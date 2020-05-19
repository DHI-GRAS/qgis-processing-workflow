"""
***************************************************************************
   DeleteWorkflowAction.py
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

from processing_workflow.Workflow import Workflow
from processing.gui.ContextAction import ContextAction
import os
from qgis.PyQt import QtGui


class DeleteWorkflowAction(ContextAction):

    def __init__(self, provider):
        self.name = "Delete workflow"
        self.provider = provider

    # This is to make the plugin work both in QGIS 2.14 and 2.16.
    # In 2.16 Processing self.alg was changed to self.itemData.
    def setData(self, itemData, toolbox):
        ContextAction.setData(self, itemData, toolbox)
        self.alg = itemData

    def isEnabled(self):
        return isinstance(self.alg, Workflow) and self.alg.provider == self.provider

    def execute(self, alg):
        reply = QtGui.QMessageBox.question(None, 'Confirmation',
                                           "Are you sure you want to delete this workflow?",
                                           QtGui.QMessageBox.Yes | QtGui.QMessageBox.No,
                                           QtGui.QMessageBox.No)
        if reply == QtGui.QMessageBox.Yes:
            os.remove(self.alg.descriptionFile)
            try:
                # QGIS 2.16 (and up?) Processing implementation
                from processing.core.alglist import algList
                algList.reloadProvider(self.alg.provider.name())
            except ImportError:
                # QGIS 2.14 Processing implementation
                self.toolbox.updateProvider(self.alg.provider.name())
