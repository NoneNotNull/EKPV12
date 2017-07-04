package com.landray.kmss.tib.jdbc.iface.impl;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.tib.jdbc.constant.TibJdbcConstant;
import com.landray.kmss.tib.jdbc.iface.TibJdbcTaskBaseSync;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappManage;
import com.landray.kmss.tib.jdbc.model.TibJdbcRelation;
import com.landray.kmss.tib.jdbc.util.JdbcUtil;
import com.landray.kmss.tib.jdbc.vo.Page;
import com.landray.kmss.util.StringUtil;

/**
 * 日志同步
 * @author qiujh
 */
public class TibJdbcTaskRunLogSync extends TibJdbcTaskBaseSync{
	
	private static final Log logger = LogFactory.getLog(TibJdbcTaskRunLogSync.class);
	
	/**
	 * 日志同步
	 */
	public Map<String, String> run(TibJdbcRelation tibJdbcRelation, JSONObject json)
			throws Exception {
		// TIB记录日志
		Map<String, String> logMap = new HashMap<String, String>();
		String message = "";
		String errorDetail = "";
		// 获取映射配置信息
		TibJdbcMappManage tibJdbcMappManage = tibJdbcRelation.getTibJdbcMappManage();
		String targetDBId = tibJdbcMappManage.getFdTargetSource();
		String sourceDBId = tibJdbcMappManage.getFdDataSource();
		String sourceSql = tibJdbcMappManage.getFdDataSourceSql();
		String configJson = tibJdbcMappManage.getFdMappConfigJson();
		JSONObject mappJsonObjs = JSONObject.fromObject(configJson);
		// 获取公式定义器解析
		FormulaParser formulaParser = FormulaParser.getInstance(tibJdbcMappManage);
		// 获取日志数据源Id
		String logDBId = json.getString("logDB");
		String logTabName = json.getString("logTabName");
		String operationTypeStr = json.getString("operationType");
		String keyValue = json.getString("key");
		String sourcePkColumn = json.getString("sourcePk");
		// 查询源表总条数的sql语句
		String querySourceCountSql = "select count(source_id) from "+ logTabName;
		
		// 遍历同步方式的配置
		JSONArray targetTabJsonArray = json.getJSONArray("targetTab");
		List<Map<String, String>> targetTabList = new ArrayList<Map<String, String>>();
		// 组装语句信息，返回查询语句和key
		String selectBlock = parseJsonInfoByLog(mappJsonObjs, targetTabJsonArray, targetTabList, 
				sourcePkColumn);
		int index = sourceSql.toLowerCase().indexOf("from");
		sourceSql = "select "+ selectBlock +" "+ sourceSql.substring(index);
		// 创建数据库日志归档表
		createLogBackTabel(logDBId, logTabName +"_bak");
		// 拆出新增、删除、修改操作类型
		String[] operationTypes = operationTypeStr.split(";");
		String optWhereBlock = "";
		for (int i = 0, len = operationTypes.length; i < len; i++) {
			String type = operationTypes[i];
			String[] operations = type.trim().split(":");
			String operationType = operations[0];
			String operationTypeValue = operations[1];
			optWhereBlock += (i == len - 1) ? " opt="+operationTypeValue : " opt="+operationTypeValue +" or ";
			if (TibJdbcConstant.DELETE.equals(operationType)) {
				long start = System.currentTimeMillis();
				// 根据操作类型，key得出总数量
				int totalCount = getTotalCountByLog(logDBId, querySourceCountSql, keyValue, operationTypeValue);
				String logSql = getLogSql(logTabName, keyValue, operationTypeValue);
				// 设置page信息
				Page logPage = new Page(1, 3000, totalCount, logSql, "source_id");
				String sourceQuerySql = "select tibJdbcDelTab."+ sourcePkColumn +" from ("+ sourceSql +") tibJdbcDelTab";
				// 删除
				Map<String, String> logDeleteMap = deleteTargetDBLogType(sourceDBId, sourceQuerySql, sourcePkColumn,
						targetDBId, targetTabList, logPage, logDBId, logTabName);
				long end = System.currentTimeMillis();
				// TIB记录日志
				message += "JDBC日志同步-DELETE，操作总条数为"+ totalCount +"条；耗时："
						+ ((end-start)/1000) +"秒；"+ logDeleteMap.get("message") +"<br/>";
				String errorIds = logDeleteMap.get("errorDetail");
				if (StringUtil.isNotNull(errorIds)) {
					errorDetail += "JDBC日志同步-DELETE，错误source_id为："+ errorIds +"<br/>";
				}
			} else {
				// 根据操作类型，key得出总数量
				int totalCount = getTotalCountByLog(logDBId, querySourceCountSql, keyValue, operationTypeValue);
				String logSql = getLogSql(logTabName, keyValue, operationTypeValue);
				// 设置page信息
				Page logPage = new Page(1, 3000, totalCount, logSql, "source_id");
				long start = System.currentTimeMillis();
				// 新增、修改
				Map<String, String> logRefreshMap = refreshTargetDB(sourceDBId, sourceSql, 
						sourcePkColumn, logPage, logDBId, logTabName, targetDBId, 
						targetTabList, operationType, formulaParser);
				long end = System.currentTimeMillis();
				// TIB记录日志
				message += "JDBC日志同步-"+ operationType +"，操作总条数为"+ totalCount 
						+"条；耗时："+ ((end-start)/1000) +"秒；"+ logRefreshMap.get("message") +"<br/>";
				String errorIds = logRefreshMap.get("errorDetail");
				if (StringUtil.isNotNull(errorIds)) {
					errorDetail += "JDBC日志同步-"+ operationType +"，错误source_id为："+ errorIds +"<br/>";
				}
			}
		}
		// JDBC日志归档
		logBackOperation(JdbcUtil.getCompDbcp(logDBId), logTabName, keyValue, optWhereBlock);
		logMap.put("message", message);
		logMap.put("errorDetail", errorDetail);
		return logMap;
	}
	
