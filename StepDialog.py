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

import os
from PyQt4 import QtCore, QtGui
from processing.gui.AlgorithmDialog import AlgorithmDialog
from processing.gui.BatchAlgorithmDialog import BatchAlgorithmDialog
from processing.gui.InputLayerSelectorPanel import InputLayerSelectorPanel
from processing_workflow import WorkflowUtils

NORMAL_MODE = "Normal"
BATCH_MODE = "Batch"

# Dialog grouping the appropriate algorithm dialog (normal or batch mode), instructions
# box and option to change from normal to batch mode if the dialog is editable.
class StepDialog(QtGui.QDialog):
    
    def __init__(self, alg, mainDialog, workflowBaseDir, canEdit=True):
        
        self.alg = alg
        self.mainDialog = mainDialog
        self.workflowBaseDir = workflowBaseDir
        self.goForward = False
        self.goBackward = False
        
        QtGui.QDialog.__init__(self)
        
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)
        
        # create a tab for this algorithm
        self.tabLayout = QtGui.QGridLayout()
        
        # Create widget holding instructions text and instructions' editing
        # toolbar if in edit mode
        self.algInstructionsWidget = QtGui.QWidget()
        self.algInstructionsLayout = QtGui.QGridLayout()
        self.algInstructionsText = QtGui.QTextEdit()
        self.algInstructionsText.setFontPointSize(10)
         
        # Tool bar to hold font-editing tools
        self.algInstructionsEditBar = QtGui.QToolBar()
        self.algInstructionsEditBar.setIconSize(QtCore.QSize(16, 16))
        iconDir = os.path.join(os.path.dirname(__file__), "images")
        
        # Bold
        self.actionTextBold = QtGui.QAction(QtGui.QIcon.fromTheme("format-text-bold", QtGui.QIcon(os.path.join(iconDir, "boldA.png"))), "&Bold", self)
        self.actionTextBold.setShortcut("Ctrl+B")
        QtCore.QObject.connect(self.actionTextBold, QtCore.SIGNAL("triggered()"), self.textBold)
        self.algInstructionsEditBar.addAction(self.actionTextBold)
        self.actionTextBold.setCheckable(True)
        
        # Italic
        self.actionTextItalic = QtGui.QAction(QtGui.QIcon.fromTheme("format-text-italic", QtGui.QIcon(os.path.join(iconDir, "italicA.png"))), "&Italic", self)
        self.actionTextItalic.setShortcut("Ctrl+I")
        QtCore.QObject.connect(self.actionTextItalic, QtCore.SIGNAL("triggered()"), self.textItalic)
        self.algInstructionsEditBar.addAction(self.actionTextItalic)
        self.actionTextItalic.setCheckable(True)
        
        # Underline
        self.actionTextUnderline = QtGui.QAction(QtGui.QIcon.fromTheme("format-text-underline", QtGui.QIcon(os.path.join(iconDir, "underlineA.png"))), "&Underline", self)
        self.actionTextUnderline.setShortcut("Ctrl+U")
        QtCore.QObject.connect(self.actionTextUnderline, QtCore.SIGNAL("triggered()"), self.textUnderline)
        self.algInstructionsEditBar.addAction(self.actionTextUnderline)
        self.actionTextUnderline.setCheckable(True)
        
        # Colour
        pix = QtGui.QPixmap(16, 16)
        pix.fill(QtGui.QColor("black"))
        self.actionTextColor = QtGui.QAction(QtGui.QIcon(pix), "&Color...", self)
        QtCore.QObject.connect(self.actionTextColor, QtCore.SIGNAL("triggered()"), self.textColor)
        self.algInstructionsEditBar.addAction(self.actionTextColor)
        
        # Font
        self.comboFont = QtGui.QFontComboBox(self.algInstructionsEditBar)
        self.comboFont.setMaximumWidth(95)
        self.algInstructionsEditBar.addWidget(self.comboFont)
        QtCore.QObject.connect(self.comboFont, QtCore.SIGNAL("activated(QString)"), self.textFamily)
        
        # Size
        self.comboSize = QtGui.QComboBox(self.algInstructionsEditBar)
        self.comboSize.setMaximumWidth(45)
        self.algInstructionsEditBar.addWidget(self.comboSize)
        self.comboSize.setEditable(True)
        db = QtGui.QFontDatabase()
        for size in db.standardSizes():
            self.comboSize.addItem(str(size))
        QtCore.QObject.connect(self.comboSize, QtCore.SIGNAL("activated(QString)"), self.textSize)
        self.comboSize.setCurrentIndex(self.comboSize.findText(str(self.algInstructionsText.font().pointSize())))
        
        # Only show the editing tool bar when in edit mode
        if not canEdit:
            self.algInstructionsText.setReadOnly(True)
            self.algInstructionsLayout.addWidget(self.algInstructionsText, 0, 0)
        else:
            self.algInstructionsLayout.addWidget(self.algInstructionsEditBar, 0, 0)
            self.algInstructionsLayout.addWidget(self.algInstructionsText, 1, 0)
        self.algInstructionsWidget.setLayout(self.algInstructionsLayout)
        
        
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
                self.normalModeDialog.mButtonBox.removeButton(self.normalModeDialog.mButtonBox.button(QtGui.QDialogButtonBox.Cancel)) 
            else:    
                self.normalModeDialog.buttonBox.removeButton(self.normalModeDialog.buttonBox.button(QtGui.QDialogButtonBox.Close))
            self.batchModeDialog.buttonBox.removeButton(self.batchModeDialog.buttonBox.button(QtGui.QDialogButtonBox.Close)) # forwardButton does this job
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
        self.normalModeDialog.connect(self.normalModeDialog, QtCore.SIGNAL("finished(int)"), self.forward)
        self.batchModeDialog.connect(self.batchModeDialog, QtCore.SIGNAL("finished(int)"), self.forward)    
        
        if self.alg.provider.getName() == "workflowtools" and self.alg.name == "Workflow instructions":
            cols = 0
        else:
            cols = 1
            self.tabLayout.setColumnStretch(1,1)
        self.resize(1120, 790)
        self.algInstructionsText.setMinimumWidth(350)
        self.tabLayout.addWidget(self.algInstructionsWidget,0,0)
        self.tabLayout.addWidget(self.normalModeDialog, 0, 1)
        self.tabLayout.addWidget(self.batchModeDialog, 0, 1)
            
        self.algMode = QtGui.QComboBox()  
        self.algMode.addItems([NORMAL_MODE, BATCH_MODE])
        if canEdit:
            self.algMode.connect(self.algMode, QtCore.SIGNAL("currentIndexChanged(QString)"),  self.mainDialog.changeAlgMode)
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
        fmt = QtGui.QTextCharFormat()
        fmt.setFontWeight(QtGui.QFont.Bold if self.actionTextBold.isChecked() else QtGui.QFont.Normal)
        self.mergeFormatOnWordOrSelection(fmt)
        
    def textItalic(self):
        fmt = QtGui.QTextCharFormat()
        fmt.setFontItalic(self.actionTextItalic.isChecked())
        self.mergeFormatOnWordOrSelection(fmt)
        
    def textUnderline(self):
        fmt = QtGui.QTextCharFormat()
        fmt.setFontUnderline(self.actionTextUnderline.isChecked())
        self.mergeFormatOnWordOrSelection(fmt)
        
    def textColor(self):
        col = QtGui.QColorDialog.getColor(self.algInstructionsText.textColor(), self);
        if not col.isValid():
            return
        fmt = QtGui.QTextCharFormat()
        fmt.setForeground(col);
        self.mergeFormatOnWordOrSelection(fmt)
        pix = QtGui.QPixmap(16, 16)
        pix.fill(col)
        self.actionTextColor.setIcon(QtGui.QIcon(pix))
        
    def textFamily(self, f):
        fmt = QtGui.QTextCharFormat()
        fmt.setFontFamily(f)
        self.mergeFormatOnWordOrSelection(fmt)
    
    def textSize(self, p):
        pointSize = float(p)
        if pointSize > 0:
            fmt = QtGui.QTextCharFormat()
            fmt.setFontPointSize(pointSize)
            self.mergeFormatOnWordOrSelection(fmt)

    def mergeFormatOnWordOrSelection(self, fontFormat):
        cursor = self.algInstructionsText.textCursor()
        cursor.mergeCharFormat(fontFormat)
        self.algInstructionsText.mergeCurrentCharFormat(fontFormat)

    def forward(self):
        self.goForward = True
        self.close()
        
    def backward(self):
        self.goBackward = True
        self.close()
        
    def getMode(self):
        return self.algMode.currentText()
    
    def setMode(self, mode):
        if not (self.alg.provider.getName() == "workflowtools" and self.alg.name == "Workflow instructions"):
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
        return self.algInstructionsText.toHtml()
    
    def setInstructions(self, instructions):
        self.algInstructionsText.setText(instructions)
        self.algInstructionsText.document().setMetaInformation(QtGui.QTextDocument.DocumentUrl, "file:" + self.workflowBaseDir +'/')
    
    # Disconnect all the signals from nomalModeDialog and batchModeDialog when
    # StepDialog is being closed
    def closeEvent(self, evt):
        self.normalModeDialog.disconnect(self.normalModeDialog, QtCore.SIGNAL("finished(int)"), self.forward)
        self.batchModeDialog.disconnect(self.batchModeDialog, QtCore.SIGNAL("finished(int)"), self.forward)
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
            
    
    # not used for now    
    def addRasterInputs(self, inputs):
        if self.getMode() == NORMAL_MODE:
            panelList = self.normalModeDialog.mainWidget.findChildren(InputLayerSelectorPanel)
        else:
            panelList = self.normalBatchDialog.mainWidget.findChildren(InputLayerSelectorPanel)
        
        for panel in panelList:
            comboBox = panel.text
            for myInput in inputs:
                comboBox.addItem(myInput, myInput)
                
