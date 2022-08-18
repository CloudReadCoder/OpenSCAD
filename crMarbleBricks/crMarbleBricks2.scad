include <BOSL2/std.scad>




$fn=16;
e=0.01;//used to get rid of flickering artifacts in preview
FLU = 1.6;
BRICK_WIDTH = 5*FLU; //8mm size of an 1x1 LEGO
BRICK_HEIGHT = 6*FLU; //9.6mm (without stud on top)
PLATE_HEIGHT = 2*FLU; //3.2mm (without stud on top)
BRICK_CORRECTION = 0.1;   //0.1 ; //makes the outer size of brick slighlty smaller
BRICK_CORRECTION_H = BRICK_CORRECTION/2;//half correction
WALL_THICKNESS = 1;//for bottom frame
BRICK_SIZE_MM=[BRICK_WIDTH,BRICK_WIDTH,PLATE_HEIGHT];


//20190301 : STUD_RADIUS from 2.45 (d=4.90) to 2.475 (d=4.95)

//Interface to baseplate settings
STUD_TOLERANCE_BOTTOM=0.0; //depends on printer & slice, tolerance of the diameter
STUD_RADIUS = 3*FLU/2; //d=4.8, r=2.4
STUD_RADIUS_INNER = STUD_RADIUS;   //these are not really important, no use to fiddle
STUD_RADIUS_OUTER = (sqrt(BRICK_WIDTH*BRICK_WIDTH+BRICK_WIDTH*BRICK_WIDTH)-2*STUD_RADIUS-STUD_TOLERANCE_BOTTOM)/2; //
//STUD_RADIUS_OUTER = 6.31 / 2   ;    //SQRT(Brickwidth^2+Brickwidth^2)-2*radius; 5=expected dia = 11.3137-5=6.31

//Interface on top 
//STUD_RADIUS = 2.485; //1.5625 * FLU;  //3*1.6 / 2 = 4.8 + 0.1
STUD_HEIGHT = FLU+0.2;  //1.8
STUD_HEIGHT_DEFAULT_ADD = 1; //1 more mm as default for this setting, to get more stability
STUD_OFFS = BRICK_WIDTH/2;
//
CORNER_ROUNDING=1;


brick_bottom([4,4,2],[0,0,0])  
   position(TOP) brick_body([4,4,2],[0,0,0]) 
    position(TOP) brick_top([4,4,0.5],[0,0,2]);

module brick_bottom(size,position=[0,0,0],anchor=CENTER,spin=0,orient=UP){
    d_posi=descale(position); 
    d_size=descale(size,size_borders=[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]); 
    attachable(anchor, spin, orient, size=d_size) {  //to be able to easily attach to sth.
    translate(d_posi)
        union(){  
            intersection(){  
                grid2d(n=[size.x+1,size.y+1], spacing=BRICK_WIDTH) {
                    tube(or=STUD_RADIUS_OUTER,ir=STUD_RADIUS_INNER,h=d_size.z); 
                    cuboid([BRICK_WIDTH+2*e,0.6,d_size.z],anchor=BOTTOM); 
                    cuboid([0.6,BRICK_WIDTH+2*e,d_size.z],anchor=BOTTOM); 
                };    
                cuboid(d_size,anchor=BOTTOM,rounding=CORNER_ROUNDING,except_edges=[TOP,BOTTOM]);
            };
            rect_tube(size=[d_size.x,d_size.y],h=d_size.z,wall=WALL_THICKNESS,rounding=CORNER_ROUNDING);
        }; //union
   
    
    children(); //for BOSL2
   }     
        
        
};    

module brick_bottom2(size,position=[0,0,0]){
   d_posi=descale(position); 
    d_size=descale(size,size_borders=[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]); 
    translate(d_posi)
        union(){  
            difference(){  
                cuboid(d_size,anchor=BOTTOM,rounding=CORNER_ROUNDING,except_edges=[TOP,BOTTOM]);
                down(e)grid2d(n=[size.x ,size.y ], spacing=BRICK_WIDTH) {
                    cuboid([STUD_RADIUS*2,STUD_RADIUS*2,d_size.z+2*e],anchor=BOTTOM); 
                     
                };    
                
            };
            rect_tube(size=[d_size.x,d_size.y],h=d_size.z,wall=WALL_THICKNESS,rounding=CORNER_ROUNDING);
        }; //union  
    

};

module brick_body(size,position=[0,0,0],anchor=BOTTOM,spin=0,orient=UP){
   d_posi=descale(position); 
   d_size=descale(size,size_borders=[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]);  
    attachable(anchor, spin, orient, size=d_size) {
    translate(d_posi)
     cuboid(d_size,anchor=BOTTOM);
    children();
   }          
        
};    

module brick_top(size,position=[0,0,0],anchor=BOTTOM,spin=0,orient=UP){
   d_posi=descale(position); 
   d_size=descale(size,size_borders=[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]);  
   attachable(anchor, spin, orient, size=d_size) {
    translate(d_posi)
     grid2d(n=[size.x,size.y], spacing=BRICK_WIDTH) 
        cyl(r=STUD_RADIUS,h=d_size.z,anchor=BOTTOM);  
   children();
   }     

};

function descale(coords,size_borders=[0,0,0],position_offset=[0,0,0]) =  
    vmul(coords,BRICK_SIZE_MM)+vmul([2,2,2],size_borders) +position_offset
  ;

function descale2(coords,size_borders=[0,0,0],position_offset=[0,0,0]) = [
              coords[0]*BRICK_WIDTH+2*size_borders[0]+position_offset[0],
              coords[1]*BRICK_WIDTH+2*size_borders[1]+position_offset[1],
              coords[2]*PLATE_HEIGHT+2*size_borders[2]+position_offset[2]
            ];