package com.landray.kmss.tib.jdbc.iface.impl;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.tib.jdbc.constant.TibJdbcConstant;
import com.landray.kmss.tib.jdbc.iface.TibJdbcTaskBaseSync;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappManage;
import com.landray.kmss.tib.jdbc.model.TibJdbcRelation;
import com.landray.kmss.tib.jdbc.service.ITibJdbcTaskManageService;
import com.landray.kmss.tib.jdbc.util.JdbcUtil;
import com.landray.kmss.tib.jdbc.vo.Page;

/**
 * 全量同步
 * 
 * @author qiujh
 */
public class TibJdbcTaskRunFullSync extends TibJdbcTaskBaseSync {
	private static final Log logger = LogFactory
			.getLog(TibJdbcTaskRunFullSync.class);
	private ITibJdbcTaskManageService tibJdbcTaskManageService;

	public void setTibJdbcTaskManageService(
			ITibJdbcTaskManageService tibJdbcTaskManageService) {
		this.tibJdbcTaskManageService = tibJdbcTaskManageService;
	}

	public Map<String, String> run(TibJdbcRelation tibJdbcRelation,JSONObject json) throws Exception {
		// 全量同步
		TibJdbcMappManage tibJdbcMappManage = tibJdbcRelation.getTibJdbcMappManage();
		String targetDbId = tibJdbcMappManage.getFdTargetSource();
		String sourceDbId = tibJdbcMappManage.getFdDataSource();
		String dataSourceSql = tibJdbcMappManage.getFdDataSourceSql();
		Map<String, String> conditionMap = new HashMap<String, String>();

		Map<String, String> returnMap = new HashMap<String, String>();

		// 检查该sql语句的末尾是否含有分号，有则截取掉
		dataSourceSql = checkSql(dataSourceSql);

		conditionMap.put("dataSourceSql", dataSourceSql);
		conditionMap.put("sourceDbId", sourceDbId);
		conditionMap.put("targetDbId", targetDbId);

		String configJson = tibJdbcMappManage.getFdMappConfigJson();
		configJson.replaceAll("\"", "\\\"");
		JSONObject jsonObj = JSONObject.fromObject(configJson);
		Iterator it = jsonObj.keySet().iterator();
		String targetTabName = "";
		List<String> tableList = new ArrayList<String>();
		Map<String, LinkedHashMap<String, Object>> mappMap = new LinkedHashMap<String, LinkedHashMap<String, Object>>();
		List<String> deleteSqlList = new ArrayList<String>();

		FormulaParser formulaParser = FormulaParser.getInstance(tibJdbcMappManage);

		while (it.hasNext()) {
			targetTabName = (String) it.next();
			tableList.add(targetTabName);
			String deleteSql = "delete from " + targetTabName;
			List<String> fieldList = new ArrayList<String>();
			LinkedHashMap<String, Object> targetMap = new LinkedHashMap<String, Object>();
			StringBuffer insertBuffer = new StringBuffer();
			StringBuffer mappColumnBuffer = new StringBuffer();
			StringBuffer noMappColumnBuffer = new StringBuffer();

			insertBuffer.append(" insert into  ").append(targetTabName).append(" (");
			String insertValueSql = ")values(";

			JSONArray jsonArray = (JSONArray) jsonObj.get(targetTabName);
			List<String> fieldInitList = new ArrayList<String>();

			for (int i = 0, len = jsonArray.size(); i < len; i++) {
				JSONObject jsonItem = jsonArray.getJSONObject(i);
				String targetFieldName = jsonItem.getString("fieldName"); // 目标字段
				String sourceFieldName = jsonItem.getString("mappFieldName"); // 可能为null
				String fieldInitData = jsonItem.getString("fieldInitData");

				// =========当目标表中含有未被映射的列且该列设置了初始化参数,则该列会被添加到sql语句中,否则不会被添加到sql语句中======================
				if (StringUtils.isEmpty(sourceFieldName)&& StringUtils.isNotEmpty(fieldInitData)) {
					// 如果该目标表字段没有被映射，并且给定了初始化参数
					noMappColumnBuffer.append(targetFieldName).append(",");
					fieldInitList.add(fieldInitData);
					insertValueSql += "?,";
				}else{
				    mappColumnBuffer.append(targetFieldName).append(",");
				    insertValueSql += "?,";
				}
				   if(StringUtils.isNotEmpty(sourceFieldName)){
				      fieldList.add(sourceFieldName);
				   }
			}

			// 构建insertSQL
			String insertSql = insertBuffer.toString();
			String noMappColumnSql = "";
			String mappColumnSql = "";

			// 未被映射的列
			if (noMappColumnBuffer.length() > 0) {
				noMappColumnSql = noMappColumnBuffer.toString();
				noMappColumnSql = noMappColumnSql.substring(0, noMappColumnSql.length() - 1);
			}

			// 映射的列
			if (mappColumnBuffer.length() > 0) {
				mappColumnSql = mappColumnBuffer.toString();
				mappColumnSql = mappColumnSql.substring(0, mappColumnSql.length() - 1);
			}

			// 如果目标表中含有未被映射的列，则组成的SQL中的列分为 被映射的列 ，未被映射的列
			if (StringUtils.isNotEmpty(mappColumnSql)&& StringUtils.isNotEmpty(noMappColumnSql)) {
				// 生成的sql语句: insert into test(column1,column2,column3,column4,column5)values(?,?,?,?,?);其中 column1到column3是映射的列,column4,column5未被映射的列,被映射的列放在前，未被映射的列放在后
				insertSql = insertSql + mappColumnSql + "," + noMappColumnSql;
			} else {
				// 目标表中的所有列都被映射
				insertSql = insertSql + mappColumnSql;
			}

			// 去掉语句中最后问号后的逗号
			insertValueSql = insertValueSql.substring(0, insertValueSql.length() - 1);
			insertSql += insertValueSql + ")";
			targetMap.put("field", fieldList);
			targetMap.put("fieldInitList", fieldInitList);
			targetMap.put("insertSql", insertSql);

			mappMap.put(targetTabName, targetMap);
			deleteSqlList.add(deleteSql);
		}

		String deleteMessage = "";
		boolean deleteFlag = true;
		String isDel = json.getString("isDel");

		// 清理目标表数据
		if (deleteSqlList != null && deleteSqlList.size() > 0&& "1".equals(isDel)) {
			Long startTime = System.currentTimeMillis();
			String deleteErrorMessage = "";
			Long endTime = 0L;
			try {
				for (int i = 0; i < deleteSqlList.size(); i++) {
					String deleteSql = deleteSqlList.get(i);
					super.deleteTargetDB(targetDbId, deleteSql);
				}
				endTime = System.currentTimeMillis();

			} catch (Exception e) {
				deleteFlag = false;
				deleteErrorMessage = e.getMessage();
			}

			if (deleteFlag) {
				Long takeTime =(endTime - startTime) / 1000;
				takeTime=takeTime>0? takeTime:1;
				deleteMessage = "成功删除数据用时:" + (takeTime)+" s";
			} else {
				deleteMessage = "删除失败:" + deleteErrorMessage;
			}

			if (!deleteFlag) {
				returnMap.put("message", "");
				returnMap.put("errorDetail", "删除数据失败:" + deleteMessage);
				return returnMap;
			}
		}
		
		CompDbcp sourceCompDbcp = JdbcUtil.getCompDbcp(sourceDbId);
		String dbType = sourceCompDbcp.getFdType().trim();
		// 获取源SQL语句中表的主键，如果有多个主键取第一张表的主键
		String sourcePk = "";
		if(dbType.equals(JdbcUtil.DB_TYPE_MSSQLSERVER)){
			sourcePk=getSourceSqlTabPk(dataSourceSql, sourceDbId);
		}
		conditionMap.put("sourcePk", sourcePk);

		// 迁移数据操作记录信息
		Map<String, Map<String, String>> messageMap = new HashMap<String, Map<String, String>>();
		// 执行数据迁移
		messageMap = doInsertBatch(conditionMap, tableList, mappMap,formulaParser);
		// 整理在整个迁移数据过程中的日志记录信息
		returnMap = getReturnMessage(messageMap, tableList, deleteMessage);
		return returnMap;
}

/**
 * 获取源sql语句中的源表主键id
 * @param sourceSql
 * @param compDbcp
 * @return
 * @throws Exception 
 */
	public String getSourceSqlTabPk(String sourceSql, String sourceDbId)
			throws Exception {
		String primaryKey = "";
		DataSet ds = null;
		ResultSet rs = null;
		try {
			CompDbcp compDbcp = JdbcUtil.getCompDbcp(sourceDbId);
			ds = new DataSet(compDbcp.getFdName());
			rs = ds.executeQuery(sourceSql);
			if (rs != null) {
				ResultSetMetaData metaData = rs.getMetaData();
				DatabaseMetaData databaseMetaData = ds.getConnection().getMetaData();
				int columnCount = metaData.getColumnCount();

				if (columnCount > 0) {
					List<String> tabNameList = getTabNameList(sourceSql);
					if (tabNameList != null && tabNameList.size() > 0) {
						for (int i = 0; i < tabNameList.size(); i++) {
							String tableName = tabNameList.get(i);// metaData.getTableName(1);
							ResultSet pkRSet = databaseMetaData.getPrimaryKeys(
									null, null, tableName.trim());
							if (pkRSet.next()) {
								primaryKey = (String) pkRSet.getObject(4);
								if (StringUtils.isNotEmpty(primaryKey)) {
									break;
								}
							}
						}

						if (!StringUtils.isNotEmpty(primaryKey)) {
							throw new Exception("源表SQL结果字段中没有主键，SqlServer下全量同步必须要主键");
						}
					} else {
						throw new Exception("源表SQL无法解析出表名或主键");
					}
				}
			}
		} finally {
			if (ds != null) {
				ds.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return primaryKey;
}

	/**
	 * 取出sql语句中的表名称
	 * @param str
	 */
	public List<String> getTabNameList(String sql) {
		sql = sql.replaceAll("\\[", "").replaceAll("\\]", "");
		Pattern p = Pattern.compile(   
		        "(?i)(?<=(?:from|into|update|join)\\s{1,1000}"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?" // 重复这里, 可以多个from后面的表   
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + "(?:\\w{1,1000}(?:\\s{0,1000},\\s{0,1000})?)?"  
		        + ")(\\w+)"  
		        ); 
		Matcher m = p.matcher(sql);
		List<String> tabNameList = new ArrayList<String>();
		while (m.find()) {
			tabNameList.add(m.group());
		}
		return tabNameList;
	}
	
/**
 * 整理迁移数据的结果信息
 * @param messageMap
 * @param tabList
 * @param deleteMessage
 * @return
 */
	public Map<String, String> getReturnMessage(Map<String, Map<String, String>> messageMap, List<String> tabList,String deleteMessage) {
		Map<String, String> returnMap = new HashMap<String, String>();
		String successMessage = "表";
		String errorDetailMessage = "表";
		boolean flag = true;
		if (messageMap != null && messageMap.size() > 0) {
			Map<String, String> inforMap = messageMap.get("informessage");
			if (inforMap == null) {
				for (int i = 0; i < tabList.size(); i++) {
					String tabName = tabList.get(i);
					Map<String, String> tabMap = messageMap.get(tabName);
					String insertSuccessCount = tabMap.get("insertSuccessCount");
					String insertErrorCount = tabMap.get("insertErrorCount");
					String insertErrorInfor = tabMap.get("insertErrorInfor");

					if (StringUtils.isNotEmpty(insertSuccessCount)) {
						int insertCount = Integer.parseInt(insertSuccessCount);
						if (insertCount > 0) {
							successMessage += tabName + "新增成功:" + insertCount
									+ "条" + "\r\n";
						}
					}

					// 新增失败
					if (StringUtils.isNotEmpty(insertErrorCount)) {
						flag = false;
						int insertErrorNum = Integer.parseInt(insertErrorCount);
						if (insertErrorNum > 0) {
							errorDetailMessage += tabName + "新增失败:"
									+ insertErrorNum + "条,id值:"
									+ insertErrorInfor + "\r\n";
						}
					}
				}

				//if (!flag) {
					//returnMap.put("message", "");
					returnMap.put("errorDetail", errorDetailMessage);
				//} else {
					returnMap.put("message", successMessage);
					//returnMap.put("errorDetail", "");
				//}
			} else {
				//表名没有需要迁移的数据
				String messageInfor = (String) inforMap.get("informessage");
				returnMap.put("message", messageInfor);
				returnMap.put("errorDetail", "");
			}
		}

		return returnMap;
}


/**
 * 截取掉输入sql中结尾处含有分号的情况
 * @param sourceSql
 * @return
 * @throws Exception
 */
	public String checkSql(String sourceSql) throws Exception {
		if (sourceSql.indexOf(";") != -1) {
			int indexNum = sourceSql.indexOf(";");
			if (indexNum != sourceSql.length() - 1) {
				throw new Exception("sql syntax error：" + sourceSql);
			} else {
				sourceSql = sourceSql.substring(0, sourceSql.length() - 1);
			}
		}
		return sourceSql;
}

	/**
	 * 迁移数据处理
	 * 
	 * @param conditionMap
	 * @param tabList
	 * @param mappMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Map<String, String>> doInsertBatch(
			Map<String, String> conditionMap, List<String> tabList,
			Map<String, LinkedHashMap<String, Object>> mappMap,
			FormulaParser formulaParser) throws Exception {
		DataSet targetDs = null;
		Connection conn = null;
		Map<String, Map<String, String>> messageMap = new HashMap<String, Map<String, String>>();
		try {
			String sourceDbId = conditionMap.get("sourceDbId");
			String targetDbId = conditionMap.get("targetDbId");
			String dataSourceSql = conditionMap.get("dataSourceSql");
			String sourcePk = conditionMap.get("sourcePk");
			targetDs = JdbcUtil.getDataSet(targetDbId);
			conn = targetDs.getConnection();
			String countSql = "select count(0) from (" + dataSourceSql
					+ ") tempTab";
			String selectSql = dataSourceSql;

			int totalCount = this.getTotalCount(sourceDbId, countSql);
			int batchCount = 0;

			// 根据得到的总数据条数 可以得到分配取数据的次数
			if (totalCount > 0 && totalCount > TibJdbcConstant.batchSize) {
				batchCount = totalCount % TibJdbcConstant.batchSize == 0 ? totalCount
						/ TibJdbcConstant.batchSize
						: (totalCount / TibJdbcConstant.batchSize + 1);
			} else if (totalCount > 0
					&& totalCount <= TibJdbcConstant.batchSize) {
				batchCount = 1;
			}

			if (batchCount > 0) {
				Page page = new Page(1, TibJdbcConstant.batchSize, totalCount, selectSql, sourcePk);

				for (int i = 1; i <= batchCount; i++) {
					page.setCurrentPage(i);
					// 根据数据库的类型不同去分页查询
					List<Object> resultList = JdbcUtil.getQueryList(sourceDbId,
							page);
					for (int indexNum = tabList.size() - 1; indexNum >= 0; indexNum--) {
						PreparedStatement ps = null;
						boolean autoCommit = conn.getAutoCommit();
						// 批量操作开始事务
						if (autoCommit) {
							conn.setAutoCommit(false);
						}
						String targetTabName = tabList.get(indexNum);
						Map<String, Object> targetMap = mappMap
								.get(targetTabName);
						String insertSql = (String) targetMap.get("insertSql");
						List<String> fieldList = (List<String>) targetMap
								.get("field");
						List<String> fieldInitList = (List<String>) targetMap
								.get("fieldInitList");
						int count = fieldList.size();
						ps = conn.prepareStatement(insertSql);

						for (int rowIndex = 0; rowIndex < resultList.size(); rowIndex++) {
							Map<String, Object> columnMap = (Map<String, Object>) resultList.get(rowIndex);
							for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
								String column = fieldList.get(columnIndex);
								Object objVal = columnMap.get(fieldList.get(columnIndex));
								this.setObjectColumn(ps, columnIndex + 1,objVal);
							}

							// 对没有被映射的字段但设置了初始参数的字段设值
							if (fieldInitList != null&& fieldInitList.size() > 0) {
								for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
									String fieldInitData = fieldInitList.get(fieldIndex);
									// 如果输入的是一个表达式,则进行转换计算成对应的值
									Object objValue = parseExpression(fieldInitData);// (String)
																						// formulaParser.parseValueScript(fieldInitData,
																						// "String");
									this.setObjectColumn(ps, count + fieldIndex+ 1, objValue);
								}
							}
							ps.addBatch();
						}

						Map<String, String> newMap = new HashMap<String, String>();
						int insertSuccessCount = 0;
						try {
							insertSuccessCount = ps.executeBatch().length;
							ps.clearBatch();
							targetDs.commit();

							// 本次批量执行成功后，记录对应的信息
							if (messageMap.get(targetTabName) != null) {
								Map<String, String> oldMap = messageMap
										.get(targetTabName);
								String old_insertSuccessCount = oldMap
										.get("insertSuccessCount");
								if (StringUtils
										.isNotEmpty(old_insertSuccessCount)) {
									int insertSuccessCountValue = Integer
											.parseInt(old_insertSuccessCount)
											+ insertSuccessCount;
									oldMap.put("insertSuccessCount", ""
											+ insertSuccessCountValue);
								}
							} else {
								newMap.put("insertSuccessCount", ""
										+ insertSuccessCount);
								newMap.put("insertErrorCount", "");
								newMap.put("insertErrorInfor", "");
								messageMap.put(targetTabName, newMap);
							}

						} catch (Exception e) {
							e.printStackTrace();
							targetDs.rollback();
							// 当本批次中的数据含有执行成功时,则进行一条一条的执行
							//if (insertSuccessCount > 0) {
								// 如果批量操作失败，则进行该批次下一条一条的执行
								newMap = doBatchByOneByOne(resultList,
										fieldList, fieldInitList, conn,
										targetMap, sourcePk);
								if (messageMap.get(targetTabName) != null) {
									Map<String, String> oldMap = messageMap
											.get(targetTabName);
									// 记录本次没有在事物条件下进行数据的更新后插入的结果信息
									getUpdateOrInsertReturnMessage(newMap,
											oldMap);
								} else {
									messageMap.put(targetTabName, newMap);
								}
								//messageMap.put("informessage", newMap);
							//} else {
								String errorMessage=e.getMessage()+"\n";
								errorMessage+="数据类型或长度进行转换时出错.";
								//throw new Exception(errorMessage);
							//}
						} finally {
							if (ps != null) {
								ps.close();
							}
						}
					}
				}
			} else {
				Map<String, String> newMap = new HashMap<String, String>();
				newMap.put("informessage", "通过sql语句查询源表,符合迁移的数据为0条");
				messageMap.put("informessage", newMap);
			}
		} catch (Exception e) {
			logger.error("向目标表插入数据出错:" + e.getMessage());
			e.printStackTrace();
			targetDs.rollback();
			//throw e;
		} finally {
			if (targetDs != null)
				targetDs.close();
		}
		return messageMap;
	}

	/***
	 * 批处理失败后，进行该批次数据一条一条的进行处理，查找出错误数据信息
	 * 
	 * @param resultList
	 * @param fieldList
	 * @param conn
	 * @param tempMap
	 * @return
	 * @throws SQLException
	 */
	public Map<String, String> doBatchByOneByOne(List<Object> resultList,List<String> fieldList, List<String> fieldInitList,
			Connection conn, Map<String, Object> tempMap,String sourcePk) throws SQLException {
		PreparedStatement insertPs = null;
		Map<String, String> resultMap = new HashMap<String, String>();
		String insertSql = (String) tempMap.get("insertSql");

		int insertSuccessCount = 0;
		int insertErrorCount = 0;
		String insertErrorInfor = "";
		String currentPkValue="";
		
		// 准备新增
		insertPs = conn.prepareStatement(insertSql);
		
		try {
			for (int rowIndex = 0; rowIndex < resultList.size(); rowIndex++) {
				Map<String, Object> columMap = (Map<String, Object>) resultList.get(rowIndex);
				currentPkValue = (String) columMap.get(sourcePk);
				for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
					this.setObjectColumn(insertPs, columnIndex + 1, columMap.get(fieldList.get(columnIndex)));
				}
				// 对没有被映射的字段但设置了初始参数的字段设值
				if (fieldInitList != null && fieldInitList.size() > 0) {
					int count = fieldList.size();
					for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
						this.setObjectColumn(insertPs, count + fieldIndex,columMap.get(fieldList.get(fieldIndex)));
					}
				}
				
				insertPs.executeUpdate();
				insertSuccessCount++;
			}
		} catch (Exception e) {
			e.printStackTrace();
			insertErrorCount++;
			insertErrorInfor += currentPkValue + ",";
		}finally{
			if (insertPs != null) {
				insertPs.close();
			}
		}

		if (insertErrorCount > 0) {
			insertErrorInfor = insertErrorInfor.substring(0, insertErrorInfor.length() - 1);
		}
		resultMap.put("insertSuccessCount", "" + insertSuccessCount);
		resultMap.put("insertErrorCount", "" + insertErrorCount);
		resultMap.put("insertErrorInfor", insertErrorInfor);
		return resultMap;
	}

