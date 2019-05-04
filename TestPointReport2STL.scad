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

testpointdata=[
/* paste testpoint data here */
["GND","T13-1",[18.2118,11.7856,1],"Bottom", 0, "075-PRP259RS-S"],
["+5.0V","T1-1",[23.8252,25.1206,1],"Bottom", 0, "075-PRP259RS-S"],
["NetJ1_1","T2-1",[29.4386,34.925,1],"Bottom", 0, "075-PRP259RS-S"],
["GND","T3-1",[10.3124,25.527,5],"Bottom", 0, "075-PRP259RS-S"],
["SDA","T4-1",[29.464,33.3502,5],"Top", 0, "075-PRP259RS-S"],
["SCL","T5-1",[26.793,32.428,1],"Top", 0, "075-PRP259RS-S"],
["-5.0V","T6-1",[31.6774,9.1419,1],"Bottom", 0, "075-PRP259RS-S"],
["","M4",[5,5,0],"Both", 3.2, "Mounting"],
["","M3",[5,35,0],"Both", 3.2, "Mounting"],
["","M2",[35,5,0],"Both", 3.2, "Mounting"],
["","M1",[35,35,0],"Both", 3.2, "Mounting"],
/* end of paste testpoint data here */
];

//Parameters for the simple rectangular testpoint holder block
buildtop=true; //build fixture for needles for top testpoints
buildbottom=true; //build fixture for needles for top testpoints
borderx=20;         //extra width of mounting sheet in x direction
bordery=10;         //extra width of mounting sheet in y direction
sheetthickness=10;  //thickness of mounting block holding the test probes

//Advanced model generation
showpins=true; //show the actual testpins
initialpindistance=1; //the initial distance of the pins from the surface of the pcb

drawmountingsystem=false;     //Generate mounting plates

showpcb = false;    //load a pcb 3d model specified by pcb path below
pcbpath="";         //path to loadable pcb file (note: OpenSCAD supports stl format only)
showpcbdummy = true; //show a dummy pcb model
showtestpads = true; //show the test pad locations on the dummy pcb as a simple cylinder shape
pcbthickness=1.6;   //thickness of the (dummy) PCB

//Animation options
movementdistance=5; //distance of movement of the pcb under test towards the bottom holder. The top holder moves twice as far.

//Data specific to the default QATech.com 075-SDN250S/075-PRP259RS-S test needles 
minpointheight=8.128;  //minimum distance of test needle tip from where it is mounted
maxpointheight=14.732;  //maximum distance of test needle tip from where it is mounted

//////////////////////////////////////////////////////////
/////////////// DO NOT EDIT BELOW ////////////////////////
//////////////////////////////////////////////////////////
timeoffset=initialpindistance/movementdistance;

span=maxpointheight-minpointheight;

pointstop=[for(v=testpointdata)if(v[3]!="Bottom")v];
echo(pointstop);

pointsbottom=[for(v=testpointdata)if(v[3]!="Top")v];
echo(pointsbottom);

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
            WAMMountingTop(zpos=maxtop+span);
    }
    //draw top bcb holder (this holder is optional as one option to hold down the pcb.)
    translate([0,0,-$t*movementdistance]){
        WAMMountingMiddle(zpos=+(-1.6+5)/2);
    }
    //draw bottom pcb holder
    translate([0,0,-$t*movementdistance]){
        WAMMountingMiddle(zpos=-(1.6+5)/2);
    }
    //draw bottom block with interconnect pcb
    WAMMountingBottom(zpos=-maxbottom-span-7);
}

