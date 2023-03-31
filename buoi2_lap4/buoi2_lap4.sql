-- 1. Hiển thị thông tin các bảng dữ liệu trên --
create view buoi2_cau1
as
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
select * from buoi2_cau1


-- 2.Thông tin các sản phẩm sắp xếp theo chiều giảm dần giá bán--
create view buoi2_cau2
as
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
ORDER BY Sanpham.giaban DESC;
select * from buoi2_cau2

-- 3.Thông tin các sản phẩm có trong cữa hàng do công ty có tên hãng là samsung sản xuất. --
create view buoi2_cau3
as
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsxZ
WHERE Hangsx.tenhang = 'Samsung'
select * from buoi2_cau3

-- 4.Thông tin các nhân viên Nữ ở phòng ‘Kế toán’.--
create view buoi2_cau4
as
SELECT * FROM nhanvien
WHERE gioitinh = 'Nữ' AND phong = 'Kế toán'
select * from buoi2_cau4


-- 5.Thông tin phiếu nhập.Sắp xếp theo chiều tăng dần của hóa đơn nhập.--
create view buoi2_cau5
as
SELECT Nhap.sohdn, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.soluongN, Nhap.dongiaN, Nhap.soluongN*Nhap.dongiaN AS tiennhap, Sanpham.mausac, Sanpham.donvitinh, Nhap.ngaynhap, Nhanvien.tennv, Nhanvien.phong
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
ORDER BY Nhap.sohdn ASC;
select * from buoi2_cau5


--6.Thông tin phiếu xuất  trong tháng 10 năm 2018, sắp xếp theo chiều tăng dần của sohdx.
create view buoi2_cau6
as
SELECT Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, 
       Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, 
       Nhanvien.tennv, Nhanvien.phong
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE MONTH(Xuat.ngayxuat) = 10 AND YEAR(Xuat.ngayxuat) = 2018
ORDER BY Xuat.sohdx ASC;
select * from buoi2_cau6


-- 7. thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017
create view buoi2_cau7
as
SELECT sohdn, Sanpham.masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong
FROM Nhap 
JOIN Sanpham ON Nhap.masp = Sanpham.masp 
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2017;
select * from buoi2_cau7

--8. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018
create view buoi2_cau8
as
SELECT TOP 10 Xuat.sohdx, Sanpham.tensp, Xuat.soluongX
FROM Xuat 
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE YEAR(Xuat.ngayxuat) = '2023' 
ORDER BY Xuat.soluongX DESC;
select * from buoi2_cau8


--9. thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm dần gía bán.
create view buoi2_cau9
as
SELECT TOP 10 tenSP, giaBan
FROM SanPham
ORDER BY giaBan DESC;
select * from buoi2_cau9


--10. thông tin sản phẩm có gía bán từ 100.000 đến 500.000 của hãng samsung.
create view buoi2_cau10
as
SELECT *
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND Sanpham.giaban >= 100000 AND Sanpham.giaban <= 500000
select * from buoi2_cau10


--11 Tính tổng tiền đã nhập trong năm 2018 của hãng samsung.
create view buoi2_cau11
as
SELECT SUM(soluongN * dongiaN) AS tongtien
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2018
select * from buoi2_cau11


--12 Thống kê tổng tiền đã xuất trong ngày 2/9/2018
create view buoi2_cau12
as
SELECT SUM(Xuat.soluongX * Sanpham.giaban) AS Tongtien
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE Xuat.ngayxuat = '2018-09-02'
select * from buoi2_cau12


--13 Đưa ra sohdn, ngaynhap có tiền nhập phải trả cao nhất trong năm 2018
create view buoi2_cau13
as
SELECT TOP 1 sohdn, ngaynhap, dongiaN
FROM Nhap
ORDER BY dongiaN DESC
select * from buoi2_cau13


--14 Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019.
create view buoi2_cau14
as
SELECT TOP 10 Sanpham.tensp, SUM(Nhap.soluongN) AS TongSoLuongN 
FROM Sanpham 
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp 
WHERE YEAR(Nhap.ngaynhap) = 2019 
GROUP BY Sanpham.tensp 
ORDER BY TongSoLuongN DESC
select * from buoi2_cau14


