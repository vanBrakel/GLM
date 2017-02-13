function s=mystrrep(s1,pos,s3)
%MYSTRREP Replaces strings given their _position_
%USE      s=mystrrep(s1,pos,s3) replaces s1(pos) with s3.
%         pos  is a vector of positions in string  s1  to change to string  s3.

%Copyright 1996 Peter Dunn
%11/11/1996

if (pos>length(s1))|(pos<1),
   error('Can''t replace a position that doesn''t exist!');
end;

s=s1;
pos=sort(pos);
tpos=pos;
delta=0;

for i=1:length(pos),

   s=[s(1:tpos(i)-1),s3,s(tpos(i)+1:length(s))];
   delta=delta+length(s3)-1;tpos=pos+delta;

end;
