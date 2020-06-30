"""
***************************************************************************
   WorkflowProvider.py
-------------------------------------
    Copyright (C) 2014 TIGER-NET (www.tiger-net.org)

***************************************************************************
* This plugin is part of the Water Observation Information System (WOIS)  *
* developed under the TIGER-NET project funded by the European Space      *
* Agency as part of the long-term TIGER initiative aiming at promoting    *
* the use of Earth Observation (EO) for improved Integrated Water         *
* Resources Management (IWRM) in Africa.                                  *
*                                                                         *
* WOIS is a free software i.e. you can redistribute it and/or modify      *
* it under the terms of the GNU General Public License as published       *
* by the Free Software Foundation, either version 3 of the License,       *
* or (at your option) any later version.                                  *
*                                                                         *
* WOIS is distributed in the hope that it will be useful, but WITHOUT ANY *
* WARRANTY; without even the implied warranty of MERCHANTABILITY or       *
* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   *
* for more details.                                                       *
*                                                                         *
* You should have received a copy of the GNU General Public License along *
* with this program.  If not, see <http://www.gnu.org/licenses/>.         *
***************************************************************************
"""

import io
import os
import json
from qgis.utils import iface
from qgis.core import QgsApplication
from processing.core.ProcessingConfig import ProcessingConfig, Setting
from processing.gui.ProviderActions import ProviderActions, ProviderContextMenuActions
from processing_workflow.WorkflowProviderBase import WorkflowProviderBase
from processing_workflow.WorkflowCollection import WorkflowCollection
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.CreateNewWorkflowAction import CreateNewWorkflowAction
from processing_workflow.CreateEditCollectionAction import CreateEditCollectionAction
from processing_workflow.WrongWorkflowException import WrongWorkflowException


class WorkflowProvider(WorkflowProviderBase):

    def __init__(self):

        WorkflowProviderBase.__init__(self)

        # Set constant properties
        self.description = "Processing Workflows (Step by step guidance)"
        self.iconPath = WorkflowUtils.workflowIcon()
        self._name = "workflow"

        self.actions += [CreateNewWorkflowAction(), CreateEditCollectionAction(self)]
        self.collections = []
        self.collectionListeners = []

        # The activate workflow provider settings
        ProcessingConfig.settingIcons[self.longName()] = self.icon()
        ProcessingConfig.addSetting(Setting(self.longName(),
                                            WorkflowUtils.WORKFLOW_FOLDER,
                                            self.tr("Workflows' folder"),
                                            WorkflowUtils.workflowPath()))
        ProcessingConfig.addSetting(Setting(self.longName(),
                                            self.getTaskbarButtonSetting(),
                                            self.tr("Show workflow button on taskbar"),
                                            True))
        ProviderActions.registerProviderActions(self, self.actions)
        ProviderContextMenuActions.registerProviderContextMenuActions(self.contextMenuActions)
        self._addToolbarIcon()

    def unload(self):
        for collection in self.collections:
            QgsApplication.processingRegistry().removeProvider(collection.id())
        self.collections = []
        self.collectionListeners = []
        WorkflowProviderBase.unload(self)
        ProcessingConfig.removeSetting(WorkflowUtils.WORKFLOW_FOLDER)
        ProcessingConfig.removeSetting(self.getTaskbarButtonSetting())
        # Remove toolbar button
        iface.removeToolBarIcon(self.action)

    # Load all the workflows saved in the workflow folder
    def createAlgsList(self):
        self.preloadedAlgs = []
        folder = WorkflowUtils.workflowPath()
        for root, _, files in os.walk(folder):
            # Load collections if they are not already loaded
            if os.path.isfile(os.path.join(root, "collection.conf")):
                try:
                    try:
                        with io.open(os.path.join(root, "collection.conf"), encoding="utf-8-sig") as f:
                            workflowCollectionSettings = json.load(f)
                        workflowCollectionName = workflowCollectionSettings["name"]
                    except:
                        continue
                    collectionAlreadyExists = False
                    for collection in self.collections:
                        if collection.name() == workflowCollectionName:
                            collectionAlreadyExists = True
                            break
                    if not collectionAlreadyExists:
                        workflowCollection = WorkflowCollection(
                                iface, os.path.join(root, "collection.conf"), self)
                        self.addCollection(workflowCollection)
                except WrongWorkflowException:
                    # A warning message was already printed in WorkflowCollection constructor so
                    # nothing to do here
                    pass

            else:
                # Load workflows which do not belong to any collection
                for descriptionFile in files:
                    if descriptionFile.endswith(".workflow"):
                        self.loadWorkflow(os.path.join(root, descriptionFile))

        return self.preloadedAlgs

    def addCollection(self, workflowCollection):
        self.collections.append(workflowCollection)
        WorkflowUtils.addWorkflowCollectionName(workflowCollection.id())
        QgsApplication.processingRegistry().addProvider(workflowCollection)
