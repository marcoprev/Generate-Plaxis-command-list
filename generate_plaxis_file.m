clearvars
close all
addpath('matlab_codes\');
addpath('example_commands\');
fid = fopen('outputs/myPlaxisFile.p3dlog','w');

lateral_displacement = 0.05; % 5 cm

pile_geom.pile_diameter =  0.508;
pile_geom.pile_wall_thickness = 0.04;
pile_geom.pile_depth = 3.1;
pile_geom.pile_above_mudline = 1;

putty_geom.putty_height = 0.2; % 20% of the pile diameter
putty_geom.putty_thick = 1.5;  % 1.5x of the pile wall thickness
putty_geom.damage_thick = 5;   % 5x the putty thickness

ff_generate_materials(fid);

ff_generate_pile_geometry(fid,pile_geom);

ff_generate_putty_geometry(fid,pile_geom,putty_geom);

ff_generate_initial_loads(fid,pile_geom);

ff_generate_stages(fid,pile_geom,lateral_displacement);

ff_mesh(fid);

fclose('all');