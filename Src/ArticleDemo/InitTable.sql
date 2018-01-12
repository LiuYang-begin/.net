/*�û���*/
CREATE TABLE t_users
    (
      id INT IDENTITY(0, 1) PRIMARY KEY,
      zh_name VARCHAR(20) ,--�ǳ�
      name VARCHAR(20) ,--��¼��
      pwd VARCHAR(20)--����
    )

/*�������*/
CREATE TABLE t_category
    (
      id INT IDENTITY(0, 1) PRIMARY KEY,
      name VARCHAR(20)
    )

/*��������*/
CREATE TABLE t_articles
    (
      id INT IDENTITY(0, 1) PRIMARY KEY,
	  cate_id INT FOREIGN KEY REFERENCES dbo.t_category(id),
      title VARCHAR(20) ,
      content VARCHAR(2000) ,
      update_time DATETIME,
	  create_user INT FOREIGN KEY REFERENCES dbo.t_users(id)
    )

/*��ѯ������ͼ*/
ALTER VIEW v_get_articles
AS
    SELECT  a.id ,
            a.cate_id ,
            ct.name cate_name ,
            a.title ,
            a.content ,
            a.update_time ,
            a.create_user ,
            u.zh_name AS user_name
    FROM    t_articles a
            LEFT JOIN t_category ct ON a.cate_id = ct.id
            LEFT JOIN t_users u ON a.create_user = u.id

			
/*�û��� t_users ����Ȩ���ֶ�*/
alter table t_users add roles varchar(100);

--�޸��û��������ֶγ���
ALTER TABLE dbo.t_users ALTER COLUMN pwd VARCHAR(100);

--�޸����±�title�ֶγ���
ALTER TABLE dbo.t_articles ALTER COLUMN title VARCHAR(200);

/*  ����Ȩ�޹�����ر� 2018-1-1 START */
--�˵���
CREATE TABLE T_MENUS
    (
      ID VARCHAR(50),
	  PARENT_ID VARCHAR(50),--�����˵���ID
	  ORDER_IDNEX INT,-- ������Ⱥ� 10>20>30
      NAME VARCHAR(100) ,-- �˵�����
      [URL] VARCHAR(100) ,--�����ַ eg:/Home/Index
      VERSION VARCHAR(100) ,--�˵��汾
      DISABLED BIT DEFAULT (0) --�Ƿ���� 1-����
    );

--��ɫ��
CREATE TABLE T_ROLES
    (
      ID INT PRIMARY KEY IDENTITY(1000, 1) ,
      NAME VARCHAR(100),
	  REMARK VARCHAR(100)
    );

--��ɫ�û���ϵ��
CREATE TABLE T_ROLES_USERS
    (
      ROLE_ID INT ,
      [USER_ID] INT
    );

--��ɫ���ã���ÿ����ɫ���з��ʲ˵���Ȩ��
CREATE TABLE T_ROLES_MENUS
    (
      ROLE_ID INT ,
      MENU_ID VARCHAR(50)
    );

/*  ����Ȩ�޹�����ر� 2018-1-1 END */


-- ���Խű���Ϊ��ɫidΪ1000��10001�Ľ�ɫ��Ӳ��Կɷ��ʲ˵�
INSERT INTO DBO.T_ROLES_MENUS
        ( ROLE_ID, MENU_ID )
SELECT 1000,T.ID FROM DBO.T_MENUS T WHERE T.VERSION='V1' AND T.DISABLED=0 AND T.ID LIKE 'M01%';

INSERT INTO DBO.T_ROLES_MENUS
        ( ROLE_ID, MENU_ID )
SELECT 1001,T.ID FROM DBO.T_MENUS T WHERE T.VERSION='V1' AND T.DISABLED=0;