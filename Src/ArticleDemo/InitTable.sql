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
