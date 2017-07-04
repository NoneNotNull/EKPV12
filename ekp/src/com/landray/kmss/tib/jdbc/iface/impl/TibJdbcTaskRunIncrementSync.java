package com.landray.kmss.tib.jdbc.iface.impl;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
 * 增量同步
 * 
 * @author qiujh
 */
public class TibJdbcTaskRunIncrementSync extends TibJdbcTaskBaseSync {
	private static final Log logger = LogFactory
			.getLog(TibJdbcTaskRunIncrementSync.class);
	private ITibJdbcTaskManageService tibJdbcTaskManageService;

	public void setTibJdbcTaskManageService(
			ITibJdbcTaskManageService tibJdbcTaskManageService) {
		this.tibJdbcTaskManageService = tibJdbcTaskManageService;
	}

	// 增量同步
	public Map<String, String> run(TibJdbcRelation tibJdbcRelation,JSONObject json) throws Exception {
		String deleteCondition = "";
		String filter = "";
		String lastUpdateTime = "";

		deleteCondition = json.getString("deleteCondition");
		filter = json.getString("filter");
		lastUpdateTime = json.getString("lastUpdateTime");
		JSONArray targetJsonArray = json.getJSONArray("targetTab");

		// 获取任务映射页面中手动设置的每个目标表主键
		Map<String, String> tabKeyMap = new HashMap<String, String>();
		if (targetJsonArray != null) {
			for (int i = 0; i < targetJsonArray.size(); i++) {
				JSONObject targetJsonObj = (JSONObject) targetJsonArray.get(i);
				String tabName = targetJsonObj.getString("targetTabName");
				String tabPk = targetJsonObj.getString("fieldPk");
				tabKeyMap.put(tabName, tabPk);
			}
		}

		Map<String, String> conditionMap = new HashMap<String, String>();
		TibJdbcMappManage tibJdbcMappManage = tibJdbcRelation.getTibJdbcMappManage();
		String dataSourceSql = tibJdbcMappManage.getFdDataSourceSql();
		String targetDbId = tibJdbcMappManage.getFdTargetSource();
		String sourceDbId = tibJdbcMappManage.getFdDataSource();

		// 检查该sql语句的末尾是否含有分号，有则截取掉
		dataSourceSql = checkSql(dataSourceSql);

		// 将单引号转换符转换成正常的单引号
		if (StringUtils.isNotEmpty(deleteCondition)) {
			deleteCondition = deleteCondition.replaceAll("&#39;", "'");
		}

		conditionMap.put("deleteCondition", deleteCondition);
		conditionMap.put("filter", filter);
		conditionMap.put("lastUpdateTime", lastUpdateTime);
		conditionMap.put("dataSourceSql", dataSourceSql);
		conditionMap.put("sourceDbId", sourceDbId);
		conditionMap.put("targetDbId", targetDbId);

		String configJson = tibJdbcMappManage.getFdMappConfigJson();
		configJson.replaceAll("\"", "\\\"");
		JSONObject jsonObj = JSONObject.fromObject(configJson);
		Iterator it = jsonObj.keySet().iterator();
		Map<String, LinkedHashMap<String, Object>> mappMap = new LinkedHashMap<String, LinkedHashMap<String, Object>>();
		List<String> tabList = new ArrayList<String>();
		String targetTabName = "";
		String sourcePk = "";

		FormulaParser formulaParser = FormulaParser.getInstance(tibJdbcMappManage);
		Map<String, String> returnMap = new HashMap<String, String>();
		
		while (it.hasNext()) {
			targetTabName = (String) it.next();
			tabList.add(targetTabName);

			List<String> fieldList = new ArrayList<String>();
			LinkedHashMap<String, Object> targetMap = new LinkedHashMap<String, Object>();
			StringBuffer insertBuffer = new StringBuffer();
			StringBuffer updateBuffer = new StringBuffer();
			StringBuffer selectBuffer = new StringBuffer();
			StringBuffer deleteBuffer = new StringBuffer();

			StringBuffer mappColumnBuffer = new StringBuffer();
			StringBuffer noMappColumnBuffer = new StringBuffer();
			StringBuffer noMappColumnUpdateBuffer = new StringBuffer();

			insertBuffer.append(" insert into ").append(targetTabName).append(" ( ");
			updateBuffer.append(" update  ").append(targetTabName).append(" set ");
			String insertValueSql = ")values(";
			deleteBuffer.append("delete from ").append(targetTabName).append(" where ");

			JSONArray jsonArray = (JSONArray) jsonObj.get(targetTabName);
			List<String> fieldInitList = new ArrayList<String>();
			String pkField = tabKeyMap.get(targetTabName);
			pkField = pkField.trim();

			String targetPk = "";
			String sourceMappPk = "";
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject jsonItem = jsonArray.getJSONObject(i);
				String targetFieldName = jsonItem.getString("fieldName");
				String sourceFieldName = jsonItem.getString("mappFieldName");
				String fieldInitData = jsonItem.getString("fieldInitData");

				// =========当目标表中含有未被映射的列且该列设置了初始化参数,则该列会被添加到sql语句中,否则不会被添加到sql语句中
				if (StringUtils.isEmpty(sourceFieldName)
						&& StringUtils.isNotEmpty(fieldInitData)) {
					noMappColumnBuffer.append(targetFieldName).append(",");
					noMappColumnUpdateBuffer.append(targetFieldName).append(
							"=?").append(",");
					fieldInitList.add(fieldInitData);
					insertValueSql += "?,";
				} else {
					// 如果该目标表字段已经被映射，不管初始化参数是否给定，该字段值用映射中源表所对应的字段值
					mappColumnBuffer.append(targetFieldName).append(",");
					updateBuffer.append(targetFieldName).append("=?").append(
							",");
					insertValueSql += "?,";
				}

				sourceFieldName = sourceFieldName.trim();

				// 如果该字段与手工设置的主键字段相同，则与该字段所映射的源表字段就为主键映射
				if (targetFieldName.toUpperCase().equals(pkField.toUpperCase())) {
					sourcePk = sourceFieldName;
					targetPk = targetFieldName;
					sourceMappPk = sourcePk;
				}

				String sourceTabFieldName = sourceFieldName;
				// 存放被映射了的字段(剔除掉即使被映射，但是值是由数据库自动生成而不能显示插值的数据列)
				if (StringUtils.isNotEmpty(sourceTabFieldName)) {
					fieldList.add(sourceTabFieldName);
				}
			}

			// 构建取目标表主键
			selectBuffer.append(" select ").append(targetPk).append(" from ").append(targetTabName).append(" where ");
			String selectSql = selectBuffer.toString();

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
			    //生成的sql语句: insert into test(column1,column2,column3,column4,column5)values(?,?,?,?,?);其中 column1到column3是映射的列 ,column4,column5未被映射的列,被映射的列放在前，未被映射的列放在后                                                    
				insertSql = insertSql + mappColumnSql + "," + noMappColumnSql;

			} else {
				// 目标表中的所有列都被映射
				insertSql = insertSql + mappColumnSql;
			}

