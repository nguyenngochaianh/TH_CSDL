
--cau1--
CREATE TRIGGER trg_Nhap_Check
ON Nhap
AFTER INSERT
AS
BEGIN
    DECLARE @masp NVARCHAR(10)
    DECLARE @manv NVARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN
    FROM inserted
    
    -- Kiểm tra masp có trong bảng Sanpham chưa
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR('Lỗi: masp không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra manv có trong bảng Nhanvien chưa
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR('Lỗi: manv không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Lỗi: soluongN và dongiaN phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng sản phẩm trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + @soluongN
    WHERE masp = @masp
END


--cau2--
CREATE TRIGGER KiemtraXuat
ON Xuat
AFTER INSERT
AS
BEGIN
    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = (SELECT masp FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = (SELECT manv FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    DECLARE @soluongX INT
    SELECT @soluongX = soluongX FROM inserted
    
    DECLARE @soluong INT
    SELECT @soluong = soluong FROM Sanpham WHERE masp = (SELECT masp FROM inserted)
    
    IF (@soluongX > @soluong)
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong - @soluongX
    WHERE masp = (SELECT masp FROM inserted)
END

--cau3--
CREATE TRIGGER capnhaSoluongXoaPhieuXuat
ON Xuat
AFTER DELETE
AS
BEGIN
    -- Cập nhật số lượng hàng trong bảng Sanpham tương ứng với sản phẩm đã xuất
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong + deleted.soluongX
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END

--cau4--
CREATE TRIGGER CapNhatSoluongXoaPhieuXuat
ON Xuat
AFTER DELETE
AS
BEGIN
    -- Cập nhật số lượng hàng trong bảng Sanpham tương ứng với sản phẩm đã xuất
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong + deleted.soluongX
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END

----cau 5----
CREATE TRIGGER tr_CapNhatNhap
ON Nhap
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra số bản ghi thay đổi
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR('Chỉ được phép cập nhật 1 bản ghi tại một thời điểm', 16, 1)
        ROLLBACK
    END
    
    -- Kiểm tra số lượng nhập
    DECLARE @masp INT
    DECLARE @soluongN INT
    DECLARE @soluong INT
    
    SELECT @masp = i.masp, @soluongN = i.soluongN, @soluong = s.soluong
    FROM inserted i
    INNER JOIN Sanpham s ON i.masp = s.masp
    
    IF (@soluongN > @soluong)
    BEGIN
        RAISERROR('Số lượng nhập không được vượt quá số lượng hiện có trong kho', 16, 1)
        ROLLBACK
    END
    
    -- Cập nhật số lượng trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + (@soluongN - (SELECT soluongN FROM deleted WHERE masp = @masp))
    WHERE masp = @masp
END

-----cau 6-------
CREATE TRIGGER CapNhat_soluong_sp 
ON Nhap
AFTER DELETE
AS

BEGIN
    
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong - deleted.soluongN
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END



