function [outfilename,bpp,MSE,psnr,compr] = func_SPIHT_Main(infilename,rate,tt,im_info,im_name)

a = ndims(infilename);
if a==3
    [outfilename,bpp,MSE,psnr,compr] = func_SPIHT_Main_clr(infilename,rate,tt,im_info,im_name);
else 
    [outfilename,bpp,MSE,psnr,compr] = func_SPIHT_Main_gray(infilename,rate,tt,im_info,im_name);
end
