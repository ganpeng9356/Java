create table tbl_company(
    comid number primary key, --��˾���
    cname varchar2(50) unique, --��˾��
    amount number, --��˾����
    createtime timestamp  --����ʱ��
);
drop table tbl_sales;--ɾ��һ�ű�
create table tbl_sales(
    slid number primary key,
    slname varchar2(50) unique,--���۵�����
    createtime timestamp,
    comid number
);
create table tbl_user(
    userid number primary key,
    uname varchar2(30) unique, --�û���
    upwd char(32) not null, --����
    job varchar2(30),  --ְҵ
    createtime timestamp, --ע��ʱ��
    slid number  --�������۵�
);
--����һЩ����
insert into tbl_company values
(1,'˫��ϵ',120,sysdate);
insert into tbl_company values
(2,'����',1000,sysdate);
insert into tbl_company values
(3,'���',800,sysdate);
--����oracle�ṩ�����ж�������������ֵ
create sequence seq_sales --��sales��
increment by 1 start with 1;
create sequence seq_user --��user��
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
--��ѯ���ʹ��
--��ѯ��˾�����Ƹ�����
select cname,amount from tbl_company;
--��ѯ���ѹ�˾������
select amount from tbl_company
where cname='����';
--��ѯ������500�����ϵĹ�˾��Ϣ
select * from tbl_company where amount>=500;
--��ѯ����˾��'��'��ʼ�Ĳ���������500�����ϵĹ�˾��Ϣ
select * from tbl_company
where amount>=500 and cname like '��%';
select * from tbl_company
where amount>=500 or cname like '��%';
--�ַ���ƴ��
select comid||cname||amount from tbl_company;
--���������߱���ȡ����
select comid||cname||amount res from tbl_company;
select c.cname from tbl_company c;
--���麯����ʹ��
select max(amount),min(amount)
,avg(amount),sum(amount),count(*)
from tbl_company;
--nvl(�ֶ�,Ĭ����ʾֵ)
select * from tbl_user;
insert into tbl_user(userid,uname,upwd,slid)
values(seq_user.nextval,'����','3e851763b34a3fc62b72c86969f5027f',3);
select uname,nvl(job,'��ҵ') job from tbl_user;
--���ڴ���
select * from tbl_company;
select cname,to_char(createtime, 'yyyy/mm/dd hh24:mi:ss') createtime 
from tbl_company;
select cname,to_char(createtime, 'yyyy-mm-dd') 
from tbl_company;
--�鿴ÿ����˾�ж��ٸ����۵�
select comid,count(*)
from tbl_sales
group by comid;
--�鿴��˾���۵�����2���Ĺ�˾��Ÿ����۵�����
select comid,count(*)
from tbl_sales
group by comid
having count(*)>=2;
--�鿴ÿ����˾�ж��ٸ����۵�
--���������۵������Ӵ�С����
select comid,count(*)
from tbl_sales
group by comid
order by count(*); --Ĭ��order by ����
select comid,count(*)
from tbl_sales
group by comid
order by count(*) desc;
--��ʾ����˾�����۵�����
select cname,slname from tbl_company c,tbl_sales s
where c.comid=s.comid;
--��ʾ��ÿ����˾ӵ�е����۵�����
select cname,count(*) total 
from tbl_company c,tbl_sales s
where c.comid=s.comid
group by c.comid,cname;
--��ʾ��ÿ����˾ӵ�е����۵��������ڵ���2
select cname,count(*) total 
from tbl_company c,tbl_sales s
where c.comid=s.comid
group by c.comid,cname
having count(*)>=2
order by count(*);
select cname,count(*) total 
from tbl_company c,tbl_sales s
where c.comid=s.comid
group by c.comid,cname
having count(*)>=2
order by total;
--�鿴��˾���������۵��Ӧ����Ա����
select cname,slname,uname,job
from tbl_company c,tbl_sales s,tbl_user u
where c.comid=s.comid and u.slid=s.slid;
--�鿴ÿ����˾��ÿ�����۵����Ա����
select cname,slname,count(*) total 
from tbl_company c,tbl_sales s,tbl_user u 
where c.comid=s.comid and u.slid=s.slid 
group by cname,slname 
order by count(*) desc;

select slname from tbl_sales
where comid in (
    select comid from tbl_company
    where cname='˫��ϵ' or cname='����'
);
select slname from tbl_sales s,tbl_company c
where s.comid=c.comid 
and cname='˫��ϵ' or cname='����';

select * from tbl_user;
