function ff_generate_pile_geometry(fid,pile_geom)


Young = 210000000;

radStr = num2str(pile_geom.pile_diameter/2);
topZ = num2str(pile_geom.pile_above_mudline);
extrudeZ = num2str(pile_geom.pile_above_mudline+pile_geom.pile_depth);
d = num2str(pile_geom.pile_wall_thickness);


fprintf(fid,['_polycurve 0 0 0 1 0 0 0 1 0\n']);
fprintf(fid,['_set Polycurve_1.Offset1 -' radStr '\n']);
fprintf(fid,['_reset Polycurve_1 "Arc" 0 180 ' radStr ' "Arc" 0 180 ' radStr '\n']);
fprintf(fid,['_delete (Polycurve_1.Segments[1])\n']);
fprintf(fid,['_set Polycurve_1.Segments[0].ArcProperties.RelativeStartAngle1 90\n']);
fprintf(fid,['_set Polycurve_1.Offset1 ' radStr '\n']);
fprintf(fid,['_set Polycurve_1.z ' topZ '\n']);
fprintf(fid,['_extrude (Polycurve_1) 0 0 -' extrudeZ '\n']);
fprintf(fid,['_rename Surface_1 "Pile_geometry"\n']);
fprintf(fid,['_rename Polycurve_1 "Curve_pile"\n']);
fprintf(fid,['_plate Pile_geometry\n']);
fprintf(fid,['_rename Pile_geometry.Plate "PilePlate"\n']);
fprintf(fid,['_platemat "MaterialType" "Elastic"\n']);
fprintf(fid,['_set Pile_geometry.Plate.Material PlateMat_1\n']);
fprintf(fid,['_set PlateMat_1.Identification "PilePlate" \n']);
fprintf(fid,['_set PilePlate_1.E1 ' num2str(Young) '\n']);
fprintf(fid,['_set PilePlate_1.StructNu12 0.3\n']);
fprintf(fid,['_set PilePlate_1.d  ' d '\n']);
fprintf(fid,['_posinterface Pile_geometry\n']);
fprintf(fid,['_neginterface Pile_geometry\n']);