	/**
	 * 解析数据，组装SQL语句等信息
	 * @param mappJsonObjs			目标表映射Json信息
	 * @param targetTabJsonArray	目标表同步Json信息
	 * @param targetTabList			目标表信息的容器
	 * @param sourcePkColumn		源表主键
	 * @return
	 * @throws Exception
	 */
	private String parseJsonInfoByLog(JSONObject mappJsonObjs, JSONArray targetTabJsonArray, 
			List<Map<String, String>> targetTabList, String sourcePkColumn) throws Exception {
		String selectBlock = "";
		// 遍历映射目标表
		for (Iterator<JSONObject> it = targetTabJsonArray.iterator(); it.hasNext();) {
			JSONObject targetTabJson = it.next();
			Map<String, String> targetTabMap = new HashMap<String, String>();
			String targetTabName = targetTabJson.getString("targetTabName");
			String targetKeyColumnName = "";//targetTabJson.getString("fieldPk");
			targetTabMap.put("targetTabName", targetTabName);
			String insertBlock = "";
			String updateBlock = "";
			String questBlock = "";
			String targetUpdateColumns = "";
			String targetInsertColumns = "";
			//String targetKeyColumn = "";
			// 映射的目标表数组
			JSONArray targetColumnArr = mappJsonObjs.getJSONArray(targetTabName);
			// 遍历列的映射
			for (int i = 0, len = targetColumnArr.size(); i < len; i++) {
				JSONObject targetColumnObj = targetColumnArr.getJSONObject(i);
				// 源表列名
				String sourceFieldName = targetColumnObj.getString("mappFieldName");
				if (StringUtil.isNotNull(sourceFieldName)) {
					String primaryKey = targetColumnObj.getString("primaryKey");
					// 目标表列名
					String targetFieldName = targetColumnObj.getString("fieldName");
					insertBlock += targetFieldName +",";
					// 得到所有列
					if (!ArrayUtils.contains(selectBlock.split(","), sourceFieldName)) {
						selectBlock += sourceFieldName +",";
					}
					targetInsertColumns += sourceFieldName +",";
					questBlock += "?,";
					// 目标表映射的源表列，用于取数据
					if ("0".equals(primaryKey)) {
						updateBlock += targetFieldName +"=?,";
						targetUpdateColumns += sourceFieldName +",";
					}
					if (sourceFieldName.equals(sourcePkColumn)) {
						targetKeyColumnName = targetFieldName;
					}
				}
			}
			String fieldInitDatas = "";
			// 遍历列的固定值，初始值
			for (int i = 0, len = targetColumnArr.size(); i < len; i++) {
				JSONObject targetColumnObj = targetColumnArr.getJSONObject(i);
				// 源表列名
				String sourceFieldName = targetColumnObj.getString("mappFieldName");
				if (!StringUtil.isNotNull(sourceFieldName)) {
					// 表字段初始化值
					fieldInitDatas += targetColumnObj.getString("fieldInitData") +"-split-";
					String primaryKey = targetColumnObj.getString("primaryKey");
					// 目标表列名
					String targetFieldName = targetColumnObj.getString("fieldName");
					insertBlock += targetFieldName +",";
					questBlock += "?,";
					// 目标表映射的源表列，用于取数据
					if ("0".equals(primaryKey)) {
						updateBlock += targetFieldName +"=?,";
					} 
				}
			}
			// 截取最后一个逗号
			insertBlock = insertBlock.substring(0, insertBlock.length() - 1);
			questBlock = questBlock.substring(0, questBlock.length() - 1);
			updateBlock = updateBlock.substring(0, updateBlock.length() - 1);
			targetInsertColumns = targetInsertColumns.substring(0, targetInsertColumns.length() - 1);
			targetUpdateColumns = targetUpdateColumns.substring(0, targetUpdateColumns.length() - 1);
			if (StringUtil.isNotNull(fieldInitDatas)) {
				fieldInitDatas = fieldInitDatas.substring(0, fieldInitDatas.length() - 7);
			}
			// 插入目标表数据的sql语句
			String insertTargetSql = "insert into "+ targetTabName +"("+ insertBlock +") values("+ questBlock +")";
			// 删除目标表数据的sql语句
			String deleteTargetSql = "delete from "+ targetTabName;
			// 修改目标表数据的sql语句
			String updateTargetSql = "update "+ targetTabName +" set "+ updateBlock +" where "+ targetKeyColumnName +"=?";
			targetTabMap.put("insertTargetSql", insertTargetSql);
			targetTabMap.put("deleteTargetSql", deleteTargetSql);
			targetTabMap.put("updateTargetSql", updateTargetSql);
			targetTabMap.put("targetInsertColumns", targetInsertColumns);
			targetTabMap.put("targetUpdateColumns", targetUpdateColumns);
			targetTabMap.put("fieldInitDatas", fieldInitDatas);
			targetTabMap.put("targetKeyColumnName", targetKeyColumnName);
			targetTabList.add(targetTabMap);
		}
		if (ArrayUtils.contains(selectBlock.split(","), sourcePkColumn.toLowerCase())) {
			selectBlock = selectBlock.substring(0, selectBlock.length() - 1);
		} else {
			selectBlock += sourcePkColumn;
		}
		// 查询来源表的所有列
		return selectBlock;
	}
	

