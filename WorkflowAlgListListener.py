from builtins import object
from qgis.core import QgsApplication
from processing_workflow.WorkflowUtils import WorkflowUtils


class WorkflowAlgListListener(object):
    def __init__(self, workflowProvider, workflowOnlyAlgorithmProvider):
        self.workflowProvider = workflowProvider
        self.workflowOnlyAlgorithmProvider = workflowOnlyAlgorithmProvider
        self.recursiveCall = False

    def algsListHasChanged(self, providerId):
        selfIds = [self.workflowProvider.id(), self.workflowOnlyAlgorithmProvider.id()]
        selfIds.extend(WorkflowUtils.workflowCollectionNames)
        if providerId not in selfIds:
            for selfId in selfIds:
                selfProvider = QgsApplication.processingRegistry().providerById(selfId)
                selfProvider.refreshAlgorithms()
