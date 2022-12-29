-- 1. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).

-- TRIGGER INSERT HOADON 
CREATE TRIGGER tg_NGHD_NGDK_insert
	ON HOADON 
	AFTER INSERT
AS
BEGIN
	DECLARE @ngayDK smalldatetime;
	DECLARE @ngayHD smalldatetime;
	SELECT @ngayDK= NGDK,@ngayHD = NGHD 
	FROM KHACHHANG kh JOIN inserted i 
		ON kh.MAKH = i.MAKH
	IF(@ngayDK > @ngayHD)
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Ngày khách hàng đăng kí (NGDK) phải nhỏ hơn ngày mua hàng (NGHD)'
	END
END
GO

-- TRIGGER UPDATE HOADON
CREATE TRIGGER tg_NGHD_NGDK_update 
	ON HOADON 
	AFTER UPDATE
AS
IF UPDATE(NGHD)
BEGIN
	IF(EXISTS(SELECT * 
			FROM KHACHHANG kh JOIN inserted i ON kh.MAKH=i.MAKH
			WHERE i.NGHD < kh.NGDK))
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Ngày khách hàng đăng kí (NGDK) phải nhỏ hơn ngày mua hàng (NGHD)'
	END
END
GO

-- TRIGGER UPDATE KHACHHANG
CREATE TRIGGER tg_NGDK_NGHD_update 
	ON KHACHHANG 
	AFTER UPDATE
AS
IF UPDATE(NGDK)
BEGIN
	IF(EXISTS(SELECT * 
			FROM HOADON hd JOIN inserted i ON hd.MAKH=i.MAKH
			WHERE i.NGDK > hd.NGHD))
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Ngày khách hàng đăng kí (NGDK) phải nhỏ hơn ngày mua hàng (NGHD)'
	END
END
GO

-- 2. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
-- TRIGGER INSERT HOADON  
CREATE TRIGGER tg_NGHD_NGVL_insert 
	ON HOADON 
	AFTER INSERT
AS
BEGIN
	DECLARE @ngayVL smalldatetime;
	DECLARE @ngayHD smalldatetime;
	SELECT @ngayVL = NGVL, @ngayHD = NGHD 
	FROM NHANVIEN nv JOIN inserted i 
		ON nv.MANV = i.MANV
	IF(@ngayVL > @ngayHD)
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Ngày vào làm (NGVL) phải nhỏ hơn ngày mua hàng (NGHD)'
	END
END
GO

-- TRIGGER UPDATE HOADON
CREATE TRIGGER tg_NGHD_NGVL_update 
	ON HOADON 
	AFTER UPDATE
AS
IF UPDATE(NGHD)
BEGIN
	IF(EXISTS(SELECT * 
			FROM NHANVIEN nv JOIN inserted i ON nv.MANV = i.MANV
			WHERE NGVL > NGHD))
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Ngày vào làm (NGVL) phải nhỏ hơn ngày mua hàng (NGHD)'
	END
END
GO

DROP TRIGGER tg_NGHD_NGVL_update
GO

--TRIGGER UPDATE NHANVIEN
CREATE TRIGGER tg_NGVL_NGHD_update 
	ON NHANVIEN 
	AFTER UPDATE
AS
IF UPDATE(NGVL)
BEGIN
	IF(EXISTS(SELECT * 
			FROM HOADON hd JOIN inserted i ON hd.MANV=i.MANV
			WHERE NGVL > NGHD))
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Ngày vào làm (NGVL) phải nhỏ hơn ngày mua hàng (NGHD)'
	END
END
GO
----------------------------------
-- TEST TRIGGER UPDATE NGÀY VÀO LÀM CỦA NHÂN VIÊN
-- dữ liệu chuẩn
-- NV02 ngvl = 21-4-2006   KH07 ngdk = 12-1-2006
-- thêm một hoá đơn để test trigger insert
INSERT HOADON VALUES('1111','2006-5-30','KH07','NV02',20000);
DELETE FROM HOADON
WHERE SOHD='1111'

-- dữ liệu chuẩn
UPDATE NHANVIEN 
SET NGVL = '2006-4-21' 
WHERE MANV = 'NV02'

-- test update trigger ngày vào làm sai
UPDATE NHANVIEN 
SET NGVL = '2006-6-30' 
WHERE MANV = 'NV02'

-- test update trigger ngày vào làm đúng
UPDATE NHANVIEN 
SET NGVL = '2006-4-30' 
WHERE MANV = 'NV02'