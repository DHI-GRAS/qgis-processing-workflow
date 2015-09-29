# -*- coding: utf-8 -*-

"""
***************************************************************************
   WorkflowListDialog.py
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
from processing_workflow.WorkflowUtils import WorkflowUtils
from qgis.utils import iface
from processing.core.Processing import Processing
from processing.gui.AlgorithmDialog import AlgorithmDialog

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

# Dialog for listing the existing workflows
class WorkflowListDialog(QtGui.QDialog):
    def __init__(self, workflowProvider):
        QtGui.QDialog.__init__(self)
        self.workflowProvider = workflowProvider
        self.setupUi()
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)
        
        # set as window modal
        self.setWindowModality(1)
        
    def setupUi(self):
        self.resize(400, 500)
        self.setWindowTitle(self.workflowProvider.getDescription())
        self.setWindowIcon(self.workflowProvider.getIcon())
        self.tabWidget = QtGui.QTabWidget()
        self.tabWidget.setMinimumWidth(300)
        
        # workflow tree
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
        self.algorithmTree.doubleClicked.connect(self.runWorkflow)

        self.algorithmsTab = QtGui.QWidget()
        self.algorithmsTab.setLayout(self.verticalLayout)
        self.tabWidget.addTab(self.algorithmsTab, "Workflows")
        
        # About tab
        ###################        
        self.aboutTab = QtGui.QWidget()
        self.gridLayout = QtGui.QGridLayout(self.aboutTab)
        self.gridLayout.setObjectName(_fromUtf8("gridLayout"))
        self.scrollArea = QtGui.QScrollArea(self.aboutTab)
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName(_fromUtf8("scrollArea"))
        self.scrollAreaWidgetContents = QtGui.QWidget()
        self.scrollAreaWidgetContents.setGeometry(QtCore.QRect(0, 0, 535, 271))
        self.scrollAreaWidgetContents.setObjectName(_fromUtf8("scrollAreaWidgetContents"))
        self.scrollAreaWidgetContents.setStyleSheet("QWidget { background-color : white}") 
        self.aboutVerticalLayout = QtGui.QVBoxLayout(self.scrollAreaWidgetContents)
        self.aboutVerticalLayout.setObjectName(_fromUtf8("aboutVerticalLayout"))
        self.aboutLabel = QtGui.QLabel(self.scrollAreaWidgetContents)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.aboutLabel.sizePolicy().hasHeightForWidth())
        self.aboutLabel.setSizePolicy(sizePolicy)
        self.aboutLabel.setMinimumSize(QtCore.QSize(10, 10))
        self.aboutLabel.setCursor(QtGui.QCursor(QtCore.Qt.ArrowCursor))
        self.aboutLabel.setFocusPolicy(QtCore.Qt.NoFocus)
        self.aboutLabel.setFrameShape(QtGui.QFrame.NoFrame)
        self.aboutLabel.setTextFormat(QtCore.Qt.AutoText)
        self.aboutLabel.setScaledContents(False)
        self.aboutLabel.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignTop)
        self.aboutLabel.setWordWrap(True)
        self.aboutLabel.setOpenExternalLinks(True)
        self.aboutLabel.setTextInteractionFlags(QtCore.Qt.LinksAccessibleByMouse)
        self.aboutLabel.setObjectName(_fromUtf8("aboutLabel"))
        self.aboutVerticalLayout.addWidget(self.aboutLabel)
        self.scrollArea.setWidget(self.scrollAreaWidgetContents)
        self.gridLayout.addWidget(self.scrollArea, 1, 1, 1, 1)
               
        self.tabWidget.addTab(self.aboutTab, "About")
        
        
        #And the whole layout
        #==========================

        self.buttonBox = QtGui.QDialogButtonBox()
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.closeButton = QtGui.QPushButton()
        self.closeButton.setText("Close")
        self.buttonBox.addButton(self.closeButton, QtGui.QDialogButtonBox.ActionRole)
        QtCore.QObject.connect(self.closeButton, QtCore.SIGNAL("clicked()"), self.closeWindow)
        
        self.globalLayout = QtGui.QVBoxLayout()
        self.globalLayout.setSpacing(2)
        self.globalLayout.setMargin(0)
        self.globalLayout.addWidget(self.tabWidget)
        self.globalLayout.addWidget(self.buttonBox)
        self.setLayout(self.globalLayout)
        QtCore.QMetaObject.connectSlotsByName(self)
    
        self.retranslateUi()
    
    def retranslateUi(self):
        try:
            self.aboutLabel.setText(_translate("", self.workflowProvider.aboutHTML, None))
        except:
            self.aboutLabel.setText(_translate("", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
    "<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
    "p, li { white-space: pre-wrap; }\n"
    "</style></head><body style=\" font-family:\'MS Shell Dlg 2\'; font-size:8pt; font-weight:400; font-style:normal;\">\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">Processing Workflow Library</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">This plugin was developed as part of the Water Observation Information System (WOIS) under the TIGER-NET project funded by the European Space Agency as part of the long-term TIGER initiative aiming at promoting the use of Earth Observation (EO) for improved Integrated Water Resources Management (IWRM) in Africa.</p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">WOIS is  a free software i.e. you can redistribute it and/or modify it under the terms of the GNU General Public License as  published by the Free Software Foundation, either version 3 of the  License, or (at your option) any later version.</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">You should have received a copy of the GNU General Public License along with this program.  If not, see http://www.gnu.org/licenses/.</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">Copyright (C) 2014 TIGER-NET (<a href=\"www.tiger-net.org\">www.tiger-net.org</a>)</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    , None))
                
    def closeWindow(self):
        self.close()
    
    # Execute the workflow, based on ProcessingToolbox.executeAlgorithm
    def runWorkflow(self):
        item = self.algorithmTree.currentItem()
        if isinstance(item, TreeAlgorithmItem):
            alg = Processing.getAlgorithm(item.alg.commandLineName())
            message = alg.checkBeforeOpeningParametersDialog()
            if message:
                QtGui.QMessageBox.warning(self, self.tr("Warning"), message)
                return
            alg = alg.getCopy()
            dlg = alg.getCustomParametersDialog()
            if not dlg:
                dlg = AlgorithmDialog(alg)
            canvas = iface.mapCanvas()
            prevMapTool = canvas.mapTool()
            dlg.show()
            dlg.exec_()
            if canvas.mapTool()!=prevMapTool:
                try:
                    canvas.mapTool().reset()
                except:
                    pass
                canvas.setMapTool(prevMapTool)
            
    # List all the available TIGER-NET workflows
    def fillAlgorithmTree(self):
        self.algorithmTree.clear()
        text = unicode(self.searchBox.text())
        allAlgs = Processing.algs
        providers = {}
        for provider in Processing.providers:
            providers[provider.getName()] = provider
        for providerName in [self.workflowProvider.getName()]:
            groups = {}
            provider = allAlgs[providerName]
            algs = provider.values()
            #add algorithms
            for alg in algs:
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