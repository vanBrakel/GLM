function [b,mu,xtwx,devlist,l,eta]=irls(obj,y,x,w,m,o,display)
%IRLS Iteratively reweighted least squares for use with glmlab
%USE: [b,mu,xtwx,devlist,l,eta]=irls(y,x,m)
%   where  y  is the vector of y-variables;
%          x  is the matrix of x-variables;
%          m  is the vector of sample sizes for a binomial distribution.
%             For other distributions, it is not needed (or use a dummy).
%          b  is the vector of parameter estimates
%          mu  is the fitted values
%          xtwx  is the matrix  X'*W*X
%          devlist  is the deviance for each iteration of the fit.
%          l  is the labels for linearly independent columns of x.
%          eta  is the linear predictor.

%Copyright 1996--1998 Peter Dunn
%Last revision: 02 November 1998

% Load from object.
toler = obj.toler;
maxits = obj.maxit;
illctol = obj.illctol;

%obtain information about the model to fit
distn=obj.Distribution;               %distribution
link=obj.Link;                        %link function
format=obj.Display;                   %output display
fitvals=obj.Fitted;                   %fitted values
weights=w;                            %prior weights
offset=o;                             %offsets


%determine files that contain distribution and link information
if ischar(link),
   linkinfo=['l',link];               %the file containing link info
else
   linkinfo='lpower';                 %link info if a power link
end;
distinfo=['d',distn];                 %the file containing distribution info

%remove aliased variables from the fit
xx=x;                                 %make other copies
oo=offset;
mm=m;
l=alias(x,toler);                     %determine aliased variables
x=x(:,l);                             %only use unaliased variables

%remove points with zero weights from the fit
if any(weights==0),                   %removes weights==0 from fitting

   zeroind= weights==0;
   allmat=[y,m,weights,offset,x,fitvals]; 
   allmat(zeroind,:)=[];

   if isempty(fitvals),
      x=allmat(:,5:size(allmat,2));
   else
      x=allmat(:,5:size(allmat,2)-1);
   end

   y=allmat(:,1);
   m=allmat(:,2);
   weights=allmat(:,3);
   offset=allmat(:,4);

   %check again for aliasing
   l=alias(x,toler);
   x=x(:,l);

end;

%Starting values
if strcmp(obj.Recycle,'on') && (~isempty(fitvals)),

   %If `Recycle fitted values' option is selected, use fitted values 
   %as starting point:
   mu=fitvals;

else

   %else usually use the actual observations and the starting point for the
   %fitted values; in some cases we must fiddle to avoid problems with zeroes.
   if strcmp(link,'logit')||strcmp(link,'complg')||strcmp(link,'probit'),
      mu= m.*(y+0.5)./(m+1); %over m+1 in the general case; McC and Nelder p 117
   elseif strcmp(link,'log')||strcmp(link,'recip'),
      mu=y+(y==0);           %remove 0's that may be there
   else
      mu=y;
   end;

end;

%initialise
its=-1;                      %number of iterations
devlist=[];                  %list of deviances after fits
clear allmat

rdev=sqrt(sum( y.^2));      %residual deviance
rdev2=0;                    %dummy to enter loop

b=[zeros(size(x,2),1)];     %initial beta
b2=100*ones(size(x,2),1);   %dummy to enter loop
b(1)=-10;                   %extra precaution to enter loop

eta=feval(linkinfo,mu,m,'eta'); %eta=Xb + offset

%iterate!
while ( ( abs(rdev-rdev2) > toler) ) && (its<maxits),

   %while: (rdev is changing;or max its not reached) and b still changing

   detadmu=feval(linkinfo,mu,m,'detadmu');          %d(eta)/d(mu)
   vfun=feval(distinfo,1,y,mu,m,weights);           %variance function
   fwts=( 1./( (detadmu).^2) ./ vfun).*weights;     %fitting weights
   z=(eta-offset+(y-mu).*detadmu);                  %adjusted dependent var
   xtwx=x'*diagm(fwts,x);                           %X'WX

   b2=b;
   b=(xtwx)\( x'*diagm(fwts,z) );                   %next beta

   eta=(x*b)+offset;                                %linear predictor, eta
   mu=feval(linkinfo,eta,m,'mu');                   %means, mu
   rdev2=rdev;                                      %last residual deviance
   rdev=feval(distinfo,2,y,mu,m,weights);           %residual deviance
   its=its+1;                                       %update iterations
   devlist=[devlist;rdev];                          %list of deviances for fits

end;

devlist(1)=[]; %remove initial empty entry

%Issue warnings where appropriate
if its>=maxits,
   disp(' ');disp(' * MAXIMUM ITERATIONS REACHED WITHOUT CONVERGENCE');
   disp(['   (This is currently set at ',num2str(maxits),')']);
end;

if (rcond(xtwx)<illctol), 
   disp('              * ILL-CONDITIONED COVARIATE MATRIX');
end;

if (rcond(xtwx)<illctol)||(its==maxits),
   disp(' ---------------------------------------------------------------------'); 
   disp(' PLEASE NOTE: INACCURACIES MAY EXIST IN THE SOLUTION.');
end;

%Message about the fit
if format(1),
   if (its<maxits),
      tag='';
      if its~=1, 
         tag='s';
      end;
      if display == 1
        disp([' :: convergence in ',num2str(its),' iteration',tag]);
      end
   end;
end;

x=xx(:,l); 
eta=(x*b)+oo;
mu=feval(linkinfo,eta,mm,'mu');


%%%SUBFUNCTION DIAGM
function A=diagm(D,B)
%DIAGM Multiples D, a diagonal matrix as a row of diag elements with matrix B
%USE: A=diagm(D,B)
%   where  D  is the diagonal elements of a diagonal matrix;
%          B  is a matrix of suitable size;
%          A  is the result of the multiplication.

%Copyright 1996 Peter Dunn
%11 Nov 1996

%error checks
if length(D)~=size(B,1),
   error('Matrix sizes are not compatible.');
end;
%end error checks

A=zeros(length(D),size(B,2));
for i=1:length(D),
   A(i,:)=D(i)*B(i,:);
end;

%%%SUBFUNCTION ALIAS
function label=alias(X,toler)
%ALIAS Finds aliased columns of matrix X
%USE: labels=alias(X)
%   where  labels  is a vector of the linearly independent columns
%          X  is the original data matrix.
%X(:,label) is the matrix with aliased variables removed
%For use within  glmlab

%Copyright 1996 Peter Dunn
%Last revision: 11 Nov 1996

XX=X(:,1); 
i=1;label=[1];
for j=1:size(X,2);
   i=i+1; 
   XX=[XX X(:,j)];
   if det(XX'*XX)<toler,
      XX=[ XX(:,1:size(XX,2)-1) ];
   else
      label=[label j];
   end;
end;
