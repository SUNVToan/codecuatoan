CREATE DATABASE QUAN_TRI_TRUONG_HOC
GO
USE QUAN_TRI_TRUONG_HOC
GO 
CREATE TABLE KHOA(
	MAKHOA VARCHAR(4) NOT NULL,
	TENKHOA VARCHAR(40) NOT NULL UNIQUE,
	NGTLAP SMALLDATETIME NOT NULL CHECK( NGTLAP <= GETDATE()),
	TRGKHOA CHAR(4) NOT NULL,
	CONSTRAINT PK_MAKHOA PRIMARY KEY(MAKHOA)           
)

GO 

CREATE TABLE MONHOC ( 
	MAMH VARCHAR(10) NOT NULL,
	TENMH VARCHAR(40) NOT NULL UNIQUE,
	TCLT TINYINT NOT NULL CHECK(TCLT > 0),
	TCTH TINYINT NOT NULL CHECK( TCTH >0),
	MAKHOA VARCHAR(4) NOT NULL,
	CONSTRAINT PK_MAMH PRIMARY KEY(MAMH),
	CONSTRAINT FK_MAKHOA FOREIGN KEY(MAKHOA) REFERENCES dbo.KHOA(MAKHOA)    	
) 

GO

CREATE TABLE DIEUKIEN(
	MAMH VARCHAR(10) NOT NULL,
	MAMH_TRUOC VARCHAR(10) NOT NULL,
	CONSTRAINT PK_DK PRIMARY KEY(MAMH, MAMH_TRUOC),
	CONSTRAINT FK_MAMH FOREIGN KEY(MAMH) REFERENCES dbo.MONHOC(MAMH)  
)


GO


CREATE TABLE GIAOVIEN(
	MAGV CHAR(4) NOT NULL,
	HOTEN VARCHAR(40) NOT NULL,
	HOCVI VARCHAR(10) NOT NULL,
	HOCHAM VARCHAR(10) NOT NULL,
	GIOITINH VARCHAR(3) NOT NULL CHECK(GIOITINH IN('NAM', N'NỮ')),
	NGSINH SMALLDATETIME NOT NULL CHECK(NGSINH < GETDATE()),
	NGVL SMALLDATETIME NOT NULL,
	HESO NUMERIC(4,2) NOT NULL,
	MUCLUONG MONEY NOT NULL,
	MAKHOA VARCHAR(4) NOT NULL,
	CONSTRAINT PK_MAGV PRIMARY KEY(MAGV),
	CONSTRAINT FK_MAKHOA01 FOREIGN KEY(MAKHOA) REFERENCES dbo.KHOA(MAKHOA),
	CONSTRAINT CK_NGSINH CHECK(NGSINH < NGVL)	
)

GO 

CREATE TABLE HOCVIEN (
	MAHV CHAR(5) NOT NULL, 
	HO NVARCHAR(40) NOT NULL,
	TEN NVARCHAR(10) NOT NULL,
	NGSINH SMALLDATETIME NOT NULL CHECK(NGSINH < GETDATE()),
	GIOITINH NVARCHAR(3) NOT NULL CHECK(GIOITINH IN('NAM', N'NỮ')),
	NOISINH NVARCHAR(40) NOT NULL,
	MALOP CHAR(3) NOT NULL,
	CONSTRAINT PK_MAHV PRIMARY KEY(MAHV)
--	CONSTRAINT FK_MALOP FOREIGN KEY( MALOP) REFERENCES LOP(MALOP) --> (liên kết vòng) chúng ta phải chọn là 1 trong 2 bảng để tạo khóa ngoại trước sau khi nhập liệu cho 2 bảng xong thì tạo khoái ngoại còn lại 
)

GO

CREATE TABLE LOP(
	MALOP CHAR(3) NOT NULL,
	TENLOP VARCHAR(40) NOT NULL UNIQUE,
	TRGLOP CHAR(5) NOT NULL,
	SISO TINYINT NOT NULL CHECK( SISO >= 0),
	MAGVCN CHAR(4) NOT NULL,
	CONSTRAINT PK_MALOP PRIMARY KEY(MALOP),
	CONSTRAINT FK_TRGLOP FOREIGN KEY(TRGLOP) REFERENCES dbo.HOCVIEN(MAHV), 
	CONSTRAINT FK_MAGVCN FOREIGN KEY(MAGVCN) REFERENCES dbo.GIAOVIEN(MAGV)
)

