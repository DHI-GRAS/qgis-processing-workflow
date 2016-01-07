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

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from processing.core.ProcessingConfig import ProcessingConfig
from processing.core.AlgorithmProvider import AlgorithmProvider
from processing.core.ProcessingLog import ProcessingLog
from processing_workflow.EditWorkflowAction import EditWorkflowAction
from processing_workflow.DeleteWorkflowAction import DeleteWorkflowAction
from processing_workflow.Workflow import Workflow
from processing_workflow.WorkflowListDialog import WorkflowListDialog
from processing_workflow.WrongWorkflowException import WrongWorkflowException

class WorkflowProviderBase(AlgorithmProvider):

    def __init__(self, iface, activate = False):
        AlgorithmProvider.__init__(self)
        
        self.activate = activate
        self.algs = []
        
        # Create action that will display workflow list dialog when toolbar button is clicked
        self.action = QAction(self.getIcon(), self.getDescription(), self.iface.mainWindow())
        QObject.connect(self.action, SIGNAL("triggered()"), self.displayWorkflowListDialog)
        
        # Right click button actions
        self.contextMenuActions = [EditWorkflowAction(self), DeleteWorkflowAction(self)]
        
    def unload(self):
        AlgorithmProvider.unload(self)
    
    # Load all the workflows saved in the workflow folder    
    def createAlgsList(self):
        pass
                        
    def loadWorkflow(self, workflowFilePath):
        try:
            workflow = Workflow(self)
            workflow.openWorkflow(workflowFilePath)
            if workflow.name.strip() != "":
                workflow.provider = self
                self.preloadedAlgs.append(workflow)
            else:
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm: " + workflowFilePath)
        except WrongWorkflowException,e:
            ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm " + workflowFilePath + ". "+e.msg)
        except Exception,e:
            ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm: " + workflowFilePath + ". Unknown exception: "+unicode(e)+"\n")

                    
    def getDescription(self):
        return self.description

    def getName(self):
        return self.name

    def getIcon(self):
        return QIcon(self.icon)

    def getActivateSetting(self):
        return 'ACTIVATE_' + self.getName().upper().replace(' ', '_')
    
    def getTaskbarButtonSetting(self):
        return 'TASKBAR_BUTTON_' + self.getName().upper().replace(' ', '_')

    def loadAlgorithms(self):
        AlgorithmProvider.loadAlgorithms(self)
        name = self.getActivateSetting()
        taskbar = self.getTaskbarButtonSetting()
        if not (ProcessingConfig.getSetting(name) and ProcessingConfig.getSetting(taskbar)):
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