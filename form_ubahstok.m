function varargout = form_ubahstok(varargin)
% FORM_UBAHSTOK MATLAB code for form_ubahstok.fig
%      FORM_UBAHSTOK, by itself, creates a new FORM_UBAHSTOK or raises the existing
%      singleton*.
%
%      H = FORM_UBAHSTOK returns the handle to a new FORM_UBAHSTOK or the handle to
%      the existing singleton*.
%
%      FORM_UBAHSTOK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_UBAHSTOK.M with the given input arguments.
%
%      FORM_UBAHSTOK('Property','Value',...) creates a new FORM_UBAHSTOK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_ubahstok_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_ubahstok_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_ubahstok

% Last Modified by GUIDE v2.5 18-Apr-2024 02:35:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_ubahstok_OpeningFcn, ...
                   'gui_OutputFcn',  @form_ubahstok_OutputFcn, ...
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
function form_ubahstok_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_ubahstok (see VARARGIN)

% Choose default command line output for form_ubahstok
set(handles.pb_set,'Enable','off');
set(handles.pb_hapus,'Enable','off');
set(handles.pb_tambah,'Enable','off');
set(handles.pb_drop_dist,'Enable','off');

handles.output = hObject;
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
% full = 'C:\bg\form_ubahstok.jpg';
% bg = imread(full); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'bottom');
movegui('center');
% Update handles structure
guidata(hObject, handles);
function varargout = form_ubahstok_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% PUSH BUTTON SET/UPDATE BARANG
function pb_set_Callback(hObject, eventdata, handles)
conn = database('stokproduk','','');
nama_baru = get(handles.ubahnama,'String');
stok_baru = str2double(get(handles.jumlah,'String'));
harga_baru = str2double(get(handles.harga,'String'));
namabarang = 'SELECT barang FROM stok';
barang = table2array(fetch(conn,namabarang));
if nama_baru == ""
    warndlg('Nama tidak boleh kosong','Peringatan','modal');
% elseif any(strcmp(nama_baru,barang))
%     warndlg('Nama Barang sudah ada','Ubah nama','modal');
elseif get(handles.jumlah,'string') == ""
    warndlg('masukkan jumlah','peringatan','modal');
elseif get(handles.harga,'string') == ""
    warndlg('masukkan harga','peringatan','modal');
else
    pilih = string(handles.pilih);
    qq = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
    clause2 = sprintf(qq,pilih);
    qwe = string(table2array(fetch(conn,clause2)));
    disp(qwe)
    data = table(nama_baru,stok_baru,harga_baru,'VariableNames',{'barang' 'jumlah' 'harga_jual'});
    query1 = 'WHERE id_barang = %s';
    clause = sprintf(query1,qwe);
    update(conn,'stok',{'barang','jumlah','harga_jual'},data,clause);
    set(handles.stok_sekarang,'String',stok_baru);
    set(handles.harga_sekarang,'String',harga_baru);
    query = 'SELECT barang FROM stok';
    datapop = string(table2array(fetch(conn,query)));
    set(handles.pop_barang,'String',datapop);   
    msgbox('berhasil');
end


% POP-UP BARANG
function pop_barang_Callback(hObject, eventdata, handles)
conn = database('stokproduk','','');
konten = get(hObject,'Value');

nama = get(hObject,'String');
pilih = nama(get(hObject,'Value'));
asd = string(pilih);
handles.konten = konten;
handles.pilih = pilih;

qq1 = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
clause2 = sprintf(qq1,asd);
qwe = string(table2array(fetch(conn,clause2)));

q1 = 'SELECT `jumlah` FROM stok WHERE id_barang = %s';
% q2 = num2str(konten);
query = sprintf(q1,qwe);
stok = table2array(fetch(conn,query));
set(handles.stok_sekarang,'String',stok);
set(handles.jumlah,'String','');
set(handles.harga,'String','');

