import os
from qgis.PyQt.QtGui import QIcon
from qgis.utils import iface
from processing.gui.ToolboxAction import ToolboxAction
from processing_workflow.WorkflowCollection import WorkflowCollection
from processing_workflow.CollectionCreatorDialog import CollectionCreatorDialog


class CreateEditCollectionAction(ToolboxAction):
    def __init__(self, workflowProvider):
        ToolboxAction.__init__(self)
        self.name = self.tr("Create/edit collection", "CreateEditCollectionAction")
        self.workflowProvider = workflowProvider

    def getIcon(self):
        return QIcon(os.path.dirname(__file__) + "/images/icon.png")

    def execute(self):
        dlg = CollectionCreatorDialog()
        dlg.exec_()
        if dlg.update and dlg.confFile:
            # Load the new collection, activate it and update Processing Toolbox
            workflowCollection = WorkflowCollection(iface, dlg.confFile, self.workflowProvider,
                                                    activate=True)
            self.workflowProvider.addCollection(workflowCollection)
