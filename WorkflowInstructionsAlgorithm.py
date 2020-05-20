from qgis.core import QgsProcessingAlgorithm
from processing.gui.AlgorithmDialog import AlgorithmDialog

# An empty GeoAlgorithm to be used as a dummy when wanting to
# display an purely instruction step in a workflow.


class WorkflowInstructionsAlgorithm(QgsProcessingAlgorithm):

    def defineCharacteristics(self):
        self.showInModeler = False
        self.showInToolbox = False
        self._name = self.tr("Workflow instructions")
        self._group = self.tr("Workflow-only tools")
        self._groupId = "workflow_only_tools"

    def processAlgorithm(self, progress):
        pass

    def getCustomParametersDialog(self):
        return WorkflowInstructionsAlgorithmParametersDialog(self)

    def name(self):
        return self._name

    def displayName(self):
        return self._name

    def shortDescription(self):
        return self._name

    def group(self):
        return self._group

    def groupId(self):
        return self._groupId

    def flags(self):
        # TODO - maybe it's safe to background thread this?
        return super().flags() | QgsProcessingAlgorithm.FlagNoThreading | QgsProcessingAlgorithm.FlagDisplayNameIsLiteral

    def helpUrl(self, key):
        return None

    def svgIconPath(self):
        return ""


class WorkflowInstructionsAlgorithmParametersDialog(AlgorithmDialog):

    def setupUi(self, dialog):
        AlgorithmDialog.setupUi(self, dialog)
        self.resize(1, 1)
        self.executed = True