	/**
	 * 更新数据库，包含新增与修改
	 */
	public Map<String, String> refreshTargetDB(String sourceDBId, String sourceSql, 
			String sourcePkColumn, Page logPage, String pageLogDBId, String logTabName, 
			String targetDBId, List<Map<String, String>> targetTabList, 
			String operationType, FormulaParser formulaParser) throws Exception {
		// TIB日志记录
		Map<String, String> logMap = new HashMap<String, String>();
		String errorDetail = "";
		int failCount = 0;
		// 日志的数据源
		CompDbcp logCompDbcp = JdbcUtil.getCompDbcp(pageLogDBId);
		DataSet logDS = null;
		DataSet targetDS = null;
		DataSet sourceDS = null; 
		// 决定是否批处理并是否开启事务的开关。
		boolean flag = true;
		try {
			// 日志表的数据库连接
			logDS = new DataSet(logCompDbcp.getFdName());
			// 目标表的数据库连接
			targetDS = JdbcUtil.getDataSet(targetDBId);
			sourceDS = JdbcUtil.getDataSet(sourceDBId);
			Connection conn = targetDS.getConnection();
			// 查询数据排序List集合
			int totalPage = logPage.getTotalPage();
			for (int currentPage = 1; currentPage <= totalPage; currentPage++) {
				logPage.setCurrentPage(currentPage);
				// 分页出来的查询条件
				List<Object> pageObjList = JdbcUtil.getQueryList(logCompDbcp, logPage);
				// 拼串查询条件or的方式
				String whereBlock = getWhereBlock(pageObjList, sourcePkColumn);
				if (StringUtil.isNull(whereBlock)) {
					continue;
				}
				// 需要插入的数据
				String inQuerySql = "select * from ("+ sourceSql +") sourceTab where "+ whereBlock;
				List<Map<String, Object>> objMapList = queryDataAndUpdateStatus(sourceDS, 
						inQuerySql, logDS, logTabName, sourcePkColumn, pageObjList);
				// if判断避免重复记录TIB日志，即回滚重新执行时不记录
				if (flag) {
					// TIB日志记录
					for (Object obj : pageObjList) {
						errorDetail += obj +"; ";
					}
					failCount += pageObjList.size();
				}
				// 多表更新数据
				for (int t = 0; t < targetTabList.size(); t++) {
					PreparedStatement ps = null;
					boolean autoCommit = conn.getAutoCommit();
					if (flag && autoCommit) {
						// 批量操作开始事务
						conn.setAutoCommit(false);
					}
					Map<String, String> targetTabMap = targetTabList.get(t);
					String refreshTargetSql = targetTabMap.get("insertTargetSql");
					String targetMappColumns = targetTabMap.get("targetInsertColumns");
					String fieldInitDatas = targetTabMap.get("fieldInitDatas");
					// 如果不是添加，是更新
					if (TibJdbcConstant.UPDATE.equals(operationType)){
						refreshTargetSql = targetTabMap.get("updateTargetSql");
						targetMappColumns = targetTabMap.get("targetUpdateColumns");
					}
					String[] initArr = fieldInitDatas.split("-split-");
					String[] columns = targetMappColumns.split(",");
					ps = conn.prepareStatement(refreshTargetSql);
					// 批量数据结果集循环（通常3000条）
					for (Iterator<Map<String, Object>> it = objMapList.iterator(); it.hasNext();) {
						Map<String, Object> objMap = it.next();
						int initLen = 0;
						if (StringUtil.isNotNull(fieldInitDatas)) {
							initLen = initArr.length;
						}
						int columnLen = columns.length;
						for (int i = 0; i < columnLen; i++) {
							setObjectColumn(ps, i + 1, objMap.get(columns[i]));
						}
						// 为固定初始值设值
						for (int i = 0; i < initLen; i++) {
							String expressionText = initArr[i];
							if (expressionText.contains("$")) {
								// 解析自定义公式表达式函数
								expressionText = parseExpression(expressionText);
							}
							ps.setObject(columnLen + i + 1, expressionText);
						}
						if (TibJdbcConstant.UPDATE.equals(operationType)){
							setObjectColumn(ps, columnLen + initLen + 1, objMap.get(sourcePkColumn));
						}
						// 是否批处理，默认是；
						if (flag) {
							ps.addBatch();
						} else {
							try {
								ps.execute();
							} catch (Exception e) {
								// 捕获错误数据，并写入日志，程序继续执行
								String info = "JDBC日志同步-表\""+ targetTabMap.get("targetTabName")+
										"\"中"+ operationType +"一条数据";
								for (int i = 0; i < columns.length; i++) {
									String column = columns[i].toLowerCase();
									// 记录不能参与日志归档的id值
									if (i == 0) {
										String value = String.valueOf(objMap.get(sourcePkColumn));
										if (!TibJdbcConstant.UPDATE.equals(operationType)){
											it.remove();
											// 删除操作完的表的这条数据。
											deleteNoBackTargetData(conn, targetTabList, t, value);
										}
										// 修改日志表状态
										String updateLogSql = getUpdateLogStatusSql(logTabName, value, "3");
										logDS.executeUpdate(updateLogSql);
										// TIB日志记录
										errorDetail += "表"+ targetTabMap.get("targetTabName") +"主键=" + value +"; ";
										failCount ++;
									}
									info += column +":\""+ objMap.get(column) +"\",";
								}
								logger.error(info + "执行失败！错误原因："+ e.getMessage());
							}
						}
					}
					try {
						if (flag) {
							// 批量
							ps.executeBatch();
							ps.clearBatch();
							targetDS.commit();
						} else {
							// 恢复默认批处理
							flag = true;
						}
					} catch (Exception e) {
						logger.error("JDBC日志同步，一批"+ operationType +"的数据执行失败，进行回滚，将重新进行单条记录更新！错误原因："+
								e.toString());
						// 回滚
						if (targetDS != null) {
							targetDS.rollback();
							// 重新执行插入
							t--;
							// 且重新任务不再批处理
							flag = false;
						}
					} finally {
						// 多张表，不同的预处理，所以需要关闭
						if (ps != null) {
							ps.close();
						}
					}
				}
			}
		} finally {
			if (logDS != null) {
				logDS.close();
			}
			if (targetDS != null) {
				targetDS.close();
			}
			if (sourceDS != null) {
				sourceDS.close();
			}
		}
		String message = "成功"+ (logPage.getTotalCount() - failCount) +"条，失败"+ failCount +"条";
		logMap.put("message", message);
		logMap.put("errorDetail", errorDetail);
		return logMap;
	}
	
