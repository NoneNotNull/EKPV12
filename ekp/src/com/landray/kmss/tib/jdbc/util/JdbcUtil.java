package com.landray.kmss.tib.jdbc.util;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.tib.jdbc.vo.Page;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * JDBC工具
 * @author qiujh
 */
public class JdbcUtil {
	public final static String DB_TYPE_ORACLE = "Oracle";
	public final static String DB_TYPE_MYSQL = "My SQL";
	public final static String DB_TYPE_DB2 = "DB2";
	public final static String DB_TYPE_MSSQLSERVER = "MS SQL Server";
	
	/**
	 * 判断数据库类型，获取查询数据
	 * @param compDbcp
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public static List<Object> getQueryList(CompDbcp compDbcp, Page page) throws Exception {
		List<Object> objList = new ArrayList<Object>();
		DataSet dataSet = new DataSet(compDbcp.getFdName());
		String dbType = compDbcp.getFdType();
		if (JdbcUtil.DB_TYPE_MSSQLSERVER.equals(dbType)) {
			objList = getQueryListBySqlServer(dataSet, page);
		} else if (JdbcUtil.DB_TYPE_DB2.equals(dbType)) {
			objList = getQueryListByDB2(dataSet, page);
		} else if (JdbcUtil.DB_TYPE_MYSQL.equals(dbType)) {
			objList = getQueryListByMySql(dataSet, page);
		} else if (JdbcUtil.DB_TYPE_ORACLE.equals(dbType)) {
			objList = getQueryListByOracle(dataSet, page);
		}
		return objList;
	}
	
	/**
	 * 判断数据库类型，获取查询数据
	 * @param dbId
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public static List<Object> getQueryList(String dbId, Page page) throws Exception {
		List<Object> objList = new ArrayList<Object>();
		CompDbcp compDbcp = JdbcUtil.getCompDbcp(dbId);
		objList = getQueryList(compDbcp, page);
		return objList;
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
	private static List<Object> getQueryListBySqlServer(DataSet dataSet, Page page) throws Exception {
		List<Object> objMapList = new ArrayList<Object>();
		ResultSet rs = null;
		try {
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
			rs = dataSet.executeQuery(pageSql);
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = metaData.getColumnCount();
			while(rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					String columnName = metaData.getColumnLabel(i).toLowerCase();
					Object obj = rs.getObject(i);
					String columnClassName = metaData.getColumnClassName(i);
					int valueLength = metaData.getColumnDisplaySize(i);
					// 时间格式取出来的数据长度与实际不符
					if (obj instanceof Date) {
						String value = String.valueOf(obj);
						if (value.length() > valueLength) {
							obj = value.substring(0, valueLength);
						}
					} else if (columnClassName.equals("java.sql.Blob") && obj == null) {
						obj = new byte[0];
					}
					map.put(columnName, obj);
				}
				objMapList.add(map);
			}
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return objMapList;
	}
	
	/**
	 * Oracle方式分页查询
	 * @param dbId
	 * @param sql
	 * @param pageSize
	 * @param totalCount
	 * @return
	 * @throws Exception
	 * SELECT * FROM  
	    (  
	    SELECT A.*, ROWNUM RN  
	    FROM (SELECT * FROM TABLE_NAME) A  
	    WHERE ROWNUM <= 40  
	    )  
	    WHERE RN >= 21
	 */
	private static List<Object> getQueryListByOracle(DataSet dataSet, Page page) throws Exception {
		List<Object> objList = new ArrayList<Object>();
		ResultSet rs = null;
		String querySql= page.getQuerySourceSql();
		int currentPage= page.getCurrentPage();
		int pageCount=page.getPageCount();
		int startRow = (currentPage - 1) * pageCount; 
		int endRow=pageCount * currentPage;
		querySql="select * from ( select tib_jdbc01.*,rownum rn from (" +querySql+") tib_jdbc01 where rownum <="+endRow +") tib_jdbc02 where tib_jdbc02.rn >="+startRow;  
		try{
			rs = dataSet.executeQuery(querySql.toUpperCase());
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = rs.getMetaData().getColumnCount();
			while(rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					String columnName = metaData.getColumnLabel(i).toLowerCase();
					Object obj = rs.getObject(i);
					/*int valueLength = metaData.getColumnDisplaySize(i);
					// 时间格式取出来的数据长度与实际不符
					if (obj instanceof Date) {
						String value = String.valueOf(obj);
						if (value.length() > valueLength) {
							obj = value.substring(0, valueLength);
						}
					}*/
					map.put(columnName, obj);
				}
				objList.add(map);
			}
		}finally {
			if (dataSet != null) {
				dataSet.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return objList;
	}
	
	/**
	 * My Sql方式分页查询
	 * @param dbId
	 * @param sql
	 * @param pageSize
	 * @param totalCount
	 * @return
	 * @throws Exception
	 */
	private static List<Object> getQueryListByMySql(DataSet dataSet, Page page) throws Exception {
		List<Object> objList = new ArrayList<Object>();
		ResultSet rs = null;
		String querySql= page.getQuerySourceSql();
		int currentPage= page.getCurrentPage();
		int pageCount=page.getPageCount();
		int startRow = (currentPage - 1) * pageCount; //起始行从0开始
		querySql=querySql+ " limit " + startRow+","+pageCount;  //从第几行开始，取多少条数据
		try{
			rs = dataSet.executeQuery(querySql);
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = rs.getMetaData().getColumnCount();
			while(rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					String columnName = metaData.getColumnLabel(i).toLowerCase();
					Object obj = rs.getObject(i);
					int valueLength = metaData.getColumnDisplaySize(i);
					// 时间格式取出来的数据长度与实际不符
					if (obj instanceof Date) {
						String value = String.valueOf(obj);
						if (value.length() > valueLength) {
							obj = value.substring(0, valueLength);
						}
					}
					map.put(columnName, obj);
				}
				objList.add(map);
			}
		}finally {
			if (dataSet != null) {
				dataSet.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return objList;
	}
	
	/**
	 * DB2 方式分页查询
	 * @param dbId
	 * @param sql
	 * @param pageSize
	 * @param totalCount
	 * @return
	 * @throws Exception
	 */
	private static List<Object> getQueryListByDB2(DataSet dataSet, Page page) throws Exception {
		List<Object> objMapList = new ArrayList<Object>();
		ResultSet rs = null;
		try {
			int pageCount = page.getPageCount();
			int currentPage = page.getCurrentPage();
			//String keyField = page.getSourceKeyField();
			String pageSql = "select * from (select db2_t.*, ROW_NUMBER() OVER() AS ROWNUM from ("
				+ page.getQuerySourceSql() +") db2_t ) db2_ta where ROWNUM > "
				+ pageCount * (currentPage - 1) +" and ROWNUM <= "+ pageCount * currentPage;
			rs = dataSet.executeQuery(pageSql);
			ResultSetMetaData metaData = rs.getMetaData();
			int columnCount = metaData.getColumnCount();
			while(rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					String columnName = metaData.getColumnLabel(i).toLowerCase();
					Object obj = rs.getObject(i);
					/*int valueLength = metaData.getColumnDisplaySize(i);
					// 时间格式取出来的数据长度与实际不符
					if (obj instanceof Date) {
						String value = String.valueOf(obj);
						if (value.length() > valueLength) {
							obj = value.substring(0, valueLength);
						}
					}*/
					map.put(columnName, obj);
				}
				objMapList.add(map);
			}
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return objMapList;
	}

	/**
	 * 获取DatabaseMetaData
	 * @param dbId
	 * @return
	 * @throws Exception
	 */
	public static DatabaseMetaData getDatabaseMetaData(String dbId) throws Exception {
		DataSet dataSet = getDataSet(dbId);
		return dataSet.getConnection().getMetaData();
	}
	
	/**
	 * 获取DataSet
	 * @param dbId
	 * @return
	 * @throws Exception
	 */
	public static DataSet getDataSet(String dbId) throws Exception {
		CompDbcp compDbcp = getCompDbcp(dbId);
		return new DataSet(compDbcp.getFdName());
	}
	
	/**
	 * 获取DataSet
	 * @param dbId
	 * @return
	 * @throws Exception
	 */
	public static DataSet getDataSet(String dbId, String insertSql) throws Exception {
		CompDbcp compDbcp = getCompDbcp(dbId);
		return new DataSet(compDbcp.getFdName(), insertSql);
	}
	
	/**
	 * 获取CompDbcp
	 * @param dbId
	 * @return
	 * @throws Exception
	 */
	public static CompDbcp getCompDbcp(String dbId) throws Exception {
		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbId);
		return compDbcp;
	}
}
