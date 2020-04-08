/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     8/4/2020 3:54:49 PM                          */
/*==============================================================*/


alter table DangNhap 
   drop foreign key FK_DANGNHAP_DANGNHAP_KHACHTRU;

alter table DangNhap 
   drop foreign key FK_DANGNHAP_DANGNHAP2_NGUOIDUN;

alter table KhachDatPhong 
   drop foreign key FK_KHACHDAT_KHACHDATP_KHACHTRU;

alter table KhachDatPhong 
   drop foreign key FK_KHACHDAT_KHACHDATP_PHONG;

alter table KhachSan 
   drop foreign key FK_KHACHSAN_FK_KHACHS_KHUVUC;

alter table NDDatPhong 
   drop foreign key FK_NDDATPHO_NDDATPHON_NGUOIDUN;

alter table NDDatPhong 
   drop foreign key FK_NDDATPHO_NDDATPHON_PHONG;

alter table Phong 
   drop foreign key FK_PHONG_FK_PHONG__KHACHSAN;

alter table Phong 
   drop foreign key FK_PHONG_FK_PHONG__LOAIPHON;


alter table DangNhap 
   drop foreign key FK_DANGNHAP_DANGNHAP_KHACHTRU;

alter table DangNhap 
   drop foreign key FK_DANGNHAP_DANGNHAP2_NGUOIDUN;

drop table if exists DangNhap;


alter table KhachDatPhong 
   drop foreign key FK_KHACHDAT_KHACHDATP_KHACHTRU;

alter table KhachDatPhong 
   drop foreign key FK_KHACHDAT_KHACHDATP_PHONG;

drop table if exists KhachDatPhong;

drop table if exists KhachHang;


alter table KhachSan 
   drop foreign key FK_KHACHSAN_FK_KHACHS_KHUVUC;

drop table if exists KhachSan;

drop table if exists KhachTruyCap;

drop table if exists KhuVuc;

drop table if exists LoaiPhong;


alter table NDDatPhong 
   drop foreign key FK_NDDATPHO_NDDATPHON_NGUOIDUN;

alter table NDDatPhong 
   drop foreign key FK_NDDATPHO_NDDATPHON_PHONG;

drop table if exists NDDatPhong;

drop table if exists NguoiDung;


alter table Phong 
   drop foreign key FK_PHONG_FK_PHONG__KHACHSAN;

alter table Phong 
   drop foreign key FK_PHONG_FK_PHONG__LOAIPHON;

drop table if exists Phong;

/*==============================================================*/
/* Table: DangNhap                                              */
/*==============================================================*/
create table DangNhap
(
   maTruyCap            char(20) not null  comment '',
   maSo_ND              char(20) not null  comment '',
   primary key (maTruyCap, maSo_ND)
);

/*==============================================================*/
/* Table: KhachDatPhong                                         */
/*==============================================================*/
create table KhachDatPhong
(
   maTruyCap            char(20) not null  comment '',
   maPhong              char(20) not null  comment '',
   ngayDat              datetime  comment '',
   thoiGianBatDau       datetime  comment '',
   thoiGianKetThuc      datetime  comment '',
   tongChiPhi           int  comment '',
   hinhThuc             varchar(20)  comment '',
   hoTen_KTC            varchar(50)  comment '',
   email_KTC            varchar(50)  comment '',
   SDT_KTC              numeric(10,0)  comment '',
   tinhThanhPho_KTC     varchar(50)  comment '',
   primary key (maTruyCap, maPhong)
);

/*==============================================================*/
/* Table: KhachHang                                             */
/*==============================================================*/
create table KhachHang
(
   maSo_KH              char(20) not null  comment '',
   hoTen_KH             varchar(50)  comment '',
   email_KH             varchar(50) not null  comment '',
   SDT_KH               numeric(10,0)  comment '',
   tinhThanhPho_KH      varchar(50)  comment '',
   primary key (maSo_KH)
);

