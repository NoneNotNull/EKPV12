package com.landray.kmss.tib.jdbc.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.tib.jdbc.vo.Page;

/**
 *         CREATE TABLE sys_log_test (
	  id VARCHAR(36) NOT NULL COMMENT '主键ID',
	  opt INT(2) NOT NULL COMMENT '操作类型，默认：增:1;删0;改:2',
	  keyWord VARCHAR(200) NOT NULL COMMENT '来源KEY：用于区分来源表，防止多个来源表中存在相同ID',
	  source_id VARCHAR(36) NOT NULL COMMENT '记录ID：进行过增删改记录的ID',
	  PRIMARY KEY (id),
	  KEY id_index (source_id) USING BTREE,
	  KEY key_index (keyWord) USING BTREE
) ENGINE=INNODB DEFAULT CHARSET=utf8

 * 
 * @author Administrator
 *
 */
public class InsertBatchTestTest {
	private static Connection conn = null;
	private static PreparedStatement ps = null;
	private static Statement st = null;

	public static void main(String[] args) throws Exception {
		//testInsert();
		//testInsertSource();
		//testUpdate();
		//testUpdate2();
		testInsertLog();
	}
	
	public static void testUpdate2() throws Exception {
		Connection conn = null;
		Statement ps = null;
		ResultSet rs = null;
		long start = System.currentTimeMillis();
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap", "sa","1");
			// SQLServer本机测试库
			int totalCount = getTotalCount("select count(fd_id) from atest_tib_jdbc");
			Page page = new Page(1, 3000, totalCount, "select * from atest_tib_jdbc", "fd_id");
			// 目标
			int totalPage = page.getTotalPage();
			for (int currentPage = 1; currentPage <= totalPage; currentPage++) {
				page.setCurrentPage(currentPage);
				List<Map<String, Object>> pageObjList = getQueryListBySqlServer(page);
				String whereBlock = "1!=1 ";
				for (Map<String, Object> objMap : pageObjList) {
					whereBlock += " or fd_id='"+objMap.get("fd_id") +"' ";
				}
				String selectSql = "select fd_id, fd_name, fd_mark from customize_table where "+ whereBlock;
				ps = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = ps.executeQuery(selectSql);
				while (rs.next()) {
					String fdId = (String) rs.getObject("fd_id");
					for (Map<String, Object> objMap : pageObjList) {
						if (fdId.equals(objMap.get("fd_id"))) {
							rs.updateObject("fd_name", objMap.get("fd_name"));
							rs.updateObject("fd_mark", objMap.get("fd_desc"));
							rs.updateRow();
						}
					}
				}
			}
		}  finally {
			if (conn != null) {
				conn.close();
			}
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		System.out.println("第二种时间="+ (System.currentTimeMillis() - start));
	}
	