GO 

CREATE TABLE GIANGDAY (
	MALOP CHAR(3) NOT NULL,
	MAMH VARCHAR(10) NOT NULL,
	MAGV CHAR(4) NOT NULL,
	HOCKI TINYINT NOT NULL CHECK( HOCKI > 0),
	NAM SMALLINT NOT NULL,
	TUNGAY SMALLDATETIME NOT NULL,
	DENNGAY SMALLDATETIME NOT NULL,
	CONSTRAINT PK_GD PRIMARY KEY(MALOP, MAMH),
	CONSTRAINT FK_MALOP FOREIGN KEY(MALOP) REFERENCES dbo.LOP(MALOP),
	CONSTRAINT FK_MAMH01 FOREIGN KEY ( MAMH) REFERENCES dbo.MONHOC(MAMH),
	CONSTRAINT FK_MAGV FOREIGN KEY( MAGV) REFERENCES dbo.GIAOVIEN(MAGV), 
	CONSTRAINT CK_DATE CHECK(TUNGAY < DENNGAY),
	CONSTRAINT CK_NAM CHECK( NAM BETWEEN YEAR(TUNGAY) AND YEAR(DENNGAY))   	
) 

CREATE TABLE KETQUATHI(
	MAHV CHAR(5) NOT NULL,
	MAMH VARCHAR(10) NOT NULL,
	LANTHI TINYINT NOT NULL CHECK( LANTHI >0),
	NGTHI SMALLDATETIME NOT NULL,
	DIEM NUMERIC(4,2) NOT NULL CHECK( DIEM >= 0),
	CONSTRAINT PK_KQ PRIMARY KEY( MAHV, MAMH, LANTHI),
	CONSTRAINT FK_MAHV FOREIGN KEY( MAHV) REFERENCES dbo.HOCVIEN( MAHV),
	CONSTRAINT FK_MAMH02 FOREIGN KEY( MAMH) REFERENCES dbo.MONHOC(MAMH),
)

ALTER TABLE dbo.HOCVIEN ADD CONSTRAINT FK_MALOP00 FOREIGN KEY( MALOP) REFERENCES LOP(MALOP)
ALTER TABLE dbo.GIANGDAY ADD CONSTRAINT PK_GDGV PRIMARY KEY(MALOP,MAMH,MAGV) 

-- Nhập dữ liệu 

