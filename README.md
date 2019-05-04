# TestPointReport2STL
This is an OpenSCAD script to convert a csv file containing a pcb test point report - generated e.g. from Altium Designer, KiCAD, Eagle or any other PCB design software - into a 3D model of a holder for mounting test probes for electrical tests.

In its simplest form the output is a rectangular block with holes for mouting the test probes into. The script generates one block for top (in red) and one for bottom (in blue), with a size enclosing the testpoint positions plus any extra space defined by borderx and bordery.
These two blocks can then be manufactured e.g. by 3D printing or any other means.

Optional testprobes can be displayed (showpins=true), as well as a complete test fixture can be generated (drawmountingsystem=true).
The default test probe geometry corresponds to QATech.com needles 075-PRP259RS-S and sheats 075-SDN250S.
The test fixture is based on the WA-M-1200 fixture by GPS-Prüftechnik GmbH with the WA-AP-100 pressure plate, WA-PAP-100 mounting plate and WA-M-1200 contact plate. The exact model of the test fixture is however still work in progress. For details on the mouting system used see https://www.gps-prueftechnik.de/_downloads_DE/WA-M-12xx.pdf.

All dimensions used by the script are metric.

## Test point data representation
The test point data is represented as list, implemented as a multidimensional OpenSCAD vector named testpointdata.
testpointdata = [
["signal name 1", "test point name 1", [position x, y, z], "on side", testpad hole diameter, "test probe type"],
["signal name 2", "test point name 2", [position x, y, z], "on side", testpad hole diameter, "test probe type"],
...
]

The list entries are as follows:
- "signal name" is the name of the signal the test point connects to. The entry is not (yet) used.
- "testpoint name" is the name of the test point.  The entry is not (yet) used.
- "[position x, y and z]" is a vector of the location of the testpad to connect to. The z-position value can be used to allow some of the needles ot connect before others. E.g. a value of 1 has the corresponding pin 1 mm higher above the pcb thus connecting later.
- "on side" can be "Top", "Bottom" or "Both", depending on whether the test probe for the pad shall be located on top, bottom or both sides.
- "testpad hole diameter" is the diameter of the hole for a through hole testpad. If tespads are to be shown (showtestpads=true) this value is expanded by 0.1 mm to draw the pad.
- "test probe type" is the specification of the test needle shape. An empty string results in the default probe beeing used. So far only an (imaginary) default probe and the QATech 075-PRP259RS-S probe are implemented.

## Convert test point data from a csv file
The entries for the testpointdata vector can easily be generated from a csv file using e.g. the Microsoft Excel formula below. The columns expected in the csv file for the below forumla are as follows.
A: Signal name
B: Test point name
C: x-pos in mm, ending with mm
D: y-pos in mm, ending with mm
E: Test point orientation, either "Top", "Bottom" or "Both".
F: Test pad diameter
G: Test probe type

Formula for english language Excel:
="["""&A2&""","""&B2&""",["&LEFT(C2;LENGTH(C2)-2)&","&LEFT(D2;LENGTH(D2)-2)&",0],"&E2&", "&F2&","&G2&"],"
Formula for german language Excel:
="["""&A2&""","""&B2&""",["&LINKS(C2;LÄNGE(C2)-2)&","&LINKS(D2;LÄNGE(D2)-2)&",0],"&E2&", "&F2&","&G2&"],"

Copy these formula in a cell behind the column

## Animation
The script supports OpenSCAD annimation for a rough estimate of how the tetspins will connect.
The absolute positions of the surrounding test fixture is however not (yet) fully correct, depending on the testpin data and thus collisions will appear.

If you want to get a STEP file directly instead of an STL file it is easiest to run this code in FreeCAD as an element in the OpenSCAD workspace. Then export the resulting model directly as STEP from there. Alternatively open the generated STL file in any suitable CAD software and convert it to STEP.

Documentation and the latest version of this script can be found at: https://raw.githubusercontent.com/5inf/TestPointReport2STL/

Ideas, improvements and bugfixes are welcome.

Enjoy!



