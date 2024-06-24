function varargout = ubah_pengguna(varargin)
% UBAH_PENGGUNA MATLAB code for ubah_pengguna.fig
%      UBAH_PENGGUNA, by itself, creates a new UBAH_PENGGUNA or raises the existing
%      singleton*.
%
%      H = UBAH_PENGGUNA returns the handle to a new UBAH_PENGGUNA or the handle to
%      the existing singleton*.
%
%      UBAH_PENGGUNA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UBAH_PENGGUNA.M with the given input arguments.
%
%      UBAH_PENGGUNA('Property','Value',...) creates a new UBAH_PENGGUNA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ubah_pengguna_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ubah_pengguna_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ubah_pengguna

% Last Modified by GUIDE v2.5 28-Aug-2023 20:05:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ubah_pengguna_OpeningFcn, ...
                   'gui_OutputFcn',  @ubah_pengguna_OutputFcn, ...
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
function ubah_pengguna_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ubah_pengguna (see VARARGIN)

% Choose default command line output for ubah_pengguna
handles.output = hObject;
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
% full = 'C:\bg\ubah_pengguna.jpg';
% bg = imread(full); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'bottom');
movegui('center');
% Update handles structure
guidata(hObject, handles);
function varargout = ubah_pengguna_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% POP-UP
function pop_user_Callback(hObject, eventdata, handles)
nama = get(hObject,'String');
pilih = nama(get(hObject,'Value'));
set(handles.user_selected,'String',pilih);

function pop_user_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
conn = database('login','','');
query = 'SELECT username FROM login';
data = string(table2array(fetch(conn,query)));
set(hObject,'string',data);

function new_password_Callback(hObject, eventdata, handles)
function new_password_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function new_user_Callback(hObject, eventdata, handles)
function new_user_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% PUSH BUTTON BUAT AKUN BARU
function pb_new_Callback(hObject, eventdata, handles)
user = string(get(handles.new_user,'String'));
pass = string(get(handles.new_password,'String'));
conn = database('login','','');

%cek akun yang sudah ada
query = 'SELECT username FROM login';
akun = table2array(fetch(conn,query));
if any(strcmp(user,akun))
    errordlg('Akun sudah ada','peringatan','modal');
else
    data = table(user,pass,'VariableNames',{'username' 'password'});
    sqlwrite(conn,'login',data);
    set(handles.new_user,'String','');
    set(handles.new_password,'String','');
    msgbox('Akun berhasil ditambah','berhasil','modal');
end
query = 'SELECT username FROM login';
data = string(table2array(fetch(conn,query)));
set(handles.pop_user,'string',data);
set(handles.user_selected,'String','');

% PUSH BUTTON HAPUS AKUN
function pb_hapus_Callback(hObject, eventdata, handles)
nama = get(handles.pop_user,'String');
pilih = nama(get(handles.pop_user,'Value'));
conn = database('login','','');
q1 = 'DELETE * FROM login WHERE username = ''%s''';
q2 = string(pilih);
sqlquery = sprintf(q1,q2);
answer = questdlg('Anda yakin ingin menghapusnya?','konfirmasi','Ya','Tidak','Tidak');
switch answer
    case 'Ya'
        execute(conn,sqlquery);
        msgbox('Akun berhasil dihapus','berhasil','modal');
%         close(conn);
    case 'Tidak'
%         close(conn);
end
query = 'SELECT username FROM login';
data = string(table2array(fetch(conn,query)));
set(handles.pop_user,'string',data);
set(handles.user_selected,'String','');
set(handles.pop_user,'value',1);   %fix bug

% PUSH BUTTON BACK
function pb_back_Callback(hObject, eventdata, handles)
form_penjualan;
close(ubah_pengguna);
