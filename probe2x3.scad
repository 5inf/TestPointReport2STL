use <testprobe.scad>

$fs=0.05;
movementdistance=5;
timeoffset=0;
delay=0.25;

translate([-1.27,1.27/2,-1])testpin(ontop=true,inset=1,movementdistance=2,probe="075-PRP259RS-S",socket="075-SDN250S");
translate([0,1.27/2,-1])testpin(ontop=true,inset=1,movementdistance=2,probe="075-PRP259RS-S",socket="075-SDN250S");;
translate([1.27,1.27/2,-1])testpin(ontop=true,inset=1,movementdistance=2,probe="075-PRP259RS-S",socket="075-SDN250S");
translate([-1.27,-1.27/2,-1])testpin(ontop=true,inset=1,movementdistance=2,probe="075-PRP259RS-S",socket="075-SDN250S");
translate([0,-1.27/2,-1.5])testpin(ontop=true,inset=0.5,movementdistance=2,probe="075-PRP2520S",socket="075-SDN250S");
translate([1.27,-1.27/2,-2])testpin(ontop=true,inset=0,movementdistance=2,probe="075-PRP2540S",socket="075-SDN250S");

difference(){
translate([0,0,10]){cube([6,4,20],center=true);}
translate([-1.27,1.27/2,0])pinhole(probe="075-PRP259RS-S");
translate([0,1.27/2,0])pinhole(probe="075-PRP259RS-S");
translate([1.27,1.27/2,0])pinhole(probe="075-PRP259RS-S");
translate([-1.27,-1.27/2,0])pinhole(probe="075-PRP259RS-S");
translate([0,-1.27/2,0])pinhole(probe="075-PRP259RS-S");
translate([1.27,-1.27/2,0])pinhole(probe="075-PRP259RS-S");
}

translate([-2.5,0,-2])cylinder(h=3,d=1);
translate([2.5,-1,-2])cylinder(h=3,d=0.6);
translate([2.5,1,-2])cylinder(h=3,d=0.4);




