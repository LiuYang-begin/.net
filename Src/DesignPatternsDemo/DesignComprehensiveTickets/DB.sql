create database tickets;

USE TICKETS;

CREATE TABLE t_tickets
    (
      ID INT IDENTITY(1, 1) ,
      TicketType VARCHAR(20) ,--Ʊ����
      Remainder INT , --��Ʊ
      Beginning VARCHAR(20) ,--���
      Destination VARCHAR(20)--�յ�
	);


