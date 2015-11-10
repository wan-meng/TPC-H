#!/bin/bash
su postgres
createdb pgdb100 -O svomhpc
exit
psql pgdb100 
\i dss.ddl

sed -i "s/|$//" customer.tbl 
sed -i "s/|$//" lineitem.tbl 
sed -i "s/|$//" nation.tbl   
sed -i "s/|$//" orders.tbl 
sed -i "s/|$//" part.tbl 
sed -i "s/|$//" partsupp.tbl 
sed -i "s/|$//" region.tbl  
sed -i "s/|$//" supplier.tbl

COPY region FROM '/user1/daa' WITH DELIMITER AS '|'; 必须是绝对路径
COPY lineitem FROM '/home/data1/download/tpch_2_15_0/dbgen/lineitem.tbl' WITH DELIMITER AS '|';
COPY nation FROM '/home/data1/download/tpch_2_15_0/dbgen/nation.tbl' WITH DELIMITER AS '|';
COPY orders FROM '/home/data1/download/tpch_2_15_0/dbgen/orders.tbl' WITH DELIMITER AS '|';
COPY part FROM '/home/data1/download/tpch_2_15_0/dbgen/part.tbl' WITH DELIMITER AS '|';   

COPY partsupp FROM '/home/data1/download/tpch_2_15_0/dbgen/partsupp.tbl' WITH DELIMITER AS '|';
COPY region FROM '/home/data1/download/tpch_2_15_0/dbgen/region.tbl' WITH DELIMITER AS '|';
COPY supplier FROM '/home/data1/download/tpch_2_15_0/dbgen/supplier.tbl' WITH DELIMITER AS '|'; 

-----------------------------------------------------------------------------------
for c in `seq 1 22`;
 do  /usr/bin/time -f  "total=%e" -o result-$c.log mclient  -dtest < q-$c.sql  & 
done;


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
Postgresql:

psql tpch -f q-pg.sql -o result-1g-pg9.log

----------------------------------------------
round the log time in milliseconds:

ipython
import rounding
rounding.working('result-1g-pg-hot4.log')
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
MYSQL:
desc XXX;

#show table structure and foreign key:
show create table XXX;

#delete foreign key
ALTER TABLE articles DROP FOREIGN KEY articles_ibfk_1;  

TPCH step:
mysql> CREATE USER ‘tpch’@'%’ IDENTIFIED BY ‘tpch’;
mysql> CREATE DATABASE tpch;
mysql> GRANT ALL ON tpch.* to ‘tpch’@'%’;
mysql> USE tpch;
mysql> \. dss.ddl

 mysql> LOAD DATA LOCAL INFILE 'customer.tbl' INTO TABLE CUSTOMER FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'orders.tbl' INTO TABLE ORDERS FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'lineitem.tbl' INTO TABLE LINEITEM FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'nation.tbl' INTO TABLE NATION FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'partsupp.tbl' INTO TABLE PARTSUPP FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'part.tbl' INTO TABLE PART FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'region.tbl' INTO TABLE REGION FIELDS TERMINATED BY '|';
  mysql> LOAD DATA LOCAL INFILE 'supplier.tbl' INTO TABLE SUPPLIER FIELDS TERMINATED BY '|';

mysql -uroot < q-mysql1.sql  tpch

Q13:
select
	c_count,
	count(*) as custdist
from
	(
		select
			c_custkey,
			count(o_orderkey) as c_count
		from
			customer left outer join orders on
				c_custkey = o_custkey
				and o_comment not like '%special%requests%'
		group by
			c_custkey
	) as c_orders
group by
	c_count
order by
	custdist desc,
	c_count desc;

for c in `seq 1 22`;do time -f "%e" -o result-mysql$c.log mysql -uroot tpch < $c.sql 
========================================================================================= 
