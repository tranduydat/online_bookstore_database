USE master;
GO
DROP DATABASE IF EXISTS [DB_SE1427_TEAM4_DatTD_DungNT_DatNT_VuTH];
GO
CREATE DATABASE [DB_SE1427_TEAM4_DatTD_DungNT_DatNT_VuTH];
GO
USE [DB_SE1427_TEAM4_DatTD_DungNT_DatNT_VuTH];
GO

IF OBJECT_ID('Authors','U') IS NOT NULL
	DROP TABLE Authors;
GO
CREATE TABLE Authors (
	[Author_ID] VARCHAR(255) NOT NULL PRIMARY KEY,
	[Author_Thumbnail] VARCHAR(255),
	[Author_Name] NVARCHAR(100) NOT NULL,
	[Biography] NTEXT,
	[Author_Slug] VARCHAR(255) NOT NULL,
	[Is_Translator] BIT NOT NULL DEFAULT 0,
);
GO

IF OBJECT_ID('Publishers','U') IS NOT NULL
	DROP TABLE Publishers;
GO
CREATE TABLE Publishers (
	[Publisher_ID] VARCHAR(255) NOT NULL PRIMARY KEY,
	[Publisher_Thumbnail] VARCHAR(255),
	[Publisher_Name] NVARCHAR(50),
	[Publisher_Description] NTEXT,
	[Slug] NVARCHAR(255) NOT NULL,
);
GO

IF OBJECT_ID('Categories','U') IS NOT NULL
	DROP TABLE Categories;
GO
CREATE TABLE Categories (
	[Category_ID] VARCHAR(255) NOT NULL PRIMARY KEY,
	[Category_Name] NVARCHAR(255),
	[Category_Description] NTEXT,
	[Slug] VARCHAR(255) NOT NULL,
	[Parent_ID] VARCHAR(255) NOT NULL,
	[Number_of_Products] BIGINT DEFAULT 0,
	[Sort_Order] INT NOT NULL DEFAULT 0,
	[Date_Added] DATETIME,
	[Date_Modified] DATETIME,
		CONSTRAINT FK_Categories FOREIGN KEY ([Parent_ID]) REFERENCES Categories([Category_ID])
);
GO

IF OBJECT_ID('Suppliers','U') IS NOT NULL
	DROP TABLE Suppliers;
GO
CREATE TABLE Suppliers (
	[Supplier_ID] INT NOT NULL PRIMARY KEY,
	[Supplier_Name] NVARCHAR(100) NOT NULL,
	[Sup_Contact_Name] NVARCHAR(30),
	[Sup_Contact_Title] NVARCHAR(30),
	[Sup_Work_Phone] VARCHAR(12),
	[Sup_Fax] NVARCHAR(24)
);
GO

IF OBJECT_ID('Products', 'U') IS NOT NULL
	DROP TABLE Products;
GO
CREATE TABLE Products(
	[Product_ID] VARCHAR(255) PRIMARY KEY NOT NULL,
	[Product_Name] NVARCHAR(255) NOT NULL,
	[Product_Thumbnail] VARCHAR(255),
	[Category_ID] VARCHAR(255),
	[Author_ID] VARCHAR(255) NOT NULL,
	[Publisher_ID] VARCHAR(255),
	[Description] NTEXT,
	[Format] VARCHAR(40),
	[Size] FLOAT(20),
	[Weight] FLOAT(20),
	[Page_Number] INT NOT NULL,
	[Quantity_In_Stock] INT NOT NULL,
	[Regular_Price] DECIMAL(19, 4) NOT NULL,
	[Sale_Price] DECIMAL(19, 4) NOT NULL,
	[Date_Published] DATETIME,
	[Date_Modified] DATETIME NOT NULL,
	[Supplier_ID] INT,
		CONSTRAINT FK_Products_Categories FOREIGN KEY ([Category_ID]) REFERENCES Categories([Category_ID]),
		CONSTRAINT FK_Products_Publishers FOREIGN KEY ([Publisher_ID]) REFERENCES Publishers([Publisher_ID]),
		CONSTRAINT FK_Pro_Auth FOREIGN KEY ([Author_ID]) REFERENCES Authors([Author_ID]),
		CONSTRAINT FK_Products_Suppliers FOREIGN KEY ([Supplier_ID]) REFERENCES Suppliers([Supplier_ID])

);
GO

IF OBJECT_ID('Discounts','U') IS NOT NULL
	DROP TABLE Discounts;
