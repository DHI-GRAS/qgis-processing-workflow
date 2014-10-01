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
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from processing.core.ProcessingConfig import ProcessingConfig, Setting
from processing.core.AlgorithmProvider import AlgorithmProvider
from processing.core.ProcessingLog import ProcessingLog
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.CreateNewWorkflowAction import CreateNewWorkflowAction
from processing_workflow.EditWorkflowAction import EditWorkflowAction
from processing_workflow.DeleteWorkflowAction import DeleteWorkflowAction
from processing_workflow.Workflow import Workflow
from processing_workflow.WorkflowListDialog import WorkflowListDialog
from processing_workflow.WrongWorkflowException import WrongWorkflowException

class WorkflowProvider(AlgorithmProvider):

    def __init__(self, iface):
        AlgorithmProvider.__init__(self)
        self.activate = False
        self.actions.append(CreateNewWorkflowAction())
        self.contextMenuActions = [EditWorkflowAction(), DeleteWorkflowAction()]
        self.iface = iface
        
        # Create action that will display workflow list dialog when toolbar button is clicked
        self.action = QAction(QIcon(self.getIcon()), \
                                  "WOIS Workflows", self.iface.mainWindow())
        QObject.connect(self.action, SIGNAL("triggered()"), self.displayWorkflowListDialog)


    def initializeSettings(self):
        AlgorithmProvider.initializeSettings(self)
        ProcessingConfig.addSetting(Setting(self.getDescription(), WorkflowUtils.WORKFLOW_FOLDER, "Workflow algorithms folder", WorkflowUtils.workflowPath()))

    def unload(self):
        AlgorithmProvider.unload(self)
        ProcessingConfig.removeSetting(WorkflowUtils.WORKFLOW_FOLDER)
        # Remove toolbar button
        self.iface.removeToolBarIcon(self.action)
    
    # Load all the workflows saved in the workflow folder    
    def createAlgsList(self):
        self.preloadedAlgs = []
        folder = WorkflowUtils.workflowPath()
        for descriptionFile in os.listdir(folder):
            if descriptionFile.endswith(".workflow"):
                try:
                    workflow = Workflow()
                    fullpath = os.path.join(folder,descriptionFile)
                    workflow.openWorkflow(fullpath)
                    if workflow.name.strip() != "":
                        self.preloadedAlgs.append(workflow)
                    else:
                        ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm: " + descriptionFile)
                except WrongWorkflowException,e:
                    ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm " + descriptionFile + ". "+e.msg)
                except Exception,e:
                    ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm: " + descriptionFile + ". Unknown exception: "+unicode(e)+"\n")

                    
    def getDescription(self):
        return "WOIS Workflows (Step by step guidance)"

    def getName(self):
        return "workflow"

    def getIcon(self):
        return QIcon(os.path.dirname(__file__) + "/images/icon.png")

    def loadAlgorithms(self):
        AlgorithmProvider.loadAlgorithms(self)
        name = 'ACTIVATE_' + self.getName().upper().replace(' ', '_')
        if not ProcessingConfig.getSetting(name):
            # Remove toolbar button
            self.iface.removeToolBarIcon(self.action)
        else:
            # Add toolbar button
            self.iface.addToolBarIcon(self.action)  

    def _loadAlgorithms(self):
        self.createAlgsList()
        self.algs = self.preloadedAlgs
        
    # display a dialog listing all the workflows
    def displayWorkflowListDialog(self):
        dlg = WorkflowListDialog(self)
        dlg.show()
        dlg.exec_()