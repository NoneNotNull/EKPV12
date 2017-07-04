package com.landray.kmss.tib.jdbc.service.spring;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcMappManageService;
import com.landray.kmss.tib.jdbc.util.JdbcDB2Util;
import com.landray.kmss.tib.jdbc.util.JdbcMysqlUtil;
import com.landray.kmss.tib.jdbc.util.JdbcOracleUtil;
import com.landray.kmss.tib.jdbc.util.JdbcSqlServerUtil;
import com.landray.kmss.tib.jdbc.util.JdbcUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 映射配置业务接口实现
 * 
 * @author
 * @version 1.0 2013-07-24
 */
public class TibJdbcMappManageServiceImp extends BaseServiceImp implements
		ITibJdbcMappManageService {

/**
 * 预览数据
 */
public Map getTableData(RequestContext requestInfo) throws Exception {
	String dbId = requestInfo.getParameter("dbId");
	String sourceSql = requestInfo.getParameter("sourceSql");
	ResultSet rs = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	List resultList = null;
	List titleList = null;
	DataSet ds = null;

	Map resultMap = new HashMap();
	if (StringUtils.isNotEmpty(sourceSql)) {
		sourceSql = sourceSql.replaceAll("&#13;&#10;", "").replaceAll("\t|\r|\n", " ");
		if ((sourceSql.toUpperCase().indexOf("SELECT") == -1 || sourceSql.toUpperCase().indexOf("FROM") == -1)) {
			return null;
		}
		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil.getBean("compDbcpService");
		sourceSql = sourceSql.trim();
		//对sql语句结尾处含有分号的进行去掉
		sourceSql=checkSql(sourceSql);
		
		try {
			CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbId);
			ds = new DataSet(compDbcp.getFdName());

			conn = (Connection) ds.getConnection();
			
			String dbType = compDbcp.getFdType().trim();
			String executeSql="";
			//为sql语句添加上取数据条数的限制条件
			executeSql=getSqlWithCondition(compDbcp,sourceSql,0,100);
			pstmt = conn.prepareStatement(executeSql);
			rs = pstmt.executeQuery();

			resultList = new ArrayList();
			titleList = new ArrayList();

			if (rs != null) {
				ResultSetMetaData metaData = rs.getMetaData();
				String columnName = "";
				Object columnValue = "";
				String columnTypeName="";
				int indexNum = 0;
				int columnCount = metaData.getColumnCount();

				// 表头
				for (int i = 1; i <= columnCount; i++) {
					columnName = metaData.getColumnLabel(i);
					titleList.add(columnName);
				}

				boolean flag = rs.next();
				while (flag) {
					if (flag) {
						List dataList = new ArrayList();
						for (int i = 1; i <= columnCount; i++) {
							columnName = metaData.getColumnLabel(i);
							columnTypeName = metaData.getColumnTypeName(i);
							columnValue = rs.getObject(columnName);
							dataList.add(columnValue);
						}
						resultList.add(dataList);
						++indexNum;

						if (indexNum >= 15) {
							flag = false;
						}
					}
					flag = rs.next();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
		   try{
				if (rs != null) rs.close();
				if (ds != null)ds.close();
				
		   }catch (Exception e) {
				e.printStackTrace();
		   }
		}
		if (titleList != null && titleList.size() > 0) {
			resultMap.put("titleList", titleList);
		}
		if (resultList != null && resultList.size() > 0)
			resultMap.put("resultList", resultList);
	}

	return resultMap;
}

/**
 * 截取掉输入sql中结尾处含有分号的情况
 * @param sourceSql
 * @return
 * @throws Exception
 */
public String  checkSql(String sourceSql)throws Exception{
	if(sourceSql.indexOf(";")!=-1){
		int indexNum = sourceSql.indexOf(";");
		if(indexNum!=sourceSql.length()-1){
			throw new Exception("sql syntax error："+sourceSql);
		}else{
		   sourceSql=sourceSql.substring(0, sourceSql.length()-1);
		}
	}
	return sourceSql;
}

/**
 * 为Sql语句添加取数据条数的限制条件
 * @param compDbcp
 * @param sourceSql
 * @param startRow
 * @param endRow
 * @return
 */
public String getSqlWithCondition(CompDbcp compDbcp,String sourceSql,int startRow,int endRow){
	String executeSql="";
	//添加该限制条件，否则在数据量大时会出现内存溢出
	String dbType=compDbcp.getFdType().trim();
	if(dbType.equals(JdbcUtil.DB_TYPE_MYSQL)){
		executeSql="select * from ("+sourceSql+") as temp limit "+startRow+" , "+endRow;
	}else if(dbType.equals(JdbcUtil.DB_TYPE_MSSQLSERVER)){
		executeSql="select top " +endRow+ " tempTab.* from ("+sourceSql+") as tempTab";
	}else if(dbType.equals(JdbcUtil.DB_TYPE_ORACLE)){
		executeSql="select * from (select rownum rn,temp.* from ("+sourceSql+") temp) temp2 where temp2.rn<="+endRow;
	}else if(dbType.equals(JdbcUtil.DB_TYPE_DB2)){
		executeSql="select * from (" +sourceSql+") TEMP fetch first " +endRow+ " rows only";
	}
	return executeSql;
}

/**
 * 取数据源数据
 */
public Map getDataSource() throws Exception {
	ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil.getBean("compDbcpService");
	HQLInfo hqlInfo = new HQLInfo();
	hqlInfo.setSelectBlock("compDbcp.fdId,compDbcp.fdName");
	List result = compDbcpService.findList(hqlInfo);
	Map<String,String> resultMap = new HashMap<String,String>();
	if(result!=null && result.size()>0){
		for(int i=0;i<result.size();i++){
			Object[] obj = (Object[]) result.get(i);
			resultMap.put((String) obj[0],(String) obj[1]);
		}
	}
	return resultMap;
}


/**
 * 取出源表中是日期时间的字段
 */
public List getTableFieldData(Map paraMap) throws Exception {
	String dbId = (String) paraMap.get("dbId");
	String sourceSql = (String) paraMap.get("sourceSql");
	List<String> field_List = new ArrayList<String>();
     
	ResultSet rs = null;
	CompDbcp compDbcp = JdbcUtil.getCompDbcp(dbId);
	DataSet ds = new DataSet(compDbcp.getFdName());

	if (StringUtils.isNotEmpty(sourceSql)) {
		sourceSql = sourceSql.replaceAll("&#13;&#10;", "").replaceAll(  
				"\t|\r|\n", " ").toUpperCase();

		if ((sourceSql.indexOf("SELECT") == -1 || sourceSql.indexOf("FROM") == -1)) {
			return field_List;
		}

		//对sql语句结尾处含有分号的进行去掉
		sourceSql=checkSql(sourceSql);
		//对sql添加上取数据条数的限制条件
		sourceSql=getSqlWithCondition(compDbcp,sourceSql,1,1);
		
		rs = ds.executeQuery(sourceSql);
		if (rs != null) {
			ResultSetMetaData metaData = rs.getMetaData();
			String columnName = "";
			String columnType="";
            String optinVal="";
			try {
				for (int i = 1, length = metaData.getColumnCount(); i <= length; i++) {
					columnName = metaData.getColumnName(i);
					columnType=metaData.getColumnTypeName(i);
					
					if(compDbcp.getFdType().equalsIgnoreCase(JdbcUtil.DB_TYPE_MYSQL)){
						if(JdbcMysqlUtil.validateRQType4Mysql(columnType)){
							optinVal=columnName;
							field_List.add(optinVal);
						};
					}else if(compDbcp.getFdType().equalsIgnoreCase(JdbcUtil.DB_TYPE_ORACLE)){
						if(JdbcOracleUtil.validateRQType4Oracle(columnType)){
							optinVal=columnName;
							field_List.add(optinVal);
						};
					}else if(compDbcp.getFdType().equalsIgnoreCase(JdbcUtil.DB_TYPE_MSSQLSERVER)){
						if(JdbcSqlServerUtil.validateRQType4SqlServer(columnType)){
							optinVal=columnName;
							field_List.add(optinVal);
						};
					}else if(compDbcp.getFdType().equalsIgnoreCase(JdbcUtil.DB_TYPE_DB2)){
						if(JdbcDB2Util.validateRQType4DB2(columnType)){
							optinVal=columnName;
							field_List.add(optinVal);
						};
					}else{
						throw new Exception("this database is not support.");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			} finally {
				try {
					if(rs!=null) rs.close();
					if (ds != null)ds.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	} 
	return field_List;
}

	/**
	 * 取源表数据中的所有经过映射的字段
	 */
	public Set<String> getSourceTabFieldData(Map paraMap)throws Exception{
		Set<String> field_Set = new HashSet<String>();
		String fdMapConfigJson = (String) paraMap.get("fdMapConfigJson");
		JSONObject jsonObject = JSONObject.fromObject(fdMapConfigJson);
		for (Iterator<String> it =  jsonObject.keys(); it.hasNext();) {
			String key = it.next();
			JSONArray jsonArray = jsonObject.getJSONArray(key);
			for (Iterator<JSONObject> it2 = jsonArray.iterator(); it2.hasNext();) {
				JSONObject columnObj = it2.next();
				String mappFieldName = columnObj.getString("mappFieldName");
				if (StringUtil.isNotNull(mappFieldName)) {
					field_Set.add(mappFieldName);
				}
			}
		}
		return field_Set;
	}


/**
 * 取源表数据中的所有字段
 */
	//public List getSourceTabFieldData(Map paraMap)throws Exception{
	//	String dbId = (String) paraMap.get("dbId");
	//	String sourceSql = (String) paraMap.get("sourceSql");
	//	List<String> field_List = new ArrayList<String>();
	//	ResultSet rs = null;
	//	CompDbcp compDbcp = JdbcUtil.getCompDbcp(dbId);
	//	DataSet ds = new DataSet(compDbcp.getFdName());
	//
	//	if (StringUtils.isNotEmpty(sourceSql)) {
	//		sourceSql = sourceSql.replaceAll("&#13;&#10;", "").replaceAll(  "\t|\r|\n", " ").toUpperCase();
	//		if ((sourceSql.indexOf("SELECT") == -1 || sourceSql.indexOf("FROM") == -1)) {
	//			return field_List;
	//		}
	//		
	//		//对sql语句结尾处含有分号的进行去掉
	//		sourceSql=checkSql(sourceSql);
	//		//对sql添加上取数据条数的限制条件
	//		String executeSql=getSqlWithCondition(compDbcp,sourceSql,1,1);
	//		
	//		rs = ds.executeQuery(executeSql);
	//		  
	//		if (rs != null) {
	//			ResultSetMetaData metaData = rs.getMetaData();
	//			String columnName = "";
	//			try {
	//				for (int i = 1, length = metaData.getColumnCount(); i <= length; i++) {
	//					columnName = metaData.getColumnLabel(i).toLowerCase();
	//					field_List.add(columnName);
	//				}
	//			} catch (Exception e) {
	//				e.printStackTrace();
	//				throw e;
	//			} finally {
	//				try {
	//					if(rs!=null)    rs.close();
	//					if(ds != null) ds.close();
	//				} catch (Exception e) {
	//					e.printStackTrace();
	//				}
	//			}
	//		}
	//	} 
	//	return field_List;
	//}
}
