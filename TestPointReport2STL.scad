/*  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <https://www.gnu.org/licenses/>.
*/

/*
An OpenSCAD script to convert a csv file containing a pcb test point report - generated e.g. from Altium Designer, KiCAD, Eagle or any other PCB design software - into a 3D model of a holder for mounting test probes for electrical tests.

Documentation and the latest version of this script can be found at: https://raw.githubusercontent.com/5inf/TestPointReport2STL

*/

//////////////////////////////////////////////////////////
//////////////// CONFIGURE BELOW//////////////////////////
//////////////////////////////////////////////////////////

//data of testpoints
/* [test point data] */
/*testpointdata=
1. Signal name (currently ignored)
2. Testpoint name (currently ignored)
3. [posx,posy,posz]
3.1 posx: Xposition of the testpoint
3.2 posy: yposition of the testpoint
3.3 posz: Initilial distance oft the probe tip above (or below) the pcb surface 
4. Orientation: "Top", "Bottom", "Both"
5. Testpad Diameter in mm (for visualization only)
6. ProbeTip, see list in testprobe.scad for available Tips (default if empty: QATech.com 075-PRP259RS-S)
7. ProbeSheet (this also defines the drill size for the holes in the block); See list in testprobe.scad for available tips (default if empty: QATech.com socket 075-SDN250S with a hole diameter of 1.35mm)
*/
testpointdata=[
/* paste testpoint data here */
["GND", "T13-1", [8.2118,11.7856,0], "Bottom", 0, "075-PRP259RS-S", "075-SDN250S"],
["+5.0V", "T1-1", [23.8252,25.1206,0], "Bottom", 0, "075-PRP259RS-S", "075-SDN250S"],
["NetJ1_1", "T2-1", [29.4386,34.925,0], "Bottom", 0, "075-PRP259RS-S", "075-SDN250S"],
["GND", "T3-1", [10.3124,25.527,0], "Bottom", 0, "075-PRP259RS-S", "075-SDN250S"],
["SDA", "T4-1", [29.464,33.3502,0], "Top", 0, "075-PRP259RS-S", "075-SDN250S"],
["SCL", "T5-1", [26.793,32.428,0], "Top", 0, "075-PRP259RS-S", "075-SDN250S"],
["-5.0V", "T6-1", [31.6774,9.1419,0], "Bottom", 0, "075-PRP259RS-S", "075-SDN250S"],
["", "M4", [5,5,0], "Both", 0, "", ""],
["", "M3", [5,35,0], "Both", 0, "", ""],
["", "M2", [35,5,0], "Both", 0, "", ""],
["", "M1", [35,35,0], "Both", 0, "", ""]
/* end of paste testpoint data here */
];

//Parameters for the simple rectangular testpoint holder block
/* [Simple] */
//build fixture for needles for top testpoints
buildtop=true;
//build fixture for needles for top testpoints
buildbottom=true;
//shall the block be a fixed size or defined by the required space + borderx/bordery
fixedsize=true;
//size of block in x direction if fixedsize=true
sizex=50;
//size of block in y direction if fixedsize=true
sizey=50;
//extra width of mounting sheet in x direction if fixedsize=false
borderx=5;
//extra width of mounting sheet in y direction fixedsize=false
bordery=5;

//thickness of mounting block holding the test probes
sheetthickness=10;

//Advanced model generation
/* [Visual] */
//show the actual testpins
showpins=false;
//the initial distance of the pins from the surface of the pcb
initialpindistance=1;

//Generate mounting plates
drawmountingsystem=false;
//include the holder for the pcb top side
includebottompcbholder=false;
//include a second holder for the pcb top side
includetoppcbholder=false;

