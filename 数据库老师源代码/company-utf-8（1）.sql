create table tbl_company(
    comid number primary key, --公司编号
    cname varchar2(50) unique, --公司名
    amount number, --公司人数
    createtime timestamp  --创建时间
);
drop table tbl_sales;--删除一张表
create table tbl_sales(
    slid number primary key,
    slname varchar2(50) unique,--销售点名称
    createtime timestamp,
    comid number
);
create table tbl_user(
    userid number primary key,
    uname varchar2(30) unique, --用户名
    upwd char(32) not null, --密码
    job varchar2(30),  --职业
    createtime timestamp, --注册时间
    slid number  --所属销售点
);
--插入一些数据
insert into tbl_company values
(1,'双体系',120,sysdate);
insert into tbl_company values
(2,'用友',1000,sysdate);
insert into tbl_company values
(3,'金蝶',800,sysdate);
--利用oracle提供的序列对象来给主键赋值
create sequence seq_sales --给sales表
increment by 1 start with 1;
create sequence seq_user --给user表
increment by 1 start with 1;

insert into tbl_sales values
(seq_sales.nextval,'项目一部',sysdate,1);
insert into tbl_sales values
(seq_sales.nextval,'项目二部',sysdate,1);
insert into tbl_sales values
(seq_sales.nextval,'项目三部',sysdate,1);
insert into tbl_sales values
(seq_sales.nextval,'重庆一部',sysdate,2);
insert into tbl_sales values
(seq_sales.nextval,'重庆二部',sysdate,2);
insert into tbl_sales values
(seq_sales.nextval,'成都一部',sysdate,3);
select * from tbl_sales;
--查询语句使用
--查询公司的名称跟人数
select cname,amount from tbl_company;
--查询用友公司的人数
select amount from tbl_company
where cname='用友';
--查询人数在500人以上的公司信息
select * from tbl_company where amount>=500;
--查询出公司以'用'开始的并且人数在500人以上的公司信息
select * from tbl_company
where amount>=500 and cname like '用%';
select * from tbl_company
where amount>=500 or cname like '用%';
--字符串拼接
select comid||cname||amount from tbl_company;
--给列名或者表名取别名
select comid||cname||amount res from tbl_company;
select c.cname from tbl_company c;
--分组函数的使用
select max(amount),min(amount)
,avg(amount),sum(amount),count(*)
from tbl_company;
--nvl(字段,默认显示值)
select * from tbl_user;
insert into tbl_user(userid,uname,upwd,slid)
values(seq_user.nextval,'豪豪','3e851763b34a3fc62b72c86969f5027f',3);
select uname,nvl(job,'待业') job from tbl_user;
--日期处理
select * from tbl_company;
select cname,to_char(createtime, 'yyyy/mm/dd hh24:mi:ss') createtime 
from tbl_company;
select cname,to_char(createtime, 'yyyy-mm-dd') 
from tbl_company;
--查看每个公司有多少个销售点
select comid,count(*)
from tbl_sales
group by comid;
--查看公司销售点至少2个的公司编号跟销售点数量
select comid,count(*)
from tbl_sales
group by comid
having count(*)>=2;
--查看每个公司有多少个销售点
--并按照销售点数量从大到小排序
select comid,count(*)
from tbl_sales
group by comid
order by count(*); --默认order by 升序
select comid,count(*)
from tbl_sales
group by comid
order by count(*) desc;
--显示出公司和销售点名称
select cname,slname from tbl_company c,tbl_sales s
where c.comid=s.comid;
--显示出每个公司拥有的销售点数量
select cname,count(*) total 
from tbl_company c,tbl_sales s
where c.comid=s.comid
group by c.comid,cname;
--显示出每个公司拥有的销售点数量大于等于2
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
--查看公司建立的销售点对应的人员名单
select cname,slname,uname,job
from tbl_company c,tbl_sales s,tbl_user u
where c.comid=s.comid and u.slid=s.slid;
--查看每个公司在每个销售点的人员数量
select cname,slname,count(*) total 
from tbl_company c,tbl_sales s,tbl_user u 
where c.comid=s.comid and u.slid=s.slid 
group by cname,slname 
order by count(*) desc;

select slname from tbl_sales
where comid in (
    select comid from tbl_company
    where cname='双体系' or cname='用友'
);
select slname from tbl_sales s,tbl_company c
where s.comid=c.comid 
and cname='双体系' or cname='用友';

select * from tbl_user;
