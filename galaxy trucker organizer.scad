include <../snap box/snap box.scad>

// Which part(s) to render.
render_part_gt = "all";	// [box,tray,lid,all]

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
snap_band_thickness = 0.6;
snap_band_position = "middle";
snap_band_percentage = 60;
snap_band_ridge_difference_radius = 0.1;
snap_band_ridge_difference_length = 4;
gap = 0.1;
inner_half_shell_ratio = 0.6;

// organizer settings
lower_tray_net_height = 22;
upper_tray_bottom_thickness = 2;
upper_tray_top_margin = 0.5;
upper_tray_net_height = height - lower_tray_net_height - upper_tray_bottom_thickness - upper_tray_top_margin;
upper_tray_side_margin = 0.7;
upper_tray_shell_thickness = 1.2;
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

display_ghost_tray = false;

$fs = 0.2;
$fa = 3;


if (render_part_gt=="box")
{
	lower_box();
}
else if (render_part_gt=="tray")
{
	upper_tray();
}
else if (render_part_gt=="lid")
{
	lid();
}
else if (render_part_gt=="all")
{
	union()
	{
		lower_box();
		translate([box_outer_size[0] + box_and_lid_distance, 0, 0])
		{
			upper_tray();
			translate([box_outer_size[0] + box_and_lid_distance, 0, 0])
				lid();
		}
	}
}
else
{
	assert(false,"No valid part selected");
}

module lower_box()
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
						cup([width-credit_length-wall_thickness, humans_box_y_size], cup_r, svg="img/human.svg", img_z_rotation=-90, img_scale=0.3);
					
					// cubes
					translate([credit_length + wall_thickness, end_of_credits_wall_y + wall_thickness])
						cup([width-credit_length-wall_thickness, cubes_size_y], cup_r, svg="img/cube.svg", img_z_rotation=-90, img_scale=0.3);
					
					// aliens
					translate([0, hourglass_box_y_size + wall_thickness])
						cup([aliens_box_x_size, end_of_credits_wall_y-hourglass_box_y_size-wall_thickness], cup_r, svg="img/alien.svg", img_z_rotation=-90, img_scale=0.3);
					
					// ships
					translate([aliens_box_x_size+wall_thickness, hourglass_box_y_size + wall_thickness])
						cup([width-aliens_box_x_size-dice_box_x_size-wall_thickness, end_of_credits_wall_y-hourglass_box_y_size-wall_thickness], cup_r, svg="img/ship.svg", img_z_rotation=-90, img_scale=0.7);
					
					// dice (special, just an etched flat floor)
					translate([width-dice_box_x_size, hourglass_box_y_size + wall_thickness])
						etched_floor([dice_box_x_size, end_of_credits_wall_y-hourglass_box_y_size-wall_thickness], svg="img/dice.svg", img_z_rotation=-90, img_scale=0.5);
					
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
	
	// transparent upper tray
	if (display_ghost_tray)
	{
		translate([shell_thickness + upper_tray_side_margin, shell_thickness + upper_tray_side_margin, shell_thickness + lower_tray_net_height])
		{
			color("#ff80ff30")
				%upper_tray();
		}
	}
}

module upper_tray()
{
	upper_tray_outer_width = width - upper_tray_side_margin * 2;
	upper_tray_inner_width = upper_tray_outer_width - 2 * upper_tray_shell_thickness;
	upper_tray_outer_small_width = width - credit_length - wall_thickness - 2 * upper_tray_side_margin;
	upper_tray_inner_small_width = upper_tray_outer_small_width - 2 * upper_tray_shell_thickness;
	upper_tray_outer_length = length - upper_tray_side_margin * 2 - humans_box_y_size - wall_thickness;
	upper_tray_inner_length = upper_tray_outer_length - 2 * upper_tray_shell_thickness;
	upper_tray_outer_south_length = length - len(credit_numbers)*(credit_width+credit_wall_thickness) - upper_tray_side_margin * 2;
	upper_tray_inner_south_length = upper_tray_outer_south_length - 2 * upper_tray_shell_thickness;
	