	/**
	 * 汇总在迁移数据的过程中每张表各种操作的详细信息数据
	 * 
	 * @param newMap
	 * @param oldMap
	 * @return
	 */
	public Map<String, String> getUpdateOrInsertReturnMessage(Map<String, String> newMap, Map<String, String> oldMap) {
		int insertSuccessCountValue = 0;
		int insertErrorCountValue = 0;
		String insertErrorValue = "";

		String new_insertSuccessCount = newMap.get("insertSuccessCount");
		String new_insertErrorCount = newMap.get("insertErrorCount");
		String new_insertErrorInfor = newMap.get("insertErrorInfor");
		String old_insertSuccessCount = oldMap.get("insertSuccessCount");
		String old_insertErrorCount = oldMap.get("insertErrorCount");
		String old_insertErrorInfor = oldMap.get("insertErrorInfor");

		// 新增成功条数
		if (StringUtils.isNotEmpty(new_insertSuccessCount)) {
			insertSuccessCountValue = Integer.parseInt(new_insertSuccessCount);
			if (StringUtils.isNotEmpty(old_insertSuccessCount)) {
				insertSuccessCountValue += Integer.parseInt(old_insertSuccessCount);
			}
		}

		// 新增失败条数
		if (StringUtils.isNotEmpty(new_insertErrorCount)) {
			insertErrorCountValue = Integer.parseInt(new_insertErrorCount);
			if (StringUtils.isNotEmpty(old_insertErrorCount)) {
				insertErrorCountValue += Integer.parseInt(old_insertErrorCount);
			}
		}

		// 新增失败的id
		if (StringUtils.isNotEmpty(new_insertErrorInfor)) {
			insertErrorValue = old_insertErrorInfor + ","+ new_insertErrorInfor;
		}

		oldMap.put("insertSuccessCount", "" + insertSuccessCountValue);
		oldMap.put("insertErrorCount", "" + insertErrorCountValue);
		oldMap.put("insertErrorInfor", insertErrorValue);

		return oldMap;
   }
}