	/**
	 * 修改日志表状态为0，标志为未成功的数据；
	 * @param logCompDbcp
	 * @param tabName
	 * @param sourceId
	 * @throws Exception
	 */
	private String getUpdateLogStatusSql(String tabName, 
			String sourceId, String statusValue) throws Exception {
		String updateLogSql = "update "+ tabName +" set status='"+ statusValue +"' where source_id='"+ sourceId +"'";
		return updateLogSql;
	}
	
	/**
	 * 尝试删除目标表不能归档的数据
	 * @param conn
	 * @param targetTabList
	 * @param noBackSet
	 * @throws SQLException
	 */
	private void deleteNoBackTargetData(Connection conn, List<Map<String, String>> targetTabList, 
			int size, String value) throws SQLException {
		for (int t = 0; t < size; t++) {
			PreparedStatement ps = null;
			try {
				Map<String, String> targetTabMap = targetTabList.get(t);
				String deleteTargetSql = targetTabMap.get("deleteTargetSql");
				String targetKeyColumnName = targetTabMap.get("targetKeyColumnName");
				String noBackWhereBlock = targetKeyColumnName +"=?";
				deleteTargetSql = deleteTargetSql +" where "+ noBackWhereBlock;
				ps = conn.prepareStatement(deleteTargetSql);
				ps.setObject(1, value);
				ps.execute();
			} finally {
				if (ps != null) {
					ps.close();
				}
			}
		}
	}
	
