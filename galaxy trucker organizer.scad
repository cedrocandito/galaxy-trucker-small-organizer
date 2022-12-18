include <../snap box/snap box.scad>

// prevent customizer from showing the variables
module __Customizer_Limit__ () {}

// snap box settings
render_part = "none";
length = 176;
width = 106;
height = 38;
lid_wall_height = 13;
shell_thickness = 2.5;
corner_radius = 1;
snappy_flaps = false;
snap_band_width = 4;
snap_band_thickness = 0.5;
snap_band_position = "middle";
snap_band_percentage = 60;
snap_band_ridge_difference_radius = 0.1;
snap_band_ridge_difference_length = 4;
gap = 0.1;
inner_half_shell_ratio = 0.6;

// organizer settings
render_part_gt = "box";
lower_tray_net_height = 22;
upper_tray_bottom_thickness = 2;
upper_tray_margin = 0.5;
upper_tray_net_height = height - lower_tray_net_height - upper_tray_bottom_thickness - upper_tray_margin;
etch_depth = 0.6;
font = "Arial";
wall_thickness = 1;
credit_corner_size = 3.5;
credit_width = 21;
credit_length = 44;
credit_height = 1.7;
credit_upper_margin = 1.5;
credit_wall_thickness = wall_thickness;
credit_hole_width = 14;
credit_numbers = [13, 21, 12, 18, 4];
credit_names = ["1₵", "2₵", "5₵", "10₵", "50₵"];
credit_font_size = 14;
humans_box_y_size = 45;
hourglass_box_y_size = 23;
dice_box_x_size = 24;
aliens_box_x_size = 40;
cup_r = 120;
tray_support_size = 4;

$fs = 0.2;
$fa = 3;


if (render_part_gt=="box")
{
	box1();
}
else if (render_part_gt=="tray")
{
	box2();
}

else if (render_part_gt=="lid")
{
	lid();
}
else if (render_part_gt=="all")
{
	union()
	{
		box1();
		translate([box_outer_size[0] + box_and_lid_distance, 0, 0])
		{
			box2();
			translate([box_outer_size[0] + box_and_lid_distance, 0, 0])
				lid();
		}
	}
}
else
{
	assert(false,"No valid part selected");
}

module box1()
{
	difference()
	{
		union()
		{
			box();
			// additions
			
			// credit boxes
			translate([shell_thickness, length + shell_thickness, shell_thickness]) rotate([0,0,-90])
			{
				for (i=[0:len(credit_numbers)-1])
				{
					translate([i*(credit_width+credit_wall_thickness),0,0])
					{
						credit_box_padded(credit_numbers[i],credit_names[i]);
					}
				}
			}
			
			translate([shell_thickness,shell_thickness,shell_thickness])
			{
				// walls
				{
					end_of_credits_wall_y = length-len(credit_numbers)*(credit_width+credit_wall_thickness);
					dice_ships_aliens_size_y  = end_of_credits_wall_y - hourglass_box_y_size - wall_thickness;
					cubes_size_y = length - end_of_credits_wall_y - humans_box_y_size - wall_thickness * 2;
					
					// along y
					translate([aliens_box_x_size, hourglass_box_y_size+wall_thickness - 0.001, 0])
						cube([wall_thickness, dice_ships_aliens_size_y +0.002, lower_tray_net_height]);
					
					translate([width-dice_box_x_size-wall_thickness, hourglass_box_y_size + wall_thickness-0.001, 0])
						cube([wall_thickness, dice_ships_aliens_size_y + 0.002, lower_tray_net_height]);
					
					// along x
					translate([credit_length+wall_thickness-0.001,length-humans_box_y_size-wall_thickness,0])
						cube([width-credit_length-wall_thickness+0.002,wall_thickness,height]);
					
					translate([credit_length+wall_thickness-0.001, end_of_credits_wall_y,0])
						cube([width-credit_length-wall_thickness+0.002,wall_thickness,lower_tray_net_height]);
					
					translate([-0.001, hourglass_box_y_size,0])
						cube([width+0.002,wall_thickness,lower_tray_net_height]);
				}
				
				// cups
				{
					// humans
					translate([credit_length + wall_thickness, length - humans_box_y_size])
						cup([width-credit_length-wall_thickness, humans_box_y_size], cup_r);
					
					// cubes
					translate([credit_length + wall_thickness, end_of_credits_wall_y + wall_thickness])
						cup([width-credit_length-wall_thickness, cubes_size_y], cup_r);
					
					// aliens
					translate([0, hourglass_box_y_size + wall_thickness])
						cup([aliens_box_x_size, end_of_credits_wall_y-hourglass_box_y_size-wall_thickness], cup_r);
					
					// ships
					translate([aliens_box_x_size+wall_thickness, hourglass_box_y_size + wall_thickness])
						cup([width-aliens_box_x_size-dice_box_x_size-wall_thickness, end_of_credits_wall_y-hourglass_box_y_size-wall_thickness], cup_r);
					
					// hourglass (special, cylindrical)
					difference()
					{
						translate([-0.001,-0.001,0])
							cube([width,hourglass_box_y_size+0.002,hourglass_box_y_size/2]);
						translate([0,hourglass_box_y_size/2,hourglass_box_y_size/2])
							rotate([0,90,0])
								cylinder(r=hourglass_box_y_size/2,h=width+0.001);
					}
				}
				
				// tray supports
				{
					// se
					tray_support();
					
					// ne
					translate([width,0,0])
						rotate([0,0,90])
							tray_support();
					
					// sw
					translate([credit_length+wall_thickness,length-humans_box_y_size-wall_thickness,0])
						rotate([0,0,-90])
							tray_support();
					
					// nw
					translate([width,length-humans_box_y_size-wall_thickness,0])
						rotate([0,0,180])
							tray_support();
					
					// w
					translate([0,end_of_credits_wall_y,0])
						rotate([0,0,-90])
							tray_support();
					
					// e
					translate([width,end_of_credits_wall_y,0])
						rotate([0,0,180])
							tray_support();
				}
			}
		}
		
		// subtractions
		
		// crddit boxes holes
		translate([shell_thickness, length + shell_thickness, shell_thickness]) rotate([0,0,-90])
			{
				for (i=[0:len(credit_numbers)-1])
				{
					translate([i*(credit_width+credit_wall_thickness),0,0])
					{
						credit_box_hole(credit_numbers[i]);
					}
				}
			}
	}
}

