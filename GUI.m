function varargout = vid_slider_work(varargin)
% VID_SLIDER_WORK MATLAB code for vid_slider_work.fig

% declare global images and video to use with processing
% img1 is mask image, img2 is bg image
% the same goes for video

global img1 img2;
global vid1 vid2;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vid_slider_work_OpeningFcn, ...
                   'gui_OutputFcn',  @vid_slider_work_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before vid_slider_work is made visible.
function vid_slider_work_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = vid_slider_work_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in selectMaskBtn.
function selectMaskBtn_Callback(hObject, eventdata, handles)

    % For MASK
    % create a gui to get the video file, then update the axis and set the
    % min,max, val of frameSlider
    
    global vid1 img1;
    filename = uigetfile('*.*');
    vid1 = VideoReader(filename);
    set(handles.text1,'string',filename);
    
    img1 = read(vid1,1);
    axes(handles.maskAxis);
    imshow(img1);
    genFrame(handles);
    
    nframes = vid1.NumberOfFrames;
    set(handles.frameSlider,'min',1);
    set(handles.frameSlider,'max',nframes);
    set(handles.frameSlider,'value',1);


% --- Executes on button press in selectBgBtn.
function selectBgBtn_Callback(hObject, eventdata, handles)

    % For BACKGROUND
    % create a gui to get the video file, then update the axis and set the
    % min,max, val of frameSlider
    
    global vid2 img2;
    filename = uigetfile('*.*');
    vid2 = VideoReader(filename);
    set(handles.text2,'string',filename);
    
    img2 = read(vid2,1);
    axes(handles.bgAxis);
    imshow(img2);
    genFrame(handles);

    
function genFrame(handles)

    % generate preview frame to be at the preview Axis with current opacity
    % and threshold values if vid1 & vid2 are not empty
    
    global img1 img2 vid1 vid2;
    
    opacityMask = get(handles.maskOpaSlider,'Value');
    opacityBg = get(handles.bgOpaSlider,'Value');
    thre = round(get(handles.thresholdSlider,'Value'));
    
    if (isempty(vid1) ~= 1 && isempty(vid2) ~= 1)
        out = HumanExtraction(img1,img2,opacityMask,opacityBg, thre); 
        axes(handles.previewAxis);
        imshow(out);
    end
    
    
function updateImg(handles)

    %Just to update 2 Axes, set 2 axes as the frame we get
    
    global vid1 vid2 img1 img2;
    val = round(get(handles.frameSlider,'Value'));
    img1 = read(vid1,val);
    img2 = read(vid2,val);
    
    
    axes(handles.maskAxis);
    imshow(img1);
    axes(handles.bgAxis);
    imshow(img2);
        


% --- Executes on slider movement.
function frameSlider_Callback(hObject, eventdata, handles)

    % need slider to take almost-real time preview, so update 2 bg,mask
    % axes then gen the previewFrame
    
    updateImg(handles);
    genFrame(handles);


% --- Executes during object creation, after setting all properties.
function frameSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in genVideoBtn.
function genVideoBtn_Callback(hObject, eventdata, handles)

    %just passing parameters(Opacity of Mask,bg, threshold) to VideoWorker to create a video
    
    global vid1 vid2;
    
    opacityMask = get(handles.maskOpaSlider,'Value');
    opacityBg = get(handles.bgOpaSlider,'Value');
    thre = round(get(handles.thresholdSlider,'Value'));
    
    VideoWorker(vid1, vid2 ,opacityMask, opacityBg, thre);


% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)

    %generate the previewFrame then set the threshold txt
    
    set(handles.threText,'String', round(get(hObject,'Value')));
    genFrame(handles);
    

% --- Executes during object creation, after setting all properties.
function thresholdSlider_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    set(hObject,'min',0);
    set(hObject,'max',255);
    set(hObject,'value',150);


% --- Executes on slider movement.
function maskOpaSlider_Callback(hObject, eventdata, handles)

    %generate the previewFrame then set the opacity mask txt

    set(handles.maskSlideVal,'String', get(hObject,'Value'));
    genFrame(handles);
    


% --- Executes during object creation, after setting all properties.
function maskOpaSlider_CreateFcn(hObject, eventdata, handles)

    %Here is just to scope a step size and max,min

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
    set(hObject,'min',0);
    set(hObject,'max',1);
    set(hObject,'value',0.8);



% --- Executes on slider movement.
function bgOpaSlider_Callback(hObject, eventdata, handles)

    %generate the previewFrame then set the opacity background txt

    set(handles.bgSlideVal,'String', get(hObject,'Value'));
    genFrame(handles);


% --- Executes during object creation, after setting all properties.
function bgOpaSlider_CreateFcn(hObject, eventdata, handles)

    %Here is just to scope a step size and max,min

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
    set(hObject,'min',0);
    set(hObject,'max',1);
    set(hObject,'value',0.5);