			insertValueSql = insertValueSql.substring(0, insertValueSql.length() - 1);
			insertSql += insertValueSql + ")";

			// 构建updateSQL
			String updateSql = updateBuffer.toString();
			updateSql = updateSql.substring(0, updateSql.length() - 1);

			// 将目标表中未被映射的字段但是设置了初始值的列添加到sql语句中
			String updateTempSql = noMappColumnUpdateBuffer.toString();
			if (StringUtils.isNotEmpty(updateTempSql)&& updateTempSql.length() > 0) {
				updateSql += ","+updateTempSql.substring(0,updateTempSql.length() - 1);
			}

			updateSql = updateSql + " where " + targetPk + "=" + "?";
			// 构建deleteSQL
			String deleteSql = deleteBuffer.toString();

			targetMap.put("field", fieldList);
			targetMap.put("fieldInitList", fieldInitList);
			targetMap.put("insertSql", insertSql);
			targetMap.put("updateSql", updateSql);
			targetMap.put("selectSql", selectSql);
			targetMap.put("sourceMappPk", sourceMappPk);
			targetMap.put("targetMappPk", targetPk);
			targetMap.put("deleteSql", deleteSql);
			targetMap.put("deleteSqlValue", "");
			mappMap.put(targetTabName, targetMap);
		}

		// 删除数据操作记录的信息
		Map<String, String> deleteMessgMap = new HashMap<String, String>();

		// 迁移数据操作记录信息
		Map<String, Map<String, String>> messageMap = new HashMap<String, Map<String, String>>();
		try {
			// 有删除条件时，对目标表的数据进行删除操作
			if (StringUtils.isNotEmpty(deleteCondition)&& deleteCondition.length() > 0) {
				deleteMessgMap = doClearTargetTabData(sourcePk, conditionMap,tabList, mappMap);
			}
			// 进行源表数据到目标数据的更新或新增操作
			messageMap = doTransData(sourcePk, tabList, conditionMap, mappMap,formulaParser);
		} catch (Exception e) {
			throw e;
		}

		// 整理在整个迁移数据过程中的日志记录信息
		returnMap = getReturnMessage(messageMap, tabList, deleteMessgMap);

		// 重新设置更新时间值
		if (StringUtils.isNotEmpty(filter)) {
			setUpdatTime(tibJdbcRelation);
		}
		return returnMap;
	}

