include <BOSL2/std.scad>
include <BOSL2/hingesnaps.scad>

e=0.01;
$fn=64;

box_outer=[60,60,40];
hingesize=[0,20,5];


box_wall=1.2;
box_inner=box_outer-[2*box_wall,2*box_wall,box_wall];
box_rounding=4;


//lid_outer=box_outer+[0,0,-box_outer.z+5];
lid_outer=[box_outer.x,box_outer.y,hingesize.z];
lid_inner=[lid_outer.x-2*box_wall,lid_outer.y-2*box_wall,box_wall];
lid_hollow=[lid_inner.x-2*box_wall,lid_inner.y-2*box_wall,lid_outer.z];

handle=[box_wall,lid_outer.y/4,5];
//handle2=[box_wall,lid_outer.y/4,box_wall];


hingew1=2*hingesize.z+0.4+1*0.8;  //0.4=snap_g 2*footdepth
hingew2=hingesize.z+0.4+0.8;
centerw=box_outer.z-hingew1-hingew2;

folded=0;

orient1=(folded==0)?UP:RIGHT;
anchor1=(folded==0)?RIGHT+BOTTOM:RIGHT+TOP;
offset1=(folded==0)?0:0.8; //0.8 footdepth

posit2=(folded==0)?LEFT+BOTTOM:LEFT+TOP;
//anchor2=(folded==0)?RIGHT+BOTTOM:RIGHT+BOTTOM;

diff("n","p"){
cuboid(box_outer,rounding=box_rounding,except_edges=[TOP,BOTTOM],$tags="p")
  position(LEFT+BOTTOM)
    down(offset1)hinge(hingesize,footdepth=0.8,socketdepth=2,anchor=anchor1,orient=orient1,$color="blue")
       position(LEFT+BOTTOM)
          cuboid([centerw,hingesize.y,hingesize.z],anchor=BOTTOM+RIGHT,$color="gold") 
              position(LEFT+BOTTOM)
                 hinge(hingesize,footdepth=0.8,socketdepth=2,anchor=RIGHT+BOTTOM,$color="blue")  
                   position(posit2)
                      right(offset1)cuboid(lid_outer,rounding=box_rounding,except_edges=[TOP,BOTTOM],anchor=RIGHT+BOTTOM,orient=orient1,$color="red",$tags="p"){
                        attach(TOP,norot=true)
                           cuboid(lid_inner,rounding=box_rounding-box_wall,anchor=BOTTOM,except_edges=[TOP,BOTTOM],$color="orange",$tags="p") 
                             position(TOP)
                                up(e)cuboid(lid_hollow,rounding=box_rounding-2*box_wall,,except_edges=[TOP,BOTTOM],anchor=TOP,$tags="n");
                        position(LEFT+BOTTOM)  
                            cuboid(handle,anchor=BOTTOM+RIGHT,$color="orange");
                      };   

 up(box_wall)cuboid(box_inner,rounding=box_rounding-box_wall,except_edges=[TOP],$tags="n");
};


