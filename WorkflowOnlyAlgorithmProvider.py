
from qgis.core import QgsProcessingProvider
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.WorkflowInstructionsAlgorithm import WorkflowInstructionsAlgorithm

# A basic provider for algorithms that can only be used within workflows.
# Currently it only includes the workflow instructions algorithm.


class WorkflowOnlyAlgorithmProvider(QgsProcessingProvider):

    def __init__(self):
        QgsProcessingProvider.__init__(self)

    def name(self):
        return 'workflowtools'

    def longName(self):
        return self.tr('Workflow-only tools')

    def icon(self):
        return WorkflowUtils.workflowIcon()

    def id(self):
        return "workflowtools"

    def helpId(self):
        return "workflowtools"

    def load(self):
        self.loadAlgorithms()
        return True

    def unload(self):
        QgsProcessingProvider.unload(self)

    def loadAlgorithms(self):
        self.algs = [WorkflowInstructionsAlgorithm()]
        for alg in self.algs:
            alg.provider = self
            self.addAlgorithm(alg)
