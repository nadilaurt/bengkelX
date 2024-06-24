function varargout = form_laporan(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_laporan_OpeningFcn, ...
                   'gui_OutputFcn',  @form_laporan_OutputFcn, ...
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
function form_laporan_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
% full = 'C:\bg\form_laporan.jpg';
% bg = imread(full); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'bottom');
guidata(hObject, handles);
set(handles.pb_per_barang,'Enable','off');

function varargout = form_laporan_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% BUTTON DATE1
function date1_Callback(hObject, eventdata, handles)
inn = datetime('now');
inn.Format = 'MM-dd-yyyy';
asd = tanggal(inn);
set(handles.dateout1,'String',string(asd));

% BUTTON DATE2
function date2_Callback(hObject, eventdata, handles)
inn = datetime('now');
inn.Format = 'MM-dd-yyyy';
asd = tanggal(inn);
set(handles.dateout2,'String',string(asd));

% BUTTON LAPORAN.
function pb_laporan_rentang_Callback(hObject, eventdata, handles)
makeDOMCompilable();
import mlreportgen.report.*
import mlreportgen.dom.*
date1 = get(handles.dateout1,'String');
date2 = get(handles.dateout2,'String');
conn = database('stokproduk','','');
if isempty(date1)
    errordlg('Masukkan Tanggal Awal','','modal');
elseif isempty(date2)
    errordlg('Masukkan tanggal Akhir','','modal');
