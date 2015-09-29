import json
import os
import glob
from PyQt4.QtGui import QIcon, QAction
from PyQt4.QtCore import QObject, SIGNAL
from qgis.gui import QgsMessageBar
from processing.core.ProcessingLog import ProcessingLog
from processing.core.ProcessingConfig import ProcessingConfig, Setting
from processing_workflow.WorkflowProviderBase import WorkflowProviderBase
from processing_workflow.WrongWorkflowException import WrongWorkflowException

class WorkflowCollection(WorkflowProviderBase):
    
    def __init__(self, iface, descriptionFile, workflowProvider):
        
        self.iface = iface
        
        # Read properties from configuration file
        self.descriptionFile = descriptionFile
        self.baseDir = os.path.dirname(descriptionFile)
        self.processDescriptionFile()
        
        WorkflowProviderBase.__init__(self, iface)
        
        self.workflowProvider = workflowProvider
        
    def unload(self):
        WorkflowProviderBase.unload(self)
        self.iface.removeToolBarIcon(self.action)    
    
    def initializeSettings(self):
        # The activate collection setting is in the Workflow provider settings group
        name = self.getActivateSetting()
        ProcessingConfig.addSetting(Setting(self.workflowProvider.getDescription(), name, self.tr('Activate '+self.getName()), self.activate))
    
    # Read the JSON description file    
    def processDescriptionFile(self):
        with open(self.descriptionFile) as f:
            try:    
                settings = json.load(f)
                self.description = settings["description"]
                self.name = settings["name"]
                self.icon = os.path.join(self.baseDir, settings["icon"])
                self.aboutHTML = (' ').join(settings["aboutHTML"])
            except ValueError:
                msg = self.tr("Workflow collection %s could not be loaded due to invalid JSON collection.conf file" % (self.baseDir))
                self.iface.messageBar().pushMessage(self.tr("Warning"), msg, QgsMessageBar.WARNING, 3)
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, msg)
                raise WrongWorkflowException
            except KeyError, e:
                msg = self.tr("Workflow collection %s could not be loaded due to missing %s field in JSON collection.conf file" % (self.baseDir, str(e)))
                self.iface.messageBar().pushMessage(self.tr("Warning"), msg, QgsMessageBar.WARNING, 3)
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, msg)
                raise WrongWorkflowException
       
    # Load all the workflows saved in the workflow folder    
    def createAlgsList(self):
        self.preloadedAlgs = []
        for descriptionFile in glob.glob(os.path.join(self.baseDir, "*.workflow")):
            self.loadWorkflow(descriptionFile)
