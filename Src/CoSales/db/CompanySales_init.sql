USE [master]
GO

-- 判断是否有该数据库，防止重复添加
IF DB_ID('CompanySales') IS NULL
CREATE DATABASE [CompanySales]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CompanySales_data', FILENAME = N'D:\DB\Sales_data.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 15%)
 LOG ON 
( NAME = N'CompanySales_log', FILENAME = N'D:\DB\Sales_log.ldf' , SIZE = 6144KB , MAXSIZE = 30720KB , FILEGROWTH = 1024KB )
GO

USE [CompanySales]
GO


-- 客户
IF OBJECT_ID('T_CUSTOMER') IS NOT NULL
DROP TABLE [dbo].[T_CUSTOMER]
GO
CREATE TABLE [dbo].[T_CUSTOMER]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [CompanyName] [VARCHAR](50) NULL ,
      [ContactName] [CHAR](8) NULL ,
      [Phone] [VARCHAR](20) NULL ,
      [Address] [VARCHAR](100) NULL ,
      [EmailAddress] [VARCHAR](50) NULL
    )
GO

-- 部门
IF OBJECT_ID('T_DEPARTMENT') IS NOT NULL
DROP TABLE [dbo].[T_DEPARTMENT]
GO
CREATE TABLE [dbo].[T_DEPARTMENT]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [DepartmentName] [VARCHAR](30) NULL ,
      [Manager] [CHAR](8) NULL ,
      [Depart_Description] [VARCHAR](50) NULL
    )
GO

-- 员工
IF OBJECT_ID('T_EMPLOYEE') IS NOT NULL
DROP TABLE [dbo].[T_EMPLOYEE]
GO
CREATE TABLE [dbo].[T_EMPLOYEE]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [EmployeeName] [VARCHAR](50) NULL ,
      [Sex] [CHAR](2) NULL ,
      [BirthDate] [SMALLDATETIME] NULL ,
      [HireDate] [SMALLDATETIME] NULL ,
      [Salary] [MONEY] NULL ,
      [DepartmentID] [INT] NULL
    )
GO

-- 产品
IF OBJECT_ID('T_PRODUCT') IS NOT NULL
DROP TABLE [dbo].[T_PRODUCT]
GO
CREATE TABLE [dbo].[T_PRODUCT]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [ProductName] [VARCHAR](50) NOT NULL ,
      [Price] [DECIMAL](18, 2) NULL ,
      [ProductStockNumber] [INT] NULL ,
      [ProductSellNumber] [INT] NULL ,
      [State] [INT] NULL DEFAULT ( 0 )
    )

GO

-- 供应商
IF OBJECT_ID('T_PROVIDER') IS NOT NULL
DROP TABLE [dbo].[T_PROVIDER]
GO
CREATE TABLE [dbo].[T_PROVIDER]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [ProviderName] [VARCHAR](50) NULL ,
      [ContactName] [CHAR](8) NULL ,
      [ProviderAddress] [VARCHAR](100) NULL ,
      [ProviderPhone] [VARCHAR](15) NULL ,
      [ProviderEmail] [VARCHAR](20) NULL
    )

GO

-- 进货订单
IF OBJECT_ID('T_PURCHASE_ORDER') IS NOT NULL
DROP TABLE [dbo].[T_PURCHASE_ORDER]
GO
CREATE TABLE [dbo].[T_PURCHASE_ORDER]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [ProductID] [INT] NULL ,
      [PurchaseOrderNumber] [INT] NULL ,
      [EmployeeID] [INT] NULL ,
      [ProviderID] [INT] NULL ,
      [PurchaseOrderDate] [SMALLDATETIME] NULL
    )

GO

