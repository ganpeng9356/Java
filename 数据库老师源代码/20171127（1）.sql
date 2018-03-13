select * from tbl_user;
select * from tbl_car_record;
--左外连接
select * from tbl_user u,tbl_car_record r
where u.userid=r.userid(+);
select * from tbl_user u left outer join
tbl_car_record r on u.userid=r.userid;
--右外连接
select * from tbl_user u,tbl_car_record r
where u.userid(+)=r.userid;
select * from tbl_user u right outer join
tbl_car_record r on u.userid=r.userid;
--exist
select * from tbl_user u
where exists(
    select null from tbl_car_record r
    where r.userid=u.userid
);
select * from tbl_car_record r
where exists(
    select null from tbl_user u
    where r.userid=u.userid
);
select * from tbl_user u,tbl_car_record r
where u.userid=r.userid;
--all
select userid from tbl_user
where userid>=all(
   select userid from tbl_user
);
select userid from tbl_user
where userid>=any(
   select userid from tbl_user
);
--union,intersect,minus
select * from tbl_user where uname like '冉%'
union
select * from tbl_user where uname like 'd%';
select * from tbl_user where uname like 'd%'
minus
select * from tbl_user where uname like 'dy%';
--完整性约束
create table t(a int, 
b int,
primary key(a, b));
drop table t;
create table t(a int, 
b int,
constraint pk_t primary key(a, b));
drop table t;
-------
create table t(a int primary key, 
b int unique);
insert into t values(1, 1);
insert into t values(2, 1);
alter table t rename to tt;
-------
alter table tbl_sales 
add constraint fk_comid foreign key(comid)
references tbl_company(comid);
insert into tbl_sales values
(seq_sales.nextval,'项目X部',sysdate,7);
delete from tbl_company;
create table ttt(a int primary key, 
b int,
constraint fk_b foreign key(b) 
references tt(a));
----create view
create or replace view view_uname_count
as
select uname,count(*) totalcount
from tbl_user u,tbl_car_record r
where u.userid=r.userid
group by u.userid,uname
order by count(*);
-----
select * from view_uname_count;
-----pl/sql
declare
  uname varchar2(20);
  score number:=80;
begin
  if score<60 and score>=0 then
    uname:='zhaqiang';
  elsif score>=60 and score<=80 then
    uname:='zhaxiaoqiang';
    dbms_output.put_line(uname);
  elsif score>80 and score<=100 then
    uname:='zhapeng';
  else
    uname:='dyl';  
    end if;
  insert into tbl_user(userid,uname) values(seq_user.nextval,uname);
  dbms_output.put_line(uname);
end;
select * from tbl_user;
------1+2+...+100
declare
    v_start number:=1;
    v_sum number:=0;
begin
    loop
      v_sum:=v_sum+v_start;
      v_start:=v_start+1;
      if v_start>100 then
        exit;
        end if;
      end loop;
      dbms_output.put_line(v_sum);
end;
-----while
declare
    v_start number:=1;
    v_sum number:=0;
begin
    while v_start<=100 loop
      v_sum:=v_sum+v_start;
      v_start:=v_start+1;
      end loop;
      dbms_output.put_line(v_sum);
end;
-----for
declare
    v_start number;
    v_sum number:=0;
    v_min number:=1;
    v_max number:=100;
begin
    for v_start in v_min..v_max loop
      v_sum:=v_sum+v_start;
      end loop;
      dbms_output.put_line(v_sum);
end;
---定义存储过程
create or replace procedure my_proc as
    v_start number:=1;
    v_sum number:=0;
begin
    while v_start<=100 loop
      v_sum:=v_sum+v_start;
      v_start:=v_start+1;
      end loop;
      dbms_output.put_line(v_sum);
  end my_proc;
--调用my_proc
declare
begin
  my_proc;
  end;
-------
create or replace procedure my_proc1(v_start number) is
    v_sum number:=0;
    v_temp number:=0;
begin
    v_temp:=v_start;
    while v_temp<=100 loop
      v_sum:=v_sum+v_temp;
      v_temp:=v_temp+1;
      end loop;
      dbms_output.put_line(v_sum);
  end my_proc1;
---
declare
begin
  my_proc1(10);
  end;
-------
create or replace procedure my_proc2
(v_start number, v_out out number) 
is
    v_sum number:=0;
    v_temp number:=0;
begin
    v_temp:=v_start;
    while v_temp<=100 loop
      v_sum:=v_sum+v_temp;
      v_temp:=v_temp+1;
      end loop;
     v_out:=v_sum;
  end my_proc2;
---
declare
  v_sum number;
begin
  my_proc2(10,v_sum);
  dbms_output.put_line(v_sum);
  end;
-------定时任务的调度
create table tbl_job
(jid number primary key,
jname varchar2(20),
ctime timestamp);
create sequence seq_job 
start with 1 increment by 1;
create or replace procedure pro_job
as
begin
  insert into tbl_job values(seq_job.nextval,'job'||seq_job.currval,sysdate);
  end pro_job;
--添加任务
declare
  job_no number;
begin
  dbms_job.submit(job_no,'pro_job;',sysdate,'sysdate+1/1440');
  dbms_output.put_line('job no is'||job_no);
  end;
--查看任务
select * from user_jobs;
select * from tbl_job;
--暂停
declare
begin
  dbms_job.broken(42,true);
  end;
--启动
declare
begin
  dbms_job.run(42);
  end;
--删除
declare
begin
  dbms_job.remove(42);
  end;
