function out=pad(in,l,how)
%PAD Takes string  instr  and pads it with blanks to make it of length  l
%USE:   outstr=pad(instr, l, how)
%       where  outstr  is the resultant string (cell or matrix, same as input);
%              instr  is the string to pad (cell strings ormatrix string);
%              l  is the length of the string;
%              how  is  1  to pad at the end; -1 to pad in front.
%       By default, the string is padded in front (ie how=-1).

%Copyright 1996, 1997 Peter Dunn
%10 October 1997

%Defaults
if nargin<3, 
   how=-1; 
end;

if how>0, 
   how=1; 
end;

cellflag=0;

if iscell(in), 

   in=char(in); 
   cellflag=1; 

end;

out=[];
for i=1:size(in,1)

   add=blanks( l-size(in(i,:),2) );

   if how<0,
      outl=[add(ones(1,size(in(i,:),1)),:),in(i,:)];
   else
      outl=[in,add(ones(1,size(in(i,:),1)),:)];
   end;

   out=[out;outl];

end;

%make output a cell array if the input was a cell array
if logical(cellflag), 
   out=cellstr(out); 
end;
