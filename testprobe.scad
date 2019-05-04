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

translate([1.27,-1.27/2,-2])testpin(ontop=true,inset=0,movementdistance=2,probe="075-PRP2510S",socket="075-SDN250S");

//models the complete test pin
module testpin(ontop=true,inset=0,probe="",socket="",inset=0,movementdistance=0){
    $fs=0.3;
    rotate([0,ontop?0:180,0]){
        probe(probe=probe,inset=inset,movementdistance=movementdistance);
        socket(socket=socket);
    }
}

//models the hole that gets drilled through the sheet
module pinhole(socket=""){
   $fs=0.3;
    if(socket=="050-SRB255P"){
       // QATech.com
       cylinder(h=1000,d=1.0,center=true);
   }else if(socket=="050-STB255P"){
       // QATech.com
       cylinder(h=1000,d=1.0,center=true);
   }else if(socket=="075-SDN250S"){
       // QATech.com socket 075-SDN250S
       cylinder(h=1000,d=1.35,center=true);
   }else if(socket=="075-PRP259RS-S"){
       //default: QATech.com socket 075-SDN250S
       cylinder(h=1000,d=1.35,center=true);
   }else{
       //default: QATech.com socket 075-SDN250S
       cylinder(h=1000,d=1.35,center=true);
   }   
}

module probe(probe="",inset=0,movementdistance=0){
   //Probe QATech.com 075-PRP259RS-S
    delay=inset/movementdistance;
    translate([0,0,$t>delay?($t-delay)*movementdistance:0]){ 
       $fs=0.1;
       if(probe=="050-PTP2540S"){
           color("Gold")
           //tip part 1
           translate([0,0,0.53/2])sphere(d=0.53);
           //tip part 2
           color("Gold")
            translate([0,0,0.53/2])cylinder(h=2,d=0.53,center=false);
           //shaft 
           color("Gold")
           translate([0,0,2])cylinder(h=8,d=0.53,center=false);
        }else 
        if(probe=="050-PTP2541S"){
           color("Gold")
           //tip part 1
           translate([0,0,0])cylinder(h=2,d1=0,d2=0.53,center=false);
           //tip part 2
           //shaft 
           color("Gold")
           translate([0,0,2])cylinder(h=8,d=0.53,center=false);
        }else if(probe=="050-PRP2540S"){
           color("Gold")
           //tip part 1
           translate([0,0,0.53/2])sphere(d=0.53);
           color("Gold")
           //tip part 2
           translate([0,0,0.53/2])cylinder(h=2,d=0.53,center=false);
           //shaft 
           color("Gold")
           translate([0,0,2])cylinder(h=8,d=0.53,center=false);
        }else
        if(probe=="050-PRP2541S"){
           color("Gold")
           //tip part 1
           translate([0,0,0])cylinder(h=2,d1=0,d2=0.53,center=false);
           //tip part 2
           //shaft 
           color("Gold")
           translate([0,0,2])cylinder(h=8,d=0.53,center=false);
        }else if(probe=="075-PRP2501S"){
           color("Gold")
           //tip part 1
           translate([0,0,0])cylinder(h=1.27/2,d1=0,d2=1.17,center=false);
           //tip part 2
           color("Gold")
           translate([0,0,1.27/2])cylinder(h=1.27/2,d=1.17,center=false);
           //shaft 
           color("Gold")
           translate([0,0,1.27])cylinder(h=8,d=0.64,center=false);
       }else if(probe=="075-PRP2510S"){
           color("Gold")
           //tip part 1
           translate([0,0,0])cylinder(h=1.17,d=1.17,center=false);
           //tip part 2
           //shaft 
           color("Gold")
           translate([0,0,1.27])cylinder(h=8,d=0.64,center=false);
        }else if(probe=="075-PRP2520S"){
           color("Gold")
           //tip part 1
           translate([0,0,0])cylinder(h=2,d=0.64,center=false);
           //tip part 2
           //shaft 
           color("Gold")
           translate([0,0,1.27])cylinder(h=8,d=0.64,center=false);
       }else if(probe=="075-PRP2540S"){
           color("Gold")
           //tip part 1
           translate([0,0,0.64/2])sphere(d=0.64);
           //tip part 2
           color("Gold")
           translate([0,0,0.64/2])cylinder(h=2,d=0.64,center=false);
           //shaft 
           color("Gold")
           translate([0,0,2])cylinder(h=8,d=0.64,center=false); 
       }else if(probe=="075-PRP259RS-S"){
           color("Gold")
           //tip part 1
           //tip part 2
           translate([0,0,0])cylinder(h=2,d1=0,d2=0.64,center=false);
           //shaft 
           color("Gold")
           translate([0,0,2])cylinder(h=8,d=0.64,center=false);
       }else {//Default
           //tip part 1
           color("Blue")
           translate([0,0,-0.5])cylinder(h=0.5,d1=2,d2=3,center=false);
           //tip part 2
           color("Red")
           translate([0,0,0])cylinder(h=2,d1=3.5,d2=0.64,center=false);
           //shaft 
           color("Red")
           translate([0,0,2])cylinder(h=7.62,d=0.64,center=false);
       }
   }
}

module socket(socket=""){
   //Socket QATech.com 075-SDN250S 
   $fs=0.1;
   if(socket=="050-SRB255P"){
       color("Gray")
       // QATech.com
       translate([0,0,43.18-36.27])cylinder(h=40.41,d=0.95,center=false);
       translate([0,0,8+5.08])cylinder(h=1,d=1.0,center=false);
       color("blue")
       translate([0,0,8+7.37])cylinder(h=1,d=1.05,center=false);
       translate([0,0,8+11.71])cylinder(h=1,d=1.0,center=false);      
   }else if(socket=="050-STB255P"){
       color("Gray")
       // QATech.com
       translate([0,0,43.18-36.27])cylinder(h=31.83,d=0.95,center=false);
       translate([0,0,8+5.08])cylinder(h=1,d=1.0,center=false);
       color("fuchsia")
       translate([0,0,8+7.37])cylinder(h=1,d=1.05,center=false);
       translate([0,0,8+11.71])cylinder(h=1,d=1.0,center=false);      
   }else if(socket=="075-SDN250S"){
       // QATech.com 075-SDN250S
       color("Gray")
       translate([0,0,7.8])cylinder(h=29.72,d=1.021,center=false);
       color("yellow")
       translate([0,0,7.8+7.62])cylinder(h=1,d=1.46,center=false);      
   }else{
       //default: QATech.com 075-PRP259RS-S with socket 075-SDN250S
       color("red")
       translate([0,0,7.8])cylinder(h=29.72,d=1.021,center=false);
       color("red")
       translate([0,0,7.8+7.62])cylinder(h=1,d=1.46,center=false);
   }
}