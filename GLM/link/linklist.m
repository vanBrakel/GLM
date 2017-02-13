function links=linklist(fname)
%LINKLIST Produces a list of link function available in  glmlab
%USE:  links=linklist(fname)
%   where  fname  is the name of the file to read
%           (not necessary, but a workaround to a MATLAB windows bug)
%          links  is a list, one link per line;
%   This info is used in forming menus

%Copyright 1996 Peter Dunn
%11/11/1996

%This  if  shouldn't be needed; a MATLAB bug in Windows
if strcmp(computer,'PCWIN'),
   fid=fopen(fname,'r');
else
   fid=fopen(fname,'rt');
end;
links=[];

while ~feof(fid),
   links=str2mat(links,fgetl(fid));
end;

for i=1:size(links,1),

   l=links(i,:);
   l=strrep(l,'.m','  ');
   ll(i)=strcmp(l,blanks(length(l)));
   lll(i)=~strcmp(l(1),'l');
   lll(1)=' ';
   l(1)=' ';
   links(i,:)=l;

end;

links((ll|lll),:)=[];
fclose(fid);
