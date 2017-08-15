%Hufman code generating phase
function fhcode(lstn,img,reduu,rate,im_name)
%disp('Code generating phase entered...');
[lm,ln]=size(lstn);
ntt=ln-1;
[im,in]=size(img);
t=0;

ax2=num2str(rate);
nme=strcat(im_name,' rate- ',ax2,'.txt');
%nme3='huffencodedinte.txt';
%disp('Generating the compressed file..........');
%header writing
id = fopen(nme,'w+');
%id3 = fopen(nme3,'w+');
for i=1:5
    ax1=reduu(i);
    bx1=length(num2str(ax1));
fprintf(id,'%d',bx1);
%fprintf(id3,'%d',bx1);
fprintf(id,'%d',reduu(i));
%fprintf(id3,'%d',reduu(i));
end
ax2=0;
fprintf(id,'%d',ax2);
%fprintf(id3,'%d',ax2);

%disp('destination huffman code file name: code.txt');
%disp('Huff Table name (for decoding purpose): table.txt');
%idd='code.txt';
%tab='table.txt';
%tb = fopen(tab,'w+');
%idd=fopen(idd,'w+');

tbb='';
%idd='';
fst1='';
fst2='';
ed=0;
din=0;
y=0;
% Traversing the Tree resembling list resulting in reverse Huffman code for a particular character%
%disp('Building Huffman Table.........');
for i=1:in
    k=img(i);
    ftemp=img(i);
    a=0;
    for j=1:3:ln
        if(lstn(j+2)==99)
            break;
        end
        if(lstn(j)==k)
            a=a+1;
            ary(a)=lstn(j+1);
            k=lstn(j+2);
        end
    end
    % Reversing the reverse Huffman Code%
    for b=a:-1:1
        t=t+1;
        hc(t)=ary(b);
        %fprintf(idd,'%d',ary(b));
        
        fst1=int2str(ary(b));
        fst2=strcat(fst2,fst1);
    end
    %Building Huffman Table for Decoding%
    din=0;
    for z=1:ed
        if dict(z)==ftemp
            din=1;
        end
    end
    if din==0
        ed=ed+1;
        dict(ed)=ftemp;
        %fprintf(tb,'%c',' ');
        %fprintf(tb,'%c',ftemp);
       % fprintf(tb,'%s',fst2);
        %tbb(y)=' ';
        y=y+1;
       % %tbb(y)=ftemp;
       % y=y+1;
       % tbb(y)=fst2;
        %y=y+1;
        ftemp1=char(ftemp);
        fst21=char(fst2);
        %fst22=char('  ');
        tr1 = strcat(ftemp1,fst21);
        tr2=(length(tr1)+48);
        tbb=strcat(tbb,tr2,tr1);
        
    end
    fst1='';
    fst2='';
end

%tab1='tablez.txt';
%tbr = fopen(tab1,'w+');
fprintf(id,'%d',y);
fprintf(id,'%c',tbb);
%fclose(tbr);
%Converting 8 bit Binary to ASCII character and storing the result in specified file%
%disp('Converting binary huffman codes to ASCII characters......');
%disp('the destination file name : encoded.txt');
%nme='huffencoded.txt';
%nme3='huffencodedinte.txt';
%disp('Generating the compressed file..........');
%id = fopen(nme,'w+');
%id3 = fopen(nme3,'w+');
%id='';
for i=1:8:t
    ck=t-i+1;
    if(ck>8)
        tp=(hc(i:i+7));
        num=8;
    else
        tp=(hc(i:t));
        num=ck;
    end      
    temp1=b2d(tp,num);
    temp2=char(temp1);
    fprintf(id,'%c',temp2);
    %fprintf(id3,'%d',temp2);
   % temp21=char(temp2);
    %id=strcat(id,temp21);
end
fclose(id); 
%fclose(id3);
%fclose(idd);
%fclose(tb);
%fprintf('Generated Compressed file\n');
return