INSERT [dbo].[DIEUKIEN] ([MAMH], [MAMH_TRUOC]) VALUES (N'MH01', N'MH02')
INSERT [dbo].[DIEUKIEN] ([MAMH], [MAMH_TRUOC]) VALUES (N'MH01', N'MH03')
INSERT [dbo].[DIEUKIEN] ([MAMH], [MAMH_TRUOC]) VALUES (N'MH03', N'MH01')
INSERT [dbo].[DIEUKIEN] ([MAMH], [MAMH_TRUOC]) VALUES (N'MH03', N'MH02')
INSERT [dbo].[DIEUKIEN] ([MAMH], [MAMH_TRUOC]) VALUES (N'MH03', N'MH03')
INSERT [dbo].[DIEUKIEN] ([MAMH], [MAMH_TRUOC]) VALUES (N'MH04', N'MH02')
INSERT [dbo].[GIANGDAY] ([MALOP], [MAMH], [MAGV], [HOCKI], [NAM], [TUNGAY], [DENNGAY]) VALUES (N'K11', N'MH01', N'GV1 ', 2, 2006, CAST(0x97DC0000 AS SmallDateTime), CAST(0x981A0000 AS SmallDateTime))
INSERT [dbo].[GIANGDAY] ([MALOP], [MAMH], [MAGV], [HOCKI], [NAM], [TUNGAY], [DENNGAY]) VALUES (N'K11', N'MH02', N'GV2 ', 1, 2008, CAST(0x9B000000 AS SmallDateTime), CAST(0x986C0000 AS SmallDateTime))
INSERT [dbo].[GIANGDAY] ([MALOP], [MAMH], [MAGV], [HOCKI], [NAM], [TUNGAY], [DENNGAY]) VALUES (N'K11', N'MH04', N'GV1 ', 2, 2006, CAST(0x97DC0000 AS SmallDateTime), CAST(0x981A0000 AS SmallDateTime))
INSERT [dbo].[GIANGDAY] ([MALOP], [MAMH], [MAGV], [HOCKI], [NAM], [TUNGAY], [DENNGAY]) VALUES (N'K12', N'MH01', N'GV1 ', 1, 2006, CAST(0x98560000 AS SmallDateTime), CAST(0x98760000 AS SmallDateTime))
INSERT [dbo].[GIANGDAY] ([MALOP], [MAMH], [MAGV], [HOCKI], [NAM], [TUNGAY], [DENNGAY]) VALUES (N'K12', N'MH02', N'GV2 ', 1, 2008, CAST(0x9B500000 AS SmallDateTime), CAST(0x98930000 AS SmallDateTime))
INSERT [dbo].[GIANGDAY] ([MALOP], [MAMH], [MAGV], [HOCKI], [NAM], [TUNGAY], [DENNGAY]) VALUES (N'K12', N'MH04', N'GV1 ', 1, 2006, CAST(0x97DC0000 AS SmallDateTime), CAST(0x981A0000 AS SmallDateTime))
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [HOCVI], [HOCHAM], [GIOITINH], [NGSINH], [NGVL], [HESO], [MAKHOA]) VALUES (N'GV1 ', N'Tran Tam Thanh', N'Thac Si', NULL, N'Nu', CAST(0x64F40000 AS SmallDateTime), CAST(0x957C0000 AS SmallDateTime), CAST(2.00 AS Numeric(4, 2)), N'KHO1')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [HOCVI], [HOCHAM], [GIOITINH], [NGSINH], [NGVL], [HESO], [MAKHOA]) VALUES (N'GV2 ', N'Nguyen To Lan', N'Thac Si', NULL, N'Nam', CAST(0x6DA30000 AS SmallDateTime), CAST(0x9E0B0000 AS SmallDateTime), CAST(2.00 AS Numeric(4, 2)), N'KHO2')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [HOCVI], [HOCHAM], [GIOITINH], [NGSINH], [NGVL], [HESO], [MAKHOA]) VALUES (N'GV3 ', N'Tran Van Huu', N'Thac Si', NULL, N'Nam', CAST(0x74A70000 AS SmallDateTime), CAST(0x9B310000 AS SmallDateTime), CAST(2.00 AS Numeric(4, 2)), N'KHO3')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [HOCVI], [HOCHAM], [GIOITINH], [NGSINH], [NGVL], [HESO], [MAKHOA]) VALUES (N'GV4 ', N'Nguyen Cao Kieu', N'Thac Si', NULL, N'Nu', CAST(0x72FC0000 AS SmallDateTime), CAST(0x92A10000 AS SmallDateTime), CAST(2.00 AS Numeric(4, 2)), N'KHO4')
INSERT [dbo].[HOCVIEN] ([MAHV], [HO], [TEN], [NGSINH], [GIOITINH], [NOISINH], [MALOP]) VALUES (N'HV1  ', N'Lam', N'Huy Huy', CAST(0x8FC70000 AS SmallDateTime), N'Nam', N'TPHCM', N'K11')
INSERT [dbo].[HOCVIEN] ([MAHV], [HO], [TEN], [NGSINH], [GIOITINH], [NOISINH], [MALOP]) VALUES (N'HV2  ', N'Nguyen', N'Ha', CAST(0x90040000 AS SmallDateTime), N'Nu', N'TPHCM', N'K11')
INSERT [dbo].[HOCVIEN] ([MAHV], [HO], [TEN], [NGSINH], [GIOITINH], [NOISINH], [MALOP]) VALUES (N'HV3  ', N'Ho', N'Le Man', CAST(0x8F850000 AS SmallDateTime), N'Nam', N'HA NOI', N'K12')
INSERT [dbo].[HOCVIEN] ([MAHV], [HO], [TEN], [NGSINH], [GIOITINH], [NOISINH], [MALOP]) VALUES (N'HV4  ', N'Tran', N'Thi Anh', CAST(0x8F490000 AS SmallDateTime), N'Nu', N'VUNG TAU', N'K12')
INSERT [dbo].[KETQUATHI] ([MAHV], [MAMH], [LANTHI], [NGTHI], [DIEM]) VALUES (N'HV1  ', N'MH01', 2, CAST(0x98570000 AS SmallDateTime), CAST(8.00 AS Numeric(4, 2)))
INSERT [dbo].[KETQUATHI] ([MAHV], [MAMH], [LANTHI], [NGTHI], [DIEM]) VALUES (N'HV2  ', N'MH01', 1, CAST(0x98560000 AS SmallDateTime), CAST(9.00 AS Numeric(4, 2)))
INSERT [dbo].[KETQUATHI] ([MAHV], [MAMH], [LANTHI], [NGTHI], [DIEM]) VALUES (N'HV3  ', N'MH01', 1, CAST(0x98930000 AS SmallDateTime), CAST(8.00 AS Numeric(4, 2)))
INSERT [dbo].[KETQUATHI] ([MAHV], [MAMH], [LANTHI], [NGTHI], [DIEM]) VALUES (N'HV4  ', N'MH01', 1, CAST(0x98940000 AS SmallDateTime), CAST(9.00 AS Numeric(4, 2)))
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NGTLAP], [TGKHOA]) VALUES (N'KHO1', N'CNTT', CAST(0x8FC70000 AS SmallDateTime), N'GV1 ')
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NGTLAP], [TGKHOA]) VALUES (N'KHO2', N'DU LICH', CAST(0x97060000 AS SmallDateTime), N'GV2 ')
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NGTLAP], [TGKHOA]) VALUES (N'KHO3', N'KINH TE', CAST(0x95450000 AS SmallDateTime), N'GV3 ')
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NGTLAP], [TGKHOA]) VALUES (N'KHO4', N'KTCN', CAST(0x92310000 AS SmallDateTime), N'GV4 ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [TRGLOP], [SISO], [MAGVCN]) VALUES (N'K11', N'LOP k11', N'HV1  ', 40, N'GV1 ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [TRGLOP], [SISO], [MAGVCN]) VALUES (N'K12', N'LOP k12', N'HV4  ', 40, N'GV2 ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [TRGLOP], [SISO], [MAGVCN]) VALUES (N'K13', N'LOP k13', NULL, 40, N'GV3 ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [TRGLOP], [SISO], [MAGVCN]) VALUES (N'K14', N'LOP k14', NULL, 40, N'GV4 ')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [TCLT], [TCTH], [MAKHOA]) VALUES (N'MH01', N'CTRR', 15, 30, N'KHO1')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [TCLT], [TCTH], [MAKHOA]) VALUES (N'MH02', N'Co So Du Lieu', 30, 30, N'KHO1')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [TCLT], [TCTH], [MAKHOA]) VALUES (N'MH03', N'Cau Truc Roi Rac', 30, 30, N'KHO1')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [TCLT], [TCTH], [MAKHOA]) VALUES (N'MH04', N'Tinh Than Khoi Nghiep', 45, 0, N'KHO3')



