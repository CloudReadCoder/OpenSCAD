include <BOSL2/std.scad>;
include <BOSL2/beziers.scad>;

/*
 Marble Bricks
 (C)opyright 2019-2020 by CloudReadMaker / CloudReadCoder
 This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
 http://creativecommons.org/licenses/by-nc-sa/4.0/ 
*/

//Version: 2.0

/*
  Use Brick # 600 for a relatively small and rapid print to check interfacing with your baseplate
  If too tight try changing line 43 to:
  STUD_RADIUS_OUTER = 6.31/2-0.1 (or 0.05)
  if too loose, try changing line 43 to:
  STUD_RADIUS_OUTER = 6.31/2+0.1 
  Also: Disable "Small Wall Detection" in PrusaSlicer
*/

//BRICKNUM=0,1000,2000 all, 
BRICKNUM=1005; //1005; //504;  //Brick Type to generate


//DO NOT FIDDLE WITH THESE CONSTANTS
$fn=16;
e=0.01;//used to get rid of flickering artifacts in preview
FLU = 1.6;
BRICK_WIDTH = 5*FLU; //8mm size of an 1x1 LEGO
BRICK_HEIGHT = 6*FLU; //9.6mm (without stud on top)
PLATE_HEIGHT = 2*FLU; //3.2mm (without stud on top)
BRICK_CORRECTION = 0.1;   //0.1 ; //makes the outer size of brick slighlty smaller
BRICK_CORRECTION_H = BRICK_CORRECTION/2;//half correction
WALL_THICKNESS = 1;//for bottom frame



//20190301 : STUD_RADIUS from 2.45 (d=4.90) to 2.475 (d=4.95)

//Interface to baseplate settings
STUD_RADIUS_INNER = 2.55;   //these are not really important, no use to fiddle
STUD_RADIUS_OUTER = 6.31 / 2   ;    //SQRT(Brickwidth^2+Brickwidth^2)-2*radius; 5=expected dia = 11.3137-5=6.31

//Interface on top 
STUD_RADIUS = 2.485; //1.5625 * FLU;  //3*1.6 / 2 = 4.8 + 0.1
STUD_HEIGHT = FLU;
STUD_HEIGHT_DEFAULT_ADD = 1; //1 more mm as default for this setting, to get more stability
STUD_OFFS = BRICK_WIDTH/2;

//


//

ALL_SIZES=[[4,4,10],[4,4,9],[4,4,12],[4,4,10]];
ALL_TOPS=[10,10,12,10];
ALL_CENTERS=[5,4,7,5]; 
ALL_BOTTOMS=[0,1,0,0];
ALL_HOLE_Z_MINS=[2.5,2.5+0.5/3.2,2.5,0];


ALL_PIPERAYS=[BRICK_WIDTH-0.5,BRICK_WIDTH-e,BRICK_WIDTH-e];
//pipe positions best 4,7,10


BNUM=BRICKNUM%1000;  

BT=floor(BRICKNUM/1000);   //0-999 = 0, 1000-1999=1, 2000-2999=2, 3000-3999=3 to determine collection
DEFAULT_SIZE=ALL_SIZES[BT];
VERT_CENTER=ALL_CENTERS[BT];
VERT_TOP=ALL_TOPS[BT];
VERT_BOTTOM=ALL_BOTTOMS[BT];
HOLE_Z_MIN = ALL_HOLE_Z_MINS[BT];  //lowest position for exit hole


BRICK_LOW=3; //height for lowrider bricks = standard lego height (expressed in plate heights)




STUDS_CORNERS = [0,3,12,15];
STUDS_POSI = [DEFAULT_SIZE[0],DEFAULT_SIZE[1],DEFAULT_SIZE[2]];
BOTTOM_SIZE = [DEFAULT_SIZE[0],DEFAULT_SIZE[1],1];

//This works perfectly with 13mm steel marbles
//pipe_ray=(BRICK_WIDTH-0.5); //FLU/4); //-0.5); //-0.5);
pipe_ray=ALL_PIPERAYS[BT]; //20200501
pipe_dia=2*pipe_ray;

echo("Brick Type:",BT);
echo("Pipe Ray:",pipe_ray);
echo("Vert Center:",VERT_CENTER);
echo("Vert Top:",VERT_TOP);
echo("BrickNum:",BRICKNUM);

