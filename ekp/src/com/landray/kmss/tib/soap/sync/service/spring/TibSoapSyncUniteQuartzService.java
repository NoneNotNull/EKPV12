package com.landray.kmss.tib.soap.sync.service.spring;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import net.sf.json.JSONObject;

import org.apache.commons.httpclient.util.DateParseException;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.util.HtmlUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;
import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.interfaces.ITibCommonLogInterface;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.util.DomUtil;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncJob;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncTempFunc;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncJobService;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncTempFuncService;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncUniteQuartz;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.StringUtil;

/**
 * soap定时任务统一服务
 * 
 * @author zhangtian
 * 
 * @version 2012-2-15
 */

public class TibSoapSyncUniteQuartzService implements ITibSoapSyncUniteQuartz {

	private Log logger = LogFactory.getLog(this.getClass());
	private Date lastTime = null;
	private String fdDeleteExpression = null;
	private ITibSoapSyncJobService tibSoapSyncJobService;
	private ITibSysSoap tibSysSoap;
	private ITibSoapSyncTempFuncService tibSoapSyncTempFuncService;
	private ITibCommonLogInterface tibCommonLogInterface;
	
	public void setTibSoapSyncJobService(
			ITibSoapSyncJobService tibSoapSyncJobService) {
		this.tibSoapSyncJobService = tibSoapSyncJobService;
	}

	public void setTibSysSoap(ITibSysSoap tibSysSoap) {
		this.tibSysSoap = tibSysSoap;
	}

	public void setTibSoapSyncTempFuncService(
			ITibSoapSyncTempFuncService tibSoapSyncTempFuncService) {
		this.tibSoapSyncTempFuncService = tibSoapSyncTempFuncService;
	}

	public void setTibCommonLogInterface(
			ITibCommonLogInterface tibCommonLogInterface) {
		this.tibCommonLogInterface = tibCommonLogInterface;
	}

	/**
	 * 定时任务执行的方法
	 */
	public void methodJob(SysQuartzJobContext sysQuartzJobContext)
			throws Exception {
		logger.debug("开始执行SAP定时任务");
		JSONObject jsonObj = JSONObject.fromObject(sysQuartzJobContext.getParameter());
		String tibSoapSyncId = (String) jsonObj.get("soapQuartzId");
		mappingJob(tibSoapSyncId);
	}
	