-- Truy vấn **************************************************************||********************************************************************************

-- Câu 1: Cho biết danh sách các môn học thuộc khoa Ngoại ngữ quản lý, thông tin gồm có: mamh, tenmh, tclt, tcth
SELECT MAMH, TENMH, TCLT, TCTH
FROM dbo.MONHOC JOIN dbo.KHOA ON KHOA.MAKHOA = MONHOC.MAKHOA  
WHERE TENKHOA LIKE N'NGOẠI NGỮ'  

--Câu 2: Cho biết các môn học có tclt lớn hơn tcth
SELECT *
FROM dbo.MONHOC
WHERE TCLT > TCTH

-- Câu 3: Cho biết các giáo viên nam, làm việc ở khoa CNTT từ năm 2010
SELECT * 
FROM dbo.GIAOVIEN JOIN dbo.KHOA ON KHOA.MAKHOA = GIAOVIEN.MAKHOA   
WHERE GIOITINH LIKE 'NAM' AND YEAR(NGVL) = 2010 AND TENKHOA LIKE N'CNTT'

-- Câu 4: Cho biết các học viên có họ Nguyễn có ngày sinh nhật trong tháng 10
SELECT *
FROM dbo.HOCVIEN 
WHERE HO LIKE N'NGUYỄN%' AND MONTH (NGSINH) = 10  

--Câu 5: Cho biết lớp học có số học viên đông nhất
-- cách 1:
SELECT *
FROM dbo.LOP
WHERE SISO IN (SELECT MAX(SISO) -- DÙNG "= " VẪN ĐƯỢC
			  FROM dbo.LOP)
