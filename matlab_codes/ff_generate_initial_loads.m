function ff_generate_initial_loads(fid,pile_geom)

% i need to think how i want to define the initial load, for now just ICP-18
h = sqrt((pile_geom.pile_diameter/2)^2-(pile_geom.pile_diameter/2-pile_geom.pile_wall_thickness)^2);
vec_y = -linspace(1e-3,pile_geom.pile_depth,1000);
vec_sigr = 0.01*15e3*(-vec_y/h).^-0.84;



n_slices = 25;
vec_z = linspace(0,pile_geom.pile_depth,n_slices+1);

fprintf(fid,['_gotostructures\n']);
fprintf(fid,['_rename Surface_1 "TipDisk"\n']);

% first, remove the portion above the ground
fprintf(fid,['_set PileDisk.z 0\n']);
fprintf(fid,['_intersect (Pile_geometry PileDisk)\n']);
fprintf(fid,['_rename Surface_1 "AboveGround"\n']);
fprintf(fid,['_rename Surface_2 "PileDisk"\n']);
fprintf(fid,['_rename Surface_3 "Pile_geometry"\n']);
for i = 2:n_slices
% move slice
fprintf(fid,['_set PileDisk.z -' num2str(vec_z(i)) '\n']);
% cut
fprintf(fid,['_intersect (Pile_geometry PileDisk)\n']);
% rename because plaxis
fprintf(fid,['_rename Surface_1 "Shaft_' num2str(i-1) '"\n']);
fprintf(fid,['_rename Surface_2 "PileDisk"\n']);
fprintf(fid,['_rename Surface_3 "Pile_geometry"\n']);

% identify the local change in lateral stress
i1 = length(vec_y)-find(abs(vec_y+vec_z(i))==min(abs(vec_y+vec_z(i))),1);
i2 = length(vec_y)-find(abs(vec_y+vec_z(i-1))==min(abs(vec_y+vec_z(i-1))),1);
if isempty(i2) i2 = length(vec_y); end

sigr = flipud(vec_sigr([i1,i2]));
y = vec_y([i1,i2]);


SigZ = diff(sigr)/diff(y);
refZ = y(1);
refSig=sigr(1);


% assign the normal stress
fprintf(fid,['_surfload  Shaft_' num2str(i-1) '\n']);
fprintf(fid,['_set  Shaft_' num2str(i-1) '.SurfaceLoad.Distribution "Perpendicular, vertical increment"\n']);
fprintf(fid,['_set  Shaft_' num2str(i-1) '.SurfaceLoad.sign_ref ' num2str(-refSig) '\n']);
fprintf(fid,['_set  Shaft_' num2str(i-1) '.SurfaceLoad.sign_inc ' num2str(refZ) '\n']);

end

fprintf(fid,['_rename Pile_geometry "Shaft_' num2str(i) '"\n']);



sigr = flipud(vec_sigr([1,i1]));
y = vec_y([1,i1]);


SigZ = diff(sigr)/diff(y);
refZ = y(1);
refSig=sigr(1);

% assign the normal stress
fprintf(fid,['_surfload  Shaft_' num2str(i) '\n']);
fprintf(fid,['_set  Shaft_' num2str(i) '.SurfaceLoad.Distribution "Perpendicular, vertical increment"\n']);
fprintf(fid,['_set  Shaft_' num2str(i) '.SurfaceLoad.sign_ref ' num2str(-refSig) '\n']);
fprintf(fid,['_set  Shaft_' num2str(i) '.SurfaceLoad.sign_inc ' num2str(refZ) '\n']);