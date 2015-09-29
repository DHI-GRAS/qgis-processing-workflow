import json
import os
import glob
from PyQt4.QtGui import QIcon, QAction
from PyQt4.QtCore import QObject, SIGNAL
from processing.core.ProcessingConfig import ProcessingConfig
from processing.core.AlgorithmProvider import AlgorithmProvider
from processing.core.ProcessingLog import ProcessingLog
from processing_workflow.Workflow import Workflow
from processing_workflow.WorkflowProviderBase import WorkflowProviderBase
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.WorkflowListDialog import WorkflowListDialog
from processing_workflow.WrongWorkflowException import WrongWorkflowException

class WorkflowCollection(WorkflowProviderBase):
    
    def __init__(self, iface, descriptionFile):
        
        self.descriptionFile = descriptionFile
        self.baseDir = os.path.dirname(descriptionFile)
        self.processDescriptionFile()
        
        self.algs = []
        
        AlgorithmProvider.__init__(self)
        self.activate = True
        
        self.iface = iface
        
        # Create action that will display workflow list dialog when toolbar button is clicked
        self.action = QAction(QIcon(self.getIcon()), self.getDescription(), self.iface.mainWindow())
        QObject.connect(self.action, SIGNAL("triggered()"), self.displayWorkflowListDialog)
    
    def unload(self):
        AlgorithmProvider.unload(self)    
    
    # Read the JSON description file    
    def processDescriptionFile(self):
        with open(self.descriptionFile) as f:
            settings = json.load(f)
            self.description = settings["description"]
            self.name = settings["name"]
            self.icon = os.path.join(self.baseDir, settings["icon"])
            self.aboutHTML = (' ').join(settings["aboutHTML"])
                
       
    # Load all the workflows saved in the workflow folder    
    def createAlgsList(self):
        self.preloadedAlgs = []
        for descriptionFile in glob.glob(os.path.join(self.baseDir, "*.workflow")):
            self.loadWorkflow(descriptionFile)
    
    def loadAlgorithms(self):
        WorkflowProviderBase.loadAlgorithms(self)
        self.iface.addToolBarIcon(self.action)        