GO
CREATE TABLE Discounts (
	[Discount_ID] VARCHAR(255) NOT NULL PRIMARY KEY,
	[Discount_Desc] NTEXT,
	[Type] NVARCHAR(255),
	[Valid_From] DATETIME,
	[Valid_To] DATETIME,
	[Amount] FLOAT,
);


IF OBJECT_ID('User_Addresses','U') IS NOT NULL
	DROP TABLE User_Addresses;
GO
CREATE TABLE User_Addresses (
	[Address_ID] BIGINT NOT NULL PRIMARY KEY,
	[Full_Name] NVARCHAR(100),
	[Phone] VARCHAR(12),
	[Country] NVARCHAR(100),
	[Province] NVARCHAR(150),
	[District] NVARCHAR(255),
	[Building_Name] NVARCHAR(255),
	[Apartment_Number] NVARCHAR(255),
	[Street] NVARCHAR(255),
);
GO
IF OBJECT_ID('Users', 'U') IS NOT NULL
	DROP TABLE Users
GO
CREATE TABLE Users (
	[User_ID] BIGINT NOT NULL PRIMARY KEY,
	[User_Password] VARCHAR(32) NOT NULL,
	[User_Email] NVARCHAR(255) NOT NULL,
	[Gender] VARCHAR(2), 
	[Date_Of_Birth] DATE,
	[Newsletter] BIT DEFAULT 0,
	[Address_ID] BIGINT,
	[Payment_ID] BIGINT,
		CONSTRAINT CHK_Users_Gender CHECK([Gender] IN ('M', 'F')),
		CONSTRAINT FK_User_Address FOREIGN KEY ([Address_ID]) REFERENCES User_Addresses([Address_ID])
);
GO

IF OBJECT_ID('User_Meta', 'U') IS NOT NULL
	DROP TABLE User_Meta
GO
CREATE TABLE User_Meta (
	[UMeta_ID] BIGINT NOT NULL PRIMARY KEY,
	[User_ID] BIGINT NOT NULL,
	[UMeta_Key] VARCHAR(255),
	[UMeta_Value] NTEXT,
		CONSTRAINT FK_User_Meta FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID])
);

IF OBJECT_ID('Payments','U') IS NOT NULL
	DROP TABLE Payments;
GO
CREATE TABLE Payments (
	[Payment_ID] BIGINT NOT NULL PRIMARY KEY,
	[User_ID] BIGINT,
		CONSTRAINT FK_Payments FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID])
);
GO

IF OBJECT_ID('Payment_Meta','U') IS NOT NULL
	DROP TABLE Payment_Meta;
GO
CREATE TABLE Payment_Meta (
	[Pay_Meta_ID] VARCHAR(255) NOT NULL PRIMARY KEY,
	[Payment_ID] BIGINT NOT NULL,
	[Pay_Meta_Key] VARCHAR(255),
	[Pay_Meta_Value] NTEXT,
		CONSTRAINT FK_Payment_Meta_Payments FOREIGN KEY ([Payment_ID]) REFERENCES Payments([Payment_ID])
);
GO

IF OBJECT_ID('Roles','U') IS NOT NULL
	DROP TABLE Roles;
GO
CREATE TABLE Roles(
	[Role_ID] VARCHAR(10) NOT NULL PRIMARY KEY,
	[Role_Name] NVARCHAR(100) NOT NULL
);
GO

IF OBJECT_ID('User_Roles','U') IS NOT NULL
	DROP TABLE User_Roles;
GO
CREATE TABLE User_Roles (
	[Role_ID] VARCHAR(10) NOT NULL,
	[User_ID] BIGINT NOT NULL,
		CONSTRAINT PK_User_Roles PRIMARY KEY (Role_ID, [User_ID]),
		CONSTRAINT FK_UR FOREIGN KEY ([Role_ID]) REFERENCES Roles([Role_ID]),
		CONSTRAINT FK_UR1 FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID])
);
GO

IF OBJECT_ID('Reviews','U') IS NOT NULL
	DROP TABLE Reviews;
GO
CREATE TABLE Reviews (
	[Review_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[User_ID] BIGINT NOT NULL,
	[Product_ID] VARCHAR(255) NOT NULL,
	[Rating] FLOAT NOT NULL DEFAULT 0,
	[Title] NTEXT NOT NULL,
	[Comment] NVARCHAR(250),
	[Is_Approved] BIT NOT NULL DEFAULT 0,
	[Date_Added] DATETIME,
	[Date_Approved] DATETIME,
		CONSTRAINT FK_Review FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID]),
		CONSTRAINT FK_Product FOREIGN KEY ([Product_ID]) REFERENCES Products([Product_ID])
);
GO

