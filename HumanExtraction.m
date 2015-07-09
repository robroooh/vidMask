function [ out ] = HumanExtraction( im_tobemask, im_background, opaMask, opaBg, thre )
    % this function take the first argument to be the mask and the other
    % one is for the back ground then do the multiplication with weight

    % opamask and opabg is the opacity to the mask, background accordingly
    % thre stands for threshold for the mask

    % convert into grayscale first to subtract the gray level
    im_mask_grayscale = rgb2gray(im_tobemask);
    [row,col,d] = size(im_tobemask);
    
    % do the mask by thresholding
    mask = im_mask_grayscale; 
    mask(mask<thre) = 1;
    mask(mask>=thre) = 255;

    out = ones(row,col,d); % prepare the output to be the same size 
    
    % make mask to 3 dimensions, so we can use with one-liner, then
    % compliment for the sake of one-liner
    mask = cat(3,mask,mask,mask); 
    mask = imcomplement(mask); 

    im_mask_grayscale = cat(3,im_mask_grayscale,im_mask_grayscale,im_mask_grayscale); %use the grayscale into 3 dimensions

    % combine original image to the im2 with according opacity
    out(mask~=0) = (opaMask*(im_mask_grayscale(mask~=0))) + (opaBg*(im_background(mask~=0)));
    out(mask==0) = 255;

    out = uint8(out);

end