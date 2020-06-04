"""
***************************************************************************
   StepDialog.py
-------------------------------------
    Copyright (C) 2014 TIGER-NET (www.tiger-net.org)

***************************************************************************
* This plugin is part of the Water Observation Information System (WOIS)  *
* developed under the TIGER-NET project funded by the European Space      *
* Agency as part of the long-term TIGER initiative aiming at promoting    *
* the use of Earth Observation (EO) for improved Integrated Water         *
* Resources Management (IWRM) in Africa.                                  *
*                                                                         *
* WOIS is a free software i.e. you can redistribute it and/or modify      *
* it under the terms of the GNU General Public License as published       *
* by the Free Software Foundation, either version 3 of the License,       *
* or (at your option) any later version.                                  *
*                                                                         *
* WOIS is distributed in the hope that it will be useful, but WITHOUT ANY *
* WARRANTY; without even the implied warranty of MERCHANTABILITY or       *
* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   *
* for more details.                                                       *
*                                                                         *
* You should have received a copy of the GNU General Public License along *
* with this program.  If not, see <http://www.gnu.org/licenses/>.         *
***************************************************************************
"""
from __future__ import absolute_import

import os
from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import (QDialog, QGridLayout, QWidget, QTextBrowser, QTextEdit, QToolBar,
                                 QAction, QDialogButtonBox, QPushButton, QComboBox)
from qgis.PyQt.QtGui import QIcon, QTextDocument
from qgis.core import (QgsApplication,
                       QgsProcessingAlgorithm)
from processing.gui.AlgorithmDialog import AlgorithmDialog
from processing.gui.BatchAlgorithmDialog import BatchAlgorithmDialog
from processing_workflow import markdown


NORMAL_MODE = "Normal"
BATCH_MODE = "Batch"
DIRNAME = os.path.dirname(__file__)