IF OBJECT_ID('Site_Options','U') IS NOT NULL
	DROP TABLE Site_Options;
GO
CREATE TABLE Site_Options (
	Option_Key VARCHAR(255) NOT NULL PRIMARY KEY,
	Option_Value NTEXT NOT NULL,
);
GO

IF OBJECT_ID('[Pages]','U') IS NOT NULL
	DROP TABLE [Pages];
GO
CREATE TABLE Pages (
	[Page_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[Page_Name] NVARCHAR(255) NOT NULL,
	[Page_Excerpt] NTEXT,
	[Content] NTEXT,
	[Author_ID] BIGINT,
	[Page_Slug] VARCHAR(255) NOT NULL,
	[Status] VARCHAR(20),
	[Publish_Date] DATETIME,
	[Last_Modified] DATETIME NOT NULL,
		CONSTRAINT FK_Pages_Users FOREIGN KEY ([Author_ID]) REFERENCES Users([User_ID])
);
GO

IF OBJECT_ID('[Page_Meta]','U') IS NOT NULL
	DROP TABLE [Page_Meta];
GO
CREATE TABLE Page_Meta (
	[PMeta_ID] BIGINT NOT NULL PRIMARY KEY,
	[Page_ID] BIGINT NOT NULL,
	[PMeta_Key] VARCHAR(255),
	[PMeta_Value] NTEXT,
		CONSTRAINT FK_Page_Meta FOREIGN KEY ([Page_ID]) REFERENCES Pages([Page_ID])
);

IF OBJECT_ID('Logistic_Companies','U') IS NOT NULL
	DROP TABLE Logistic_Companies;
GO
CREATE TABLE Logistic_Companies (
	[Logistic_Com_ID] INT NOT NULL PRIMARY KEY,
	[Company_Name] NVARCHAR(50) NOT NULL,
	[Contact_Name] NVARCHAR(30),
	[Contact_Title] NVARCHAR(30),
	[Work_Phone] VARCHAR(12),
	[Fax] NVARCHAR(24),
	[Address] NVARCHAR(255),
);
GO

IF OBJECT_ID('Shippers','U') IS NOT NULL
	DROP TABLE Shippers;
GO
CREATE TABLE Shippers(
	[Shipper_ID] BIGINT NOT NULL PRIMARY KEY,
	[Logistic_Com_ID] INT NOT NULL,
	[Shipper_Name] NVARCHAR(50),
	[Shipper_Phone] INT,
		CONSTRAINT FK_Shippers FOREIGN KEY ([Logistic_Com_ID]) REFERENCES Logistic_Companies([Logistic_Com_ID])
);

IF OBJECT_ID('Orders','U') IS NOT NULL
	DROP TABLE Orders;
GO
CREATE TABLE Orders(
	[Order_ID] BIGINT NOT NULL PRIMARY KEY,
	[Order_Date] DATETIME NOT NULL,
	[Shipped_Date] DATETIME NOT NULL,
	[Required_Date] DATE NOT NULL,
	[Status] NVARCHAR(20),
	[Note] NTEXT,
	[User_ID] BIGINT NOT NULL,
		CONSTRAINT FK_Orders_Users FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID])
);
GO

IF OBJECT_ID('Order_Details','U') IS NOT NULL
	DROP TABLE Order_Details;
GO
CREATE TABLE Order_Details(
	[Order_ID] BIGINT NOT NULL,
	[Product_ID] VARCHAR(255) NOT NULL,
	[OrderLine_Number] INT DEFAULT 0 NOT NULL,
	[Quantity_Ordered] INT NOT NULL DEFAULT 0,
	[Price_Each] DECIMAL(19, 2) NOT NULL,
	[Discount_Applied] VARCHAR(255),
	[Shipper_ID] BIGINT NOT NULL,
	[Supplier_ID] INT,
		CONSTRAINT PK_Order_Detail PRIMARY KEY ([Order_ID], [Product_ID]),
		CONSTRAINT FK_Order_Detail_Orders FOREIGN KEY ([Order_ID]) REFERENCES Orders([Order_ID]),
		CONSTRAINT FK_Order_Detail_Shippers FOREIGN KEY ([Shipper_ID]) REFERENCES Shippers([Shipper_ID]),
		CONSTRAINT FK_Order_Detail_Products FOREIGN KEY ([Product_ID]) REFERENCES Products([Product_ID]),
		CONSTRAINT FK_Order_Detail_Discounts FOREIGN KEY ([Discount_Applied]) REFERENCES Discounts([Discount_ID]),
		CONSTRAINT FK_Order_Detail_Suppliers FOREIGN KEY ([Supplier_ID]) REFERENCES Suppliers([Supplier_ID])
);
GO

