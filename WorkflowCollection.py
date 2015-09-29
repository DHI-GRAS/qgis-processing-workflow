import json
import os
import glob
from PyQt4.QtGui import QIcon, QAction
from PyQt4.QtCore import QObject, SIGNAL
from processing.core.ProcessingConfig import ProcessingConfig
from processing.core.AlgorithmProvider import AlgorithmProvider
from processing.core.ProcessingLog import ProcessingLog
from processing_workflow.Workflow import Workflow
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.WorkflowListDialog import WorkflowListDialog
from processing_workflow.WrongWorkflowException import WrongWorkflowException

class WorkflowCollection(AlgorithmProvider):
    
    def __init__(self, iface, descriptionFile):
        
        self.descriptionFile = descriptionFile
        self.baseDir = os.path.dirname(descriptionFile)
        self.processDescriptionFile()
        
        self.algs = []
        
        AlgorithmProvider.__init__(self)
        self.activate = True
        
        self.iface = iface
    
    # Read the JSON description file    
    def processDescriptionFile(self):
        with open(self.descriptionFile) as f:
            settings = json.load(f)
            self.description = settings["description"]
            self.name = settings["name"]
            self.icon = settings["icon"]
            self.aboutHTML = (' ').join(settings["aboutHTML"])
            
    def getDescription(self):
        return self.description

    def getName(self):
        return self.name

    def getIcon(self):
        return QIcon(os.path.join(self.baseDir, self.icon))
    
    def loadAlgorithms(self):
        AlgorithmProvider.loadAlgorithms(self)
       
    # Load all the workflows saved in the workflow folder    
    def createAlgsList(self):
        self.preloadedAlgs = []
        for descriptionFile in glob.glob(os.path.join(self.baseDir, "*.workflow")):
            try:
                workflow = Workflow()
                fullpath = os.path.join(self.baseDir,descriptionFile)
                workflow.openWorkflow(fullpath)
                if workflow.name.strip() != "":
                    workflow.provider = self
                    self.preloadedAlgs.append(workflow)
                else:
                    ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm: " + descriptionFile)
            except WrongWorkflowException,e:
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm " + descriptionFile + ". "+e.msg)
            except Exception,e:
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, "Could not open Workflow algorithm: " + descriptionFile + ". Unknown exception: "+unicode(e)+"\n")

    def _loadAlgorithms(self):
        self.createAlgsList()
        self.algs = self.preloadedAlgs
        
            