function varargout = vid_slider_work(varargin)
% VID_SLIDER_WORK MATLAB code for vid_slider_work.fig
%      VID_SLIDER_WORK, by itself, creates a new VID_SLIDER_WORK or raises the existing
%      singleton*.
%
%      H = VID_SLIDER_WORK returns the handle to a new VID_SLIDER_WORK or the handle to
%      the existing singleton*.
%
%      VID_SLIDER_WORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VID_SLIDER_WORK.M with the given input arguments.
%
%      VID_SLIDER_WORK('Property','Value',...) creates a new VID_SLIDER_WORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vid_slider_work_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vid_slider_work_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vid_slider_work

% Last Modified by GUIDE v2.5 10-Jul-2015 02:36:09

% Begin initialization code - DO NOT EDIT
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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vid_slider_work (see VARARGIN)

% Choose default command line output for vid_slider_work
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vid_slider_work wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vid_slider_work_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectMaskBtn.
function selectMaskBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selectMaskBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
% hObject    handle to selectBgBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global vid2 img2;
    filename = uigetfile('*.*');
    vid2 = VideoReader(filename);
    set(handles.text2,'string',filename);
    
    img2 = read(vid2,1);
    axes(handles.bgAxis);
    imshow(img2);
    genFrame(handles);

    
function genFrame(handles)
    global img1 img2 vid1 vid2;
    %get the opacity from the textbox
    opacityMask = str2double(get(handles.opaMask,'String'));
    opacityBg = str2double(get(handles.opaBg,'String'));
    thre = round(get(handles.thresholdSlider,'Value'));

    
    if (isempty(vid1) ~= 1 && isempty(vid2) ~= 1)
        out = HumanExtraction(img1,img2,opacityMask,opacityBg, thre); 
        axes(handles.previewAxis);
        imshow(out);
    end
    
    
function updateImg(handles)
    global vid1 vid2 img1 img2;
    
    val = round(get(handles.frameSlider,'Value'));
    img1 = read(vid1,val);
    img2 = read(vid2,val);
    
    %set 2 axes as the frame we get
    axes(handles.maskAxis);
    imshow(img1);
    axes(handles.bgAxis);
    imshow(img2);
        


% --- Executes on slider movement.
function frameSlider_Callback(hObject, eventdata, handles)
    updateImg(handles);
    genFrame(handles);


% --- Executes during object creation, after setting all properties.
function frameSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in genVideoBtn.
function genVideoBtn_Callback(hObject, eventdata, handles)
    global vid1 vid2;
    
    opacityMask = str2double(get(handles.opaMask,'String'));
    opacityBg = str2double(get(handles.opaBg,'String'));
    thre = round(get(handles.thresholdSlider,'Value'));
    
    VideoWorker(vid1, vid2 ,opacityMask, opacityBg, thre);



function opaMask_Callback(hObject, eventdata, handles)
    opVal = get(hObject,'String');
    opVal = str2double(opVal);

    if opVal > 1
        opVal = 1.0;
        set(hObject, 'String', num2str( opVal ));
    elseif opVal < 0
        opVal = 0.0;
        set(hObject, 'String', num2str( opVal ));
    end
    genFrame(handles);




function opaMask_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function opaBg_Callback(hObject, eventdata, handles)
    opVal = get(hObject,'String');
    opVal = str2double(opVal);

    if opVal > 1
        opVal = 1.0;
        set(hObject, 'String', num2str( opVal ));
    elseif opVal < 0
        opVal = 0.0;
        set(hObject, 'String', num2str( opVal ));
    end
    genFrame(handles);


% --- Executes during object creation, after setting all properties.
function opaBg_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)
    genFrame(handles);
    

% --- Executes during object creation, after setting all properties.
function thresholdSlider_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    set(hObject,'min',0);
    set(hObject,'max',255);
    set(hObject,'value',150);