IF OBJECT_ID('Carts','U') IS NOT NULL
	DROP TABLE Carts;
GO
CREATE TABLE Carts (
	[Cart_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[User_ID] BIGINT NOT NULL,
	[Address_ID] BIGINT NOT NULL,
		CONSTRAINT FK_Carts_Users FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID]),
		CONSTRAINT FK_Carts_User_Addresses FOREIGN KEY ([Address_ID]) REFERENCES User_Addresses([Address_ID])
);
GO

IF OBJECT_ID('Cart_Items','U') IS NOT NULL
	DROP TABLE Cart_Items;
GO
CREATE TABLE Cart_Items (
	[Item_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[Cart_ID] BIGINT NOT NULL,
	[Product_ID] VARCHAR(255) NOT NULL,
	[Quantity] INT NOT NULL DEFAULT 1,
	[Price] DECIMAL (19, 2) NOT NULL DEFAULT 0,
	[Discount_Applied] VARCHAR(255),
	[Date_Added] DATETIME,
	[Date_Modified] DATETIME,
		CONSTRAINT FK_Cart_Items_Carts FOREIGN KEY ([Cart_ID]) REFERENCES Carts([Cart_ID]),
		CONSTRAINT FK_Cart_Items_Products FOREIGN KEY ([Product_ID]) REFERENCES Products([Product_ID]),
		CONSTRAINT FK_Cart_Items_Discounts FOREIGN KEY ([Discount_Applied]) REFERENCES Discounts([Discount_ID]),
);
GO

IF OBJECT_ID('Wishlists','U') IS NOT NULL
	DROP TABLE Wishlists;
GO
CREATE TABLE Wishlists (
	[Wishlist_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[User_ID] BIGINT NOT NULL,
	[Product_ID] VARCHAR(255) NOT NULL,
	[Date_Added] DATETIME NOT NULL DEFAULT GETDATE(),
	[Status] NVARCHAR(20) NOT NULL,
		CONSTRAINT FK_Wishlists_Users FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID]),
		CONSTRAINT FK_Wishlists_Products FOREIGN KEY ([Product_ID]) REFERENCES Products([Product_ID]),
);
GO


--Author
INSERT INTO [dbo].[Authors]([Author_ID],[Author_Thumbnail],[Author_Name],[Biography],[Author_Slug],[Is_Translator])
     VALUES
           (101,'https://www.vinabook.com/tac-gia/nguyen-phong-i12968',N'Nguyên Phong',N'Nguyên Phong tên thật là Vũ Văn Du, sinh năm 1950 tại Hà Nội. Năm 1968, ông rời khỏi Việt Nam, sang Hoa Kỳ du học hai nghành Sinh vật học và Điện toán, sau đó ông sống và làm việc tại Hoa Kỳ cho đến nay','nguyen-phong',0),
           (102,'https://www.vinabook.com/tac-gia/nguyen-nhat-anh-i15512',N'Nguyễn Nhật Ánh',N'Nguyễn Nhật Ánh là tên và cũng là bút danh của một nhà văn Việt Nam chuyên viết cho tuổi mới lớn. Ông sinh ngày 7 tháng 5 năm 1955 tại huyện Thăng Bình, Quảng Nam.','nguyen-nhat-anh',0),
           (103,'https://www.vinabook.com/tac-gia/duong-thuy-1-i1990',N'Dương Thụy',N'Dương Thụy, một trong những nữ tác giả có sách bán chạy hàng đầu Việt Nam. Cô được nhiều độc giả biết đến qua các tựa sách bán chạy như: Bồ câu chung mái vòm, Oxford thân yêu, Nhắm mắt thấy Paris,...','duong-thuy',0),
           (104,'https://www.vinabook.com/tac-gia/nguyen-ngoc-tu-i6323',N'Nguyễn Ngọc Tư',N'Nhà văn nữ Nguyễn Ngọc Tư là một nhà văn trẻ thuộc thế hệ hậu chiến (sinh năm 1976) tại tỉnh miền cuối nước Việt là Cà Mau, lớn lên ở đây, đi làm và viết văn cũng ở đây.','nguyen-ngoc-tu',0),
           (105,'https://www.vinabook.com/tac-gia/nguyen-phong-viet-i24633',N'Nguyễn Phong Việt',N'Nguyễn Phong Việt sinh Năm 1980 tại Tuy Hòa, Phú Yên (cựu học sinh chuyên ban Nguyễn Huệ).','nguyen-phong-viet',0)
