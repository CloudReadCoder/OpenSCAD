include <BOSL2/std.scad>


/* [HOOK SHAPE] */

// Choose between classic hook with screw-holes (0) or "bracket" system (1)

//Bracket Types
BT_NONE=0;
BT_SQUARE=1;
BT_SQUAREWITHDIVIDER=2;
BT_CLAMP=3;
BT_ROUND=4;
BT_ENDLOOP=5;

BTYPE=BT_ENDLOOP;


VAL_BRA=[0,1,1,0,0,0];
VAL_DVD=[0,0,1,0,0,0];
VAL_LOP=[0,0,0,0,0,1];


bracket=VAL_BRA[BTYPE];
bracket_adddivider=VAL_DVD[BTYPE];
endloop=VAL_LOP[BTYPE];




clamp_size=20;
clamp_dist=10;


//bracket=1; // [0, 1]
//bracket_adddivider=1; //
bracket_round=0; // [0, 1]
bracket_depth=12; //9.1; //isa
stop_length=17; //ikea


//endloop=0; //bracket and endloop are mutually exclusive


divider_length=73;



// Choose between square (0) and round bracket (1)


// Choose to have a second hook (1) or not (0)
second_hook=0; // [0, 1]




/* [MAIN HOOK SIZE] */

// Intern diameter of hook's main U shape
hook_size=8; // [0.1:250]

// Hook's "thickness" = object's width = print's height
thickness=10; // [0.1:250]


/* [BRACKET] */

// Bracket's main size
//bracket_size=12; // [0:250] ikea

// Bracket's back lenght
//stop_length=14; // [0:250]
//stop_length=9; //isa

// Bracket Stiffness (only with square bracket)
bracket_stiffness=hook_size/4; //     2.5; // [0:100]



/* [EXTRA SETTINGS] */

// Choose to have a screw-hole in square bracket (1), or not (0)
safety_screw=0; // [1, 0]

// Choose to have the hook's "triangle" extremity (1) or not (0)
extremity=1; // [1, 0]

// Choose to have screw-holes (1) or not (0)
screw_holes=0; // [1, 0]

// Choose to have the hook's rounded "top" (1) or not (0)
rounded_top=1; // [1, 0]



/* [SPACERS] */


back_size = 28.8;  //

back_size_force = 1; //


// Space between main hook and bottom screw
spacer_1=5; // [0:200]

// Space between bottom screw and secondary hook
spacer_2=5; // [0:200]

// Space between second hook and top screw
spacer_3=2; // [0:200]

// Space between top screw and hook's rounded top
spacer_4=3; // [0:200]


/*----------------------------------------------------------------------------*/
/*-------                             CODE                            --------*/
/*----------------------------------------------------------------------------*/

/*____________________________________________________________________________*/
/* [HIDDEN] */
// shortcuts
e=0.01;
stiffness=hook_size/4;

//height_bottom=hook_size;
width_global=hook_size+stiffness*2;
half_width=width_global/2-stiffness/2;
screw_hole=screw_diam+tolerance*2;
screw_house=screw_head+tolerance*2;
//bracket_move=bracket_size/2+width_global/2;
//bracket_round_diam=bracket_size+stiffness*2;
min_height1=spacer_1+screw_house/2+stiffness;
min_height2=min_height1+spacer_2/2+screw_house/2;
min_height2_hg=spacer_1+stiffness+spacer_2/2;
min_height3=min_height2+spacer_3/2+spacer_2/2;
min_height3_hg=min_height2_hg+spacer_3/2+spacer_2/2;
min_height4=min_height3+spacer_4/2+spacer_3/2+screw_house;
min_height4_hg=min_height3_hg+spacer_3/2+spacer_4/2;
space_global=spacer_1+spacer_2+spacer_3+spacer_4;
$fn=150;
//some math here,step by step, to get the length of the bottom left cutoff point
d=hook_size*2 ; //diam of big circle
w=hook_size+2*stiffness; //width of framing main hook box
ddiff=d-w;  //left side overhang
x=d/2-ddiff; //we subtract 
cosx=x/(d/2);  
angle=acos(cosx);
sinx=sin(angle);
bottomback_height=sinx*(d/2)+hook_size/2;  //this is needed for accurate backplate hight calculation
echo(bottomback_height);
//this could be compacted, but for clearness of calc sake, keep it long
echo(bracket_stiffness);