/**
 * 整理迁移结果返回的信息
 * @param messageMap
 * @param tabList
 * @param deleteMessgMap
 * @return
 */
	public Map<String, String> getReturnMessage(Map<String, Map<String, String>> messageMap, List<String> tabList,Map<String, String> deleteMessgMap) {
		Map<String, String> returnMap = new HashMap<String, String>();
		if (messageMap != null && messageMap.size() > 0) {
			Map<String, String> inforMap = messageMap.get("informessage");
			if (inforMap == null) {
				String successMessage = "";
				String errorDetailMessage = "";
				if (deleteMessgMap != null && deleteMessgMap.size() > 0) {
					String deleteMessage = deleteMessgMap.get("deleteMessage");
					String deleteTime = deleteMessgMap.get("deleteTime");
					String deleteFlag = deleteMessgMap.get("deleteFlag");
					if ("true".equals(deleteFlag)) {
						successMessage += deleteMessage + "用时:" + deleteTime+"\r\n";
					} else {
						errorDetailMessage += deleteMessage;
					}
				}
				boolean flag = true;
				for (int i = 0; i < tabList.size(); i++) {
					String commonInfor = "表";
					String errorDetailInfor = "表";
					String tabName = tabList.get(i);
					Map<String, String> tabMap = messageMap.get(tabName);
					String updateSuccessCount = tabMap.get("updateSuccessCount");
					String insertSuccessCount = tabMap.get("insertSuccessCount");
					String updateErrorCount = tabMap.get("updateErrorCount");
					String insertErrorCount = tabMap.get("insertErrorCount");
					String updateErrorInfor = tabMap.get("updateErrorInfor");
					String insertErrorInfor = tabMap.get("insertErrorInfor");
					commonInfor += tabName + ":";
					if (StringUtils.isNotEmpty(updateSuccessCount)) {
						int updateCount = Integer.parseInt(updateSuccessCount);
						if (updateCount > 0) {
							commonInfor += "更新成功:" + updateCount + "条," + "\r\n";
						}
					}
	
					if (StringUtils.isNotEmpty(insertSuccessCount)) {
						int insertCount = Integer.parseInt(insertSuccessCount);
						if (insertCount > 0) {
							commonInfor += "新增成功:" + insertCount + "条" + "\r\n";
						}
					}
					// 更新失败
					if (StringUtils.isNotEmpty(updateErrorCount)) {
						int updateErrorNum = Integer.parseInt(updateErrorCount);
						if (updateErrorNum > 0) {
							errorDetailInfor += "更新失败:" + updateErrorNum + "条,id值:"+ updateErrorInfor + "\r\n";
						}
					}
					// 新增失败
					if (StringUtils.isNotEmpty(insertErrorCount)) {
						int insertErrorNum = Integer.parseInt(insertErrorCount);
						if (insertErrorNum > 0) {
							errorDetailInfor += "新增失败:" + insertErrorNum + "条,id值:"+ insertErrorInfor + "\r\n";
						}
					}
	
					// 成功
					if (!StringUtils.isNotEmpty(updateErrorCount)&& !StringUtils.isNotEmpty(insertErrorCount)) {
						successMessage += commonInfor + "\r\n";
					}
	
					// 失败
					if (StringUtils.isNotEmpty(updateErrorCount)|| StringUtils.isNotEmpty(insertErrorCount)) {
						flag = false;
						errorDetailMessage += commonInfor + "\r\n"+ errorDetailInfor;
					}
				}
	
				returnMap.put("message", successMessage);
				if (!flag) {
					returnMap.put("errorDetail", errorDetailMessage);
				} else {
					returnMap.put("errorDetail", "");
				}
			
			}else{
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
 * 
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
 * 根据删除条件，先到源SQL结果集中取出符合删除的数据，然后取出该数据中与每一个目标表对应的主键字段值，
 * 根据所对应的主键值到目标表中检查，是否目标表中存在该主键值的数据，如果存在就删除掉目标表中主键值为该值的数据
 * @param sourcePk
 * @param conditionMap
 * @param tabList
 * @param mappMap
 * @return
 * @throws Exception
 */
	public Map<String, String> doClearTargetTabData(String sourcePk,Map<String, String> conditionMap, List<String> tabList,Map<String, LinkedHashMap<String, Object>> mappMap)throws Exception {
		CompDbcp sourceCompDbcp = null;
		DataSet targetDs = null;
		String countSql = "";
		String selectSql = "";
		Map<String, String> messageMap = new HashMap<String, String>();
	
		try {
			String sourceDbId = conditionMap.get("sourceDbId");
			String targetDbId = conditionMap.get("targetDbId");
			sourceCompDbcp = JdbcUtil.getCompDbcp(sourceDbId);
			targetDs = JdbcUtil.getDataSet(targetDbId);

			String deleteCondition = conditionMap.get("deleteCondition");
			String dataSourceSql = conditionMap.get("dataSourceSql");
			String lastUpdateTime = conditionMap.get("lastUpdateTime");
			String filter = conditionMap.get("filter");

			// 数据库类型
			String dbType = sourceCompDbcp.getFdType().trim();
			if (StringUtils.isNotEmpty(deleteCondition)&& deleteCondition.length() > 0) {
				countSql = "select count(0) from (" + dataSourceSql+ ")  tempTab " + " where " + deleteCondition;
				selectSql = "select * from (" + dataSourceSql + ")  tempTab"+ " where " + deleteCondition;

				if (StringUtils.isNotEmpty(filter)&& StringUtils.isNotEmpty(lastUpdateTime)) {
					if (dbType.equals(JdbcUtil.DB_TYPE_MYSQL)) {
						countSql = countSql + " and  " + filter  +" >='"+ lastUpdateTime +"'";
						selectSql = selectSql + " and " + filter + ">='"+ lastUpdateTime +"'";
					} else if (dbType.equals(JdbcUtil.DB_TYPE_MSSQLSERVER)) {
						countSql = countSql + " and  " + filter + ">='"+ lastUpdateTime +"'"; 
						selectSql = selectSql + " and  " + filter + ">='"+ lastUpdateTime +"'";
					} else if (dbType.equals(JdbcUtil.DB_TYPE_ORACLE)) {
						countSql = countSql + " and TO_DATE(TO_CHAR(" + filter + ",'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss')>="+ " TO_DATE('" + lastUpdateTime + "',"+ "'yyyy-MM-dd hh24:mi:ss')";
						selectSql = selectSql + " and TO_DATE(TO_CHAR(" + filter + ",'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss')>="+ " TO_DATE('" + lastUpdateTime + "',"+ "'yyyy-MM-dd hh24:mi:ss')";
					} else if (dbType.equals(JdbcUtil.DB_TYPE_DB2)) {
						countSql = countSql + " and " + filter + ">='"+  lastUpdateTime+"'";
						selectSql = selectSql + " and " + filter + ">='"+ lastUpdateTime+"'";
					}
				}

				int batchCount = 0;
				// 得到需要删除数据总数据条数结果
				int totalCount = this.getTotalCount(sourceDbId, countSql);

				// 根据得到删除总数据条数 可以得到批处理次数
				if (totalCount > 0 && totalCount > TibJdbcConstant.batchSize) {
					batchCount = totalCount % TibJdbcConstant.batchSize == 0 ? totalCount/ TibJdbcConstant.batchSize: (totalCount / TibJdbcConstant.batchSize + 1);
				} else if (totalCount > 0 && totalCount <= TibJdbcConstant.batchSize) {
					batchCount = 1;
				}

				if (batchCount > 0) {
					Page page = new Page(1, TibJdbcConstant.batchSize, totalCount, selectSql, sourcePk);

					// 进行目标表数据的删除
					for (int batchNum = 1; batchNum <= batchCount; batchNum++) {
						page.setCurrentPage(batchNum); 
						List<Object> resultList = JdbcUtil.getQueryList(sourceDbId, page);

						// 取得目标表中本批次进行删除的数据id字符串
						for (int rowIndex = 0; rowIndex < resultList.size(); rowIndex++) {
							Map<String, Object> columnMap = (Map<String, Object>) resultList.get(rowIndex);
							for (int i = 0; i < tabList.size(); i++) {
								String tabName = tabList.get(i);
								Map<String, Object> tabInforMap = mappMap.get(tabName);
								String deleteSqlValue = (String) tabInforMap.get("deleteSqlValue");
								
								Object sourceMappPk = tabInforMap.get("sourceMappPk");
								Object targetMappPk = tabInforMap.get("targetMappPk");
								Object targetPkValue = columnMap.get(sourceMappPk);
								
								if (targetPkValue != null) {
									deleteSqlValue += " " + targetMappPk + "='"+ targetPkValue + "'" + " or ";
									tabInforMap.put("deleteSqlValue",deleteSqlValue);
								}
							}
						}

						try {
							targetDs.beginTran();
							Long startTime = System.currentTimeMillis();
							for (int i = 0; i < tabList.size(); i++) {
								String tabName = tabList.get(i);
								Map<String, Object> tabInforMap = mappMap.get(tabName);
								String deleteSqlValue = (String) tabInforMap.get("deleteSqlValue");
								String deleteSql = (String) tabInforMap.get("deleteSql");
								
								if (StringUtils.isNotEmpty(deleteSqlValue)) {
									int indexNum = deleteSqlValue.lastIndexOf("or");
									deleteSqlValue = deleteSqlValue.substring(0, indexNum);
									deleteSql = deleteSql + deleteSqlValue + "";
									System.out.println(deleteSql);
									// 删除目标表中需要删除的数据
									targetDs.executeUpdate(deleteSql);
								}
							}
							targetDs.commit();
							
							Long endTime = System.currentTimeMillis();
							messageMap.put("deleteMessage","删除目标表数据");
							Long takeTime=(endTime - startTime) / 1000;
							takeTime = takeTime>0 ? takeTime: 1;
							messageMap.put("deleteTime", ""+takeTime+" s" );
							messageMap.put("deleteFlag", "true");
						} catch (Exception e) {
							e.printStackTrace();
							targetDs.rollback();
							messageMap.put("deleteMessage", e.getMessage());
							messageMap.put("deleteTime", "");
							messageMap.put("deleteFlag", "false");
						} finally {
							if (targetDs != null) {
								targetDs.close();
							}
						}
					}
				}
			}

		} catch (Exception e) {
			logger.error("删除目标数据出错:" + e.getMessage());
			e.printStackTrace();
			throw e;
		} finally {
			if (targetDs != null) {
				targetDs.close();
			}
		}
		return messageMap;
	}

	
/**
 * 数据迁移
 * @param sourcePk
 * @param tabList
 * @param conditionMap
 * @param mappMap
 * @return
 * @throws Exception
 */
	public Map<String, Map<String, String>> doTransData(String sourcePk,List<String> tabList, Map<String, String> conditionMap,Map<String, LinkedHashMap<String, Object>> mappMap,FormulaParser formulaParser) throws Exception {
		CompDbcp sourceCompDbcp = null;
		DataSet sourceDs = null;
		DataSet targetDs = null;

		String countSql = "";
		String selectSql = "";
		Map<String, Map<String, String>> messageMap = new HashMap<String, Map<String, String>>();
		try {
			String sourceDbId = conditionMap.get("sourceDbId");
			String targetDbId = conditionMap.get("targetDbId");

			sourceCompDbcp = JdbcUtil.getCompDbcp(sourceDbId);
			sourceDs = JdbcUtil.getDataSet(sourceDbId);
			targetDs = JdbcUtil.getDataSet(targetDbId);
			Connection conn = targetDs.getConnection();

			String dataSourceSql = conditionMap.get("dataSourceSql");
			String lastUpdateTime = conditionMap.get("lastUpdateTime");
			String filter = conditionMap.get("filter");

			countSql = "select count(0) from (" + dataSourceSql + ")  tempTab";
			selectSql = "select * from (" + dataSourceSql + ")  tempTab";

			// 数据库类型
			String dbType = sourceCompDbcp.getFdType().trim();

			if (StringUtils.isNotEmpty(filter)&& StringUtils.isNotEmpty(lastUpdateTime)) {
				if (dbType.equals(JdbcUtil.DB_TYPE_MYSQL)) {
					countSql = countSql + " where  "+filter+" >='"+lastUpdateTime+"'";
					selectSql = selectSql + " where "+filter+" >='"+lastUpdateTime+"'";
				} else if (dbType.equals(JdbcUtil.DB_TYPE_MSSQLSERVER)) {
					countSql = countSql + " where "+filter +" >='"+lastUpdateTime+"'";
					selectSql = selectSql + " where "+filter +" >='"+lastUpdateTime+"'";
				} else if (dbType.equals(JdbcUtil.DB_TYPE_ORACLE)) {
					countSql = countSql + " where TO_DATE(TO_CHAR(" + filter + ",'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss')>="+ " TO_DATE('" + lastUpdateTime + "',"+ "'yyyy-MM-dd hh24:mi:ss')";
					selectSql = selectSql + " where TO_DATE(TO_CHAR(" + filter + ",'yyyy-MM-dd hh24:mi:ss'),'yyyy-MM-dd hh24:mi:ss')>="+ " TO_DATE('" + lastUpdateTime + "',"+ "'yyyy-MM-dd hh24:mi:ss')";
				} else if (dbType.equals(JdbcUtil.DB_TYPE_DB2)) {
					countSql = countSql + " where " + filter + " >='"+  lastUpdateTime+"'";
					selectSql = selectSql + " where " + filter + " >='"+ lastUpdateTime+"'";
				}
			}

			int batchCount = 0;
			int totalCount = this.getTotalCount(sourceDbId, countSql);

			// 根据得到需要迁移的数据 可以得到批处理次数
			if (totalCount > 0 && totalCount > TibJdbcConstant.batchSize) {
				batchCount = totalCount % TibJdbcConstant.batchSize == 0 ? totalCount/ TibJdbcConstant.batchSize: (totalCount / TibJdbcConstant.batchSize + 1);
			} else if (totalCount > 0 && totalCount <= TibJdbcConstant.batchSize) {
				batchCount = 1;
			}

			if (batchCount > 0) {
				Page page = new Page(1, TibJdbcConstant.batchSize, totalCount, selectSql, sourcePk);

				for (int batchNum = 1; batchNum <= batchCount; batchNum++) {
					page.setCurrentPage(batchNum);
					List<Object> resultList = JdbcUtil.getQueryList(sourceDbId,page);
					// 这里注意,需先执行父表再执行子表
					for (int tabIndex = tabList.size() - 1; tabIndex >= 0; tabIndex--) {
						String pkValues = "";
						String targetTabName = tabList.get(tabIndex);

						boolean autoCommit = conn.getAutoCommit();
						// 批量操作开始事务
						if (autoCommit) {
							conn.setAutoCommit(false);
						}

						Map<String, Object> tempMap = mappMap.get(targetTabName);
						String selectTargetSql = (String) tempMap.get("selectSql");
						List<Object> fieldList = (List<Object>) tempMap.get("field");
						List<Object> fieldInitList = (List<Object>) tempMap.get("fieldInitList");
						String targetMappPk = (String) tempMap.get("targetMappPk");
						String sourceMappPk = (String) tempMap.get("sourceMappPk");

						Map<Object, Object> updatePkMap = new HashMap<Object, Object>();

						// 该目标表是否有主键被映射
						if (StringUtils.isNotEmpty(sourceMappPk)&& StringUtils.isNotEmpty(targetMappPk)) {
							for (int rowIndex = 0; rowIndex < resultList.size(); rowIndex++) {
								Map<String, Object> columMap = (Map<String, Object>) resultList.get(rowIndex);
								Object pk = columMap.get(sourceMappPk);
								if (pk != null) {
									pkValues += "" + targetMappPk + "='" + pk+ "'" + " or ";
								}
							}

							// 得到本批次目标数据表中需要更新的数据
							if (StringUtils.isNotEmpty(pkValues)&& pkValues.length() > 0) {
								int indexNum = pkValues.lastIndexOf("or");
								if (indexNum > 0) {
									pkValues = pkValues.substring(0, indexNum);
								}
								selectTargetSql += pkValues;
								// 根据映射中的源表主键值，到目标表中查询出源表主键值出现在目标表中的数据的主键
								ResultSet targetRSet = targetDs.executeQuery(selectTargetSql);

								if (targetRSet != null) {
									while (targetRSet.next()) {
										Object updatPkValue = targetRSet.getObject(targetMappPk);
										updatePkMap.put(updatPkValue,updatPkValue);
									}
									targetRSet.close();
								}
							}
						}
						
						//=========测试代码begin   输出当前行中的每列信息======================
						for (int m = 0; m < resultList.size(); m++) {
							Map<String, Object> columMap = (Map<String, Object>) resultList.get(m);
							String str = "";
							for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
								str += fieldList.get(columnIndex)+ "="+ columMap.get(fieldList.get(columnIndex)) + ",";
							}
							//System.out.println("当前行是第" + m + "行,数据信息:" + str);
						}
						//=========测试代码end    输出当前行中的每列信息======================
						
						// 准备批量下的新增和更新
						Map<String, PreparedStatement> resultMap = getBatchPreparStetament(resultList,updatePkMap, conn, tempMap, formulaParser);
						Map<String, String> newMap = new HashMap<String, String>();
						PreparedStatement updatePs = null;
						PreparedStatement insertPs = null;
						int updateSuccessCount = 0;
						int insertSuccessCount = 0;

						try {
							updatePs = resultMap.get("updatePs");
							insertPs = resultMap.get("insertPs");
							
							insertSuccessCount = insertPs.executeBatch().length;
							insertPs.clearBatch();
							if (updatePs != null) {
								updateSuccessCount = updatePs.executeBatch().length;//executeUpdate();
								updatePs.clearBatch();
							}
							
							targetDs.commit();

							// 本次批量更新成功后，记录对应的更新成功信息
							if (messageMap.get(targetTabName) != null) {
								Map<String, String> oldMap = messageMap.get(targetTabName);
								String old_updateSuccessCount = oldMap.get("updateSuccessCount");
								String old_insertSuccessCount = oldMap.get("insertSuccessCount");
								if (StringUtils.isNotEmpty(old_updateSuccessCount)) {
									int updateSuccessCountValue = Integer.parseInt(old_updateSuccessCount)+ updateSuccessCount;
									oldMap.put("updateSuccessCount", ""+ updateSuccessCountValue);
								}

								if (StringUtils.isNotEmpty(old_insertSuccessCount)) {
									int insertSuccessCountValue = Integer.parseInt(old_insertSuccessCount)+ insertSuccessCount;
									oldMap.put("insertSuccessCount", ""+ insertSuccessCountValue);
								}
							} else {
									newMap.put("updateSuccessCount", ""+ updateSuccessCount);
									newMap.put("insertSuccessCount", ""+ insertSuccessCount);
									newMap.put("updateErrorCount", "");
									newMap.put("insertErrorCount", "");
									newMap.put("updateErrorInfor", "");
									newMap.put("insertErrorInfor", "");
									messageMap.put(targetTabName, newMap);
							}

						} catch (Exception e) {
							//e.printStackTrace();
							logger.error("执行一批数据出错，等待回滚重新执行，错误为："+ e.getMessage());
							targetDs.rollback();
							
							// 如果批量操作失败，则进行该批次下一条一条的执行
//							if (insertSuccessCount > 0|| updateSuccessCount > 0) {
								newMap = doBatchByOneByOne(resultList, updatePkMap,conn, targetTabName, tempMap,formulaParser);
								if (messageMap.get(targetTabName) != null) {
									Map<String, String> oldMap = messageMap.get(targetTabName);
									// 记录本次没有在事物条件下进行数据的更新后插入的结果信息
									getUpdateOrInsertReturnMessage(newMap,oldMap);
								} else {
									messageMap.put(targetTabName, newMap);
								}
//							} else {
//								throw e;
//							}
						} finally {
							if (insertPs != null) {
								insertPs.close();
							}
							if (updatePs != null) {
								updatePs.close();
							}
						}
					}
					//System.out.println("第"+ batchNum +"批数据同步耗时："+ (System.currentTimeMillis() - startTime) +"秒");
				}
			}else{
				Map<String,String> newMap=new HashMap<String,String>();
		    	newMap.put("informessage", "通过sql语句查询源表,符合迁移的数据为0条");
		    	messageMap.put("informessage", newMap);
			}
		} catch (Exception e) {
			logger.error("向目标表插入数据出错:" + e.getMessage());
			targetDs.rollback();
			throw e;
		} finally {
			if (sourceDs != null) {
				sourceDs.close();
			}
			if (targetDs != null) {
				targetDs.close();
			}
		}
		return messageMap;
	}

	
/**
 * 汇总在迁移数据的过程中每张表各种操作的详细信息数据
 * 
 * @param newMap
 * @param oldMap
 * @return
 */
	public void getUpdateOrInsertReturnMessage(Map<String, String> newMap,Map<String, String> oldMap) {

		int updateSuccessCountValue = 0;
		int insertSuccessCountValue = 0;
		int updateErrorCountValue = 0;
		int insertErrorCountValue = 0;
		String updateErrorValue = "";
		String insertErrorValue = "";

		String new_updateSuccessCount = newMap.get("updateSuccessCount");
		String new_insertSuccessCount = newMap.get("insertSuccessCount");
		String new_updateErrorCount = newMap.get("updateErrorCount");
		String new_insertErrorCount = newMap.get("insertErrorCount");

		String new_updateErrorInfor = newMap.get("updateErrorInfor");
		String new_insertErrorInfor = newMap.get("insertErrorInfor");

		String old_updateSuccessCount = oldMap.get("updateSuccessCount");
		String old_insertSuccessCount = oldMap.get("insertSuccessCount");
		String old_updateErrorCount = oldMap.get("updateErrorCount");
		String old_insertErrorCount = oldMap.get("insertErrorCount");

		String old_updateErrorInfor = oldMap.get("updateErrorInfor");
		String old_insertErrorInfor = oldMap.get("insertErrorInfor");

		// 更新成功条数
		if (StringUtils.isNotEmpty(new_updateSuccessCount)) {
			    updateSuccessCountValue = Integer.parseInt(new_updateSuccessCount);
			if (StringUtils.isNotEmpty(old_updateSuccessCount)) {
				updateSuccessCountValue += Integer.parseInt(old_updateSuccessCount);
			}
		}

		// 更新失败条数
		if (StringUtils.isNotEmpty(new_updateErrorCount)) {
			    updateErrorCountValue = Integer.parseInt(new_updateErrorCount);
			if (StringUtils.isNotEmpty(old_updateSuccessCount)) {
				updateErrorCountValue += Integer.parseInt(old_updateErrorCount);
			}
		}

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

		// 更新失败的id
		if (StringUtils.isNotEmpty(new_updateErrorInfor)) {
			updateErrorValue = old_updateErrorInfor + ","+ new_updateErrorInfor;
		}

		// 新增失败的id
		if (StringUtils.isNotEmpty(new_insertErrorInfor)) {
			insertErrorValue = old_insertErrorInfor + ","+ new_insertErrorInfor;
		}

		oldMap.put("updateSuccessCount", "" + updateSuccessCountValue);
		oldMap.put("insertSuccessCount", "" + insertSuccessCountValue);
		oldMap.put("updateErrorCount", "" + updateErrorCountValue);
		oldMap.put("insertErrorCount", "" + insertErrorCountValue);
		oldMap.put("updateErrorInfor", updateErrorValue);
		oldMap.put("insertErrorInfor", insertErrorValue);
	}

	
/***
 * 批处理失败后，进行该批次数据一条一条的进行处理，查找出错误数据信息
 * 
 * @param resultList
 * @param fieldList
 * @param updatePkMap
 * @param conn
 * @param targetTabName
 * @param tempMap
 * @return
 */
	public Map<String, String> doBatchByOneByOne(List<Object> resultList,Map<Object, Object> updatePkMap, Connection conn,String targetTabName, Map<String, Object> tempMap,
			FormulaParser formulaParser) {
		PreparedStatement updatePs = null;
		PreparedStatement insertPs = null;
		Map<String, String> resultMap = new HashMap<String, String>();
		String sourceMappPk = (String) tempMap.get("sourceMappPk");
		String updateSql = (String) tempMap.get("updateSql");
		String insertSql = (String) tempMap.get("insertSql");
		List<Object> fieldList = (List<Object>) tempMap.get("field");
		List<Object> fieldInitList = (List<Object>) tempMap.get("fieldInitList");

		int updateSuccessCount = 0;
		int insertSuccessCount = 0;
		int updateErrorCount = 0;
		int insertErrorCount = 0;

		String updateErrorInfor = "";
		String insertErrorInfor = "";

		try {
			if (updatePkMap.size() > 0) {
				// 准备更新
				updatePs = conn.prepareStatement(updateSql);
			}
				// 准备新增
			    insertPs = conn.prepareStatement(insertSql);
			    
		} catch (SQLException e) {
			e.printStackTrace();
			resultMap.put("sqlError", e.getMessage());
		}

		for (int rowIndex = 0; rowIndex < resultList.size(); rowIndex++) {
			Map<String, Object> columMap = (Map<String, Object>) resultList.get(rowIndex);
			String currentPk = (String) columMap.get(sourceMappPk);
			if (updatePkMap.size() <= 0) {
				try {
					// 如果没有需要更新的数据，则全部数据是要新增的
					for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
						this.setObjectColumn(insertPs, columnIndex + 1,columMap.get(fieldList.get(columnIndex)));
					}
					
					// 对没有被映射的字段但设置了初始参数的字段设值
					if (fieldInitList != null && fieldInitList.size() > 0) {
						int count = fieldList.size();
						for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
							Object fieldInitData = fieldInitList.get(fieldIndex);
							// 如果输入的是一个表达式,则进行转换计算成对应的值
							Object objValue = parseExpression((String) fieldInitData);
							this.setObjectColumn(insertPs, count + fieldIndex+ 1, objValue);
						}
					}
					
					insertPs.executeUpdate();
					insertSuccessCount++;
					
				} catch (Exception e) {
					insertErrorCount++;
					insertErrorInfor += currentPk + ",";
					//e.printStackTrace();
					logger.error("执行出错，出错主键为："+ currentPk +"，错误为："+ e.getMessage());
				}

			} else {// 部分数据更新 部分数据新增
				
				// 更新操作设值
				if (StringUtils.isNotEmpty(currentPk)&& updatePkMap.containsKey(currentPk)) {
					try {
						for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
							this.setObjectColumn(updatePs, columnIndex + 1,columMap.get(fieldList.get(columnIndex)));
						}

						// 对没有被映射的字段但设置了初始参数的字段设值
						int countNum=fieldList.size();
						if (fieldInitList != null && fieldInitList.size() > 0) {
							int count = fieldList.size();
							countNum+=fieldInitList.size();
							for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
								Object fieldInitData = fieldInitList.get(fieldIndex);
								// 如果输入的是一个表达式,则进行转换计算成对应的值
								Object objValue = parseExpression((String) fieldInitData);
								this.setObjectColumn(updatePs, count+ fieldIndex + 1, objValue);
							}
						}

						// 设置where条件
						this.setObjectColumn(updatePs, countNum + 1,columMap.get(sourceMappPk));
						updatePs.executeUpdate();
						updateSuccessCount++;
						
					} catch (Exception e) {
						e.printStackTrace();
						updateErrorCount++;
						updateErrorInfor += currentPk + ",";
					}
				} else {
					
					// 新增操作设值
					if (StringUtils.isNotEmpty(sourceMappPk)&& StringUtils.isNotEmpty(sourceMappPk)) {
						try {
							for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
								this.setObjectColumn(insertPs,columnIndex + 1,columMap.get(fieldList.get(columnIndex)));
							}
							
							// 对没有被映射的字段但设置了初始参数的字段设值
							if (fieldInitList != null&& fieldInitList.size() > 0) {
								int count = fieldList.size();
								for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
									Object fieldInitData = fieldInitList.get(fieldIndex);
									// 如果输入的是一个表达式,则进行转换计算成对应的值
									Object objValue = parseExpression((String) fieldInitData);
									this.setObjectColumn(insertPs, count+ fieldIndex + 1, objValue);
								}
							}
							
							insertPs.executeUpdate();
							insertSuccessCount++;
							
						} catch (Exception e) {
							insertErrorCount++;
							insertErrorInfor += currentPk + ",";
							//e.printStackTrace();
							logger.error("执行出错，出错主键为："+ currentPk +"，错误为："+ e.getMessage());
						}
					}
				}
			}
		}

		// 失败id信息
		if (updateErrorCount > 0) {
			updateErrorInfor = updateErrorInfor.substring(0, updateErrorInfor.length() - 1);
		}
		
		if (insertErrorCount > 0) {
			insertErrorInfor = insertErrorInfor.substring(0, insertErrorInfor.length() - 1);
		}
		
		resultMap.put("updateSuccessCount", "" + updateSuccessCount);
		resultMap.put("insertSuccessCount", "" + insertSuccessCount);
		resultMap.put("updateErrorCount", "" + updateErrorCount);
		resultMap.put("insertErrorCount", "" + insertErrorCount);
		resultMap.put("updateErrorInfor", updateErrorInfor);
		resultMap.put("insertErrorInfor", insertErrorInfor);
		return resultMap;
	}