//center testpoints arround origin
translate([-(minx+maxx)/2,-(maxy+miny)/2,0]){
    
    //dummy PCB
    translate([0,0,-$t*movementdistance]){
        if(showpcbdummy){
            translate([minx-5,miny-5,-pcbthickness/2]){
                    color("Green",alpha=0.4)
                    cube([maxx-minx+10,maxy-miny+10,pcbthickness],center=false);
                }
        }
        //external pcb model
        if(showpcb){
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
                    translate([minx-borderx,miny-bordery,maxtop+span]){
                        color("red",alpha=0.5)
                        cube([maxx-minx+2*borderx,maxy-miny+2*bordery,sheetthickness],center=false);
                    }
                    for(point=pointstop){
                        translate([point[2][0],point[2][1],0]){
                            pinhole();
                        }
                    }
                }

                if(showpins){
                    for(point=pointstop){
                        translate([point[2][0],point[2][1],point[2][2]]){
                            testpin(ontop=true,inset=point[2][2],tip=point[5]);
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
                    translate([minx-borderx,miny-bordery,-maxbottom-span-10]){
                        color("blue",alpha=0.5)
                        cube([maxx-minx+2*borderx,maxy-miny+2*bordery,sheetthickness],center=false);
                    }
                    for(point=pointsbottom){
                        translate([point[2][0],point[2][1],0]){
                            pinhole();
                        }
                    }
                }
                if(showpins){
                    for(point=pointsbottom){
                        translate([point[2][0],point[2][1],-point[2][2]])
                            testpin(ontop=false,inset=point[2][2],tip=point[5]);
                    }
                }
            }
        }
    }
}

//models the complete test pin
module testpin(ontop=true,inset=0,tip=""){
    $fs=0.3;
    delay=timeoffset+inset/movementdistance;
    rotate([0,ontop?0:180,0]){
        //needle();
        //sheath();
        translate([0,0,$t>delay?($t-delay)*movementdistance:0])probe(tip=tip);
        socket();
    }
}

//models the hole that gets drilled through the sheet
module pinhole(){
   $fs=0.3;
   cylinder(h=1000,d=1.35,center=true);     
}

module probe(tip=""){
   //Probe QATech.com 075-PRP259RS-S 
   $fs=0.1;
   if(tip=="075-PRP259RS-S"){
       color("Gold")
       translate([0,0,0])cylinder(h=2,d1=0,d2=0.64,center=false);
       //shaft 
       color("Gold")
       translate([0,0,2])cylinder(h=7.62,d=0.64,center=false);
   }else{//Default
       color("Blue")
       translate([0,0,-0.5])cylinder(h=0.5,d1=2,d2=3,center=false);
       color("Red")
       translate([0,0,0])cylinder(h=2,d1=3.5,d2=0.64,center=false);
       //shaft 
       color("Red")
       translate([0,0,2])cylinder(h=7.62,d=0.64,center=false);
   }
}

module socket(){
   //Socket QATech.com 075-SDN250S   
   $fs=0.1;
   color("Gray")
   translate([0,0,8.62])cylinder(h=33.2-7.62,d=1.021,center=false);     
}

module WAMMountingTop(zpos=0){
    //WA-AP-100 pressure plate / Andruckplatte
    //TODO: correct hole positions
    translate([0,0,zpos+7]){
    difference(){
        color("White",alpha=0.2)
        cube([190,110,10], center=true);
        translate([90,-50,0])cylinder(d=1.6,h=10,center=true);
        translate([90,0,0])cylinder(d=1.6,h=10,center=true);
        translate([90,50,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,-50,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,0,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,50,0])cylinder(d=1.6,h=10,center=true);
        translate([0,-20,0])cylinder(d=1.6,h=10,center=true);
        translate([0,20,0])cylinder(d=1.6,h=10,center=true);
    }
    //interconnect pcb
    translate([0,0,(10+1.6)/2])color("Green")cube([160,100,1.6], center=true); 
    // push rods  
    translate([-80,50,-22]){cylinder(d=8,h=22);}
    translate([80,50,-22]){cylinder(d=8,h=22);}
}
}

