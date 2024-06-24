function varargout = form_login(varargin)
% FORM_LOGIN MATLAB code for form_login.fig
%      FORM_LOGIN, by itself, creates a new FORM_LOGIN or raises the existing
%      singleton*.
%
%      H = FORM_LOGIN returns the handle to a new FORM_LOGIN or the handle to
%      the existing singleton*.
%
%      FORM_LOGIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_LOGIN.M with the given input arguments.
%
%      FORM_LOGIN('Property','Value',...) creates a new FORM_LOGIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_login_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_login_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_login

% Last Modified by GUIDE v2.5 29-Dec-2022 14:51:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_login_OpeningFcn, ...
                   'gui_OutputFcn',  @form_login_OutputFcn, ...
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
function form_login_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_login (see VARARGIN)

% Choose default command line output for form_login
handles.output = hObject;

ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
% full = 'C:\bg\form_login.jpg';
% bg = imread(full); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'bottom');

handles.FirstKeyFlag = 1;
uicontrol(handles.et_user);
movegui('center');
% Update handles structure
guidata(hObject, handles);
function varargout = form_login_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% id = handles.id;
% Get default command line output from handles structure
varargout{1} = handles.output;



% PUSH BUTTON LOGIN
function pb_login_Callback(hObject, eventdata, handles)
% [real_id,real_pass] = credential;
conn = database('login','','');
query = ['SELECT username FROM login'];
data = table2array(fetch(conn,query));
% id = get(handles.dummy,'String');
id = get(handles.et_user,'String');
handles.id = id;
if any(strcmp(id,data)) %&& strcmp(pass,real_pass)
    close(conn);
    password;
%     msgbox('Login Successful');
else
    close(conn);
    errordlg('ID yang dimasukkan salah','Salah ID','modal');   
end

function pb_login_KeyPressFcn(hObject, eventdata, handles)
switch eventdata.Key
    case 'return'
        pb_login_Callback(hObject, eventdata, handles)
end

function et_user_Callback(hObject, eventdata, handles)
function et_user_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function et_user_KeyPressFcn(hObject, eventdata, handles)
% cc = eventdata.Character;
% ss = double(cc);
% if ss == 13 %enter/return
% %     handles.rr = get(handles.et_user,'String'); %bugged/glitch
% %     enter = get(handles.dummy,'String');
%     pb_login_Callback(hObject, eventdata, handles)
% %     close(form_login);
%     
% elseif ss == 127 %del
%     %nothing
% else
%     if handles.FirstKeyFlag == 1
%         handles.rr = cc;
%         handles.FirstKeyFlag = 0;   
%     else
%         if double(cc) == 8 %backspace
%             handles.rr = handles.rr(1:end-1);
%         else
%             handles.rr = horzcat(handles.rr,cc);
%         end
%     end
% end
% guidata(hObject,handles);
% set(handles.dummy,'String',handles.rr);
% set(handles.et_user,'String',char('*' * sign(handles.rr)));