-- 销售订单
IF OBJECT_ID('T_SELL_ORDER') IS NOT NULL
DROP TABLE [dbo].[T_SELL_ORDER]
GO
CREATE TABLE [dbo].[T_SELL_ORDER]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [ProductID] [INT] NULL ,
      [SellOrderNumber] [INT] NULL ,
      [EmployeeID] [INT] NULL ,
      [CustomerID] [INT] NULL ,
      [SellOrderDate] [SMALLDATETIME] NULL
    )

GO

-- 用户上传附件资源
IF OBJECT_ID('T_ATTACHMENT') IS NOT NULL
DROP TABLE [dbo].[T_ATTACHMENT]
GO
CREATE TABLE [dbo].[T_ATTACHMENT]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [AttType] [VARCHAR](20) NULL ,--附件类型
      [RelatedID] [INT] NOT NULL,-- 关联资源ID
	  [AttName] [VARCHAR](100) NULL ,
      [AttPath] [VARCHAR](100) NULL ,
	  [UpTime] [DATETIME] NULL ,
	  [UserID] [INT] NOT NULL,
      [Remark] [VARCHAR](100) NULL
    )
GO

-- 用户
IF OBJECT_ID('T_USER') IS NOT NULL
DROP TABLE [dbo].[T_USER]
GO
CREATE TABLE [dbo].[T_USER]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [UserID] [VARCHAR](100) NULL ,
      [Password] [VARCHAR](100) NULL ,
      [UserName] [VARCHAR](50) NULL ,
      [Gender] [CHAR](2) NULL ,
      [BirthDate] [SMALLDATETIME] NULL ,
      [RoleID] [INT] NULL ,
      [HeadImg] [VARCHAR](100) NULL ,
      [Remark] [VARCHAR](200) NULL
    )
GO

/* 
默认用户（测试用） md5加密后密码，明文为1 
admin 管理员
jack 普通用户
*/
INSERT INTO T_USER ([UserID],[Password],[RoleID]) VALUES('admin','C4CA4238A0B923820DCC509A6F75849B',1)
INSERT INTO T_USER ([UserID],[Password],[RoleID]) VALUES('jack','C4CA4238A0B923820DCC509A6F75849B',0)
GO

-- 系统枚举字典表
IF OBJECT_ID('T_DIC_NODE') IS NOT NULL
DROP TABLE [dbo].[T_DIC_NODE]
GO
CREATE TABLE [dbo].[T_DIC_NODE]
    (
      [ID] [INT] IDENTITY(1,1) PRIMARY KEY ,
      [NodeType] [VARCHAR](20) NULL ,
      [NodeID] [INT] NULL ,
      [NodeName] [VARCHAR](50) NULL ,
      [Remark] [VARCHAR](100) NULL
    )
GO

/* 添加产品状态枚举值 */
INSERT INTO dbo.T_DIC_NODE ( NodeType, NodeID, NodeName, Remark )VALUES  ( 'product', -1, '已删除', '产品状态' )
INSERT INTO dbo.T_DIC_NODE ( NodeType, NodeID, NodeName, Remark )VALUES  ( 'product', 0, '待审核', '产品状态' )
INSERT INTO dbo.T_DIC_NODE ( NodeType, NodeID, NodeName, Remark )VALUES  ( 'product', 1, '正常', '产品状态' )
INSERT INTO dbo.T_DIC_NODE ( NodeType, NodeID, NodeName, Remark )VALUES  ( 'product', 2, '被驳回', '产品状态' )
GO