//brick_standard(0,"test");
//anyBrick(80,1);
//anyBrick(81,3);

//brick_topmark(1,"80"); 
//translate(descale([-4,0,6]))
//anyBrick(503,2);

if (BNUM==0) {
   for (i = [1:16]) anyBrick(i,i);
   anyBrick(500,17);
   anyBrick(502,17);
   anyBrick(503,19);
   anyBrick(504,21);
   
   //111 + 112
} else
{anyBrick(BNUM,1);
  
    
};    
//
//
//brick definitions
module anyBrick(num,pos){
   
    
    
    x=(pos-1) % 4;
    y=floor((pos-1) / 4); 
    
    
    
    
    
    
    
    translate([64*x,-64*y,0]) {
    if (num==1) marbrick_1();  
    if (num==2) marbrick_2();    
    if (num==3) marbrick_3();    
    if (num==4) marbrick_4();  
    if (num==5) marbrick_5();    
    if (num==6) marbrick_6();  
    if (num==7) marbrick_7();  
    if (num==8) marbrick_8();    
    if (num==9) marbrick_9();  
    if (num==10) marbrick_10(); 
    if (num==11) marbrick_11(); 
    if (num==12) marbrick_12(); 
    if (num==13) marbrick_13(); 
    if (num==14) marbrick_14();    
    if (num==15) marbrick_15(); 
    if (num==16) marbrick_funnel(); 
    //connectors between bricks of type 0 (10 high) and 1 (9 high)
    if (num==80) marbrick_80();    
    if (num==81) marbrick_81();

    if (num==105) marbrick_105();
    
    if (num==111) marbrick_111();
    if (num==112) marbrick_112();    
    
    if (num==501) marbrick_502(1);
    if (num==502) marbrick_502(2); 
    if (num==503) marbrick_502(3);  
    if (num==504) marbrick_502(4);      
    
    if (num==600) marbrick_600(); //testprint for bottom
        
   
    
  
    
    
  };  
    
    
};

module brick_topmark(side,mark){  //front=0,right=1,back=2,left=3
  off=BRICK_WIDTH/2;
  asize=BRICK_WIDTH*0.8;
    
  loctrans=[[2,0,10],[4,2,10],[2,4,10],[0,2,10]];
  offsets=[[0,off],[-off,0],[0,-off],[off,0]];
    
  t1=descale(loctrans[side]);
  
  trans=[t1[0]+offsets[side][0],t1[1]+offsets[side][1],t1[2]-STUD_HEIGHT+e];  
   translate(trans)  
  rotate([0,0,side*90])
    linear_extrude(STUD_HEIGHT)  
    text(mark, font = "Liberation Sans:style=Bold",size=asize,valign="center",halign="center"); 

};

module marbrick_1(){  //#1 Basic building block, no pipes
  difference(){ 
     brick_standard();
     brick_block([2.5,2,9],[0.75,1,2]);
     brick_block([2,2.5,9],[1,0.75,2]);
   }
};

module marbrick_2(){  //#2 X X - T2
  difference(){   
   brick_standard();
   brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
   brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);
 }; 
};

module marbrick_3(){  //#3 Y Y X T2
  difference(){   
   union(){
     brick_standard(); //full bottom structure,  
     if (BT==0) brick_block([4,2,1],[0,1,0]); //to fill where bottom pipe goes
   };
   if (BT==0) brick_pipe([0,2,0],[4,2,0]);
   brick_pipe([2,0,VERT_CENTER],[2,4,VERT_CENTER]); 
   brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);  
 }; 
};
module marbrick_4(){  //#4 XY X - T2
  difference(){   
    brick_standard();
    brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);
    brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
    brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);   
  }; 
};

module marbrick_5(){  //isOK #2 T2
  difference(){   
    brick_standard();
    brick_pipe([2,0,VERT_TOP],[4,2,VERT_TOP],[2,2,VERT_TOP]);
    brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);
  }; 
};

module marbrick_6(){  //isOK #2 T2
  difference(){   
    brick_standard();
    brick_pipe([2,4,VERT_TOP],[4,2,VERT_TOP],[2,2,VERT_TOP]);
    brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);  
  }; 
};

