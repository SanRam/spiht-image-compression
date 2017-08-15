function [outfilename,bpp,MSE,psnr,compr] =func_SPIHT_Main_gray(infilename,rate,tt,im_info,im_name)
% Matlab implementation of SPIHT
%
% Main function 
%
% input:    Orig_I : the original image.
%           rate : bits per pixel
% output:   img_spiht 
%
multiWaitbar( 'CloseAll' );
tic
fprintf('-----------   Welcome to SPIHT Matlab    ----------------\n');
fprintf('--------DWT----------SPIHT-----------HUFFMAN----------\n');
fprintf('-----------   Load Image   ----------------\n');

%gray scale images

%infilename = 'lena512.bmp';
%outfilename = 'lena512_reconstruct.bmp';

%Orig_I = double(imread(infilename));
Orig_I = double(infilename);
fprintf('done!\n');
 fl_sz=im_info.FileSize;
 fl_dp=im_info.BitDepth;
%rate = 1;

[OrigSize,outs] = size(Orig_I);
max_bits = floor(rate * (OrigSize*outs));
OutSize = OrigSize;
image_spiht = zeros(size(Orig_I));
[nRow, nColumn] = size(Orig_I);

multiWaitbar( 'Image Encoding...', 1/5, 'Color', [0.4 0.1 0.5] );

fprintf('-----------   Wavelet Decomposition   ----------------\n');
[n_1,n_2] = size(Orig_I);
if n_1<n_2
n_log = log2(n_2);
else
n_log = log2(n_1);
end
level =floor(n_log);
% wavelet decomposition level can be defined by users manually.

type =tt;     %'bior4.4';
fprintf('filter type = ');
disp(tt)

[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);

multiWaitbar( 'Image Encoding...', 2/5, 'Color', [0.4 0.1 0.5] );

[I_W, S] = func_DWT(Orig_I, level, Lo_D, Hi_D);

multiWaitbar( 'Image Encoding...', 3/5, 'Color', [0.4 0.1 0.5] );
hh='Dwt.txt';
fid = fopen(hh,'w');
fprintf(fid, '%d', I_W);
fclose(fid);
fprintf('done!\n');

fprintf('----------- SPIHT  Encoding   ----------------\n');
img_enc = func_SPIHT_Enc(I_W, max_bits, nRow*nColumn, level,fl_dp);   
fprintf('done!\n');

multiWaitbar( 'Image Encoding...', 4/5, 'Color', [0.4 0.1 0.5] );

fid = fopen('spenc.txt','w');
fprintf(fid, '%d', img_enc);
fclose(fid);

fprintf('-----------  HUFFMAN encoding   ----------------\n');
fhstart(img_enc,rate,im_name);
fprintf('done!\n');

multiWaitbar( 'Image Encoding...', 5/5, 'Color', [0.4 0.1 0.5] );

t1=toc;
if 1>(fl_dp)<=8
image(uint8(I_W));
elseif 8>(fl_dp)<=16
image(uint16(I_W));
else
 image(logical(I_W));
end
%image(uint8(I_W));         % for displaying the DWT coefficients.....
axis image;
pause

fprintf('\n\n\nThe encoding block generates compressed file and taken by decoding block\n\n\n\n');
tic
multiWaitbar( 'Image Decoding...', 0, 'Color', [0.4 0.1 0.5] );


ax2=num2str(rate);
nme=strcat(im_name,' rate- ',ax2,'.txt');
id1 = fopen(nme,'r');
a11 = fscanf(id1,'%c',inf);
fclose(id1);

fprintf('-----------  HUFFMAN Decoding   ----------------\n');
huff_dec=fhdecode2(nme);
fprintf('done!\n');

multiWaitbar( 'Image Decoding...', 1/5, 'Color', [0.4 0.1 0.5] );
dx_level=huff_dec(4);
dx_BtDpt=huff_dec(5);
fprintf('-----------  SPIHT Decoding   ----------------\n');
img_dec = func_SPIHT_Dec(huff_dec);
fprintf('done!\n');

multiWaitbar( 'Image Decoding...', 2/5, 'Color', [0.4 0.1 0.5] );

fprintf('-----------   Wavelet Reconstruction   ----------------\n');
img_spiht = func_InvDWT(img_dec, S, Lo_R, Hi_R, dx_level);

multiWaitbar( 'Image Decoding...', 3/5, 'Color', [0.4 0.1 0.5] );

fprintf('done!\n');

if 1>dx_BtDpt<=8
outfilename = uint16(img_spiht);
elseif 8>dx_BtDpt<=16
outfilename = uint16(img_spiht);
else
    outfilename = logical(img_spiht);
end

t2=toc;

multiWaitbar( 'Image Decoding...', 4/5, 'Color', [0.4 0.1 0.5] );

%imwrite(img_spiht, gray(256), outfilename, 'bmp');
%info = dicominfo(infilename);
%dicomwrite((outfilename), 'outfilename.dcm');

fprintf('\n\n-----------   Performance   ----------------\n');

[sz1,sz2]=size(Orig_I);
fprintf('Size of image is %dx%d  \n',sz1,sz2);
compr1=((length(a11))/(fl_sz));
bpp=(compr1*8);
compr=(compr1*100);
fprintf('Compression Ratio = %.3f percent (%.2f : 1)  \n',(compr1*100),(1/compr1));
fprintf('The bitrate is %.2f bpp (with rate %.2f in the encoding)\n',bpp ,rate);

jn1=double(img_spiht);
jn2=double(Orig_I);
[MSE,snr,psnr]=Peak_SNR(jn1,jn2);
%disp(dx_BtDpt)
%Q=max(Orig_I(:));
%Q = 255;
%MSE = (sum(sum((double(img_spiht)-double(Orig_I)).^2)))/(sz1*sz2);
fprintf('The MSE performance is %.2f \n', MSE);
%psnr=10*log10(Q*Q/MSE);
fprintf('The psnr performance is %.2f dB\n\n', psnr);

fprintf('Time consumption \n');
fprintf('Encoding = %.3f sec\n',t1);
fprintf('Decoding = %.3f sec\n',t2);

multiWaitbar( 'Image Decoding...', 5/5, 'Color', [0.4 0.1 0.5] );

multiWaitbar( 'CloseAll' );

%[X1,map1]=imread(infilename);
%[X2,map2]=imread(outfilename);
%subplot(1,2,1), imshow(X1,map1)
%subplot(1,2,2), imshow(X2,map2)