/*
添加测试数据
*/
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'三川实业有限公司', N'刘明    ', N'030-88355547', N'上海市大崇明路 50 号', N'guy1@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'远东科技有限公司', N'王丽丽  ', N'030-88355547', N'大连市沙河区承德西路 80 号', N'kevin0@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'坦森行贸易有限公司', N'王炫皓  ', N'0321-88755539', N'上海市黄台北路 780 号', N'roberto0@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'国顶有限公司', N'方小峰  ', N'0571-87465557', N'杭州市海淀区天府东街 30 号', N'rob0@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'通恒机械有限公司', N'黄国栋  ', N'0921-85791234', N'天津市南开区东园西甲 30 号', N'robme@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'森通科技有限公司', N'张孔苗  ', N'030-88300584', N'大连市沙河区常保阁东 80 号', N'yund@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'国皓科技有限公司', N'黄雅玲  ', N'0671-68788601', N'杭州市海淀区广发北路 10 号', N'yalin@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'迈多贸易科技有限公司', N'李丽珊  ', N'0533-87855522', N'天津市南开区临翠大街 80 号', N'lishan@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'祥通科技有限公司', N'姚苗波  ', N'0678-85912445', N'大连市沙河区花园东街 90 号', N'miaopo@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'广通网络信息有限公司', N'谢久久  ', N'0478-85955547', N'大连市沙河区平谷嘉石大街 38 号', N'jiujiu@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'光明杂志社', N'谢丽秋  ', N'0571-87545551', N'上海市黄石路 50 号', N'liqiu@163.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'威航货运有限公司', N'黄小欧  ', N'0610-80113555', N'天津市经七纬二路 13 号', N'xiaoou@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'三捷实业有限公司', N'徐慧    ', N'0616-86155533', N'重庆市英雄山路 84 号', N'xuhui@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'浩天旅行社', N'洪瑞强  ', N'0306-67300765', N'杭州市海淀区白广路 314 号', N'huidf@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'同恒软件有限公司', N'陈云海  ', N'0306-78355576', N'天津市七一路 37 号', N'yunhai@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'万海房产有限公司', N'台融岛  ', N'0717- 87455522', N'天津市劳动路 23 号', N'rongdo@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'世邦房产有限公司', N'高强    ', N'0241- 83410391', N'天津市南开区光明东路 395 号', N'gaoq@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'迈策船舶有限公司', N'郑莉晓  ', N'0567-56306788', N'天津市南开区沉香街 329 号', N'lixiao@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'中通软件有限公司', N'张小平  ', N'0307- 45555502', N'厦门市光复北路 895 号', N'xiaopin@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'正人资源有限公司', N'张耀    ', N'0571-45576753', N'杭州市临江东街 62 号', N'zhanoq@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'红阳事业有限公司', N'杨晓鹏  ', N'0571-45275559', N'杭州市海淀区外滩西路 238 号', N'zgab1@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'嘉元实业有限公司', N'李霞    ', N'0919-87255594', N'武汉市东湖大街 28 号', N'xiao34@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'嘉业房产有限公司', N'黄丹和  ', N'0321-78820161', N'瑞安市经三纬二路 8 号', N'danhe@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'五洲信托投资有限公司', N'张玉    ', N'0876-67695346', N'天津市沿江北路 942 号', N'zhany34@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'友恒信托投资有限公司', N'戴瑶    ', N'0896-67387731', N'天津市经二路 9 号', N'dail4@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'国银贸易有限公司', N'吴晓贵  ', N'0876-76703221', N'福州市嘉禾区辅城街 42 号', N'xiaogui@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'文成软件有限公司', N'汤蓬蓬  ', N'0569-67349882', N'福州市嘉禾区临江街 32 号', N'penpen@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'康浦房产有限公司', N'黄振    ', N'0687- 67435425', N'厦门市授业路 361 号', N'huangzheng@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'东旗有限公司', N'莫笑笑  ', N'0571-26760334', N'温州市尊石路 238 号', N'xiao3@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'建资房产有限公司', N'赵凯    ', N'0922-67755582', N'广州市广惠东路 38 号', N'zhaokai@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'温州中学', N'李德奇  ', N'0577-68235423', N'温州市市府路23号', N'deqi4@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'均瑶航空公司', N'何燕    ', N'0577-82635423', N'温州市学院路24号', N'heyan3@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'清华大学出版社', N'李明明  ', N'010-92929332', N'北京市朝阳路23号', N'mingmin3@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'北京秦峰昕鑫商贸有限公司', N'李俊峰  ', N'0135-53583789', N'北京市 北京复兴路83号东九楼504大厦１8c', N'rr45@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'深圳市金丰达科技有限公司', N'董小姐  ', N'0755-83789290', N'中国 广东 深圳市 福田区福华路２９号京海大厦１８Ｃ', N'hjyu7@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'上海友谊卷笔刀有限公司', N'马颖达  ', N'021-58033688', N'上海市南汇区南六公路1125弄三灶工业园区发展西路11号', N'5er6@mail.zjitc.com')
INSERT [dbo].[T_CUSTOMER] ([CompanyName], [ContactName], [Phone], [Address], [EmailAddress]) VALUES (N'林川中学', N'毛梅捷  ', N'13858235423', N'新居市学院路24号', N'lincun@lczxmail.com.cn')
GO

