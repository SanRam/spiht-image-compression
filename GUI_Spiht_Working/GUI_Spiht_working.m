function varargout = GUI_Spiht_working(varargin)
% GUI_SPIHT_WORKING M-file for GUI_Spiht_working.fig
%      GUI_SPIHT_WORKING, by itself, creates a new GUI_SPIHT_WORKING or raises the existing
%      singleton*.
%
%      H = GUI_SPIHT_WORKING returns the handle to a new GUI_SPIHT_WORKING or the handle to
%      the existing singleton*.
%
%      GUI_SPIHT_WORKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SPIHT_WORKING.M with the given input arguments.
%
%      GUI_SPIHT_WORKING('Property','Value',...) creates a new GUI_SPIHT_WORKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Spiht_working_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Spiht_working_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Spiht_working

% Last Modified by GUIDE v2.5 06-May-2012 23:01:53

% Begin initialization code - DO NOT EDIT
clc;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Spiht_working_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Spiht_working_OutputFcn, ...
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


% --- Executes just before GUI_Spiht_working is made visible.
function GUI_Spiht_working_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Spiht_working (see VARARGIN)


   % Clear the image plot
    InitImageFig(handles)
    
% Choose default command line output for GUI_Spiht_working
handles.output = hObject;
handles.image_info=0;
handles.image_rex=0;
handles.impath=0;
handles.if_dicom=0;
handles.imname=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Spiht_working wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Spiht_working_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function InitImageFig(handles)
    img=ones(10,10,3);
    
    axes(handles.image_original);
    imshow(img,[]);
    
    img_res=ones(10,10,3);    
    axes(handles.image_processed);
    imshow(img_res,[]); 
  % if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   % set(hObject,'BackgroundColor','white');
  % end
    

function InitImageFig1(handles)
   % img=ones(10,10,3);
    
   % axes(handles.image_original);
  %  imshow(img,[]);
    
    img_res=ones(10,10,3);    
    axes(handles.image_processed);
    imshow(img_res,[]); 
    bpp='';
    mse1='';
    psnr1='';
    comp='';
    set(handles.edit24,'String',sprintf('%2.5f',bpp),'UserData',bpp);     %display bpp
    set(handles.edit21,'String',sprintf('%3.2f',mse1),'UserData',mse1);   %display mse
    set(handles.edit25,'String',sprintf('%3.2f',psnr1),'UserData',psnr1); %display psnr
    set(handles.edit26,'String',sprintf('%3.2f',comp),'UserData',comp);   %display comperssion ratio

   %if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   % set(hObject,'BackgroundColor','white');
   %end   
    
    function ShowImageFile(filename,pathname,handles)
    if ~isequal(filename, 0)
        fn=strcat(pathname,filename);
        setappdata(handles.imname,'name1',filename);
        
        bx1 = strfind(filename,'.dcm');
        
        setappdata(handles.if_dicom,'User1',bx1);
        
        if bx1>=1
        img_ori=dicomread(fn);
        axes(handles.image_original);
        imshow(img_ori,[]);
        
        set(handles.image_original,'UserData',img_ori);
                
        img_inf=dicominfo(fn);
        setappdata(handles.image_info,'User2',img_inf);
        
        else   
        img_ori=imread(fn);
        axes(handles.image_original);
        imshow(img_ori,[]);
        set(handles.image_original,'UserData',img_ori);
        
        img_inf=imfinfo(fn);
        setappdata(handles.image_info,'User2',img_inf);
        end
 
    end
    

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile({'*.bmp';'*.cur';'*.dcm';'*.gif';'*.hdf';'*.j2c';'*.j2k';'*.jp2';'*.jpf';'*.jpx';'*.jpg';'*.jpeg';'*.pbm';'*.pcx';'*.pgm';'*.png';'*.pnm';'*.ppm';'*.ras';'*.tif';'*.tiff';'*.xwd'},'Select a image file');
ShowImageFile(filename,pathname,handles);
InitImageFig1(handles)


% --------------------------------------------------------------------
function SaveMenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im_inf=getappdata(handles.image_info,'User2');

tt=getappdata(handles.if_dicom,'User1');
if tt>=1
[filename,pathname] = uiputfile({'*.dcm'});
fn=strcat(pathname,filename);

im_recon=getappdata(handles.image_rex,'User3');
dicomwrite((im_recon),fn,im_inf);
else
img_res=get(handles.image_processed,'Userdata');
savePlotWithinGUI(img_res);
end