q1_nama = 'SELECT `barang` FROM stok WHERE id_barang = %s';
query2 = sprintf(q1_nama,qwe);
barang = table2array(fetch(conn,query2));
set(handles.ubahnama,'String',barang);

q1_harga = 'SELECT `harga_jual` FROM stok WHERE id_barang = %s';
query3 = sprintf(q1_harga,qwe);

harga = table2array(fetch(conn,query3));
    rupiah = sprintf('Rp. %.f',harga);
            if length(reverse(rupiah)) > 13
                format = insertAfter(reverse(rupiah),9,'.');
                format = insertAfter(format,6,'.');
                format = insertAfter(format,3,'.');
            elseif length(reverse(rupiah)) > 10
                format = insertAfter(reverse(rupiah),6,'.');
                format = insertAfter(format,3,'.');
            else
                format = insertAfter(reverse(rupiah),3,'.');
            end
set(handles.harga_sekarang,'String',reverse(format)); %tampilkan harga barang

q1_harga_dist = 'SELECT `harga_asli` FROM stok WHERE id_barang = %s';
query4 = sprintf(q1_harga_dist,qwe);

harga2 = table2array(fetch(conn,query4));
    rupiah = sprintf('Rp. %.f',harga2);
            if length(reverse(rupiah)) > 13
                format = insertAfter(reverse(rupiah),9,'.');
                format = insertAfter(format,6,'.');
                format = insertAfter(format,3,'.');
            elseif length(reverse(rupiah)) > 10
                format = insertAfter(reverse(rupiah),6,'.');
                format = insertAfter(format,3,'.');
            else
                format = insertAfter(reverse(rupiah),3,'.');
            end
set(handles.harga_dist,'String',reverse(format)); %tampilkan harga barang


guidata(hObject,handles);
set(handles.pb_set,'Enable','on');
set(handles.pb_hapus,'Enable','on');
set(handles.pb_tambah,'Enable','on');

function pop_barang_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
conn = database('stokproduk','','');
query = 'SELECT barang FROM stok';
data = string(table2array(fetch(conn,query)));
set(hObject,'String',data);

% ------ EDIT TEXT PANEL -------
function jumlah_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));
if isnan(qty)
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_set,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.pb_set,'Enable','on');
end
function jumlah_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%-----------------------------------------------------------------------------
function harga_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));;
if isnan(qty)
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_set,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.pb_set,'Enable','on');
end
function harga_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%-----------------------------------------------------------------------------
function ubahnama_Callback(hObject, eventdata, handles)
function ubahnama_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function barangbaru_Callback(hObject, eventdata, handles)
function barangbaru_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function jumlahbaru_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));;
if isnan(qty)
    set(handles.pb_tambah,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_tambah,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_tambah,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.pb_tambah,'Enable','off');
end
function jumlahbaru_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hargabaru_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));;
if isnan(qty)
    set(handles.pb_tambah,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_tambah,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_tambah,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.pb_tambah,'Enable','on');
end
function hargabaru_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function harga_jual_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));
if isnan(qty)
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_set,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.pb_set,'Enable','on');
end
function harga_jual_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% PUSH BUTTON TAMBAH BARANG
function pb_tambah_Callback(hObject, eventdata, handles)
selection = get(handles.rb_add,'Value');
new_barang = string(get(handles.barangbaru,'String'));
new_jumlah = str2double(get(handles.jumlahbaru,'String'));
new_harga = str2double(get(handles.hargabaru,'String'));
hrg_jual = str2double(get(handles.harga_jual,'String'));
conn = database('stokproduk','','');

% ambil id barang & distributor
Q_id_barang = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
pilih       = get(handles.pop_barang,'String');
Q_pilih     = pilih(get(handles.pop_barang,'Value'));
clause1     = sprintf(Q_id_barang,string(Q_pilih));
id_barang   = table2array(fetch(conn,clause1));

Q_id_dist    = 'SELECT id_distributor FROM distributor WHERE nama = ''%s''';
pilih_dist   = get(handles.popdist,'String');
Q_pilih_dist = pilih_dist(get(handles.popdist,'Value'));
clause2      = sprintf(Q_id_dist,string(Q_pilih_dist));
id_dist      = table2array(fetch(conn,clause2));

