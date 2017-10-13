CREATE TABLE TABLE_1
(
    ID INT IDENTITY(1,1),
    NAME VARCHAR(20)
)

INSERT INTO TABLE_1 (NAME) VALUES('��');
INSERT INTO TABLE_1 (NAME) VALUES('��');
INSERT INTO TABLE_1 (NAME) VALUES('��');
INSERT INTO TABLE_1 (NAME) VALUES('��');

SELECT * FROM TABLE_1;

-- ͳ�Ʋ�ͬNAME������
SELECT NAME,COUNT(1) FROM dbo.TABLE_1 GROUP BY NAME;

-- ͳ���ظ���NAME��Ҳ����COUNT()�������1
SELECT NAME,COUNT(1) FROM dbo.TABLE_1 GROUP BY NAME HAVING COUNT(1)>1;

-- DISTINCT
-- ��ʾ��ͬ��NAME
SELECT DISTINCT NAME FROM dbo.TABLE_1;

-- ͳ�Ʋ�ͬNAME����Ŀ
SELECT COUNT(DISTINCT NAME) FROM dbo.TABLE_1;

/**********************************************************************************************/

CREATE TABLE T_STUDENT
    (
      ID INT NOT NULL,
      C_ID INT ,
      NAME VARCHAR(20)
    );

CREATE TABLE T_COURSE ( ID INT, NAME VARCHAR(20) );

INSERT INTO dbo.T_STUDENT
        ( ID, C_ID, NAME )
VALUES  ( 1, 1, '��һ'),(2,2,'Ǯ��'),(3,2,'����'),(4,3,'����');

INSERT INTO dbo.T_COURSE
        ( ID, NAME )
VALUES  ( 1, 'BigData'),(2,'AI'),(5,'SINGING')

SELECT * FROM dbo.T_STUDENT;
SELECT * FROM dbo.T_COURSE;

-- ��������ķ��ؽ��  ѧ����ţ�ѧ���������γ̱�ţ��γ�����

--�ѿ����� 4*3 12�н��
SELECT A.ID AS 'ѧ�����',A.NAME AS 'ѧ������',B.ID AS '�γ̱��',B.NAME AS '�γ�����'
 FROM dbo.T_STUDENT A CROSS JOIN dbo.T_COURSE B ; 

-- �������� ������  LEFT JOIN/LEFT OUTER JOIN
SELECT A.ID AS 'ѧ�����',A.NAME AS 'ѧ������',B.ID AS '�γ̱��',B.NAME AS '�γ�����'
 FROM dbo.T_STUDENT A LEFT JOIN dbo.T_COURSE B ON a.C_ID = b.ID; 

-- ������ 
SELECT A.ID AS 'ѧ�����',A.NAME AS 'ѧ������',B.ID AS '�γ̱��',B.NAME AS '�γ�����'
 FROM dbo.T_STUDENT A RIGHT JOIN dbo.T_COURSE B ON a.C_ID = b.ID; 

-- ������
SELECT A.ID AS 'ѧ�����',A.NAME AS 'ѧ������',B.ID AS '�γ̱��',B.NAME AS '�γ�����'
 FROM dbo.T_STUDENT A INNER JOIN dbo.T_COURSE B ON a.C_ID = b.ID; 

-- ȫ����
SELECT A.ID AS 'ѧ�����',A.NAME AS 'ѧ������',B.ID AS '�γ̱��',B.NAME AS '�γ�����'
 FROM dbo.T_STUDENT A FULL JOIN dbo.T_COURSE B ON A.C_ID = B.ID; 


SELECT 1 AS id ,'��' AS NAME
UNION
SELECT 89,'ABC';


SELECT NEWID();

