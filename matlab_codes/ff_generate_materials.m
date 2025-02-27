function ff_generate_materials(fid)

fref = fopen('example_commands\material_parameters1.p3dlog','r');

while ~feof(fref)

l = fgetl(fref);

fprintf(fid,[l '\n']);

end

fclose(fref);