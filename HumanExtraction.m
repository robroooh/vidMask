function [ out ] = HumanExtraction( im_tobemask, im_background, opa1, opa2, thre )
% this function take the first argument to be the mask and the other one is
% underneath this one

    %opa1 and opa2 is the opacity to the image


    im_mask_grayscale = rgb2gray(im_tobemask);%convert into grayscale first to subtract the gray level
    [row,col,d] = size(im_tobemask);

    mask = im_mask_grayscale; %do the mask by thresholding
    mask(mask<thre) = 1;
    mask(mask>=thre) = 255;
   
    out = ones(row,col,d); % prepare the output to be the same size 

     mask = cat(3,mask,mask,mask); %make mask to 3 dimensions, so we can use with one-liner
     mask = imcomplement(mask); % complement
     
     im_mask_grayscale = cat(3,im_mask_grayscale,im_mask_grayscale,im_mask_grayscale); %use the grayscale into 3 dimensions
     
     %combine original image to the im2 with according opacity
     out(mask~=0) = (opa1*(im_mask_grayscale(mask~=0))) + (opa2*(im_background(mask~=0)));
     out(mask==0) = 255;

     out = uint8(out);

end