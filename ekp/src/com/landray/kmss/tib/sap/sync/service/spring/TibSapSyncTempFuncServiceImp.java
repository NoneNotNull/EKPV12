package com.landray.kmss.tib.sap.sync.service.spring;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncTempFunc;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncTempFuncService;
import com.landray.kmss.tib.sys.sap.constant.QuartzCfg;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * 定时任务对应函数表业务接口实现
 * 
 * @author
 * @version 1.0 2011-10-20
 */
public class TibSapSyncTempFuncServiceImp extends BaseServiceImp implements
		ITibSapSyncTempFuncService {

	protected ICompDbcpService compDbcpService;

	public Page findPageByData(String dbID, String tableName, String tempId,
			int pageno, int rowsize, String orderby) throws Exception {

		TibSapSyncTempFunc tibSapSyncTempFunc = (TibSapSyncTempFunc) findByPrimaryKey(tempId);
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbID);
		Page page = new Page();
		if (tibSapSyncTempFunc != null && compDbcp != null) {
			int total = getTotalCount(compDbcp, tableName);
			String primaryKey = getPrimaryKeysName(compDbcp, tableName);
			page.setRowsize(rowsize);
			page.setPageno(pageno);
			page.setTotalrows(total);
			page.excecute();
			String pageSql = getfindListSql(page.getStart(), page.getRowsize(),
					page.getPageno(), tableName, compDbcp.getFdType(),
					primaryKey);
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			if (StringUtil.isNotNull(pageSql)) {
				list = findPage(pageSql, compDbcp);
			}
			page.setList(list);
		} else {
			page = Page.getEmptyPage();
		}

		return page;
	}

	private String getPrimaryKeysName(CompDbcp compDbcp, String tableName)
			throws Exception {
		DataSet dataSet = new DataSet(compDbcp.getFdName());
		DatabaseMetaData dbmd = dataSet.getConnection().getMetaData();
		ResultSet rs = dbmd.getPrimaryKeys(null, null, tableName.toUpperCase()
				.trim());
		String keyName = null;
		while (rs.next()) {
			keyName = rs.getString("COLUMN_NAME");
		}
		dataSet.close();
		return keyName;
	}

	private int getTotalCount(CompDbcp compDbcp, String tableName)
			throws Exception {
		DataSet dataSet = new DataSet(compDbcp.getFdName());
		String findCountSql = "select count(*) from " + tableName;
		Statement statement = dataSet.getStatement();
		ResultSet rs = statement.executeQuery(findCountSql);
		int totalCount = 0;
		while (rs.next()) {
			totalCount = rs.getInt(1);
		}
		dataSet.close();
		return totalCount;
	}

	/**
	 * 分页语句拼装
	 * 
	 * @param start
	 * @param rowsize
	 * @param pageno
	 * @param tableName
	 * @param driverName
	 * @param primaryKey
	 * @return
	 */
	private String getfindListSql(int start, int rowsize, int pageno,
			String tableName, String dbType, String primaryKey) {
		String findPageSql = "";
		
		String orderBy = StringUtil.isNotNull(primaryKey) ? "ORDER BY "
				+ primaryKey + " ASC" : "";
		int preNum=( rowsize * ( pageno - 1));
		int curNum=(( rowsize * ( pageno )))==0?rowsize:( rowsize * ( pageno ));
		
		if ("MY SQL".equalsIgnoreCase(dbType))
		{
			findPageSql=QuartzCfg.QUERY_MYSQL;
		}
		else if("MS SQL Server".equals(dbType))
		{
			findPageSql=QuartzCfg.QUERY_MSSQLSERVER;
		}
		else if ("Oracle".equals(dbType)) {
			findPageSql=QuartzCfg.QUERY_ORACLE;
		}
		else if ("DB2".equals(dbType)){
			findPageSql=QuartzCfg.QUERY_DB2;
		}
		findPageSql= findPageSql.replace("!{start}", start+"").replace("!{rowsize}", rowsize+"")
		            .replace("!{curNum}", curNum+"").replace("!{preNum}", preNum+"")
		            .replace("!{tableName}", tableName).replace("!{orderBy}", orderBy);
		/*
		if ("MY SQL".equalsIgnoreCase(dbType)) {
			findPageSql = "SELECT * FROM " + tableName + " ORDER BY "
					+ primaryKey + " ASC" + " LIMIT " + start + ", " + rowsize;
		} else if ("MS SQL Server".equals(dbType)) {
//			 利用主键select top 数量 跟 前一页的key 比较 分页。
			 findPageSql = "SELECT TOP " + rowsize + " * FROM " + tableName
			 + " WHERE ( " + primaryKey + " NOT IN (SELECT TOP "
			 + rowsize * (pageno - 1) + " " + primaryKey + " FROM "
			 + tableName + " ORDER BY " + primaryKey
			 + " ASC) ) ORDER BY " + primaryKey + " ASC ";
			 
			String orderBy = StringUtil.isNotNull(primaryKey) ? "ORDER BY "
					+ primaryKey + " ASC" : "";
			// sqlserver 2005 及以上
			findPageSql = "SELECT TOP " + rowsize + " * " + " FROM ("
					+ "SELECT ROW_NUMBER() OVER (" + orderBy
					+ ") AS RN,*　FROM  " + tableName + ") A WHERE A.RN>"
					+ rowsize * (pageno - 1);
		} else if ("Oracle".equals(dbType)) {
			String orderBy = StringUtil.isNotNull(primaryKey) ? "ORDER BY "
					+ primaryKey + " ASC" : "";
			findPageSql = "SELECT * FROM ( SELECT B.* ,ROWNUM RN FROM ( SELECT * FROM "
					+ tableName
					+ " "
					+ orderBy
					+ ") AS B WHERE ROWNUM <= "
					+ (start + rowsize + pageno - 1)
					+ " ) WHERE RN>="
					+ (start + pageno - 1);
		} else if ("DB2".equals(dbType)) {
			String orderBy = StringUtil.isNotNull(primaryKey) ? "ORDER BY "
					+ primaryKey + " ASC" : "";
			findPageSql = "SELECT * FROM ( SELECT B.* ,ROWNUMBER() OVER( "
					+ orderBy + " ) AS RN FROM " + "(SELECT * FROM "
					+ tableName + " ) AS B ) " + "AS A WHERE A.RN BETWEEN "
					+ (start + pageno - 1) + " AND "
					+ (start + rowsize + pageno - 1);
		}
		*/
		return findPageSql;
	}

	private List findPage(String sql, CompDbcp compDbcp) {
		DataSet dataSet = null;
		List<Map<String, Object>> resultTable = new ArrayList<Map<String, Object>>();
		try {
			dataSet = new DataSet(compDbcp.getFdName());
			ResultSet rs = dataSet.getStatement().executeQuery(sql);
			while (rs.next()) {
				ResultSetMetaData rsmd = rs.getMetaData();
				Map<String, Object> field = new HashMap<String, Object>();
				for (int i = 0; i < rsmd.getColumnCount(); i++) {
					String key = rsmd.getColumnName(i + 1);
					Object value = rs.getObject(i + 1);
					field.put(key, value);
				}
				resultTable.add(field);
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
		}

		return resultTable;

	}

	public ICompDbcpService getCompDbcpService() {
		return compDbcpService;
	}

	public void setCompDbcpService(ICompDbcpService compDbcpService) {
		this.compDbcpService = compDbcpService;
	}

}
