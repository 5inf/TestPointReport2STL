use <testprobe.scad>

$fs=0.05;
movementdistance=2;
timeoffset=0;
delay=0.25;

translate([-1.27,1.27/2,-2+1])testpin(ontop=true,inset=1,movementdistance=movementdistance,probe="050-PTP2540S",socket="050-STB255P");
translate([0,1.27/2,-2+1])testpin(ontop=true,inset=1,movementdistance=movementdistance,probe="050-PTP2540S",socket="050-STB255P");
translate([1.27,1.27/2,-2+1])testpin(ontop=true,inset=1,movementdistance=movementdistance,probe="050-PTP2540S",socket="050-STB255P");
translate([-1.27,-1.27/2,-2+1])testpin(ontop=true,inset=1,movementdistance=movementdistance,probe="050-PTP2540S",socket="050-STB255P");
translate([0,-1.27/2,-2+0.8])testpin(ontop=true,inset=0.8,movementdistance=movementdistance,probe="050-PTP2540S",socket="050-STB255P");
translate([1.27,-1.27/2,-2+0.4])testpin(ontop=true,inset=0.4,movementdistance=movementdistance,probe="050-PTP2540S",socket="050-STB255P");

//translate([11.27,-1.27/2,-2])testpin(ontop=true,inset=0,movementdistance=2,probe="050-PTP2541S",socket="050-STB255P");
//translate([13.27,-1.27/2,-2])testpin(ontop=true,inset=0,movementdistance=2,probe="050-PRP2541S",socket="050-SRB255P");

difference(){
translate([0,0,10]){cube([6,4,20],center=true);}
translate([-1.27,1.27/2,0])pinhole(socket="050-STB255P");
translate([0,1.27/2,0])pinhole(socket="050-STB255P");
translate([1.27,1.27/2,0])pinhole(socket="050-STB255P");
translate([-1.27,-1.27/2,0])pinhole(socket="050-STB255P");
translate([0,-1.27/2,0])pinhole(socket="050-STB255P");
translate([1.27,-1.27/2,0])pinhole(socket="050-STB255P");
}

translate([-2.5,0,-2])cylinder(h=3,d=1);
translate([2.5,-1,-2])cylinder(h=3,d=0.6);
translate([2.5,1,-2])cylinder(h=3,d=0.4);


