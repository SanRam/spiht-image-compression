%Huffman decoder for text compression
%clc;
%clear all;
%Accepting the decoded file and storing it in character array a%
function  [gg]=fhdecode2(nme_1)

%disp('taking encoded file.....');
nme=nme_1;
id = fopen(nme,'r');
a = fscanf(id,'%c',inf);
fclose(id);

[mx,nx]=size(a);
ax0=1;

ax1=(double(a(1))-48);
ax2=(double(a(1+ax1+1))-48);
ax3=(double(a(1+ax1+1+ax2+1))-48);
ax4=(double(a(1+ax1+1+ax2+1+ax3+1))-48);
ax5=(double(a(1+ax1+1+ax2+1+ax3+1+ax4+1))-48);
ax0=(double(a(1+ax1+1+ax2+1+ax3+1+ax4+1+ax5+1))-48);

if ax0==1
    fprintf('error\n');
end
ax6=ax1+ax2+ax3+ax4+ax5+6;
ax7=ax6+1;
ax8=(double(a(1+ax1+1+ax2+1+ax3+1+ax4+1+ax5+2))-48);
%now for table
ax9(1)=(0);
ax11(1)=(0);
for i=1:ax8
ax9(i+1)=(double(a(ax6+2+ax11(i)+i-1))-48);
ax11(1)=0;
ax11(i+1)=ax11(i)+ax9(i+1);
end
ax10=ax8;
for i=1:ax8
ax10=ax9(i+1)+ax10;
end
for i=1:ax10
a22(i)=0;
end
ax11(1)=(0);
q=1;
i=2;
for j=1:ax8
    a22(q)=(-16);
    q=q+1;
    
    for k=1:ax9(i)
    a22(q)=(double(a(ax6+2+k+ax11(i-1)+i-2))-48);
    q=q+1;
    end
    i=i+1;
end


for i=1:ax6
    bb1(i)=double(a(i))-48;
end




for i=1:5
gg(i)=0;
end
k=1;
j=ax1-1;
for i=1:ax1
    gg(k)=gg(k)+(bb1(i+1)*(10^j));
    j=j-1;
end
k=k+1;
j=ax2-1;
for i=1:ax2
    gg(k)=gg(k)+(bb1(i+ax1+2)*(10^j));
    j=j-1;
end
k=k+1;
j=ax3-1;
for i=1:ax3
    gg(k)=gg(k)+(bb1(i+ax1+2+ax2+1)*(10^j));
    j=j-1;
end
k=k+1;
j=ax4-1;
for i=1:ax4
    gg(k)=gg(k)+(bb1(i+ax1+2+ax2+1+ax3+1)*(10^j));
    j=j-1;
end
k=k+1;
j=ax5-1;
for i=1:ax5
    gg(k)=gg(k)+(bb1(i+ax1+2+ax2+1+ax3+1+ax4+1)*(10^j));
    j=j-1;
end


ax13=ax6+ax10+1;
ax14=ax13+1;


for i=ax14:nx
    ab2(i-ax13)=a(i);
end


[m,n]=size(ab2);
k=1;
for i=1:n
    b(i)=double(ab2(i));
end
%Constructing the original decoded file from the 8 bit block file 
%and storing the result in the character array d%
for i=1:n
    c = dec2bin(b(i),8);
    for j=1:8
        d(k)=c(j);
        k=k+1;
    end
end
%Accepting the Huffman Table%
%Enter the table name given at the time of compression 
%disp('taking table file.....');

%nme2='table.txt';
%id2 = fopen(nme2,'r');
%a2=fscanf(id2,'%c',inf);
%fclose(id2);
uv2=length(a22);
for i=1:uv2
    a23(i)=(a22(i)+48);
end
   a2=char(a23);
[m1,n1]=size(a2);
chk=0;
cnt=1;
str='';
temp=0;
%Partiotning the Huffman table into character array and corresponding 
%code array-cd1(character),cd2(code)%
for j=1:n1
    if chk==1 && a2(j)~=' '
        str=strcat(str,a2(j));
        cd2{cnt-1}=str;
    end
        if temp==1 
        cd1(cnt)=a2(j);
        cnt=cnt+1;
        chk=1;
        temp=0;
        str='';
        end
        
        if a2(j)==' '
            temp=1;
            chk=0;
            if j>1
                if a2(j-1)==' ' 
                    chk=1;
                    temp=0;
                    str='';
                end
            end
            
        end
end
%reconstructing original text from huffman code%
[m2,n2]=size(d);
[m3,n3]=size(cd2);
% Enter a file name to deliver the decoded output
%nme=input('Enter the file name (to produce output) :','s');
%id = fopen(nme,'w+');
id=0;
comp='';
tap=0;
zz=1;
%disp('Decompression starts.........');
for i=1:n2
      cnt=0;  
      z1=d(i);
      m=num2str(z1);
      for j=1:n3          
          k=strcmp(m,cd2(j));
          if(k==1 & tap==0)
              %fprintf(id,'%c',cd1(j));
              id(zz)=cd1(j);
              zz=zz+1;
              comp='';
              cnt=1;
          end
       end
       
       if(cnt==0)
            comp=strcat(comp,num2str(z1));
            tap=1;
            for j=1:n3
                m=cd2(j);
                k=strcmp(comp,cd2(j));
                if(k==1)
                    cd1(j);
                    %fprintf(id,'%c',cd1(j));
                    id(zz)=cd1(j);
                    zz=zz+1;
                    comp='';
                    tap=0;
                end
            end
       end
end
%disp('Decompression Over');




[mm,nnn]=size(id);
%for i=1:nnn
 %   bb(i)=double(id(i));
%end
for i=1:nnn
    bb2(i)=id(i)-48;
end




for i=1:nnn
    gg(i+5)=bb2(i);
end




%fclose(id);