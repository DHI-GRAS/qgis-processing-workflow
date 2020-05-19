from builtins import object

class WorkflowAlgListListener(object):
    def __init__(self, workflowProvider, workflowOnlyAlgorithmProvider):
        self.workflowProvider = workflowProvider
        self.workflowOnlyAlgorithmProvider = workflowOnlyAlgorithmProvider
        self.recursiveCall = False

    def algsListHasChanged(self, providerId):
        selfIds = [self.workflowProvider.id(), self.workflowOnlyAlgorithmProvider.id()]
        if providerId not in selfIds:
            self.workflowProvider.refreshAlgorithms()
