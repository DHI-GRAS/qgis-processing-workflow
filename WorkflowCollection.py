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
    
    def __init__(self, iface, descriptionFile, workflowProvider, activate = False):
        
        self.iface = iface
        
        # If we just want to parse the description file (e.g. when creating
        # new collection) then iface is not provided and we don't want to do 
        # proper initialization 
        if iface:
            WorkflowProviderBase.__init__(self, activate)
        
        # Read properties from configuration file
        self.descriptionFile = descriptionFile
        self.baseDir = os.path.dirname(descriptionFile)
        self.processDescriptionFile()
        
        self.workflowProvider = workflowProvider
        
    def unload(self):
        WorkflowProviderBase.unload(self)
        ProcessingConfig.removeSetting(self.getTaskbarButtonSetting())
        self.iface.removeToolBarIcon(self.action)    
    
    def initializeSettings(self):
        # The activate collection setting is in the Workflow provider settings group
        name = self.getActivateSetting()
        activateSetting = Setting(self.workflowProvider.getDescription(), name, self.tr('Activate '+self.getName())+' collection', self.activate)
        ProcessingConfig.addSetting(activateSetting)
        # If activate is True (default is False) then save the setting properly, otherwise it will be set to false
        # when QGIS is restarted.
        if self.activate:
            activateSetting.setValue(self.activate)
            activateSetting.save()
        ProcessingConfig.addSetting(Setting(self.workflowProvider.getDescription(), self.getTaskbarButtonSetting(), "Show "+self.getName()+" collection icon on taskbar", True))
    
    # Read the JSON description file    
    def processDescriptionFile(self):
        with open(self.descriptionFile) as f:
            try:    
                settings = json.load(f)
                self.description = settings["description"]
                self.name = settings["name"]
                self.icon = os.path.join(self.baseDir, settings["icon"])
                self.aboutHTML = "".join(settings["aboutHTML"])
                self.css = os.path.join(self.baseDir, settings["css"])
            except ValueError:
                msg = self.tr("Workflow collection %s could not be loaded due to invalid JSON collection.conf file" % (self.baseDir))
                if self.iface:
                    self.iface.messageBar().pushMessage(self.tr("Warning"), msg, QgsMessageBar.WARNING, 3)
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, msg)
                raise WrongWorkflowException
            except KeyError, e:
                msg = self.tr("Workflow collection %s could not be fully loaded due to missing %s field in JSON collection.conf file" % (self.baseDir, str(e)))
                if self.iface:
                    self.iface.messageBar().pushMessage(self.tr("Warning"), msg, QgsMessageBar.WARNING, 3)
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, msg)
       
    # Load all the workflows saved in the workflow folder    
    def createAlgsList(self):
        self.preloadedAlgs = []
        for descriptionFile in glob.glob(os.path.join(self.baseDir, "*.workflow")):
            self.loadWorkflow(descriptionFile)
            
    def loadAlgorithms(self):
        self.processDescriptionFile()
        super(WorkflowCollection, self).loadAlgorithms()
