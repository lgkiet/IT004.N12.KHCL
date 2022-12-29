USE QLBH_2020;

--1. Hóa đơn nào mua sản phẩm có mã số ‘BB01’ nhưng không mua sản phẩm có mã số
--‘BC02’. Sử dụng hai cách: truy vấn con NOT IN và sử dụng lượng từ EXISTS.
--Cach 1
SELECT
    *
FROM
    HOADON
    JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE
    CTHD.MASP = 'BB01'
    AND HOADON.SOHD NOT IN(
        SELECT
            HOADON.SOHD
        FROM
            HOADON
            JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
        WHERE
            CTHD.MASP = 'BC02'
    );

--Cach 2
SELECT
    *
FROM
    HOADON
    JOIN CTHD ON hoadon.SOHD = CTHD.SOHD
WHERE
    CTHD.MASP = 'BB01'
    AND NOT EXISTS (
        SELECT
            CTHD.SOHD
        FROM
            CTHD
        WHERE
            hoadon.SOHD = CTHD.SOHD
            AND CTHD.MASP = 'BC02'
    );

--2. Tìm các số hóa đơn (SOHD) mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”.
SELECT
    *
FROM
    HOADON
    JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE
    CTHD.MASP = 'BB01'
    AND EXISTS (
        SELECT
            CTHD.SOHD
        FROM
            CTHD
        WHERE
            hoadon.SOHD = CTHD.SOHD
            AND CTHD.MASP = 'BB02'
    );

--3. Tìm các số hóa đơn (SOHD) trong tháng 12 năm 2006 có mua cùng lúc 2 sản phẩm 
--có mã số “BB01” và “BB02”.
SELECT
    *
FROM
    HOADON
    JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE
    CTHD.MASP = 'BB01'
    AND MONTH(NGHD) = 12
    AND year(NGHD) = 2006
    AND HOADON.SOHD IN(
        SELECT
            HOADON.SOHD
        FROM
            HOADON
            JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
        WHERE
            CTHD.MASP = 'BB02'
    );

--4. Tìm các số hóa đơn (SOHD) có mua sản phẩm có mã số “ST04” nhưng không mua 
--sản phẩm có mã số “TV03”.
SELECT
    cthd1.SOHD
FROM
    CTHD cthd1
WHERE
    cthd1.MASP = 'ST04'
    AND NOT EXISTS (
        SELECT
            CTHD.SOHD
        FROM
            CTHD
        WHERE
            cthd1.SOHD = CTHD.SOHD
            AND CTHD.MASP = 'TV03'
    );

--5. Tìm các hóa đơn (SOHD, NGHD) có mua sản phẩm có mã số “ST04” nhưng không 
--mua sản phẩm có mã số “TV03”.
SELECT
    HOADON.SOHD,
    HOADON.NGHD
FROM
    HOADON
    JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE
    CTHD.MASP = 'ST04'
    AND NOT EXISTS (
        SELECT
            CTHD.SOHD
        FROM
            CTHD
        WHERE
            HOADON.SOHD = CTHD.SOHD
            AND CTHD.MASP = 'TV03'
    );

--6. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá 
--bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT
    MASP,
    TENSP,
    GIA
FROM
    SANPHAM
WHERE
    SANPHAM.NUOCSX = 'Trung Quoc'
    AND SANPHAM.GIA IN (
        SELECT
            TOP(3) GIA
        FROM
            SANPHAM
        WHERE
            NUOCSX = 'Trung Quoc'
        ORDER BY
            GIA DESC
    );

--7. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
SELECT
    MONTH(NGHD) thang
FROM
    HOADON
WHERE
    YEAR(NGHD) = 2006
GROUP BY
    MONTH(nghd)
HAVING
    SUM(TRIGIA) >= ALL(
        SELECT
            SUM(TRIGIA) doanh_so
        FROM
            HOADON
        WHERE
            YEAR(NGHD) = 2006
        GROUP BY
            MONTH(NGHD)
    );

--8. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT
    sp.MASP,
    sp.TENSP
FROM
    SANPHAM sp
    JOIN CTHD ON sp.MASP = CTHD.MASP
    JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE
    YEAR(NGHD) = 2006
GROUP BY
    sp.MASP,
    sp.TENSP
HAVING
    SUM(SL) <= ALL (
        SELECT
            SUM(SL)
        FROM
            SANPHAM sp1
            JOIN CTHD ON sp1.MASP = CTHD.MASP
            JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
        WHERE
            YEAR(NGHD) = 2006
        GROUP BY
            sp1.MASP
    );

--9. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT
    kh.MAKH,
    HOTEN,
    TRIGIA
FROM
    KHACHHANG kh
    JOIN HOADON hd ON kh.MAKH = hd.MAKH
WHERE
    YEAR(NGHD) = 2006
    AND TRIGIA >= ALL(
        SELECT
            TRIGIA
        FROM
            HOADON
    );

--10.Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT
    MASP,
    TENSP,
    NUOCSX,
    GIA
FROM
    SANPHAM
WHERE
    GIA >= ALL(
        SELECT
            GIA
        FROM
            SANPHAM sp
        WHERE
            SANPHAM.NUOCSX = sp.NUOCSX
    );

--11.Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT
    DISTINCT cthd1.SOHD
FROM
    CTHD cthd1
    JOIN SANPHAM sp ON cthd1.MASP = sp.masp
WHERE
    NOT EXISTS (
        SELECT
            MASP
        FROM
            SANPHAM
        WHERE
            NUOCSX = 'Singapore'
            AND MASP NOT IN (
                SELECT
                    SANPHAM.MASP
                FROM
                    CTHD
                    JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
                WHERE
                    CTHD.sohd = cthd1.SOHD
                    AND NUOCSX = 'Singapore'
            )
    );