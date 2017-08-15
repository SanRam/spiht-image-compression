function func_SPIHT_Main
% Matlab implementation of SPIHT 
%
% Main function 
%
% input:    Orig_I : the original image.
%           rate : bits per pixel
% output:   img_spiht 
%


clear all;
clc;
tic
fprintf('-----------   Welcome to SPIHT Matlab    ----------------\n');
fprintf('----DWT------SPIHT-------HUFFMAN-------LZW-------\n');
fprintf('-----------   Load Image   ----------------\n');

%dicom images

%infilename = 'brain_001.dcm';
%outfilename = 'brain_001_reconstruct.dcm';

%gray scale images

infilename = 'lena512.bmp';
outfilename = 'lena512_reconstruct.bmp';

%color images

%infilename = 'test9.bmp';
%outfilename = 'test9_reconstruct.bmp';


%Orig_I = double(dicomread(infilename));

Orig_I = double(imread(infilename));

%Orig_I1 = (imread(infilename));
%yy=rgb2ycbcr(Orig_I1);
%Orig_I2 = double(yy);

fprintf('done!\n');

%for ij=1:3
    
%fprintf('\n\nplane %d computing\n\n',ij);


%Orig_I=Orig_I2(:,:,ij);

rate = 1;

OrigSize = size(Orig_I, 1);
max_bits = floor(rate * OrigSize^2);
OutSize = OrigSize;
image_spiht = zeros(size(Orig_I));
[nRow, nColumn] = size(Orig_I);


fprintf('-----------   Wavelet Decomposition   ----------------\n');
n = size(Orig_I,1);
n_log = log2(n); 
level = n_log;
% wavelet decomposition level can be defined by users manually.

type = 'bior4.4';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);

[I_W, S] = func_DWT(Orig_I, level, Lo_D, Hi_D);

fprintf('done!\n');

fprintf('----------- SPIHT  Encoding   ----------------\n');
img_enc = func_SPIHT_Enc(I_W, max_bits, nRow*nColumn, level);   


fprintf('done!\n');
fid = fopen('spenc.txt','w');
fprintf(fid, '%d', img_enc);
fclose(fid);

fprintf('-----------  HUFFMAN encoding   ----------------\n');
fhstart(img_enc);
fprintf('done!\n\n\n\n');


t1=toc;
fprintf('the encoding block generates compressed three files and taken by decoding block\n\n\n\n');
tic

fprintf('-----------  HUFFMAN Decoding   ----------------\n');
huff_dec=fhdecode2;
fprintf('done!\n');


fprintf('-----------  SPIHT Decoding   ----------------\n');
img_dec = func_SPIHT_Dec(huff_dec);
fprintf('done!\n');


fprintf('-----------   Wavelet Reconstruction   ----------------\n');
img_spiht = func_InvDWT(img_dec, S, Lo_R, Hi_R, level);

fprintf('done!\n');
fprintf('-----------   PSNR analysis   ----------------\n');




%info = dicominfo(infilename);
%dicomwrite(img_spiht, outfilename);
%dicomwrite(uint16(img_spiht), outfilename,info);
%san=double(img_spiht);

imwrite(img_spiht, gray(256), outfilename, 'bmp');

%y2r(:,:,ij)=uint8(img_spiht);

%end

%origre=ycbcr2rgb(y2r);
%imwrite((origre), gray(256), outfilename, 'bmp');

Q = 255;
%MSE = sum(sum(sum(((origre)-Orig_I1).^2)))/nRow / nColumn/3;
MSE = (sum(sum((img_spiht-Orig_I).^2)))/nRow / nColumn;
fprintf('The psnr performance is %.2f dB\n', 10*log10(Q*Q/MSE));

t2=toc;

fprintf('time consumption \n');
fprintf('encoding = %.3f sec\n',t1);
fprintf('decoding = %.3f sec\n',t2);

[X1,map1]=imread(infilename);
[X2,map2]=imread(outfilename);
subplot(1,2,1), imshow(X1,map1)
subplot(1,2,2), imshow(X2,map2)