% ambil stok yang sudah ada
querystok    = 'SELECT jumlah FROM stok WHERE barang = ''%s''';
Q_querystok  = sprintf(querystok,string(Q_pilih));
stok         = table2array(fetch(conn,Q_querystok));
stokfinal    = stok + new_jumlah;

% total belanja
subtotal = new_jumlah * new_harga;
tgl_sekarang = datetime('now');
tgl_sekarang.Format = 'MM-dd-yyyy';

%cek barang yang sudah ada
query = 'SELECT barang from stok';
barang = table2array(fetch(conn,query));
if any(strcmp(new_barang,barang))
    warndlg('Nama Barang sudah ada','Ubah nama','modal');
elseif new_barang == "" && selection == 0
    warndlg('Nama tidak boleh kosong','Peringatan','modal');
elseif string(new_jumlah) == ""
    warndlg('Jumlah tidak boleh kosong','Peringatan','modal');
elseif string(new_harga) == ""
    warndlg('Harga tidak boleh kosong','Peringatan','modal');
elseif string(hrg_jual) == ""
    warndlg('Harga jual tidak boleh kosong','Peringatan','modal');
elseif selection == 1
    % UPDATE INTO STOK
    data     = table(stokfinal,'VariableNames',{'jumlah'});
    clause   = 'WHERE id_barang = %s';
    Q_clause = sprintf(clause,string(id_barang));
    update(conn,'stok',{'jumlah'},data,Q_clause);

    % INSERT INTO PEMBELIAN
    data = table(id_barang,id_dist,new_jumlah,new_harga,subtotal,string(tgl_sekarang),'VariableNames',{'id_barang' 'id_distributor' 'kuantitas_beli' 'harga_satuan' 'subtotal' 'tgl_pembelian'});
    sqlwrite(conn,'pembelian',data);
    set(handles.barangbaru,'String','');
    set(handles.jumlahbaru,'String','');
    set(handles.hargabaru,'String','');
    msgbox('berhasil','modal')    
else
    % INSERT INTO STOK
    data = table(new_barang,new_jumlah,hrg_jual,new_harga,'VariableNames',{'barang' 'jumlah' 'harga_jual' 'harga_asli'});
    sqlwrite(conn,'stok',data);
    
    % INSERT INTO PEMBELIAN
    data = table(id_barang,id_dist,new_jumlah,new_harga,subtotal,string(tgl_sekarang),'VariableNames',{'id_barang' 'id_distributor' 'kuantitas_beli' 'harga_satuan' 'subtotal' 'tgl_pembelian'});
    sqlwrite(conn,'pembelian',data);
    set(handles.barangbaru,'String','');
    set(handles.jumlahbaru,'String','');
    set(handles.hargabaru,'String','');
    set(handles.harga_jual,'String','');
    msgbox('berhasil','modal')
end
% REFRESH PANEL
query = 'SELECT barang FROM stok';
data = string(table2array(fetch(conn,query)));
set(handles.pop_barang,'String',data);   
set(handles.stok_sekarang,'String',stokfinal);


% PUSH BUTTON HAPUS BARANG.
function pb_hapus_Callback(hObject, eventdata, handles)
conn = database('stokproduk','','');
konten = handles.konten;
pilih = string(handles.pilih);
qq1 = 'select id_barang from stok where barang = ''%s''';
clause2 = sprintf(qq1,pilih);
qwe = string(table2cell(fetch(conn,clause2)));
disp(qwe)
whos qwe
query1 = 'DELETE * FROM stok WHERE id_barang = %s';
% query2 = num2str(konten);
clause = sprintf(query1,qwe);
execute(conn,clause);
msgbox('data berhasil dihapus','','modal');

