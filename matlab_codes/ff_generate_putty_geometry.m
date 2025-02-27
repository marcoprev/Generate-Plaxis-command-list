function ff_generate_putty_geometry(fid,pile_geom,putty_geom)


% geom params
putty_thickness = pile_geom.pile_wall_thickness * putty_geom.putty_thick; % it's an assumption idk
damage_thickness = putty_thickness * (putty_geom.damage_thick+1); % 5 times the putty thickness
below_tip_height = pile_geom.pile_diameter * putty_geom.putty_height; % 20%? idk

radPutty = num2str(pile_geom.pile_diameter/2 + putty_thickness);
radDamage = num2str(pile_geom.pile_diameter/2 + damage_thickness);
extrudeZ = num2str(pile_geom.pile_depth + below_tip_height);
extrudeZDamage = num2str(pile_geom.pile_depth + below_tip_height*5);

% generate the putty torus
fprintf(fid,['_polycurve 0 0 0 1 0 0 0 1 0\n']);
fprintf(fid,['_set Polycurve_1.Offset1 -' radPutty '\n']);
fprintf(fid,['_reset Polycurve_1 "Arc" 0 180 ' radPutty ' "Arc" 0 180 ' radPutty '\n']);
fprintf(fid,['_delete (Polycurve_1.Segments[1])\n']);
fprintf(fid,['_set Polycurve_1.Segments[0].ArcProperties.RelativeStartAngle1 90\n']);
fprintf(fid,['_set Polycurve_1.Offset1 ' radPutty '\n']);
fprintf(fid,['_rename Polycurve_1 "PuttyRing"\n']);
fprintf(fid,['_close PuttyRing\n']);
fprintf(fid,['_surface PuttyRing\n']);
fprintf(fid,['_rename Surface_1 "PuttyDisk"\n']);
fprintf(fid,['_extrude (PuttyDisk) 0 0 -' extrudeZ '\n']);


% generate the damage area
fprintf(fid,['_polycurve 0 0 0 1 0 0 0 1 0\n']);
fprintf(fid,['_set Polycurve_1.Offset1 -' radDamage '\n']);
fprintf(fid,['_reset Polycurve_1 "Arc" 0 180 ' radDamage ' "Arc" 0 180 ' radDamage '\n']);
fprintf(fid,['_delete (Polycurve_1.Segments[1])\n']);
fprintf(fid,['_set Polycurve_1.Segments[0].ArcProperties.RelativeStartAngle1 90\n']);
fprintf(fid,['_set Polycurve_1.Offset1 ' radDamage '\n']);
fprintf(fid,['_rename Polycurve_1 "DamageRing"\n']);
fprintf(fid,['_close DamageRing\n']);
fprintf(fid,['_surface DamageRing\n']);
fprintf(fid,['_rename Surface_1 "DamageDisk"\n']);
fprintf(fid,['_extrude (DamageDisk) 0 0 -' extrudeZDamage '\n']);

fprintf(fid,['_gotostructures\n']);
fprintf(fid,['_close Curve_pile\n']);
fprintf(fid,['_surface Curve_pile\n']);
fprintf(fid,['_rename Surface_1 "PileDisk"\n']);
fprintf(fid,['_extrude (PileDisk) 0 0 -' num2str(pile_geom.pile_above_mudline+pile_geom.pile_depth) '\n']);
fprintf(fid,['_set PuttyDisk.z -' num2str(pile_geom.pile_depth) '\n']);
fprintf(fid,['_intersect (Volume_1 PuttyDisk)\n']);
fprintf(fid,['_intersect (Volume_2 Volume_3 Volume_4 Volume_5)\n']);
fprintf(fid,['_rename Volume_9 "VolumeTip"\n']);
fprintf(fid,['_rename Volume_7 "VolumeShaft"\n']);
fprintf(fid,['_rename Volume_6 "VolumeInner"\n']);
fprintf(fid,['_rename Volume_8 "VolumeDamaged"\n']);
fprintf(fid,['_delete Geometry Volume_1\n']);

% set material properties of the putty bits
fprintf(fid,['_set VolumeDamaged.Soil.Material Damaged\n']);
fprintf(fid,['_set VolumeInner.Soil.Material PuttyInternal\n']);
fprintf(fid,['_set VolumeShaft.Soil.Material PuttyShaft\n']);
fprintf(fid,['_set VolumeTip.Soil.Material PuttyTip\n']);