module marbrick_7(){  //isOK #7 small bottom plate T2?
  difference(){   
   union(){
     brick_standard();
     brick_block([2,3,1],[1,0,0]); //to fill where bottom pipe goes
   };
   brick_pipe([0,2,VERT_TOP],[2,4,VERT_TOP],[2,2,VERT_TOP]); 
   brick_pipe([0,2,VERT_CENTER],[2,0,HOLE_Z_MIN],[2,2,-1]);
 }; 
};

module marbrick_8(){  //isOK #8 T2 (like 7 just the other way around) small bottom plate
  difference(){   
   union(){
     brick_standard();
     brick_block([2,3,1],[1,1,0]); //to fill where bottom pipe goes
   };
   brick_pipe([0,2,VERT_TOP],[2,0,VERT_TOP],[2,2,VERT_TOP]);
   brick_pipe([0,2,VERT_CENTER],[2,4,HOLE_Z_MIN],[2,2,-1]);
  }; 
};

module marbrick_9(){  //isOK T2 #9 small bottom plate
  difference(){   
   union(){
     brick_standard();
     brick_block([2,3,1],[1,0,0]); //to fill where bottom pipe goes
   };
   brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
   brick_pipe([0,2,VERT_CENTER],[2,0,HOLE_Z_MIN],[2,2,-1]); //3.75=5-(2.5)/2
  }; 
};

module marbrick_10(){ //isOK #10 T2 (like 9, just the other way around) small bottom plate
  difference(){   
   union(){
     brick_standard(); //full bottom structure,  
     brick_block([2,3,1],[1,1,0]); //to fill where bottom pipe goes
   };
   brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
   brick_pipe([0,2,VERT_CENTER],[2,4,HOLE_Z_MIN],[2,2,-1]); 
 }; 
};

module marbrick_11(){ //isOK #11 T2 #Cross on top, x on mid & low, top->middle hole
  difference(){   
    brick_standard();
    brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
    brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);
    brick_pipe([0,2,VERT_CENTER],[2,2,DEFAULT_SIZE[2]]);
 }; 
};

module marbrick_12(){ //isOK T2 #12small bottom plate
  vc=VERT_CENTER-(VERT_CENTER-HOLE_Z_MIN)/1.5;  //move it closer to the bottom
  difference(){   
   union(){
     brick_standard();
     brick_block([3,2,1],[0,1,0]); //to fill where bottom pipe goes
    
   };
   brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
   brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);
   brick_pipe([0,2,HOLE_Z_MIN],[2,2,DEFAULT_SIZE[2]],[2,2,vc]); 
 }; 
};
module marbrick_13(){ //isOK T2 
  difference(){   
    brick_standard();
    brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);  
    angle90large(0,0,180,[2,2,VERT_TOP],0);
    angle90large(0,0,0,[2,2,VERT_TOP],0);
   }; 
};


module marbrick_14(){ //T2
  difference(){   
    brick_standard();
    brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);
    brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);    
    brick_pipe([2,0,VERT_CENTER],[2,4,VERT_CENTER]);
    brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);     
  }; 
};

module marbrick_15(){ //T2
  difference(){  
   union(){   
    brick_standard();
    brick_block([4,2,1],[0,1,0]);    
    brick_block([2,4,1],[1,0,0]);    
   };
    brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);
    brick_pipe([2,0,VERT_BOTTOM],[2,4,VERT_BOTTOM]);
    brick_pipe([0,2,VERT_BOTTOM],[4,2,VERT_BOTTOM]);
  }; 
};

module marbrick_80(){ //CONNECTOR BETWEEN WORLDS
  vert_bt0=ALL_CENTERS[0];
  vert_bt1=ALL_CENTERS[1];  
  difference(){   
    brick_standard();
    brick_topmark(1,"80");  
    brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);
      
    brick_pipe([2,0,vert_bt0],[0,2,vert_bt1],[2,2,-1]);
     
  }; 
};

module marbrick_81(){ //CONNECTOR BETWEEN WORLDS
  vert_bt0=ALL_CENTERS[0];
  vert_bt1=ALL_CENTERS[1];  
  difference(){   
    brick_standard();
    brick_pipe([2,0,VERT_TOP],[2,4,VERT_TOP]);
      
    
    brick_pipe([2,4,vert_bt0],[0,2,vert_bt1],[2,2,-1]);  
  }; 
};


