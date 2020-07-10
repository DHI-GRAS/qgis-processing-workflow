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

from builtins import str
from builtins import range
import codecs
import os

from qgis.PyQt import uic
from qgis.PyQt.QtCore import (Qt,
                              QByteArray,
                              pyqtSignal)
from qgis.PyQt.QtWidgets import (QLineEdit,
                                 QWidget,
                                 QVBoxLayout,
                                 QFileDialog,
                                 QMessageBox,
                                 QMainWindow,
                                 QDockWidget,
                                 QGridLayout,
                                 QLabel,
                                 QSizePolicy,
                                 QFrame)
from qgis.core import (QgsProcessingParameterString,
                       QgsProcessingParameterBoolean,
                       QgsProcessingParameterEnum,
                       QgsProcessingParameterNumber,
                       QgsProcessingParameterExtent,
                       QgsApplication,
                       QgsSettings)
from qgis.gui import (QgsMessageBar,
                      QgsDockWidget,
                      QgsScrollArea,
                      QgsFilterLineEdit,
                      QgsProcessingToolboxTreeView)
from qgis.utils import iface
from processing.gui.AlgorithmDialog import AlgorithmDialog
from processing_workflow.Workflow import Workflow
from processing_workflow.StepDialog import StepDialog, NORMAL_MODE, BATCH_MODE
from processing_workflow.WorkflowUtils import WorkflowUtils
from processing_workflow.WrongWorkflowException import WrongWorkflowException

pluginPath = os.path.dirname(__file__)
WIDGET, BASE = uic.loadUiType(os.path.join(pluginPath, 'ui', 'DlgWorkflowCreator.ui'))