	/**
	 * 日志归档，增删改后统一归档
	 * @param logCompDbcp
	 * @param logTabName
	 * @param optWhereBlock
	 * @throws Exception 
	 */
	private void logBackOperation(CompDbcp logCompDbcp, String logTabName, String keyword,
			String optWhereBlock) throws Exception {
		DataSet logDS = null;
		try {
			logDS = new DataSet(logCompDbcp.getFdName());
			logDS.beginTran();
			String deleteLogSql = "delete from "+ logTabName +" where status='1'";
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String logBackSql = "insert into "+ logTabName +"_bak (id, opt, keyword, source_id, update_time) " 
					+"select id, opt, keyword, source_id, '"+ sdf.format(new Date()) +"' from "+ logTabName 
					+" where status='1' ";
			if (StringUtil.isNotNull(keyword)) {
				logBackSql += " and keyword='"+ keyword +"'";
				deleteLogSql += " and keyword='"+ keyword +"'";
			}
			logBackSql += " and ("+ optWhereBlock +")";
			logDS.executeUpdate(logBackSql);
			// 删除日志表已归档数据
			deleteLogSql += " and ("+ optWhereBlock +")";
			logDS.executeUpdate(deleteLogSql);
			logDS.commit();
		} catch(Exception e){
			e.printStackTrace();
			if (logDS != null) {
				logDS.rollback();
			}
		} finally {
			if (logDS != null) {
				logDS.close();
			}
		}
	}
	