--cách 2:			  
SELECT MAX( SISO) AS 'LOP DONG NHAT' -- nhớ là khi mà chỉ có thống kê thôi mà không có các thuộc tính đi kèm ở select thì KO phải có GROUP BY 
FROM dbo.LOP	

-- cách 3: top 1
SELECT TOP 1 *
FORM dbo.LOP
ORDER BY SISO DESC   

-- cách 4: 
SELECT * 
FROM dbo.LOP 
WHERE SISO >= ALL(SELECT SISO FROM dbo.LOP)  	   
			  
-- Câu 6: Cho biết học viên vừa học môn có tên là tin học căn bản 1, vừa học môn có tên là Lập trình căn bản

--Cách 1: 
SELECT *	
FROM dbo.MONHOC JOIN dbo.KETQUATHI ON KETQUATHI.MAMH = MONHOC.MAMH JOIN dbo.HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV   
WHERE TENMH LIKE N'tin học căn bản 1' 
INTERSECT -- Giao 2 bảng truy vấn
SELECT *	
FROM dbo.MONHOC JOIN dbo.KETQUATHI ON KETQUATHI.MAMH = MONHOC.MAMH JOIN dbo.HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV   
WHERE TENMH LIKE N'Lập trình căn bản' 
        
-- Cách 2: 
SELECT  dbo.HOCVIEN.*
FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH
WHERE TENMH LIKE N'tin học căn bản 1'
	  AND HOCVIEN.MAHV IN (SELECT HOCVIEN.MAHV
						   FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV     
						   WHERE TENMH LIKE N'lập trình căn bản')

-- câu 7: Cho biết giáo viên có mức lương thấp nhất
--CÁCH 1:
SELECT * 
FROM dbo.GIAOVIEN
WHERE MUCLUONG = (SELECT MIN(MUCLUONG) FROM dbo.GIAOVIEN)
--CÁCH 2:
SELECT *
FROM dbo.GIAOVIEN 
WHERE MUCLUONG <= ALL(SELECT MUCLUONG FROM dbo.GIAOVIEN)
--CÁCH 3: 
SELECT MAGV, HOTEN, MIN( MUCLUONG) AS 'LUONG THAP NHAT' 	
FROM dbo.GIAOVIEN 
GRUOP BY MAGV, HOTEN

-- Câu 8: Với mỗi giáo viên, cho biết số lớp học đã giảng dạy trong mỗi học kỳ của năm 2020, thông tin: magv, hoten, hocky, solopdagiangday
SELECT G.MAGV, G.HOTEN, HOCKI, COUNT ( *) AS'solopdagiangday'  
FROM dbo.GIAOVIEN G JOIN dbo.GIANGDAY GD ON GD.MAGV = G.MAGV
GROUP BY G.MAGV, G.HOTEN, HOCKI

-- Câu 9: Với mỗi học viên, cho biết số lượng môn học đã tham gia học tập, thông tin: mahv, ho va ten, ngaysinh, số môn học đã tham gia
SELECT HOCVIEN.MAHV, HO + ' ' + TEN AS'HỌ VÀ TÊN', NGSINH, COUNT( MONHOC.MAMH) AS'số môn học đã tham gia' 
FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH  
GROUP BY HOCVIEN.MAHV, HO + ' ' + TEN, NGSINH

-- Câu 10: Với mỗi học viên, cho biết số lượng môn học đã bị nợ môn, thông tin: mahv, hovaten, soMonHocCanTraNo thi lại tối đa 2 lần thôi
SELECT HOCVIEN.MAHV, HO + ' ' + TEN AS'hovaten', COUNT( DIEM) AS'soMonHocCanTraNo' 
FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV 
WHERE DIEM < 5 
GROUP BY HOCVIEN.MAHV,  HO + ' ' + TEN
HAVING COUNT( DIEM) > 2

-- Câu 11: Với mỗi môn học, cho biết số lượng học viên tham gia, thông tin: mamh, tenmh, sohvThamgia
SELECT KETQUATHI.MAMH, TENMH, COUNT( HOCVIEN.MAHV) AS'sohvThamgia' 
FROM dbo.MONHOC JOIN dbo.KETQUATHI ON KETQUATHI.MAMH = MONHOC.MAMH JOIN dbo.HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV   
GROUP BY KETQUATHI.MAMH, TENMH

