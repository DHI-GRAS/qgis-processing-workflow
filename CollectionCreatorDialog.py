import io
import json
import os
import shutil
from qgis.PyQt import uic
from qgis.PyQt.QtWidgets import QFileDialog
from qgis.core import QgsApplication
from processing_workflow.WorkflowCollection import WorkflowCollection
from processing_workflow.WorkflowUtils import WorkflowUtils

pluginPath = os.path.dirname(__file__)
WIDGET, BASE = uic.loadUiType(os.path.join(pluginPath, 'ui', 'CollectionDialog.ui'))


class CollectionCreatorDialog(WIDGET, BASE):
    def __init__(self):
        self.confFile = ""
        self.basedir = WorkflowUtils.workflowPath()
        super(CollectionCreatorDialog, self).__init__()
        self.setupUi(self)
        self.folderSelected = 0
        self.iconSelected = 0
        self.pushButton_folder.clicked.connect(self.selectFolder)
        self.pushButton_icon.clicked.connect(self.selectIcon)
        self.pushButton_css.clicked.connect(self.selectCss)
        self.lineEdit_icon.editingFinished.connect(self.checkIcon)
        self.pushButton_cancel.clicked.connect(self.closeWindow)
        self.pushButton_save.clicked.connect(self.createCollection)

    def selectFolder(self):
        self.lineEdit_folder.setText(QFileDialog.getExistingDirectory(self,
                                                                      self.tr("Select a folder"),
                                                                      self.basedir))
        self.checkFolder()
        self.folderSelected = 1
        self.activateButton()

    def selectIcon(self):
        filename = QFileDialog.getOpenFileName(self,
                                               self.tr("Select image"),
                                               self.basedir,
                                               self.tr("Image Files(*.png *.jpg *.bmp)"))[0]
        self.lineEdit_icon.setText(filename)
        self.checkIcon()
        self.iconSelected = 1
        self.activateButton()

    def selectCss(self):
        filename = QFileDialog.getOpenFileName(self,
                                               self.tr("Select CSS file"),
                                               self.basedir,
                                               self.tr("CSS Files(*.css *.CSS)"))[0]
        self.lineEdit_css.setText(filename)
        self.activateButton()

    def closeWindow(self):
        self.close()

    def checkFolder(self):
        confFile = os.path.join(self.lineEdit_folder.text(), 'collection.conf')
        if os.path.isfile(confFile):
            collection = WorkflowCollection(None, confFile, None)
            self.lineEdit_desc.setText(collection.description)
            self.lineEdit_name.setText(collection.name())
            self.lineEdit_icon.setText(collection.iconPath)
            self.lineEdit_css.setText(collection.css)
            self.textEdit_about.setText(collection.aboutHTML)
            self.checkIcon()
        else:
            self.lineEdit_desc.setText('')
            self.lineEdit_name.setText('')
            self.lineEdit_icon.setText('')
            self.lineEdit_css.setText('')
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

    def copyFile(self, original):
        _, tail = os.path.split(original)
        copy = os.path.join(self.lineEdit_folder.text(),  tail)
        if os.path.realpath(original) != os.path.realpath(copy) and os.path.isfile(original):
            shutil.copyfile(original, copy)
        return tail

    def createCollection(self):
        self.confFile = os.path.join(self.lineEdit_folder.text(), 'collection.conf')
        confOptions = {}
        confOptions["description"] = self.lineEdit_desc.text()
        confOptions["name"] = self.lineEdit_name.text()
        confOptions["icon"] = self.copyFile(self.lineEdit_icon.text())
        confOptions["css"] = self.copyFile(self.lineEdit_css.text())
        confOptions["aboutHTML"] = self.textEdit_about.toPlainText()
        with io.open(self.confFile, 'w', encoding="utf-8") as fp:
            fp.write(json.dumps(confOptions, indent=4, separators=(',', ':'), ensure_ascii=False))
        for provider in QgsApplication.processingRegistry().providers():
            try:
                if os.path.realpath(provider.descriptionFile) == os.path.realpath(self.confFile):
                    provider.unload()
                    provider.load()
            except AttributeError:
                pass
        self.closeWindow()