	/**
	 * 执行映射任务
	 * @param tibSoapSyncId soap定时任务类id
	 * @throws Exception
	 */
	private void mappingJob(String tibSoapSyncId) throws Exception {
		TibSoapSyncJob tibSoapSyncJob = (TibSoapSyncJob) tibSoapSyncJobService
				.findByPrimaryKey(tibSoapSyncId);
		if (tibSoapSyncJob == null) {
			logger.warn("找不到定时任务信息,抛弃当前同步动作~");
			return;
		}
		// 遍历定时任务下的映射表
		for (TibSoapSyncTempFunc tempFunc : tibSoapSyncJob.getFdSoapInfo()) {
			Date startDate = new Date();
			lastTime = tempFunc.getFdLastDate();
			String fdSoapXml = tempFunc.getFdSoapXml();
			if (StringUtil.isNull(fdSoapXml)) {
				continue;
			}
			Document doc = DomUtil.stringToDoc(fdSoapXml);
			NodeList InNodeList = DomUtil.selectNode("/web/Input", doc);
			// 设置节点值的方法
			setNodeValue(InNodeList, lastTime);
			SoapInfo soapInfo = new SoapInfo();
			soapInfo.setRequestDocument(doc);
			soapInfo.setTibSysSoapMain(tempFunc.getFdSoapMain());
			Document backDoc = tibSysSoap.inputToOutputDocument(soapInfo);
			// 数据源
			CompDbcp compDbcp = tempFunc.getFdCompDbcp();
			DataSet dataSet = null;
			ResultSet rs = null;
			try {
				dataSet = new DataSet(compDbcp.getFdName());
				Connection conn = dataSet.getConnection();
				// 批量操作开始事务
				conn.setAutoCommit(false);
				String fdSyncTableXpath = tempFunc.getFdSyncTableXpath();
				String[] fdSyncTableXpaths = fdSyncTableXpath.split(",");
				for (String xpath : fdSyncTableXpaths) {
					if (StringUtil.isNull(xpath)) {
						continue;
					}
					PreparedStatement ps = null;
					Statement stmt = null;
					NodeList outNodeList = DomUtil.selectNode(xpath, backDoc);
					Map<String, String> sqlMap = new HashMap<String, String>();
					List<Map<String, String>> columnValueList = new ArrayList<Map<String, String>>();
					// 解析组装Map,List,返回同步方式时间戳列
					String columnKey = getDetailExecute(outNodeList, sqlMap, columnValueList);
					// 如果是空数据，那么跳过
					if (sqlMap.containsKey("continue")) {
						continue;
					}
					if (!sqlMap.containsKey("syncType")) {
						continue;
					}
					short syncType = Short.parseShort(sqlMap.get("syncType"));
					if (sqlMap.containsKey("deleteSql")) {
						ps = conn.prepareStatement(sqlMap.get("deleteSql"));
						ps.execute();
					}
					/*
					 *  [if]	增量(插入前删除)
					 *  [else]	不是全量的话，那么就是增量，增量(时间戳)，增量(条件删除)中的一种
					 */
					if (syncType == SYNC_INCR_BEFORE_DEL) {
						// 增量（插入前删除）
						String selectSql = sqlMap.get("selectSql");
						if (StringUtil.isNotNull(selectSql)) {
							// 预编译并执行查询语句，查出相同的用来修改（增量方式）
							stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
							rs = stmt.executeQuery(selectSql);
							while (rs.next()) {
								String keyValue = String.valueOf(rs.getObject(columnKey));
								for (Iterator<Map<String, String>> it = columnValueList.iterator(); it.hasNext();) {
									Map<String, String> tempMap = it.next();
									// 比较KEY列值，相同的进行删除
									if (keyValue.equals(tempMap.get(columnKey))) {
										rs.deleteRow();
										break;
									}
								}
							}
						}
					} else if (syncType != SYNC_FULL) {
						// 增量，增量(时间戳)，增量(条件删除)
						String selectSql = sqlMap.get("selectSql");
						if (StringUtil.isNotNull(selectSql)) {
							// 执行查询语句，查出相同的用来修改（增量方式）
							stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
							rs = stmt.executeQuery(selectSql);
							while (rs.next()) {
								String keyValue = String.valueOf(rs.getObject(columnKey));
								for (Iterator<Map<String, String>> it = columnValueList.iterator(); it.hasNext();) {
									Map<String, String> tempMap = it.next();
									// 比较KEY列值，修改语句执行（此Map为TreeMap，有序的），并移除原List数据
									if (keyValue.equals(tempMap.get(columnKey))) {
										// 移除原Lisst数据 
										it.remove();
										for (String key : tempMap.keySet()) {
											// KEY则跳过，因为修改语句是根据KEY来的
											if (key.equals(columnKey)) {
												continue;
											}
											rs.updateObject(key, tempMap.get(key));
										}
										rs.updateRow();
										break;
									}
								}
							}
						}
					} 
					
					// 插入操作，所有同步方式都可能需要做的
					if (columnValueList.size() > 0) {
						String addSql = sqlMap.get("addSql");
						ps = conn.prepareStatement(addSql);
						for (Map<String, String> columnMap : columnValueList) {
							int i = 1;
							for (String value : columnMap.values()) {
								ps.setObject(i, value);
								i ++;
							}
							ps.addBatch();
						}
						ps.executeBatch();
					}
				}
				dataSet.commit();
			} catch(Exception e) {
				tibCommonLogInterface.saveLogMain(tibSoapSyncJob.getFdSubject() +"[任务同步]", 
						Constant.FD_TYPE_SOAP, startDate, "", 
						tempFunc.getFdSoapXml(), "异常日志：tibSoapSyncUniteQuartzService.method();执行错误为："+ 
						e.toString(), TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
				throw e;
			} finally {
				if (dataSet != null) {
					dataSet.close();
				}
				if (rs != null) {
					rs.close();
				}
			}
			// 修改最后执行时间
			tempFunc.setFdLastDate(new Date());
			tibSoapSyncTempFuncService.update(tempFunc);
			tibCommonLogInterface.saveLogMain(tibSoapSyncJob.getFdSubject() +"[任务同步]", Constant.FD_TYPE_SOAP, startDate, "", 
					tempFunc.getFdSoapXml(), "成功日志：tibSoapSyncUniteQuartzService.method();执行", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
		}
	}
	
	/**
	 *  组装数据库执行语句
	 * @param nodeList
	 * @throws SQLException 
	 * @throws DateParseException 
	 */
	private String getDetailExecute(NodeList nodeList, Map<String, String> sqlMap,
			List<Map<String, String>> columnValueList) throws Exception {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (Node.ELEMENT_NODE != curNode.getNodeType()) {
				continue;
			}
			Node commentNode = findCommentNode(curNode);
			if (null == commentNode) {
				continue;
			}
			String commentStr = commentNode.getTextContent();
			String splitStr = "|erp_web=";
			if (commentStr.lastIndexOf(splitStr) > 0) {
				int start = commentStr.lastIndexOf(splitStr) + splitStr.length();
				String result = commentStr.substring(start);
				JSONObject commentJsonObj = JSONObject.fromObject(result);
				if (commentJsonObj.containsKey("fdSyncTable")) {
					// 明细表操作开始
					String syncTable = commentJsonObj.getString("fdSyncTable");
					String syncType = commentJsonObj.getString("syncType");
					String columnKey = commentJsonObj.getString("key");
					String syncDateTimeColumn = commentJsonObj.getString("syncType_date");
					String fdDelConditionName = commentJsonObj.getString("fdDelConditionName");
					// 非全量同步，必须选择KEY
					if (Short.parseShort(syncType) != SYNC_FULL 
							&& StringUtil.isNull(columnKey)) {
						new Exception("同步失败，表"+ syncTable +"的非全量方式同步的Key为必选");
					}
					// 为数据库表中列的容器装值
					setColumnValueList(nodeList, columnValueList, syncDateTimeColumn);
					if (columnValueList.isEmpty()) {
						sqlMap.put("continue", "continue");
						return null;
					}
					// 设置插入语句
					String addSql = setAddSql(syncTable, columnValueList.get(0));
					String deleteSql = "";
					String selectSql = "";
					switch (Short.parseShort(syncType)) {
					case SYNC_INCR:
						// 增量
						selectSql = setSelectSql(syncTable, columnKey, columnValueList);
						sqlMap.put("selectSql", selectSql);
						break;
					case SYNC_FULL:
						// 全量
						deleteSql = "delete from "+ syncTable;
						if (StringUtil.isNotNull(addSql)) {
							sqlMap.put("deleteSql", deleteSql);
						}
						break;
					case SYNC_INCR_DATE:
						// 增量(时间戳)
						if (StringUtil.isNotNull(syncDateTimeColumn)) {
							selectSql = setSelectSql(syncTable, columnKey, columnValueList);
							// 返回时间戳列
							sqlMap.put("selectSql", selectSql);
						} else {
							new Exception("同步失败，增量(时间戳)方式未选择时间戳");
						}
						break;
					case SYNC_INCR_BEFORE_DEL:
						// 增量(插入前删除)
						selectSql = setSelectSql(syncTable, columnKey, columnValueList);
						if (StringUtil.isNotNull(selectSql)) {
							sqlMap.put("selectSql", selectSql);
						}
						break;
					case SYNC_INCR_CONDITION_DEL:
						// 增量(条件删除)
						deleteSql = "delete from "+ syncTable;
						selectSql = setSelectSql(syncTable, columnKey, columnValueList);
						if (StringUtil.isNotNull(selectSql)) {
							if (StringUtil.isNotNull(fdDelConditionName)) {
								fdDeleteExpression = HtmlUtils.htmlUnescape(fdDelConditionName);
								// 设置删除表达式，解析替换fdDeleteExpression字段
								setFdDeleteExpression(curNode.getChildNodes());
								deleteSql += " where "+ fdDeleteExpression;
								sqlMap.put("deleteSql", deleteSql);
							} else {
								fdDeleteExpression = "";
							}
							sqlMap.put("selectSql", selectSql);
						}
						break;
					}
					sqlMap.put("syncType", syncType);
					sqlMap.put("addSql", addSql);
					return columnKey;
				}
			}
		}
		return null;
	}
	
	/**
	 * 解析删除条件表达式
	 * @param nodeList
	 * @param syncTypeDateTime
	 * @return
	 */
	private String setFdDeleteExpression(NodeList nodeList) {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (Node.ELEMENT_NODE != curNode.getNodeType()) {
				continue;
			}
			// 获取对应注释节点
			Node commentNode = findCommentNode(curNode);
			if (null == commentNode) {
				// 还有子节点，那么递归
				if (curNode.hasChildNodes()) {
					setFdDeleteExpression(curNode.getChildNodes());
				}
				continue;
			}
			String commentStr = commentNode.getTextContent();
			String splitStr = "|erp_web=";
			if (commentStr.lastIndexOf(splitStr) > 0) {
				int start = commentStr.lastIndexOf(splitStr) + splitStr.length();
				String result = commentStr.substring(start);
				JSONObject commentJsonObj = JSONObject.fromObject(result);
				if (commentJsonObj.containsKey("fdSyncTable")) {
					// 明细表包含明细表那么跳过
					continue;
				} else if (commentJsonObj.containsKey("mappingValue")) {
					// 证明有映射，那么开始数据库sql语句拼串
					if (fdDeleteExpression.contains("$"+ curNode.getNodeName() +"$")) {
						String mappingValue = commentJsonObj.getString("mappingValue");
						fdDeleteExpression = fdDeleteExpression.replaceAll("\\$"+ curNode.getNodeName() +"\\$", mappingValue);
					}
				} 
			}
			// 还有子节点，那么递归
			if (curNode.hasChildNodes()) {
				setFdDeleteExpression(curNode.getChildNodes());
			}
		}
		return null;
	}
	
