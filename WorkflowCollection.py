import json
import os
import glob
from PyQt4.QtGui import QIcon, QAction
from PyQt4.QtCore import QObject, SIGNAL
from processing.core.ProcessingConfig import ProcessingConfig, Setting
from processing_workflow.WorkflowProviderBase import WorkflowProviderBase

class WorkflowCollection(WorkflowProviderBase):
    
    def __init__(self, iface, descriptionFile, workflowProvider):
        
        self.descriptionFile = descriptionFile
        self.baseDir = os.path.dirname(descriptionFile)
        self.processDescriptionFile()
        
        self.algs = []
        
        WorkflowProviderBase.__init__(self, iface)
        self.activate = False
        
        self.workflowProvider = workflowProvider
        
    
    def unload(self):
        WorkflowProviderBase.unload(self)
        self.iface.removeToolBarIcon(self.action)    
    
    def initializeSettings(self):
        # The activate collection setting is in the Workflow provider settings group
        name = 'ACTIVATE_' + self.getName().upper().replace(' ', '_')
        ProcessingConfig.settingIcons[name] = self.getIcon()
        ProcessingConfig.addSetting(Setting(self.workflowProvider.getDescription(), name, self.tr('Activate '+self.getName()), self.activate))
    
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