-- CÂU 12: Cho biết các môn học chưa được triển khai giảng dạy
SELECT * 
FROM dbo.MONHOC JOIN dbo.KETQUATHI ON KETQUATHI.MAMH = MONHOC.MAMH
WHERE MONHOC.MAMH NOT IN (SELECT MAMH FROM dbo.KETQUATHI)

-- CÂU 13: Cho biết các giáo viên đã giảng dạy trên 2 môn học, magv, hoten, SoMonGiangDay
SELECT GIANGDAY.MAGV , HOTEN, COUNT( MAMH) AS'SoMonGiangDay'
FROM dbo.GIAOVIEN JOIN dbo.GIANGDAY ON GIANGDAY.MAGV = GIAOVIEN.MAGV  
GROUP BY GIANGDAY.MAGV , HOTEN
HAVING COUNT( MAMH) > 2

-- CÂU 14: Cho biết các môn học chưa được tổ chức giảng dạy trong năm 2020 
SELECT * 
FROM dbo.MONHOC JOIN dbo.GIANGDAY ON GIANGDAY.MAMH = MONHOC.MAMH 
WHERE MONHOC.MAMH NOT IN (SELECT MAMH FROM dbo.GIANGDAY) AND NAM = 2020

-- CÂU 15: Cho biết các giáo viên chưa giảng dạy trong năm 2020 
SELECT * 
FROM dbo.GIAOVIEN JOIN dbo.GIANGDAY ON GIANGDAY.MAGV = GIAOVIEN.MAGV
WHERE GIAOVIEN.MAGV NOT IN (SELECT MAGV FROM dbo.GIANGDAY) AND NAM = 2020

-- CÂU 16: Cho biết danh sách các giảng viên tham gia giảng dạy cả 2 môn Lập trình căn bản và lập trình nâng cao
SELECT dbo.GIAOVIEN.* 
FROM dbo.GIAOVIEN JOIN dbo.GIANGDAY ON GIANGDAY.MAGV = GIAOVIEN.MAGV JOIN dbo.MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH
WHERE TENMH LIKE N'LẬP TRÌNH CĂN BẢN' 
	  AND GIAOVIEN.MAGV IN (SELECT MAGV 
							FROM dbo.GIANGDAY JOIN dbo.MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH  
							WHERE TENMH LIKE N'LẬP TRÌNH NÂNG CAO')
							
-- CÂU 17: Cho biết các giảng viên giảng dạy môn Lập trình căn bản nhưng không giảng dạy môn Lập trình nâng cao							    
SELECT dbo.GIAOVIEN.* 
FROM dbo.GIAOVIEN JOIN dbo.GIANGDAY ON GIANGDAY.MAGV = GIAOVIEN.MAGV JOIN dbo.MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH
WHERE TENMH LIKE N'LẬP TRÌNH CĂN BẢN' 
	  AND GIAOVIEN.MAGV NOT IN (SELECT MAGV 
							    FROM dbo.GIANGDAY JOIN dbo.MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH  
							    WHERE TENMH LIKE N'LẬP TRÌNH NÂNG CAO')

-- CÂU 18: Cho biết các học viên đã tham gia học tập trên 3 môn, mahv, ho, ten, soMHDaThamgia
SELECT HOCVIEN.MAHV, HO + ' ' + TEN AS'HỌ VÀ TÊN', NGSINH, COUNT( MONHOC.MAMH) AS'số môn học đã tham gia ' 
FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH  
GROUP BY HOCVIEN.MAHV, HO + ' ' + TEN, NGSINH
HAVING COUNT( MONHOC.MAMH) > 3


-- TEST THỬ CÁC LỆNH HỆ THỐNG 
SELECT * FROM dbo.HOCVIEN
PRINT @@ROWCOUNT  
-- CÂU LỆNH IF
IF EXISTS (SELECT MAHV FROM dbo.HOCVIEN WHERE NGSINH = 5)
BEGIN	
	PRINT'CHUC MUNG SINH NHAT HOC VIEN SINH THANG 5'
	SELECT * FROM dbo.HOCVIEN WHERE NGSINH = 5 
END
ELSE
	PRINT N'KHÔNG CÓ HV SINH THANG 5'
-- ĐIỀU KIỆN WHILE
DECLARE @A INT =1
WHILE @A <= 5
BEGIN 
	PRINT @A
	SET @A = @A +1
END

