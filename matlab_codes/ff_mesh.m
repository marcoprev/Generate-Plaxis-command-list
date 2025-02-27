function ff_mesh(fid)


fref = fopen('example_commands\mesh.p3dlog','r');

while ~feof(fref)

l = fgetl(fref);

fprintf(fid,[l '\n']);

end

fclose(fref);
