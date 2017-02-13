function [where,ind]=findmat(instr, searchstr)
%FINDMAT Finds where  searchstr  occurs in (matrix) string instr
%USE:  [where,ind]=findmat(instr, searchstr)
%  where  where  is a string matrix, each row a string of where
%         searchstr  is found.  str2num(where(1,:)) converts to numbers.
%         ind  is a column vector containing the number of times
%              searchstr  is found in each row of  instr.

%Copyright 1996, 1997 Peter Dunn
%26 August 1997

%error checks
if size(searchstr,1)>1, 
   error('Can only search for one-line strings!');
end;

ind=zeros(size(instr,1),1);

if size(instr,1)==1, 

   if strcmp(searchstr,blanks(length(searchstr))),
      padchar='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
      padchar=[padchar,padchar,padchar];
   else
      padchar=blanks(100);
   end;

   ins=[instr,padchar];

   %pad to ensure that searchstr is looked for
   where=findstr(ins,searchstr);

   if ~isempty(where), 
      ind=length(where); 
   end;

   where=mmat2str(where);

else

   where=[];

   if strcmp(searchstr,blanks(length(searchstr))),

      padchar='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
      padchar=[padchar,padchar,padchar];

   else

      padchar=blanks(100);

   end;

   for i=1:size(instr,1), 

      ins=[instr(i,:),padchar];
      ok=findstr(ins,searchstr);
      ind(i)=length(ok);
      where=str2mat(where, mmat2str( ok ));

   end;

   if ~isempty(where), 
      where(1,:)=[]; 
   end;

end;

%%%SUBFUNCTION mmat2str
function outstr=mmat2str(matrix)
%MMAT2STR  glmlab  version of MATLAB  mat2str  for those with student editions
%USE  outstr=mmat2str(matrix)
%     where  matrix  is a matrix to convert to a string
%            outstr  is the resultant string.

%Copyright 1996 Peter Dunn
%11/11/1996

%Heavy borrowing from  MATLAB's  mat2str

if isstr(matrix), 
   outstr=matrix;
   return;
end;

[rows, cols] = size(matrix);
if rows*cols ~= 1, 
   outstr = '['; 
else 
   outstr = ''; 
end;

for i=1:rows,

   for j=1:cols,

      %some special cases out of the way first
      if matrix(i,j) == Inf,
         outstr=[outstr,'Inf'];
      elseif matrix(i,j) == -Inf,
         outstr=[outstr,'-Inf'];
      else
         outstr=[outstr,sprintf('%.15g',real(matrix(i,j)))];

         %Complex entries
         if imag(matrix(i,j))<0,
            outstr=[outstr,'-i*',sprintf('%.15g',abs(imag(matrix(i,j))))];
         elseif(imag(matrix(i,j)) > 0)
            outstr=[outstr,'+i*',sprintf('%.15g',imag(matrix(i,j)))];
         end;

      end;
      outstr=[outstr ' '];

   end;

   l=length(outstr); 
   outstr(l:l+1)='; '; %Row finished

end;

if rows==0, 	%Empty case
   outstr=[outstr,'  ']; 
end;

l=length(outstr);

if rows*cols ~= 1
   outstr(l-1)=']';
   outstr(l)=[];
else    
   outstr(l-1:l)=[];
end;
