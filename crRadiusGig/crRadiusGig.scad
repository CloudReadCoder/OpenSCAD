/*
 Radius Measuring Gig
 (C)opyright 2019 by CloudReadMaker / CloudReadCoder
 This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
 http://creativecommons.org/licenses/by-nc-sa/4.0/ 
*/

//Version: 1.6


sq1=sqrt(2);
sq2=sq1/2; //sin45
e=0.01;  //extra size/offset used to get rid of schimmering in difference()

attach_dia=2;
attach_ray=attach_dia/2;
attach_angle=0;

offs=7;
offsf=10;

radi1=[5,6,7,8,9];
radi2=[10,12,14,16,18];
radi3=[20,22,24,26,28];
radi4=[30,32,34,36,38,40];

$fn=72;

for (i=[0:4])  //pieces from 5-9
  translate([i*offs+offsf,i*offs+offsf,0])
    anglepiece(radi1[i]);

for (i=[0:4]) 
  translate([i*offs+offsf,-i*offs-offsf,0])
    rotate([0,0,-90])
    anglepiece(radi2[i]);

for (i=[0:4]) 
  translate([-i*offs-offsf,-i*offs-offsf,0])
    rotate([0,0,-180])
     anglepiece(radi3[i]);

for (i=[0:5]) 
  translate([-i*offs-offsf,i*offs+offsf,0])
    rotate([0,0,-270])
     anglepiece(radi4[i]);



module anglepiece(radius){
  
  fs=3; //fontsiize  
  depth=8;
  fpos=(depth-fs)/2;  
    
  pos=radius*0.9;      
  
   
    
  difference(){  
    union(){ translate([0,0,0])  
      cylinder(r=radius,h=4);
    }; 
  union(){  
     translate([-depth/sq1,-depth/sq1,-e])
       union(){ 
        cylinder(r=radius,h=4+2*e);    
        translate([-radius,0,0])
           cube([radius,radius*2,4+2*e]); 
        translate([0,-radius,0])
            cube([radius*2,radius,4+2*e]);    
           
       };      
     translate([(radius-depth/2)*sin(attach_angle) ,(radius-depth/2)*cos(attach_angle),-e]) 
       cylinder(r=attach_ray,h=4+2*e);  
       
  };  
  }; //difference
  
  color("red")
  translate([radius/sq1-fs,radius/sq1-fs,4])  
    linear_extrude(height=1)
    rotate([0,0,-45])
       text(str(radius),size=fs,valign="center",halign="left"); 
  
    
};   
