--1. Tạo database, bảng với kiểu dữ liệu của các thuộc tính được mô tả như trên. (Phải có 
--đầy đủ khóa chính, khóa ngoại).

--Tao database
create database QlyDoXe

--Tao bang
CREATE TABLE KHACHHANG(
	MAKH	CHAR(5) PRIMARY KEY,
	HOTEN	VARCHAR(50),
	DIACHI	VARCHAR(100),
	NGSINH	SMALLDATETIME,
	EMAIL	VARCHAR(70)
);

CREATE TABLE HANGXE(
	MAHX	CHAR(5) PRIMARY KEY,
	TENHX	VARCHAR(40)
);

CREATE TABLE XE(
	MAXE	CHAR(5) PRIMARY KEY,
	NAMSX	INT,
	MAHX	CHAR(5)
);

CREATE TABLE VEXE(
	MAVE	CHAR(5) PRIMARY KEY,
	MOTA	VARCHAR(60)
);

CREATE TABLE PHIEUDOXE(
	MAPHIEU	CHAR(5) PRIMARY KEY,
	MAKH	CHAR(5),
	MAXE	CHAR(5),
	MAVE	CHAR(5),
	NGAYGHIPHIEU SMALLDATETIME,
	NGAYTRATIEN SMALLDATETIME
);

--KHOA CHINH, KHOA NGOAI
ALTER TABLE XE ADD CONSTRAINT FK_MAHX FOREIGN KEY (MAHX) REFERENCES HANGXE(MAHX)
ALTER TABLE PHIEUDOXE ADD CONSTRAINT FK_MAKH FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
ALTER TABLE PHIEUDOXE ADD CONSTRAINT FK_MAXE FOREIGN KEY (MAXE) REFERENCES XE(MAXE)
ALTER TABLE PHIEUDOXE ADD CONSTRAINT FK_MAVE FOREIGN KEY (MAVE) REFERENCES VEXE(MAVE)

--2.
--a. Thêm thuộc tính NAMTL có kiểu dữ liệu VARCHAR(10) vào bảng HANGXE.
ALTER TABLE HANGXE ADD NAMTL VARCHAR(10)


--b. Thay đổi thuộc tính NAMTL của HANGXE thành INT.
ALTER TABLE HANGXE ALTER COLUMN NAMTL INT

--c. Xóa thuộc tính NAMTL của bảng HANGXE.
ALTER TABLE HANGXE DROP COLUMN NAMTL

--3.
--a. Thêm một dòng dữ liệu vào bảng VEXE.
INSERT INTO VEXE
VALUES('LGK12','THUONG GIA')

--b. Thay đổi mô tả (MOTA) của VEXE đã được thêm ở câu a thành ‘Lan xe buyt’.
UPDATE VEXE
SET
	MOTA = 'Lan xe buyt'
WHERE MAVE = 'LGK12'

--c. Xóa dòng dữ liệu vừa mới thêm ở câu a ra khỏi bảng VEXE.DELETE FROM VEXEWHERE MAVE = 'LGK12'--B.--1.  Hiển thị những khách hàng (makh, hoten, diachi) sinh vào tháng 6 năm 2000. Sắp 
-- xếp theo hoten khách hàng.
SELECT	MAKH, HOTEN, DIACHI
FROM	KHACHHANG
WHERE	YEAR(NGSINH) = 2000 AND MONTH(NGSINH) = 6
ORDER BY HOTEN

--2.  Hiển thị những phiếu đỗ xe (maphieu, makh, ngayghiphieu) được ghi trong năm 
--2001 hoặc năm 2002. Sắp xếp theo mã khách hàng
SELECT	MAPHIEU, MAKH, NGAYGHIPHIEU
FROM	PHIEUDOXE
WHERE	YEAR(NGAYGHIPHIEU) = 2001 OR YEAR(NGAYGHIPHIEU) = 2002
ORDER BY MAKH

--3. Xe nào được sản xuất trong khoảng thời gian từ năm 1990 đến năm 2000. Sắp xếp 
--theo năm sản xuất
SELECT	*
FROM	XE
WHERE	YEAR(XE.NAMSX) BETWEEN  1990 AND 2000

--4. Khách hàng nào (MAKH) có phiếu đỗ xe của hãng có tên hãng xe là 'Toyota'.
