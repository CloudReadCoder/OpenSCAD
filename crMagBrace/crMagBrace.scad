include <BOSL2/std.scad>

e=0.01;

layer=0.2;

mag_d=5+0.2;
mag_h=3;
double_space=1.5;

wall=0.5;

cord_l=5;
cord4_d=4;
cord2_d=2;

$fn=64;

left(10) magbrace_strands(3,0);
back(10) joiner();
fwd(10) magbrace_double();
right(10) magbrace_single();
magbrace_three();

module magbrace_three(){
  
  inner=[3*cord2_d+2*wall,cord2_d,cord_l];
  outer=inner+[2*wall,2*wall,0];
  
  diff("remove") {
    cuboid(outer,rounding=1,edges="Z");
     tag("remove")
        {
        cyl(d=cord2_d,h=cord_l+2*e);
        left(cord2_d+wall) 
          cyl(d=cord2_d,h=cord_l+2*e);
        right(cord2_d+wall) 
          cyl(d=cord2_d,h=cord_l+2*e);    
      };    
        
  
  };
    
    
};    

module joiner(){
    
  cord_r=(4-1)/2;  
  
  inner_r=6.5/2;
  inner_l=5;
    
  outer_r=inner_r+1;
  outer_l=2*(outer_r-cord_r)+inner_l;  
    
    
  back_half()  
  diff() {
    cyl(r=outer_r,l=outer_l,rounding=outer_r-cord_r);
    tag("remove") {
      cyl(r=cord_r,l=outer_l+2*e);
      cyl(r=inner_r,l=inner_l);  
        
    };    
    
    
  };    
    
  
    
    
};


module magbrace_strands(strands,overlap){
    
   ang=360/strands;
    
    
   zrot_copies(n=strands,r=cord4_d/2-(overlap/100)*cord4_d/2)
     cyl(d=cord4_d,h=10); 
    
    
    
};    





module magbrace_double(){
   inner=[2*cord4_d-double_space,cord4_d,cord_l];
   outer=inner+[4*wall,4*wall,0];
   
   diff("neg"){ 
     hull(){
     cuboid(outer,rounding=2,edges="Z",anchor=BOTTOM )  
        position(TOP)   
        cyl(d=mag_d+4*wall,h=mag_h+4*layer,anchor=BOTTOM )   //mag top
           position(TOP) up(e)
             tag("neg") 
             cyl(d=mag_d,h=mag_h,anchor=TOP ); //mag hole 
     };  
    //down(e)
      //cuboid(inner,anchor=BOTTOM,$tags="neg");
    tag("neg")
     down(e){
      right(double_space/2)cyl(d=cord4_d,h=cord_l, anchor=BOTTOM+RIGHT );   
      left(double_space/2)cyl(d=cord4_d,h=cord_l, anchor=BOTTOM+LEFT );     
    };
   };

};    



module magbrace_single(){
diff("neg" ){
   cyl(d1=cord4_d+4*wall,d2=mag_d+4*wall,h=cord_l,anchor=BOTTOM ) //rope bottom
     position(TOP)   
        cyl(d=mag_d+4*wall,h=mag_h+4*layer,anchor=BOTTOM ) //mag top
           position(TOP) up(e)
            tag("neg") cyl(d=mag_d,h=mag_h,anchor=TOP ); //mag hole 
   
    down(e)
      tag("neg")cyl(d=cord4_d,h=cord_l, anchor=BOTTOM); //rope hole 
    
};    
};