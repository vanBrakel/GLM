function [y] = cdfgam(X, A, B)
% CDFBINO Returns the cumulative bimonial distn always returning a number
%          (unlike MATLAB's GAMCDF which can return NaN)
% USE: [y] = cdfgam(X,A,B)

%Copyright 1996 Peter Dunn
%11/11/1996

xl=length(X); 
al=length(A); 
bl=length(B);
l=[max([xl,al,bl]),1];

if (xl~=al)|(xl~=bl),

   if (xl~=1)&(al~=1)&(bl~=1),
      error(['The inputs are confusing to me!',...
             '  All should be same size vectors, or scalars.']); 
   else
      if xl==1, X=X*ones(l); end;
      if al==1, A=A*ones(l); end;
      if bl==1, B=B*ones(l); end;
   end;

end;

%Find problems
no=find(A<=0 | B<=0 | X<=0);
yep=find(~(A<=0 | B<=0 | X<=0));

if sum(yep), 
   y(yep)=gammainc(X(yep)./B(yep),A(yep)); 
end;

if sum(no), 
   y(no)=zeros(size(no)); 
end;

y=y';
