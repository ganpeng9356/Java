create table tbl_company(
    comid number primary key, --��˾���
    cname varchar2(50) unique, --��˾��
    amount number, --��˾����
    createtime timestamp  --����ʱ��
);
create table tbl_sales(
    slid number primary key,
    slname varchar2(50) unique,--���۵�����
    createtime timestamp,
    comid number
);
create table tbl_user1(
    userid number primary key,
    uname varchar2(30) unique, --�û���
    upwd char(32) not null, --����
    job varchar2(30),  --ְҵ
    createtime timestamp, --ע��ʱ��
    slid number  --�������۵�
);
--����һЩ����
insert into tbl_company values (1,'˫��ϵ',120,sysdate);
insert into tbl_company values (2,'����',1000,sysdate);
insert into tbl_company values (3,'���',800,sysdate);
--����oracle�ṩ�����ж�������������ֵ
create sequence seq_sales --��sales��
increment by 1 start with 1;
create sequence seq_user1 --��user��
increment by 1 start with 1;

insert into tbl_sales values
(seq_sales.nextval,'��Ŀһ��',sysdate,1);
insert into tbl_sales values
(seq_sales.nextval,'��Ŀ����',sysdate,1);
insert into tbl_sales values
(seq_sales.nextval,'��Ŀ����',sysdate,1);
insert into tbl_sales values
(seq_sales.nextval,'����һ��',sysdate,2);
insert into tbl_sales values
(seq_sales.nextval,'�������',sysdate,2);
insert into tbl_sales values
(seq_sales.nextval,'�ɶ�һ��',sysdate,3);
select * from tbl_sales;
insert into tbl_company values(4,'�����Ƽ�',6,sysdate);