GO
--Category
INSERT INTO [dbo].[Categories]([Category_ID],[Category_Name],[Category_Description],[Slug],[Parent_ID],[Number_of_Products],[Sort_Order],[Date_added],[Date_Modified])
     VALUES
           (1,N'Sách văn học trong nước',NULL,'sach-van-hoc-trong-nuoc',1,0,0,NULL,NULL),
           (2,N'Truyện ngắn',NULL,'truyen-ngan',1,0,0,NULL,NULL),
           (3,N'Sách phát triển bản thân',NULL,'sach-phat-trien-ban-than',3,0,0,NULL,NULL),
           (4,N'Sách học làm người',NULL,'sach-hoc-lam-nguoi',3,0,0,NULL,NULL),
           (5,N'Truyện dài',NULL,'truyen-dai',1,0,0,NULL,NULL)
GO
--Publishers
INSERT INTO [dbo].[Publishers]([Publisher_ID],[Publisher_Thumbnail],[Publisher_Name] ,[Publisher_Description],[Slug])
     VALUES
           (10,'https://www.vinabook.com/nha-phat-hanh/nxb-tre',N'NXB Trẻ',N'Nhà xuất bản Trẻ xuất bản sách và văn hóa phẩm các loại, phục vụ chủ yếu cho thanh niên, thiếu nhi,...','nxb-tre'),
           (11,'https://www.vinabook.com/nha-phat-hanh/nxb-hoi-nha-van',N'NXB Hội Nhà Văn',N'Được thành lập năm 1957, hoạt động theo phương thức “sự nghiệp có thu','nxb-hoi-nha-van'),
		   (12,'https://www.vinabook.com/nha-phat-hanh/nxb-phu-nu',N'NXB Phụ Nữ',N'Nhà xuất bản Phụ nữ là cơ quan thông tin, tuyên truyền, giáo dục của Hội Liên hiệp Phụ nữ Việt Nam','nxb-phu-nu'),
           (13,'https://www.vinabook.com/nha-phat-hanh/nxb-tong-hop-tphcm',N'NXB Tổng hợp TP.HCM',N'NXB Tổng Hợp TP.HCM với tên giao dịch Nhà Xuất Bản Tổng Hợp TP.HCM, đã hoạt động hơn 18 năm trong lĩnh vực Hoạt động xuất bản','nxb-tong-hop-tphcm')
GO
--Products
INSERT INTO [dbo].[Products]([Product_ID],[Product_Name],[Product_Thumbnail],[Date_Published],[Date_Modified],[Description],[Format],[Size],[Weight],[Page_Number],[Quantity_In_Stock],[Regular_Price],[Sale_Price],[Publisher_ID],[Category_ID],[Author_ID])
	 VALUES
           (45,'Ticket To Childhood','https://www.vinabook.com/ticket-to-childhood-p85990.html','01-dec-2018','11-dec-2019','The story of a man looking back on his life','Bia mem',20,176,152,100,95000,76000,10,2,102),
		   (46,N'Cung Đường Vàng Nắng','https://www.vinabook.com/cung-duong-vang-nang-bia-mem-p49183.html','01-mar-2015','11-dec-2019',N'Giống nhiều người trẻ hiện đại, Vy - cô gái trong truyện dài "Cung Đường Vàng Nắng" có những suy tư rất "hiện đại" về những sự lựa chọn trong cuộc sống.','Bia mem',20,286,304,100,80000,64000,10,5,103),
           (47,N'Muôn Kiếp Nhân Sinh','https://www.vinabook.com/muon-kiep-nhan-sinh-bia-cung-p91262.html','30-jun-2020','11-dec-2019',N'Cuộc sống quanh ta đầy màu nhiệm, chánh niệm là trái tim của thiền tập, là nguồn năng lượng xuyên suốt không thể thay đổi','Bia cung',24,924,410,20,228000,182000,13,4,101),
           (48,N'Endless Field','https://www.vinabook.com/endless-field-p90281.html','01-nov-2019' ,'11-dec-2019','Endless Field is a tale of Mekong Delta natives' ,'Bia cung' ,20 ,242 ,104 ,110 ,135000 ,108000 ,10 ,2,104),
           (49,N'Mình Sẽ Đi Cuối Đất Cùng Trời','https://www.vinabook.com/minh-se-di-cuoi-dat-cung-troi-p90571.html' ,'11-dec-2019' ,'11-dec-2019' ,'Endless Field is a tale of Mekong Delta natives' ,'Bia mem',18 ,220 ,160 ,130 ,98000 ,84000 ,12 ,1 ,105)