-- sử dụng lệnh sử lí ngoại lệ 
BEGIN TRY
	INSERT INTO HOCVIEN ( MAHV, TEN)
	VALUES('001','TOAN')
	INSERT INTO HOCVIEN ( MAHV, TEN) -- LỖI TRÙNG KHOA CHÍNH
	VALUES('001','TOAN')
END TRY
BEGIN CATCH
	PRINT 'Error Number:' + CAST(ERROR_NUMBER()as varchar(10))-- CHUYỂN SỐ THÀNH CHUỔI VÀ HÀM CONVERT CHUYỂN CHỮ THÀNH SỐ
	PRINT 'Error Message:' + ERROR_MESSAGE()
	PRINT 'Error Severity:' + CAST(ERROR_SEVERITY()as varchar(10))
	PRINT 'Error State:' + CAST(ERROR_STATE()as varchar(10))
	PRINT 'Error Line:' + CAST(ERROR_LINE()as varchar(10))
	PRINT 'Error Procedure:' + ISNULL(ERROR_PROCEDURE(),'not in procedure')
END CATCH

-- ví dụ:
BEGIN 
SELECT HOCVIEN.MAHV, HO + '  '+ TEN AS HOTENHV,NGSINH,
CASE 
	WHEN DIEM >=8 THEN N'XUAT SAC'
	WHEN DIEM >=7 THEN N'KHA'
	WHEN DIEM >=5 THEN N'TRUNG BINH'
	ELSE N'YEU'
END AS XEPLOAI
FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV 
END
-- Tạo 1 thủ tục
-- Viết 1 thủ tục có tên là sp_dssinhnhatthang, in ra danh sach hoc vien co ngày sinh nhật trong tháng là tham số được truyền vào
 
ALTER PROCEDURE sp_dssinhnhatthang @NGAYSINH SMALLDATETIME  
AS
BEGIN
	
	PRINT N'SINH VIÊN SINH NHẬT TRONG NGÀY NÀY LÀ: '
	SELECT * FROM dbo.HOCVIEN WHERE NGSINH = @NGAYSINH
END

sp_dssinhnhatthang '20010512'

-- LÀM BÀI PHÉP CHIA

ALTER PROC sp_Phep_tinh @a INT, @b INT, @c VARCHAR(1)
AS 
BEGIN TRY 
		BEGIN PRINT 
				CASE 
					WHEN @c LIKE '+' THEN @a + @b
					WHEN @c LIKE '-' THEN @a - @b
					WHEN @c LIKE 'x' THEN @a * @b
					WHEN @c LIKE '/' THEN @a / @b
					ELSE  N'PHÉP TOÁN SAI'
				END	
		END
END TRY
BEGIN CATCH 
			BEGIN
				 PRINT N'KHÔNG THỰC HIỆN ĐƯỢC PHÉP CHIA ' + CONVERT( VARCHAR(2), @a) + ' CHO 0' 
			END

END CATCH
 
 sp_Phep_tinh 10, 0, '/'


 -- BÀI TẬP VỀ NHÀ 3 --> 6
 -- Câu 3: Nhập thêm bảng môn học 
ALTER PROC sp_them_mh(@mamh VARCHAR(10),
					   @tenmh VARCHAR(40),
					   @tclt TINYINT,
					   @tcth TINYINT,   	
					   @makhoa VARCHAR(4))
AS
BEGIN
	IF EXISTS (SELECT MAMH FROM dbo.MONHOC WHERE @mamh = MAMH)
		PRINT N'MÔN HỌC NÀY ĐÃ TỒN TẠI'
	ELSE
	BEGIN
		IF EXISTS (SELECT MAKHOA FROM dbo.KHOA WHERE @makhoa = MAKHOA) 
		BEGIN   
			PRINT N'BẠN VỪA THÊM DỮ LIỆU VÀO BẢNG MÔN HỌC BẠN CÓ THỂ SỬ DỤNG CÂU LỆNH: "SELECT * FROM dbo.MONHOC" ĐỂ XEM DỮ LIỆU'
			INSERT INTO MONHOC(MAMH, TENMH, TCLT, TCTH, MAKHOA)
			VALUES (@mamh, @tenmh, @tclt, @tcth, @makhoa)
		END
		ELSE PRINT N'MÃ KHOA NÀY CHƯA TỒN TẠI'
	END
END 

sp_them_mh '001', 'HQTCSDL', 3, 2, 'CNTT'

