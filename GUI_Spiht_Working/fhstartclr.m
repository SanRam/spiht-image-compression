%Hufman coding algorithm

%%%% USAGE %%%%%%%
% Run the program fhstart.m


function  ST= fhstartclr(imgenc,ij,rate,im_name)

%clc;
%clear all;
%k=input('Enter the file name :','s');
%fid = fopen('seqn5','r');
%F = fread(fid);
%img = char(imgenc');

[qqq,ttt]=size(imgenc);
for i=1:5
    reduu(i)=imgenc(i);
end
%disp('destination redundant file name: redu.txt');
%idd='redu.txt';
%idd=fopen(idd,'w');
%fprintf(idd,'%d',reduu);
%fclose(idd);


for i=6:ttt
    fftt(i-5)=imgenc(i);
end

    
[www,zzz]=size(fftt);
for i=1:zzz
    F(i,1)=fftt(i)+48;
end

img = char(F');
mx=255;
[x y z]=size(img);
h(1:mx)=0;
%disp('Histogram building phase started....');
for i=1:y
        iy=img(i);
        val=double(iy);
        h(val)=h(val)+1;
    end

%disp('Probability calculating phase started...');
i=1:mx;
p(i)=h(i)/(x*y);
j=1;
for i=1:mx
        if(p(i)~=0)
         lst(j)=i;
         lst(j+1)=p(i);
         j=j+2;
        end
 end
[tt,mx]=size(lst);
%disp('sorting phase started....');
for i=2:2:mx
    for j=i:2:mx
        if (lst(i)>lst(j))
            temp1=lst(i-1);
            temp2=lst(i);
            lst(i-1)=lst(j-1);
            lst(i)=lst(j);
            lst(j-1)=temp1;
            lst(j)=temp2;
        end
    end
end
%disp('Building Huffman Tree.....');
fhtree1clr(lst,img,ij,reduu,rate,im_name);