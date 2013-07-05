#--TEST--
#test mysql
#--FILE--
import MySQLdb
fd = MySQLdb.connect(user='noah',passwd='noah',db='zeus_web')
c = fd.cursor()
c.execute('select * from task limit 1')
print c.fetchall()

#--EXPECT--
#((401L, 0L, 1L, 'RollBack', '7719', datetime.datetime(2011, 5, 24, 0, 0), 1L, 600L, 600L, '1', '', '', '13911', 'work', '', '', 0L, 0L, None, None),)
