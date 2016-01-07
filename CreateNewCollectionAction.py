from qgis.utils import iface
from processing.gui.ToolboxAction import ToolboxAction
from processing_workflow.WorkflowCollection import WorkflowCollection
from processing_workflow.CollectionCreatorDialog import CollectionCreatorDialog
import os
from PyQt4 import QtGui

#import traceback

class CreateNewCollectionAction(ToolboxAction):
    def __init__(self, workflowProvider):
        self.name = "Create new collection"
        self.group = "Tools"
        self.workflowProvider = workflowProvider
        
    def getIcon(self):
        return QtGui.QIcon(os.path.dirname(__file__) + "/images/icon.png")
    
    def execute(self):
        dlg = CollectionCreatorDialog(None)
        dlg.exec_()
        if dlg.update and dlg.confFile:
            # Load the new collection, activate it and update Processing Toolbox
            workflowCollection = WorkflowCollection(iface, dlg.confFile, self.workflowProvider, activate = True)
            self.workflowProvider.addCollection(workflowCollection, updateToolbox = True)

            