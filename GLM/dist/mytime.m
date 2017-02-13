function time=mytime
%MYTIME Return the current time in the format hh:mm:ss(am or pm)
%USE:   mytime

%Copyright 1996 Peter Dunn
%11/11/1996

ss=fix(clock);
if ss(4)>12,				%HOUR
   time=[num2str(ss(4)-12),':'];tag='pm';
else
   time=[num2str(ss(4)),':'];tag='am';
end;

if ss(5)<10, 				%MINUTE
   time=[time,'0',num2str(ss(5)),':'];
else
   time=[time,num2str(ss(5)),':'];
end;

if ss(6)<10,				%SECOND
   time=[time,'0',num2str(ss(6)),tag];
else
   time=[time,num2str(ss(6)),tag];
end;