module marbrick_111(){  //isOK #2
  difference(){   
   union(){
     brick_standard(); //full bottom structure,  
     brick_block([4,2,1],[0,1,0]); //to fill where bottom pipe goes
    
   };
  { brick_pipe([0,2,0],[4,2,0]);
    brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]);
    brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
   };
 }; 
};
module marbrick_112(){  //isOK #3
  difference(){   
   union(){
     brick_standard(); //full bottom structure,  
     brick_block([2,4,1],[1,0,0]); //to fill where bottom pipe goes
    };
  { 
  brick_pipe([0,2,VERT_TOP],[4,2,VERT_TOP]);
  brick_pipe([0,2,VERT_CENTER],[4,2,VERT_CENTER]); 
  brick_pipe([2,0,0],[2,4,0]);
      
  };
 }; 
};

module marbrick_105(){  //isOK #2 T2
  difference(){   
    brick_standard();
    brick_pipe([2,0,VERT_TOP],[4,2,VERT_TOP],[2,2,VERT_TOP]);
  }; 
};




 
module marbrick_502(mult){ //2-4  brick long passover
   
   long=mult*4; 
    
   studs=(mult==1)?[0,3,4,7,12,15]:
         (mult==2)?[0,3,4,7,24,27,28,31]:
         (mult==3)?[0,3,4,7,8,11,36,39,40,43,44,47]:
         (mult==4)?[0,3,4,7,8,11,12,15,48,51,52,55,56,59,60,63]:
         [1,2,3,4]; 
    
    difference(){
     union(){
       brick_bottom([long,4,1],[0,0,0]);
       brick_block([long,4,2],[0,0,1]);
       brick_studs([long,4,3],studs);  
       //brick_block([long,2,2],[0,1,0]);  
     };    
     brick_pipe([0,2,4],[long,2,4],[],[long,4,3]);  
   };    
   
    
};    



module marbrick_funnel(){ //needs rework
   difference(){   
   union(){
     brick_standard(); //full bottom structure,  
     brick_block([3,2,1],[0,1,0]); //to fill where bottom pipe goes
     
   };
  { //inner channels
    posi=descale([2,2,10]);
  //sphere_dia=BRICK_WIDTH*3.5*2; 
    translate(posi)
      hull(){
       rotate_extrude(angle=360,$fn=32) //create the angle
        translate([pipe_ray,0,0])  
          circle(r=pipe_ray,$fn=16);
         
     };
  brick_pipe([0,2,HOLE_Z_MIN],[2,2,DEFAULT_SIZE[2]],[2,2,-1]);  
   
 
 }; 
};
};

module marbrick_600(){  //small quickprint priece for first test of baseplate interface
  union(){
    brick_bottom([4,4,1],[0,0,0]);
    brick_block([4,4,1],[0,0,1]);
    brick_studs([4,4,2],[0,3,12,15]);    
  };    
};    





//
//
//general modules used by most bricks
module brick_pipe(hole1,hole2,pos_center=[2,2,VERT_CENTER],bricksize=DEFAULT_SIZE){
   //
   //echo(def_size);  
  /*
    h1=descale(hole1);
   h2=descale(hole2); 
   p1=descale(pos_center);
   p2=descale(pos_center); 
    
    path = [ h1, p1, p2,h2 ];
    echo(path);
    //trace_polyline(path, size=1, N=3, showpts=true);
     //bezier_path_extrude(path,clipsize=10,splinesteps=8){circle(r=BRICK_WIDTH);};
   trace_polyline(bezier_polyline(path, N=3), size=BRICK_WIDTH*2);
  */
    
    
   f1=getface(hole1,bricksize);
   f2=getface(hole2,bricksize); 
    
   //echo(f1,f2);
   
   h1=(f1<f2)?hole1:hole2;
   h2=(f1<f2)?hole2:hole1; 
    
   t1=(f1<f2)?f1:f2;
   t2=(f1<f2)?f2:f1; 
  
