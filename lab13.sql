--1
CREATE TABLE MaThang (
  MaHang INT PRIMARY KEY,
  tenHang VARCHAR(255),
  SoLuong INT
);

CREATE TABLE NhatKyBanhang (
  STT INT PRIMARY KEY,
  Ngay DATE,
  NguoiMua VARCHAR(255),
  MaHang INT,
  SoLuong INT,
  GiaBan FLOAT,
  FOREIGN KEY (MaHang) REFERENCES MaThang(MaHang)
);
--2
Insert into Mathang (MaHang, tenHang,SoLuong)
VALUES ('1','Keo','100'),('2','Banh','200'),('3','Thuoc','100')

Insert into NhatKyBanhang (STT, Ngay, NguoiMua, MaHang, SoLuong, GiaBan)
Values ('1','1999-02-09','ab','2','230','50000')
--3
--a
CREATE TRIGGER trg_nhatkybanhang_insert 
ON NhatKyBanhang 
AFTER INSERT 
AS 
UPDATE MaThang 
SET SoLuong = SoLuong - (SELECT SoLuong FROM inserted) 
WHERE MaHang = (SELECT MaHang FROM inserted);


--b
CREATE TRIGGER Trg_nhatkybanhang_update_soluong
ON NhatKyBanhang
AFTER UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) = 1 AND (SELECT COUNT(*) FROM deleted) = 1
    BEGIN
        DECLARE @maHang INT, @soLuong INT, @soLuongCu INT, @soLuongMoi INT
        SELECT @maHang = inserted.MaHang, @soLuongCu = deleted.SoLuong, @soLuongMoi = inserted.SoLuong FROM inserted, deleted
        IF (@soLuongCu <> @soLuongMoi)
        BEGIN
            SELECT @soLuong = SoLuong FROM MaThang WHERE MaHang = @maHang
            UPDATE MaThang SET SoLuong = @soLuong - (@soLuongCu - @soLuongMoi) WHERE MaHang = @maHang
        END
    END
END;
--c
CREATE TRIGGER trg_nhatkybanhang_insert1
ON NHATKYBANHANG
FOR INSERT
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong <= @soluong_hien_co
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong - @soluong
		WHERE mahang = @mahang
		END
		ELSE
		BEGIN
		RAISERROR('Số lượng hàng bán ra phải nhỏ hơn hoặc bằng số lượng hàng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
END;
--d
CREATE TRIGGER trg_nhatkybanhang_update
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
IF (SELECT COUNT(*) FROM inserted) > 1
BEGIN
	RAISERROR('Chỉ được cập nhật 1 bản ghi tại một thời điểm!', 16, 1)
	ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM inserted

		SELECT @soluong_hien_co = soluong
		FROM MATHANG
		WHERE mahang = @mahang

		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
--e
CREATE TRIGGER trg_nhatkybanhang_delete
ON NHATKYBANHANG
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(*) FROM deleted) > 1
	BEGIN
		RAISERROR('Chỉ được xóa 1 bản ghi tại một thời điểm!', 16, 1)
		ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
		DECLARE @mahang INT, @soluong INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM deleted
		UPDATE MATHANG
		SET soluong = soluong + @soluong
		WHERE mahang = @mahang
	END
END;

--f
CREATE TRIGGER trg_nhatkybanhang_updatef
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong > @soluong_hien_co
	BEGIN
		RAISERROR('Số lượng cập nhật không được vượt quá số lượng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE IF @soluong = @soluong_hien_co
	BEGIN
		RAISERROR('Không cần cập nhật số lượng!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;	
--g
CREATE PROCEDURE sp_xoa_mathang
@mahang INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM MATHANG WHERE mahang = @mahang)
BEGIN
PRINT 'Mã hàng không tồn tại!'
RETURN
END

BEGIN TRANSACTION

DELETE FROM NHATKYBANHANG WHERE mahang = @mahang
DELETE FROM MATHANG WHERE mahang = @mahang

COMMIT TRANSACTION

PRINT 'Xóa mặt hàng thành công!'
END

--h
CREATE FUNCTION fn_tongtien_hang
(@tenhang NVARCHAR(50))
RETURNS MONEY
AS
BEGIN
DECLARE @tongtien MONEY

SELECT @tongtien = SUM(tongiten)
FROM NHATKYBANHANG nk
JOIN MATHANG mh ON nk.mahang = mh.mahang
WHERE mh.tenHang = @tenhang

RETURN @tongtien
END


--i
-- câu 2
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- 3a
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(6, '2022-04-22', 'Nguyễn Thị F', 1, 3, 15000)
SELECT * FROM MATHANG
--3b
UPDATE NHATKYBANHANG SET soluong = 2 WHERE stt = 2
SELECT * FROM MATHANG
-- 3c
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(7, '2022-04-23', 'Trương Văn G', 2, 10, 12000)
SELECT * FROM MATHANG
-- 3d
UPDATE NHATKYBANHANG SET soluong = 1 WHERE stt = 3
SELECT * FROM MATHANG
--3e
DELETE FROM NHATKYBANHANG WHERE stt = 4
SELECT * FROM MATHANG
--3f
UPDATE NHATKYBANHANG SET soluong = 7 WHERE stt = 5
SELECT * FROM MATHANG
--3g
EXEC sp_xoa_mathang 3
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- 3h
SELECT dbo.fn_tongtien_hang('Sữa tươi Vinamilk') AS 'Tổng tiền Sữa tươi Vinamilk'
SELECT dbo.fn_tongtien_hang('Bánh mì phô mai') AS 'Tổng tiền Bánh mì phô mai'