dothehook();



module endloop(anchor,spin=0,orient=UP){
    size=[thickness,thickness+thickness/4,thickness];  
    attachable(anchor , spin , orient , size=size) { 
        fwd(size.y/2) //move to center
            diff("neg","pos"){
                hull(){ 
                    cuboid([stiffness,thickness/4,thickness],anchor=FRONT,$tags="pos") 
                        position(BACK) 
                            cyl(d=thickness,l=thickness,anchor=FRONT,$tags="pos")
                                cyl(d=thickness-2*stiffness,l=thickness+2*e,$tags="neg"); 
                }; //hull
            }; //diff
        
        children(); 
   }; //end attabale
};    
   

//rule: 


module dothehook(){ 
    assert( (bracket+endloop)<=1,"Bracket and Endloop cannot be used together");
       
    hook_block(anchor=LEFT+BACK ){  //hook hole block
        position(FRONT)
            hook_bottom(anchor=BACK);    //add the bottom at the front 
        
        if (extremity==1)
            position(BACK+RIGHT) 
                hook_tip(anchor=RIGHT+FRONT);  //add the tip at the back right 
    
        position(BACK+LEFT) 
            spacer(anchor=FRONT+LEFT) { //add the spacer at the back left 
                if (BTYPE==BT_SQUARE || BTYPE==BT_SQUAREWITHDIVIDER) 
                    position(BACK+LEFT)
                        bracket_square(anchor=RIGHT+BACK);  //add bracket at the back left of the spacer
                if (endloop==1)
                    position(BACK)
                        endloop(anchor=FRONT);
                if (BTYPE==BT_CLAMP) {
                    position(BACK+LEFT)
                        cuboid([clamp_size,bracket_stiffness,thickness],anchor=RIGHT+BACK);
                    position(BACK+LEFT) fwd(clamp_dist) 
                        cuboid([clamp_size,bracket_stiffness,thickness],anchor=RIGHT+BACK);
                }; //BT_CLAMP    
            }; //spacer   
    }; //hook_block    
};

module bracket_square(anchor,spin=0,orient=UP){
    size_bracketblock=[bracket_depth+bracket_stiffness,bracket_stiffness,thickness];
    attachable(anchor , spin , orient , size=size_bracketblock) { 
        diff("neg","pos"){
            cuboid(size_bracketblock,$tags="pos",$color="pink") {
                if (bracket_adddivider==0){
                    position(LEFT+BACK)  //rounding top left
                        rounding_mask_z(l=thickness+2*e,r=bracket_stiffness,$tags="neg",$color="red"); 
                };
            position(LEFT+FRONT) //backstop
                cuboid([bracket_stiffness,stop_length,thickness],anchor=BACK+LEFT,$tags="pos"){ 
                    if (bracket_adddivider==0){ 
                        position(FRONT+LEFT) //rounding of the bracket end
                            rounding_mask_z(l=thickness+2*e,r=bracket_stiffness,$tags="neg"); 
                    };   
                    if (bracket_adddivider==1) { 
                        position(FRONT+LEFT+BOTTOM) //extension as "divider" for ikea type rails
                            cuboid([divider_length-bracket_stiffness,stop_length+bracket_stiffness,bracket_stiffness],anchor=RIGHT+FRONT+BOTTOM,$tags="pos",$color="green") {  
                                position(RIGHT+TOP) //divider fillet
                                    interior_fillet(l=stop_length+bracket_stiffness,r=thickness/2,anchor=FRONT+LEFT,spin=180,orient=BACK,$tags="pos",$color="blue");
                                position(FRONT+TOP) //divider enforcement
                                    cuboid([divider_length-bracket_stiffness,2,2],anchor=FRONT+BOTTOM,$tags="pos");
                            }; //end cuboid    
                    }; //bracket_addivide=1
                }; //backstop   
            }; //bracketblock 
        }; //diff
        children();  
    }; //attachable    
};  