   if (isstraight(t1,t2)==true) {
     color("cyan")
      hull(){
       translate(descale(hole1))sphere(r=pipe_ray);  
       translate(descale(hole2))sphere(r=pipe_ray);
     };  
   } else
   { 
         
   rindex=
       (t1==1 && t2==2)?1:
       (t1==2 && t2==3)?2:
       (t1==3 && t2==4)?3:
       (t1==1 && t2==4)?4:
       (t1==1 && t2==5)?5:
       (t1==2 && t2==5)?6:
       (t1==3 && t2==5)?7:
       (t1==4 && t2==5)?8:
       (t1==1 && t2==6)?9:
       (t1==2 && t2==6)?10:
       (t1==3 && t2==6)?11:
       (t1==4 && t2==6)?12:
       0;    
       
   //echo(rindex);    
   
   rotations=[[-45,-45,-45],
       [0,0,90],[0,0,180],[0,0,270],[0,180,-90],
       [90,0,90],[90,0,180],[90,0,270],[90,0,0],
       [-90,0,90],[-90,0,180],[-90,0,270],[-90,0,0]];
   rotation=rotations[rindex];   
 
 entry=h1;
 exit=h2;
    
 pos_entry=descale(entry);
 pos_exit=descale(exit);   
 
//p_center=(pos_center[2]==-1)?[pos_center[0],pos_center[1],(h1[2]+h2[2])/2]:pos_center;
 p_center=(pos_center[2]==-1)?[pos_center[0],pos_center[1],max(h1[2],h2[2])-abs(h1[2]-h2[2])/4]:pos_center;
 
 
 //draw angle piece first   
 posi=descale(p_center);
 translate(posi) //move into legospace 
   rotate(rotation) //apply rotation
    translate([-pipe_ray,-pipe_ray,0]) //move it to center
      {
      rotate_extrude(angle=90,$fn=32) //create the angle
        translate([pipe_ray,0,0])  
         rotate([0,0,0])  //360/32
          circle(r=pipe_ray,$fn=16);
    };
   
  ph=e;
  //draw pipe blue
  color("blue")  
   hull(){   
     translate(posi) //move into legospace 
       rotate(rotation) //apply rotation
         translate([-pipe_ray,0,0])   
            rotate([0,90,0])cylinder(r=pipe_ray,h=ph);     
       brick_hole(entry,bricksize); 
   };  
  //draw pipe red
   color("red")
   hull(){
     translate(posi) //move into legospace 
       rotate(rotation) //apply rotation
        translate([0,-pipe_ray+e,0])   
            rotate([90,0,0])cylinder(r=pipe_ray,h=ph);  
       brick_hole(exit,bricksize);
   }; 
    };
   
}; 





module brick_standard(){ //DEFAULT_SIZE full brick
  brick_bottom(BOTTOM_SIZE,[0,0,0]); //full bottom structure,  
  brick_block([DEFAULT_SIZE[0],DEFAULT_SIZE[1],DEFAULT_SIZE[2]-BOTTOM_SIZE[2]],[0,0,BOTTOM_SIZE[2]]);  //main body block 
  brick_studs(STUDS_POSI,STUDS_CORNERS);    
};
module brick_low(){ //DEFAULT_SIZE full brick
  brick_bottom(BOTTOM_SIZE,[0,0,0]); //full bottom structure,  
  brick_block([DEFAULT_SIZE[0],DEFAULT_SIZE[1],BRICK_LOW-BOTTOM_SIZE[2]],[0,0,BOTTOM_SIZE[2]]);  //main body block   
  brick_studs([4,4,BRICK_LOW],STUDS_CORNERS);    
};
module brick_medium(){ //DEFAULT_SIZE full brick
  brick_bottom(BOTTOM_SIZE,[0,0,0]); //full bottom structure,  
  brick_block([DEFAULT_SIZE[0],DEFAULT_SIZE[1],9-BOTTOM_SIZE[2]],[0,0,BOTTOM_SIZE[2]]);  //main body block   
  brick_studs([4,4,9],STUDS_CORNERS);    
};


module brick_bottom(size,position){ //bottom interface
  //tis one actually works nicvely
  w=WALL_THICKNESS;
  frame_outer=descale(size,[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]);
  frame_inner=descale(size,[-w-BRICK_CORRECTION_H,-w-BRICK_CORRECTION_H,e]);
  z1=frame_outer[2];
  z2=z1+2*e;  //for artifact elimination
    
