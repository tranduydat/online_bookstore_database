CREATE DATABASE [DB_SE1427_TEAM4_DatTD_DungNT_DatNT_VuTH];
GO
USE [DB_SE1427_TEAM4_DatTD_DungNT_DatNT_VuTH];
GO

IF OBJECT_ID('Authors','U') IS NOT NULL
	DROP TABLE Authors;
GO
CREATE TABLE Authors (
	[Author_ID] INT NOT NULL PRIMARY KEY,
	[Author_Thumbnail] VARCHAR(255),
	[Author_Name] NVARCHAR(100) NOT NULL,
	[Biography] NTEXT,
	[Author_Slug] VARCHAR(255) NOT NULL,
	[Is_Translator] BIT NOT NULL DEFAULT 0,
);
GO

IF OBJECT_ID('[Publishers]','U') IS NOT NULL
	DROP TABLE [Publishers];
GO
CREATE TABLE Publishers (
	[Publisher_ID] INT NOT NULL PRIMARY KEY,
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
	[Category_ID] INT NOT NULL,
	[Category_Name] NVARCHAR(255),
	[Category_Description] NTEXT,
	[Slug] VARCHAR(255) NOT NULL,
	[Parent_ID] INT NOT NULL DEFAULT 0,
	[Number_of_Products] BIGINT DEFAULT 0,
	[Sort_Order] INT NOT NULL DEFAULT 0,
	[Date_added] DATETIME,
	[Date_Modified] DATETIME,
		CONSTRAINT PK_Categories PRIMARY KEY ([Category_ID]),
);
GO


IF OBJECT_ID('Products', 'U') IS NOT NULL
	DROP TABLE Products;
GO
CREATE TABLE Products(
	[Product_ID] BIGINT PRIMARY KEY NOT NULL IDENTITY,
	[Product_Name] NVARCHAR(255) NOT NULL,
	[Product_Thumbnail] VARCHAR(255),
	[Date_Published] DATETIME,
	[Date_Modified] DATETIME NOT NULL,
	[Description] NTEXT,
	[Format] VARCHAR(40),
	[Size] FLOAT(20),
	[Weight] FLOAT(20),
	[Page_Number] INT NOT NULL,
	[Quantity_In_Stock] INT NOT NULL,
	[Regular_Price] DECIMAL(19, 4) NOT NULL,
	[Sale_Price] DECIMAL(19, 4) NOT NULL,
	[Publisher_ID] INT,
	[Category_ID] INT,
		CONSTRAINT FK_Products_Categories FOREIGN KEY ([Category_ID]) REFERENCES Categories([Category_ID]),
		CONSTRAINT FK_Products_Publishers FOREIGN KEY ([Category_ID]) REFERENCES Publishers([Publisher_ID]),
);
GO

-----------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('Customer_Addresses','U') IS NOT NULL
	DROP TABLE Customer_Addresses;
GO
CREATE TABLE Customer_Addresses (
	[Address_ID] INT NOT NULL,
	[User_ID] BIGINT NOT NULL,
	[Full_Name] NVARCHAR(100) NOT NULL,
	[Phone] VARCHAR(12) NOT NULL,
	[Country] NVARCHAR(100) NOT NULL,
	[Province] NVARCHAR(150) NOT NULL,
	[Distinct] NVARCHAR(255),
	[Building_Name] NVARCHAR(255),
	[Apartment_Number] NVARCHAR(255),
	[Stress] NVARCHAR(255),
		CONSTRAINT PK_Customer_Addresses PRIMARY KEY ([Address_ID])
);
GO

IF OBJECT_ID('Users', 'U') IS NOT NULL
	DROP TABLE Users
GO
CREATE TABLE Users (
	[User_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[User_Password] VARCHAR(32) NOT NULL,
	[User_Email] NVARCHAR(255) NOT NULL,
	[Gender] VARCHAR(2) NOT NULL, 
	[DateOfBirth] DATE,
	[Newsletter] BIT DEFAULT 0,
	[Address_ID] INT NOT NULL
		CONSTRAINT CHK_Users_Gender CHECK([Gender] IN ('M', 'F'))
		CONSTRAINT FK_Users_Customer_Addressses FOREIGN KEY ([Address_ID]) REFERENCES Customer_Addresses([Address_ID]),
);
GO

-- them vao day boi khong nhan ra bang users neu dat trong phan Customer_Addresses
ALTER TABLE Customer_Addresses
ADD CONSTRAINT FK_Customer_Addresses_Users FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID]);
GO

-- list the roles available for users
IF OBJECT_ID('Roles','U') IS NOT NULL
	DROP TABLE Roles;
GO
CREATE TABLE Roles(
	[Role_ID] INT NOT NULL PRIMARY KEY,
	[Role_Name] NVARCHAR(100) NOT NULL
);
GO

IF OBJECT_ID('User_Roles','U') IS NOT NULL
	DROP TABLE User_Roles;
GO
CREATE TABLE User_Roles (
	[Role_ID] INT NOT NULL,
	[User_ID] BIGINT NOT NULL,
		CONSTRAINT PK_User_Roles PRIMARY KEY (Role_ID, [User_ID]),
		CONSTRAINT FK_UR FOREIGN KEY ([Role_ID]) REFERENCES Roles([Role_ID]),
		CONSTRAINT FK_UR1 FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID])
);
GO

