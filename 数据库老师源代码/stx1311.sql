--�����û���tbl_user
create table tbl_user(
    userid number primary key, --��������
    uname varchar2(30),
    upwd varchar2(32),
    ucreattime timestamp
);
--����������tbl_car
create table tbl_car(
    cid number primary key, --��������
    cname varchar2(20),
    money number,
    state number,
    ctime timestamp
);
--ɾ������
drop table tbl_user;
drop table tbl_car;
--�����賵��¼��tbl_car_record
create table tbl_car_record(
    rid number primary key,  --����
    userid number,   --�û����
    cid number,        --�����
    stime timestamp,  --���ʱ��
    endtime timestamp, --�黹ʱ��
    rcode number
);
-----------------------------------------
--������������
insert into tbl_user 
values(1,'dyl','123',sysdate);
insert into tbl_user(userid,uname,upwd)
values(2,'ddyyll','456');
--��ѯ������������
select * from tbl_user;
--�����������У����ڸ�������ֵ
create sequence seq_user
increment by 1 start with 3;
create sequence seq_car
increment by 1 start with 1;
create sequence seq_car_record
increment by 1 start with 1;
----------------------------------
insert into tbl_user
values(seq_user.nextval,'dyl3','234',sysdate);
insert into tbl_user
values(seq_user.nextval,'dyl4','111',sysdate);
----�޸ı�������
update tbl_user set upwd='222' where userid=5;
update tbl_user set uname='dyl44',upwd='444'
where userid=4;
---ɾ����������
delete from tbl_user;
delete from tbl_user where userid=5;
delete from tbl_user
where uname='dyl3' and upwd='234';
select * from tbl_user;
-------------------------------
--���ӵ������ݺ͵���ʹ�ü�¼
insert into tbl_car
values(seq_car.nextval,'car1',1,0,sysdate);
insert into tbl_car
values(seq_car.nextval,'car2',2,0,sysdate);
insert into tbl_car
values(seq_car.nextval,'car3',3,0,sysdate);
insert into tbl_car
values(seq_car.nextval,'car4',1.5,0,sysdate);
select * from tbl_car;
----------
insert into 
tbl_car_record(rid,userid,cid,stime,rcode)
values(seq_car_record.nextval,1,1,sysdate,5554);
update tbl_car set state=1 where cid=1;
--
insert into 
tbl_car_record(rid,userid,cid,stime,rcode)
values(seq_car_record.nextval,2,3,sysdate,2334);
update tbl_car set state=1 where cid=3;
--
insert into 
tbl_car_record(rid,userid,cid,stime,rcode)
values(seq_car_record.nextval,6,2,sysdate,1223);
update tbl_car set state=1 where cid=2;
select * from tbl_car_record;
---------��ѯ���ʹ��
select * 
from tbl_user;--������������
--��ѯ�����û���Ϊdyl����Ϣ
select * from tbl_user where uname='dyl';
--��ѯ�����û���Ϊdyl���û���š����Ƹ�����
select userid,uname,upwd from tbl_user
where uname='dyl';
--��ѯ�����û���Ϊdyl,����Ϊ123���û����
select userid from tbl_user
where uname='dyl' and upwd='123';
--��ѯ�����û���Ϊdyl����ddyyll���û���Ϣ
select * from tbl_user
where uname='dyl' or uname='ddyyll';
--��ѯ�����û�����dd��ͷ���û���Ϣ��ģ����ѯ
select * from tbl_user
where uname like 'dd%';
select * from tbl_user
where uname like '%y%';
select * from tbl_user
where uname like '_y%';
--oracle�ַ�����ƴ��||
--���û���������ƴ��Ϊһ�з���
select uname||upwd from tbl_user;
--ȡ����
select uname||upwd napw from tbl_user;
select uname||upwd as napw from tbl_user;
select u.userid,u.uname from tbl_user u;
--�����ڵĲ���
--�����û���������ע��ʱ�䣬����"��-��-�� ʱ���֣���"��ʽ����
select uname,to_char(ucreattime,'YYYY-MM-DD hh24:mi:ss') ctime
from tbl_user;
--������������С�������𡢵�������
select max(money),min(money),sum(money),count(*)
from tbl_car;
--
select * from tbl_car_record;
insert into 
tbl_car_record(rid,userid,cid,stime,rcode)
values(seq_car_record.nextval,6,1,sysdate,1244);
insert into 
tbl_car_record(rid,userid,cid,stime,rcode)
values(seq_car_record.nextval,6,3,sysdate,1233);
insert into 
tbl_car_record(rid,userid,cid,stime,rcode)
values(seq_car_record.nextval,2,2,sysdate,1253);
--��ÿ���û��ܹ����õĵ�������,���Ϊ�û���š���������
select userid,count(userid)
from tbl_car_record
group by userid;
--��ÿ���û��ܹ����õĵ�������
--���յ��������Ӹߵ�������
--���Ϊ�û���š���������
select userid,count(userid)
from tbl_car_record
group by userid
order by count(userid);
select userid,count(userid)
from tbl_car_record
group by userid
order by count(userid) desc;
--��ÿ���û��ܹ����õĵ�������
--�����������ڵ���2�βŷ���
--���յ��������Ӹߵ�������
--���Ϊ�û���š���������
select userid,count(userid)
from tbl_car_record
group by userid having count(userid)>=2
order by count(userid) desc;
----------����ѯ
--��ѯ�û���ʹ�õĽ賵��¼��
--���Ϊ�û�����������ţ�����ʱ��
select uname,cid,stime
from tbl_user,tbl_car_record
where tbl_user.userid=tbl_car_record.userid;
select u.userid,uname,cid,stime
from tbl_user u,tbl_car_record r
where u.userid=r.userid;
--��ѯ����ʹ�õĽ賵��¼��
--���Ϊ�������ƣ��û���ţ�����ʱ��
select cname,userid,ctime
from tbl_car_record r,tbl_car c
where r.cid=c.cid;
--��ѯ�û�ʹ�õ����Ľ賵��¼��
--���Ϊ�û����ƣ��������ƣ�����ʱ��
select uname,cname,ctime
from tbl_user u,tbl_car_record r,tbl_car c
where u.userid=r.userid and r.cid=c.cid;
--����ÿ���û����������õĵ���������
--���Ϊ���û�����   ������������
select uname,count(*)
from tbl_user u,tbl_car_record r
where u.userid=r.userid
group by u.userid,uname
order by count(*);
--����ÿ�����������õĴ���
--���Ϊ����������   ����
select cname,count(*)
from tbl_car c,tbl_car_record r
where c.cid=r.cid
group by c.cid,cname;