# Dialog for creating new workflows from all the available Processing algorithms
class WorkflowCreatorDialog(WIDGET, BASE):

    update_workflow = pyqtSignal()

    dlgs = []

    @staticmethod
    def create(workflow=None):
        """
        Based on ModelerDialog.py
        Workaround crappy sip handling of QMainWindow. It doesn't know that we are using the
        deleteonclose flag, so happily just deletes dialogs as soon as they go out of scope. The
        only workaround possible while we still have to drag around this Python code is to store a
        reference to the sip wrapper so that sip doesn't get confused. The underlying object will
        still be deleted by the deleteonclose flag though!
        """
        dlg = WorkflowCreatorDialog(workflow)
        WorkflowCreatorDialog.dlgs.append(dlg)
        return dlg

    def __init__(self, workflow):
        super().__init__(None)
        self.setAttribute(Qt.WA_DeleteOnClose)

        self.setupUi()

        self.setWindowFlags(self.windowFlags() | Qt.WindowSystemMenuHint |
                            Qt.WindowMinMaxButtonsHint)

        # set as window modal
        self.setWindowModality(1)

        self.help = None

        if workflow:
            self.workflow = workflow
            self.openWorkflow(workflow.descriptionFile)
            self.setWindowIcon = workflow.icon()
        else:
            self.workflow = Workflow()

        self.hasChanged = False
        self.help = None

    def setupUi(self):

        super().setupUi(self)

        self.propertiesDock = QgsDockWidget(self)
        self.propertiesDock.setFeatures(
            QDockWidget.DockWidgetFloatable | QDockWidget.DockWidgetMovable)
        self.propertiesDock.setObjectName("propertiesDock")
        propertiesDockContents = QWidget()
        self.verticalDockLayout_1 = QVBoxLayout(propertiesDockContents)
        self.verticalDockLayout_1.setContentsMargins(0, 0, 0, 0)
        self.verticalDockLayout_1.setSpacing(0)
        self.scrollArea_1 = QgsScrollArea(propertiesDockContents)
        sizePolicy = QSizePolicy(QSizePolicy.MinimumExpanding,
                                 QSizePolicy.MinimumExpanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.scrollArea_1.sizePolicy().hasHeightForWidth())
        self.scrollArea_1.setSizePolicy(sizePolicy)
        self.scrollArea_1.setFocusPolicy(Qt.WheelFocus)
        self.scrollArea_1.setFrameShape(QFrame.NoFrame)
        self.scrollArea_1.setFrameShadow(QFrame.Plain)
        self.scrollArea_1.setWidgetResizable(True)
        self.scrollAreaWidgetContents_1 = QWidget()
        self.gridLayout = QGridLayout(self.scrollAreaWidgetContents_1)
        self.gridLayout.setContentsMargins(6, 6, 6, 6)
        self.gridLayout.setSpacing(4)
        self.label_1 = QLabel(self.scrollAreaWidgetContents_1)
        self.gridLayout.addWidget(self.label_1, 0, 0, 1, 1)
        self.textName = QLineEdit(self.scrollAreaWidgetContents_1)
        self.gridLayout.addWidget(self.textName, 0, 1, 1, 1)
        self.label_2 = QLabel(self.scrollAreaWidgetContents_1)
        self.gridLayout.addWidget(self.label_2, 1, 0, 1, 1)
        self.textGroup = QLineEdit(self.scrollAreaWidgetContents_1)
        self.gridLayout.addWidget(self.textGroup, 1, 1, 1, 1)
        self.label_1.setText(self.tr("Name"))
        self.textName.setToolTip(self.tr("Enter workflow name here"))
        self.label_2.setText(self.tr("Group"))
        self.textGroup.setToolTip(self.tr("Enter group name here"))
        self.scrollArea_1.setWidget(self.scrollAreaWidgetContents_1)
        self.verticalDockLayout_1.addWidget(self.scrollArea_1)
        self.propertiesDock.setWidget(propertiesDockContents)
        self.propertiesDock.setWindowTitle(self.tr("Workflow Properties"))

        self.algorithmsDock = QgsDockWidget(self)
        self.algorithmsDock.setFeatures(QDockWidget.DockWidgetFloatable | QDockWidget.DockWidgetMovable)
        self.algorithmsDock.setObjectName("algorithmsDock")
        self.algorithmsDockContents = QWidget()
        self.verticalLayout_4 = QVBoxLayout(self.algorithmsDockContents)
        self.verticalLayout_4.setContentsMargins(0, 0, 0, 0)
        self.scrollArea_3 = QgsScrollArea(self.algorithmsDockContents)
        sizePolicy.setHeightForWidth(self.scrollArea_3.sizePolicy().hasHeightForWidth())
        self.scrollArea_3.setSizePolicy(sizePolicy)
        self.scrollArea_3.setFocusPolicy(Qt.WheelFocus)
        self.scrollArea_3.setFrameShape(QFrame.NoFrame)
        self.scrollArea_3.setFrameShadow(QFrame.Plain)
        self.scrollArea_3.setWidgetResizable(True)
        self.scrollAreaWidgetContents_3 = QWidget()
        self.verticalLayout_2 = QVBoxLayout(self.scrollAreaWidgetContents_3)
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_2.setSpacing(4)
        self.searchBox = QgsFilterLineEdit(self.scrollAreaWidgetContents_3)
        self.verticalLayout_2.addWidget(self.searchBox)
        self.algorithmTree = QgsProcessingToolboxTreeView(None,
                                                          QgsApplication.processingRegistry())
        self.algorithmTree.setAlternatingRowColors(True)
        self.algorithmTree.header().setVisible(False)
        self.verticalLayout_2.addWidget(self.algorithmTree)
        self.scrollArea_3.setWidget(self.scrollAreaWidgetContents_3)
        self.verticalLayout_4.addWidget(self.scrollArea_3)
        self.algorithmsDock.setWidget(self.algorithmsDockContents)
        self.addDockWidget(Qt.DockWidgetArea(1), self.algorithmsDock)
        self.algorithmsDock.setWindowTitle(self.tr("Algorithms"))
        self.searchBox.setToolTip(self.tr("Enter algorithm name to filter list"))
        self.searchBox.setShowSearchIcon(True)

        self.bar = QgsMessageBar()
        self.bar.setSizePolicy(QSizePolicy.Minimum, QSizePolicy.Fixed)
        self.centralWidget().layout().insertWidget(0, self.bar)
        self.setDockOptions(self.dockOptions() | QMainWindow.GroupedDragging)

        if iface is not None:
            self.mToolbar.setIconSize(iface.iconSize())
            self.setStyleSheet(iface.mainWindow().styleSheet())

        self.mActionOpen.setIcon(
            QgsApplication.getThemeIcon('/mActionFileOpen.svg'))
        self.mActionSave.setIcon(
            QgsApplication.getThemeIcon('/mActionFileSave.svg'))
        self.mActionRemoveStep.setIcon(
            QgsApplication.getThemeIcon('/mActionDeleteSelected.svg'))
        self.mActionRun.setIcon(
            QgsApplication.getThemeIcon('/mActionStart.svg'))

        self.addDockWidget(Qt.LeftDockWidgetArea, self.propertiesDock)
        self.addDockWidget(Qt.LeftDockWidgetArea, self.algorithmsDock)

        self.setWindowFlags(Qt.WindowMinimizeButtonHint |
                            Qt.WindowMaximizeButtonHint |
                            Qt.WindowCloseButtonHint)

        settings = QgsSettings()
        self.restoreState(settings.value("/Processing/stateWorkflowCreator", QByteArray()))
        self.restoreGeometry(settings.value("/Processing/geometryWorkflowCreator", QByteArray()))

        self.canvasTabWidget.setMinimumWidth(300)
        self.canvasTabWidget.setMovable(True)

        self.mActionOpen.triggered.connect(self.openWorkflow)
        self.mActionSave.triggered.connect(self.saveWorkflow)
        self.mActionRemoveStep.triggered.connect(self.removeStep)
        self.mActionRun.triggered.connect(self.runWorkflow)
        self.algorithmTree.doubleClicked.connect(self.addAlgorithm)

    def closeEvent(self, evt):
        settings = QgsSettings()
        settings.setValue("/Processing/stateWorkflowCreator", self.saveState())
        settings.setValue("/Processing/geometryWorkflowCreator", self.saveGeometry())

        if self.hasChanged:
            ret = QMessageBox.question(
                self, self.tr('Save Workflow?'),
                self.tr('There are unsaved changes in this workflow. Do you want to keep those?'),
                QMessageBox.Save | QMessageBox.Cancel | QMessageBox.Discard, QMessageBox.Cancel)

            if ret == QMessageBox.Save:
                self.saveWorkflow(False)
                evt.accept()
            elif ret == QMessageBox.Discard:
                evt.accept()
            else:
                evt.ignore()
        else:
            evt.accept()

    # For running (testing) the workflow without saving it and closing the creator window
    def runWorkflow(self):
        for i in range(0, self.canvasTabWidget.count()):
            self.updateStep(i)
        self.workflow.processAlgorithm(None, None, None)

    def removeStep(self):
        removeIndex = self.canvasTabWidget.currentIndex()
        self.canvasTabWidget.removeTab(removeIndex)
        self.workflow.removeStep(removeIndex)
        self.hasChanged = True

    def updateStep(self, stepNumber):
        stepDialog = self.canvasTabWidget.widget(stepNumber)
        # get customised default values for some parameter types
        if stepDialog.getMode() == NORMAL_MODE:
            if isinstance(stepDialog.normalModeDialog, AlgorithmDialog):
                for param in stepDialog.alg.parameterDefinitions():
                    if isinstance(param, QgsProcessingParameterBoolean) or\
                       isinstance(param, QgsProcessingParameterNumber) or\
                       isinstance(param, QgsProcessingParameterString) or\
                       isinstance(param, QgsProcessingParameterEnum) or\
                       isinstance(param, QgsProcessingParameterExtent):
                        # this is not very nice going so deep into step dialog but there seems to
                        # be no other way right now
                        param.setDefaultValue(
                                stepDialog.normalModeDialog.mainWidget().wrappers[param.name()].parameterValue())
        elif stepDialog.getMode() == BATCH_MODE:
            col = 0
            for param in stepDialog.alg.parameterDefinitions():
                if isinstance(param, QgsProcessingParameterBoolean) or\
                   isinstance(param, QgsProcessingParameterNumber) or\
                   isinstance(param, QgsProcessingParameterString) or\
                   isinstance(param, QgsProcessingParameterEnum) or\
                   isinstance(param, QgsProcessingParameterExtent):
                    param.setDefaultValue(
                            stepDialog.batchModeDialog.mainWidget().wrappers[0][col].parameterValue())
                col += 1

        # update the step in the workflow
        self.workflow.changeStep(stepNumber, stepDialog.alg, stepDialog.getMode(),
                                 stepDialog.getInstructions())

    # Save workflow to text file
    def saveWorkflow(self):
        if str(self.textGroup.text()).strip() == "" or\
           str(self.textName.text()).strip() == "":
            QMessageBox.warning(self, "Warning",
                                      "Please enter group and model names before saving")
            return
        self.workflow.setName(str(self.textName.text()))
        self.workflow.setGroup(str(self.textGroup.text()))

        # save the instructions for all the steps in the workflow
        for i in range(0, self.canvasTabWidget.count()):
            self.updateStep(i)

        if self.workflow.descriptionFile:
            filename = self.workflow.descriptionFile
        else:
            filename = QFileDialog.getSaveFileName(self, "Save Workflow",
                                                   WorkflowUtils.workflowPath(),
                                                   "QGIS Processing workflows (*.workflow)")[0]
            if filename:
                if not filename.endswith(".workflow"):
                    filename += ".workflow"
                self.workflow.descriptionFile = filename

        if filename:
            text = self.workflow.serialize()
            fout = codecs.open(filename, 'w', encoding='utf-8')
            fout.write(text)
            fout.close()
            self.update_workflow.emit()
            QMessageBox.information(self, "Workflow saving", "Workflow was correctly saved.")
            self.hasChanged = False

    # Open workflow from text file
    def openWorkflow(self, filename=None):
        if not filename:
            filename = QFileDialog.getOpenFileName(self, "Open Workflow",
                                                   WorkflowUtils.workflowPath(),
                                                   "Processing workflows (*.workflow)")[0]
        if filename:
            try:
                self.workflow.openWorkflow(filename)

                self.canvasTabWidget.clear()
                for i in range(0, self.workflow.getLength()):
                    # create a dialog for this algorithm
                    stepDialog = StepDialog(self.workflow.getAlgorithm(i),
                                            self.workflow.getParameters(i),
                                            self,
                                            os.path.dirname(filename),
                                            style=self.workflow.style)
                    stepDialog.setMode(self.workflow.getMode(i))
                    stepDialog.setInstructions(self.workflow.getInstructions(i))
                    # create new tab for it
                    self.canvasTabWidget.addTab(stepDialog,
                                                self.workflow.getAlgorithm(i).displayName())

                self.textGroup.setText(self.workflow.group())
                self.textName.setText(self.workflow.displayName())
                self.hasChanged = False

            except WrongWorkflowException as e:
                QMessageBox.critical(self, "Could not open workflow",
                                     "The selected workflow could not be loaded\nWrong line:" + e.msg)

    # Change the mode (normal or batch execution) for the currently open StepDialog
    # This is a slot for a StepDialog signal
    def changeAlgMode(self, mode):
        print(mode)
        # change the mode in the dialog
        self.canvasTabWidget.currentWidget().setMode(mode)
        # and in the step object
        self.workflow.changeMode(self.canvasTabWidget.currentIndex(), mode)
        self.hasChanged = True

    # Add new step (algorithm) to the workflow
    def addAlgorithm(self):
        algorithm = self.algorithmTree.selectedAlgorithm()
        if algorithm is not None:
            alg = QgsApplication.processingRegistry().createAlgorithmById(algorithm.id())

            # create a tab for this algorithm
            stepDialog = StepDialog(alg, {}, self, "")
            self.canvasTabWidget.addTab(stepDialog, alg.displayName())

            # add this step to the workflow
            self.workflow.addStep(alg, stepDialog.getMode(), stepDialog.getInstructions())
            self.hasChanged = True