//load a pcb 3d model specified by pcb path below
show3dpcb = false;
//load a pcb 2d outline of the pcb from the pcb path spedified below
show2dpcb = false;
//path to loadable pcb file (note: OpenSCAD supports stl format only)
pcbpath="";
//show a dummy pcb model
showpcbdummy = false;
//show the test pad locations on the dummy pcb as a simple cylinder shape
showtestpads = false; //show the test pad locations on the dummy pcb as a simple cylinder shape
//thickness of the (dummy) PCB
pcbthickness=1.6;

//Animation options
/* [Animation] */
//distance of movement of the pcb under test towards the bottom holder. The top holder moves twice as far.
movementdistance=5;

/* [Hidden] */
//Data specific to the default QATech.com 075-SDN250S/075-PRP259RS-S test needles
//minimum distance of test needle tip from where it is mounted
minpointheight=0;
//maximum distance of test needle tip from where it is mounted
maxpointheight=6.35;

//reduce to 2d for dxf export
dxfexport=false;

//////////////////////////////////////////////////////////
/////////////// DO NOT EDIT BELOW ////////////////////////
//////////////////////////////////////////////////////////

use <testprobe.scad>
use <WAMMounting.scad>

timeoffset=initialpindistance/movementdistance;

span=maxpointheight-minpointheight;

pointstop=[for(v=testpointdata)if(v[3]!="Bottom")v];
//echo(pointstop);

pointsbottom=[for(v=testpointdata)if(v[3]!="Top")v];
//echo(pointsbottom);

maxx=max([for(v=testpointdata)v[2][0]]);
minx=min([for(v=testpointdata)v[2][0]]);
maxy=max([for(v=testpointdata)v[2][1]]);
miny=min([for(v=testpointdata)v[2][1]]);

maxtop=max([for(v=pointstop)v[2][2]]);
mintop=min([for(v=pointstop)v[2][2]]);
maxbottom=max([for(v=pointsbottom)v[2][2]]);
minbottom=min([for(v=pointsbottom)v[2][2]]);

maxdisttop=maxtop-mintop;
maxdistbottom=maxbottom-minbottom;

if(dxfexport){
    showpins=false;
    includetoppcbholder=false;
    showpcb = false;
    showpcbdummy = false;
    projection(){all();}
}else{
    all();
}

