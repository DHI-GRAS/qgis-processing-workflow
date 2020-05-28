import io
import json
import os
import glob
from qgis.gui import QgsMessageBar
from processing.core.ProcessingLog import ProcessingLog
from processing.core.ProcessingConfig import ProcessingConfig, Setting
from processing_workflow.WorkflowProviderBase import WorkflowProviderBase
from processing_workflow.WrongWorkflowException import WrongWorkflowException


class WorkflowCollection(WorkflowProviderBase):

    def __init__(self, iface, descriptionFile, workflowProvider, activate=False):

        self.iface = iface
        self.workflowProvider = workflowProvider

        # If we just want to parse the description file (e.g. when creating
        # new collection) then iface is not provided and we don't want to do
        # proper initialization
        if iface:
            WorkflowProviderBase.__init__(self, activate)
        else:
            self.css = ""

        # Read properties from configuration file
        self.descriptionFile = descriptionFile
        self.baseDir = os.path.dirname(descriptionFile)
        self.configured = self.processDescriptionFile()
        self.initializeSettings()

        if self.configured and iface:
            self._addToolbarIcon()

    def unload(self):
        WorkflowProviderBase.unload(self)
        ProcessingConfig.removeSetting(self.getTaskbarButtonSetting())
        self.iface.removeToolBarIcon(self.action)

    def initializeSettings(self):
        # The activate collection setting is in the Workflow provider settings group
        name = self.getActivateSetting()
        activateSetting = Setting(self.workflowProvider.longName(), name,
                                  self.tr('Activate %s collection') % self.name(),
                                  self.activate)
        ProcessingConfig.addSetting(activateSetting)
        # If activate is True (default is False) then save the setting properly, otherwise it will
        # be set to false when QGIS is restarted.
        if self.activate:
            activateSetting.setValue(self.activate)
            activateSetting.save()
        ProcessingConfig.addSetting(Setting(self.workflowProvider.longName(),
                                            self.getTaskbarButtonSetting(),
                                            "Show "+self.name()+" collection icon on taskbar",
                                            True))

    # Read the JSON description file
    def processDescriptionFile(self):
        with io.open(self.descriptionFile, "r", encoding="utf-8-sig") as f:
            try:
                settings = json.loads(f.read())
                self.description = settings["description"]
                self._name = settings["name"]
                self.iconPath = os.path.join(self.baseDir, settings["icon"])
                self.aboutHTML = "".join(settings["aboutHTML"])
                self.css = os.path.join(self.baseDir, settings["css"])
            except ValueError:
                msg = self.tr("Workflow collection %s could not be loaded due to invalid JSON " +
                              "collection.conf file" % (self.baseDir))
                if self.iface:
                    self.iface.messageBar().pushMessage(self.tr("Warning"), msg,
                                                        QgsMessageBar.WARNING, 3)
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, msg)
                raise WrongWorkflowException
            except KeyError as e:
                msg = self.tr("Workflow collection %s could not be fully loaded " % self.baseDir +
                              "due to missing %s field in JSON collection.conf file" % e)
                if self.iface:
                    self.iface.messageBar().pushMessage(self.tr("Warning"), msg,
                                                        QgsMessageBar.WARNING, 3)
                ProcessingLog.addToLog(ProcessingLog.LOG_ERROR, msg)
                return False
        return True

    def id(self):
        return WorkflowProviderBase.id(self)+"_"+self.name().replace(' ', '_')

    # Load all the workflows saved in the workflow folder
    def createAlgsList(self):
        self.preloadedAlgs = []
        for descriptionFile in glob.glob(os.path.join(self.baseDir, "*.workflow")):
            self.loadWorkflow(descriptionFile)
        return self.preloadedAlgs

    def load(self):
        if self.configured:
            return WorkflowProviderBase.load(self)
        else:
            return False
