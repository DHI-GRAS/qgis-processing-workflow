from processing.gui.ToolboxAction import ToolboxAction
from processing_workflow.CollectionCreatorDialog import CollectionCreatorDialog
import os
from PyQt4 import QtGui

#import traceback

class CreateNewCollectionAction(ToolboxAction):
    def __init__(self):
        self.name = "Create new collection"
        self.group = "Tools"
        
    def getIcon(self):
        return QtGui.QIcon(os.path.dirname(__file__) + "/images/icon.png")
    
    def execute(self):
        dlg = CollectionCreatorDialog(None)
        dlg.exec_()
        if dlg.update:
            self.toolbox.updateProvider('workflow')

            