module box2()
{
	box();
}

module credit_silhouette(width,length,corner_size)
{
	polygon([
		[corner_size, 0],
		[width - corner_size, 0],
		[width, corner_size],
		[width, length - corner_size],
		[width - corner_size, length],
		[corner_size, length],
		[0, length - corner_size],
		[0, corner_size]
	]);
}

module credit_box_full_height()
{
	inner_size = [credit_width,credit_length,height];
	outer_size = [credit_width+credit_wall_thickness, credit_length+credit_wall_thickness, height];

	difference()
	{
		cube(outer_size);
		translate([-0.001,0,0])
		{
			linear_extrude(height=height+0.01)
			{
				credit_silhouette(credit_width,credit_length,credit_corner_size);
			}
		}
	}
}

module credit_box_padded(number_of_tiles, etch_text)
{
	padding_height = height - credit_upper_margin - credit_height*number_of_tiles;
	assert(padding_height >= etch_depth);
	union()
	{
		credit_box_full_height();
		translate([-0.001, 0, 0])
		{
			difference()
			{
				cube([credit_width,credit_length,padding_height]);
				translate([credit_width/2, credit_length/2, padding_height-etch_depth])
				{
					linear_extrude(height=etch_depth+0.01)
					{
						rotate([0,0,90]) text(text=etch_text, size=credit_font_size, font=font, halign="center", valign="center");
					}
				}
			}
		}
	}
}

module credit_box_hole(number_of_tiles)
{
	padding_height = height - credit_upper_margin - credit_height*number_of_tiles;
	translate([(credit_width-credit_hole_width)/2, -shell_thickness-0.001, padding_height])
	{
		cube([credit_hole_width, shell_thickness+credit_corner_size, height-padding_height+0.001]);
		{
			difference()
			{
				translate([0,0,-shell_thickness])
					cube([credit_hole_width,shell_thickness,shell_thickness+0.001]);
				
				translate([0,shell_thickness,-shell_thickness])
					rotate([0,90,0])
						cylinder(r=shell_thickness, h=credit_hole_width);
			}
		}
	}
}

module cup(size,r)
{
	difference()
	{
		translate([-0.001,-0.001,0])
			cube([size[0]+0.002,size[1]+0.002,r]);
		translate([size[0]/2,size[1]/2,r])
			sphere(r=r);
	}
}

module tray_support()
{
	linear_extrude(height=lower_tray_net_height)
	{
		polygon([
			[-0.001,-0.001],
			[tray_support_size,-0.001],
			[-0.001,tray_support_size]
		]);
	}
	
}