function edit20_Callback(hObject, ~, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
% for clearing the values
    InitImageFig1(handles)
    bpp='';
    mse1='';
    psnr1='';
    comp='';
    set(handles.edit24,'String',sprintf('%2.5f',bpp),'UserData',bpp);     %display bpp
    set(handles.edit21,'String',sprintf('%3.2f',mse1),'UserData',mse1);   %display mse
    set(handles.edit25,'String',sprintf('%3.2f',psnr1),'UserData',psnr1); %display psnr
    set(handles.edit26,'String',sprintf('%3.2f',comp),'UserData',comp);   %display comperssion ratio
    
im_name=getappdata(handles.imname,'name1');
im_info=getappdata(handles.image_info,'User2');

ax1=(im_info.BitDepth);

if   0<ax1<=48                  %((ax1==8)||(ax1==16)||(ax1==24))
    
img_ori=get(handles.image_original,'Userdata');  %get org image 
thre=str2num(get(handles.edit20,'String'));      %get Threshold value 
tt=get(handles.popupmenu10,'value');             %get Filter type value  
switch tt                                        %select Filter type
    case 1
        m='bior1.1';
        
    case 2
        m='bior1.3';
        
    case 3
        m='bior1.5';
        
    case 4
        m='bior2.2';
        
    case 5
        m='bior2.4';
        
    case 6
        m='bior2.6';
        
    case 7
        m='bior2.8';
        
    case 8
        m='bior3.1';
        
    case 9
        m='bior3.3';
        
    case 10
        m='bior3.5';
        
    case 11
        m='bior3.7';
        
    case 12
        m='bior3.9';
        
    case 13
        m='bior4.4';
        
    case 14
        m='bior5.5';
        
    case 15
        m='bior6.8';
              
end

[img_res,bpp,mse1,psnr1,comp]=func_SPIHT_Main(img_ori,thre,m,im_info,im_name);         %call spiht main function
setappdata(handles.image_rex,'User3',img_res);

axes(handles.image_processed);                                            %for 
    imshow(img_res,[]);colormap(gray);                                    %ploting reconstructed image
    set(handles.edit24,'String',sprintf('%2.5f',bpp),'UserData',bpp);     %display bpp
    set(handles.edit21,'String',sprintf('%3.2f',mse1),'UserData',mse1);   %display mse
    set(handles.edit25,'String',sprintf('%3.2f',psnr1),'UserData',psnr1); %display psnr
    set(handles.edit26,'String',sprintf('%3.2f',comp),'UserData',comp);   %display comperssion ratio
    
else
    fprintf('error invalid bitdepth : Matlab does not support current bitdepth of the image\n');
     bpp='error';
    mse1='error';
    psnr1='error';
    comp='error';
    set(handles.edit24,'String',sprintf('%s',bpp),'UserData',bpp);     %display bpp
    set(handles.edit21,'String',sprintf('%s',mse1),'UserData',mse1);   %display mse
    set(handles.edit25,'String',sprintf('%s',psnr1),'UserData',psnr1); %display psnr
    set(handles.edit26,'String',sprintf('%s',comp),'UserData',comp);   %display comperssion ratio
    
end

% --- Executes on selection change in popupmenu10.
function [sel_val]=popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
  sel_val = get(hObject,'Value');
  



% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu10.
function popupmenu10_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile({'*.bmp';'*.cur';'*.dcm';'*.gif';'*.hdf';'*.j2c';'*.j2k';'*.jp2';'*.jpf';'*.jpx';'*.jpg';'*.jpeg';'*.pbm';'*.pcx';'*.pgm';'*.png';'*.pnm';'*.ppm';'*.ras';'*.tif';'*.tiff';'*.xwd'},'Select a image file');
%'*.cur','*.gif','*.hdf','*.j2c','*.j2k','*.jp2','*.jpf','*.jpx','*.jpg','*.jpeg','*.pbm','*.pcx','*.pgm','*.png','*.pnm','*.ppm','*.ras','*.tif','*.tiff','*.xwd'
ShowImageFile(filename,pathname,handles);
InitImageFig1(handles)



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


im_inf=getappdata(handles.image_info,'User2');

tt=getappdata(handles.if_dicom,'User1');
if tt>=1
[filename,pathname] = uiputfile({'*.dcm'});
fn=strcat(pathname,filename);

im_recon=getappdata(handles.image_rex,'User3');
dicomwrite((im_recon),fn,im_inf);
else
img_res=get(handles.image_processed,'Userdata');
savePlotWithinGUI(img_res);
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xx1=HELP();

% --- Executes during object creation, after setting all properties.
function pushbutton8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Helpmenu_Callback(hObject, eventdata, handles)
% hObject    handle to Helpmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xx1=HELP();


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S.fh = figure('units','pixels',...
              'position',[400 400 300 200],...
              'menubar','none',...
              'name','SPIHT',...
              'numbertitle','off',...
              'resize','off');
S.tx = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[20 20 260 160],...
                 'fontsize',14,...
                 'string','Image compression using SPIHT algorithm.                                                                    This Project is licensed to Santhosh Ramaiah');


% --------------------------------------------------------------------
function ExitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(GUI_Spiht_working);