INSERT [dbo].[T_DEPARTMENT] ([DepartmentName], [Manager], [Depart_Description]) VALUES (N'销售部', N'王丽丽  ', N'主管销售')
INSERT [dbo].[T_DEPARTMENT] ([DepartmentName], [Manager], [Depart_Description]) VALUES (N'采购部', N'李嘉明  ', N'主管公司的产品采购')
INSERT [dbo].[T_DEPARTMENT] ([DepartmentName], [Manager], [Depart_Description]) VALUES (N'人事部', N'蒋柯南  ', N'主管公司的人事关系')
INSERT [dbo].[T_DEPARTMENT] ([DepartmentName], [Manager], [Depart_Description]) VALUES (N'后勤部', N'张绵荷  ', N'主管公司的后勤工作')
GO

INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'章宏', N'男', CAST(0x639E0000 AS SmallDateTime), CAST(0x96460000 AS SmallDateTime), 3100.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'李立三  ', N'女', CAST(0x72A80000 AS SmallDateTime), CAST(0x93070000 AS SmallDateTime), 3460.2000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'王孔若  ', N'女', CAST(0x6AF20000 AS SmallDateTime), CAST(0x8F8B0000 AS SmallDateTime), 3800.8000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'余杰    ', N'男', CAST(0x68E60000 AS SmallDateTime), CAST(0x92900000 AS SmallDateTime), 3315.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'蔡慧敏  ', N'男', CAST(0x52320000 AS SmallDateTime), CAST(0x90E40000 AS SmallDateTime), 3453.7000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'孔高铁  ', N'男', CAST(0x6AD40000 AS SmallDateTime), CAST(0x8FA90000 AS SmallDateTime), 3600.5000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'姚晓力  ', N'女', CAST(0x63530000 AS SmallDateTime), CAST(0x90E00000 AS SmallDateTime), 3313.8000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'宋振辉  ', N'男', CAST(0x6B880000 AS SmallDateTime), CAST(0x8FE70000 AS SmallDateTime), 3376.6000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'刘丽    ', N'男', CAST(0x56830000 AS SmallDateTime), CAST(0x91950000 AS SmallDateTime), 3421.9000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'姜玲娜  ', N'女', CAST(0x72F90000 AS SmallDateTime), CAST(0x98180000 AS SmallDateTime), 3200.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'崔军利  ', N'男', CAST(0x5EF50000 AS SmallDateTime), CAST(0x94540000 AS SmallDateTime), 3392.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'金林皎  ', N'男', CAST(0x61EE0000 AS SmallDateTime), CAST(0x914E0000 AS SmallDateTime), 3366.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'唐军芳  ', N'男', CAST(0x6FEE0000 AS SmallDateTime), CAST(0x94D10000 AS SmallDateTime), 3304.1000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'郑阿齐  ', N'女', CAST(0x56720000 AS SmallDateTime), CAST(0x94860000 AS SmallDateTime), 3409.8000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'刘启芬  ', N'男', CAST(0x65210000 AS SmallDateTime), CAST(0x911F0000 AS SmallDateTime), 3432.5000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'吴昊    ', N'男', CAST(0x5AE10000 AS SmallDateTime), CAST(0x92EB0000 AS SmallDateTime), 3361.3000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'何文华  ', N'女', CAST(0x5CC90000 AS SmallDateTime), CAST(0x92E70000 AS SmallDateTime), 3306.2000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'李萍    ', N'女', CAST(0x6A090000 AS SmallDateTime), CAST(0x93580000 AS SmallDateTime), 3295.7000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'宋广科  ', N'男', CAST(0x5D700000 AS SmallDateTime), CAST(0x93CE0000 AS SmallDateTime), 3384.5000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'罗耀祖  ', N'女', CAST(0x6B520000 AS SmallDateTime), CAST(0x937C0000 AS SmallDateTime), 3286.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'吴晓松  ', N'男', CAST(0x63DB0000 AS SmallDateTime), CAST(0x92800000 AS SmallDateTime), 3282.5000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'钱其娜  ', N'女', CAST(0x5CAC0000 AS SmallDateTime), CAST(0x91BA0000 AS SmallDateTime), 3378.3000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'章明铁  ', N'女', CAST(0x52F60000 AS SmallDateTime), CAST(0x902C0000 AS SmallDateTime), 3400.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'张晓明  ', N'男', CAST(0x55AB0000 AS SmallDateTime), CAST(0x920D0000 AS SmallDateTime), 3376.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'李丽丽  ', N'男', CAST(0x597B0000 AS SmallDateTime), CAST(0x955A0000 AS SmallDateTime), 3408.8000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'欧阳天民', N'女', CAST(0x5B9B0000 AS SmallDateTime), CAST(0x95420000 AS SmallDateTime), 3359.9000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'陈晓东  ', N'女', CAST(0x66E60000 AS SmallDateTime), CAST(0x918C0000 AS SmallDateTime), 3374.2000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'金恰亦  ', N'女', CAST(0x58060000 AS SmallDateTime), CAST(0x932F0000 AS SmallDateTime), 3318.5000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'王辉    ', N'男', CAST(0x731E0000 AS SmallDateTime), CAST(0x966A0000 AS SmallDateTime), 3450.0000, 3)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'柯小於', N'男', CAST(0x87870260 AS SmallDateTime), CAST(0x9A790260 AS SmallDateTime), 3566.0000, 3)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'吴玲    ', N'女', CAST(0x70F40000 AS SmallDateTime), CAST(0x96980000 AS SmallDateTime), 3410.0000, 3)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'任洁    ', N'女', CAST(0x75590000 AS SmallDateTime), CAST(0x96980000 AS SmallDateTime), 3340.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'洪皓    ', N'男', CAST(0x5FF30000 AS SmallDateTime), CAST(0x90E30000 AS SmallDateTime), 3410.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'金圆圆  ', N'女', CAST(0x72600000 AS SmallDateTime), CAST(0x96980000 AS SmallDateTime), 3410.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'柯敏    ', N'女', CAST(0x760F0000 AS SmallDateTime), CAST(0x975C0000 AS SmallDateTime), 3410.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'姚安娜', N'女', CAST(0x76DE053A AS SmallDateTime), CAST(0x9A8A053A AS SmallDateTime), 3456.0000, 3)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'张希希', N'男', CAST(0x6F850000 AS SmallDateTime), CAST(0x90E20000 AS SmallDateTime), 3400.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'张琪琪', N'女', CAST(0x5333052B AS SmallDateTime), CAST(0x9A8A052B AS SmallDateTime), 4000.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'李亮    ', N'男', CAST(0x61410000 AS SmallDateTime), CAST(0x90E20000 AS SmallDateTime), 3400.0000, 3)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'高思修', N'女', CAST(0x72C10000 AS SmallDateTime), CAST(0x90E20000 AS SmallDateTime), 3400.0000, 3)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'凃米明', N'女', CAST(0x7FEF0000 AS SmallDateTime), CAST(0x999D0000 AS SmallDateTime), 3200.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'金一名', N'男', CAST(0x642F0000 AS SmallDateTime), CAST(0x9A160000 AS SmallDateTime), 3200.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'童金星', N'男', CAST(0x52E00000 AS SmallDateTime), CAST(0x95EF0000 AS SmallDateTime), 3300.2000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'李利明', N'男', CAST(0x5B8D0000 AS SmallDateTime), CAST(0x94810000 AS SmallDateTime), 5300.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'贾振旺', N'女', CAST(0x6B5F0000 AS SmallDateTime), CAST(0x99A20000 AS SmallDateTime), 5000.0000, 2)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'王百静', N'男', CAST(0x8C450539 AS SmallDateTime), CAST(0x9A8A0539 AS SmallDateTime), 5000.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'吴剑波', N'男', CAST(0x88010529 AS SmallDateTime), CAST(0x9A8E0529 AS SmallDateTime), 6443.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'田大海', N'男', CAST(0x7E01054E AS SmallDateTime), CAST(0x9A8A054E AS SmallDateTime), 4800.0000, 1)
INSERT [dbo].[T_EMPLOYEE] ([EmployeeName], [Sex], [BirthDate], [HireDate], [Salary], [DepartmentID]) VALUES (N'李央', N'女', CAST(0x7E070000 AS SmallDateTime), CAST(0x9BFF0000 AS SmallDateTime), 3000.0000, 1)
GO


INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'路由器', CAST(4.50 AS Decimal(18, 2)), 100, 40, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'果冻', CAST(1.00 AS Decimal(18, 2)), 2000, 1000, -1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'打印纸', CAST(20.00 AS Decimal(18, 2)), 100, 1000, -1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'墨盒', CAST(80.00 AS Decimal(18, 2)), 3400, 3000, -1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'鼠标', CAST(40.00 AS Decimal(18, 2)), 4566, 4500, 1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'键盘', CAST(80.00 AS Decimal(18, 2)), 500, 500, 1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'优盘', CAST(40.00 AS Decimal(18, 2)), 9000, 7000, 1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'牙刷', CAST(6.05 AS Decimal(18, 2)), 9000, 8900, 1)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'Usb鼠标', CAST(50.00 AS Decimal(18, 2)), 870, 80, 2)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'圆珠笔', CAST(0.61 AS Decimal(18, 2)), 8000, 450, 2)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'水笔', CAST(0.30 AS Decimal(18, 2)), 5400, 4000, 2)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'水彩笔', CAST(16.50 AS Decimal(18, 2)), 100, 10, 2)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'蜡笔', CAST(7.00 AS Decimal(18, 2)), 20, 10, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'橡皮', CAST(2.00 AS Decimal(18, 2)), 30, 10, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'苹果汁', CAST(4.24 AS Decimal(18, 2)), 70, 30, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'橘子汁', CAST(4.54 AS Decimal(18, 2)), 100, 20, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'鼠标垫', CAST(2.00 AS Decimal(18, 2)), 100, 10, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'订书机', CAST(5.00 AS Decimal(18, 2)), 600, 30, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'铅笔', CAST(2.00 AS Decimal(18, 2)), 500, 500, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'彩色显示器', CAST(700.00 AS Decimal(18, 2)), -400, 1000, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'液晶显示器', CAST(800.00 AS Decimal(18, 2)), 600, 300, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'直尺', CAST(0.89 AS Decimal(18, 2)), 900, 0, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'无线鼠标', CAST(50.00 AS Decimal(18, 2)), 800, 30, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'2G优盘', CAST(40.00 AS Decimal(18, 2)), 760, 300, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'毛巾', CAST(10.00 AS Decimal(18, 2)), 3400, 2000, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'实践报告本', CAST(5.00 AS Decimal(18, 2)), 10000, 2000, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'圆规', CAST(0.20 AS Decimal(18, 2)), 900, 300, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'键盘保护膜', CAST(5.00 AS Decimal(18, 2)), 700, 700, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'白板', CAST(24.00 AS Decimal(18, 2)), 560, 300, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'鼠标垫', CAST(34.00 AS Decimal(18, 2)), 870, 300, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'蛋奶', CAST(3.00 AS Decimal(18, 2)), 900, 100, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'牛奶', CAST(5.00 AS Decimal(18, 2)), 900, 10, 0)
INSERT [dbo].[T_PRODUCT] ([ProductName], [Price], [ProductStockNumber], [ProductSellNumber], [State]) VALUES (N'玻璃茶杯', CAST(5.00 AS Decimal(18, 2)), 300, 50, 0)
GO

