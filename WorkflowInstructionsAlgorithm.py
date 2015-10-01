from processing.core.GeoAlgorithm import GeoAlgorithm
from processing.gui.AlgorithmDialog import AlgorithmDialog

# An empty GeoAlgorithm to be used as a dummy when wanting to 
# display an purely instruction step in a workflow.

class WorkflowInstructionsAlgorithm(GeoAlgorithm):

    def defineCharacteristics(self):
        self.showInModeler = False
        self.showInToolbox = False
        self.name = self.tr('Workflow instructions')
        self.group = self.tr('Workflow-only tools')
        
    def processAlgorithm(self, progress):
        pass
    
    def getCustomParametersDialog(self):
            return WorkflowInstructionsAlgorithmParametersDialog(self)
        
class WorkflowInstructionsAlgorithmParametersDialog(AlgorithmDialog):


    def setupUi(self, dialog):
        AlgorithmDialog.setupUi(self, dialog)
        self.resize(1, 1)
        self.executed = True
        