GO
--User address
INSERT INTO [dbo].[User_Addresses]([Address_ID],[Full_Name],[Phone],[Country],[Province],[District],[Building_Name],[Apartment_Number],[Street])
     VALUES
           (1,'Nguyen Van Anh','0377847334','Vietnam','Ha Giang','Dong Van','Bitexco','303','Le Hong Phong'),
		   (2,'Hoang Van Binh','0327446392','Vietnam','Ha Noi','Dong Da',NULL,'97','Hao Nam'),
		   (3,'Le Thi Chanh','0368876687','Vietnam','Ha Noi','Hai Ba Trung',NULL,'303','Le Hong Phong'),
		   (4,'Vu Van Thanh','0344344565','Vietnam','Ha Noi','Hoan Kiem',NULL,'47','Luong Van Can'),
		   (5,'Nguyen Hoang Tuan','0398897753','Vietnam','Ha Noi','Thanh Xuan',NULL,'164','Nguyen Tuan')
GO
--User
INSERT INTO [dbo].[Users]([User_ID],[User_Password],[User_Email],[Gender],[Date_Of_Birth],[Newsletter],[Address_ID],[Payment_ID])
     VALUES
           (123,69696969,'abcxyz@gmail.com','M','26-mar-2003',1,1,4862839998833373),
           (456,12345678,'bovitde@gmail.com','M','14-jul-2003',0,2,4862877546633564),
           (789,11111111,'cayhoala@yahoo.com','F','1-jun-2000',0,3,4862822654436534),
           (987,55667788,'luconha@gmail.com','F','22-nov-1995',0,4,4862774588655532),
           (654,11211311,'boyvjpkute2k@gmail.com','F','11-dec-2004',1,5,4862844326646634)

GO
--Payments
INSERT INTO [dbo].[Payments]([Payment_ID],[User_ID])
     VALUES
           (4862839998833373,123),
           (4862877546633564,456),
		   (4862822654436534,789),
		   (4862774588655532,987),
		   (4862844326646634,654)

GO
--Orders
Insert Into [dbo].[Orders]
([Order_ID], [Order_Date],[Shipped_Date],[Required_Date],[Status],[Note],[User_ID])
VALUES (12,'11-dec-2020','12-dec-2020','13-dec-2020',N'Đang vận chuyển','NO',123),
	   (13,'13-dec-2020','14-dec-2020','15-dec-2020',N'Đang xuất kho','NO',456),
	   (14,'14-dec-2020','15-dec-2020','16-dec-2020',N'Đang vận chuyển','NO',789),
	   (15,'15-dec-2020','16-dec-2020','17-dec-2020',N'Đang vận chuyển','NO',987),
	   (16,'17-dec-2020','18-dec-2020','18-dec-2020',N'Đang vận chuyển','NO',654)
GO
--Logistic
INSERT INTO [dbo].[Logistic_Companies]([Logistic_Com_ID],[Company_Name],[Contact_Name],[Contact_Title],[Work_Phone],[Fax],[Address])
     VALUES
           (1,'Giao hang nhanh','Tran Huy Vu','Director','091245653','02835136013' ,N'405/15 Xô Viết Nghệ Tĩnh, Phường 24, Quận Bình Thạnh, TP HCM'),
		   (2,'Giao hang tiet kiem','Tran Duy Dat','Director','0354664874','0935565775' ,N'Tòa nhà VTV, số 8 Phạm Hùng, phường Mễ Trì, quận Nam Từ Liêm, thành phố Hà Nội, Việt Nam'),
		   (3,'Viettel Post','Nguyen Dinh Vu','Director','091245653','3453262465' ,N'Toà nhà N2, Km số 2, Đại lộ Thăng Long, Phường Mễ Trì, Quận Nam Từ Liêm, Hà Nội'),
		   (4,'VN Post','Hoang Huong Giang','Director','0954434874','0933365575' ,N'Số 05 đường Phạm Hùng - Mỹ Đình 2 - Nam Từ Liêm - Hà Nội - Việt Nam')
GO
--Shipper
INSERT INTO [dbo].[Shippers]([Shipper_ID],[Logistic_Com_ID],[Shipper_Name],[Shipper_Phone])VALUES
           (111,1,'Dong Van Chan',0377443553),
		   (222,2,'Hoang Viet Dung',0323323345),
		   (333,1,'Chu Van An',0936639936),
		   (444,4,'Nguyen Dinh Vu',0328878778),
		   (555,3,'Luong Bang Quang',0988888778)


