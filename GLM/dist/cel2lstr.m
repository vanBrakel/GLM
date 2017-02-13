function out=cel2lstr(in)
%CEL2LSTR Converts a cell string array to a single line string
%          separated by commas.  The input can be a cell of strings or
%          string matrix.
%USE: out=cel2lstr(in)

%Copyright 1997 Peter Dunn
%23 October 1997

if isempty(in), 
   out=in; 
   return; 
end;

if isstr(in),

   out=deblank(in(1,:));
   for i=2:size(in,1),
      out=[out,',',deblank(in(i,:))];
   end;

elseif ~iscellstr(in), 

%   error('Must enter a cell of strings!');
   out = in;

else

   tstr=in(:);
   out=[];

   for i=1:length(tstr),

      if ~isempty(deblank(tstr{i})),
         out=[out,',',tstr{i}];
      end;

   end;

   out(1)=[];

end;