	private String setAddSql(String syncTable, Map<String, String> map) {
		String addSql = "";
		String setSql = "";
		for (String column : map.keySet()) {
			addSql += column +",";
			setSql += "?,";
		}
		if (StringUtil.isNotNull(setSql)) {
			// 截取最后一个逗号，再补上括号
			addSql = addSql.substring(0, addSql.length() - 1);
			setSql = setSql.substring(0, setSql.length() - 1);
			return "insert into "+ syncTable +"("+ addSql +")"+ "values("+ setSql +")";
		} else {
			return null;
		}
	}
	/**
	 * @deprecated
	 * @param syncTable
	 * @param columnKey
	 * @param map
	 * @return
	 */
	private String setUpdateSql(String syncTable, 
			String columnKey, Map<String, String> map) {
		String setSql = "";
		for (String column : map.keySet()) {
			if (columnKey.equals(column)) {
				continue;
			}
			setSql += column +"=?,";
		}
		if (StringUtil.isNotNull(setSql)) {
			// 截取最后一个逗号，再补上括号
			setSql = setSql.substring(0, setSql.length() - 1);
			return "update "+ syncTable +" set " + setSql +" where "+ columnKey +"=?";
		} else {
			return null;
		}
	}
	
	/**
	 * 拼串查询是否存在记录的sql语句
	 * @param syncTable
	 * @param columnKey
	 * @param columnValueList
	 * @return
	 */
	private String setSelectSql(String syncTable, String columnKey,
			List<Map<String, String>> columnValueList) {
		String selectBlock = "";
		StringBuffer whereBlockBuf = new StringBuffer("");
		for (int i = 0, len = columnValueList.size(); i < len; i++) {
			Map<String, String> map = columnValueList.get(i);
			if (i == 0) {
				// 查询的字段
				for (String key : map.keySet()) {
					selectBlock += key +",";
				}
			}
			String keyValue = map.get(columnKey);
			if (i == len - 1) {
				whereBlockBuf.append(columnKey +"='"+ keyValue +"' "); 
			} else {
				whereBlockBuf.append(columnKey +"='"+ keyValue +"' or "); 
			}
		}
		if (StringUtil.isNotNull(whereBlockBuf.toString())) {
			selectBlock = selectBlock.substring(0, selectBlock.length() - 1);
			return "select "+ selectBlock +" from "+ syncTable +" where " + whereBlockBuf.toString();
		} else {
			return null;
		}
	}
	