module WAMMountingMiddle(zpos=0){
    //WA-PAP-100 mounting plate / Prüflingsauflageplatte
    //TODO: correct hole positions
    //Comes with a dummy coutout as hole. Adjust this cutout according to the actual pcb outline
    translate([0,0,zpos+1.6])color("MediumSlateBlue",alpha=0.2)
    difference(){
        cube([190,110,5], center=true);
        //dummy pcb cutout
        translate([0,0,zpos])cube([38,38,6], center=true);
        translate([0,0,zpos+4])cube([40.5,40.5,2], center=true);
        
        //mounting holes
        translate([80,50,0])cylinder(d=10,h=10,center=true);
        translate([-80,50,0])cylinder(d=10,h=10,center=true);
        
        translate([90,-5,0])cylinder(d=3,h=10,center=true);
        translate([90,-25,0])cylinder(d=3,h=10,center=true);
        translate([90,-45,0])cylinder(d=3,h=10,center=true);
        translate([-90,-5,0])cylinder(d=3,h=10,center=true);
        translate([-90,-25,0])cylinder(d=3,h=10,center=true);
        translate([-90,-45,0])cylinder(d=3,h=10,center=true);
        
        translate([90,20,0])cylinder(d=1.6,h=10,center=true);
        translate([90,10,0])cylinder(d=1.6,h=10,center=true);
        translate([90,0,0])cylinder(d=1.6,h=10,center=true);
        translate([90,-10,0])cylinder(d=1.6,h=10,center=true);
        translate([90,-20,0])cylinder(d=1.6,h=10,center=true);
        translate([90,-30,0])cylinder(d=1.6,h=10,center=true);
        translate([90,-40,0])cylinder(d=1.6,h=10,center=true);
        translate([90,-50,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,20,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,10,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,0,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,-10,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,-20,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,-30,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,-40,0])cylinder(d=1.6,h=10,center=true);
        translate([-90,-50,0])cylinder(d=1.6,h=10,center=true);
    }
}

module WAMMountingBottom(zpos=0){
    //WA-M-1200 contact plate / Kontaktträgerplatte
    //TODO: correct hole positions
    translate([0,0,zpos]){
        difference(){
            color("Cornsilk")cube([190,110,10], center=true);
            translate([90,-5,0])cylinder(d=3,h=10,center=true);
            translate([90,-25,0])cylinder(d=3,h=10,center=true);
            translate([90,-45,0])cylinder(d=3,h=10,center=true);
            translate([-90,-5,0])cylinder(d=3,h=10,center=true);
            translate([-90,-25,0])cylinder(d=3,h=10,center=true);
            translate([-90,-45,0])cylinder(d=3,h=10,center=true);
       
            translate([90,20,0])cylinder(d=1.6,h=10,center=true);
            translate([90,10,0])cylinder(d=1.6,h=10,center=true);
            translate([90,0,0])cylinder(d=1.6,h=10,center=true);
            translate([90,-10,0])cylinder(d=1.6,h=10,center=true);
            translate([90,-20,0])cylinder(d=1.6,h=10,center=true);
            translate([90,-30,0])cylinder(d=1.6,h=10,center=true);
            translate([90,-40,0])cylinder(d=1.6,h=10,center=true);
            translate([90,-50,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,20,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,10,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,0,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,-10,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,-20,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,-30,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,-40,0])cylinder(d=1.6,h=10,center=true);
            translate([-90,-50,0])cylinder(d=1.6,h=10,center=true);
            
            translate([-30,-50,0])cylinder(d=3.2,h=10,center=true);
            translate([30,-50,0])cylinder(d=3.2,h=10,center=true);
            translate([-30,50,0])cylinder(d=3.2,h=10,center=true);
            translate([30,50,0])cylinder(d=3.2,h=10,center=true);
        }
        //interconnect pcb
        translate([0,0,-(10+1.6)/2])color("Green")cube([160,100,1.6], center=true); 
        //guiding rods
        guidingRod([-90,-45,-2-(10+1.6)/2]);
        guidingRod([-90,45,-2-(10+1.6)/2]);
        guidingRod([90,-45,-2-(10+1.6)/2]);
        guidingRod([90,45,-2-(10+1.6)/2]);
        //bottom pcb holder distance spring rods
        distanceSpringRod([-88,-50,-1-(10+1.6)/2]);
        distanceSpringRod([88,-50,-1-(10+1.6)/2]);
        distanceSpringRod([88,50,-1-(10+1.6)/2]);
        distanceSpringRod([-88,50,-1-(10+1.6)/2]);
    }
}

module distanceSpringRod(pos=[0,0,0]){
    translate(pos){
        color("DimGray")translate([0,0,-2])cylinder(d=3,h=15);
        translate([0,0,-$t*movementdistance]){
            color("Gold")translate([0,0,19.5])cylinder(d=3,h=2);
            color("Gold")translate([0,0,10])cylinder(d=1,h=10);
        }
    }
}
module guidingRod(pos=[0,0,0]){
    translate(pos){
        color("Black")translate([0,0,0])
            cylinder(d=3,h=25);
        }
}