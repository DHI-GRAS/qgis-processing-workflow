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

from PyQt4 import QtCore, QtGui
from processing.gui.AlgorithmDialog import AlgorithmDialog
from processing.gui.BatchAlgorithmDialog import BatchAlgorithmDialog
from processing.gui.InputLayerSelectorPanel import InputLayerSelectorPanel

NORMAL_MODE = "Normal"
BATCH_MODE = "Batch"

# Dialog grouping the appropriate algorithm dialog (normal or batch mode), instructions
# box and option to change from normal to batch mode if the dialog is editable.
class StepDialog(QtGui.QDialog):
    
    def __init__(self, alg, mainDialog, canEdit=True):
        
        self.alg = alg
        self.mainDialog = mainDialog
        self.goForward = False
        self.goBackward = False
        
        QtGui.QDialog.__init__(self)
        
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)
        
        # create a tab for this algorithm
        self.tabLayout = QtGui.QGridLayout()
            
        self.algInstructions = QtGui.QTextEdit()
        self.algInstructions.setMinimumWidth(250)
        self.algInstructions.setMaximumWidth(250)
        self.algInstructions.setFontPointSize(10)
        if not canEdit:
            self.algInstructions.setReadOnly(True)
        
        self.normalModeDialog = alg.getCustomParametersDialog()
        if not self.normalModeDialog:
            self.normalModeDialog = AlgorithmDialog(alg)
        self.batchModeDialog = BatchAlgorithmDialog(alg)
        self.batchModeDialog.setHidden(True)
        # Not all dialogs might have buttonBox
        try:
            if self.alg.name == "Field calculator":
                self.normalModeDialog.mButtonBox.button(QtGui.QDialogButtonBox.Cancel).hide() # forwardButton does this job
                self.batchModeDialog.mButtonBox.button(QtGui.QDialogButtonBox.Cancel).hide() # forwardButton does this job
            else:    
                self.normalModeDialog.buttonBox.button(QtGui.QDialogButtonBox.Close).hide() # forwardButton does this job
                self.batchModeDialog.buttonBox.button(QtGui.QDialogButtonBox.Close).hide() # forwardButton does this job
        except:
            pass
        if canEdit:
            # Not all dialogs might have buttonBox
            try:
                self.normalModeDialog.progressBar.hide()
                self.batchModeDialog.progressBar.hide()
                if self.alg.name == "Field calculator":
                    self.normalModeDialog.mButtonBox.hide()
                else:
                    self.normalModeDialog.buttonBox.hide()
                self.batchModeDialog.buttonBox.hide()
                
            except:
                pass
        self.normalModeDialog.connect(self.normalModeDialog, QtCore.SIGNAL("finished(int)"), self.forward)
        self.batchModeDialog.connect(self.batchModeDialog, QtCore.SIGNAL("finished(int)"), self.forward)    
            
        self.tabLayout.addWidget(self.algInstructions,0,0)
        self.tabLayout.addWidget(self.normalModeDialog, 0, 1)
        self.tabLayout.addWidget(self.batchModeDialog, 0, 1)
        
        self.algMode = QtGui.QComboBox()  
        self.algMode.addItems([NORMAL_MODE, BATCH_MODE])
        if canEdit:
            self.algMode.connect(self.algMode, QtCore.SIGNAL("currentIndexChanged(QString)"),  self.mainDialog.changeAlgMode)
            self.tabLayout.addWidget(self.algMode, 1, 1)
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
            self.tabLayout.addWidget(self.buttonBox, 1, 1)
            
        self.setLayout(self.tabLayout)
        
        self.executed = self.normalModeDialog.executed
    
    def forward(self):
        self.goForward = True
        self.close()
        
    def backward(self):
        self.goBackward = True
        self.close()
        
    def getMode(self):
        return self.algMode.currentText()
    
    def setMode(self, mode):
        if mode == NORMAL_MODE and not self.normalModeDialog.isVisible(): 
            self.batchModeDialog.setHidden(True)
            self.normalModeDialog.setVisible(True)
        elif mode == BATCH_MODE and not self.batchModeDialog.isVisible():
            self.normalModeDialog.setHidden(True)
            self.batchModeDialog.setVisible(True)
            self.resize(1050, 500)
    
    def getInstructions(self):
        return self.algInstructions.toPlainText()
    
    def setInstructions(self, instructions):
        self.algInstructions.setText(instructions)
    
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
                
