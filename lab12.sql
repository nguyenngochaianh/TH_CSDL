Create table tlbChucvu(
	MaCV nvarchar(2) primary key,
	TenCV nvarchar(30)
);

Create table tblNhanvien(
	MaNV nvarchar(4)primary key,
	MaCV nvarchar(2),
	TenNV nvarchar(30),
	NgaySinh datetime,
	LuongCanBan float,
	NgayCong int,
	PhuCap float
	FOREIGN KEY (MaCV) REFERENCES tlbChucvu(MaCV)
);


insert into tlbChucvu
values
('BV',N'Bảo Vệ'),
('GD',N'Giám Đốc'),
('HC',N'Hành Chính'),
('KT',N'Kế Toán'),
('TQ',N'Thủ Quỷ'),
('VS',N'Vệ sĩ')

insert into tblNhanvien
values
('NV01',N'GD',N'Nguyễn Văn An','1977-12-12','700000','25','500000'),
('NV02',N'BV',N'Bùi Văn Tí','1978-10-10','400000','24','100000'),
('NV03',N'KT',N'Trần Thanh Nhật','1977-9-9','600000','26','400000'),
('NV04',N'VS',N'Nguyễn Thị Út','1980-10-10','300000','26','300000'),
('NV05',N'HC',N'Lê Thị Hà','1979-10-10','500000','27','200000')


--Yeu Cau:
--a
CREATE PROCEDURE SP_Them_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM tlbChucvu WHERE MaCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap);
    SELECT 'Thêm nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể thêm nhân viên.' AS ThongBao;
  END
END


--b
CREATE PROCEDURE SP_CapNhat_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM tlbChucvu WHERE MaCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    UPDATE tblNhanVien
    SET MaCV = @MaCV, TenNV = @TenNV, NgaySinh = @NgaySinh, LuongCanBan = @LuongCanBan, NgayCong = @NgayCong, PhuCap = @PhuCap
    WHERE MaNV = @MaNV;
    SELECT 'Cập nhật nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể cập nhật nhân viên.' AS ThongBao;
  END
END

--c
CREATE PROCEDURE SP_LuongLN
AS
BEGIN
  SELECT MaNV, TenNV, LuongCanBan*NgayCong+PhuCap AS Luong
  FROM tblNhanVien;
END

--d
CREATE FUNCTION TBL_LuongTB()
RETURNS TABLE 
AS
RETURN
(
  SELECT tblNhanVien.MaNV, tblNhanVien.TenNV, tlbChucvu.TenCV, tblNhanVien.LuongCanBan*CASE WHEN NgayCong >= 25 THEN NgayCong*2 ELSE NgayCong END + PhuCap AS Luong
  FROM tblNhanVien
  INNER JOIN tlbChucvu ON tblNhanVien.MaCV = tlbChucvu.MaCV
  GROUP BY tblNhanVien.MaNV, tblNhanVien.TenNV, tlbChucvu.TenCV, tblNhanVien.LuongCanBan, tblNhanVien.NgayCong, tblNhanVien.PhuCap
)

--1
CREATE PROCEDURE SP_ThemNhanVien
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhucCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhucCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhucCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--2
CREATE PROCEDURE SP_ThemNhanVien2
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhucCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhucCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhucCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--3
CREATE PROCEDURE SP_CapNhatNgaySinh
  @MaNV VARCHAR(10),
  @NgaySinh DATE
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
  IF @Count = 0
  BEGIN
    SELECT 'Không tìm thấy bản ghi cần cập nhật' AS ThongBao;
  END
  ELSE
  BEGIN
    UPDATE NhanVien SET NgaySinh = @NgaySinh WHERE MaNV = @MaNV;
    SELECT 'Cập nhật thành công' AS ThongBao;
  END
END

--4
CREATE PROCEDURE SP_TongSoNhanVienTheoNgayCong
  @NgayCong1 INT,
  @NgayCong2 INT
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NhanVien
  WHERE NgayCong BETWEEN @NgayCong1 AND @NgayCong2;
END

--5
CREATE PROCEDURE SP_TongSoNhanVienTheoChucVu
  @TenCV NVARCHAR(50)
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NhanVien
  WHERE MaCV IN (SELECT MaCV FROM ChucVu WHERE TenCV = @TenCV);
END