	public static void testUpdate() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		long start = System.currentTimeMillis();
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap", "sa","1");
			// SQLServer本机测试库
			int totalCount = getTotalCount("select count(fd_id) from atest_tib_jdbc");
			Page page = new Page(1, 3000, totalCount, "select * from atest_tib_jdbc", "fd_id");
			// 目标
			int totalPage = page.getTotalPage();
			for (int currentPage = 1; currentPage <= totalPage; currentPage++) {
				page.setCurrentPage(currentPage);
				List<Map<String, Object>> pageObjList = getQueryListBySqlServer(page);
				String whereBlock = "1!=1 ";
				for (Map<String, Object> objMap : pageObjList) {
					whereBlock += " or fd_id='"+objMap.get("fd_id") +"' ";
				}
				stmt = conn.createStatement();
				String selectSql01 = "select fd_id from customize_table where "+ whereBlock;
				rs2 = stmt.executeQuery(selectSql01);
				while (rs2.next()) {
					for (Map<String, Object> objMap : pageObjList) {
						String fdId = (String) rs2.getObject("fd_id");
						if (objMap.get("fd_id").equals(fdId)) {
							String updateSql = "update customize_table set fd_name=?, fd_mark=? where fd_id=?";
							ps = conn.prepareStatement(updateSql);
							ps.setObject(1, objMap.get("fd_name"));
							ps.setObject(2, objMap.get("fd_mark"));
							ps.setObject(3, objMap.get("fd_id"));
							//ps.executeUpdate();
							ps.addBatch();
						}
					}
				}
				ps.executeBatch();
				ps.clearBatch();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				conn.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
			if (rs2 != null) {
				rs2.close();
			}
		}
		System.out.println("第一种时间="+ (System.currentTimeMillis() - start));
	}

	// 日志表插入数据
	public static void testInsertLog(){
		try {
			long start = System.currentTimeMillis();
			conn.setAutoCommit(false);// 取消自动事务提交
			String sql="insert into tib_jdbclog_test (id,opt,keyword,source_id,status) values(?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			int count=0;
			final int batchSize=3000;
			for (int i = 1; i <= 100000; i++) {
				ps.setString(1, "test_"+i);//IDGenerator.generateID()
				ps.setInt(2, 0);
				ps.setString(3, "test");
				ps.setString(4, "sourceId+"+i);
				ps.setString(5, "1");
				ps.addBatch();
				
				if (i % batchSize == 0 || i == 100000) {// 每500条数据执行一次、到最后必须执行一次
					ps.executeBatch();// 执行批
					count++;
					conn.commit();
					System.out.println("第"+count+"批次执行完.");
				}
			}
			System.out.print("总共用时：" + (System.currentTimeMillis() - start)/ 1000 +"秒");// 测试用时
		} catch (Exception e) {
			e.printStackTrace();
		} finally {// 关闭数据库连接
			closeDB();
		}
	}
	
	public static void testInsertSource() throws Exception{
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap_test", "sa","1");
			long start = System.currentTimeMillis();
			conn.setAutoCommit(false);// 取消自动事务提交
			String sql="insert into atest_tib_jdbc (fd_id,fd_name,fd_desc,fd_age, fd_time) values(?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			int count=0;
			int batchSize=3000;
			int size = 100000;
			for (int i = 1; i <= size; i++) {
				ps.setString(1, "sourceId+"+i);//IDGenerator.generateID()
				ps.setString(2, "name"+i);
				ps.setString(3, "desc_"+i);
				ps.setInt(4, i);
				ps.setTimestamp(5, new Timestamp(new java.util.Date().getTime()));
				ps.addBatch();
				
				if (i % batchSize == 0 || i == size) {// 每500条数据执行一次、到最后必须执行一次
					ps.executeBatch();// 执行批
					count++;
					conn.commit();
					System.out.println("第"+count+"批次执行完.");
				}
			}
			System.out.print("总共用时：" + (System.currentTimeMillis() - start)/ 1000 +"秒");// 测试用时
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDB(conn, ps);
		}
	}
	
	public static void testInsertSource2() throws Exception{
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap_test", "sa","1");
			long start = System.currentTimeMillis();
			conn.setAutoCommit(false);// 取消自动事务提交
			String sql="insert into atest_test (id,name,mark) values(?,?,?)";
			ps = conn.prepareStatement(sql);
			int count=0;
			int batchSize=3000;
			int size = 105000;
			for (int i = 1; i <= size; i++) {
				ps.setString(1, "sourceId+"+i);//IDGenerator.generateID()
				ps.setString(2, "name"+i);
				ps.setString(3, "desc_"+i);
				ps.addBatch();
				
				if (i % batchSize == 0 || i == size) {// 每500条数据执行一次、到最后必须执行一次
					ps.executeBatch();// 执行批
					count++;
					conn.commit();
					//System.out.println("第"+count+"批次执行完.");
				}
			}
			System.out.print("总共用时：" + (System.currentTimeMillis() - start)/ 1000 +"秒");// 测试用时
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDB(conn, ps);
		}
	}
	
	public static void closeDB(Connection conn, PreparedStatement ps) {
		if (ps != null) {
			try {
				ps.close();
			} catch (SQLException e1) {
				ps = null;
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				conn = null;
			}
		}
	}

	static {
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap", "sa","1");
//			Class.forName("com.mysql.jdbc.Driver");
//			conn = DriverManager.getConnection("jdbc:mysql://192.168.2.78:3306/etib", "root","573");
		} catch (Exception e) {
			System.out.println("数据库连接错误");
		}
	}

	public static void closeDB() {
		if (st != null)
			try {
				st.close();
			} catch (SQLException e1) {
				st = null;
			}
		if (ps != null)
			try {
				ps.close();
			} catch (SQLException e1) {
				ps = null;
			}
		if (conn != null)
			try {
				conn.close();
			} catch (SQLException e) {
				conn = null;
			}
		System.out.println("\t 连接已关闭");
	}
	
	/**
	 * 求总数
	 * @param dbId
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	public static int getTotalCount(String sql) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		int totalCount = 0;
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap_test", "sa","1");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				totalCount = rs.getInt(1);
			}
		} finally {
			if (conn != null) {
				conn.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return totalCount;
	}
	
	/**
	 * SQL Server方式分页查询
	 * @param dbId
	 * @param sql
	 * @param pageSize
	 * @param totalCount
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> getQueryListBySqlServer(Page page) throws Exception {
		List<Map<String, Object>> objMapList = new ArrayList<Map<String, Object>>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap_test", "sa","1");
			int totalPage = page.getTotalPage();
			int pageCount = page.getPageCount();
			int currentPage = page.getCurrentPage();
			String keyField = page.getSourceKeyField();
			int currentQueryRow = pageCount * currentPage;
			if ((currentPage == totalPage)) {
				pageCount = pageCount- (currentQueryRow - page.getTotalCount());
				currentQueryRow = page.getTotalCount();
			}
			String pageSql = "SELECT TOP "+ currentQueryRow +" * FROM ("+ page.getQuerySourceSql() +
					") as t1 ORDER BY "+ keyField +" ASC";
			pageSql = "SELECT TOP "+ pageCount +" * FROM("+ pageSql +") AS t2 ORDER BY "+ keyField +" DESC";
			pageSql = "SELECT * FROM ("+ pageSql +") AS t3 ORDER BY "+ keyField +" ASC";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(pageSql);
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = metaData.getColumnCount();
			while(rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					String columnName = metaData.getColumnLabel(i);
					Object obj = rs.getObject(i);
					map.put(columnName, obj);
				}
				objMapList.add(map);
			}
		} finally {
			if (conn != null) {
				conn.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return objMapList;
	}
}
