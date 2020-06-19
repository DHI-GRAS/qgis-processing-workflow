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

from builtins import str
from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtCore import QCoreApplication
from qgis.utils import iface
from qgis.core import QgsProcessingProvider, QgsMessageLog, Qgis
from processing.core.ProcessingConfig import ProcessingConfig, settingsWatcher
from processing_workflow.EditWorkflowAction import EditWorkflowAction
from processing_workflow.DeleteWorkflowAction import DeleteWorkflowAction
from processing_workflow.Workflow import Workflow
from processing_workflow.WorkflowListDialog import WorkflowListDialog
from processing_workflow.WrongWorkflowException import WrongWorkflowException


class WorkflowProviderBase(QgsProcessingProvider):

    def __init__(self, activate=False):
        QgsProcessingProvider.__init__(self)

        self.activate = activate
        self.algs = []
        self.actions = []

        self.descriptionFile = ""
        self.baseDir = ""
        self.description = ""
        self._name = ""
        self.iconPath = ""
        self.aboutHTML = ""
        self.css = ""

        # Right click button actions
        self.contextMenuActions = [EditWorkflowAction(), DeleteWorkflowAction()]

        settingsWatcher.settingsChanged.connect(self.addRemoveTaskbarButton)

    def unload(self):
        QgsProcessingProvider.unload(self)

    def _addToolbarIcon(self):
        # Create action that will display workflow list dialog when toolbar button is clicked
        self.action = QAction(self.icon(), self.longName(), iface.mainWindow())
        self.action.triggered.connect(self.displayWorkflowListDialog)

    # Load all the workflows saved in the workflow folder
    def createAlgsList(self):
        return []

    def loadWorkflow(self, workflowFilePath):
        try:
            workflow = Workflow()
            workflow.openWorkflow(workflowFilePath)
            if workflow.name().strip() != "":
                self.preloadedAlgs.append(workflow)
            else:
                QgsMessageLog.logMessage(
                        self.tr("Could not open Workflow algorithm: " + workflowFilePath),
                        self.tr("Processing"),
                        Qgis.Critical)
        except WrongWorkflowException as e:
            QgsMessageLog.logMessage(
                    self.tr("Could not open Workflow algorithm "+workflowFilePath+". "+e.msg),
                    self.tr("Processing"),
                    Qgis.Critical)
        except Exception as e:
            QgsMessageLog.logMessage(
                    self.tr("Could not open Workflow algorithm: " + workflowFilePath +
                            ". Unknown exception: "+str(e)+"\n"),
                    self.tr("Processing"),
                    Qgis.Critical)

    def longName(self):
        return self.description

    def name(self):
        return self._name

    def id(self):
        return "processing_workflow"

    def helpId(self):
        return "processing_workflow"

    def icon(self):
        return QIcon(self.iconPath)

    def getActivateSetting(self):
        return 'ACTIVATE_' + self.name().upper().replace(' ', '_')

    def getTaskbarButtonSetting(self):
        return 'TASKBAR_BUTTON_' + self.name().upper().replace(' ', '_')

    def addRemoveTaskbarButton(self):
        name = self.getActivateSetting()
        taskbar = self.getTaskbarButtonSetting()
        if self.isActive() and ProcessingConfig.getSetting(taskbar):
            # Add toolbar button
            iface.addToolBarIcon(self.action)
        else:
            # Remove toolbar button
            iface.removeToolBarIcon(self.action)

    def load(self):
        QgsProcessingProvider.load(self)
        ProcessingConfig.readSettings()
        self.addRemoveTaskbarButton()
        self.loadAlgorithms()
        return True

    def loadAlgorithms(self):
        algs = self.createAlgsList()
        for a in algs:
            self.addAlgorithm(a)

    # display a dialog listing all the workflows
    def displayWorkflowListDialog(self):
        dlg = WorkflowListDialog(self)
        dlg.show()
        dlg.exec_()

    def tr(self, string, context=''):
        if context == '':
            context = 'WorkflowProvider'
        return QCoreApplication.translate(context, string)