module bracket_round(anchor,spin=0,orient=UP){
  size_bracket_round=[bracket_depth+2*stiffness,bracket_depth+2*stiffness,thickness];
   attachable(anchor , spin , orient , size=size_bracket_round) { 
    #tube(ir=bracket_depth/2,wall=stiffness,h=size_bracketblock.z);
    children();  
  };    
};  





module spacer(anchor, spin=0, orient=UP){
    y2=(bracket==1)?bracket_stiffness:0;
    
    y1=(back_size_force==1)?back_size-bottomback_height+y2:space_global+stiffness;
    echo(y1);
    
    size_spacer=[stiffness,y1,thickness];
    attachable(anchor, spin, orient, size=size_spacer) { 
      diff("neg","pos"){ 
       
        #cuboid(size_spacer,$tags="pos")   
         if ((rounded_top==1) && (BTYPE!=BT_ENDLOOP))
             position(RIGHT+BACK)
              rounding_mask_z(l=thickness+2*e,r=stiffness,$tags="neg");
      };    
        children();  
    };    
};    

module hook_tip(anchor,spin=0,orient=UP){
    size_tip=[stiffness,thickness/3,thickness];
    attachable(anchor, spin, orient, size=size_tip) { 
        hull(){
            position(FRONT+TOP)
                xcyl(r=stiffness/2,h=stiffness,anchor=TOP,$tags="pos"); 
            position(FRONT+BOTTOM)
                xcyl(r=stiffness/2,h=stiffness,anchor=BOTTOM); 
            position(BACK+TOP)  
                down(size_tip.y)xcyl(r=stiffness/2,h=stiffness,anchor=BACK); 
            position(BACK+BOTTOM)  
                up(size_tip.y)xcyl(r=stiffness/2,h=stiffness,anchor=BACK);  
        }; //hull  
    /*
    diff("neg","pos"){  
      cuboid(size_tip,$tags="pos"){
        position(BACK+TOP)
           chamfer_mask_x(l=stiffness,chamfer=size_tip.y,$tags="neg");  
        position(BACK+BOTTOM)
           chamfer_mask_x(l=stiffness,chamfer=size_tip.y,$tags="neg");    
      };    
    };
    */  
        children();
    }; //attachable
};


module hook_block(anchor, spin=0, orient=UP){
    size_hookblock=[hook_size+2*stiffness,hook_size/2,thickness];
    //this is the hookblock
    attachable(anchor, spin, orient, size=size_hookblock) { 
    diff("neg","pos")
        cuboid(size_hookblock,$tags="pos") {  //main block of the hook
            position(BACK)
                cyl(d=hook_size,h=thickness+2*e,$tags="neg"); //hook hole centered on back
            if (extremity==0) { //make nice round corners if no tip
              position(BACK+TOP)
                  rounding_mask_x(l=stiffness*4,r=stiffness/2,anchor=LEFT,$tags="neg");   
              position(BACK+BOTTOM)
                  rounding_mask_x(l=stiffness*4,r=stiffness/2,anchor=LEFT,$tags="neg");  
            };
            
        };    
    children();  
  };    
    
};    
module hook_bottom(anchor, spin=0, orient=UP){ 
    big_r=hook_size/5;
    small_r=stiffness/2;
    
    size_bottom=[hook_size+2*stiffness,hook_size,thickness];
    
    attachable(anchor, spin, orient, size=size_bottom){   
       difference(){ 
        intersection(){
          cuboid(size_bottom );
          translate([-stiffness,size_bottom.y/2,0])cyl(d=hook_size*2,l=thickness  );
        };
        
         hull ()
        {
            translate ([-big_r/2-stiffness/4,0,0])
            cyl (r=big_r, h=thickness+2*e );

            translate ([big_r,stiffness/2,0])
            cyl (r=small_r, h=thickness+2*e);

        }
    }; 
       
     children();
    };
};    

