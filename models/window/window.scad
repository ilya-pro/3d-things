// window
// @author Ilya Protasov

/*
TODO
- complete step
- complete front side of frame
- gap_width
- gap_thick

- back side of frame
- slide window
- open window on hinge
*/

window_width = 60;
window_height = 45;
window_thick = 1;
window_frame_width = 6;
window_central_width = 4;

frame_thick = 1;
frame_width = 6;
frame_step_in = 1;
frame_step_out = 2;
frame_step_depth = 5;

// gap between window and frame
gap_window_width = .2;

module window(width, height, thick) {
    difference() {
       cube([width, height, thick], true);
       cube([width - window_frame_width * 2,
             height - window_frame_width * 2, thick * 1.01],         true);
    }
    // cross
    cube([window_central_width, height, thick], true);
    cube([width, window_central_width, thick], true);
}

module frame(width, height, thick) {
    difference() {
       union() {
           // outer
           cube([width + (frame_width - frame_step_in) * 2,
                height + (frame_width - frame_step_in) * 2,
                thick], true);
           // inner step
           translate([0, 0, (frame_step_depth + thick)/2])
                cube([width + (frame_step_out) * 2,
                    height + (frame_step_out) * 2,
                    frame_step_depth], true);
       }

       translate([0, 0, frame_step_depth/2])
       cube([width - frame_step_in * 2,
             height - frame_step_in * 2,
             (thick + frame_thick + frame_step_depth) * 1.01],         true);
    }
}

#window(window_width, window_height, window_thick);
color("lightYellow")
 translate([0, 0, -window_thick - frame_step_depth])
    frame(width = window_width,
          height = window_height,
          thick = window_thick);

*color("lightYellow") cube([200, 150, .5], true);