--------------------------------------------------------------------------------------
IF OBJECT_ID('Reviews','U') IS NOT NULL
	DROP TABLE Reviews;
GO
CREATE TABLE Reviews (
	[Review_ID] BIGINT NOT NULL IDENTITY,
	[User_ID] BIGINT NOT NULL,
	[Product_ID] BIGINT NOT NULL,
	[Rating] INT NOT NULL DEFAULT 0,
	[Title] NTEXT NOT NULL,
	[Comment] NVARCHAR(250),
	[Is_Approved] BIT NOT NULL DEFAULT 0,
	[Date_Added] DATETIME,
	[Date_Approved] DATETIME,
		CONSTRAINT PK_Reviews PRIMARY KEY ([User_ID], [Review_ID], [Product_ID]),
		CONSTRAINT FK_Review FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID]),
		CONSTRAINT FK_Product FOREIGN KEY ([Product_ID]) REFERENCES Products([Product_ID])
);
GO
-- TODO: add "meta" relation for reviews to store neccessary information

-----------------------------------------------------------------------------
IF OBJECT_ID('Site_Options','U') IS NOT NULL
	DROP TABLE Site_Options;
GO
CREATE TABLE Site_Options (
	Option_Key BIGINT NOT NULL PRIMARY KEY,
	Option_Value NVARCHAR(255) NOT NULL,
);
GO

-------------------------------------------------------------------------
IF OBJECT_ID('[Pages]','U') IS NOT NULL
	DROP TABLE [Pages];
GO
CREATE TABLE Pages (
	[Page_ID] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[Page_Name] NVARCHAR(255) NOT NULL,
	[Page_Excerpt] NTEXT,
	[Content] NTEXT,
	[Publish_Date] DATETIME,
	[Last_Modified] DATETIME NOT NULL
);
GO
-- TODO: add meta relation for pages
-------------------------------------------------------------------------

IF OBJECT_ID('Payments','U') IS NOT NULL
	DROP TABLE Payments;
GO
CREATE TABLE Payments (
	[Payment_ID] BIGINT NOT NULL,
	[User_ID] BIGINT,
		CONSTRAINT PK_Payments PRIMARY KEY ([Payment_ID], [User_ID]),
		CONSTRAINT FK_Payments FOREIGN KEY ([User_ID]) REFERENCES Users([User_ID])
);
GO

--CREATE TABLE Payment_Meta (
--	[Pay_Meta_ID] BIGINT NOT NULL IDENTITY,
--	[Payment_ID] BIGINT NOT NULL,
--	[Payment_Meta_Key] NVARCHAR(255) NOT NULL,
--	[Payment_Meta_Value] NVARCHAR(255),
--		CONSTRAINT FK_Payment_Meta FOREIGN KEY (Payment_ID)	REFERENCES dbo.Payments(Payment_ID)
--);
--GO


------------------------------------------------------------------------------------------------
IF OBJECT_ID('Orders','U') IS NOT NULL
	DROP TABLE Orders;
GO
CREATE TABLE Orders(
	[Order_ID] BIGINT NOT NULL PRIMARY KEY,
	[Order_Date] DATETIME NOT NULL,
	[Shipper_Date] DATETIME NOT NULL,
	[Required_Date] DATE NOT NULL,
	[Status] NVARCHAR(20),
	[Note] NTEXT,
);
GO

IF OBJECT_ID('OrderDetail','U') IS NOT NULL
	DROP TABLE OrderDetail;
GO
CREATE TABLE Order_Detail(
	[Order_ID] BIGINT NOT NULL PRIMARY KEY,
	[Quantity_Ordered] INT NOT NULL DEFAULT 0,
	[Price_Each] DECIMAL(19, 2) NOT NULL,
	[OrderLine_Number] INT DEFAULT 0,
		CONSTRAINT FK_Order_Detail_Orders FOREIGN KEY ([Order_ID]) REFERENCES Orders([Order_ID])
);
GO

------------------------------------------------------------------------------------------------
IF OBJECT_ID('Ship_Companies','U') IS NOT NULL
	DROP TABLE Ship_Companies;
GO
CREATE TABLE Ship_Companies(
	[ShipCompany_ID] INT NOT NULL PRIMARY KEY,
	[Company_Name] NVARCHAR(50),
	[Work_phone] INT,
	[Address] NVARCHAR(255)
);
GO 

IF OBJECT_ID('Shippers','U') IS NOT NULL
	DROP TABLE Shippers;
GO
CREATE TABLE Shippers(
	[ShipCompany_ID] INT NOT NULL,
	[Shipper_ID] INT NOT NULL,
	[Shipper_Name] NVARCHAR(50),
	[Shipper_Phone] INT,
		CONSTRAINT PK_Shippers PRIMARY KEY ([ShipCompany_ID], [Shipper_ID]),
		CONSTRAINT FK_Shippers FOREIGN KEY ([ShipCompany_ID]) REFERENCES ShipCompany([ShipCompany_ID])
);