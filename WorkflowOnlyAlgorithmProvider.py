
from processing.core.AlgorithmProvider import AlgorithmProvider
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.WorkflowInstructionsAlgorithm import WorkflowInstructionsAlgorithm

# A basic provider for algorithms that can only be used within workflows.
# Currently it only includes the workflow instructions algorithm.


class WorkflowOnlyAlgorithmProvider(AlgorithmProvider):

    def __init__(self):
        AlgorithmProvider.__init__(self)

    def getName(self):
        return 'workflowtools'

    def getDescription(self):
        return self.tr('Workflow-only tools')

    def getIcon(self):
        return WorkflowUtils.workflowIcon()

    def _loadAlgorithms(self):
        self.algs = [WorkflowInstructionsAlgorithm()]
        for alg in self.algs:
            alg.provider = self
