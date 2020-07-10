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

import os
from qgis.PyQt.QtWidgets import QMessageBox
from qgis.core import QgsApplication
from processing_workflow.Workflow import Workflow
from processing.gui.ContextAction import ContextAction


class DeleteWorkflowAction(ContextAction):

    def __init__(self):
        super().__init__()
        self.name = self.tr("Delete workflow", "DeleteWorkflowAction")

    def isEnabled(self):
        return (isinstance(self.itemData, Workflow) and
                "processing_workflow" in self.itemData.provider().id())

    def execute(self, alg):
        reply = QMessageBox.question(None,
                                     self.tr("Confirmation", "DeleteWorkflowAction"),
                                     self.tr("Are you sure you want to delete this workflow?",
                                             "DeleteWorkflowAction"),
                                     QMessageBox.Yes | QMessageBox.No,
                                     QMessageBox.No)
        if reply == QMessageBox.Yes:
            providerId = self.itemData.provider().id()
            os.remove(self.itemData.descriptionFile)
            QgsApplication.processingRegistry().providerById(providerId).refreshAlgorithms()
