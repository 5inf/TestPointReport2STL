# TestPointReport2STL
This is an OpenSCAD script to convert a csv file containing a PCB test point report - generated e.g. from Altium Designer, KiCAD, Eagle or any other PCB design software - into a 3D model of a holder for mounting test probes for electrical tests.

In its simplest form the output is a rectangular block with holes for mounting the test probes into. The script generates one block for top (in red) and one for bottom (in blue), with a size enclosing the test point positions plus any extra space defined by borderx and bordery.
These two blocks can then be manufactured e.g. by 3D printing or any other means.

Optional test probes can be displayed (showpins=true), as well as a complete test fixture can be generated (drawmountingsystem=true).
The default test probe geometry corresponds to QATech.com probe 075-PRP259RS-S and sockets 075-SDN250S, see https://www.qatech.com/downloads/075-25/075-25_Catalog.pdf.
The test fixture is based on the WA-M-1200 fixture by GPS-Prüftechnik GmbH with the WA-AP-100 pressure plate, WA-PAP-100 mounting plate and WA-M-1200 contact plate. The exact model of the test fixture is however still work in progress. For details on the mounting system used see https://www.gps-prueftechnik.de/_downloads_DE/WA-M-12xx.pdf.

All dimensions used by the script are metric.

## Test point data representation
The test point data is represented as list, implemented as a multidimensional OpenSCAD vector named testpointdata.


    testpointdata = [
    ["signal name 1", "test point name 1", [position x, y, z], "on side", test pad hole diameter, "test probe type"],
    ["signal name 2", "test point name 2", [position x, y, z], "on side", test pad hole diameter, "test probe type"],
    ...
    ]


The list entries are as follows:
- "signal name" is the name of the signal the test point connects to. The entry is not (yet) used.
- "test point name" is the name of the test point.  The entry is not (yet) used.
- "[position x, y and z]" is a vector of the location of the test pad to connect to. The z-position value can be used to allow some of the needles to connect before others. E.g. a value of 1 has the corresponding pin 1 mm higher above the PCB thus connecting later.
- "on side" can be "Top", "Bottom" or "Both", depending on whether the test probe for the pad shall be located on top, bottom or both sides.
- "test pad hole diameter" is the diameter of the hole for a through hole test pad. If test pads are to be shown (showtestpads=true) this value is expanded by 0.1 mm to draw the pad.
- "test probe type" is the specification of the test needle shape. An empty string results in the (imaginary) default probe being used.

The currently implemented probe types are:
- QATech 050-PTP2540S
- QATech 050-PTP2541S
- QATech 050-PRP2540S
- QATech 050-PRP2541S
- QATech 075-PRP2501S
- QATech  075-PRP2510S
- QATech 075-PRP2520S
- QATech 075-PRP2540S
- QATech 075-PRP259RS-S (default)

The currently implemented sockets are:
- QATech 050-SRB255P
- QATech 050-STB255P
- QATech 075-SDN250S (default)

The script is not (yet) testing whether probes and socket match.

## Convert test point data from a csv file
The entries for the testpointdata vector can easily be generated from a csv file using e.g. the Microsoft Excel formula below. The columns expected in the csv file for the below formula are as follows:

    A: Signal name
    B: Test point name
    C: x-pos in mm, ending in mm
    D: y-pos in mm, ending in mm
    E: Test point orientation, either "Top", "Bottom" or "Both".
    F: Test pad diameter
    G: Test probe type

Formula for English language Excel:

    ="["""&A2&""","""&B2&""",["&LEFT(C2;LENGTH(C2)-2)&","&LEFT(D2;LENGTH(D2)-2)&",0],"&E2&", "&F2&","&G2&"],"

Formula for German language Excel:

    ="["""&A2&""","""&B2&""",["&LINKS(C2;LÄNGE(C2)-2)&","&LINKS(D2;LÄNGE(D2)-2)&",0],"&E2&", "&F2&","&G2&"],"

Copy these formula in a cell behind each column with test point data, starting with row number two. If the data in your csv file is somewhat different this approach should still be easily adapted.

If you are on Linux or don't like Excel below is an awk script doing the same:

      awk -F";" 'NR > 1 {printf "[\"%s\", \"%s\", [%s,%s,0], \"%s\", %s, \"%s\", \"%s\"],\n",$1,$2,substr($3, 1, length($3)-2),substr($4, 1, length($4)-2),$5,$6,$7,$8}' testpointdata.csv

Or if it is a "real" csv (split character is ",") then:

    awk -F"," 'NR > 1 {printf "[\"%s\", \"%s\", [%s,%s,0], \"%s\", %s, \"%s\", \"%s\"],\n",$1,$2,substr($3, 1, length($3)-2),substr($4, 1, length($4)-2),$5,$6,$7,$8}' testpointdata.csv

This awk script also available as a shell script in the file testpointformat.sh.

## Animation
The script supports OpenSCAD animation for a rough estimate of how the test pins will connect.
The absolute positions of the surrounding test fixture is however not (yet) fully correct, depending on the test pin data and thus collisions will appear.

If you want to get a STEP file directly instead of an STL file it is easiest to run this code in FreeCAD as an element in the OpenSCAD workspace. Then export the resulting model directly as STEP from there. Alternatively open the generated STL file in any suitable CAD software and convert it to STEP.

Documentation and the latest version of this script can be found at: https://raw.githubusercontent.com/5inf/TestPointReport2STL/

Ideas, improvements and bugfixes are welcome.

Enjoy!