INSERT [dbo].[T_PROVIDER] ([ProviderName], [ContactName], [ProviderAddress], [ProviderPhone], [ProviderEmail]) VALUES (N'上海友谊卷笔刀有限公司', N'陈云海  ', N'上海市南汇区南六公路1125弄三灶工业园区发展西路11号', N'0577-88335572', N'5er6@mail.zjitc.com')
INSERT [dbo].[T_PROVIDER] ([ProviderName], [ContactName], [ProviderAddress], [ProviderPhone], [ProviderEmail]) VALUES (N'深圳市金丰达科技有限公司', N'张小平  ', N'中国 广东 深圳市 福田区福华路２９号京海大厦１８Ｃ', N'0577-88335573', N'hjyu7@mail.zjitc.com')
INSERT [dbo].[T_PROVIDER] ([ProviderName], [ContactName], [ProviderAddress], [ProviderPhone], [ProviderEmail]) VALUES (N'文成软件有限公司', N'汤蓬蓬  ', N'福州市嘉禾区临江街 32 号', N'0569-67349882', N'liqiu@163.com')
INSERT [dbo].[T_PROVIDER] ([ProviderName], [ContactName], [ProviderAddress], [ProviderPhone], [ProviderEmail]) VALUES (N'温州神话软件有限公司', N'吴慧    ', N'温州东游大夏1203', N'0577-89574833', N'shenghua@163.com')
GO

INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (9, 210, 18, 1, CAST(0x94AC0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (8, 210, 26, 2, CAST(0x95260000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (9, 110, 32, 2, CAST(0x95450000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (2, 210, 7, 2, CAST(0x96D00000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (3, 110, 26, 2, CAST(0x98390000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (4, 610, 18, 2, CAST(0x987A0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (5, 210, 32, 1, CAST(0x98250000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (2, 210, 7, 1, CAST(0x97C30000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (4, 110, 18, 1, CAST(0x98250000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (5, 30, 34, 2, CAST(0x988C0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (6, 60, 46, 3, CAST(0x988D0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (6, 60, 8, 3, CAST(0x988D0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (8, 22, 46, 2, CAST(0x988C0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (5, 21, 18, 1, CAST(0x988C0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (10, 21, 9, 1, CAST(0x988D0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (7, 66, 26, 1, CAST(0x97690000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (6, 77, 32, 1, CAST(0x97C40000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (7, 99, 7, 3, CAST(0x98210000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (5, 410, 34, 3, CAST(0x983C0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (6, 344, 34, 2, CAST(0x97840000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (6, 40, 7, 2, CAST(0x97840000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (9, 50, 47, 3, CAST(0x97A40000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (7, 60, 32, 2, CAST(0x97A40000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (8, 50, 7, 1, CAST(0x97850000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (10, 79, 47, 1, CAST(0x98020000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (10, 79, 24, 2, CAST(0x97660000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (10, 70, 8, 3, CAST(0x97670000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (13, 40, 47, 1, CAST(0x9A060000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (11, 70, 34, 3, CAST(0x98020000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (11, 50, 9, 3, CAST(0x98780000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (11, 100, 8, 2, CAST(0x987A0000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (7, 50, 32, 2, CAST(0x97460000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (5, 510, 18, 2, CAST(0x98950000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (9, 60, 32, 1, CAST(0x9A060000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (2, 110, 24, 1, CAST(0x9A980000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (6, 600, 18, 1, CAST(0x9A900000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (8, 900, 7, 2, CAST(0x9A980000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (5, 98, 8, 3, CAST(0x9A980000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (4, 108, 24, 3, CAST(0x9A980000 AS SmallDateTime))
INSERT [dbo].[T_PURCHASE_ORDER] ([ProductID], [PurchaseOrderNumber], [EmployeeID], [ProviderID], [PurchaseOrderDate]) VALUES (19, 33, 24, 3, CAST(0x9A900000 AS SmallDateTime))
GO

INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (8, 200, 3, 1, CAST(0x94A20000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (7, 200, 3, 2, CAST(0x951C0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (8, 100, 3, 2, CAST(0x953B0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (1, 200, 5, 5, CAST(0x96C60000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (2, 100, 15, 8, CAST(0x982F0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 600, 14, 20, CAST(0x98700000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 200, 20, 4, CAST(0x981B0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (1, 200, 23, 4, CAST(0x97B90000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 100, 21, 4, CAST(0x981B0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 20, 12, 5, CAST(0x98820000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 50, 25, 6, CAST(0x98830000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 50, 25, 6, CAST(0x98830000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (7, 12, 27, 13, CAST(0x98820000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 11, 28, 16, CAST(0x98820000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (9, 11, 3, 20, CAST(0x98830000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (6, 56, 4, 1, CAST(0x975F0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 67, 1, 1, CAST(0x97BA0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (6, 89, 2, 3, CAST(0x98170000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 400, 6, 7, CAST(0x98320000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 334, 7, 3, CAST(0x977A0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 30, 2, 12, CAST(0x977A0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (8, 40, 5, 13, CAST(0x979A0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (6, 50, 6, 24, CAST(0x979A0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (7, 40, 17, 15, CAST(0x977B0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (9, 69, 19, 17, CAST(0x97F80000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (9, 69, 20, 20, CAST(0x975C0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (9, 60, 20, 21, CAST(0x975D0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (12, 30, 5, 4, CAST(0x99FC0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (10, 60, 21, 24, CAST(0x97F80000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (10, 40, 22, 26, CAST(0x986E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (10, 90, 2, 20, CAST(0x98700000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (6, 40, 5, 21, CAST(0x973C0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 500, 6, 7, CAST(0x988B0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (8, 50, 3, 31, CAST(0x99FC0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (1, 100, 1, 1, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 590, 6, 5, CAST(0x9A860000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (7, 890, 7, 4, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 88, 7, 5, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 98, 3, 2, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (18, 23, 43, 29, CAST(0x9A860000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (6, 90, 48, 3, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 87, 3, 3, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (5, 90, 7, 15, CAST(0x9A8C0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (15, 8000, 16, 5, CAST(0x9A8E0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 300, 11, 24, CAST(0x9A8F0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (10, 3000, 5, 1, CAST(0x9A8F0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (4, 300, 7, 6, CAST(0x9A900000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (32, 100, 6, 11, CAST(0x9A9B0000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (6, 233, 6, 24, CAST(0x9A730000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (29, 2000, 6, 7, CAST(0x9A910000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 344, 6, 7, CAST(0x9A960000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (32, 560, 35, 33, CAST(0x9A960000 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (20, 400, 10, 38, CAST(0x9C7B03DC AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 200, 4, 5, CAST(0x9C8004F2 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 200, 4, 5, CAST(0x9C8004F4 AS SmallDateTime))
INSERT [dbo].[T_SELL_ORDER] ([ProductID], [SellOrderNumber], [EmployeeID], [CustomerID], [SellOrderDate]) VALUES (3, 200, 4, 5, CAST(0x9C8004F5 AS SmallDateTime))
GO