GO
--Suppliers
INSERT INTO [dbo].[Suppliers]([Supplier_ID],[Supplier_Name],[Sup_Contact_Name],[Sup_Contact_Title],[Sup_Work_Phone],[Sup_Fax])
     VALUES
           (88,'Saigon Books','Nguyen Tien Dat','Director','0902551818','19385385'),
		   (89,'Nha Nam Books','Ngon Phi','Director','01235555858','59235385'),
		   (90,'Fahasha','Nguyen Ngoc Diep','Director','0123456789','36475385'),
		   (91,'Tiki','Luc Van Tien','Director','097255658','592353455'),
		   (92,'Thaiha Books','Diep Phi','Director','0972992992','592433385')

GO
--Order Details
Insert Into [dbo].[Order_Details]
([Order_ID],[Product_ID],[OrderLine_Number],[Quantity_Ordered],[Price_Each],[Discount_Applied],[Shipper_ID],[Supplier_ID])
Values (12,45,0,4,40000,NULL,111,88),
		(13,46,1,5,50000,NULL,222,89),
		(14,47,2,5,50000,NULL,333,90),
		(15,48,3,6,60000,NULL,444,91),
		(16,49,4,7,70000,NULL,555,92)
GO
SET IDENTITY_INSERT [dbo].[Carts] ON
--Cart
GO
Insert Into [dbo].[Carts] ([Cart_ID],[User_ID],[Address_ID])
Values(1021,123,1),
	  (1022,456,2),
	  (1023,789,3),
	  (1024,987,4),
	  (1025,654,5)

GO
--CartItem
Insert INTO [dbo].[Cart_Items] ([Cart_ID],[Product_ID],[Quantity],[Price],[Discount_Applied],[Date_Added],[Date_Modified])
Values (1021,45,0,7800,NULL,'11-dec-2020','12-dec-2020'),
		(1022,46,1,9800,NULL,'12-dec-2020','13-dec-2020'),
		(1023,47,2,5800,NULL,'13-dec-2020','14-dec-2020'),
		(1024,48,3,7800,NULL,'14-dec-2020','15-dec-2020'),
		(1025,49,4,7800,NULL,'15-dec-2020','16-dec-2020')
GO
--Wishlists
Insert Into [dbo].[Wishlists] ([User_ID],[Product_ID],[Date_Added],[Status])
Values (123,45,'11-April-2020','ĐL'),
		(456,46,'18-April-2020','HL'),
		(789,47,'19-April-2020','KO'),
		(987,48,'14-April-2020','BM'),
		(654,49,'13-April-2020','ĐL')

GO
--Discount
INSERT INTO [dbo].[Discounts]([Discount_ID],[Discount_Desc],[Type],[Valid_From],[Valid_To],[Amount])
     VALUES
           (1,'Giam gia mua he','Giam gia','15-july-2020','15-oct-2020',50),
		   (2,'Giam gia gio vang','Giam gia','15-july-2020','15-oct-2020',70),
		   (3,'Phieu mua hang','Phieu mua hang','15-july-2020','15-oct-2020',100),
		   (4,'Giam gia do tre em','Giam gia','15-july-2020','15-oct-2020',30),
		   (5,'Giam gia do choi','Giam gia','15-july-2020','15-oct-2020',40)
GO
--Roles
INSERT INTO [dbo].[Roles]([Role_ID],[Role_Name])
     VALUES
           (1, 'Director'),
		   (2, 'Employee'),
		   (3, 'Manager'),
		   (4, 'Supervisor'),
		   (5, 'User')

	GO	   
--User_Roles
INSERT INTO [dbo].[User_Roles]([Role_ID],[User_ID])
     VALUES
           (1 ,123),
		   (2 ,789),
		   (3 ,456),
		   (4 ,654),
		   (5 ,987)