	/**
	 *  遍历多行明细表第一层节点
	 * @param nodeList
	 * @param columnValueList
	 * @throws SQLException
	 * @throws ParseException 
	 */
	private void setColumnValueList(NodeList nodeList, List<Map<String, String>> 
			columnValueList, String syncDateTimeColumn) throws SQLException, ParseException {
		// 遍历多行明细表第一层子节点（多少个子节点决定着多少条记录）
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (Node.ELEMENT_NODE != curNode.getNodeType()) {
				continue;
			}
			Node commentNode = findCommentNode(curNode);
			if (null == commentNode) {
				continue;
			}
			String commentStr = commentNode.getTextContent();
			String splitStr = "|erp_web=";
			if (commentStr.lastIndexOf(splitStr) > 0) {
				int start = commentStr.lastIndexOf(splitStr) + splitStr.length();
				String result = commentStr.substring(start);
				JSONObject commentJsonObj = JSONObject.fromObject(result);
				if (commentJsonObj.containsKey("fdSyncTable")) {
					Map<String, String> columnValueMap = new TreeMap<String, String>();
					// 遍历明细表的一行记录进行设置(递归遍历)
					setColumnValueMap(curNode.getChildNodes(), columnValueMap, syncDateTimeColumn);
					if (!columnValueMap.isEmpty()) {
						String generateFdId = commentJsonObj.getString("generateFdId");
						if (StringUtil.isNotNull(generateFdId)) {
							columnValueMap.put(generateFdId, IDGenerator.generateID());
						}
						// 把一条记录装入List容器
						columnValueList.add(columnValueMap);
					}
				}
			}
		}
	}
	
	/**
	 * 设置列值的Map容器
	 * （递归遍历）
	 * @param nodeList
	 * @param columnValueMap
	 * @throws SQLException
	 * @throws ParseException 
	 */
	private void setColumnValueMap(NodeList nodeList, Map<String, String> columnValueMap, 
			String syncDateTimeColumn) throws SQLException, ParseException {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (Node.ELEMENT_NODE != curNode.getNodeType()) {
				continue;
			}
			Node commentNode = findCommentNode(curNode);
			if (null == commentNode) {
				// 有子节点继续递归
				if (curNode.hasChildNodes()) {
					setColumnValueMap(curNode.getChildNodes(), columnValueMap, syncDateTimeColumn);
				}
				continue;
			}
			String commentStr = commentNode.getTextContent();
			String splitStr = "|erp_web=";
			if (commentStr.lastIndexOf(splitStr) > 0) {
				int start = commentStr.lastIndexOf(splitStr) + splitStr.length();
				String result = commentStr.substring(start);
				JSONObject commentJsonObj = JSONObject.fromObject(result);
				if (commentJsonObj.containsKey("fdSyncTable")) {
					// 明细表包含明细表那么跳过
					continue;
				} else if (commentJsonObj.containsKey("mappingValue")) {
					// 证明有映射，那么开始数据库sql语句拼串
					String value = curNode.getTextContent();
					if (commentJsonObj.containsKey("ctype") && "dateTime".equals(commentJsonObj.getString("ctype"))) {
						Date date = DateUtil.convertStringToDate(value, "yyyy-MM-dd'T'HH:mm:ss");
						// 比较时间戳
						if (lastTime != null 
								&& syncDateTimeColumn.equals(curNode.getNodeName())
								&& date.compareTo(lastTime) <= 0) {
							columnValueMap.clear();
							return ;
						}
						value = DateUtil.convertDateToString(date, "yyyy-MM-dd HH:mm:ss");
					}
					String mappingColumn = commentJsonObj.getString("mappingValue");
					if (StringUtil.isNotNull(mappingColumn)) {
						columnValueMap.put(mappingColumn, value);
					}
				} 
			}
			// 有子节点继续递归
			if (curNode.hasChildNodes()) {
				setColumnValueMap(curNode.getChildNodes(), columnValueMap, syncDateTimeColumn);
			}
		}
	}
	
	/**
	 * 从注释中拿出节点的值进行设置
	 * (可递归方法)
	 * @param nodeList
	 */
	private void setNodeValue(NodeList nodeList, Date lastTime) throws Exception {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (Node.ELEMENT_NODE != curNode.getNodeType()) {
				continue;
			}
			// 获取对应注释节点
			Node commentNode = findCommentNode(curNode);
			if (null == commentNode) {
				// 还有子节点，那么递归
				if (curNode.hasChildNodes()) {
					setNodeValue(curNode.getChildNodes(), lastTime);
				}
				continue;
			}
			String commentStr = commentNode.getTextContent();
			String splitStr = "|erp_web=";
			if (commentStr.lastIndexOf(splitStr) > 0) {
				int start = commentStr.lastIndexOf(splitStr) + splitStr.length();
				String result = commentStr.substring(start);
				JSONObject commentJsonObj = JSONObject.fromObject(result);
				Document doc = curNode.getOwnerDocument();
				String textStr = ""; 
				if (commentJsonObj.containsKey("inputSelect")) {
					String inputSelect = commentJsonObj.getString("inputSelect");
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					if ("1".equals(inputSelect)) {
						textStr = commentJsonObj.getString("inputText");
					} else if ("2".equals(inputSelect)) {
						// 最后更新时间
						textStr = sdf.format(new Date());
					} else if ("3".equals(inputSelect)) {
						// 最后执行时间
						if (null != lastTime) {
							textStr = sdf.format(lastTime);
						} else {
							textStr = "";
						}
					}
					Text nodeText = doc.createTextNode(textStr);
					curNode.appendChild(nodeText);
				}
			}
			// 还有子节点，那么递归
			if (curNode.hasChildNodes()) {
				setNodeValue(curNode.getChildNodes(), lastTime);
			}
		}
	}
	
	/**
	 * 找上一个为注释节点
	 * @param curNode
	 * @return
	 */
	private Node findCommentNode(Node curNode) {
		if (curNode != null) {
			Node preNode = curNode.getPreviousSibling();
			// 上一个节点就是尽头
			if (preNode == null) {
				return null;
			} else if (preNode.getNodeType() == Node.ELEMENT_NODE) {
				return null;
			} else if (preNode.getNodeType() == Node.COMMENT_NODE) {
				return preNode;
			} else {
				return findCommentNode(preNode);
			}
		}
		return null;
	}
	
}


