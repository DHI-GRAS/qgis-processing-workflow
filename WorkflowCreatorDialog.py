"""
***************************************************************************
   WorkflowCreatorDialog.py
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
import codecs
from processing.modeler.ModelerUtils import ModelerUtils
try:
    ModelerUtils.allAlgs = ModelerUtils.getAlgorithms()
except:
    pass
try:
    from processing.modeler.Providers import Providers
except:
    from processing.modeler.ModelerUtils import ModelerUtils
try:
    from processing.parameters.ParameterString import ParameterString
except:
    from processing.core.parameters import ParameterString
try:
    from processing.parameters.ParameterBoolean import ParameterBoolean
except:
    from processing.core.parameters import ParameterBoolean
try:
    from processing.parameters.ParameterSelection import ParameterSelection
except:
    from processing.core.parameters import ParameterSelection
try:
    from processing.parameters.ParameterNumber import ParameterNumber
except:
    from processing.core.parameters import ParameterNumber
from processing.gui.AlgorithmDialogBase import AlgorithmDialogBase
from processing_workflow.Workflow import Workflow
from processing_workflow.StepDialog import StepDialog, NORMAL_MODE, BATCH_MODE
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing.gui.AlgorithmDialog import AlgorithmDialog
from processing_workflow.WrongWorkflowException import WrongWorkflowException

# Dialog for creating new workflows from all the available SEXTANTE algorithms
class WorkflowCreatorDialog(AlgorithmDialogBase):
    def __init__(self, workflow):
        QtGui.QDialog.__init__(self)
        self.setupUi()
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)
        
        # set as window modal
        self.setWindowModality(1)
        
        self.workflow = Workflow()

        self.help = None
        self.update = True #indicates whether to update or not the toolbox after closing this dialog
        self.executed = False
        
        if workflow:
            self.openWorkflow(workflow.descriptionFile)

    def setupUi(self):
        self.resize(1200, 600)
        self.setWindowTitle("WOIS Workflow Creator")
        self.setWindowIcon(WorkflowUtils.workflowIcon())
        self.tabWidget = QtGui.QTabWidget()
        self.tabWidget.setMaximumSize(QtCore.QSize(350, 10000))
        self.tabWidget.setMinimumWidth(300)
        
        #left hand side part
        #==================================
        self.verticalLayout = QtGui.QVBoxLayout()
        self.verticalLayout.setSpacing(2)
        self.verticalLayout.setMargin(0)
        self.searchBox = QtGui.QLineEdit()
        self.searchBox.textChanged.connect(self.fillAlgorithmTree)
        self.verticalLayout.addWidget(self.searchBox)
        self.algorithmTree = QtGui.QTreeWidget()
        self.algorithmTree.setHeaderHidden(True)
        self.fillAlgorithmTree()
        self.verticalLayout.addWidget(self.algorithmTree)
        self.algorithmTree.doubleClicked.connect(self.addAlgorithm)

        self.algorithmsTab = QtGui.QWidget()
        self.algorithmsTab.setLayout(self.verticalLayout)
        self.tabWidget.addTab(self.algorithmsTab, "Algorithms")

        #right hand side part
        #==================================
        self.textName = QtGui.QLineEdit()
        if hasattr(self.textName, 'setPlaceholderText'):
            self.textName.setPlaceholderText("[Enter workflow name here]")
        self.textGroup = QtGui.QLineEdit()
        if hasattr(self.textGroup, 'setPlaceholderText'):
            self.textGroup.setPlaceholderText("[Enter group name here]")
        self.horizontalLayoutNames = QtGui.QHBoxLayout()
        self.horizontalLayoutNames.setSpacing(2)
        self.horizontalLayoutNames.setMargin(0)
        self.horizontalLayoutNames.addWidget(self.textName)
        self.horizontalLayoutNames.addWidget(self.textGroup)

        self.canvasTabWidget = QtGui.QTabWidget()
        self.canvasTabWidget.setMinimumWidth(300)
        self.canvasTabWidget.setMovable(True)

        self.canvasLayout = QtGui.QVBoxLayout()
        self.canvasLayout.setSpacing(2)
        self.canvasLayout.setMargin(0)
        self.canvasLayout.addLayout(self.horizontalLayoutNames)
        self.canvasLayout.addWidget(self.canvasTabWidget)

        #upper part, putting the two previous parts together
        #===================================================
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setSpacing(2)
        self.horizontalLayout.setMargin(0)
        self.horizontalLayout.addWidget(self.tabWidget)
        self.horizontalLayout.addLayout(self.canvasLayout)

        #And the whole layout
        #==========================

        self.buttonBox = QtGui.QDialogButtonBox()
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.runButton = QtGui.QPushButton()
        self.runButton.setText("Test")
        self.buttonBox.addButton(self.runButton, QtGui.QDialogButtonBox.ActionRole)
        self.removeButton = QtGui.QPushButton()
        self.removeButton.setText("Remove step")
        self.buttonBox.addButton(self.removeButton, QtGui.QDialogButtonBox.ActionRole)
        self.openButton = QtGui.QPushButton()
        self.openButton.setText("Open")
        self.buttonBox.addButton(self.openButton, QtGui.QDialogButtonBox.ActionRole)
        self.saveButton = QtGui.QPushButton()
        self.saveButton.setText("Save")
        self.buttonBox.addButton(self.saveButton, QtGui.QDialogButtonBox.ActionRole)
        self.closeButton = QtGui.QPushButton()
        self.closeButton.setText("Close")
        self.buttonBox.addButton(self.closeButton, QtGui.QDialogButtonBox.ActionRole)
        QtCore.QObject.connect(self.openButton, QtCore.SIGNAL("clicked()"), self.openWorkflow)
        QtCore.QObject.connect(self.saveButton, QtCore.SIGNAL("clicked()"), self.saveWorkflow)
        QtCore.QObject.connect(self.closeButton, QtCore.SIGNAL("clicked()"), self.closeWindow)
        QtCore.QObject.connect(self.runButton, QtCore.SIGNAL("clicked()"), self.runWorkflow)
        QtCore.QObject.connect(self.removeButton, QtCore.SIGNAL("clicked()"), self.removeStep)
        
        self.globalLayout = QtGui.QVBoxLayout()
        self.globalLayout.setSpacing(2)
        self.globalLayout.setMargin(0)
        self.globalLayout.addLayout(self.horizontalLayout)
        self.globalLayout.addWidget(self.buttonBox)
        self.setLayout(self.globalLayout)
        QtCore.QMetaObject.connectSlotsByName(self)

    def closeWindow(self):
        self.close()

    # For running (testing) the workflow without saving it and closing the creator window
    def runWorkflow(self):
        for i in range(0, self.canvasTabWidget.count()):
            self.updateStep(i)
        self.workflow.run()
        
    def removeStep(self):
        removeIndex = self.canvasTabWidget.currentIndex()
        self.canvasTabWidget.removeTab(removeIndex)   
        self.workflow.removeStep(removeIndex) 
    
    def updateStep(self, stepNumber):
        stepDialog = self.canvasTabWidget.widget(stepNumber)
        # get customised default values for some parameter types
        if stepDialog.getMode() == NORMAL_MODE:
            if isinstance(stepDialog.normalModeDialog, AlgorithmDialog):
                for param in stepDialog.alg.parameters:
                    if isinstance(param, ParameterBoolean) or isinstance(param, ParameterNumber) or isinstance(param, ParameterString) or isinstance(param, ParameterSelection):
                        # this is not very nice going so deep into step dialog but there seems to be no other way right now
                        stepDialog.normalModeDialog.setParamValue(param, stepDialog.normalModeDialog.paramTable.valueItems[param.name])
        elif stepDialog.getMode() == BATCH_MODE:
            col = 0
            for param in stepDialog.alg.parameters:
                    if isinstance(param, ParameterBoolean) or isinstance(param, ParameterNumber) or isinstance(param, ParameterString) or isinstance(param, ParameterSelection):
                        stepDialog.batchModeDialog.setParameterValueFromWidget(param, stepDialog.batchModeDialog.table.cellWidget(0, col))
                    col += 1
        
        # update the step in the workflow            
        self.workflow.changeStep(stepNumber, stepDialog.alg, stepDialog.getMode(), stepDialog.getInstructions())
    
    # Save workflow to text file        
    def saveWorkflow(self):
        if unicode(self.textGroup.text()).strip() == "" or unicode(self.textName.text()).strip() == "":
            QtGui.QMessageBox.warning(self, "Warning", "Please enter group and model names before saving")
            return
        self.workflow.name = unicode(self.textName.text())
        self.workflow.group = unicode(self.textGroup.text())
        
        # save the instructions for all the steps in the workflow
        for i in range(0, self.canvasTabWidget.count()):
            self.updateStep(i)
        
        if self.workflow.descriptionFile != None:
            filename = self.workflow.descriptionFile
        else:
            filename = unicode(QtGui.QFileDialog.getSaveFileName(self, "Save Workflow", WorkflowUtils.workflowPath(), "QGIS Processing workflows (*.workflow)"))
            if filename:
                if not filename.endswith(".workflow"):
                    filename += ".workflow"
                self.workflow.descriptionFile = filename
        
        if filename:
            text = self.workflow.serialize()
            fout = codecs.open(filename, 'w', encoding='utf-8') #open(filename, "w")
            fout.write(text)
            fout.close()
            self.update = True
            QtGui.QMessageBox.information(self, "Workflow saving", "Workflow was correctly saved.")

    # Open workflow from text file
    def openWorkflow(self, filename = None):
        if not filename:
            filename = QtGui.QFileDialog.getOpenFileName(self, "Open Workflow",  WorkflowUtils.workflowPath(), "SEXTANTE workflows (*.workflow)")
        if filename:
            try:
                workflow = Workflow()
                workflow.openWorkflow(filename)
                self.workflow = workflow
                
                self.canvasTabWidget.clear()
                for i in range(0, self.workflow.getLength()):
                    # create a dialog for this algorithm
                    stepDialog = StepDialog(self.workflow.getAlgorithm(i), self)      
                    stepDialog.setMode(self.workflow.getMode(i))
                    stepDialog.setInstructions(self.workflow.getInstructions(i))
                    # create new tab for it
                    self.canvasTabWidget.addTab(stepDialog, self.workflow.getAlgorithm(i).name)

                self.textGroup.setText(workflow.group)
                self.textName.setText(workflow.name)

            except WrongWorkflowException, e:
                QtGui.QMessageBox.critical(self, "Could not open workflowl", "The selected workflow could not be loaded\nWrong line:" + e.msg)
 
    # Change the mode (normal or batch execution) for the currently open StepDialog
    # This is a slot for a StepDialog signal
    def changeAlgMode(self, mode):
        # change the mode in the dialog
        self.canvasTabWidget.currentWidget().setMode(mode)
        # and in the step object
        self.workflow.changeMode(self.canvasTabWidget.currentIndex(),mode)
        
    # Add new step (algorithm) to the workflow
    def addAlgorithm(self):
        item = self.algorithmTree.currentItem()
        if isinstance(item, TreeAlgorithmItem):
            alg = ModelerUtils.getAlgorithm(item.alg.commandLineName())
            alg = alg.getCopy()#copy.deepcopy(alg)
            
            # create a tab for this algorithm
            stepDialog = StepDialog(alg, self)      
            self.canvasTabWidget.addTab(stepDialog, alg.name)
            
            # add this step to the workflow 
            self.workflow.addStep(alg, stepDialog.getMode(), stepDialog.getInstructions())
    
    # List all the available algorithms in SEXTANTE
    def fillAlgorithmTree(self):
        self.algorithmTree.clear()
        text = unicode(self.searchBox.text())
        allAlgs = ModelerUtils.allAlgs
        # Account for old (pre 2.4) and new (2.4 and up) Processing API
        try:
            providers = Providers.providers
        except:
            providers = ModelerUtils.providers
        for providerName in allAlgs.keys():
            # don't show workflows in available algorithms
            if providerName == "workflow":
                continue
            groups = {}
            provider = allAlgs[providerName]
            algs = provider.values()
            #add algorithms
            for alg in algs:
                if not alg.showInModeler:
                    continue
                if text == "" or text.lower() in alg.name.lower():
                    if alg.group in groups:
                        groupItem = groups[alg.group]
                    else:
                        groupItem = QtGui.QTreeWidgetItem()
                        groupItem.setText(0, alg.group)
                        groups[alg.group] = groupItem
                    algItem = TreeAlgorithmItem(alg)
                    groupItem.addChild(algItem)

            if len(groups) > 0:
                providerItem = QtGui.QTreeWidgetItem()
                providerItem.setText(0, providers[providerName].getDescription())
                providerItem.setIcon(0, providers[providerName].getIcon())
                for groupItem in groups.values():
                    providerItem.addChild(groupItem)
                self.algorithmTree.addTopLevelItem(providerItem)
                providerItem.setExpanded(True)
                for groupItem in groups.values():
                    if text != "":
                        groupItem.setExpanded(True)

        self.algorithmTree.sortItems(0, QtCore.Qt.AscendingOrder)


class TreeAlgorithmItem(QtGui.QTreeWidgetItem):

    def __init__(self, alg):
        QtGui.QTreeWidgetItem.__init__(self)
        self.alg = alg
        self.setText(0, alg.name)
        self.setIcon(0, alg.getIcon())



        