package com.landray.kmss.tib.jdbc.service.bean;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.tib.jdbc.util.JdbcUtil;
import com.landray.kmss.util.SpringBeanUtil;

public class TibJdbcLoadTableFieldService implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {

		Map<String, List<String>> fieldTableMap = new LinkedHashMap<String, List<String>>();
		JSONArray fieldList = new JSONArray();

		String dbId = requestInfo.getParameter("dbId");
		String sourceSql = requestInfo.getParameter("sourceSql");
		String tableNames = requestInfo.getParameter("tableName");

		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbId);
		

		if (StringUtils.isNotEmpty(sourceSql)) {
			sourceSql = sourceSql.replaceAll("&#13;&#10;", "").replaceAll(  
					"\t|\r|\n", " ").toUpperCase();
			if ((sourceSql.indexOf("SELECT") == -1 || sourceSql.indexOf("FROM") == -1)) {
				return fieldList;
			}
			//DataSet ds = new DataSet(compDbcp.getFdName());
			//如果输入的原始sql后有分号则进行剔除处理
			sourceSql=checkSql(sourceSql);
			List<String> resultList =getTabFieldInfoTypeOne(sourceSql,dbId);
			fieldTableMap.put("sourceSql", resultList);
			fieldList.add(fieldTableMap);
		} else if (StringUtils.isNotEmpty(tableNames.trim())) {
			Map<String,List<String>>resultMap =getTabFieldInfoTypeTwo(tableNames,compDbcp);
			fieldList.add(resultMap);
		}
		return fieldList;
	}

	/**
	 * 取出sql语句中的表名称
	 * @param str
	 */
	public List<String> getTabNameList(String sql) {
		Pattern p = Pattern.compile(   
		        "(?i)(?<=(?:from|into|update|join)\\s{1,1000}"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?" // 重复这里, 可以多个from后面的表   
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"   
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + ")(\\w+)"  
		        ); 
		//Pattern p = Pattern.compile("(?i)(?<=(?:from|into|update|join|)\\s*)\\w*[\\.]?\\w*(?=\\s*)");
		Matcher m = p.matcher(sql);
		List<String> tabNameList = new ArrayList<String>();
		while (m.find()) {
			tabNameList.add(m.group());
		}
		//System.out.println(tabNameList);
		return tabNameList;
	}
	
	/**
	 *  通过数据源sql查询表的字段信息
	 * @param sourceSql
	 * @param ds
	 * @return
	 * @throws Exception
	 */
  private List<String> getTabFieldInfoTypeOne(String sourceSql, String dbId)
			throws Exception {
		String jsonTemplate = "{fieldName:'!{fdName}',dataType:'!{dataType}',isNull:'!{isNull}',tabName:'!{tabName}'}";
		List<String> field_List = new ArrayList<String>();
		ResultSet rs=null;
		String primaryKey="";
		DatabaseMetaData databaseMetaData=null;
		DataSet ds = JdbcUtil.getDataSet(dbId);
		try {
			rs = ds.executeQuery(sourceSql);
			if (rs != null) {
				ResultSetMetaData metaData = rs.getMetaData();
				String columnName = "";
				String columnTypeName = "";
				String tableName = "";
				String columnSize = "";
				String nullAble = "";
				CompDbcp sourceCompDbcp = JdbcUtil.getCompDbcp(dbId);
				String dbType = sourceCompDbcp.getFdType().trim();
				if(dbType.equals(JdbcUtil.DB_TYPE_MSSQLSERVER)){
					List<String> tabNameList = getTabNameList(sourceSql);
					if(tabNameList!=null && tabNameList.size()>0){
						databaseMetaData = ds.getConnection().getMetaData();
						for(int i=0;i<tabNameList.size();i++){
						    tableName =tabNameList.get(i) ;
							ResultSet pkRSet = databaseMetaData.getPrimaryKeys(null,null, tableName.trim());
							if (pkRSet.next()) {
								primaryKey = (String) pkRSet.getObject(4);
								if(StringUtils.isNotEmpty(primaryKey)){
									break;
								}
							}
						}
					}
				}
				for (int i = 1, length = metaData.getColumnCount(); i <= length; i++) {
					columnName = metaData.getColumnLabel(i).toLowerCase();
					columnSize = metaData.getColumnDisplaySize(i) + "";
					columnTypeName = metaData.getColumnTypeName(i);
					tableName = metaData.getTableName(i);
					columnTypeName += "(" + columnSize + ")";
					String elementString="";
					if (metaData.isNullable(i) == ResultSetMetaData.columnNoNulls) {
						nullAble = "notNull";
					} else if (metaData.isNullable(i) == ResultSetMetaData.columnNullable) {
						nullAble = "null";
					}
					if(StringUtils.isNotEmpty(primaryKey)){
						primaryKey=primaryKey.trim().toLowerCase();
						if(primaryKey.equals(columnName)){
							elementString = jsonTemplate.replace("!{fdName}", columnName)
			                        .replace("!{dataType}", columnTypeName)
					                .replace("!{isNull}", "PRIMARY");
						}else{
							elementString = jsonTemplate.replace("!{fdName}",columnName)
		                            .replace("!{dataType}", columnTypeName)
		                            .replace("!{isNull}",nullAble)
		                            .replace("!{tabName}", tableName);
						}
					}else{
				       elementString = jsonTemplate.replace("!{fdName}",columnName)
                               .replace("!{dataType}", columnTypeName)
                               .replace("!{isNull}",nullAble)
                               .replace("!{tabName}", tableName);
					}
					field_List.add(elementString);
				}
			}
		} finally {
			if (rs != null)
				rs.close();
			if (ds != null)
				ds.close();
		}
		return field_List;
	}
  
  
  /**
   * 通过表名 构建sql查询表的字段信息
   * @param sourceSql
   * @param ds
   * @param tableNames
   * @return
   * @throws Exception
   */
  	private Map<String, List<String>> getTabFieldInfoTypeTwo( String tableNames,CompDbcp compDbcp)
  			throws Exception {
	    Map<String, List<String>> fieldTableMap = new LinkedHashMap<String, List<String>>();
	    DataSet ds = new DataSet(compDbcp.getFdName());
		try {
			DatabaseMetaData databaseMetaData = ds.getConnection().getMetaData();
			String jsonTemplate = "{fieldName:'!{fdName}',dataType:'!{dataType}',isNull:'!{isNull}'}";
			String tableNameArray[] = tableNames.trim().split(",");
			for(int i=0;i<tableNameArray.length;i++){
				String tabeName = checkTabNameIsKeyWord(tableNameArray[i],compDbcp);
				String executeSql="select * from " + tabeName;
				ResultSet rs = null;
				try {
					rs = ds.executeQuery(executeSql);
					//获取表的主键
					ResultSet pkRSet = databaseMetaData.getPrimaryKeys(null,null, tableNameArray[i].trim());
					String primaryKey = "";
					while (pkRSet.next()) {
						primaryKey = (String) pkRSet.getObject(4);
					}
					//获取表的所有列
					if(rs!=null){
						ResultSetMetaData metaData = rs.getMetaData();
						String columnName = "";
						String columnTypeName="";
						String columnSize = "";
						String nullAble = "";
						boolean flag = true;
						List<String> field_List = new ArrayList<String>();
						for (int indexNum = 1, length = metaData.getColumnCount(); indexNum <= length; indexNum++) {
							columnName=metaData.getColumnLabel(indexNum).toLowerCase();
							columnSize = metaData.getColumnDisplaySize(indexNum) + "";
							//int columnType = metaData.getColumnType(indexNum);
							String javaType= metaData.getColumnClassName(indexNum);
							columnTypeName =metaData.getColumnTypeName(indexNum);
							String columnTemp=columnTypeName;
							columnTemp=columnTemp.toLowerCase();
							if (compDbcp.getFdType().equals(JdbcUtil.DB_TYPE_MSSQLSERVER) && "timestamp".equals(columnTypeName)) {
								continue;
							}
							columnTypeName += "(" + columnSize + ")";
							if (metaData.isNullable(indexNum) == ResultSetMetaData.columnNoNulls) {
								nullAble = "notNull";
							} else if (metaData.isNullable(indexNum) == ResultSetMetaData.columnNullable) {
								nullAble = "null";
							}
							
							String elementString = "";
							
							if (flag) 
							{
								if (StringUtils.isNotEmpty(primaryKey)){
									if (primaryKey.toUpperCase().equals(columnName.toUpperCase())) {
										elementString = jsonTemplate.replace("!{fdName}", columnName)
										                            .replace("!{dataType}", columnTypeName)
												                    .replace("!{isNull}", "PRIMARY");
										flag = false;
									}else {
										elementString = jsonTemplate.replace("!{fdName}", columnName)
										                            .replace("!{dataType}", columnTypeName)
												                    .replace("!{isNull}", nullAble);
									}
							   } else {
									    elementString = jsonTemplate.replace("!{fdName}", columnName)
									                                .replace("!{dataType}", columnTypeName)
									                                .replace("!{isNull}", nullAble);
							   }
							} else {
								        elementString = jsonTemplate.replace("!{fdName}",columnName)
								                                    .replace("!{dataType}",columnTypeName)
								                                    .replace("!{isNull}",nullAble);
							}
							field_List.add(elementString);
						}
						fieldTableMap.put(tableNameArray[i], field_List);
					}
				} finally {
					if (rs != null) {
						rs.close();
					}
				}
			}
		} finally {
			try {
				if (ds != null)
				    ds.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	return fieldTableMap;
  }
  
  /**
   * 处理关于 档表名称是数据库中的关键字时，进行表名的特殊处理
   * @param tableName
   * @param compDbcp
   * @return
   */
  private String checkTabNameIsKeyWord(String tableName,CompDbcp compDbcp){
	    String dbType = compDbcp.getFdType();
		if (JdbcUtil.DB_TYPE_MSSQLSERVER.equals(dbType)) {
			tableName="["+tableName+"]";
		} else if (JdbcUtil.DB_TYPE_DB2.equals(dbType)) {
			
		} else if (JdbcUtil.DB_TYPE_MYSQL.equals(dbType)) {
			tableName="`"+tableName+"`";
		} else if (JdbcUtil.DB_TYPE_ORACLE.equals(dbType)) {
			
		}
	  return tableName;
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
}