-- Câu 4:
CREATE PROC sp_diemthi @mamh VARCHAR(10)
AS 
BEGIN 
	SELECT HOCVIEN.MAHV, HO + '  '+ TEN AS HOTENHV,NGSINH, CASE WHEN DIEM >= 8 THEN	N'XUẤT SẮC'
																WHEN DIEM >= 7 THEN	N'KHÁ'
																WHEN DIEM >= 5 THEN	N'TRUNG BÌNH'
																ELSE N'YẾU'
															END AS XEPLOAI
	FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV
	WHERE MAMH = @mamh  
END	

sp_diemthi '001'

-- Câu 5: 
CREATE PROC sp_ds_sv_xuatsac @mamh VARCHAR(10)
AS
BEGIN 
	IF @mamh IN ( SELECT MAMH  
				  FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV 
				  WHERE DIEM >=8 )
		BEGIN
			PRINT N'DANH SÁCH NHỮNG SINH VIÊN XUẤT SẮC'
			SELECT dbo.HOCVIEN.* 
			FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV 
			WHERE DIEM >=8
		END
	ELSE
		PRINT N'KHÔNG CÓ SINH VIÊN XUẤT SẮC'
END 	

sp_ds_sv_xuatsac '001' 		 

--Câu 6:
CREATE PROC sp_ds_sv_khoa @makhoa VARCHAR(4) 
AS
BEGIN 
	 IF @makhoa IN (SELECT MAKHOA FROM	dbo.KHOA)
		SELECT dbo.HOCVIEN.*
		FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH JOIN dbo.KHOA ON KHOA.MAKHOA = MONHOC.MAKHOA 
		WHERE KHOA.MAKHOA = @makhoa   
	ELSE
		PRINT N'KHÔNG CÓ MÃ MÔN HỌC NÀY'
END

sp_ds_sv_khoa 'CNTT'


-- Câu: Tính tổng các số tự nhiên từ 1 đến n (n là tham số đầu vào, kết quả được ghi nhận ở 1 tham số output)

CREATE PROC SP_Tong2 @n int, @ketqua INT OUTPUT
AS
BEGIN
	DECLARE @k int = 1
	SET @ketqua=0
	WHILE @k < = @n
		BEGIN
			SET @Ketqua = @Ketqua + @k;
			SET @k = @k + 1 ;
		END
END

DECLARE @ketqua int
EXEC SP_Tong2 100 , @ketqua OUTPUT
SELECT @ketqua

-- Câu 7: 
CREATE PROC sp_tk_sv @makhoa VARCHAR(4)
AS
BEGIN 
	IF @makhoa IN (SELECT MAKHOA FROM dbo.KHOA)
		BEGIN
			PRINT N'THÔNG TIN KHOA' + @makhoa	
			SELECT TENKHOA, COUNT( HOCVIEN.MAHV ) AS N'Số lượng sinh viên' 
			FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH JOIN dbo.KHOA ON KHOA.MAKHOA = MONHOC.MAKHOA 
			WHERE @makhoa = KHOA.MAKHOA
			GROUP BY TENKHOA
		END
	ELSE PRINT N'KHÔNG TỒN TẠI KHOA '+ @makhoa  +' NÀY' 
END 

EXEC sp_tk_sv '001'

-- NGUYỄN VĂN TOÀN

-- câu 8: 

ALTER PROC sp_bd_sv @mahv CHAR(5) 
AS 
BEGIN 
	IF @mahv IN( SELECT MAHV FROM dbo.HOCVIEN)
		BEGIN
			IF @mahv IN ( SELECT * FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV WHERE DIEM IS NOT NULL)
				SELECT TENMH, dbo.KETQUATHI.* 
				FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH
				WHERE @mahv = HOCVIEN.MAHV  
			ELSE PRINT N'Sinh viên chưa có kết quả học tập'
		END 
	ELSE PRINT N'Không tìm thấy mã số này'		
END 

EXEC sp_bd_sv 'hv001'

-- câu 9:

CREATE PROC sp_mh_chuandk 
AS 
BEGIN
	(SELECT MAMH, TENMH  
	FROM dbo.MONHOC)
	EXCEPT
	(SELECT MONHOC.MAMH, TENMH  
	FROM dbo.HOCVIEN JOIN dbo.KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV JOIN dbo.MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH)    
END


