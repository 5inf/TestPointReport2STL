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

//testpointdata: signalname, pinname, position, ontop
//can be generated from a csv file using e.g. this excel formula:
//
testpointdata=[
["t1","p1",[-10,-15,-2],true, 0.8],
["t2","p2",[3,4,0],false, 0.8],
["t3","p3",[6,7,2],false, 0.8],,
["t4","p4",[34,10,3],true, 1.8],
["t5","p5",[12,20,0],true, 0.8]
];

minpointheight=10;  //minimum distance of test needle from mounting sheet
maxpointheight=16;  //maximum distance of test needle from mounting sheet
sheetthickness=10;  //thickness of mounting sheet holding the test needles
borderx=10;         //extra width of mounting sheet in x direction
bordery=20;         //extra width of mounting sheet in y direction

showpcb = false;    //load a pcb 3d model specified by pcb path
pcbpath="";         //path to loadable pcb file (stl format only)

showpcbdummy = true; //show a dummy pcb model
showtestpads = true; //show the test pad locations
pcbthickness=1.6;   //thickness of the (dummy) PCB


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
/////////////// DO NOT EDIT BELOW ////////////////////////
//////////////////////////////////////////////////////////

span=maxpointheight-minpointheight;

pointstop=[for(v=testpointdata)if(v[3])v];
echo(pointstop);

pointsbottom=[for(v=testpointdata)if(!v[3])v];
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

//dummy PCB
if(showpcbdummy){
    translate([minx-5,miny-5,0]){
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
        translate([point[2][0],point[2][1],pcbthickness/2])cylinder(d=point[4],h=0.1);
        }
    for(point=pointsbottom){
        color("Gold")
        translate([point[2][0],point[2][1],-pcbthickness/2-0.1])cylinder(d=point[4],h=0.1);
        }
    }
}

if(maxdisttop>span){
    echo("ERROR: Span to high");
}else{
//the top holder and test pins
    translate([0,0,pcbthickness/2])
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

        for(point=pointstop){
            translate([point[2][0],point[2][1],point[2][2]]){
                testpin(ontop=true);
            }
        }
    }
}

if(maxdistbottom>span){
    echo("ERROR: Span on bottom to high");
}else{
    //the bottom holder and testpins
    translate([0,0,-pcbthickness/2])
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

        for(point=pointsbottom){
            translate([point[2][0],point[2][1],-point[2][2]])
                testpin(ontop=false);
        }
    }
}



//models the actual pinhead/needle
module needle(type="default"){
    color("Gold")
    translate([0,0,2])cylinder(h=30-2,d=0.635,center=false);
    if(type=="bla"){
        cylinder(h=2,d1=0,d2=0.635,center=false);
    }else{
        cylinder(h=1,d1=2,d2=2,center=false);
        cylinder(h=2,d1=0.635,d2=0.635,center=false);
    }
}

//models the outer sheath of the test pin
module sheath(type="defaut"){
    color("Gray")
    if(type=="bla"){
        translate([0,0,6])cylinder(h=25,d=1.02,center=false);
    }else{
        translate([0,0,6])cylinder(h=25,d=1.02,center=false);
    }
}
//models the complete test pin
module testpin(ontop=true){
       $fs=0.3;
    rotate([0,ontop?0:180,0]){
        needle();
        sheath();
    }
}

//models the hole that gets drilled through the sheet
module pinhole(){
   $fs=0.3;
   cylinder(h=1000,d=1.35,center=true);     
}
