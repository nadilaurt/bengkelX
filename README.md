
REQUIREMENTS:
1. matlab v2019. kompatibel dengan versi matlab 2019 sampai versi terakhir. dengan installan minimal package berikut :
      - MATLAB
      - Database toolbox
      - Matlab Compiler
      - Matlab compiler SDK
      - Matlab Report Generator
      
2. MS office Access Database 2016 keatas.
  
3. Setting ODBC data source Administrator 64-bit driver :
      - tambahkan data source MS access driver dengan nama "login" tanpa kutip dan browse/pilih file "credentials.accdb" yang ada di direktori
      - tambahkan data source MS access driver dengan nama "stokproduk" tanpa kutip dan browse/pilih file "stok barang.accdb" yang ada di direktori


* terdapat dua file MS Access Database yaitu "credentials.accdb" sebagai database login pengguna dan "stok barang.accdb" sebagai data-data detail barang.
* project ini dapat langsung run pada tiap file berekstensi ".m" pada matlab.
* untuk build aplikasi, gunakan command "deploytool" pada command windows dan memilih file "form_login.m" sebagai main file agar ketika dieksekusi yang muncul duluan adalah form login untuk mengisi id pengguna.
