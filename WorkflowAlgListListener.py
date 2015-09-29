from processing.core.Processing import Processing

class WorkflowAlgListListener():
    def __init__(self, workflowProvider):
        self.workflowProvider = workflowProvider
        self.recursiveCall = False
            
    def algsListHasChanged(self):
        if self.recursiveCall:
            return
        self.workflowProvider.createAlgsList()
        algs = {}
        for alg in self.workflowProvider.preloadedAlgs:
            algs[alg.commandLineName()] = alg
        Processing.algs[self.workflowProvider.getName()] = algs
        
        # fireAlgsListHasChanged to update the Toolbox GUI but make sure that the 
        # call doesn't lead to infinite loop
        self.recursiveCall = True
        Processing.fireAlgsListHasChanged()
        self.recursiveCall = False