	/**
	 * 删除目标表方法
	 * @param targetDBId
	 * @param targetKeyColumnName
	 * @param deleteTargetSql
	 * @param logPage
	 * @param pageDBId
	 * @throws Exception
	 */
	private Map<String, String> deleteTargetDBLogType(String sourceDBId, String sourceSql, 
			String sourcePkColumn, String targetDBId, 
			List<Map<String, String>> targetTabList, 
			Page logPage, String pageDBId, String logTabName) throws Exception {
		// TIB日志记录
		Map<String, String> logMap = new HashMap<String, String>();
		String errorDetail = "";
		int failCount = 0;
		DataSet targetDS = null; 
		DataSet sourceDS = null; 
		DataSet logDS = null; 
		try {
			CompDbcp compDbcp = JdbcUtil.getCompDbcp(pageDBId);
			targetDS = JdbcUtil.getDataSet(targetDBId);
			sourceDS = JdbcUtil.getDataSet(sourceDBId);
			logDS = new DataSet(compDbcp.getFdName());
			// 查询数据排序List集合
			int totalPage = logPage.getTotalPage();
			for (int currentPage = 1; currentPage <= totalPage; currentPage++) {
				logPage.setCurrentPage(currentPage);
				// 分页出来的查询条件
				List<Object> pageObjList = JdbcUtil.getQueryList(compDbcp, logPage);
				for (Map<String, String> targetTabMap : targetTabList) {
					// 拼串查询条件or的方式
					String whereBlock = getWhereBlock(pageObjList, targetTabMap.get("targetKeyColumnName"));
					if (StringUtil.isNull(whereBlock)) {
						continue;
					}
					targetDS.executeUpdate(targetTabMap.get("deleteTargetSql") +" where "+ whereBlock);
				}
				// 拼串查询条件or的方式
				String sourceWhereBlock = getWhereBlock(pageObjList, sourcePkColumn);
				// 修改日志表未找到记录的状态
				String sourceQuerySql = "select * from ("+ sourceSql +") tibJdbcDelQueryTab where "+ sourceWhereBlock;
				delQueryDataAndUpdateStatus(sourceDS, sourceQuerySql, logDS, 
						logTabName, sourcePkColumn, pageObjList);
				// TIB日志记录
				for (Object obj : pageObjList) {
					errorDetail += obj +"; ";
				}
				failCount += pageObjList.size();
			}
		} finally {
			if (targetDS != null) {
				targetDS.close();
			}
			if (sourceDS != null) {
				sourceDS.close();
			}
			if (logDS != null) {
				logDS.close();
			}
		}
		String message = "成功："+ (logPage.getTotalCount() - failCount) +"条, 失败"+ failCount +"条";
		logMap.put("message", message);
		logMap.put("errorDetail", errorDetail);
		return logMap;
	}
	
	
	/**
	 * 组装whereBlock 格式例如：
	 * fd_id = 'aa' or fd_id = 'bb' or fd_id = 'cc'
	 * @param objListList
	 * @param sourcePkColumn
	 * @return
	 */
	private String getWhereBlock(List<Object> objList, String pkColumn) {
		StringBuffer whereBlock = new StringBuffer("");
		for (int i = 0, len = objList.size(); i < len; i++) {
			Map<String, Object> map = (Map<String, Object>) objList.get(i);
			Object idValue = map.get("source_id");
			whereBlock.append(pkColumn +"='"+ String.valueOf(idValue) +"' ");
			if (i != len - 1) {
				whereBlock.append(" or ");
			} 
		}
		return whereBlock.toString();
	}
	
	/**
	 * 求日志总数
	 * @param dbId
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	public int getTotalCountByLog(String dbId, String sql, String keyValue,
			String operationTypeValue) throws Exception {
		sql += " where opt="+ operationTypeValue;
		if (StringUtil.isNotNull(keyValue)) {
			sql += " and keyword='"+ keyValue +"'";
		}
		return getTotalCount(dbId, sql);
	}
	
	
	/**
	 * 获取日志所有的source_id
	 * @param logDBId
	 * @param logTabName
	 * @param keyValue
	 * @return
	 * @throws Exception
	 */
	private String getLogSql(String logTabName, String keyValue, 
			String operationTypeValue) throws Exception {
		String sql = "select source_id from "+ logTabName +" where opt="+ operationTypeValue;
		if (StringUtil.isNotNull(keyValue)) {
			sql += " and keyword='"+ keyValue +"'";
		}
		return sql;
	}
	
