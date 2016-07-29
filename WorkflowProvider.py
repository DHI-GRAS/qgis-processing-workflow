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

import os
import json
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.utils import iface
from processing.core.ProcessingConfig import ProcessingConfig, Setting
from processing.core.AlgorithmProvider import AlgorithmProvider
from processing.core.Processing import Processing
from processing_workflow.WorkflowProviderBase import WorkflowProviderBase
from processing_workflow.WorkflowCollection import WorkflowCollection
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.CreateNewWorkflowAction import CreateNewWorkflowAction
from processing_workflow.CreateNewCollectionAction import CreateNewCollectionAction
from processing_workflow.WrongWorkflowException import WrongWorkflowException


class WorkflowProvider(WorkflowProviderBase):

    def __init__(self):
        
        # Set constant properties
        self.description = "Processing Workflows (Step by step guidance)"
        self.icon = WorkflowUtils.workflowIcon()
        self.name = "workflow"
        
        WorkflowProviderBase.__init__(self)
        self.actions += [CreateNewWorkflowAction(self), CreateNewCollectionAction(self)]
        self.collections = []
        self.collectionListeners = []
        

    def initializeSettings(self):
        AlgorithmProvider.initializeSettings(self)
        ProcessingConfig.addSetting(Setting(self.getDescription(), WorkflowUtils.WORKFLOW_FOLDER, "Workflows' folder", WorkflowUtils.workflowPath()))
        ProcessingConfig.addSetting(Setting(self.getDescription(), self.getTaskbarButtonSetting(), "Show workflow button on taskbar", True))

    def unload(self):
        for collection in self.collections:
            Processing.removeProvider(collection)
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
                        with open(os.path.join(root, "collection.conf")) as f:
                            workflowCollectionSettings = json.load(f)
                        workflowCollectionName = workflowCollectionSettings["name"]
                    except:
                        continue
                    collectionAlreadyExists = False
                    for collection in self.collections:
                        if collection.getName() == workflowCollectionName:
                            collectionAlreadyExists = True
                            break
                    if not collectionAlreadyExists:
                            workflowCollection = WorkflowCollection(iface, os.path.join(root, "collection.conf"), self)
                            self.addCollection(workflowCollection, False)
                except WrongWorkflowException:
                    # A warning message was already printed in WorkflowCollection constructor so nothing to do here 
                    pass
                
            else:
                # Load workflows which do not belong to any collection
                for descriptionFile in files:
                    if descriptionFile.endswith(".workflow"):
                        self.loadWorkflow(os.path.join(root,descriptionFile))
                        
    def addCollection(self, workflowCollection, updateToolbox):
        self.collections.append(workflowCollection)
        Processing.addProvider(workflowCollection, updateToolbox)
        WorkflowUtils.addWorkflowCollectionName(workflowCollection.getName())
                        