module all(){

if(movementdistance>initialpindistance+span){
    echo ("ERROR: moving to far. Pins and setup might get damaged!");
}
if(movementdistance<initialpindistance+maxdisttop){
    echo ("ERROR: moving not far enough. Top pins might not all connect!");
}
if(movementdistance<initialpindistance+maxdistbottom){
    echo ("ERROR: moving not far enough. Bottom pins might not all connect!");
}

if(drawmountingsystem){
    //draw top block with interconnect pcb

    translate([0,0,-2*$t*movementdistance]){
        //WAMMountingTop(zpos=maxtop+span+2);
    }
    //draw top bcb holder (this holder is optional as one option to hold down the pcb.)
    if(includetoppcbholder){
    translate([0,0,-$t*movementdistance]){
        WAMMountingMiddle(zpos=+(-1.6+5)/2);
    }
}
    //draw bottom pcb holder
    if(includebottompcbholder){
        translate([0,0,-$t*movementdistance]){
            WAMMountingMiddle(zpos=-(1.6+5)/2);
        }
    }
    //draw bottom block with interconnect pcb
    //WAMMountingBottom(zpos=-maxbottom-span-9,movementdistance=movementdistance);
}


//center testpoints arround origin
translate([-(minx+maxx)/2,-(maxy+miny)/2,0]){
//cylinder(r=1,h=200);
//  translate([minx,miny,0])cylinder(r=1,h=200);
//  translate([maxx,maxy,0])cylinder(r=1,h=200);
    //dummy PCB
    translate([0,0,-$t*movementdistance]){
        if(showpcbdummy){
            translate([minx-5,miny-5,-pcbthickness/2]){
                    color("Green",alpha=0.4)
                    cube([maxx-minx+10,maxy-miny+10,pcbthickness],center=false);
                }
        }
        //external pcb model
        if(show3dpcb){
            import(pcbpath);
        }
        if(show2dpcb){
            //import("test2.dxf");
            import(pcbpath);
        }
        //testpads
        if(showtestpads){
            union(){
                $fs=0.3;
            for(point=pointstop){
                color("Gold")
                translate([point[2][0],point[2][1],pcbthickness/2]){
                    difference(){
                        cylinder(d=point[4]+0.4,h=0.1);
                        translate([0,0,-1])cylinder(d=point[4],h=3);
                    }
                }
                }
            for(point=pointsbottom){
                color("Gold")
                translate([point[2][0],point[2][1],-pcbthickness/2-0.1]){
                    difference(){
                        cylinder(d=point[4]+0.4,h=0.1);
                        translate([0,0,-1])cylinder(d=point[4],h=3);
                    }
                }
                }
            }
        }
    }
    if(buildtop && !(pointstop==[])){
        if(maxdisttop>span){
            echo("ERROR: Span on top to high", span, maxdistbottom);
        }else{
            translate([0,0,-2*$t*movementdistance]){
        //the top holder and test pins
            translate([0,0,pcbthickness/2+initialpindistance])
            union(){
                difference(){
                    if(!drawmountingsystem){
                      if(fixedsize){
                        translate([-sizex/2+(minx+maxx)/2,(miny+maxy)/2-sizey/2,maxtop+span+2]){
                        color("red",alpha=0.5)
                        cube([sizex,sizey,sheetthickness],center=false);}
                      }else{
                        translate([minx-borderx,miny-bordery,maxtop+span+2]){
                        color("red",alpha=0.5)
                        cube([maxx-minx+2*borderx,maxy-miny+2*bordery,sheetthickness],center=false);}
                      }
                    }else{
                      translate([+(minx+maxx)/2,+(maxy+miny)/2,0]){
                        WAMMountingTop(zpos=maxtop+span+2);
                    }}
                    for(point=pointstop){
                        translate([point[2][0],point[2][1],0]){
                            pinhole(socket=point[6]);
                        }
                    }
                }

                if(showpins){
                    for(point=pointstop){
                        translate([point[2][0],point[2][1],point[2][2]]){
                            testpin(ontop=true,inset=point[2][2]+initialpindistance,probe=point[5],socket=point[6],movementdistance=movementdistance);
                        }
                    }
                }
            }
        }
    }
    }

    if(buildbottom && !(pointsbottom==[])){
        if(maxdistbottom>span){
            echo("ERROR: Span on bottom to high", span, maxdistbottom);
        }else{
            //the bottom holder and testpins
            translate([0,0,-pcbthickness/2-initialpindistance])
            union(){
                difference(){
                    if(!drawmountingsystem){
                      if(fixedsize){
                    translate([(minx+maxx)/2-sizex/2,(miny+maxy)/2-sizey/2,-maxbottom-span-12]){
                        color("blue",alpha=0.5)
                        cube([sizex,sizey,sheetthickness],center=false);
                    }}else{
                        translate([minx-borderx,miny-bordery,-maxbottom-span-12]){
                        color("blue",alpha=0.5)
                        cube([maxx-minx+2*borderx,maxy-miny+2*bordery,sheetthickness],center=false);
                      }}
                    }else{
                    translate([+(minx+maxx)/2,+(maxy+miny)/2,0]){
                    WAMMountingBottom(zpos=-maxbottom-span-9,movementdistance=movementdistance);
                    }
                    }
                    for(point=pointsbottom){
                        translate([point[2][0],point[2][1],0]){
                            pinhole(socket=point[6]);
                        }
                    }
                }
                if(showpins){
                    for(point=pointsbottom){
                        translate([point[2][0],point[2][1],-point[2][2]])
                            testpin(ontop=false,inset=point[2][2]+initialpindistance,probe=point[5],socket=point[6],movementdistance=movementdistance);
                    }
                }
            }
        }
    }
}
}
