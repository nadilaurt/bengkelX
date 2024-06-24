function varargout = form_penjualan(varargin)
% FORM_PENJUALAN MATLAB code for form_penjualan.fig
%      FORM_PENJUALAN, by itself, creates a new FORM_PENJUALAN or raises the existing
%      singleton*.
%
%      H = FORM_PENJUALAN returns the handle to a new FORM_PENJUALAN or the handle to
%      the existing singleton*.
%
%      FORM_PENJUALAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_PENJUALAN.M with the given input arguments.
%
%      FORM_PENJUALAN('Property','Value',...) creates a new FORM_PENJUALAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_penjualan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_penjualan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_penjualan

% Last Modified by GUIDE v2.5 19-May-2024 23:32:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_penjualan_OpeningFcn, ...
                   'gui_OutputFcn',  @form_penjualan_OutputFcn, ...
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
function form_penjualan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_penjualan (see VARARGIN)
% close(form_login);
% Choose default command line output for form_penjualan
handles.output = hObject;

ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
% full = 'C:\bg\form_penjualan.jpg';
% bg = imread(full); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'bottom');

handles.FirstKeyFlag = 1;
uicontrol(handles.kuantitas);
movegui('center');
% Update handles structure
guidata(hObject, handles);
set(handles.kuantitas,'Enable','off');
set(handles.kuantitas2,'Enable','off');
set(handles.total_bayar,'Enable','off');
set(handles.pb_bayar,'Enable','off');
set(handles.pembeli,'Enable','off');
set(handles.pb_tambahbarang,'Enable','off');
set(handles.konfirmasi,'Enable','off');

function varargout = form_penjualan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%-----------------------------------------------------------------
function kuantitas_Callback(hObject, eventdata, handles)
str = str2double(get(hObject,'String'));
if isnan(str)
    set(hObject,'String','');
    errordlg('Masukkan hanya angka','Peringatan','modal');
    set(handles.total_seluruh,'String','');
elseif isempty(str)
    set(hObject,'String','');
    errordlg('isis tidak boleh kosong','Peringatan','modal');
    set(handles.total_seluruh,'String','');    
end
% set(handles.kuantitas,'String','');    
function kuantitas_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function kuantitas_KeyPressFcn(hObject, eventdata, handles)
inputharga = get(handles.detail_harga,'String');
if inputharga == ""
    errordlg('pilih barang dahulu','warning','modal');
else
    ec = eventdata.Character;
    kuantitas = double(ec);
    if handles.FirstKeyFlag == 1
        handles.rr = ec;
        handles.FirstKeyFlag = 0;
    elseif any(kuantitas == [47:58]) % angka
        handles.rr = horzcat(handles.rr,ec);
    elseif kuantitas == 8 % backspace
        handles.rr = handles.rr(1:end-1);
    elseif kuantitas == 127 % del
        % do nothing
    elseif kuantitas == 32 % spasi/space
        % do nothing
    else
        set(handles.kuantitas,'String',' ');
    end
end

%kalkulasi uang total
hargaonly = handles.hargaonly;
qty = str2double(handles.rr);
total_harga = qty * hargaonly;
handles.harga_keseluruhan = total_harga; %return variabel ke global

%tampilkan uang total ke bentuk rupiah string
rupiah = 'Rp. %.f';
format = sprintf(rupiah,total_harga);
reverse_format = reverse(format);

if length(reverse_format) > 13
    format2 = insertAfter(reverse_format,9,'.');
    format2 = insertAfter(format2,6,'.');
    format2 = insertAfter(format2,3,'.');
elseif length(reverse_format) > 10
    format2 = insertAfter(reverse_format,6,'.');
    format2 = insertAfter(format2,3,'.');
else
    format2 = insertAfter(reverse_format,3,'.');
end
reverse_again = reverse(format2);
set(handles.total_seluruh,'String',reverse_again);
guidata(hObject,handles);

