function outstr=lstr2cel(instr)
%LSTR2CEL Converts an in-line string (comma separated) to a cell of strings
%USE:  out=lstr2cel(in)
%      Use  char(out) to convert to a string matrix.
%      Does not break comma separated list inside round or square brackets.
%
%      If outstr == [], there was a problem.

%Copyright 1997--1998 Peter Dunn
%06 March 1998

if isempty(instr),              %if empty instr, return empty cell
   outstr={''}; 
   return;
end;

if size(instr,1)>1,             %if already a number or rows, turn into lstr

   instr=cel2lstr(instr); 

end;

if iscell(instr),               %if instr already a cell, return

   outstr=instr;
   return; 

end;

instr=char(instr);             %ensure non-cell input

instr=deblank(instr);          %remove trailing blanks

if ~(instr(1)==''''&instr(length(instr))=='''')
   instr=[ '''',instr,''''];   %place quotes at start and end
end;

%%%%%%%%%%%%%%%%
%round brackets
%%%%%%%%%%%%%%%%
openrb=findstr(instr,'(');
closerb=findstr(instr,')');

%find position of brackets

numopenrb = length(openrb);
numcloserb = length(closerb);

%ensure matching brackets
while (numcloserb < numopenrb)
   %then brackets don't match
   %so, in desperation, we add a bracket and keep trying
   %til we have added enough.

   instr = [ instr(1:end-1),')',instr(end) ];

   closerb = findstr(instr,')');

   numcloserb = length(closerb);

end;


while (numcloserb > numopenrb)
   %then brackets don't match
   %so, in desperation, we add a bracket and keep trying
   %til we have added enough.

   instr = [ '(',instr(1:end-1),instr(end) ];

   openrb = findstr(instr,'(');

   numopenrb = length(openrb);

end;

instr = strrep(instr,',)',')');
   
comma=findstr(instr,','); 
noch=[];
ch=[];

%Ensure break isn't between brackets

for ii=1:length(comma),

   for jj=1:numopenrb,

%     find((comma(ii)>openrb(jj)).*(comma(ii)<closerb(jj))),
        if find((comma(ii)>openrb(jj)).*(comma(ii)<closerb(jj))),
        %is comma between brackets?  If so, we don't break there
           noch=[noch,comma(ii)];
        else
           ch=[ch,comma(ii)];
        end;

    end;
  
end;

if ~isempty(noch),

   for ii=1:length(noch),
      instr(noch(ii))='#';
   end;

end;

%%%%%%%%%%%%%%%%%
%square brackets
%%%%%%%%%%%%%%%%%
opensb=findstr(instr,'[');
closesb=findstr(instr,']');

numopensb = length(opensb);
numclosesb = length(closesb);

%ensure matching brackets
if (numclosesb ~= numopensb)
   %then brackets don't match
   %so, in desperation, we delete all [ and ].
   %Otherwise, we have to decide where to put [ and [] in 
   %relation to commas and round brackets

   instr(closesb) = [];
   opensb=findstr(instr,'[');
   instr(opensb) = [];
   opensb=[];
   closesb=[];
   numopensb=0;
   numclosesb=0;

end;

instr = strrep(instr,',]',']');
comma=findstr(instr,','); 
noch=[];
ch=[];

for ii=1:length(comma),

   for jj=1:length(opensb),

      if find((comma(ii)>opensb(jj)).*(comma(ii)<closesb(jj))),
      %is comma between brackets?  If so, we don't break there
         noch=[noch,comma(ii)];
      else
         ch=[ch,comma(ii)];
      end;

   end;

end;

if ~isempty(noch),

   for ii=1:length(noch),
      instr(noch(ii))='#';
   end;

end;

instr=strrep(instr,',',''',''');     %replace  ,  by  ',']
instr=strrep(instr,'#',',');         %replace  #  by commas

%Problem:  If the user has given, eg,  Rainfall'  as the
%string, this is now giving  instr='Rainfall'', which
%will cause errors!
%One solution is to write it as '[Rainfall']'

dinst = deblank(instr);
ldi = length(dinst);
if (dinst(ldi-1:ldi)==''''''),
   dinst = [ dinst(1),'[',dinst(2:ldi-1),''']''' ];
end
instr=dinst;

eval(['outstr=strvcat(',instr,');'] , 'outstr=1;'); 
                                     %vertically concatenate strings
                                     %outstr == 1 means a problem.
outstr = cellstr(outstr);
