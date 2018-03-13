--创建用户表tbl_user
create table tbl_user(
    userid number primary key, --设置主键
    uname varchar2(30),
    upwd varchar2(32),
    ucreattime timestamp
);
--创建单车表tbl_car
create table tbl_car(
    cid number primary key, --设置主键
    cname varchar2(20),
    money number,
    state number,
    ctime timestamp
);
--删除表定义
drop table tbl_user;
drop table tbl_car;
--创建借车记录表tbl_car_record
create table tbl_car_record(
    rid number primary key,  --主键
    userid number,   --用户编号
    cid number,        --车编号
    stime timestamp,  --借出时间
    endtime timestamp, --归还时间
    rcode number
);
-----------------------------------------
--向表中添加数据
insert into tbl_user 
values(1,'dyl','123',sysdate);
insert into tbl_user(userid,uname,upwd)
values(2,'ddyyll','456');
--查询表中所有数据
select * from tbl_user;
--创建自增序列，用于给主键赋值
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
----修改表中数据
update tbl_user set upwd='222' where userid=5;
update tbl_user set uname='dyl44',upwd='444'
where userid=4;
---删除表中数据
delete from tbl_user;
delete from tbl_user where userid=5;
delete from tbl_user
where uname='dyl3' and upwd='234';
select * from tbl_user;
-------------------------------
--增加单车数据和单车使用记录
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
