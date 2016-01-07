import json
from PyQt4 import uic
from PyQt4.QtGui import QFileDialog
from qgis.utils import iface
import os, shutil
from processing_workflow.WorkflowCollection import WorkflowCollection
from processing_workflow.WorkflowUtils import WorkflowUtils

pluginPath = os.path.dirname(__file__)
WIDGET, BASE = uic.loadUiType(os.path.join(pluginPath, 'ui', 'CollectionDialog.ui'))

class CollectionCreatorDialog(WIDGET, BASE):
    def __init__(self, alg):
        self.update = False
        self.confFile = ""
        self.basedir = WorkflowUtils.workflowPath()
        super(CollectionCreatorDialog, self).__init__(iface.mainWindow())
        self.setupUi(self)
        self.folderSelected = 0
        self.iconSelected = 0
        self.toolButton_folder.clicked.connect(self.selectFolder)
        self.toolButton_icon.clicked.connect(self.selectIcon)
        self.lineEdit_icon.editingFinished.connect(self.checkIcon)
        self.pushButton_cancel.clicked.connect(self.closeWindow)
        self.pushButton_save.clicked.connect(self.createCollection)
        
    def selectFolder(self):
        self.lineEdit_folder.setText(QFileDialog.getExistingDirectory(self,
                    "Select a folder", self.basedir))
        self.checkFolder()
        self.folderSelected = 1
        self.activateButton()
    
    def selectIcon(self):
        self.lineEdit_icon.setText(QFileDialog.getOpenFileName(self,
                    "Select image", self.basedir, 'Image Files(*.png *.jpg *.bmp)'))
        self.checkIcon()
        self.iconSelected = 1
        self.activateButton()

    def closeWindow(self):
        self.close()
    
    def checkFolder(self):
        #if os.path.exists(self.lineEdit_folder.text()):# check not needed when user not allowed to edit line.
        confFile = os.path.join(self.lineEdit_folder.text(), 'collection.conf')
        if os.path.isfile(confFile):
            collection = WorkflowCollection(None, confFile, None)
            self.lineEdit_desc.setText(collection.description)
            self.lineEdit_name.setText(collection.name)
            self.lineEdit_icon.setText(collection.icon)
            self.textEdit_about.setText(collection.aboutHTML)
            self.checkIcon()
        else:
            self.lineEdit_desc.setText('')
            self.lineEdit_name.setText('')
            self.lineEdit_icon.setText('')
            self.textEdit_about.setText('')
    
    def checkIcon(self):
        if os.path.isfile(self.lineEdit_icon.text()):
            self.lineEdit_icon.setStyleSheet('color: rgb(0, 0, 0);')
            self.iconSelected = 1
        else:
            self.lineEdit_icon.setStyleSheet('color: rgb(255, 0, 0);')
            self.iconSelected = 0
        self.activateButton()
            
    def activateButton(self):
        if self.folderSelected == 1 and self.iconSelected == 1:
            self.pushButton_save.setEnabled(True)
        else:
            self.pushButton_save.setEnabled(False)
    
    def copyIcon(self):
        iconFile = self.lineEdit_icon.text()
        _,tail = os.path.split(iconFile)
        iconFileCopy = os.path.join(self.lineEdit_folder.text(),tail)
        if os.path.isfile(iconFileCopy) == False:
            shutil.copyfile(iconFile, iconFileCopy)
        return tail
    
    def createCollection(self):        
        self.confFile = os.path.join(self.lineEdit_folder.text(),'collection.conf')
        icon = self.copyIcon()
        confOptions = {}
        confOptions["description"] = self.lineEdit_desc.text()
        confOptions["name"] = self.lineEdit_name.text()
        confOptions["icon"] = icon
        confOptions["aboutHTML"] = self.textEdit_about.toHtml()
        with open(self.confFile, 'w') as f1:
            json.dump(confOptions, f1, indent=4, separators=(',',':'))
        self.update = True
        self.closeWindow()