% REFRESH PANEL
query = 'SELECT barang FROM stok';
data = string(table2array(fetch(conn,query)));
set(handles.pop_barang,'String',data);   
set(handles.pop_barang,'value',1);
set(handles.harga_sekarang,'String','');
set(handles.harga_dist,'String','');
set(handles.stok_sekarang,'String','');
set(handles.ubahnama,'String','');


% PUSH BUTTON BACK
function pb_back_Callback(hObject, eventdata, handles)
form_penjualan;
close(form_ubahstok);


% POP-UP DISTRIBUTOR
function popdist_Callback(hObject, eventdata, handles)
konten_dist = get(hObject,'Value');
nama_dist = get(hObject,'String');
pilih_dist = nama_dist(get(hObject,'Value'));

handles.konten_dist = konten_dist;
handles.pilih_dist = pilih_dist;
guidata(hObject,handles);
set(handles.pb_drop_dist,'Enable','on');

function popdist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
conn = database('stokproduk','','');
query = 'SELECT nama FROM distributor';
data = string(table2array(fetch(conn,query)));
set(hObject,'String',data);


% PUSH BUTTON TAMBAH DISTRIBUTOR.
function pb_add_dist_Callback(hObject, eventdata, handles)
new_dist    = string(get(handles.nama_dist,'String'));
new_alamat  = string(get(handles.alamat_dist,'String'));
new_telp    = string(get(handles.telp_dist,'String'));
conn        = database('stokproduk','','');
distributor = table2array(fetch(conn,'SELECT nama FROM distributor'));;

%cek nama distributor
if any(strcmp(new_dist,distributor))
    warndlg('Nama Distributor sudah ada','','modal');
elseif new_dist == ""
    warndlg('Nama tidak boleh kosong','Peringatan','modal');
elseif new_alamat == ""
    warndlg('Alamat tidak boleh kosong','Peringatan','modal');
elseif new_telp == ""
    warndlg('Telepon tidak boleh kosong','Peringatan','modal');
else
    data = table(new_dist,new_alamat,new_telp,'VariableNames',{'nama' 'alamat' 'telepon'});
    sqlwrite(conn,'distributor',data);
    set(handles.nama_dist,'String','');
    set(handles.alamat_dist,'String','');
    set(handles.telp_dist,'String','');
    msgbox('berhasil','modal');
end
% REFRESH PANEL
query = 'SELECT nama FROM distributor';
data = string(table2array(fetch(conn,query)));
set(handles.popdist,'String',data);   


% PUSH BUTTON HAPUS DISTRIBUTOR.
function pb_drop_dist_Callback(hObject, eventdata, handles)
conn = database('stokproduk','','');
konten_dist = handles.konten_dist;
pilih_dist = string(handles.pilih_dist);
qq1 = 'select id_distributor from distributor where nama = ''%s''';
clause2 = sprintf(qq1,pilih_dist);
qwe = string(table2cell(fetch(conn,clause2)));
query1 = 'DELETE * FROM distributor WHERE id_distributor = %s';
% query2 = num2str(konten);
clause = sprintf(query1,qwe);
execute(conn,clause);
msgbox('data berhasil dihapus','','modal');

% REFRESH PANEL
query = 'SELECT nama FROM distributor';
data = string(table2array(fetch(conn,query)));
set(handles.popdist,'String',data);   
set(handles.popdist,'value',1);



% EDIT TEXT DISTRIBUTOR
function nama_dist_Callback(hObject, eventdata, handles)
function nama_dist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function alamat_dist_Callback(hObject, eventdata, handles)
function alamat_dist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function telp_dist_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));
if isnan(qty)
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_set,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_set,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.pb_set,'Enable','on');
end
function telp_dist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- RADIO BUTTON UNTUK TAMBAH.
function rb_add_Callback(hObject, eventdata, handles)
select = get(hObject,'Value');
if select == 1
   set(handles.barangbaru,'Enable','off');
   set(handles.harga_jual,'Enable','off');
elseif select == 0
   set(handles.barangbaru,'Enable','on');
   set(handles.harga_jual,'Enable','on');
end



