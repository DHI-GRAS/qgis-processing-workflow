Processing-Workflow
===================

Plugin for QGIS Processing Toolbox for creating processing workflows. The workflows provide step-by-step instructions and guidance for less experienced users thus facilitating capacity building in Earth observation data analysis and GIS tasks.

After installing and activating the plugin, it also needs to be activated in Processing options which are accessible from QGIS main menu (Processing > Options and configuration). The path to the directory where the workflow files are stored (by default in the plugin directory) can also be set:

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/activate.png)

After the activation the workflow library can be accessed through the Processing Toolbox and also from an icon on the QGIS task bar:

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/location.png)

A workflow consists of a number of steps, with each step having an instruction pane on the left and the algorithm window on the right. After a step execution is started (by pressing the Run button) and completed, the next step will automatically open. It is also possible to skip steps without execution and go back to previous steps by using the buttons at the bottom of the workflow dialog:

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/workflow.png)

New workflows can be easily added by using the Workflow Creator which can be accessed from the Processing Toolbox (Workflows > Tools > Create new workflow). Existing workflows can also be edited by right clicking on them and selecting Edit workflow: 

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/edit.png)

In the Workflow Creator new algorithms can be added to a workflow by double clicking on any algorithm in the list on the left. All algorithms available in the Processing Toolbox, including models and scripts, can be added to a workflow. To remove an algorithm from a workflow the Remove step at the bottom of the dialog should be used. The order of the algorithms can be changed by dragging the tabs with algorithm names at the top of the dialog. To save a workflow its name and group should be entered at the top of the dialog and the save button clicked. Workflows are saved in a text file which contains information on the number and order of steps, the instructions for each step and any pre-set values of numeric, text, drop-down list or boolean algorithm parameters. The workflows can also be tested before saving by using the Test button.

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/creator.png)

This plugin is part of the Water Observation Information System (WOIS) developed under the TIGER-NET project funded by the European Space Agency as part of the long-term TIGER initiative aiming at promoting the use of Earth Observation (EO) for improved Integrated Water Resources Management (IWRM) in Africa. 

Copyright (C) 2014 TIGER-NET (www.tiger-net.org)
