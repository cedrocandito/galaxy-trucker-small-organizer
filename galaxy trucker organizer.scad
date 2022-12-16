include <../snap box/snap box.scad>

// prevent customizer from showing the variables
module __Customizer_Limit__ () {}

// snap box settings
render_part = "none";
length = 177;
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
render_part_gt = "all";
etch_depth = 0.6;
font = "Arial";
credit_corner_size = 3.5;
credit_width = 21;
credit_length = 44;
credit_height = 1.7;
credit_upper_margin = 1.5;
credit_wall_thickness = 1;
credit_hole_width = 14;
credit_numbers = [13, 21, 12, 18, 4];
credit_names = ["1₵", "2₵", "5₵", "10₵", "50₵"];
credit_font_size = 14;

$fs = 0.2;
$fa = 3;


if (render_part_gt=="box1")
{
	box1();
}
else if (render_part_gt=="box2")
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
			translate([shell_thickness-credit_wall_thickness, length + shell_thickness + credit_wall_thickness, shell_thickness]) rotate([0,0,-90])
			{
				for (i=[0:len(credit_numbers)-1])
				{
					translate([i*(credit_width+credit_wall_thickness),0,0])
					{
						credit_box_padded(credit_numbers[i],credit_names[i]);
					}
				}
			}
				
				
		}
		
		// subtractions
		
		// crddit boxes holes
		translate([0, length + shell_thickness + credit_wall_thickness, shell_thickness]) rotate([0,0,-90])
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
	outer_size = [credit_width+2*credit_wall_thickness, credit_length+credit_wall_thickness, height];

	difference()
	{
		cube(outer_size);
		translate([credit_wall_thickness-0.001,0,0])
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
		translate([0,credit_wall_thickness,0])
		{
			credit_box_full_height();
			translate([credit_wall_thickness-0.001, 0, 0])
			{
				difference()
				{
					cube([credit_width,credit_length,padding_height]);
					translate([credit_width/2+credit_wall_thickness, credit_length/2+credit_wall_thickness, padding_height-etch_depth])
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
}

module credit_box_hole(number_of_tiles)
{
	padding_height = height - credit_upper_margin - credit_height*number_of_tiles;
	translate([(credit_width-credit_hole_width)/2+credit_wall_thickness, -0.001, padding_height])
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