else
    %query untuk laba
    query_m = ['SELECT pembayaran.banyak_barang ', ...
                'FROM ( pembayaran INNER JOIN transaksi ', ...
                'ON pembayaran.id_transaksi = transaksi.id_transaksi) ', ...
                'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_m2 = sprintf(query_m,date1,date2);
    table_m = table2array(fetch(conn,query_m2));
    query_p = ['SELECT stok.harga_asli ', ...
                'FROM ( stok INNER JOIN transaksi ', ...
                'ON stok.id_barang = transaksi.id_barang) ', ...
                'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_p2 = sprintf(query_p,date1,date2);
    table_p = table2array(fetch(conn,query_p2));
    query_j = ['SELECT stok.harga_jual ', ...
                'FROM ( stok INNER JOIN transaksi ', ...
                'ON stok.id_barang = transaksi.id_barang) ', ...
                'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_j2 = sprintf(query_j,date1,date2);
    table_j  = table2array(fetch(conn,query_j2));
    h_a      = sum(table_m .* table_p);
    h_j      = sum(table_m .* table_j);
    total    = h_j - h_a;
    if sign(total) == 1
        rupiah = sprintf('Rp. %.f',total);
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
    else
        total = total * -1;
        rupiah = sprintf('-Rp. %.f',total);
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
    end
    laba = sprintf('Profit = %s',string(reverse(format)));
        
    %query untuk laporan
    query = ['SELECT stok.barang, pembeli.nama_pembeli, ', ...
            'pembayaran.banyak_barang, pembayaran.total_bayar, transaksi.tanggal ', ...
            'FROM ( ( ( pembayaran  ', ...
            'INNER JOIN transaksi ON pembayaran.id_transaksi = transaksi.id_transaksi) ', ...
            'INNER JOIN pembeli ON transaksi.id_pembeli = pembeli.id_pembeli)  ', ...
            'INNER JOIN stok ON transaksi.id_barang = stok.id_barang)  ', ...
            'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_f = sprintf(query,date1,date2);
    data = fetch(conn,query_f);
    if isempty(data)
        msgbox('Entry tidak ditemukan','modal');
        return
    end
    rpt = Report("C:\Laporan","pdf");
    open(rpt);
    pageLayoutObj = PDFPageLayout;
    pageLayoutObj.PageSize.Orientation = "portrait";
    pageLayoutObj.PageSize.Height = "1150px";
    pageLayoutObj.PageSize.Width = "800px";
    pageLayoutObj.PageMargins.Top = "2px";
    pageLayoutObj.PageMargins.Bottom = "2px";
    pageLayoutObj.PageMargins.Left = "70px";
    pageLayoutObj.PageMargins.Right = "30px";
    heading = Heading(1,"Laporan Penjualan");
    add(rpt,pageLayoutObj);
    add(rpt,heading);
    add(rpt,' ');
    add(rpt,data);
    add(rpt,' ');
    add(rpt,laba);
    close(rpt);
    rptview(rpt);
end

% BUTTON PENJUALAN PER BARANG.
function pb_per_barang_Callback(hObject, eventdata, handles)
makeDOMCompilable();
import mlreportgen.report.*
import mlreportgen.dom.*

conn = database('stokproduk','','');
value = handles.pilih;
query_barang  = 'SELECT id_barang FROM stok WHERE barang = ''%s''';
query_barang2 = sprintf(query_barang,string(value));
query_b_final = table2array(fetch(conn,query_barang2));
date1 = get(handles.dateout1,'String');
date2 = get(handles.dateout2,'String');

if isempty(date1)
    errordlg('Masukkan Tanggal Awal','','modal');
elseif isempty(date2)
    errordlg('Masukkan tanggal Akhir','','modal');
else
    %query untuk laba
    query_m = ['SELECT pembayaran.banyak_barang ', ...
                'FROM (( pembayaran INNER JOIN transaksi ', ...
                'ON pembayaran.id_transaksi = transaksi.id_transaksi) ', ...
                'INNER JOIN stok ON transaksi.id_barang = stok.id_barang) ', ...
                'WHERE stok.id_barang = %d AND transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_m2 = sprintf(query_m,query_b_final,date1,date2);
    table_m = table2array(fetch(conn,query_m2));
    query_p = ['SELECT stok.harga_asli ', ...
                'FROM ( stok INNER JOIN transaksi ', ...
                'ON stok.id_barang = transaksi.id_barang) ', ...
                'WHERE stok.id_barang = %d AND transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_p2 = sprintf(query_p,query_b_final,date1,date2);
    table_p = table2array(fetch(conn,query_p2));
    query_j = ['SELECT stok.harga_jual ', ...
                'FROM ( stok INNER JOIN transaksi ', ...
                'ON stok.id_barang = transaksi.id_barang) ', ...
                'WHERE stok.id_barang = %d AND transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_j2 = sprintf(query_j,query_b_final,date1,date2);
    table_j  = table2array(fetch(conn,query_j2));
    h_a      = sum(table_m .* table_p);
    h_j      = sum(table_m .* table_j);
    total    = h_j - h_a;
    if sign(total) == 1
        rupiah = sprintf('Rp. %.f',total);
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
    else
        total = total * -1;
        rupiah = sprintf('-Rp. %.f',total);
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
    end
    laba = sprintf('Profit = %s',string(reverse(format)));
         
    %query untuk laporan
    query = ['SELECT stok.id_barang, ', ...
        'stok.barang, ', ...
        'stok.harga_asli, ', ...
        'stok.harga_jual, ', ...
        'pembayaran.banyak_barang, ', ...
        'pembayaran.total_bayar, ', ...
        'transaksi.id_transaksi, ', ...
        'transaksi.tanggal ', ...
        'FROM ( ( stok ', ...
        'INNER JOIN transaksi ', ...
        'ON stok.id_barang = transaksi.id_barang) ', ...
        'INNER JOIN pembayaran ', ...
        'ON transaksi.id_transaksi = pembayaran.id_transaksi) ', ...
        'WHERE stok.id_barang = %d AND transaksi.tanggal BETWEEN ''%s'' AND ''%s'''];
    query_f = sprintf(query,query_b_final,date1,date2);
    data = fetch(conn,query_f);
    if isempty(data)
        msgbox('Entry tidak ditemukan','modal');
        return
    end
    
    rpt = Report("C:\Laporan per barang","pdf");
    open(rpt);
    pageLayoutObj = PDFPageLayout;
    pageLayoutObj.PageSize.Orientation = "landscape";
    pageLayoutObj.PageSize.Height = "800px";
    pageLayoutObj.PageSize.Width = "1150px";
    pageLayoutObj.PageMargins.Top = "2px";
    pageLayoutObj.PageMargins.Bottom = "2px";
    pageLayoutObj.PageMargins.Left = "70px";
    pageLayoutObj.PageMargins.Right = "30px";
    heading = Heading(1,"Laporan per barang");
    add(rpt,pageLayoutObj);
    add(rpt,heading);
    add(rpt,' ');
    add(rpt,data);
    add(rpt,' ');
    add(rpt,' ');
    add(rpt,laba);
    close(rpt);
    rptview(rpt);
end

% PUSH BUTTON LAPORAN SEMUA BARANG.
function pb_barang_all_Callback(hObject, eventdata, handles)
makeDOMCompilable();
import mlreportgen.report.*
import mlreportgen.dom.*
date1 = get(handles.dateout1,'String');
date2 = get(handles.dateout2,'String');
conn = database('stokproduk','','');
if isempty(date1)
    errordlg('Masukkan Tanggal Awal','','modal');
elseif isempty(date2)
    errordlg('Masukkan tanggal Akhir','','modal');
else
    %query untuk laba
    query_m = ['SELECT pembayaran.banyak_barang ', ...
                'FROM ( pembayaran INNER JOIN transaksi ', ...
                'ON pembayaran.id_transaksi = transaksi.id_transaksi) ', ...
                'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_m2 = sprintf(query_m,date1,date2);
    table_m = table2array(fetch(conn,query_m2));
    query_p = ['SELECT stok.harga_asli ', ...
                'FROM ( stok INNER JOIN transaksi ', ...
                'ON stok.id_barang = transaksi.id_barang) ', ...
                'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_p2 = sprintf(query_p,date1,date2);
    table_p = table2array(fetch(conn,query_p2));
    query_j = ['SELECT stok.harga_jual ', ...
                'FROM ( stok INNER JOIN transaksi ', ...
                'ON stok.id_barang = transaksi.id_barang) ', ...
                'WHERE transaksi.tanggal BETWEEN  ''%s'' AND ''%s'' '];
    query_j2 = sprintf(query_j,date1,date2);
    table_j  = table2array(fetch(conn,query_j2));
    h_a      = sum(table_m .* table_p);
    h_j      = sum(table_m .* table_j);
    total    = h_j - h_a;
    if sign(total) == 1
        rupiah = sprintf('Rp. %.f',total);
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
    else
        total = total * -1;
        rupiah = sprintf('-Rp. %.f',total);
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
    end
    laba = sprintf('Profit = %s',string(reverse(format)));
        
    %query untuk laporan
    query = ['SELECT stok.id_barang, ', ...
        'stok.barang, ', ...
        'stok.harga_asli, ', ...
        'stok.harga_jual, ', ...
        'pembayaran.banyak_barang, ', ...
        'pembayaran.total_bayar, ', ...
        'transaksi.id_transaksi, ', ...
        'transaksi.tanggal ', ...
        'FROM ( ( stok ', ...
        'INNER JOIN transaksi ', ...
        'ON stok.id_barang = transaksi.id_barang) ', ...
        'INNER JOIN pembayaran ', ...
        'ON transaksi.id_transaksi = pembayaran.id_transaksi) ', ...
        'WHERE transaksi.tanggal BETWEEN ''%s'' AND ''%s'''];
    query_f = sprintf(query,date1,date2);
    data = fetch(conn,query_f);
    if isempty(data)
        msgbox('Entry tidak ditemukan','modal');
        return
    end
    rpt = Report("C:\Laporan Semua Barang","pdf");
    open(rpt);
    pageLayoutObj = PDFPageLayout;
    pageLayoutObj.PageSize.Orientation = "landscape";
    pageLayoutObj.PageSize.Height = "800px";
    pageLayoutObj.PageSize.Width = "1150px";
    pageLayoutObj.PageMargins.Top = "2px";
    pageLayoutObj.PageMargins.Bottom = "2px";
    pageLayoutObj.PageMargins.Left = "70px";
    pageLayoutObj.PageMargins.Right = "30px";
    heading = Heading(1,"Laporan Semua Barang");
    add(rpt,pageLayoutObj);
    add(rpt,heading);
    add(rpt,' ');
    add(rpt,data);
    add(rpt,' ');
    add(rpt,laba);
    close(rpt);
    rptview(rpt);
end

% PUSH BUTTON LAPORAN BARANG MASUK.
function pb_barang_masuk_Callback(hObject, eventdata, handles)
makeDOMCompilable();
import mlreportgen.report.*
import mlreportgen.dom.*

conn = database('stokproduk','','');

date1 = get(handles.dateout1,'String');
date2 = get(handles.dateout2,'String');

if isempty(date1)
    errordlg('Masukkan Tanggal Awal','','modal');
elseif isempty(date2)
    errordlg('Masukkan tanggal Akhir','','modal');
else
   
    %query untuk laporan
    query = ['SELECT pembelian.id_pembelian, ', ...
            'stok.barang, ', ...
            'distributor.nama, ', ...
            'pembelian.kuantitas_beli, ', ...
            'pembelian.harga_satuan, ', ...
            'pembelian.subtotal, ', ...
            'pembelian.tgl_pembelian ', ...
            'FROM ( ( stok ', ...
            'INNER JOIN pembelian ', ...
            'ON stok.id_barang = pembelian.id_barang) ', ...
            'INNER JOIN distributor ', ...
            'ON pembelian.id_distributor = distributor.id_distributor) ', ...
            'WHERE pembelian.tgl_pembelian BETWEEN ''%s'' AND ''%s'''];
    query_f = sprintf(query,date1,date2);
    data = fetch(conn,query_f);
    if isempty(data)
        msgbox('Entry tidak ditemukan','modal');
        return
    end

    rpt = Report("C:\Laporan barang masuk","pdf");
    open(rpt);
    pageLayoutObj = PDFPageLayout;
    pageLayoutObj.PageSize.Orientation = "landscape";
    pageLayoutObj.PageSize.Height = "700px";
    pageLayoutObj.PageSize.Width = "1200px";
    pageLayoutObj.PageMargins.Top = "2px";
    pageLayoutObj.PageMargins.Bottom = "2px";
    pageLayoutObj.PageMargins.Left = "70px";
    pageLayoutObj.PageMargins.Right = "30px";
    heading = Heading(1,"Laporan barang masuk");
    add(rpt,pageLayoutObj);
    add(rpt,heading);
    add(rpt,' ');
    add(rpt,data);
    add(rpt,' ');
    add(rpt,' ');
    close(rpt);
    rptview(rpt);
end

% BUTTON LAPORAN BARANG.
function pb_daftar_barang_Callback(hObject, eventdata, handles)
makeDOMCompilable();
conn = database('stokproduk','','');
query = 'SELECT * FROM stok';
data = fetch(conn,query);

import mlreportgen.report.*
import mlreportgen.dom.*

rpt = Report("C:\Daftar Barang yang dijual","pdf");
open(rpt);
pageLayoutObj = PDFPageLayout;
pageLayoutObj.PageSize.Orientation = "portrait";
pageLayoutObj.PageSize.Height = "1150px";
pageLayoutObj.PageSize.Width = "800px";
pageLayoutObj.PageMargins.Top = "2px";
pageLayoutObj.PageMargins.Bottom = "2px";
pageLayoutObj.PageMargins.Left = "100px";
pageLayoutObj.PageMargins.Right = "30px";
heading = Heading(1,"Barang Jualan Aktif");
add(rpt,pageLayoutObj);
add(rpt,heading);
add(rpt,' ');
add(rpt,data);
close(rpt);
rptview(rpt);


% PUSH BUTTON DAFTAR DISTRIBUTOR.
function pb_dist_Callback(hObject, eventdata, handles)
makeDOMCompilable();
conn = database('stokproduk','','');
query = 'SELECT * FROM distributor';
data = fetch(conn,query);

import mlreportgen.report.*
import mlreportgen.dom.*

rpt = Report("C:\Daftar Distributor","pdf");
open(rpt);
pageLayoutObj = PDFPageLayout;
pageLayoutObj.PageSize.Orientation = "landscape";
pageLayoutObj.PageSize.Height = "700px";
pageLayoutObj.PageSize.Width = "1000px";
pageLayoutObj.PageMargins.Top = "2px";
pageLayoutObj.PageMargins.Bottom = "2px";
pageLayoutObj.PageMargins.Left = "100px";
pageLayoutObj.PageMargins.Right = "30px";
heading = Heading(1,"Distributor");
add(rpt,pageLayoutObj);
add(rpt,heading);
add(rpt,' ');
add(rpt,data);
close(rpt);
rptview(rpt);


% POP UP BARANG.
function pop_barang_Callback(hObject, eventdata, handles)
set(handles.pb_per_barang,'Enable','on');
konten = get(hObject,'Value');
str_line = get(hObject,'String');
pilih = str_line(get(hObject,'Value'));

handles.konten = konten;
handles.pilih = pilih;
guidata(hObject,handles);

function pop_barang_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
conn = database('stokproduk','','');
query = 'SELECT barang FROM stok';
data = string(table2array(fetch(conn,query)));
set(hObject,'String',data);
