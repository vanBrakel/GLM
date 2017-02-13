function dists=distlist(fname)
%DISTLIST Produces a list of error distributions available in  glmlab
%USE:  dists=distlist(fname)
%   where  fname  is the name of the file to read
%           (not necessary, but a workaround to a MATLAB windows bug)
%          dists  is a list, one distribution per line;
%   This info is used in forming menus

%Copyright 1996 Peter Dunn
%11/11/1996

%This  if  statement shouldn't be needed; a bug in MATLAB windows
if strcmp(computer,'PCWIN'),
   fid=fopen(fname,'r');
else
   fid=fopen(fname,'rt');
end;

dists=[];

while ~feof(fid),
   dists=str2mat(dists,fgetl(fid));
end;

for i=1:size(dists,1),

   d=dists(i,:);
   d=strrep(d,'.m','  ');
   dd(i)=strcmp(d,blanks(length(d)));
   ddd(i)=~strcmp(d(1),'d');
   d(1)=' ';
   dists(i,:)=d;

end;

dists((dd|ddd),:)=[];
fclose(fid);