--15 Đưa ra masp,tensp của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
create view buoi2_dscau15
as
SELECT Sanpham.masp, Sanpham.tensp
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp
INNER JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND Nhanvien.manv = 'NV01';
select * from buoi2_cau15


--16 Đưa ra sohdn,masp,soluongN,ngayN của mặt hàng có masp là ‘SP02’, được nhân viên ‘NV02’ xuất.
create view buoi2_cau16
as
SELECT sohdn, masp, soluongN, ngaynhap
FROM Nhap
WHERE masp = 'SP02' AND manv = 'NV02'
select * from buoi2_cau16


--17 Đưa ra manv,tennv đã xuất mặt hàng có mã ‘SP02’ ngày ’03-02-2020’.
create view buoi2_cau17
as
SELECT Nhanvien.manv, Nhanvien.tennv
FROM Nhanvien
JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Xuat.masp = 'SP02' AND Xuat.ngayxuat = '2020-03-02'
select * from buoi2_cau17


--lab3--
--2 --
create view buoi2_cau18
as
SELECT masp, SUM(soluongN * dongiaN) AS TongTienNhap
FROM Nhap
WHERE YEAR(ngaynhap) = 2020
GROUP BY masp;
select * from buoi2_cau18

--3 --
create view buoi2_cau19
as
SELECT Sanpham.masp, Sanpham.tensp, SUM(Xuat.soluongX) AS tong_so_luong_xuat
FROM Sanpham JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE Sanpham.mahangsx = 'H01'
GROUP BY Sanpham.masp, Sanpham.tensp
HAVING SUM(Xuat.soluongX) > 10000;
select * from buoi2_cau19

--4 --
create view buoi2_cau20
as
SELECT phong, COUNT(*) as 'So_luong_nhan_vien_nam'
FROM Nhanvien
WHERE gioitinh = N'Nam'
GROUP BY phong;
select * from buoi2_cau20
--5 --
create view buoi2_cau21
as
SELECT Hangsx.tenhang, SUM(Nhap.soluongN) AS tongnhap
FROM Hangsx
JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2020
GROUP BY Hangsx.tenhang
select * from buoi2_cau21
-- 6 --
create view buoi2_cau22
as
SELECT Nhanvien.manv, Nhanvien.tennv, SUM(Xuat.soluongX * Sanpham.giaban) AS tongtienxuat
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE YEAR(Xuat.ngayxuat) = 2018
GROUP BY Nhanvien.manv, Nhanvien.tennv
select * from buoi2_cau22
-- 7 --
create view buoi2_cau23
as
SELECT manv, SUM(soluongN * dongiaN) AS tong_tien_nhap
FROM Nhap
WHERE MONTH(ngaynhap) = 8 AND YEAR(ngaynhap) = 2018
GROUP BY manv
HAVING SUM(soluongN * dongiaN) > 100000;
select * from buoi2_cau23
-- 8 --
create view buoi2_cau24
as
SELECT *
FROM Sanpham
WHERE masp NOT IN (SELECT masp FROM Xuat)
select * from buoi2_cau24
-- 9 --
create view buoi2_cau25
as
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.ngaynhap, Xuat.ngayxuat
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Nhap.ngaynhap) = 2018 AND YEAR(Xuat.ngayxuat) = 2018;
select * from buoi2_cau25
-- 10 --
create view buoi2_cau26
as
SELECT DISTINCT NV.manv, NV.tennv
FROM Nhap N 
JOIN Xuat X ON N.masp = X.masp AND N.manv = X.manv
JOIN Nhanvien NV ON N.manv = NV.manv;
select * from buoi2_cau26
-- 11 --
create view buoi2_cau27
as
SELECT *
FROM Nhanvien
LEFT JOIN Nhap ON Nhanvien.manv = Nhap.manv
LEFT JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Nhap.manv IS NULL AND Xuat.manv IS NULL;
select * from buoi2_cau27