/**
 * 预处理批量的插入和更新
 * @param resultList
 * @param updatePkMap
 * @param conn
 * @param tempMap
 * @param formulaParser
 * @return
 * @throws SQLException
 * @throws IOException
 */
	public Map<String, PreparedStatement> getBatchPreparStetament(List<Object> resultList,Map<Object, Object> updatePkMap,Connection conn, Map<String, Object> tempMap,
			FormulaParser formulaParser) throws SQLException, IOException {

		Map<String, PreparedStatement> resultMap = new HashMap<String, PreparedStatement>();
		PreparedStatement updatePs = null;
		PreparedStatement insertPs = null;
		String sourceMappPk = (String) tempMap.get("sourceMappPk");
		String updateSql = (String) tempMap.get("updateSql");
		String insertSql = (String) tempMap.get("insertSql");
		List<Object> fieldList = (List<Object>) tempMap.get("field");
		List<Object> fieldInitList = (List<Object>) tempMap.get("fieldInitList");
		int insertCount=0;
		int updateCount=0;
		
		// 准备更新
		if (updatePkMap.size() > 0) {
			updatePs = conn.prepareStatement(updateSql);
		}
		
		// 准备新增
		insertPs = conn.prepareStatement(insertSql);
		
		for (int rowIndex = 0; rowIndex < resultList.size(); rowIndex++) {
			Map<String, Object> columMap = (Map<String, Object>) resultList.get(rowIndex);
			Object currentPk = columMap.get(sourceMappPk);
			
			if (updatePkMap.size() <= 0) {
				// 如果没有需要更新的数据，则全部数据是要新增的
				for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
					this.setObjectColumn(insertPs, columnIndex + 1, columMap.get(fieldList.get(columnIndex)));
				}
				
				// 对没有被映射的字段但设置了初始参数的字段设值
				if (fieldInitList != null && fieldInitList.size() > 0) {
					int count = fieldList.size();
					for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
						Object fieldInitData = fieldInitList.get(fieldIndex);
						// 如果输入的是一个表达式,则进行转换计算成对应的值
						Object objValue = parseExpression((String) fieldInitData);
						this.setObjectColumn(insertPs, count + fieldIndex + 1, objValue);
					}
				}
				
				insertPs.addBatch();
				insertCount++;
				
			} else {// 部分数据更新 部分数据新增
				
				// 更新操作设值
				if (currentPk != null && updatePkMap.containsKey(currentPk)) {
					for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
						this.setObjectColumn(updatePs, columnIndex + 1, columMap.get(fieldList.get(columnIndex)));
					}

					int countNum=fieldList.size();
					// 对没有被映射的字段但设置了初始参数的字段设值
					if (fieldInitList != null && fieldInitList.size() > 0) {
						int count = fieldList.size();
						countNum+=fieldInitList.size();
						for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
							Object fieldInitData = fieldInitList.get(fieldIndex);
							// 如果输入的是一个表达式,则进行转换计算成对应的值
							Object objValue = parseExpression((String) fieldInitData);
							this.setObjectColumn(updatePs, count + fieldIndex + 1, objValue);
						}
					}

					// 设置where条件
					this.setObjectColumn(updatePs, countNum+ 1, columMap.get(sourceMappPk));
					updatePs.addBatch();
					updateCount++;
					
				} else {
					// 新增操作设值
					for (int columnIndex = 0; columnIndex < fieldList.size(); columnIndex++) {
						this.setObjectColumn(insertPs, columnIndex + 1, columMap.get(fieldList.get(columnIndex)));
					}
					// 对没有被映射的字段但设置了初始参数的字段设值
					if (fieldInitList != null && fieldInitList.size() > 0) {
						int count = fieldList.size();
						for (int fieldIndex = 0; fieldIndex < fieldInitList.size(); fieldIndex++) {
							Object fieldInitData = fieldInitList.get(fieldIndex);
							// 如果输入的是一个表达式,则进行转换计算成对应的值
							Object objValue = parseExpression((String) fieldInitData);
							this.setObjectColumn(insertPs, count + fieldIndex + 1, objValue);
						}
					}
					
					insertPs.addBatch();
					insertCount++;
				}
			}
		}
		
		//System.out.println("当前批次中,总共参与执行的数据有:"+(insertCount+updateCount)+"条,被执行新增的数据有:"+insertCount+"条,被执行更新的数据有:"+updateCount+"条");
		resultMap.put("insertPs", insertPs);
		resultMap.put("updatePs", updatePs);
		return resultMap;
	}

	/**
	 * 将本次迁移数据动作的时间回写到映射关联对象中
	 * 
	 * @param tibJdbcRelation
	 * @throws Exception
	 */
	public void setUpdatTime(TibJdbcRelation tibJdbcRelation) throws Exception {
		String syncTypeJson = tibJdbcRelation.getFdSyncType();
		String lastUpdateTime = "";
		syncTypeJson.replaceAll("\"", "\\\"");
		JSONObject jsonObj = JSONObject.fromObject(syncTypeJson);
		Date now = new Date();
		DateFormat df = DateFormat.getDateTimeInstance();
		lastUpdateTime = df.format(now);
		jsonObj.put("lastUpdateTime", lastUpdateTime);
		tibJdbcRelation.setFdSyncType(jsonObj.toString());
		tibJdbcTaskManageService.update(tibJdbcRelation);
	}
}