GO
--Review
INSERT INTO [dbo].[Reviews]([User_ID],[Product_ID],[Rating],[Title],[Comment],[Is_Approved],[Date_Added],[Date_Approved])
     VALUES
           (123,45,5,N'Review qua quyển sách mình vừa đọc :)',N'Sau khi đọc quyển sách này, mình cảm thấy cơ thể mình như được làm tươi mới, rất thích hợp để đọc khi đi ngủ',1,'30-jul-2020','31-jul-2020'),
		   (456,46,4,N'Sách hay, không đọc phí thanh xuân',N'Mình mua quyển sách được 1 tuần và thấy rất ưng, bạn có thể đọc một mình hoặc đọc cùng người yêu để làm tăng thêm không khí lãng mạn',1,'30-jul-2020','31-jul-2020'),
		   (789,47,3,N'Bình thường, không thú vị cho lắm',N'Mình mua vì giới thiệu ngoài bìa hay, cơ mà hơi thất vọng',1,'30-jul-2020','31-jul-2020'),
		   (987,48,4,N'Cũng được', N'Sách khá thú vị cho bạn nào chưa có người yêu',1,'30-jul-2020','31-jul-2020'),
		   (654,49,5,N'Tuyệt vời',N'Mình cam đoan cuốn sách này hay, các bạn mua sẽ không cảm thấy phí tiền',1,'30-jul-2020','31-jul-2020')


----------------------------PROCEDURES-----------------------------
-- Search products by given name (as parameter)
IF OBJECT_ID('usp_Search_Products_By_Name','P') IS NOT NULL
	DROP PROCEDURE usp_Add_Products_By_Name
GO
CREATE PROCEDURE usp_Add_Products_By_Name
	@productName NVARCHAR(255)
AS
BEGIN
	SELECT *
	FROM Products prd
	WHERE prd.[Product_ID] = @productName
END;
GO

-- List out of stock products
IF OBJECT_ID('usp_List_Products_Out_Of_Stock','P') IS NOT NULL
	DROP PROCEDURE usp_List_Products_Out_Of_Stock
GO
CREATE PROCEDURE usp_List_Products_Out_Of_Stock
AS
BEGIN
	SELECT *
	FROM Products prd
	WHERE prd.[Quantity_In_Stock] = 0
END;
GO
 
-- Count and display number of products in each category
IF OBJECT_ID('usp_Count_Products_Each_Category','P') IS NOT NULL
	DROP PROCEDURE usp_Count_Products_Each_Category
GO
CREATE PROCEDURE usp_Count_Products_Each_Category
AS
BEGIN
	SELECT
		cat.Category_ID,
		cat.Category_Name
	FROM Categories cat
	INNER JOIN (
		SELECT
			prd.Category_ID,
			COUNT(*) As NumberOfProducts
		FROM Products prd
		GROUP BY prd.Category_ID
	) T
	ON cat.Category_ID = T.Category_ID
END;
GO

-- Count and display number of products of each publisher
IF OBJECT_ID('usp_Count_Products_Each_Publisher','P') IS NOT NULL
	DROP PROCEDURE usp_Count_Products_Each_Publisher
GO
CREATE PROCEDURE usp_Count_Products_Each_Publisher
AS
BEGIN
	SELECT
		pub.[Publisher_ID],
		pub.[Publisher_Name]
	FROM Publishers pub
	INNER JOIN (
		SELECT
			prd.Publisher_ID,
			COUNT(*) As NumberOfProducts
		FROM Products prd
		GROUP BY prd.Publisher_ID
	) T
	ON pub.Publisher_ID = T.Publisher_ID
END;
GO

-- Count and display number of products of each author
IF OBJECT_ID('usp_Count_Products_Each_Author','P') IS NOT NULL
	DROP PROCEDURE usp_Count_Products_Each_Author
GO
CREATE PROCEDURE usp_Count_Products_Each_Author
AS
BEGIN
	SELECT
		auth.[Author_ID],
		auth.[Author_Name]
	FROM Authors auth
	INNER JOIN (
		SELECT
			prd.Author_ID,
			COUNT(*) As NumberOfWork
		FROM Products prd
		GROUP BY prd.Author_ID
	) T
	ON auth.Author_ID = T.Author_ID
END;
GO


IF OBJECT_ID('usp_Get_Best_Seller_Products_In_Range','P') IS NOT NULL
	DROP PROCEDURE usp_Get_Best_Seller_Products_In_Range
GO
CREATE PROCEDURE usp_Get_Best_Seller_Products_In_Range
	@fromDate DATE,
	@toDate DATE
AS
BEGIN
	SELECT *
	FROM Order_Details
END;
GO

IF OBJECT_ID('TR_PRODUCTS_Check_Regular_Price', 'TR') IS NOT NULL
	DROP TRIGGER TR_PRODUCTS_Check_Regular_Price
GO

CREATE TRIGGER TR_PRODUCTS_Check_Regular_Price
ON Products
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @regular_price DECIMAL(19, 2) = (SELECT inserted.Regular_Price FROM inserted)
	IF @regular_price < 0
	BEGIN
		RAISERROR('Error: The regular price of each product should be larger than or equal to 0', 16, 1)
		ROLLBACK TRAN
	END
END;
GO