module hinge(hingesize,socketdepth=2,footdepth=4, layer_h=0.2,anchor=CENTER,spin=0,orient=UP){




snap_t=hingesize.z;
snap_oal=hingesize.y;

snap_r=snap_t/2; //rounding
snap_g=0.4;  //gap between 2 sockets on same side
airgap=0.8;
foot_h=footdepth; //height of socket foot


prot_b=layer_h*3;   //border arund protrustion
prot_r=snap_r-prot_b;
prot_r2=prot_r*0.2;
prot_l=prot_r*1.50;  //length of protrusion

sock_d=socketdepth;  //depth of socket (y axis)
sock_t=snap_t;  //thickness (z axis, same as snap
sock_w=snap_t ;  //half

snap_l=snap_oal-2*sock_d-2*airgap;

snap_inner=[2*snap_t+snap_g,snap_l,snap_t];
sock=[sock_w,sock_d,sock_t];
foot=[foot_h,sock.y,sock.z];


size_hingeblock=[snap_inner.x+2*foot.x-2*e,snap_oal,snap_t];

attachable(anchor , spin , orient , size=size_hingeblock) { 

diff("neg","pos",keep="keep")
cuboid(snap_inner,rounding=snap_r,edges=[LEFT+TOP,RIGHT+TOP],$tags="pos"){ //removed LEFT+BOTTOM and RIGHT BOTTOM
    //the protrusions
    position(FRONT+LEFT)right(prot_b)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=BACK,anchor=BOTTOM+LEFT,$tags="neg");
    position(FRONT+RIGHT)left(prot_b)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=BACK,anchor=BOTTOM+RIGHT,$tags="neg");
    position(BACK+LEFT)right(prot_b)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=FRONT,anchor=BOTTOM+LEFT,$tags="neg");
    position(BACK+RIGHT)left(prot_b)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=FRONT,anchor=BOTTOM+RIGHT,$tags="neg");  
    //the sockets
    position(FRONT+LEFT)fwd(airgap)cuboid(sock,rounding=snap_r,edges=[RIGHT+TOP],anchor=BACK+LEFT,$tags="keep"){  //removed RIGHTBOTTOMM
        position(BACK)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=BACK,anchor=BOTTOM,$tags="keep"); 
        position(LEFT) cuboid(foot,anchor=RIGHT,$tags="keep");  
    };    
    position(FRONT+RIGHT)fwd(airgap)cuboid(sock,rounding=snap_r,edges=[LEFT+TOP],anchor=BACK+RIGHT,$tags="keep"){  //rem leftbottom
        position(BACK)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=BACK,anchor=BOTTOM,$tags="keep"); 
        position(RIGHT) cuboid(foot,anchor=LEFT,$tags="keep"); 
    };    
    position(BACK+LEFT)back(airgap)cuboid(sock,rounding=snap_r,edges=[RIGHT+TOP ],anchor=FRONT+LEFT,$tags="keep"){ //rem rightbott
        position(FRONT)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=FRONT,anchor=BOTTOM,$tags="keep"); 
        position(LEFT) cuboid(foot,anchor=RIGHT,$tags="keep");
    };    
    position(BACK+RIGHT)back(airgap)cuboid(sock,rounding=snap_r,edges=[LEFT+TOP],anchor=FRONT+RIGHT,$tags="keep"){   //rem leftbott
        position(FRONT)cyl(r1=prot_r,r2=prot_r2,l=prot_l,orient=FRONT,anchor=BOTTOM,$tags="keep"); 
        position(RIGHT) cuboid(foot,anchor=LEFT,$tags="keep"); 
    
    };
   //the socket lengthside connectors
   //position(RIGHT) right(airgap)cuboid([foot.x-airgap,snap_inner.y+2*airgap+2*e,snap_t],anchor=LEFT,$tags="keep"); //+2*e to be sure 
   //position(LEFT) left(airgap)cuboid([foot.x-airgap,snap_inner.y+2*airgap+2*e,snap_t],anchor=RIGHT,$tags="keep"); 
};
  children();
 };



};

 



/*

box_size_total=[50,100,50];
box_walls=5;

lid_thick=10;

//box_size=[box_size_total.x,box_size_total.y,box_size_total.z-lid_thick];
lid_size=[box_size.x,box_size.y,lid_thick];

side_slot_depth=2;
side_slot=[box_walls-side_slot_depth,box_size.y/3,box_size.z];


hinge_size=[10,box_size.y/3,box_walls-2];
side_size=[box_size.z-2*hinge_size.x,hinge_size.y,hinge_size.z];

module fullbox(){
diff("neg","pos"){
cuboid(box_size,anchor=BOTTOM,$tags="pos") {
  position(LEFT+BOTTOM)
    cuboid(hinge_size,anchor=RIGHT,$tags="pos") //first hinge close to box
      position(LEFT+BOTTOM)
        cuboid(side_size,anchor=RIGHT,$tags="pos") //lateral panel
          position(LEFT+BOTTOM)
            cuboid(hinge_size,anchor=RIGHT,$tags="pos")   //second hinge close to lid
              position(LEFT+BOTTOM)
                cuboid(lid_size,anchor=RIGHT,$tags="pos");  
   position(LEFT+BOTTOM)
     #cuboid(side_slot,$tags="neg",anchor=BOTTOM+LEFT); 
    
  };  
};

};


echo(hinge_size);

$fn=64;

gap=0.2; //between outer and inner

dia1=hinge_size.z;
dia2=hinge_size.z*0.25;
module kabes(){
diff("neg","pos") 
  cuboid([dia1,dia1,dia1],anchor=LEFT,$tags="pos")
    position(LEFT)
      left(e)xcyl(d1=dia1,d2=dia2,l=dia1/2,anchor=LEFT,$tags="neg");

left(0.1)xcyl(d1=dia1-gap,d2=dia2-gap,l=dia1/2,anchor=LEFT);
  #left(0.1+dia1 )cuboid([dia1,dia1,dia1],anchor=LEFT);
//snap_lock(thick=side_slot_depth,snaplen=20,snapdiam=10);
};

*/