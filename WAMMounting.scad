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
translate([0,0,40])WAMMountingTop();
translate([0,0,18])WAMMountingMiddle();
translate([0,0,0])WAMMountingBottom();


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
        translate([0,0,0])cube([38,38,5], center=true);
        translate([0,0,+2.5-1.6/2])cube([40.5,40.5,1.6], center=true);
        
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

module WAMMountingBottom(zpos=0,movementdistance=0){
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
        distanceSpringRod([-88,-50,-1-(10+1.6)/2],movementdistance=movementdistance);
        distanceSpringRod([88,-50,-1-(10+1.6)/2],movementdistance=movementdistance);
        distanceSpringRod([88,50,-1-(10+1.6)/2],movementdistance=movementdistance);
        distanceSpringRod([-88,50,-1-(10+1.6)/2],movementdistance=movementdistance);
    }
}

module distanceSpringRod(pos=[0,0,0],movementdistance=0){
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