function kuantitas2_Callback(hObject, eventdata, handles)
qty = str2double(get(hObject,'String'));
if isnan(qty)
    set(handles.total_bayar,'Enable','off');
    set(handles.pb_tambahbarang,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.total_bayar,'Enable','off');
    set(handles.pb_tambahbarang,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.total_bayar,'Enable','off');
    set(handles.pb_tambahbarang,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
else
    set(handles.total_bayar,'Enable','on');
    set(handles.pb_tambahbarang,'Enable','on');
end
function kuantitas2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function total_bayar_Callback(hObject, eventdata, handles)
l_box = get(handles.listbox1,'string');
qty = str2double(get(hObject,'String'));
nama = get(handles.pembeli,'String');
if isnan(qty)
    set(handles.pb_bayar,'Enable','off');
    set(hObject,'String','');
    errordlg('harus di isi dengan angka','warning','modal');
elseif qty <= 0
    set(handles.pb_bayar,'Enable','off');
    set(hObject,'String','');
    errordlg('isi tidak bisa nol','warning','modal');
elseif isempty(qty)
    set(handles.pb_bayar,'Enable','off');
    errordlg('isi tidak bisa kosong','warning','modal');
elseif isempty(nama)
    errordlg('nama tidak bisa kosong','warning','modal');
elseif isempty(l_box)
    errordlg('Harus ada Barang di daftar order','','modal');
else
    set(handles.pb_bayar,'Enable','on');
end
function total_bayar_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% PUSH BUTTON KONFIRMASI
function konfirmasi_Callback(hObject, eventdata, handles)
list_barang  = get(handles.listbox1,'String');
value_barang = get(handles.listbox1,'Value');
list = length(list_barang);
handles.list = list; %passing ke var global
total_harga = str2double(get(handles.temp_hargatotal,'String'));
set(handles.total_bayar,'Enable','on');
set(handles.pb_bayar,'Enable','on');
set(handles.pembeli,'Enable','on');
% hargaonly = handles.hargaonly;
% qty = str2double(get(handles.kuantitas2,'String'));
% total_harga = qty * hargaonly;
handles.harga_keseluruhan = total_harga; %return variabel ke global
    if isempty(total_harga)
        msgbox('masukkan barang','','modal');
        set(handles.total_seluruh,'string','');
        set(handles.total_bayar,'string','');
        set(handles.pembeli,'string','');
        set(handles.pb_bayar,'Enable','off');
    elseif isnan(total_harga)
        msgbox('masukkan barang','','modal');
        set(handles.total_seluruh,'string','');
        set(handles.total_bayar,'string','');
        set(handles.pb_bayar,'Enable','off');
        set(handles.pembeli,'string','');
    elseif total_harga <= 0
        msgbox('masukkan barang','','modal');
        set(handles.total_seluruh,'string','');
        set(handles.total_bayar,'string','');
        set(handles.pb_bayar,'Enable','off');
        set(handles.pembeli,'string','');
    else
        %tampilkan uang total ke bentuk rupiah string pada textbox
        rupiah = 'Rp. %.f';
        format = sprintf(rupiah,total_harga);
        reverse_format = reverse(format);
        if length(reverse_format) > 13
            format2 = insertAfter(reverse_format,9,'.');
            format2 = insertAfter(format2,6,'.');
            format2 = insertAfter(format2,3,'.');
        elseif length(reverse_format) > 10
            format2 = insertAfter(reverse_format,6,'.');
            format2 = insertAfter(format2,3,'.');
        else
            format2 = insertAfter(reverse_format,3,'.');
        end
        reverse_again = reverse(format2);
        set(handles.total_seluruh,'String',reverse_again);
    end
guidata(hObject,handles);

% PUSH BUTTON BAYAR --- TRANSAKSI
function pb_bayar_Callback(hObject, eventdata, handles)
jumlah_list = handles.list; %ambil var dari global, PB konfirmasi
list_barang = char(get(handles.listbox1,'string'));
inputuang = get(handles.total_bayar,'String');
inputnama = get(handles.pembeli,'String');
if inputuang == ""
    errordlg('Masukkan Jumlah Uang','Peringatan','modal');
elseif inputnama == ""
    errordlg('Masukkan nama','Peringatan','modal');
else
    %cek bayar mencukupi atau tidak
    harga = handles.harga_keseluruhan; %ambil dari var global
    bayar = str2double(get(handles.total_bayar,'String')); %ubah ke bentuk angka(double)
    kembalian = bayar - harga;
    if kembalian < 0
        warndlg('Jumlah Bayar Kurang','peringatan','modal');
    else
        for i = 1:jumlah_list
            %cek stok mencukupi atau tidak ---------------------
            list_barang_temp = list_barang(i,:);
            qty_barang  = str2double(extract(list_barang_temp,digitsPattern));
            qty_barang_temp  = qty_barang(1,1); %jumlah barang ke i
            spasi       = regexp(list_barang_temp,' ');
            barang      = list_barang_temp((spasi + 1) : max(length(list_barang_temp)));

            conn = database('stokproduk','','');
            q  = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
            q2 = sprintf(q,barang);
            q3 = string(table2array(fetch(conn,q2)));
            q4 = 'SELECT jumlah FROM stok WHERE id_barang = %s';
            q5 = sprintf(q4,q3);
            stok = table2array(fetch(conn,q5));
            jumlah_terakhir = stok - qty_barang_temp;
            if jumlah_terakhir < 0
                warndlg('Stok tidak mencukupi','peringatan','modal');
            else
                data = table(jumlah_terakhir,'VariableNames',{'jumlah'});
                query1 = 'WHERE id_barang = %s';
                clause = sprintf(query1,q3);
                update(conn,'stok',{'jumlah'},data,clause); % --- UPDATE JUMLAH PRODUK per ITEM ---
                set(handles.stok_sekarang,'String',jumlah_terakhir);

                %----- INSERT NAMA pembeli ke TABLE PEMBELI -----
                nama = get(handles.pembeli,'String');
                tanggal_beli = datetime('now');
                tanggal_beli.Format = 'MM-dd-yyyy';

                data_nama = table(string(nama),string(tanggal_beli),'VariableNames',{'nama_pembeli' 'tanggal_beli'});
                sqlwrite(conn,'pembeli',data_nama);
                disp(data_nama)

                %----- INSERT TABLE TRANSAKSI -----
                panjang_list  = size(list_barang);
                panjang_list2 = panjang_list(:,1);
%                 pilih = handles.pilih; %ambil var global
%                 cla1 = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
%                 clause1 = sprintf(cla1,string(pilih));
%                 id_barang = table2array(fetch(conn,clause1));
                id_barang = str2double(q3);
                tgl_sekarang = datetime('now');
                tgl_sekarang.Format = 'MM-dd-yyyy';
                cla2 = 'SELECT id_pembeli FROM pembeli WHERE nama_pembeli = ''%s''';
                clause2 = sprintf(cla2,string(nama));
                id_pembeli = table2array(fetch(conn,clause2));
                data_transaksi = table(id_barang,string(tgl_sekarang),max(id_pembeli),'VariableNames',{'id_barang' 'tanggal' 'id_pembeli'});
                sqlwrite(conn,'transaksi',data_transaksi);
                disp(data_transaksi)

                %----- INSERT TABLE PEMBAYARAN -----
                % jika 1 atau lebih barang
                if panjang_list2 == 1
                    disp('con 1 cuma 1')
                    cla3 = 'SELECT id_transaksi FROM transaksi WHERE id_pembeli = %d';
                    clause3 = sprintf(cla3,max(id_pembeli));
                    id_transaksi = table2array(fetch(conn,clause3));
                    data_pembayaran = table(harga,qty_barang_temp,id_transaksi,'VariableNames',{'total_bayar' 'banyak_barang' 'id_transaksi'});
                    sqlwrite(conn,'pembayaran',data_pembayaran);
                    disp(data_pembayaran)

                    rupiah = sprintf('Rp. %.f',kembalian);
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
                    set(handles.total_kembali,'String',reverse(format));
                else
                    disp('con lebih dari 1')
                    
                    h1 = 'SELECT harga_jual FROM stok WHERE id_barang = %d';
                    h2 = sprintf(h1,str2double(q3));
                    h3 = table2array(fetch(conn,h2));
                    harga_m = qty_barang_temp * h3;
                    
                    cla3 = 'SELECT id_transaksi FROM transaksi WHERE id_pembeli = %d';
                    clause3 = sprintf(cla3,max(id_pembeli));
                    id_transaksi = table2array(fetch(conn,clause3));
                    data_pembayaran = table(harga_m,qty_barang_temp,id_transaksi,'VariableNames',{'total_bayar' 'banyak_barang' 'id_transaksi'});
                    sqlwrite(conn,'pembayaran',data_pembayaran);
                    disp(data_pembayaran)

                    rupiah = sprintf('Rp. %.f',kembalian);
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
                    set(handles.total_kembali,'String',reverse(format));
                end
            end
        end
    end
end

% PUSH BUTTON LOG OUT
function logout_Callback(hObject, eventdata, handles)
close;
form_login;

% POP-UP MENU KANAN ATAS
function pop_setting_Callback(hObject, eventdata, handles)
konten = get(hObject,'Value');
nama = get(hObject,'String');
pilih = nama(konten);
if konten == 2
    form_ubahstok
    close(form_penjualan);
elseif konten == 3
    ubah_pengguna
    close(form_penjualan);
elseif konten == 4
    form_laporan
%     close(form_penjualan);
end
function pop_setting_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% POP-UP BARANG / PRODUK
function pop_produk3_Callback(hObject, eventdata, handles)
conn = database('stokproduk','','');
konten = get(hObject,'Value');
handles.konten = konten; %passing var ke global
nama = get(hObject,'String');
pilih = nama(konten);
handles.pilih = pilih; %passing var ke global

set(handles.pb_tambahbarang,'Enable','off');
set(handles.konfirmasi,'Enable','on');
set(handles.kuantitas2,'Enable','on');
set(handles.kuantitas2,'String','');
set(handles.total_bayar,'String','');
set(handles.total_seluruh,'String','');
set(handles.total_kembali,'String','');
set(handles.pembeli,'string','');

%cek barang ganda di listbox
produk_p = string(pilih);
list_barang  = cellstr(get(handles.listbox1,'String'));
sama = nonzeros(count(list_barang,produk_p));
sama2 = find(1 == sama);
if min(sama2) == 1
    set(handles.detail_merk,'string','');
    set(handles.detail_harga,'string','');
    set(handles.stok_sekarang,'string','');
    warndlg('Hapus barang yang ada terlebih dahulu','Barang sudah ditambahkan','modal');
else
    qq1 = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
    clause = sprintf(qq1,string(pilih));
    qwe = string(table2array(fetch(conn,clause)));
    set(handles.detail_merk,'String',pilih); %tampilkan nama barang

    n1 = 'SELECT harga_jual FROM stok WHERE id_barang = %s';
    n2 = num2str(konten);
    query_nama = sprintf(n1,qwe);
    produk = table2array(fetch(conn,query_nama));
    handles.hargaonly = produk; %passing harga ke variabel global
    rupiah = sprintf('Rp. %.f',produk);
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
    set(handles.detail_harga,'String',reverse(format)); %tampilkan harga barang
    j1 = 'SELECT `jumlah` FROM stok WHERE id_barang = %s';
    j2 = num2str(konten);
    query_jumlah = sprintf(j1,qwe);
    jumlah = table2array(fetch(conn,query_jumlah));
    set(handles.stok_sekarang,'String',jumlah);
    c1 = 'WHERE id_barang = %s';
    c2 = num2str(konten);
    clause2 = sprintf(c1,c2);
    handles.clause = clause2;
end
guidata(hObject,handles);

function pop_produk3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
conn = database('stokproduk','','');
query = 'SELECT barang FROM stok';
data = string(table2array(fetch(conn,query)));
set(hObject,'String',data);

% ERROR HANDLING TEXT BOX PEMBELI
function pembeli_Callback(hObject, eventdata, handles)
nama = get(hObject,'string');
if isempty(nama)
    errordlg('nama tidak bisa kosong','','modal');
%     set(handles.pb_bayar,'Enable','off');
else
    set(handles.total_bayar,'Enable','on');
end
function pembeli_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- DAFTAR KERANGJANG (LISTBOX)
function listbox1_Callback(hObject, eventdata, handles)
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- PUSH BUTTON HAPUS BARANG DARI LISTBOX
function pb_hapusbarang_Callback(hObject, eventdata, handles)
set(handles.total_bayar,'Enable','off');
set(handles.pembeli,'Enable','off');
set(handles.pb_bayar,'Enable','off');
set(handles.pembeli,'String','');
set(handles.total_bayar,'String','');
set(handles.total_seluruh,'String','');
list_barang  = cellstr(get(handles.listbox1,'String'));
value_barang = get(handles.listbox1,'Value');

if isempty(list_barang)
    msgbox('Barang sudah kosong','','modal');
else
    %pengurangan kumulatif harga barang
    list   = char(list_barang(value_barang));
    qty    = str2double(extract(list,digitsPattern));
    qty2   = qty(1,1); %jumlah barang only
    spasi  = regexp(list,' ');
    barang = list((spasi + 1):max(length(list))); % nama barang only

    conn = database('stokproduk','','');
    q1 = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
    q2 = sprintf(q1,barang);
    q3 = string(table2array(fetch(conn,q2)));
    n1 = 'SELECT harga_jual FROM stok WHERE id_barang = %s';
    n2 = sprintf(n1,q3);
    harga = table2array(fetch(conn,n2));
    harga_temp = str2double(get(handles.temp_hargatotal,'string')); %ambil harga item dari temp untuk adding harga kumulatif
    harga2 = harga_temp - (qty2 * harga); %hapus harga
    set(handles.temp_hargatotal,'string',harga2); % update harga di temp harga total
    %hapus barang di listbox
    if isempty(list_barang)
        msgbox('tidak ada barang terpilih','','modal');
    else
        list_barang(value_barang) = [];
        set(handles.listbox1,'value',1); %menghindari error value dan string listbox
        set(handles.listbox1,'String',list_barang);
    end
end


% --- PUSH BUTTON TAMBAH BARANG KE LISTBOX.
function pb_tambahbarang_Callback(hObject, eventdata, handles)
%cek barang ganda di listbox saat menekan tombol tambah barang
produk = handles.pilih; %ambil dari var global - popup barang
produk = string(produk);
list_barang  = cellstr(get(handles.listbox1,'String'));
sama = nonzeros(count(list_barang,produk));
sama2 = find(1 == sama);
if min(sama2) == 1
    warndlg('Hapus barang yang ada terlebih dahulu','Barang sudah ditambahkan','modal');
else
    %cek kuantitas cukup / tidak
    qty   = get(handles.kuantitas2,'string');
    qty_n = get(handles.stok_sekarang,'string');
    qty_r = str2double(qty_n) - str2double(qty);
    if qty_r < 0
        warndlg('Stok tidak mencukupi','','modal');
    else
        set(handles.stok_sekarang,'string',qty_r);
        %penambahan kumulatif harga barang
        jumlah       = get(handles.kuantitas2,'string');
        qty          = str2double(jumlah);
        harga_produk = handles.hargaonly;
        total_harga  = qty * harga_produk;
        handles.total_harga = total_harga; %passing ke variabel global, ke konfirmasi
        harga_temp   = str2double(get(handles.temp_hargatotal,'string')); %ambil harga item dari temp untuk adding harga kumulatif
        if isnan(harga_temp)
            set(handles.temp_hargatotal,'string',total_harga); %taruh harga item ke temp
        elseif harga_temp <= 0
            set(handles.temp_hargatotal,'string',total_harga); %taruh harga item ke temp
        else
            harga_temp = harga_temp + total_harga;
            set(handles.temp_hargatotal,'string',harga_temp);
        end

        % penambahan barang ke listbox
        pilih  = append(jumlah,'x ',produk);
        current_list = get(handles.listbox1,'string');
        if isempty(current_list)
            current_list = pilih;
        else
            current_list = cellstr(get(handles.listbox1,'string'));
            current_list{end+1} = string(pilih);
        end
        set(handles.listbox1,'String',current_list);
    end
end
guidata(hObject,handles);


% PUSH BUTTTON KELUAR / EXIT
function pb_keluar_Callback(hObject, eventdata, handles)
selection = questdlg(['Anda Yakin Ingin Menutup Aplikasi',' ?'],...
['Tutup Aplikasi?' '' '...'],...
'Ya','Batal','Ya');
if strcmp(selection,'Batal')
    return
end
close;
