USE QLBH_2020
GO
--1. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT		NUOCSX , COUNT(MASP) sosp
FROM		SANPHAM
GROUP BY	NUOCSX

--2. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT	COUNT(SOHD) Khachhangkhongdangky
FROM	HOADON
where	MAKH IS NULL

--3. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT	MAX(TRIGIA) GTLN, MIN(TRIGIA) GTNN
FROM	HOADON

--4. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT	AVG(TRIGIA) GTTB
FROM	HOADON
WHERE	YEAR(NGHD) =2006

--5. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT		NUOCSX, MAX(GIA) GTLN, MIN(GIA) GTNN, AVG(GIA) GTTB
FROM		SANPHAM sp
group by	NUOCSX 

--6. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT		MONTH(NGHD), SUM(TRIGIA) DOANHTHU
FROM		HOADON
WHERE		YEAR(NGHD) ='2006'
GROUP BY	MONTH(NGHD)

--7. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006
SELECT	ct.MASP , SUM(ct.SL) TONGSL
FROM	CTHD ct
	JOIN HOADON hd ON ct.SOHD =hd.SOHD
WHERE	MONTH(NGHD) ='10' AND YEAR(NGHD) ='2006'
GROUP BY ct.MASP

--8. Tìm hóa đơn có mua 3 mã sản phẩm do “Viet Nam” sản xuất.
SELECT ct.SOHD
FROM CTHD ct
JOIN SANPHAM sp ON sp.MASP =ct.MASP
WHERE sp.NUOCSX ='VIET NAM'
GROUP BY ct.SOHD
HAVING COUNT(sp.MASP) ='3'

--9. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 WITH ties SOHD 
FROM HOADON 
WHERE YEAR(NGHD) =2006 
ORDER BY TRIGIA DESC 

--10.Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 WITH ties kh.MAKH, HOTEN , SOHD, TRIGIA
FROM HOADON h
JOIN KHACHHANG kh ON kh.MAKH = h.MAKH
WHERE YEAR(NGHD) =2006 
ORDER BY TRIGIA DESC 

--11.In ra danh sách khách hàng và thứ hạng của khách hàng (xếp hạng theo doanh số).
SELECT *, rank() over(ORDER BY DOANHSO DESC) 
FROM KHACHHANG

--12.In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần
SELECT TOP 3 WITH TIES MAKH, HOTEN 
FROM KHACHHANG
ORDER BY DOANHSO DESC

--13.In ra thông tin (MAKH, HOTEN, DOANHSO) và loại của khách hàng...
SELECT MAKH, HOTEN, DOANHSO, LOAIKH =
CASE 
       WHEN DOANHSO > 2000000 THEN ' KHACH HANG VIP '
	   WHEN DOANHSO > 500000 THEN ' KHACH HANG TV'
	   ELSE ' KHACH HANG TT'
END
FROM KHACHHANG