  big_block=descale(size,[BRICK_WIDTH,BRICK_WIDTH,e]);  
 
    
    
  translate(descale(position))  
    union(){  
    
    
   translate([BRICK_CORRECTION_H,BRICK_CORRECTION_H,0]) 
   difference(){  //Create the hollow framed bottom
     cube(frame_outer);  
     translate([w,w,-e])
       cube(frame_inner);
  };
 
  //add the supporting walls between bottom studs for safer printing
  wall_thick=0.1; //BRICK WIDTH = 5*FLU = 8mm 
  wall_x=descale([wall_thick,size[1],size[2]],[0,-2*BRICK_CORRECTION_H,0]);  //needs brick_correction?
  wall_y=descale([size[0],wall_thick,size[2]],[-2*BRICK_CORRECTION_H,0,0]);
  
  
  
  
  
 difference(){ //ALLTHE STUDS - OUTERFRAME
  union(){
   for (x=[0:size[0]]) {  //-1 because from 0 on, -2 because one less than stud
     for (y=[0:size[1]]) {
        translate( descale([x,y,0],[0,0,0])) 
           cylinder(h=z1,r=STUD_RADIUS_OUTER);
      };      
  };     
  for (x=[1:size[0]-1]) {
    translate(descale([x-wall_thick/2,0,0],[BRICK_CORRECTION_H,BRICK_CORRECTION_H,0]))
      cube(wall_x);
  };   
 
 for (y=[1:size[1]-1]) {
    translate(descale([0,y-wall_thick/2,0],[BRICK_CORRECTION_H,BRICK_CORRECTION_H,0]))
      cube(wall_y);
 }; 
  }; //union
  for (x=[0:size[0]]) {  //-1 because from 0 on, -2 because one less than stud
     for (y=[0:size[1]]) {
       //we paint the studs
       translate( descale([x,y,0],[0,0,0])) 
         //difference(){
         //  cylinder(h=z1,r=STUD_RADIUS_OUTER);
          translate([0,0,-e]) 
          cylinder(h=z2,r=STUD_RADIUS_INNER);  
         //};  
      };      
  };     
  
  
  
  
  translate([BRICK_CORRECTION_H,BRICK_CORRECTION_H,0]) 
  difference(){  //BORDER AROUND THE BRICK TO CUT OFF EXCESS STUDS
    translate([-BRICK_WIDTH,-BRICK_WIDTH,-e])
      cube(big_block);
    cube(frame_outer);
  }; 
};
 }; //end final untion
};    


module brick_block(size,position){ //block, no interfaces
   translate(descale(position,[0,0,0],[BRICK_CORRECTION_H,BRICK_CORRECTION_H,0]))
     cube(descale(size,[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]));   


};










  



   

module brick_studs(size,nostuds,addhigh=STUD_HEIGHT_DEFAULT_ADD){//upper interface (studs)
  for (x=[0:size[0]-1]){  
    for (y=[0:size[1]-1]){
      if (len(search(x+y*size[0],nostuds))!=0){
         translate([x*BRICK_WIDTH+STUD_OFFS,y*BRICK_WIDTH+STUD_OFFS,size[2]*PLATE_HEIGHT])
          cylinder(h=STUD_HEIGHT+addhigh,r=STUD_RADIUS);
      };   
    };
}; 
};









module brick_hole(position,bricksize=DEFAULT_SIZE){
   //switched from FLU to FLU/2 on 20191104
   offs=FLU/4;
   mm_len=offs*2+e;  //length of outer pipe segments        //        
   hh=(4*BRICK_WIDTH-pipe_dia)/4;
   
   pos_x=-sign(position[0]-2);
   pos_y=-sign(position[1]-2); 
   pos_z=-sign(position[2]-5); 
    
   
   
   plone=getface(position,bricksize); 
    
    rot_y=(plone==2)||(plone==4)?1:0;
    rot_x=(plone==1)||(plone==3)?1:0;
    rot_z=(plone==5)||(plone==6)?1:0;
    
   //rot_y=(plane==0)?1:0; planey
   //rot_x=(plane==1)?1:0; planex
   //rot_z=(plane==2)?1:0; planez//not used,just here for simetry

