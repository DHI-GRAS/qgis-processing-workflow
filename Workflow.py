"""
***************************************************************************
   Workflow.py
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
from io import open
import os
import json
from qgis.PyQt.QtCore import QCoreApplication
from qgis.core import (QgsApplication,
                       QgsProcessingAlgorithm,
                       QgsProcessingParameterString,
                       QgsProcessingParameterBoolean,
                       QgsProcessingParameterEnum,
                       QgsProcessingParameterNumber,
                       QgsProcessingParameterExtent)
from processing.algs.grass7.Grass7Algorithm import Grass7Algorithm
from processing.algs.grass7.Grass7Utils import Grass7Utils
from processing_workflow.StepDialog import StepDialog, NORMAL_MODE, BATCH_MODE
from processing_workflow.WrongWorkflowException import WrongWorkflowException
from processing_workflow.WorkflowUtils import WorkflowUtils

DIRNAME = os.path.dirname(__file__)


# Class containing the list of steps (algorithms) in the workflow together with the mode
# and instructions for each step
class Workflow(QgsProcessingAlgorithm):

    def __init__(self):
        QgsProcessingAlgorithm.__init__(self)
        # holds the algorithm object, the mode (normal or batch) and instructions
        self._steps = list()
        self._name = ''
        self._group = ''
        self.descriptionFile = ''
        self.style = None
        self.parameters = [QgsProcessingParameterString("Info",
                                                        "Workflow can not be run as a batch " +
                                                        "process. Please close this dialog and " +
                                                        "execute as a normal process.",
                                                        "",
                                                        False)]
        self.showInModeler = False

    def addStep(self, algorithm, mode, instructions, algParameters={}):
        step = {'algorithm': algorithm, 'mode': mode, 'instructions': instructions,
                'parameters': algParameters}
        self._steps.append(step)

    def changeStep(self, index, algorithm, mode, instructions, algParameters={}):
        algParameters = {}
        for param in algorithm.parameters:
            if isinstance(param, QgsProcessingParameterBoolean) or\
               isinstance(param, QgsProcessingParameterNumber) or\
               isinstance(param, QgsProcessingParameterString) or\
               isinstance(param, QgsProcessingParameterEnum) or\
               isinstance(param, QgsProcessingParameterExtent):
                algParameters[param.name] = param.value
        self._steps[index] = {'algorithm': algorithm, 'mode': mode, 'instructions': instructions,
                              'parameters': algParameters}

    def changeMode(self, index, mode):
        self._steps[index]['mode'] = mode

    def changeInstructions(self, index, instructions):
        self._steps[index]['instructions'] = instructions

    def getLength(self):
        return len(self._steps)

    def getAlgorithm(self, index):
        return self._steps[index]['algorithm']

    def getMode(self, index):
        return self._steps[index]['mode']

    def getInstructions(self, index):
        return self._steps[index]['instructions']

    def icon(self):
        try:
            return self.provider().icon()
        except:
            return WorkflowUtils.workflowIcon()

    def getStyle(self):
        styleFile = os.path.join(self.provider().baseDir, self.provider().css)
        if not os.path.isfile(styleFile):
            styleFile = os.path.join(DIRNAME, "style.css")
        with open(styleFile, 'r') as fi:
            self.style = fi.read()

    def createInstance(self):
        newone = Workflow()
        newone.setProvider(self.provider())
        newone.openWorkflow(self.descriptionFile)
        newone.getStyle()
        return newone

    def removeStep(self, index):
        self._steps.pop(index)

    def processAlgorithm(self, parameters, context, progress):
        # execute the first step
        step = self._steps[0]
        stepDialog = self.executeStep(step)

        # execute the rest
        while True:
            # check if workflow should go forward, backward or finish
            if stepDialog.goForward:
                step = self.nextStep(step)
            elif stepDialog.goBackward:
                step = self.previousStep(step)
            else:
                step = None

            # finish the workflow or execute the next step
            if step is None:
                Grass7Utils.endGrassSession()
                #return stepDialog.executed()
                return {}
            else:
                stepDialog = self.executeStep(step)

    def prepareStepAlgorithm(self, step):
        parameters = step['parameters']
        alg = step['algorithm'].create()
        for paramName in parameters.keys():
            param = alg.parameterDefinition(paramName)
            if param and (isinstance(param, QgsProcessingParameterBoolean) or
                          isinstance(param, QgsProcessingParameterNumber) or
                          isinstance(param, QgsProcessingParameterString) or
                          isinstance(param, QgsProcessingParameterEnum) or
                          isinstance(param, QgsProcessingParameterExtent)):
                param.setDefaultValue(parameters[paramName])
        return alg

    def executeStep(self, step):
        if isinstance(step['algorithm'], Grass7Algorithm):
            Grass7Utils.startGrassSession()
        else:
            Grass7Utils.endGrassSession()
        stepDialog = StepDialog(self.prepareStepAlgorithm(step), None,
                                os.path.dirname(self.descriptionFile), False, style=self.style)
        stepDialog.setMode(step['mode'])
        stepDialog.setInstructions(step['instructions'])
        stepDialog.setWindowTitle(
            u"Workflow {workflowname}, Step {stepno} of {nsteps}: {algname}"
            .format(
                workflowname=self.name(),
                stepno=(self._steps.index(step) + 1),
                nsteps=len(self._steps),
                algname=step['algorithm'].name()))
        stepDialog.setWindowIcon(self.icon())
        # set as window modal to allow access to QGIS functions
        stepDialog.setWindowModality(1)
        stepDialog.exec_()
        return stepDialog

    def nextStep(self, step):
        index = self._steps.index(step)
        if index < len(self._steps)-1:
            return (self._steps[index+1])
        else:
            return None

    def previousStep(self, step):
        index = self._steps.index(step)
        if index > 0:
            return (self._steps[index-1])
        else:
            return (self._steps[0])

    def serialize(self):
        s = ".NAME:" + str(self.name) + "\n"
        s += ".GROUP:" + str(self.group) + "\n"

        for step in self._steps:
            s += ".ALGORITHM:" + step['algorithm'].commandLineName() + "\n"
            s += ".PARAMETERS:" + json.dumps(step['parameters']) + "\n"
            s += ".MODE:" + step['mode'] + "\n"
            s += ".INSTRUCTIONS:" + step['instructions']
            if not str(s).endswith("\n"):
                s += "\n"
            s += "!INSTRUCTIONS" + "\n"

        return s

    # Read workflow from text file
    def openWorkflow(self, filename):
        self._steps = list()
        self.descriptionFile = filename
        instructions = False
        lineNumber = 0
        with open(filename, 'r', encoding="utf-8-sig") as fileinput:
            for line in fileinput:
                lineNumber += 1
                line = line.rstrip()
                try:
                    # comment line
                    if line.startswith("#"):
                        pass

                    if line.startswith(".NAME:"):
                        self._name = self.tr(line[len(".NAME:"):])

                    elif line.startswith(".GROUP:"):
                        self._group = self.tr(line[len(".GROUP:"):])
                        self._groupId = line[len(".GROUP:"):].lower().replace(" ", "_")

                    elif line.startswith(".ALGORITHM:"):
                        alg = QgsApplication.processingRegistry().algorithmById(
                                line[len(".ALGORITHM:"):])
                        if alg:
                            self.addStep(alg, NORMAL_MODE, '')
                        else:
                            raise WrongWorkflowException

                    elif line.startswith(".MODE:"):
                        if line[len(".MODE:"):] == NORMAL_MODE:
                            self._steps[-1]['mode'] = NORMAL_MODE
                        elif line[len(".MODE:"):] == BATCH_MODE:
                            self._steps[-1]['mode'] = BATCH_MODE
                        else:
                            raise WrongWorkflowException

                    elif line.startswith(".PARAMETERS:"):
                        try:
                            params = json.loads(line[len(".PARAMETERS:"):])
                        except json.JSONDecodeError:
                            params = None
                        if type(params) == dict:
                            self._steps[-1]['parameters'] = params
                        else:
                            raise WrongWorkflowException

                    elif line.startswith(".INSTRUCTIONS"):
                        instructions = line[len(".INSTRUCTIONS:"):]+"\n"
                        self._steps[-1]['instructions'] = instructions
                        instructions = True

                    elif instructions:
                        if line == "!INSTRUCTIONS":
                            instructions = False
                        elif line == "":
                            self._steps[-1]['instructions'] += "\n"
                        else:
                            self._steps[-1]['instructions'] += line+"\n"

                except WrongWorkflowException:
                    msg = "Error on line number "+str(lineNumber)+": "+line+"\n"
                    raise WrongWorkflowException(msg)
                except Exception as e:
                    raise e

    def name(self):
        return self._name

    def displayName(self):
        return self._name

    def shortDescription(self):
        return self._name

    def group(self):
        return self._group

    def groupId(self):
        return self._groupId

    def flags(self):
        return super().flags() | (QgsProcessingAlgorithm.FlagNoThreading |
                                  QgsProcessingAlgorithm.FlagHideFromModeler &
                                  ~QgsProcessingAlgorithm.FlagSupportsBatch)

    def helpUrl(self):
        return ""

    def helpId(self):
        return ""

    def svgIconPath(self):
        return ""

    def tr(self, string, context=''):
        if context == '':
            context = self.__class__.__name__
        return QCoreApplication.translate(context, string)

    def initAlgorithm(self, config=None):
        pass

    def validateInputCRS(self):
        return True
