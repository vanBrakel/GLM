function limits=wildfind(string,searchstr)
%WILDFIND Does a string search with wildcard character, *
%         (thus implying that  *  cannot be used otherwise).
%USE:    limits=wildfind(string, searchstr)
%   where  limits  are the positions of  seacrhstr  in  string
%EXAMPLE:
%   >> wildfind('string of example text','t*e')
%   ans =
%        2    11
%       19    20
%   since a t appears in position 2, and the next e at position 11;
%   and a t next appears at pos 19, with the next e at position 20.

%Copyright 1996 Peter Dunn
%11 Nov 1996

wildchar=findstr(searchstr,'*'); %position of wildcards

if length(wildchar)>1,
   error('Only one wildcard (the ''*'' character) is allowed.');
end;

if isempty(wildchar),

   number=findstr(string,searchstr);
   limits=zeros(number,2);
   limits=[number', (number+length(searchstr)-1)'];

else

   str1=searchstr(1:wildchar-1);
   str2=searchstr(wildchar+1:length(searchstr));
   one=[findstr(string,str1),length(string)];
   two=findstr(string,str2);

   if length(one)==1, %then the first character before the * is not present
      limits=[];return;
   end;

   limits=zeros(length(two),2); %possible limits of the search string

   for i=1:length(two),

      thisone=[];
      possibles=[];
      possibles=diff(one<two(i)); %candidates for other end of searchstr
      thisone=[(possibles~=0),0];

      if ~isempty(one(logical(thisone))),
         limits(i,:)=[one(logical(thisone)),two(i)];
      end;

   end;

   %Now find 'gaps' with minimum distance (most likely things to want)
   if ~isempty(limits),

      select=[1;diff(limits(:,1))];
      limits=limits(select>0,:);

   end;

end;

deleteme=[];

for i=1:size(limits,1),
   if limits(i,:)==zeros(size(limits(i,:))),

      deleteme=[deleteme;i];

   end;

end;

if ~isempty(deleteme), 
   limits(deleteme,:)=[]; 
end;