   posi=descale(position); 
    translate(posi)  
     translate([offs*rot_y*pos_x,offs*rot_x*pos_y,offs*rot_z*pos_z]) 
       rotate([rot_x*90,rot_y*90,0]) 
         translate([0,0,-mm_len/2])
           cylinder(h=mm_len,r=pipe_ray); 
};











   





module angle90large(rotx,roty,rotz,position,ext_cyl){
 offs=2*BRICK_WIDTH-pipe_ray;
  
 posi=descale(position);
 color("green")
 translate(posi) //move into legospace 
   rotate([rotx,roty,rotz]) //apply rotation
     translate([-offs-pipe_ray,-offs-pipe_ray,0])  
    {
      rotate_extrude(angle=90,$fn=32) //create the angle
        translate([pipe_ray+offs,0,0])  
          circle(r=pipe_ray,$fn=16);
        if (ext_cyl!=0) {
        
        translate([pipe_ray+offs,e,0])
          rotate([90,0,0])cylinder(r=pipe_ray,h=ext_cyl);    
        translate([-ext_cyl+e,pipe_ray+offs,0]) 
          rotate([0,90,0])cylinder(r=pipe_ray,h=ext_cyl); 
        };   
      };
};  
//functions
function descale(coords,size_borders=[0,0,0],position_offset=[0,0,0]) = [
              coords[0]*BRICK_WIDTH+2*size_borders[0]+position_offset[0],
              coords[1]*BRICK_WIDTH+2*size_borders[1]+position_offset[1],
              coords[2]*PLATE_HEIGHT+2*size_borders[2]+position_offset[2]
            ];
function isstraight(t1,t2) = (t1==1 && t2==3) || (t1==2 && t2==4) || (t1==5 && t2==6);
function getface(entry,bsize) =  
   (entry[0]==0 && entry[1]!=0)?4:   
   (entry[0]==bsize[0] && entry[1]!=0)?2: 
   (entry[1]==0 && entry[0]!=0)?1:
   (entry[1]==bsize[1] && entry[0]!=0)?3:
   (entry[2]==0 && entry[0]!=0 && entry[1]!=0)?5:
   (entry[2]==bsize[2] && entry[0]!=0 && entry[1]!=0)?6:0
 ;
//
//
//
//
//UNUSED functions
function distance(p1,p2) = sqrt(pow(p2[0]-p1[0],2)+pow(p2[1]-p1[1],2)+pow(p2[2]-p1[2],2));

//UNUSED modules

module consecutive_hull() {
  for (i = [1:$children-1])
    hull() {
      children(i-1);
      children(i);
    }
};

module torus(a,start){
  
  rotate([0,0,start])
    rotate_extrude(angle=a,$fn=32) //create the angle
        translate([pipe_ray,0,0])  
           circle(r=pipe_ray,$fn=16);
    
};   
module angle90hole(rotation,position,ext_cyl,which){  //which is 1 or 2
  posi=descale(position);
  translate(posi) //move into legospace 
   rotate(rotation) //apply rotation
    translate([-pipe_ray,-pipe_ray,0]) //move it to center
      if (which==1) {
       translate([pipe_ray,e,0])
          rotate([90,0,0])cylinder(r=pipe_ray,h=ext_cyl);       
          
      } else 
      if (which==2) {
        translate([-ext_cyl+e,pipe_ray,0]) 
          rotate([0,90,0])cylinder(r=pipe_ray,h=ext_cyl);     
  
      };
    
    
    
}; 

module rotate_around_pt(z, y, pt) {
    translate(pt)
        rotate([0, y, z]) // CHANGE HERE
            translate(-pt)
                children();   
}
module roundend(position){
   apos=descale(position);
   translate(apos)
      sphere(r=pipe_ray,$fn=16);
};   


module curb1(position){
  translate(descale(position)) 
  rotate_extrude(angle=90,$fn=32)
    translate([BRICK_WIDTH*2,0,0])  
      circle(r=pipe_ray,$fn=16);
};  

