function A=diagm(D,B)
%DIAGM Multiples D, a diagonal matrix as a row of diag elements with matrix B
%USE: A=diagm(D,B)
%   where  D  is the diagonal elements of a diagonal matrix;
%          B  is a matrix of suitable size;
%          A  is the result of the multiplication.

%Copyright 1996 Peter Dunn
%11/11/1996

%error checks
if length(D)~=size(B,1),
   error('Matrix sizes are not compatible.');
end;
%end error checks

A=zeros(length(D),size(B,2));

for i=1:length(D),
   A(i,:)=D(i)*B(i,:);
end;
