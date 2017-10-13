SELECT stu.sno,stu.sname,stu.sage,stu.ssex,sc.cno,score
 FROM dbo.student stu LEFT JOIN sc ON stu.sno = sc.sno;

 -- ��ͼ�Ĵ���
 CREATE VIEW V_GET_STU_SCORE
 AS
 SELECT stu.sno,stu.sname,stu.sage,stu.ssex,sc.cno,score
 FROM dbo.student stu LEFT JOIN sc ON stu.sno = sc.sno;

 SELECT * FROM dbo.V_GET_STU_SCORE;

 ALTER VIEW V_GET_STU_SCORE
 AS
  SELECT stu.sno,stu.sname,stu.sage,stu.ssex,sc.cno,score
 FROM dbo.student stu LEFT JOIN sc ON stu.sno = sc.sno
 WHERE stu.sname = '����'
 ;

 -- �����Ĵ���
 ALTER FUNCTION dbo.F_TEST ( @INPUT INT )
RETURNS INT
 AS
        BEGIN
            SET @INPUT = @INPUT + 1;
			RETURN @INPUT;
        END

SELECT dbo.F_TEST(21) ;

--�洢����
CREATE PROCEDURE P_TEST
AS
BEGIN

CREATE TABLE T_USERS
(
	ID INT IDENTITY(1,1),
	NAME VARCHAR(20)
);

INSERT dbo.T_USERS (NAME) VALUES ('JACK');
INSERT dbo.T_USERS (NAME) VALUES ('ROSE');
END

-- ִ�д洢
EXEC P_TEST;

-- �����﷨

--�������
DECLARE @CNT INT

--������ֵ
SET @CNT = 1;
SELECT @CNT = 8;
SELECT @CNT = COUNT(1) FROM [TABLE_NAME];
UPDATE @CNT = COUNT(1) FROM [TABLE_NAME];
-- ��ӡ����
PRINT @CNT;

--ѭ��
WHILE ( @CNT < 100 )
    BEGIN--{
        SET @CNT = @CNT + 1;
    END--}

--IF...ELSE...
IF ( @INPUT > 0 )
    BEGIN
        SET @RES = '����';
    END
ELSE
    IF ( @INPUT < 0 )
        BEGIN
            SET @RES = '����';
        END
    ELSE
        BEGIN
            SET @RES = '��';
        END


CREATE PROCEDURE SP_TEST
    (
      @INPUT INT ,
      @RES VARCHAR(20) OUTPUT
    )
AS
    BEGIN
        IF ( @INPUT > 0 )
            BEGIN
                SET @RES = '����';
            END
        ELSE
            IF ( @INPUT < 0 )
                BEGIN
                    SET @RES = '����';
                END
            ELSE
                BEGIN
                    SET @RES = '��';
                END
    END


CREATE TABLE TABLE_BATCH
    (
      ID INT IDENTITY(1, 1) ,
      NAME VARCHAR(50) ,
      AGE INT ,
      UPDATE_TIME DATETIME
    )

--�����洢�����Ѵ�����CREATE�滻ΪALTER
ALTER PROCEDURE P_IN_BATCH_DATA
AS
    DECLARE @NUM INT
    SET @NUM = 1

    --10w����¼
    WHILE ( @NUM <= 100000 )
        BEGIN 
            SET @NUM = @NUM + 1

    --����������ݣ�NEWID()�������ֵ��RAND()�������С����SYSDATETIME()ϵͳʱ��
            INSERT  INTO TABLE_BATCH
                    ( NAME ,
                      AGE ,
                      UPDATE_TIME
                    )
            VALUES  ( NEWID() ,
                      CAST(RAND() * 100 AS INT) ,
                      SYSDATETIME()
                    )
        END

--ִ�иô洢
EXEC P_IN_BATCH_DATA;