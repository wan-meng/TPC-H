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

OPY partsupp FROM '/home/data1/download/tpch_2_15_0/dbgen/partsupp.tbl' WITH DELIMITER AS '|';
COPY region FROM '/home/data1/download/tpch_2_15_0/dbgen/region.tbl' WITH DELIMITER AS '|';
COPY supplier FROM '/home/data1/download/tpch_2_15_0/dbgen/supplier.tbl' WITH DELIMITER AS '|'; 

-----------------------------------------------------------------------------------
for c in `seq 1 22`;
 do  /usr/bin/time -f  "total=%e" -o result-$c.log mclient  -dtest100 < q-$c.sql  & 
done;

psql tpch -f q-pg.sql -o result-1g-pg9.log

----------------------------------------------
round the log time in milliseconds:

ipython
import rounding
rounding.working('result-1g-pg-hot4.log')
----------------------------------------------
