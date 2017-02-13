function [y] = cdfpoiss(X, lambda)
% CDFPOISS Returns the cumulative poisson distn always returning a number
%          (unlike POISSCDF which can return NaN)
% USE: [y] = cdfpoiss(X,LAMBDA)
%	where  X  is the vector of observations;
%              LAMBDA  is the vector of means;
%              y  is the vector of corresponding cdfs.

%Hardly an optimal code, but will suffice.

%Copyright 1996 Peter Dunn
%11/11/1996

for j=1:length(X),

   x=X(j);

   if (x<0),

      y(j) = 0;				%If x<0, cdf = 0

   else

      pdf(j)=exp(-lambda(j)); cdf(j)=pdf(j);
      for i=1:x,
         pdf(j)=pdf(j)*lambda(j)/(i);
         cdf(j)=cdf(j)+pdf(j);
      end;
      y(j) = cdf(j);

   end;

end;

y=y';
