
/*ִ�����½ű��������ϰ��*/

CREATE TABLE student
    (
      sno VARCHAR(10) PRIMARY KEY ,
      sname VARCHAR(20) ,
      sage INT ,
      ssex VARCHAR(5)
    );
CREATE TABLE teacher
    (
      tno VARCHAR(10) PRIMARY KEY ,
      tname VARCHAR(20)
    );
CREATE TABLE course
    (
      cno VARCHAR(10) ,
      cname VARCHAR(20) ,
      tno VARCHAR(20) ,
      CONSTRAINT pk_course PRIMARY KEY ( cno, tno )
    );
CREATE TABLE sc
    (
      sno VARCHAR(10) ,
      cno VARCHAR(10) ,
      score NUMERIC(4, 2) ,
      CONSTRAINT pk_sc PRIMARY KEY ( sno, cno )
    );
/*******��ʼ��ѧ���������******/
INSERT  INTO student
VALUES  ( 's001', '����', 23, '��' );
INSERT  INTO student
VALUES  ( 's002', '����', 23, '��' );
INSERT  INTO student
VALUES  ( 's003', '����', 25, '��' );
INSERT  INTO student
VALUES  ( 's004', '����', 20, 'Ů' );
INSERT  INTO student
VALUES  ( 's005', '����', 20, 'Ů' );
INSERT  INTO student
VALUES  ( 's006', '�', 21, '��' );
INSERT  INTO student
VALUES  ( 's007', '����', 21, '��' );
INSERT  INTO student
VALUES  ( 's008', '����', 21, 'Ů' );
INSERT  INTO student
VALUES  ( 's009', '������', 23, 'Ů' );
INSERT  INTO student
VALUES  ( 's010', '����', 22, 'Ů' );
COMMIT;
/******************��ʼ����ʦ��***********************/
INSERT  INTO teacher
VALUES  ( 't001', '����' );
INSERT  INTO teacher
VALUES  ( 't002', '����' );
INSERT  INTO teacher
VALUES  ( 't003', '������' );
COMMIT;
/***************��ʼ���γ̱�****************************/
INSERT  INTO course
VALUES  ( 'c001', 'J2SE', 't002' );
INSERT  INTO course
VALUES  ( 'c002', 'Java Web', 't002' );
INSERT  INTO course
VALUES  ( 'c003', 'SSH', 't001' );
INSERT  INTO course
VALUES  ( 'c004', 'Oracle', 't001' );
INSERT  INTO course
VALUES  ( 'c005', 'SQL SERVER 2005', 't003' );
INSERT  INTO course
VALUES  ( 'c006', 'C#', 't003' );
INSERT  INTO course
VALUES  ( 'c007', 'JavaScript', 't002' );
INSERT  INTO course
VALUES  ( 'c008', 'DIV+CSS', 't001' );
INSERT  INTO course
VALUES  ( 'c009', 'PHP', 't003' );
INSERT  INTO course
VALUES  ( 'c010', 'EJB3.0', 't002' );
COMMIT;
/***************��ʼ���ɼ���***********************/
INSERT  INTO sc
VALUES  ( 's001', 'c001', 78.9 );
INSERT  INTO sc
VALUES  ( 's002', 'c001', 80.9 );
INSERT  INTO sc
VALUES  ( 's003', 'c001', 81.9 );
INSERT  INTO sc
VALUES  ( 's004', 'c001', 60.9 );
INSERT  INTO sc
VALUES  ( 's001', 'c002', 82.9 );
INSERT  INTO sc
VALUES  ( 's002', 'c002', 72.9 );
INSERT  INTO sc
VALUES  ( 's003', 'c002', 81.9 );
INSERT  INTO sc
VALUES  ( 's001', 'c003', '59' );