	small_part_x_offset = upper_tray_outer_width - upper_tray_outer_small_width;
	start_tiles_x_size = upper_tray_inner_width - upper_tray_inner_small_width - wall_thickness;
	
	start_tiles_position = [0, 0, 0];
	start_tiles_size = [start_tiles_x_size, upper_tray_inner_south_length, upper_tray_net_height+0.001];
	
	titles_position = [start_tiles_x_size + wall_thickness, 0, 0];
	titles_size = [upper_tray_inner_small_width, upper_tray_inner_south_length, upper_tray_net_height+0.001];
	
	batteries_position = [titles_position[0], titles_size[1]+wall_thickness,0];
	batteries_size = [titles_size[0], titles_size[1], upper_tray_net_height+0.001];
		
	difference()
	{
		union()
		{
			cube([upper_tray_outer_width, upper_tray_outer_south_length, upper_tray_bottom_thickness + upper_tray_net_height]);
			translate([small_part_x_offset,upper_tray_outer_south_length-0.001,0])
			{
				cube([upper_tray_outer_small_width, upper_tray_outer_length - upper_tray_outer_south_length, upper_tray_bottom_thickness+upper_tray_net_height]);
			}
		}

		translate([upper_tray_shell_thickness, upper_tray_shell_thickness, upper_tray_bottom_thickness])
		{
			cube(start_tiles_size);
			
			translate(titles_position)
			{
				cube(titles_size);
			}
			
			translate(batteries_position)
			{
				cube(batteries_size);
			}
		}
	}
	
	// floor etchings & cups
	translate([upper_tray_shell_thickness, upper_tray_shell_thickness, upper_tray_bottom_thickness])
	{
		// start tiles
		translate(start_tiles_position)
		{
			etched_floor(start_tiles_size, svg="img/start_tile.svg", img_z_rotation=-90, img_scale=0.22);
		}
		
		// titles
		translate(titles_position)
		{
			etched_floor(titles_size, svg="img/title_edge.svg", img_z_rotation=-90, img_scale=0.6);
		}
		
		// batteries
		translate(batteries_position)
			cup(batteries_size, cup_r*1.5, svg="img/battery.svg", img_z_rotation=-90, img_scale=1.3);
	}
		
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

module cup(size, r, text=undef, png=undef, svg=undef, img_z_rotation=0, img_scale=1)
{
	difference()
	{
		translate([-0.001,-0.001,0])
			cube([size[0]+0.002,size[1]+0.002,r]);
		translate([size[0]/2,size[1]/2,0])
		{
			union()
			{
				// inner sphere (floor)
				translate([0,0,r + etch_depth]) sphere(r=r);
				
				// spherical etch
				intersection()
				{
					translate([0,0,r])
						sphere(r=r);
					
					etching(h=r, text=text, svg=svg, img_z_rotation=img_z_rotation, img_scale=img_scale);
				}
			}
		}
	}
}

module etched_floor(size, text=undef, png=undef, svg=undef, img_z_rotation=0, img_scale=1)
{
	translate([-0.001,-0.001,0])
	{
		difference()
		{
			cube([size[0]+0.002,size[1]+0.002,etch_depth]);
			
			translate([size[0]/2,size[1]/2,0])
			{
				etching(h=etch_depth+0.001, text=text, svg=svg, img_z_rotation=img_z_rotation, img_scale=img_scale);
			}
		}
	}
}

module etching(h, text=undef, svg=undef, img_z_rotation=0, img_scale=1)
{
	if (svg!=undef)
	{
		rotate([0,0,img_z_rotation])
		{
			scale([img_scale,img_scale,1])
			{
				linear_extrude(height=h)
				{
					import(file=svg, center=true);
				}
			}
		}
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