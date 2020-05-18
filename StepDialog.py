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
from qgis.PyQt import QtCore, QtGui
from processing.gui.AlgorithmDialog import AlgorithmDialog
from processing.gui.BatchAlgorithmDialog import BatchAlgorithmDialog
from processing.gui.InputLayerSelectorPanel import InputLayerSelectorPanel
from . import markdown

NORMAL_MODE = "Normal"
BATCH_MODE = "Batch"
DIRNAME = os.path.dirname(__file__)


# Dialog grouping the appropriate algorithm dialog (normal or batch mode), instructions
# box and option to change from normal to batch mode if the dialog is editable.
class StepDialog(QtGui.QDialog):

    def __init__(self, alg, mainDialog, workflowBaseDir, canEdit=True, style=None):

        self.alg = alg
        self.mainDialog = mainDialog
        self.workflowBaseDir = workflowBaseDir
        self.canEdit = canEdit
        self.goForward = False
        self.goBackward = False
        self.style = style

        QtGui.QDialog.__init__(self)

        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)

        # create a tab for this algorithm
        self.tabLayout = QtGui.QGridLayout()

        # Create widget holding instructions text and instructions' editing
        # toolbar if in edit mode
        self.algInstructionsWidget = QtGui.QWidget()
        self.algInstructionsLayout = QtGui.QGridLayout()

        if not canEdit:
            self.algInstructionsText = QtGui.QTextBrowser()
            self.algInstructionsText.setOpenExternalLinks(True)
            self.algInstructionsLayout.addWidget(self.algInstructionsText, 0, 0)
        else:
            self.algInstructionsText = QtGui.QTextEdit()
            self.algInstructionsText.setTextInteractionFlags(QtCore.Qt.TextEditorInteraction)
            self.algInstructionsLayout.addWidget(self.algInstructionsText, 1, 0)
            # Tool bar to hold font-editing tools
            self.algInstructionsEditBar = QtGui.QToolBar()
            self.algInstructionsEditBar.setIconSize(QtCore.QSize(16, 16))
            iconDir = os.path.join(os.path.dirname(__file__), "images")
            # Bold
            self.actionTextBold = QtGui.QAction(
                    QtGui.QIcon.fromTheme("format-text-bold",
                                          QtGui.QIcon(os.path.join(iconDir, "boldA.png"))),
                    "&Bold", self)
            self.actionTextBold.setShortcut("Ctrl+B")
            QtCore.QObject.connect(self.actionTextBold, QtCore.SIGNAL("triggered()"),
                                   self.textBold)
            self.algInstructionsEditBar.addAction(self.actionTextBold)
            # Italic
            self.actionTextItalic = QtGui.QAction(
                    QtGui.QIcon.fromTheme("format-text-italic",
                                          QtGui.QIcon(os.path.join(iconDir, "italicA.png"))),
                    "&Italic", self)
            self.actionTextItalic.setShortcut("Ctrl+I")
            QtCore.QObject.connect(self.actionTextItalic, QtCore.SIGNAL("triggered()"),
                                   self.textItalic)
            self.algInstructionsEditBar.addAction(self.actionTextItalic)
            # Underline
            self.actionTextUnderline = QtGui.QAction(
                    QtGui.QIcon.fromTheme("format-text-underline",
                                          QtGui.QIcon(os.path.join(iconDir, "underlineA.png"))),
                    "&Underline", self)
            self.actionTextUnderline.setShortcut("Ctrl+U")
            QtCore.QObject.connect(self.actionTextUnderline, QtCore.SIGNAL("triggered()"),
                                   self.textUnderline)
            self.algInstructionsEditBar.addAction(self.actionTextUnderline)
            # Toggle preview
            self.actionTogglePreview = QtGui.QAction(
                    QtGui.QIcon.fromTheme("document-print-preview",
                                          QtGui.QIcon(os.path.join(iconDir, "eye.png"))),
                    "&Preview", self)
            # self.actionTogglePreview.setShortcut("Ctrl-P")
            self.actionTogglePreview.triggered.connect(self.textTogglePreview)
            self.algInstructionsEditBar.addAction(self.actionTogglePreview)
            self.algInstructionsLayout.addWidget(self.algInstructionsEditBar, 0, 0)

        self.algInstructionsWidget.setLayout(self.algInstructionsLayout)
        self.algInstructionsDoc = QtGui.QTextDocument()
        self.algInstructionsDoc.setDefaultStyleSheet(self.style)
        self.algInstructionsText.setDocument(self.algInstructionsDoc)
        self.algInstructionsText.setAcceptRichText(False)
        self.setDefaultInstructionsText()

        self.normalModeDialog = alg.getCustomParametersDialog()
        if not self.normalModeDialog:
            self.normalModeDialog = AlgorithmDialog(alg)
        # Do not show the "Run as batch process" button in workflows
        try:
            self.normalModeDialog.tabWidget.setCornerWidget(None)
        except:
            pass
        self.batchModeDialog = BatchAlgorithmDialog(alg)
        self.batchModeDialog.setHidden(True)
        # forwardButton does the job of cancel/close button
        try:
            if self.alg.name == "Field calculator":
                self.normalModeDialog.mButtonBox.removeButton(
                        self.normalModeDialog.mButtonBox.button(QtGui.QDialogButtonBox.Cancel))
            else:
                self.normalModeDialog.buttonBox.removeButton(
                        self.normalModeDialog.buttonBox.button(QtGui.QDialogButtonBox.Close))
            # forwardButton does this job
            self.batchModeDialog.buttonBox.removeButton(
                    self.batchModeDialog.buttonBox.button(QtGui.QDialogButtonBox.Close))
        except:
            # Not all dialogs might have buttonBox
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
            except:
                # Not all dialogs might have buttonBox
                pass
        self.normalModeDialog.connect(self.normalModeDialog, QtCore.SIGNAL("finished(int)"),
                                      self.forward)
        self.batchModeDialog.connect(self.batchModeDialog, QtCore.SIGNAL("finished(int)"),
                                     self.forward)

        self.resize(1120, 790)
        self.algInstructionsText.setMinimumWidth(350)
        self.tabLayout.addWidget(self.algInstructionsWidget, 0, 0)
        if self.alg.provider.getName() == "workflowtools" and\
           self.alg.name == "Workflow instructions":
            cols = 0
        else:
            cols = 1
            self.tabLayout.setColumnStretch(1, 1)
            self.tabLayout.addWidget(self.normalModeDialog, 0, 1)
            self.tabLayout.addWidget(self.batchModeDialog, 0, 1)

        self.algMode = QtGui.QComboBox()
        self.algMode.addItems([NORMAL_MODE, BATCH_MODE])
        if canEdit:
            self.algMode.connect(self.algMode, QtCore.SIGNAL("currentIndexChanged(QString)"),
                                 self.mainDialog.changeAlgMode)
            self.tabLayout.addWidget(self.algMode, 1, cols)
        else:
            self.buttonBox = QtGui.QDialogButtonBox()
            self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
            self.backwardButton = QtGui.QPushButton()
            self.backwardButton.setText("< Previous step")
            self.buttonBox.addButton(self.backwardButton, QtGui.QDialogButtonBox.ActionRole)
            QtCore.QObject.connect(self.backwardButton, QtCore.SIGNAL("clicked()"), self.backward)
            self.forwardButton = QtGui.QPushButton()
            self.forwardButton.setText("Skip step >")
            self.buttonBox.addButton(self.forwardButton, QtGui.QDialogButtonBox.ActionRole)
            QtCore.QObject.connect(self.forwardButton, QtCore.SIGNAL("clicked()"), self.forward)
            self.closeButton = QtGui.QPushButton()
            self.closeButton.setText("Finish Workflow")
            self.buttonBox.addButton(self.closeButton, QtGui.QDialogButtonBox.ActionRole)
            QtCore.QObject.connect(self.closeButton, QtCore.SIGNAL("clicked()"), self.close)
            self.tabLayout.addWidget(self.buttonBox, 1, cols)
        self.setLayout(self.tabLayout)

        self.executed = self.normalModeDialog.executed

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
        if not (self.alg.provider.getName() == "workflowtools" and
                self.alg.name == "Workflow instructions"):
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
        self.algInstructionsText.document().setMetaInformation(QtGui.QTextDocument.DocumentUrl,
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
        self.normalModeDialog.disconnect(self.normalModeDialog, QtCore.SIGNAL("finished(int)"),
                                         self.forward)
        self.batchModeDialog.disconnect(self.batchModeDialog, QtCore.SIGNAL("finished(int)"),
                                        self.forward)
        # batchModeDialog could be already closed if the algorithm was executed
        # in batch mode
        try:
            self.batchModeDialog.closeEvent(evt)
        except TypeError:
            pass
        # normalModeDialog could be already closed if the algorithm was executed
        # in normal mode
        try:
            self.normalModeDialog.closeEvent(evt)
        except TypeError:
            pass
        QtGui.QDialog.closeEvent(self, evt)