module curb2(position){
  translate(descale(position)) 
  translate([BRICK_WIDTH*3,BRICK_WIDTH*3,0])
  rotate([0,0,180])  
    rotate_extrude(angle=90,$fn=32)
    translate([BRICK_WIDTH*2,0,0])  
      circle(r=pipe_ray,$fn=16);
};  
module curb3(position){
  translate(descale(position)) 
  translate([0,0,BRICK_WIDTH*3])
  rotate([-90,0,0])  
    rotate_extrude(angle=90,$fn=32)
    translate([BRICK_WIDTH*2,0,0])  
      circle(r=pipe_ray,$fn=16);
}; 

module curb3n(position){
  protrude=2*BRICK_WIDTH-pipe_ray;
  extralength=10; //2*BRICK_WIDTH; //needed for subtractions
  translate(descale(position)) 
  
    
  translate([protrude,0,0])
  rotate([-90,0,00]) //rotate -90 upwards
   translate([-protrude-pipe_ray,-pipe_ray,0]) 
    
    union(){
    rotate_extrude(angle=90,$fn=32) //angle part
      translate([pipe_ray,0,0])  
       circle(r=pipe_ray,$fn=16);
    translate([-protrude-extralength+e,pipe_ray,0])
      rotate([0,90,0])
      cylinder(h=protrude+extralength,r=pipe_ray); //horizontal
    translate([pipe_ray,e,0])
      rotate([90,0,0])
      cylinder(h=protrude+extralength,r=pipe_ray);  //vertical tube
      
      
  };    
}; 









module fence(frame_outer,thickness){
  echo(frame_outer);
  frame_inner=[frame_outer[0]-2*thickness,
               frame_outer[1]-2*thickness,
               frame_outer[2]+2*e];
    
    
    
  difference(){
    cube(frame_outer);
    translate([thickness,thickness,-e]) cube(frame_inner);  
    
    
  };    
    
};    


module brick_bottom_concentric(size,position){
  //brick_studs(size);
    //fence(size,0.5);
  cnta=(size[0]>size[1])?floor(size[1]/2):floor(size[0]/2);
    
  cnt=cnta;
  offset= -BRICK_WIDTH/2+2.5;   
   
  for (i=[1:cnt]){
    x=size[0]-2*i;
    y=size[1]-2*i;
    z=size[2]; 
     
     
      
    translate(descale([i,i,0],[0,0,0],[offset,offset,0]))
       fence(descale([x,y,z],[-offset,-offset,0]),1); 
  
  
  
    

};
}; 

module brick_bottom_concentric_new(size,position){
  nsize=descale([4,4,1],[-1,-1,0],[1,1,-e]);
  difference(){
    brick_block([4,4,1],[0,0,0]);
      
    #cube(nsize);  
      
  
  };  


}; 







module brick_bottom_frame(size,position){
w=WALL_THICKNESS;
  frame_outer=descale(size,[-BRICK_CORRECTION_H,-BRICK_CORRECTION_H,0]);
  frame_inner=descale(size,[-w-BRICK_CORRECTION_H,-w-BRICK_CORRECTION_H,e]);
  //z1=frame_outer[2];
  //z2=z1+2*e;  //for artifact elimination
    
  //big_block=descale(size,[BRICK_WIDTH,BRICK_WIDTH,e]);  
 
  translate(descale(position))  
     
    
    
   translate([BRICK_CORRECTION_H,BRICK_CORRECTION_H,0]) 
   difference(){  
     cube(frame_outer);  
     translate([w,w,-e])
       cube(frame_inner);
  
};  
};


module brick_bottom_square(size,position){
  size_mm=descale(size);
  wall_t=BRICK_WIDTH-2*2.5;  
  wall_th=wall_t/2;
  line_t=0.5;
    
  for (x=[0:size[0]]){
    translate([x*BRICK_WIDTH,0,0]){
      translate([-wall_th,0,0])
      cube([line_t,size_mm[1],size_mm[2]]); 
      translate([wall_th-line_t,0,0])
      cube([line_t,size_mm[1],size_mm[2]]); 
      
        
    };    
   };    
  for (y=[0:size[1]]){
    translate([0,y*BRICK_WIDTH,0]){
      translate([0,-wall_th,0])
      cube([size_mm[0],line_t,size_mm[2]]); 
       translate([0,wall_th-line_t,0])
      cube([size_mm[0],line_t,size_mm[2]]); 
    };    
        };       
    

};