	/**
	 * 创建日志归档表
	 * @param logDBId
	 * @param backTableName
	 * @throws Exception
	 */
	private void createLogBackTabel(String logDBId, String backTableName) throws Exception {
		DataSet dataSet = null;
		try {
			dataSet = JdbcUtil.getDataSet(logDBId);
			DatabaseMetaData metaData = dataSet.getConnection().getMetaData();
			// 验证表是否存在
			ResultSet rs = metaData.getTables(null, null, backTableName, new String[] { "TABLE" });
			// 如果表不存在，则创建表
			if (!rs.next()) {
				// 创表语句
				String sql="create table "+ backTableName +"(id varchar(36) primary key," +
						"opt int not null, keyword varchar(200) null," +
						"source_id varchar(36) not null, update_time varchar(50) not null)";
				try {
					dataSet.executeUpdate(sql);
				} catch (Exception e) {
					logger.warn("日志备份表存在");
				}
			}
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
		}
	}
	

	/**
	 * 新增、修改时。查询数据的方法,顺便修改不能归档的日志表数据状态
	 * @param dbId
	 * @param querySql
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> queryDataAndUpdateStatus(DataSet sourceDS, 
			String inQuerySql, DataSet logDS, String logTabName, 
			String sourcePkColumn, List<Object> idList) throws Exception {
		List<Map<String, Object>> objMapList = new ArrayList<Map<String, Object>>();
		ResultSet inRS = null;
		try {
			inRS = sourceDS.executeQuery(inQuerySql);
			ResultSetMetaData  metaData = inRS.getMetaData();
			int columnCount = metaData.getColumnCount();
			while (inRS.next()) {
				Map<String, Object> objMap = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					Object obj = inRS.getObject(i);
					String columnName = metaData.getColumnLabel(i).toLowerCase();
					if (columnName.equals(sourcePkColumn.toLowerCase())) {
						String objStr = String.valueOf(obj);
						for (Iterator it = idList.iterator(); it.hasNext();) {
							Map<String, Object> map = (Map<String, Object>) it.next();
							String sourceId = String.valueOf(map.get("source_id"));
							if (sourceId.equals(objStr)) {
								it.remove();
							}
						}
					}
					String columnClassName = metaData.getColumnClassName(i);
					int valueLength = metaData.getColumnDisplaySize(i);
					// 时间格式取出来的数据长度与实际不符
					if (obj instanceof Date && valueLength == 4) {
						String value = String.valueOf(obj);
						obj = value.substring(0, valueLength);
					} else if (columnClassName.equals("java.sql.Blob") && obj == null) {
						obj = new byte[0];
					}
					objMap.put(columnName, obj);
				}
				objMapList.add(objMap);
			}
			// 日志修改状态
			updateLogStatus(logDS, logTabName, idList);
		} finally {
			if (inRS != null) {
				inRS.close();
			}
		}
		return objMapList;
	}
	
	/**
	 * 删除时。查询数据的方法,顺便修改不能归档的日志表数据状态
	 * @param dbId
	 * @param querySql
	 * @return
	 * @throws Exception
	 */
	public void delQueryDataAndUpdateStatus(DataSet dataSet, 
			String inQuerySql, DataSet logDS, String logTabName, 
			String sourcePkColumn, List<Object> idList) throws Exception {
		ResultSet inRS = null;
		try {
			inRS = dataSet.executeQuery(inQuerySql);
			ResultSetMetaData  metaData = inRS.getMetaData();
			int columnCount = metaData.getColumnCount();
			while (inRS.next()) {
				for (int i = 1; i <= columnCount; i++) {
					Object obj = inRS.getObject(i);
					String columnName = metaData.getColumnLabel(i).toLowerCase();
					if (columnName.equals(sourcePkColumn.toLowerCase())) {
						String objStr = String.valueOf(obj);
						for (Iterator it = idList.iterator(); it.hasNext();) {
							Map<String, Object> map = (Map<String, Object>) it.next();
							String sourceId = String.valueOf(map.get("source_id"));
							if (sourceId.equals(objStr)) {
								it.remove();
							}
						}
					}
				}
			}
			// 日志修改状态
			updateLogStatus(logDS, logTabName, idList);
		} finally {
			if (inRS != null) {
				inRS.close();
			}
		}
	}
	
	private void updateLogStatus(DataSet logDS, String logTabName, 
			List<Object> idList) throws Exception {
		// 日志状态修改
		for (Object id : idList) {
			String updateLogSql = getUpdateLogStatusSql(logTabName, String.valueOf(id), "2");
			logDS.executeUpdate(updateLogSql);
		}
	}
	
}
