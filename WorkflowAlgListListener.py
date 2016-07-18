from processing.core.Processing import Processing

class WorkflowAlgListListener():
    def __init__(self, workflowProvider):
        self.workflowProvider = workflowProvider
        self.recursiveCall = False
            
    def algsListHasChanged(self):
        try:
            # QGIS 2.16 (and up?) Processing implementation
            from processing.core.alglist import algList
            algList.reloadProvider(self.workflowProvider.getName())
            for collection in self.workflowProvider.collections:
                algList.reloadProvider(collection.getName())
        
        except ImportError:
            # QGIS 2.14 Processing implementation
            if self.recursiveCall:
                return
            
            # Load algorithms outside any collections
            self.workflowProvider.createAlgsList()
            algs = {}
            for alg in self.workflowProvider.preloadedAlgs:
                algs[alg.commandLineName()] = alg
            Processing.algs[self.workflowProvider.getName()] = algs
            
            # Load algorithms in collection
            for collection in self.workflowProvider.collections:
                collection.createAlgsList()
                algs = {}
                for alg in collection.preloadedAlgs:
                    algs[alg.commandLineName()] = alg
                Processing.algs[collection.getName()] = algs
            
            
            # fireAlgsListHasChanged to update the Toolbox GUI but make sure that the 
            # call doesn't lead to infinite loop
            self.recursiveCall = True
            Processing.fireAlgsListHasChanged()
            self.recursiveCall = False