# Dialog grouping the appropriate algorithm dialog (normal or batch mode), instructions
# box and option to change from normal to batch mode if the dialog is editable.
class StepDialog(QDialog):

    def __init__(self, alg, mainDialog, workflowBaseDir, canEdit=True, style=None):
        self.alg = alg
        self.mainDialog = mainDialog
        self.workflowBaseDir = workflowBaseDir
        self.canEdit = canEdit
        self.goForward = False
        self.goBackward = False
        self.style = style

        QDialog.__init__(self)

        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)

        # create a tab for this algorithm
        self.tabLayout = QGridLayout()

        # Create widget holding instructions text and instructions' editing
        # toolbar if in edit mode
        self.algInstructionsWidget = QWidget()
        self.algInstructionsLayout = QGridLayout()

        if not canEdit:
            self.algInstructionsText = QTextBrowser()
            self.algInstructionsText.setOpenExternalLinks(True)
            self.algInstructionsLayout.addWidget(self.algInstructionsText, 0, 0)
        else:
            self.algInstructionsText = QTextEdit()
            self.algInstructionsText.setTextInteractionFlags(QtCore.Qt.TextEditorInteraction)
            self.algInstructionsLayout.addWidget(self.algInstructionsText, 1, 0)
            # Tool bar to hold font-editing tools
            self.algInstructionsEditBar = QToolBar()
            self.algInstructionsEditBar.setIconSize(QtCore.QSize(16, 16))
            iconDir = os.path.join(os.path.dirname(__file__), "images")
            # Bold
            self.actionTextBold = QAction(
                    QIcon.fromTheme("format-text-bold",
                                    QIcon(os.path.join(iconDir, "boldA.png"))),
                                    "&Bold", self)
            self.actionTextBold.setShortcut("Ctrl+B")
            QtCore.QObject.connect(self.actionTextBold, QtCore.SIGNAL("triggered()"),
                                   self.textBold)
            self.algInstructionsEditBar.addAction(self.actionTextBold)
            # Italic
            self.actionTextItalic = QAction(
                    QIcon.fromTheme("format-text-italic",
                                    QIcon(os.path.join(iconDir, "italicA.png"))),
                                    "&Italic", self)
            self.actionTextItalic.setShortcut("Ctrl+I")
            QtCore.QObject.connect(self.actionTextItalic, QtCore.SIGNAL("triggered()"),
                                   self.textItalic)
            self.algInstructionsEditBar.addAction(self.actionTextItalic)
            # Underline
            self.actionTextUnderline = QAction(
                    QIcon.fromTheme("format-text-underline",
                                    QIcon(os.path.join(iconDir, "underlineA.png"))),
                                    "&Underline", self)
            self.actionTextUnderline.setShortcut("Ctrl+U")
            QtCore.QObject.connect(self.actionTextUnderline, QtCore.SIGNAL("triggered()"),
                                   self.textUnderline)
            self.algInstructionsEditBar.addAction(self.actionTextUnderline)
            # Toggle preview
            self.actionTogglePreview = QAction(
                    QIcon.fromTheme("document-print-preview",
                                    QIcon(os.path.join(iconDir, "eye.png"))),
                                    "&Preview", self)
            # self.actionTogglePreview.setShortcut("Ctrl-P")
            self.actionTogglePreview.triggered.connect(self.textTogglePreview)
            self.algInstructionsEditBar.addAction(self.actionTogglePreview)
            self.algInstructionsLayout.addWidget(self.algInstructionsEditBar, 0, 0)

        self.algInstructionsWidget.setLayout(self.algInstructionsLayout)
        self.algInstructionsDoc = QTextDocument()
        self.algInstructionsDoc.setDefaultStyleSheet(self.style)
        self.algInstructionsText.setDocument(self.algInstructionsDoc)
        self.algInstructionsText.setAcceptRichText(False)
        self.setDefaultInstructionsText()

        self.normalModeDialog = self.createAlgorithmDialog(self.alg)
        try:
            self.normalModeDialog.tabWidget().setCornerWidget(None)
        except AttributeError:
            pass
        self.batchModeDialog = BatchAlgorithmDialog(self.alg)
        self.batchModeDialog.setHidden(True)
        # forwardButton does the job of cancel/close button
        try:
            if self.alg.name() == "Field calculator":
                self.normalModeDialog.mButtonBox().removeButton(
                        self.normalModeDialog.mButtonBox().button(QDialogButtonBox.Cancel))
            else:
                self.normalModeDialog.buttonBox().removeButton(
                        self.normalModeDialog.buttonBox().button(QDialogButtonBox.Close))
            # forwardButton does this job
            self.batchModeDialog.buttonBox().removeButton(
                    self.batchModeDialog.buttonBox().button(QDialogButtonBox.Close))
        except AttributeError:
            # Not all dialogs might have buttonBox
            pass
        try:
            self.batchModeDialog.btnRunSingle.hide()
            self.normalModeDialog.runAsBatchButton.hide()
        except AttributeError:
            # Not all dialogs might have those buttons
            pass
        if canEdit:
            try:
                self.normalModeDialog.progressBar.hide()
                self.batchModeDialog.progressBar.hide()
                if self.alg.name == "Field calculator":
                    self.normalModeDialog.mButtonBox.hide()
                else:
                    self.normalModeDialog.buttonBox.hide()
                self.batchModeDialog.buttonBox.hide()
            except AttributeError:
                # Not all dialogs might have buttonBox
                pass

        self.normalModeDialog.accepted.connect(self.forward)
        self.batchModeDialog.accepted.connect(self.forward)
        self.normalModeDialog.rejected.connect(self.forward)
        self.batchModeDialog.rejected.connect(self.forward)

        self.resize(1120, 790)
        self.algInstructionsText.setMinimumWidth(350)
        self.tabLayout.addWidget(self.algInstructionsWidget, 0, 0)
        if self.alg.provider().name() == "workflowtools" and\
           self.alg.name() == "workflowinstructions":
            cols = 0
        else:
            cols = 1
            self.tabLayout.setColumnStretch(1, 1)
            self.tabLayout.addWidget(self.normalModeDialog, 0, 1)
            self.tabLayout.addWidget(self.batchModeDialog, 0, 1)

        self.algMode = QComboBox()
        self.algMode.addItems([NORMAL_MODE, BATCH_MODE])
        if canEdit:
            self.algMode.connect(self.algMode, QtCore.SIGNAL("currentIndexChanged(QString)"),
                                 self.mainDialog.changeAlgMode)
            self.tabLayout.addWidget(self.algMode, 1, cols)
        else:
            self.buttonBox = QDialogButtonBox()
            self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
            self.backwardButton = QPushButton()
            self.backwardButton.setText("< Previous step")
            self.buttonBox.addButton(self.backwardButton, QDialogButtonBox.ActionRole)
            self.backwardButton.clicked.connect(self.backward)
            self.forwardButton = QPushButton()
            self.forwardButton.setText("Skip step >")
            self.buttonBox.addButton(self.forwardButton, QDialogButtonBox.ActionRole)
            self.forwardButton.clicked.connect(self.forward)
            self.closeButton = QPushButton()
            self.closeButton.setText("Finish Workflow")
            self.buttonBox.addButton(self.closeButton, QDialogButtonBox.ActionRole)
            self.closeButton.clicked.connect(self.close)
            self.tabLayout.addWidget(self.buttonBox, 1, cols)
        self.setLayout(self.tabLayout)

        self.executed = self.normalModeDialog.wasExecuted

    # Based on processing.tools.general.createAlgorithmDialog but with parent of the dialog widgets
    # set to None. Otherwise some buttons cannot be removed.
    def createAlgorithmDialog(self, algOrName, parameters={}):
        if isinstance(algOrName, QgsProcessingAlgorithm):
            alg = algOrName.create()
        else:
            alg = QgsApplication.processingRegistry().createAlgorithmById(algOrName)

        if alg is None:
            return None

        dlg = alg.createCustomParametersWidget(None)

        if not dlg:
            dlg = AlgorithmDialog(alg, parent=None)

        dlg.setParameters(parameters)

        return dlg

    def textBold(self):
        cursor = self.algInstructionsText.textCursor()
        text = cursor.selectedText()
        if text:
            cursor.insertText("**" + text + "**")

    def textItalic(self):
        cursor = self.algInstructionsText.textCursor()
        text = cursor.selectedText()
        if text:
            cursor.insertText("*" + text + "*")

    def textUnderline(self):
        cursor = self.algInstructionsText.textCursor()
        text = cursor.selectedText()
        if text:
            cursor.insertText("<u>" + text + "</u>")

    def textTogglePreview(self):
        self.getInstructions()
        self.canEdit = not self.canEdit
        if not self.canEdit:
            self.algInstructionsText.setTextInteractionFlags(QtCore.Qt.TextBrowserInteraction)
            self.actionTextUnderline.setDisabled(True)
            self.actionTextBold.setDisabled(True)
            self.actionTextItalic.setDisabled(True)
        else:
            self.algInstructionsText.setTextInteractionFlags(QtCore.Qt.TextEditorInteraction)
            self.actionTextUnderline.setEnabled(True)
            self.actionTextBold.setEnabled(True)
            self.actionTextItalic.setEnabled(True)
        self.setInstructions(self._raw_instructions)

    def forward(self):
        self.goForward = True
        self.close()

    def backward(self):
        self.goBackward = True
        self.close()

    def getMode(self):
        return self.algMode.currentText()

    def setMode(self, mode):
        if not (self.alg.provider().name() == "workflowtools" and
                self.alg.name() == "Workflow instructions"):
            if mode == NORMAL_MODE and not self.normalModeDialog.isVisible():
                self.batchModeDialog.setHidden(True)
                self.normalModeDialog.setVisible(True)
            elif mode == BATCH_MODE and not self.batchModeDialog.isVisible():
                self.normalModeDialog.setHidden(True)
                self.batchModeDialog.setVisible(True)
                self.resize(1050, 500)
        else:
            self.batchModeDialog.setHidden(True)
            self.normalModeDialog.setHidden(True)

    def getInstructions(self):
        if self.canEdit:
            self._raw_instructions = self.algInstructionsText.toPlainText()
            self._html_instructions = self.algInstructionsText.toHtml()
        return self._raw_instructions

    def setInstructions(self, instructions):
        self._raw_instructions = instructions
        html = markdown.markdown(instructions)
        self._html_instructions = html

        self.algInstructionsDoc.clear()
        self.algInstructionsText.clear()
        if not self.canEdit:
            self.algInstructionsDoc.setDefaultStyleSheet(self.style)
            self.algInstructionsDoc.setHtml(self._html_instructions)
            self.algInstructionsText.setDocument(self.algInstructionsDoc)
            cursor = self.algInstructionsText.textCursor()
            cursor.setPosition(0)
            self.algInstructionsText.setTextCursor(cursor)
        else:
            self.algInstructionsDoc.setDefaultStyleSheet("")
            self.algInstructionsText.setFontPointSize(12)
            self.algInstructionsText.setPlainText(self._raw_instructions)
        self.algInstructionsText.document().setMetaInformation(QTextDocument.DocumentUrl,
                                                               "file:"+self.workflowBaseDir+'/')

    def setDefaultInstructionsText(self):
        with open(os.path.join(DIRNAME, "defaultInstructionsText.md"), 'r') as fi:
            text = fi.read()
        if self.canEdit:
            self.algInstructionsText.setFontPointSize(12)
            self.algInstructionsText.setPlainText(text)
        else:
            self.algInstructionsDoc.setDefaultStyleSheet(self.style)
            self.algInstructionsDoc.setHtml(text)
            self.algInstructionsText.setDocument(self.algInstructionsDoc)

    # Disconnect all the signals from nomalModeDialog and batchModeDialog when
    # StepDialog is being closed
    def closeEvent(self, evt):
        self.normalModeDialog.accepted.disconnect(self.forward)
        self.batchModeDialog.accepted.disconnect(self.forward)
        self.normalModeDialog.rejected.disconnect(self.forward)
        self.batchModeDialog.rejected.disconnect(self.forward)

        # batchModeDialog could be already closed if the algorithm was executed
        # in batch mode
        try:
            self.batchModeDialog.finish()
        except TypeError:
            pass
        # normalModeDialog could be already closed if the algorithm was executed
        # in normal mode
        try:
            self.normalModeDialog.finish()
        except TypeError:
            pass
