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
