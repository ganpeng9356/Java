select stime,nvl(to_char(endtime),0) from tbl_car_recod;
select * from tbl_car_recod;
select nvl(money,0)money from tbl_car_recod;
select * from tbl_user;


create table employees(
emp_no char(8) primary key,----设置主键
emp_name varchar2(20),
emp_age number(2),
emp_mobile char(11),
emp_id char(18)
);
select * from employees;
create sequence seq_emp
increment by 1 start with 1;

select * from employees;
alter table employees modify emp_id char(18) unique;
------------------------------------------------------
select * from employees;
create sequence seq_emp
increment by 1 start with 1;
create sequence seq_emp
increment by 1 start with 1;
insert into employees values(seq_emp.nextval,'','');
update employees set emp_name='令狐冲' where emp_no='1';
insert into employees values(seq_emp.nextval,'')
update employees set emp_name='sss' where emp_no='1';
create table employees(
emp_no char(8) primary key, ---设置主键
emp_name varchar2(30),
emp_age number(2),
emp_mobile char(11),
emp_id char(18) not null unique
);

