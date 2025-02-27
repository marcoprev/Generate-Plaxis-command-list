function ff_generate_stages(fid,pile_geom,lateral_displacement)


% generate the lateral load BC
fprintf(fid,['_gotostructures\n']);
fprintf(fid,['_pointdispl -' num2str(pile_geom.pile_diameter/2) ' 0 ' num2str(pile_geom.pile_above_mudline) '\n']);
fprintf(fid,['_set Point_1.PointDisplacement.Displacement_z "Free"\n']);
fprintf(fid,['_set Point_1.PointDisplacement.Displacement_x "Prescribed"\n']);
fprintf(fid,['_set Point_1.PointDisplacement.ux ' num2str(lateral_displacement) '\n']);

fref = fopen('example_commands\stages.p3dlog','r');

while ~feof(fref)

l = fgetl(fref);

fprintf(fid,[l '\n']);

end

fclose(fref);