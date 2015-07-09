function [ output_args ] = Myvid( mask, bg, opaMask, opaBg )

    tic
    [file,path] = uiputfile('RobrooSoSmart.avi','Save file name');
    PF = strcat(path,file);
    writeObj = VideoWriter(PF); % create the VideoWriter Object to save the video name Output
    open(writeObj); %start manipulating

    % framer = mask.FrameRate;
    % writeObj.FrameRate = framer;
    
    %get number of frames from 2 input videos(mask,bg)
    nframes = mask.NumberOfFrames;
    nframes2 = bg.NumberOfFrames;
    
    %get Width and Height from mask
    vidWidth = mask.Width;
    vidHeight = mask.Height;
    
    %get Width and Height from bg
    vidWidth2 = bg.Width;
    vidHeight2 = bg.Height;

    %create struct array of cdata with the same size of video
    %with 3 dimensions
    frameMask(1:nframes) = struct('cdata',zeros(vidHeight,vidWidth, 3, 'uint8'),'colormap',[]);
    frameBg(1:nframes2) = struct('cdata',zeros(vidHeight2,vidWidth2, 3, 'uint8'),'colormap',[]);

    %iterate through all frames
    for k = 1 : nframes-1
        
        %Read a video frame data
        frameMask(k).cdata = read(mask,k);
        frameBg(k).cdata = read(bg,k);

        %use those two frame to merge and get the WOW result
        frame = Hum_Segmentation(frameMask(k).cdata,frameBg(k).cdata, opaMask, opaBg);
        writeVideo(writeObj,frame); % write into Video Object
    end
    
    %just to close then write file
    close(writeObj);
    toc
end
