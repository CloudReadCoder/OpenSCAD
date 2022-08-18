include <BOSL2/std.scad>
include <VCR/vcr_bricks.scad>

BALL_DIA=BRICK_WIDTH*2-1;
BALL_RAY=BALL_DIA/2;



brack=[4,4,10]; //building block with everything around, in Lego Units
echo(brack);

cubus=vcr_size_raw([4,4,10]);  //size used for all calculations
cubus_real=vcr_size_net([4,4,10]);  //used for printing the outer shell, slighlty smaller x+y, like Lego
 

//BRICK_CORRECTION=-16; //for debugging purposes

//
echo(UP,DOWN);


dobrick(tubes=[],turns=["d","b","c"]); //from top to bottom
 
 
module conditional_tube(crit,posi) {
  position(posi) {
  if ((crit=="-")||(crit=="+")) mb_tube(spin=0);
  if ((crit=="|")||(crit=="+")) mb_tube(spin=90); 
  };    
};    
 
module conditional_turn(crit,posi) {
  position(posi) {
    if (crit=="a") mb_curb(zdir=0);
    if (crit=="b") mb_curb(zdir=0,spin=90);
    if (crit=="c") mb_curb(zdir=0,spin=180);
    if (crit=="d") mb_curb(zdir=0,spin=270);    
  };
};  

module dobrick(tubes,turns,levels){
    
    diff("remove") {
        vcr_brick(brack,top4x4_corners) {
           tag("remove") {
               conditional_tube(tubes[0],TOP);
               conditional_tube(tubes[1],CENTER);
               conditional_tube(tubes[2],BOTTOM);
               
               conditional_turn(turns[0],TOP);
               conditional_turn(turns[1],CENTER);
               conditional_turn(turns[2],BOTTOM);
               
                   
        };
    }; //diff
  };
};


 

module mb_tube(anchor, spin, orient) {
    
  size_tube=[cubus.x,BALL_DIA,BALL_DIA];  
  attachable(anchor, spin, orient, size=size_tube) {
   hull(){
     left(cubus_real.x/2)  //using cubus_real, needs to go to surface
        spheroid(r=BALL_RAY);
     right(cubus_real.x/2)
        spheroid(r=BALL_RAY);   
   }; 
   children();      
  };    
};


function posi(x,tot,r,zmov) = (x==-1)? //special treatment for -1
                            [-cubus_real.x/2,0,0]:
                            (x==tot+1)? //other special treatment
                            [0,-cubus_real.y/2,zmov]:
                            [sin(x/tot*90)*r-r,cos(x/tot*90)*r-r,zmov*(x/tot)];


module mb_curb(zdir=0,zoffs=cubus.z/2,anchor, spin, orient) {
   size_tube=[cubus.x,cubus.y,cubus.z]; 
    
   //curv=(cubus.x-BALL_DIA)/2; 
   curv=cubus.x/2-BRICK_WIDTH/2; //center is one of the corner studs
    
   curv_pnts=4; 
   zmov=zdir*zoffs; 
    
   attachable(anchor, spin, orient, size=size_tube) { 
       
       
       chain_hull()
        {
     move(posi(-1,curv_pnts,curv,zmov)) //first one special coords -1/4
       spheroid(r=BALL_RAY);        
    
    move(posi(0,curv_pnts,curv,zmov))
       spheroid(r=BALL_RAY);  
    move(posi(1,curv_pnts,curv,zmov))
       spheroid(r=BALL_RAY);    
    move(posi(2,curv_pnts,curv,zmov))
       spheroid(r=BALL_RAY);               
    move(posi(3,curv_pnts,curv,zmov))
       spheroid(r=BALL_RAY);   
    move(posi(4,curv_pnts,curv,zmov))
       spheroid(r=BALL_RAY);           
      
    move(posi(5,curv_pnts,curv,zmov))  //last one specialcoords 5/4
       spheroid(r=BALL_RAY);   
      
    
       
   
       
   };
    children();
   }; 
};    