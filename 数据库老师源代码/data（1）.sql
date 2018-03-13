create table tbl_company(
    comid number primary key, --公司编号
    cname varchar2(50) unique, --公司名
    amount number, --公司人数
    createtime timestamp  --创建时间
);
create table tbl_sales(
    slid number primary key,
    slname varchar2(50) unique,--销售点名称
    createtime timestamp,
    comid number
);
create table tbl_user1(
    userid number primary key,
    uname varchar2(30) unique, --用户名
    upwd char(32) not null, --密码
    job varchar2(30),  --职业
    createtime timestamp, --注册时间
    slid number  --所属销售点
);
--插入一些数据
insert into tbl_company values (1,'双体系',120,sysdate);
insert into tbl_company values (2,'用友',1000,sysdate);
insert into tbl_company values (3,'金蝶',800,sysdate);
--利用oracle提供的序列对象来给主键赋值
create sequence seq_sales --给sales表
increment by 1 start with 1;
create sequence seq_user1 --给user表
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
insert into tbl_company values(4,'梦三科技',6,sysdate);