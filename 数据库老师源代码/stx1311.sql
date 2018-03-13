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
---------查询语句使用
select * 
from tbl_user;--表中所有数据
--查询表中用户名为dyl的信息
select * from tbl_user where uname='dyl';
--查询表中用户名为dyl的用户编号、名称跟密码
select userid,uname,upwd from tbl_user
where uname='dyl';
--查询表中用户名为dyl,密码为123的用户编号
select userid from tbl_user
where uname='dyl' and upwd='123';
--查询表中用户名为dyl或者ddyyll的用户信息
select * from tbl_user
where uname='dyl' or uname='ddyyll';
--查询表中用户名以dd开头的用户信息，模糊查询
select * from tbl_user
where uname like 'dd%';
select * from tbl_user
where uname like '%y%';
select * from tbl_user
where uname like '_y%';
--oracle字符串的拼接||
--将用户名、密码拼接为一列返回
select uname||upwd from tbl_user;
--取别名
select uname||upwd napw from tbl_user;
select uname||upwd as napw from tbl_user;
select u.userid,u.uname from tbl_user u;
--对日期的操作
--返回用户名，及其注册时间，按照"年-月-日 时：分：秒"格式返回
select uname,to_char(ucreattime,'YYYY-MM-DD hh24:mi:ss') ctime
from tbl_user;
--返回最大租金、最小租金、总租金、单车数量
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
--求每个用户总共租用的单车数量,结果为用户编号、单车数量
select userid,count(userid)
from tbl_car_record
group by userid;
--求每个用户总共租用的单车数量
--按照单车数量从高到低排序
--结果为用户编号、单车数量
select userid,count(userid)
from tbl_car_record
group by userid
order by count(userid);
select userid,count(userid)
from tbl_car_record
group by userid
order by count(userid) desc;
--求每个用户总共租用的单车数量
--单车数量大于等于2次才返回
--按照单车数量从高到低排序
--结果为用户编号、单车数量
select userid,count(userid)
from tbl_car_record
group by userid having count(userid)>=2
order by count(userid) desc;
----------多表查询
--查询用户名使用的借车记录，
--结果为用户名，单车编号，借用时间
select uname,cid,stime
from tbl_user,tbl_car_record
where tbl_user.userid=tbl_car_record.userid;
select u.userid,uname,cid,stime
from tbl_user u,tbl_car_record r
where u.userid=r.userid;
--查询单车使用的借车记录，
--结果为单车名称，用户编号，借用时间
select cname,userid,ctime
from tbl_car_record r,tbl_car c
where r.cid=c.cid;
--查询用户使用单车的借车记录，
--结果为用户名称，单车名称，借用时间
select uname,cname,ctime
from tbl_user u,tbl_car_record r,tbl_car c
where u.userid=r.userid and r.cid=c.cid;
--返回每个用户名称所借用的单车的数量
--结果为：用户名称   单车借用数量
select uname,count(*)
from tbl_user u,tbl_car_record r
where u.userid=r.userid
group by u.userid,uname
order by count(*);
--返回每辆单车所借用的次数
--结果为：单车名称   次数
select cname,count(*)
from tbl_car c,tbl_car_record r
where c.cid=r.cid
group by c.cid,cname;
