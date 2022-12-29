USE QlyCungcapPhutung
GO

CREATE TRIGGER trg_phutung_update
	ON Phutung
	AFTER UPDATE
AS
	IF(UPDATE(KHOILUONG))
	BEGIN
		DECLARE @maphutung varchar(5), @kluong float
		BEGIN
			SELECT @maphutung = MaPT, @kluong =Khoiluong
			FROM INSERTED
			UPDATE Cungcap 
			SET KhoiluongPT=soluong * @kluong
			WHERE MaPT=@maphutung
		END
	END

UPDATE Phutung set khoiluong=15 where MaPT='P0015'