/*==============================================================*/
/* Table: KhachSan                                              */
/*==============================================================*/
create table KhachSan
(
   maKhachSan           char(20) not null  comment '',
   maKhuVuc             char(20) not null  comment '',
   tenKhachSan          varchar(100) not null  comment '',
   diaChi_KH            varchar(100) not null  comment '',
   primary key (maKhachSan)
);

/*==============================================================*/
/* Table: KhachTruyCap                                          */
/*==============================================================*/
create table KhachTruyCap
(
   maTruyCap            char(20) not null  comment '',
   primary key (maTruyCap)
);

/*==============================================================*/
/* Table: KhuVuc                                                */
/*==============================================================*/
create table KhuVuc
(
   maKhuVuc             char(20) not null  comment '',
   tenKhuVuc            varchar(100) not null  comment '',
   primary key (maKhuVuc)
);

/*==============================================================*/
/* Table: LoaiPhong                                             */
/*==============================================================*/
create table LoaiPhong
(
   maLoaiPhong          char(20) not null  comment '',
   moTa                 varchar(8000)  comment '',
   dienTich             int  comment '',
   phongConLai          int  comment '',
   primary key (maLoaiPhong)
);

/*==============================================================*/
/* Table: NDDatPhong                                            */
/*==============================================================*/
create table NDDatPhong
(
   maSo_ND              char(20) not null  comment '',
   maPhong              char(20) not null  comment '',
   ngayDat              datetime  comment '',
   thoiGianBatDau       datetime  comment '',
   thoiGianKetThuc      datetime  comment '',
   tongChiPhi           int  comment '',
   hinhThuc             varchar(20)  comment '',
   primary key (maSo_ND, maPhong)
);

/*==============================================================*/
/* Table: NguoiDung                                             */
/*==============================================================*/
create table NguoiDung
(
   maSo_ND              char(20) not null  comment '',
   hoTen_ND             varchar(50)  comment '',
   tenDanhNhap          varchar(50) not null  comment '',
   matKhau_ND           varchar(50) not null  comment '',
   email_ND             varchar(50) not null  comment '',
   SDT_ND               numeric(10,0)  comment '',
   quyenQuanTri         blob  comment '',
   diaChi_ND            varchar(100)  comment '',
   timhThanhPho_ND      varchar(50)  comment '',
   primary key (maSo_ND)
);

/*==============================================================*/
/* Table: Phong                                                 */
/*==============================================================*/
create table Phong
(
   maPhong              char(20) not null  comment '',
   maLoaiPhong          char(20) not null  comment '',
   maKhachSan           char(20) not null  comment '',
   primary key (maPhong)
);

alter table DangNhap add constraint FK_DANGNHAP_DANGNHAP_KHACHTRU foreign key (maTruyCap)
      references KhachTruyCap (maTruyCap);

alter table DangNhap add constraint FK_DANGNHAP_DANGNHAP2_NGUOIDUN foreign key (maSo_ND)
      references NguoiDung (maSo_ND);

alter table KhachDatPhong add constraint FK_KHACHDAT_KHACHDATP_KHACHTRU foreign key (maTruyCap)
      references KhachTruyCap (maTruyCap);

alter table KhachDatPhong add constraint FK_KHACHDAT_KHACHDATP_PHONG foreign key (maPhong)
      references Phong (maPhong);

alter table KhachSan add constraint FK_KHACHSAN_FK_KHACHS_KHUVUC foreign key (maKhuVuc)
      references KhuVuc (maKhuVuc);

alter table NDDatPhong add constraint FK_NDDATPHO_NDDATPHON_NGUOIDUN foreign key (maSo_ND)
      references NguoiDung (maSo_ND);

alter table NDDatPhong add constraint FK_NDDATPHO_NDDATPHON_PHONG foreign key (maPhong)
      references Phong (maPhong);

alter table Phong add constraint FK_PHONG_FK_PHONG__KHACHSAN foreign key (maKhachSan)
      references KhachSan (maKhachSan);

alter table Phong add constraint FK_PHONG_FK_PHONG__LOAIPHON foreign key (maLoaiPhong)
      references LoaiPhong (maLoaiPhong);

