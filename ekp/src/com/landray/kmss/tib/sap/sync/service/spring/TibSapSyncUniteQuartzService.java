package com.landray.kmss.tib.sap.sync.service.spring;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Attribute;
import org.dom4j.Element;
import org.springframework.web.util.HtmlUtils;

import bsh.EvalError;
import bsh.Interpreter;

import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;
import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.interfaces.ITibCommonLogInterface;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncJob;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncTempFunc;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncJobService;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncTempFuncService;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncUniteQuartz;
import com.landray.kmss.tib.sap.sync.util.ElementInfo;
import com.landray.kmss.tib.sap.sync.util.SAPBatch;
import com.landray.kmss.tib.sap.sync.util.TableFieldUtils;
import com.landray.kmss.tib.sap.sync.util.TibSapSyncLogDetail;
import com.landray.kmss.tib.sap.sync.util.TibSapSyncLogVo;
import com.landray.kmss.tib.sap.sync.util.TibSapSyncXMLHandler;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.util.TypesExchange;
import com.landray.kmss.tib.sys.sap.constant.MessageConstants;
import com.landray.kmss.tib.sys.sap.constant.QuartzCfg;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRecordField;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;

/**
 * sap定时任务统一服务
 * 
 * @author zhangtian
 * 
 * @version 2012-2-15
 */

public class TibSapSyncUniteQuartzService implements ITibSapSyncUniteQuartz {
	
	private final static String lastUpdateDate = ResourceUtil.getString("tibSapSyncJob.lastUpdateDate", "tib-sap-sync");
	private final static String currentExecuteDate = ResourceUtil.getString("tibSapSyncJob.currentExecuteDate", "tib-sap-sync");
	
	private ITibSapSyncJobService tibSapSyncJobService;
	private ICompDbcpService compDbcpService;

	private ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil;
	private ITibSapSyncTempFuncService tibSapSyncTempFuncService;
	private Log logger = LogFactory.getLog(TibSapSyncUniteQuartzService.class);
	private Date editTime;
	private JCoFunction resultFunc = null;
	// private String sendType = null;// 标记操作类型 删除表/不删除表/启用时间戳
	private JCoFunction jcoFunciton = null;// jco函数对象
	private String functionId = null;
	private TibSapSyncLogVo tibSapSyncLogVo = null;

	// private Map<String, List<SAPBatch>> updateBatchMap = new HashMap<String,
	// List<SAPBatch>>();
	private Map<String, List<SAPBatch>> insertBatchMap = new HashMap<String, List<SAPBatch>>();
	// 存储批次数据
	private Map<String, Map<String, SAPBatch>> batchStore = new HashMap<String, Map<String, SAPBatch>>();

	private Map<String, TibSapSyncLogDetail> logDetail = new HashMap<String, TibSapSyncLogDetail>();
   
	private Map<String,Map<String,String>> tabFieldMap = new HashMap<String,Map<String,String>>();
	
	public void methodJob(SysQuartzJobContext sysQuartzJobContext)
			throws Exception {
		logger.debug("开始执行SAP定时任务");
		JSONObject jsonObj = JSONObject.fromObject(sysQuartzJobContext
				.getParameter());
		String tibSapSyncId = (String) jsonObj.get("sapQuartzId");
		mappingJob(tibSapSyncId);

	}

	/**
	 * 执行映射任务
	 * 
	 * @param tibSapSyncId
	 *            sap定时任务类id
	 * @throws Exception
	 */
	private void mappingJob(String tibSapSyncId) throws Exception {

		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");

		tibSapSyncJobService = (ITibSapSyncJobService) SpringBeanUtil
				.getBean("tibSapSyncJobService");
		compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		TibSapSyncJob tibSapSyncJob = (TibSapSyncJob) tibSapSyncJobService
				.findByPrimaryKey(tibSapSyncId);
		tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
		tibSapSyncTempFuncService = (ITibSapSyncTempFuncService) SpringBeanUtil
				.getBean("tibSapSyncTempFuncService");
		
		if(tibSapSyncJob==null){
			logger.warn("找不到定时任务信息,抛弃当前同步动作~");
			return ;
		}
		
		// 遍历定时任务下的映射表
		for (TibSapSyncTempFunc tempFunc : tibSapSyncJob.getFdSapInfo()) {
			editTime = tempFunc.getFdEditorTime();
			if (StringUtil.isNull(tempFunc.getFdRfcXml()))
				continue;
			// 传出前== 需要从数据库获取import参数
			// 跟传入table参数===================================================
			tibSapSyncLogVo = new TibSapSyncLogVo();
			logger.debug("执行的BAPI函数:"
					+ tempFunc.getFdRfcSetting().getFdFunctionName());
			tibSapSyncLogVo.setFunctionId(tempFunc.getFdRfcSetting().getFdId());
			tibSapSyncLogVo.setStartDate(new Date());
			tibSapSyncLogVo.setTibSapSyncName(tibSapSyncJob.getFdSubject());
			// String initXml = initXmlDataFromDB(tempFunc.getFdRfcXml(),
			// editorTime);
			// sendType = tempFunc.getFdSendType();

			// jcoFunciton =
			// tibSysSapJcoFunctionUtil.getFunctionByNameAndPool(tempFunc
			// .getFdRfcSetting().getFdFunctionName(), tempFunc
			// .getFdRfcSetting().getFdPool().getFdId());
			try {
				jcoFunciton = (JCoFunction) tibSysSapJcoFunctionUtil
						.getFunctionById(tempFunc.getFdRfcSetting().getFdId());
			} catch (Exception e) {
				tibSapSyncLogVo.getErrList().add(
						"获取初始rfc 出错 functionId："
								+ tempFunc.getFdRfcSetting().getFdId() + "\n"
								+ e.getMessage());
				tibSapSyncLogVo.setFdErr(true);

				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SAP, null, "", tempFunc
								.getFdRfcSetting().getFdFunctionName(),
						tibSapSyncLogVo.getStartDate(), new Date(), "",
						tibSapSyncLogVo.isFdErr() ? tibSapSyncLogVo.toString()
								: null,
						"程序异常:SapUniteQuartzService.mappingJob()："
								+ e.getMessage(),
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
				// tibCommonLogInterface.logError("SapUniteQuartzService.mappingJob()",
				// tibSapSyncLogVo.getStartDate(), null, null, null, null,
				// tibSapSyncLogVo.isFdErr() ? tibSapSyncLogVo.toString()
				// : null,Constant.FD_TYPE_SAP);
				// tibCommonLogInterface.logError(tempFunc.getFdRfcSetting().getFdPool().getFdPoolName(),
				// tibSapSyncLogVo.getStartDate(), new Date(), "", null, null
				// , tibSapSyncLogVo.isFdErr() ?
				// tibSapSyncLogVo.toString():null,
				// Constant.FD_TYPE_SAP);

				// tibCommonLogInterface.saveJcoLog(tibSapSyncLogVo.getStartDate(),
				// "0",
				// tibSapSyncLogVo.isFdErr() ? tibSapSyncLogVo.toString()
				// : null, null, null, tibSapSyncLogVo
				// .getFunctionId(),Constant.FD_TYPE_SAP);
				throw e;
			}

			// 传入参数解析
			TibSapSyncXMLHandler sapImportXMLHandler = new TibSapSyncXMLHandler() {
				private static final long serialVersionUID = 1L;

				public void doImport(ElementInfo importElement) {
					doImport4Function(importElement, jcoFunciton, editTime);
				}

				public void doImportRecord(ElementInfo parentElement,
						ElementInfo fieldElement) {
					doImportRecord4Function(parentElement, fieldElement,
							jcoFunciton, editTime);
				}

				public void doJcoElem(ElementInfo jcoElem) {
					functionId = jcoElem.getAttrs().get(
							MessageConstants.JCO_ATTR_ID);
				}

				public void doExport(ElementInfo exportElement) {
				}

				public void doExportRecord(ElementInfo parentElement,
						ElementInfo fieldElement) {
				}
			};
			// 通过模板解析,根据模板构造出JCOFunction
			sapImportXMLHandler.parseXMLString(tempFunc.getFdRfcXml());
			/**
			 * ======================对象传输=========================
			 */
			// 传出参数xml模板解析类
			TibSapSyncXMLHandler sapExportXMLHandler = new TibSapSyncXMLHandler() {
				private static final long serialVersionUID = 1L;
				// 遇到isin =0 的table 的records标签 操作
				private boolean flagRecord = false;
				private Map<String, Boolean> flagMap = new HashMap<String, Boolean>();

				public void doExportRecord(ElementInfo parentElement,
						ElementInfo fieldElement) {
					// doTableOperation(parentElement, fieldElement, editTime);
					String key = parentElement.getAttrs().get("name");
					Map clocal = clocalMap(parentElement.getAttrs().get(
							"clocal"));
					// 读取模板，当当前table没有遍历过的时候遍历,flagMap 标记遍历
					if ((!flagMap.containsKey(key))
							&& StringUtil
									.isNotNull((String) clocal.get("dbId"))) {
						JCoTable jcoTable = resultFunc.getTableParameterList()
								.getTable(key);
						saveUpdateTable(jcoTable, fieldElement, parentElement);
						insertBatchMap.clear();
						batchStore.clear();

					}
				}

				// 遇到export标签 操作
				public void doExport(ElementInfo exportElement) {
					// 传出参数数据映射先不做
					// doExprotOperation(exportElement, editTime);
				}

				public void doImport(ElementInfo importElement) {
				}

				public void doImportRecord(ElementInfo parentElement,
						ElementInfo fieldElement) {
				}

				public void doJcoElem(ElementInfo jcoElem) {
				}
			};
			try {
				resultFunc = tibSysSapJcoFunctionUtil.getFunctionFromFunc(
						jcoFunciton, functionId);
				sapExportXMLHandler.parseXMLString(tempFunc.getFdRfcXml());
				tempFunc.setFdEditorTime(new Date());
				tibSapSyncTempFuncService.update(tempFunc);
				// Notes 调用日志接口：传入参数为配置模板xml,传出参数为jcoFunction
				// 的toXML方法，传出参数xml有可能比较大
				if (tibSapSyncLogVo.isFdErr()) {
					// tibCommonLogInterface.logError(
					// "SapUniteQuartzService.mappingJob()",
					// tibSapSyncLogVo.getStartDate(), null, null, tempFunc
					// .getFdRfcXml(), null, null,
					// Constant.FD_TYPE_SAP);

					tibCommonLogInterface.saveTibCommonLogMain(
							Constant.FD_TYPE_SAP, null, "", tempFunc
									.getFdRfcSetting().getFdFunctionName(),
							tibSapSyncLogVo.getStartDate(), new Date(), "",
							tempFunc.getFdRfcXml(),
							"程序异常:SapUniteQuartzService.mappingJob()",
							TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
				} else {
					tibCommonLogInterface.saveTibCommonLogMain(
							Constant.FD_TYPE_SAP, null, "", tempFunc
									.getFdRfcSetting().getFdFunctionName(),
							tibSapSyncLogVo.getStartDate(), new Date(), "",
							tempFunc.getFdRfcXml(),
							"成功日志:SapUniteQuartzService.mappingJob()",
							TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);

					// tibCommonLogInterface.logSuccess(
					// "SapUniteQuartzService.mappingJob()",
					// tibSapSyncLogVo.getStartDate(), null, null, tempFunc
					// .getFdRfcXml(), null, null,
					// Constant.FD_TYPE_SAP);
				}
			} catch (Exception e) {
				tibSapSyncLogVo.getErrList().add(
						"获取结果rfc 出错 functionId："
								+ tempFunc.getFdRfcSetting().getFdId() + "\n"
								+ e.getMessage());
				tibSapSyncLogVo.setFdErr(true);
				// tibCommonLogInterface.logError("SapUniteQuartzService.mappingJob()",
				// tibSapSyncLogVo.getStartDate(), null, null, tempFunc
				// .getFdRfcXml(), null, null,
				// Constant.FD_TYPE_SAP);
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SAP, null, "", tempFunc
								.getFdRfcSetting().getFdFunctionName(),
						tibSapSyncLogVo.getStartDate(), new Date(), "",
						tempFunc.getFdRfcXml(),
						"程序异常:SapUniteQuartzService.mappingJob():"
								+ e.getMessage(),
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);

				// sapJcoLogUtil.saveJcoLog(tibSapSyncLogVo.getStartDate(), "0",
				// tibSapSyncLogVo.isFdErr() ? tibSapSyncLogVo.toString()
				// : null, (Object) tempFunc.getFdRfcXml(), "",
				// tibSapSyncLogVo.getFunctionId());
				throw e;
			}
		}
	}

	public JCoFunction doImportRecord4Function(ElementInfo parentElement,
			ElementInfo fieldElement, JCoFunction jcoFunction, Date eDate) {
		String tableName = parentElement.getAttrs().get("name");
		String clocalString = parentElement.getAttrs().get("clocal");
		Map<String, String> cloMap = clocalMap(clocalString);
		JCoTable jcoTable = jcoFunction.getTableParameterList().getTable(
				tableName);
		// 当没有跟数据库发生映射的时候
		if (StringUtil.isNull(cloMap.get("dbId"))
				|| StringUtil.isNull(cloMap.get("tableName"))) {
			Stack<ElementInfo> stackInfo = fieldElement.getChildrens();
			if (!stackInfo.isEmpty()) {
				jcoTable.appendRow();
			}
			// 遍历field
			while (!stackInfo.isEmpty()) {
				ElementInfo elem = stackInfo.pop();
				String ekpId = elem.getAttrs().get("ekpid");
				String fieldName = elem.getAttrs().get("name");
				String ctype = elem.getAttrs().get("ctype");
				Object fieldValue = null;
				if (MessageConstants.DATE.equals(ctype.trim())) {
					fieldValue = TypesExchange.exSwitchValue(ctype, elem
							.getNodeValue(), true, "yyyyMMdd");
				} else {
					fieldValue = TypesExchange.exSwitchValue(ctype, elem
							.getNodeValue(), true);
				}
				// 定时任务最后更新时间 当前执行时间 在传入参数跟传入表格上定时任务最后更新时间与执行时间选项是动态时间
				if (lastUpdateDate.equals(ekpId)) {
					fieldValue = eDate;
				} else if (currentExecuteDate.equals(ekpId)) {
					fieldValue = new Date();
				}
				jcoTable.setValue(fieldName, fieldValue);
			}
		}
		// 数据库中有可取数据
		else {
			try {
				// 保存原来使用数据，clone一份数据用来遍历，栈需要
				ElementInfo fieldInfo = (ElementInfo) fieldElement.clone();
				List<String> queryField = new ArrayList<String>();
				Stack<ElementInfo> stackInfo = fieldInfo.getChildrens();
				// 找到想数据库查询的字段
				while (!stackInfo.isEmpty()) {
					ElementInfo elem = stackInfo.pop();
					Map<String, String> attrs = elem.getAttrs();
					// 取得对应数据库字段名
					String xml_ekpid = attrs.get("ekpid");
					if (StringUtil.isNull(xml_ekpid))
						continue;
					if (lastUpdateDate.equals(xml_ekpid)
							|| currentExecuteDate.equals(xml_ekpid)) {
						continue;
					}
					queryField.add(xml_ekpid);
				}
				List<Map<String, Object>> result = findDBList(cloMap
						.get("tableName"), cloMap.get("dbId"), queryField);

				boolean first = false;
				for (Map<String, Object> fields : result) {
					if (fields.isEmpty()) {
						continue;
					}
					ElementInfo fieldInfo2DB = (ElementInfo) fieldElement
							.clone();
					Stack<ElementInfo> stackInfo2DB = fieldInfo2DB
							.getChildrens();
					if (!stackInfo2DB.isEmpty() && first) {
						jcoTable.appendRow();
					}
					first = true;
					// 遍历field
					while (!stackInfo2DB.isEmpty()) {
						ElementInfo elem = stackInfo2DB.pop();
						String ekpId = elem.getAttrs().get("ekpid");
						String ctype = elem.getAttrs().get("ctype");
						String fieldName = elem.getAttrs().get("name");
						Object fieldValue = null;
						fieldValue = fields.get(ekpId);
						fieldValue = fieldValue != null ? fieldValue : "";
						// 从数据库去取数据来再用toString转化字符串,再进行数据类型转化
						if (MessageConstants.DATE.equals(ctype.trim())) {
							fieldValue = TypesExchange.exSwitchValue(ctype,
									fieldValue.toString(), true, "yyyyMMdd");
						} else {
							fieldValue = TypesExchange.exSwitchValue(ctype,
									fieldValue.toString(), true);
						}
						// 定时任务最后更新时间 当前执行时间 在传入参数跟传入表格上定时任务最后更新时间与执行时间选项是动态时间
						if (lastUpdateDate.equals(ekpId)) {
							fieldValue = eDate;
						} else if (currentExecuteDate.equals(ekpId)) {
							fieldValue = new Date();
						}
						jcoTable.setValue(fieldName,
								fieldValue != null ? fieldValue : "");
					}

				}
			} catch (Exception e) {
				logger.debug("构造传入参数错误" + e.getMessage());
				tibSapSyncLogVo.getErrList().add("构造传入参数错误" + e.getMessage());
				tibSapSyncLogVo.setFdErr(true);
			}

		}
		return jcoFunction;
	}

	public JCoFunction doImport4Function(ElementInfo importElement,
			JCoFunction jcoFunction, Date eDate) {
		if (jcoFunction == null)
			return null;
		JCoParameterList importList = jcoFunction.getImportParameterList();
		Stack<ElementInfo> elements = importElement.getChildrens();
		for (ElementInfo elem : elements) {
			if (MessageConstants.STRUCTURE.equals(elem.getqName())) {
				JCoStructure jcoStructure = importList.getStructure(elem
						.getAttrs().get("name"));
				Stack<ElementInfo> structurElems = importElement.getChildrens();
				for (ElementInfo s_elem : structurElems) {
					if (MessageConstants.FIELD.equals(s_elem.getqName())) {
						String fieldName = s_elem.getAttrs().get("name");
						String ctype = s_elem.getAttrs().get("ctype");
						Object fieldValue = null;
						if (MessageConstants.DATE.equals(ctype.trim())) {
							fieldValue = TypesExchange.exSwitchValue(ctype,
									s_elem.getNodeValue(), true, "yyyyMMdd");
						} else {
							fieldValue = TypesExchange.exSwitchValue(ctype,
									s_elem.getNodeValue(), true);
						}
						jcoStructure.setValue(fieldName, fieldValue);
					}
				}
			}
			// 针对field进行赋值
			else if (MessageConstants.FIELD.equals(elem.getqName())) {
				String ekpId = elem.getAttrs().get("ekpid");
				String fieldName = elem.getAttrs().get("name");
				String ctype = elem.getAttrs().get("ctype");
				Object fieldValue = null;
				if (MessageConstants.DATE.equals(ctype.trim())) {
					fieldValue = TypesExchange.exSwitchValue(ctype, elem
							.getNodeValue(), true, "yyyyMMdd");
				} else {
					fieldValue = TypesExchange.exSwitchValue(ctype, elem
							.getNodeValue(), true);
				}
				// 定时任务最后更新时间 当前执行时间 在传入参数跟传入表格上定时任务最后更新时间与执行时间选项是动态时间
				if (lastUpdateDate.equals(ekpId)) {
					fieldValue = eDate;
				} else if (currentExecuteDate.equals(ekpId)) {
					fieldValue = new Date();
				}
				importList.setValue(fieldName, fieldValue);
			}
		}
		return jcoFunction;
	}

	/**
	 * 取得key -name 组合 key 为ekpid 数据库表字段，name 为sap 对应字段名
	 * 
	 * @param fieldElement
	 * @return
	 */
	private Map<String, String> findKeyNames(ElementInfo fieldElement) {
		Map<String, String> keyNames = new HashMap<String, String>();
		Stack<ElementInfo> fieldStack = fieldElement.getChildrens();
		while (!fieldStack.isEmpty()) {
			ElementInfo elem = fieldStack.pop();
			Map<String, String> attrs = elem.getAttrs();

			// 取得对应数据库字段名
			String xml_ekpid = attrs.get("ekpid");
			if (StringUtil.isNull(xml_ekpid))
				continue;
			String name = attrs.get("name");
			String xml_dbiskey = attrs.get("dbiskey");
			if (TypesExchange.getBoolean(xml_dbiskey)) {
				keyNames.put(xml_ekpid, name);
			}
		}
		return keyNames;
	}

	/**
	 * 是否存在配置数据源，有则返回这个配置的Map ,无责返回空
	 * 
	 * @param parentElement
	 * @return
	 */
	private Map<String, String> isExistDBSetting(ElementInfo parentElement) {
		Map<String, String> cloMap = clocalMap(parentElement.getAttrs().get(
				"clocal"));
		if (StringUtil.isNotNull(cloMap.get("dbId"))
				&& StringUtil.isNotNull(cloMap.get("tableName"))) {
			return cloMap;
		}
		return null;
	}

	/**
	 * 遍历jco数据,查找数据库中所有数据是否存在key 值的数据删除掉
	 * 
	 * @param jcoTable
	 * @param cloMap
	 * @param keyNames
	 * @param detail
	 *            日志
	 */
	private void deleteRowByKey(JCoTable jcoTable, Map<String, String> cloMap,
			Map<String, String> keyNames, TibSapSyncLogDetail detail) {
		DataSet dataSet = null;
		CompDbcp compDbcp = null;
		try {
			compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(cloMap
					.get("dbId"));
			dataSet = new DataSet(compDbcp.getFdName());

			String tableName = cloMap.get("tableName");
			StringBuffer whereBock = new StringBuffer();
			boolean flagWhere = true;

			for (int index = 0, len = jcoTable.getNumRows(); index < len; index++) {
				jcoTable.setRow(index);
				JCoRecordFieldIterator iterator = jcoTable
						.getRecordFieldIterator();

				if (flagWhere) {
					flagWhere = false;
				} else {
					whereBock.append(" OR ");
				}
				StringBuffer buf = new StringBuffer("(");
				boolean first = true;
				for (String ekpid : keyNames.keySet()) {
					String sapName = keyNames.get(ekpid);
					boolean flag = true;
					// loop:
					while (iterator.hasNextField() && flag) {
						JCoRecordField recordField = iterator.nextRecordField();
						if (recordField.getName().equals(sapName)) {
							String value = StringUtil.isNotNull(recordField
									.getString()) ? recordField.getString()
									: "";
							if (first) {
								first = false;
							} else {
								buf.append(" AND ");
							}

							buf.append(ekpid + "='" + value + "'");

							flag = false;
							// break loop;
						}
					}
				}
				buf.append(")");
				first = true;
				whereBock.append(buf);

				if ((index % QuartzCfg.DEFAUTL_DELETE_NUM == 0) && (index != 0)) {
					String sql = QuartzCfg.DELETE_EXIST_SQL.replace(
							"!{TABLENAME}", tableName).replace("!{WHEREBOCK}",
							whereBock.toString());
					// 存在proxool 把connection关闭情况，被迫判断

					dataSet.beginTran();
					dataSet.executeUpdate(sql);
					dataSet.commit();
					logger.debug("delete " + index);
					// =proxool 甚至时间太短,只能自己每次删除不都把连接关闭掉======;
					dataSet.close();
					// ======
					dataSet = initDataSet(compDbcp.getFdId());
					flagWhere = true;
					whereBock = new StringBuffer();
				}
			}
			if (whereBock.length() > 0) {
				String sql = QuartzCfg.DELETE_EXIST_SQL.replace("!{TABLENAME}",
						tableName)
						.replace("!{WHEREBOCK}", whereBock.toString());
				dataSet.beginTran();
				dataSet.executeUpdate(sql);
				dataSet.commit();
				// =proxool 甚至时间太短,只能自己每次删除不都把连接关闭掉======
				dataSet.close();
				dataSet = initDataSet(compDbcp.getFdId());
				// ==========
			}
			// flagWhere = true;
			// whereBock = new StringBuffer();

		} catch (Exception e) {
			logger.error("删除表数据时数据异常:" + e.getMessage());
			detail.getErrorMsg().add("删除表数据时数据异常:" + e.getMessage());
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
		}

	}

	/**
	 * 通过模板跟jco对象合并,做相应数据操作
	 * 
	 * @param jcoTable
	 * @param fieldElement
	 * @param parentElement
	 */
	public void saveUpdateTable(JCoTable jcoTable, ElementInfo fieldElement,
			ElementInfo parentElement) {

		String del_condition = parentElement.getAttrs().get("del_condition");
		long current = System.currentTimeMillis();
		// ElementInfo copyField=new ElementInfo();
		// 遍历jcoFunction的所有数据
		// 根据操作类型判断是否清空表格
		Map<String, String> cloMap = isExistDBSetting(parentElement);
		if (cloMap == null)
			return;

		// ==日志对象====
		TibSapSyncLogDetail detail = logDetail.get(parentElement.getAttrs()
				.get("name"));
		if (detail == null) {
			detail = new TibSapSyncLogDetail();
			logDetail.put(parentElement.getAttrs().get("name"), detail);
		}
		int flagNum = 0;
		detail.setRowsNum(jcoTable.getNumRows());

		try {
			String sendType = parentElement.getAttrs().get("sendType");
			if (QuartzCfg.QUARTZ_INSERT_ALL.equals(sendType)) {
				emptypTable(cloMap.get("tableName"), cloMap.get("dbId"));
			}
			if (QuartzCfg.QUARTZ_INSERT_DELETE.equals(sendType)
					|| QuartzCfg.QUARTZ_CONDITION_DELETE.equals(sendType)) {
				ElementInfo cloneElem = (ElementInfo) fieldElement.clone();
				Map<String, String> keyNames = findKeyNames(cloneElem);
				if (!keyNames.isEmpty()) {
					long mils = System.currentTimeMillis();
					deleteRowByKey(jcoTable, cloMap, keyNames, detail);
					logger.debug("删除重复数据花费时间："
							+ (System.currentTimeMillis() - mils) + "ms");
				}
			}
			for (int index = 0, len = jcoTable.getNumRows(); index < len; index++) {
				// ==============测试是用,限制插入条目=======================
				// if(index>100000){
				// break;
				// }
				// =============================

				jcoTable.setRow(index);
				flagNum = index;// 记录日志
				// 克隆xml数据,这里算法待优化
				ElementInfo cloneElem = (ElementInfo) fieldElement.clone();
				Stack<ElementInfo> source = cloneElem.getChildrens();// fieldElement.getChildrens();
				// Iterator<ElementInfo> elemIterator=source.iterator();
				for (ElementInfo elem : source) {
					// 遍历模板xml的field
					String fieldName = elem.getAttrs().get("name");
					JCoRecordFieldIterator iterator = jcoTable
							.getRecordFieldIterator();
					boolean flag = true;
					// 把jco funciton 的值填入模板里面
					while (iterator.hasNextField() && flag) {
						JCoRecordField recordField = iterator.nextRecordField();
						if (recordField.getName().equals(fieldName)) {
							elem.setNodeValue(recordField.getString());
							flag = false;
						}
					}
					flag = true;
				}
				// 执行单条数据操作
				doTableOperation(parentElement, cloneElem, editTime, detail);
			}
			if (!insertBatchMap.isEmpty()) {
				for (String key : insertBatchMap.keySet()) {
					List<SAPBatch> insertBatchs = insertBatchMap.get(key);
					if (insertBatchs.size() > 0) {
						detail.setInsertNum(detail.getInsertNum()
								+ insertBatchs.size());
						doInsertBatch(insertBatchs, detail);
					}
					insertBatchMap.remove(key);
				}
			}
			if (batchStore.size() > 0) {
				for (String key : batchStore.keySet()) {
					Map<String, SAPBatch> batchMap = batchStore.get(key);

					if (!batchMap.isEmpty()) {
						Set<String> keys = batchMap.keySet();
						SAPBatch batchInfo = null;
						int curIndex = 0;
						for (String curKey : keys) {
							batchInfo = batchMap.get(curKey);
							if (curIndex == 0) {
								break;
							}
						}
						long mils = System.currentTimeMillis();

						String SQL = findExistSQL(batchInfo.getDbId(), batchMap);
						List<String> keyList = findExistExecute(batchInfo
								.getDbId(), SQL, detail);
						logger.debug("select花费"
								+ (System.currentTimeMillis() - mils) + "ms");

						Map<String, SAPBatch> updateBatch = new HashMap<String, SAPBatch>();
						for (String keyVal : keyList) {
							SAPBatch batch = batchMap.get(keyVal);
							if (batch != null) {
								updateBatch.put(keyVal, batch);
								batchMap.remove(keyVal);
							}
						}
						try {
							detail.setUpdateNum(detail.getUpdateNum()
									+ updateBatch.size());

							mils = System.currentTimeMillis();
							doUpdateBatchV2(updateBatch, detail);
							logger.debug("update花费"
									+ (System.currentTimeMillis() - mils)
									+ "ms:" + updateBatch.size() + "条");

							detail.setInsertNum(detail.getInsertNum()
									+ batchMap.size());

							mils = System.currentTimeMillis();
							doInsertBatchV2(batchMap, detail);
							logger.debug("insert花费"
									+ (System.currentTimeMillis() - mils)
									+ "ms:" + batchMap.size() + "条");
							batchStore.remove(key);
						} catch (Exception e) {
							// TODO 自动生成 catch 块
							e.printStackTrace();
							logger.error("批量更新操作发生异常" + e.getMessage());
							detail.getErrorMsg().add(
									"批量更新操作发生异常" + e.getMessage());
						} finally {
							batchStore.remove(key);
						}

					}
				}
			}

		} catch (CloneNotSupportedException e) {
			// TODO: handle exception
			logger.debug("不支持克隆对象-执行数据插入异常");
			detail.getErrorMsg().add(
					"执行" + flagNum + "条数据出错!克隆对象-执行数据插入异常：" + e.getMessage());

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("数据异常~@" + e.getMessage());
			detail.getErrorMsg().add(
					"执行" + flagNum + "条数据出错!数据异常" + e.getMessage());
		} finally {
			detail.setTarget(parentElement.getAttrs().get("name"));
			detail.setUseMs((System.currentTimeMillis() - current));
			logger.debug("执行table：" + parentElement.getAttrs().get("name")
					+ "-" + (System.currentTimeMillis() - current) + "ms");
			tibSapSyncLogVo.getDetails().add(detail);
			if (detail.getErrorMsg().size() > 0) {
				tibSapSyncLogVo.setFdErr(true);
			}
			logDetail.remove(parentElement.getAttrs().get("name"));
		}
	}

	/**
	 * 解析clocal 属性值 3：数据源id：表名：时间戳字段名
	 * 
	 * @param clocal
	 * @return
	 */
	private Map<String, String> clocalMap(String clocal) {
		Map<String, String> clo = new HashMap<String, String>();
		if (StringUtil.isNull(clocal))
			return clo;
		String[] cloData = clocal.split(":");
		if (cloData.length > 0 && StringUtil.isNotNull(cloData[0])) {
			clo.put("type", cloData[0]);
		}
		if (cloData.length > 1 && StringUtil.isNotNull(cloData[1])) {
			clo.put("dbId", cloData[1]);
		}
		if (cloData.length > 2 && StringUtil.isNotNull(cloData[2])) {
			clo.put("tableName", cloData[2]);
		}
		return clo;
	}

	/**
	 * 
	 * @param tableName
	 *            表名
	 * @param dbId
	 *            数据连接对象id
	 * @param queryField
	 *            需要查找的字段列
	 * @return 根据queryField 顺序组装好的数据集list Map<String,Object> 字段名,字段值。
	 * 
	 * @throws Exception
	 */
	public List<Map<String, Object>> findDBList(String tableName, String dbId,
			List<String> queryField) throws Exception {
		// if (dataSet == null) {
		DataSet dataSet = initDataSet(dbId);
		// 组装sql 语句 select XXX,XX from tableName;
		Statement stms = null;
		System.out.println("dd");
		StringBuffer querySql = new StringBuffer("select ");
		int index = 0;
		for (String field : queryField) {
			querySql.append(" " + field + " ");

			if (index < queryField.size() - 1) {
				querySql.append(",");
			}
			index++;
		}
		querySql.append(" from " + tableName);
		try {
			// 获取连接
			ResultSet rs = dataSet.executeQuery(querySql.toString());
			// 返回数据集 装载集合
			List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();

			while (rs.next()) {
				Map<String, Object> rowMap = new HashMap<String, Object>();
				int i = 0;
				for (String fieldName : queryField) {
					Object resultObject = rs.getObject(i + 1);
					rowMap.put(fieldName, resultObject);
					i++;
				}
				resultList.add(rowMap);
			}
			return resultList;
		} catch (SQLException e) {
			logger.debug(e.getMessage());
			return null;
		} finally {
			dataSet.close();
		}
	}

	public void doExprotOperation(ElementInfo exportElement, Date editTime) {
		Map<String, String> cloMap = clocalMap(exportElement.getAttrs().get(
				"clocal"));
		if (StringUtil.isNull(cloMap.get("dbId"))
				|| StringUtil.isNull(cloMap.get("tableName")))
			return;

		TibSapSyncLogDetail detail = new TibSapSyncLogDetail();
		detail.setTarget("EXPORT 参数");
		logDetail.put("EXPORT", detail);
		String sendType = exportElement.getAttrs().get("sendType");
		// 时间戳字段
		String timestamp = exportElement.getAttrs().get("timestamp_ekp");
		// 主键标记
		String del_condition = exportElement.getAttrs().get("del_condition");
		List<String> keyNames = new ArrayList<String>();
		Map<String, String> keyNamesSap = new HashMap<String, String>();
		String timestamp_value = null;
		Stack<ElementInfo> fieldStack = exportElement.getChildrens();
		Map<String, Object> params = new HashMap<String, Object>();
		while (!fieldStack.isEmpty()) {
			ElementInfo elem = fieldStack.pop();
			Map<String, String> attrs = elem.getAttrs();

			// 取得对应数据库字段名
			String xml_ekpid = attrs.get("ekpid");
			if (StringUtil.isNull(xml_ekpid))
				continue;

			String xml_ctype = attrs.get("ctype");
			String xml_dbiskey = attrs.get("dbiskey");
			String xml_value = elem.getNodeValue();
			Object paramValue = TypesExchange.exSwitchValue(xml_ctype,
					xml_value, true);
			// 检验时间戳字段跟
			String xml_name = attrs.get("name");

			// 判断是否为时间戳字段
			if (StringUtil.isNotNull(timestamp)
					&& StringUtil.isNotNull(timestamp)
					&& timestamp.equalsIgnoreCase(xml_name)) {
				if (lastUpdateDate.equals(xml_ekpid)) {
					timestamp_value = DateUtil.convertDateToString(editTime,
							"yyyy-MM-dd HH:mm:ss");
				} else if (currentExecuteDate.equals(xml_ekpid)) {
					timestamp_value = DateUtil.convertDateToString(new Date(),
							"yyyy-MM-dd HH:mm:ss");
				}
			} else {
				params.put(xml_ekpid, paramValue);
				keyNamesSap.put(xml_name, xml_ekpid);
			}
			if (TypesExchange.getBoolean(xml_dbiskey)) {
				keyNames.add(xml_ekpid);
			}
		}
		// saveOrUpdateDb(cloMap.get("dbId"), cloMap.get("tableName"), keyNames,
		// params, timestamp_value, editTime);
		saveOrUpdateDbByBatch(cloMap.get("dbId"), cloMap.get("tableName"),
				keyNames, keyNamesSap, params, timestamp_value, editTime,
				"EXPORT", sendType, del_condition, detail);
		tibSapSyncLogVo.getDetails().add(detail);
		if (detail.getErrorMsg().size() > 0) {
			tibSapSyncLogVo.setFdErr(true);
		}
	}

	/**
	 * 执行table 标签先得record 操作 组装当前标签数据,供给数据库操作
	 * 
	 * @param parentElement
	 *            table 标签
	 * @param fieldElement
	 *            records 标签信息
	 * @param editTime
	 */
	public void doTableOperation(ElementInfo parentElement,
			ElementInfo fieldElement, Date editTime, TibSapSyncLogDetail detail) {
		// 获取数据连接信息
		String clocal = parentElement.getAttrs().get("clocal");
		Map<String, String> cloMap = clocalMap(clocal);
		if (StringUtil.isNull(cloMap.get("dbId"))
				|| StringUtil.isNull(cloMap.get("tableName")))
			return;
		// 时间戳字段
		String timestamp = parentElement.getAttrs().get("timestamp_ekp");

		String del_condition = parentElement.getAttrs().get("del_condition");
		// 主键标记
		// String keyName = null;
		List<String> keyNames = new ArrayList<String>();
		Map<String, String> keyNameSap = new HashMap<String, String>();
		Date compareDate = editTime;
		String timestamp_value = null;
		Stack<ElementInfo> fieldStack = fieldElement.getChildrens();
		Map<String, Object> params = new HashMap<String, Object>();
		while (!fieldStack.isEmpty()) {
			ElementInfo elem = fieldStack.pop();
			Map<String, String> attrs = elem.getAttrs();

			// 取得对应数据库字段名
			String xml_ekpid = attrs.get("ekpid");
			if (StringUtil.isNull(xml_ekpid))
				continue;

			String xml_ctype = attrs.get("ctype");
			String xml_dbiskey = attrs.get("dbiskey");
			String xml_value = elem.getNodeValue();
			Object paramValue = TypesExchange.exSwitchValue(xml_ctype,
					xml_value, true);
			// 检验时间戳字段跟
			String xml_name = attrs.get("name");

			// 判断是否为时间戳字段
			if (StringUtil.isNotNull(timestamp)
					&& StringUtil.isNotNull(timestamp)
					&& timestamp.equalsIgnoreCase(xml_name)) {

				// 备注,时间字段为yyyyMMdd
				timestamp_value = xml_value;
				if (lastUpdateDate.equals(xml_ekpid)) {
					compareDate = editTime;
				} else if (currentExecuteDate.equals(xml_ekpid)) {
					compareDate = new Date();
				} else {
					params.put(xml_ekpid, paramValue);
					keyNameSap.put(xml_name, xml_ekpid);
				}
				// 时间错比对
				// if(!compareTime(xml_value, compareDate))
				// continue;

			} else {
				params.put(xml_ekpid, paramValue);
				keyNameSap.put(xml_name, xml_ekpid);
			}
			if (TypesExchange.getBoolean(xml_dbiskey)) {
				keyNames.add(xml_ekpid);
			}
		}

		// 通过table 的名字来区分属于哪一个批次,如果没有名字,则废弃这条记录
		String batchName = parentElement.getAttrs().get("name");
		// 使用批量插入方式,针对table 采用
		if (StringUtil.isNotNull(batchName)) {
			saveOrUpdateDbByBatch(cloMap.get("dbId"), cloMap.get("tableName"),
					keyNames, keyNameSap, params, timestamp_value, compareDate,
					batchName, parentElement.getAttrs().get("sendType"),
					del_condition, detail);
		}
		// 逐条插入方式
		// saveOrUpdateDb(cloMap.get("dbId"), cloMap.get("tableName"), keyNames,
		// params, timestamp_value, editTime);
	}

	/**
	 * 判断批次中是否存在数据一致的，如果存在就返回false ，存放在update批次中， 这一步操作比较慢,
	 * 解决当同一个批次还没有进入数据库的时候存在keys值都一样
	 * 
	 * @param params
	 * @param keyNames
	 * @param batchName
	 * @return
	 */
	public boolean existInBatch(Map<String, Object> params,
			List<String> keyNames, String batchName) {

		if (keyNames.isEmpty())
			return false;
		if (!insertBatchMap.containsKey(batchName))
			return false;

		List<SAPBatch> batchList = insertBatchMap.get(batchName);
		for (SAPBatch sapBatch : batchList) {
			Map<String, Object> paramMap = sapBatch.getParams();
			boolean flag = true;
			Iterator<String> it = keyNames.iterator();
			while (it.hasNext() && flag) {
				String keyName = (String) it.next();
				Object sourceVal = paramMap.get(keyName);
				Object tarVal = params.get(keyName);
				flag = compareObject(sourceVal, tarVal);
			}
			if (!keyNames.isEmpty() && flag == true) {
				return true;
			}
		}
		return false;

	}

	/**
	 * 比较对象，只比较String类型 (待优化)
	 * 
	 * @param sourceVal
	 * @param tarVal
	 * @return
	 */
	public boolean compareObject(Object sourceVal, Object tarVal) {
		if (sourceVal == null || tarVal == null) {
			return false;
		}
		if (sourceVal.getClass().isInstance(tarVal)) {
			if (sourceVal.toString().equals(tarVal.toString())) {
				return true;
			}
		}
		return false;
	}

	/**
	 * (代码可更优化) 更新，插入操作 主要负责分批,同一个table 需要更新的数据分到一批，不同表需要更新另外一批
	 * 
	 * @param dbID
	 * @param tableName
	 * @param keyNames
	 * @param params
	 * @param timeStamp
	 * @param editTime
	 * @param batchName
	 */
	private void saveOrUpdateDbByBatch(String dbID, String tableName,
			List<String> keyNames, Map<String, String> keyNameSap,
			Map<String, Object> params, String timeStamp, Date editTime,
			String batchName, String sendType, String del_condition,
			TibSapSyncLogDetail detail) {
		// 比对时间戳
		if (QuartzCfg.QUARTZ_INSERT_TIMESTAMP.equals(sendType)
				&& !compareTime(timeStamp, editTime))
			return;

		// 存在key值 并且不属于 增量(插入前删除) 的情况下进入 增量(插入前删除)--在插入前已经对表中数据进行删除了一次
		if (!keyNames.isEmpty()
				&& !QuartzCfg.QUARTZ_INSERT_DELETE.equals(sendType)
				&& !QuartzCfg.QUARTZ_CONDITION_DELETE.equals(sendType)) {
			// 查询数据库是否存在当前数据
			// if (existInTable(params, keyNames, tableName, dbID)
			// 取消同一个批次数据重复的判断,加快数据插入()
			// || existInBatch(params, keyNames, batchName)
			// )
			// ===================================================================
			//如果该表中的字段没有被查询过，则先查询判断是否含有fd_id
			if(!tabFieldMap.containsKey(tableName)){
				getTabField(dbID,tableName);
			}
			//判断是否有fd_id，如果有并且没有被映射，则用公司id生成器生成
			checkedFdId(tableName,params);
			
			SAPBatch batchInfo = new SAPBatch(params, keyNames, keyNameSap,
					dbID, tableName);
			if (batchStore.containsKey(batchName)) {
				batchStore.get(batchName).put(batchInfo.hashKey(), batchInfo);
				try {
					if (batchStore.get(batchName).size() >= QuartzCfg.DEFAUTL_NUM) {
						Map<String, SAPBatch> curBatch = batchStore
								.get(batchName);

						// ====================================
						// 过滤这个批次的删除数据，不插入进数据库
						// if(QuartzCfg.QUARTZ_CONDITION_DELETE.equals(StringUtil.isNotNull(del_condition))){
						// long millis = System.currentTimeMillis();
						// Map<String, SAPBatch> delBatch = findDeleteField(
						// del_condition, curBatch);
						// logger.debug("根据公式定义过滤删除数据,过滤到" + delBatch.size()
						// + "条数据,花费时间："
						// + (System.currentTimeMillis() - millis) + "ms");
						// }
						// ===================================

						long mils = System.currentTimeMillis();
						String SQL = findExistSQL(batchInfo.getDbId(), curBatch);
						List<String> keys = findExistExecute(batchInfo
								.getDbId(), SQL, detail);
						logger.debug("select花费"
								+ (System.currentTimeMillis() - mils) + "ms");

						Map<String, SAPBatch> updateBatch = new HashMap<String, SAPBatch>();
						for (String key : keys) {
							SAPBatch batch = curBatch.get(key);
							if (batch != null) {
								updateBatch.put(key, batch);
								curBatch.remove(key);
							}
						}

						detail.setUpdateNum(detail.getUpdateNum()
								+ updateBatch.size());

						mils = System.currentTimeMillis();
						doUpdateBatchV2(updateBatch, detail);
						logger.debug("update花费"
								+ (System.currentTimeMillis() - mils) + "ms:"
								+ updateBatch.size() + "条");

						detail.setInsertNum(detail.getInsertNum()
								+ curBatch.size());
						mils = System.currentTimeMillis();
						doInsertBatchV2(curBatch, detail);
						logger.debug("insert花费"
								+ (System.currentTimeMillis() - mils) + "ms:"
								+ curBatch.size() + "条");
						batchStore.remove(batchName);
					}
				} catch (Exception e) {
					batchStore.remove(batchName);
					e.printStackTrace();
					logger.error("批量操作发生异常" + e.getMessage());
					detail.getErrorMsg().add("批量操作发生异常" + e.getMessage());
				} finally {
					// batchStore.remove(batchName);
				}
			}

			else {
				batchStore.put(batchName, new HashMap<String, SAPBatch>());
				batchStore.get(batchName).put(batchInfo.hashKey(), batchInfo);
			}

		} else {
			if (!insertBatchMap.containsKey(batchName)) {
				if (insertBatchMap.size() > 0) {
					for (String key : insertBatchMap.keySet()) {
						List<SAPBatch> insertBatch = insertBatchMap.get(key);
						try {
							detail.setInsertNum(detail.getInsertNum()
									+ insertBatch.size());
							doInsertBatch(insertBatch, detail);
						} catch (Exception e) {
							logger.error("批量插入操作发生异常" + e.getMessage());
							detail.getErrorMsg().add(
									"批量插入操作发生异常:" + e.getMessage());
						} finally {
							insertBatchMap.remove(key);
						}
					}

				}
				List<SAPBatch> tmp = new ArrayList<SAPBatch>();
				insertBatchMap.put(batchName, tmp);
				
				//如果该表中的字段没有被查询过，则先查询判断是否含有fd_id
				if(!tabFieldMap.containsKey(tableName)){
					getTabField(dbID,tableName);
				}
				//判断是否有fd_id，如果有并且没有被映射，则用公司id生成器生成
				checkedFdId(tableName,params);
				
				SAPBatch batch = new SAPBatch(params, keyNames, keyNameSap,
						dbID, tableName);
				// ======公式定义过滤==============
				if (QuartzCfg.QUARTZ_CONDITION_DELETE.equals(sendType)) {
					boolean filter = filterByCondition(del_condition, batch);
					if (!filter) {
						insertBatchMap.get(batchName).add(batch);
					}
				} else {
					insertBatchMap.get(batchName).add(batch);
				}
				// ============================

			} else {
				//如果该表中的字段没有被查询过，则先查询判断是否含有fd_id
				if(!tabFieldMap.containsKey(tableName)){
					getTabField(dbID,tableName);
				}
				//判断是否有fd_id，如果有并且没有被映射，则用公司id生成器生成
				checkedFdId(tableName,params);
				
				SAPBatch batch = new SAPBatch(params, keyNames, keyNameSap,
						dbID, tableName);
				// ======公式定义过滤==============
				if (QuartzCfg.QUARTZ_CONDITION_DELETE.equals(sendType)) {
					boolean filter = filterByCondition(del_condition, batch);
					if (!filter) {
						insertBatchMap.get(batchName).add(batch);
					}
				} else {
					insertBatchMap.get(batchName).add(batch);
				}
				// ====================
				if (insertBatchMap.get(batchName).size() > QuartzCfg.DEFAUTL_NUM) {
					List<SAPBatch> insertBatch = insertBatchMap.get(batchName);
					try {
						detail.setInsertNum(detail.getInsertNum()
								+ insertBatch.size());
						doInsertBatch(insertBatch, detail);
					} catch (Exception e) {
						logger.error("批量插入操作发生异常" + e.getMessage());
						detail.getErrorMsg().add("批量插入操作发生异常" + e.getMessage());
					} finally {
						insertBatchMap.remove(batchName);
					}
				}
			}
		}
	}

	private List<String> findExistExecute(String dbId, String sql,
			TibSapSyncLogDetail detail) {
		List<String> existList = new ArrayList<String>();
		DataSet dataSet = null;
		try {
			dataSet = initDataSet(dbId);
			ResultSet rs = dataSet.executeQuery(sql);
			while (rs.next()) {
				existList.add((String) rs.getObject(1));
			}
		} catch (Exception e) {
			logger.equals("检测数据库是否存在条目执行出错" + e.getMessage());
			detail.getErrorMsg().add("检测数据库是否存在条目执行出错" + e.getMessage());
		} finally {
			dataSet.close();
		}

		return existList;
	}

	/**
	 * 查找需要删除的数据
	 * 
	 * @param script
	 * @param batch
	 * @return
	 */
	public Map<String, SAPBatch> findDeleteField(String script,
			Map<String, SAPBatch> batch) {
		Map<String, SAPBatch> delBatch = new HashMap<String, SAPBatch>();
		Interpreter interpreter = new Interpreter();
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		if (loader != null) {
			interpreter.setClassLoader(loader);
		}
		try {
			// 修改增强循环删除后面报错ConcurrentModificationException
			Iterator<String> it = batch.keySet().iterator();
			while (it.hasNext()) {
				String key = it.next();
				SAPBatch sapbatch = batch.get(key);
				Map<String, String> params = sapbatch.getKeyNamesSAP(); // sapbatch.getParams();
				Map<String, Object> valueMap = sapbatch.getParams();
				String scriptClone = script;
				for (String paramsKey : params.keySet()) {
					String value = (String) valueMap.get(params.get(paramsKey));
					if (StringUtil.isNull(value)) {
						value = "&quot;&quot;";
					} else {
						value = "&quot;" + value + "&quot;";
					}
					scriptClone = scriptClone.replace("$" + paramsKey + "$",
							value);
				}
				scriptClone = HtmlUtils.htmlUnescape(scriptClone);
				Object result;
				result = interpreter.eval(scriptClone);
				boolean parseResult = (Boolean) result;
				if (parseResult) {
					delBatch.put(key, sapbatch);
					it.remove();
				}
			}
			return delBatch;

		} catch (EvalError e) {
			e.printStackTrace();
			return delBatch;
		} catch (Exception e) {
			e.printStackTrace();
			return delBatch;
		}
	}

	/**
	 * 
	 * @param script
	 * @param sapbatch
	 * @return true 符合条件 false 不符合条件
	 */
	private boolean filterByCondition(String script, SAPBatch sapbatch) {
		Interpreter interpreter = new Interpreter();
		Map<String, String> params = sapbatch.getKeyNamesSAP(); // sapbatch.getParams();
		Map<String, Object> valueMap = sapbatch.getParams();
		String scriptClone = script;
		for (String paramsKey : params.keySet()) {
			String value = (String) valueMap.get(params.get(paramsKey));
			if (StringUtil.isNull(value)) {
				value = "&quot;&quot;";
			} else {
				value = "&quot;" + value + "&quot;";
			}
			scriptClone = scriptClone.replace("$" + paramsKey + "$", value);
		}
		scriptClone = HtmlUtils.htmlUnescape(scriptClone);
		Object result;
		try {
			result = interpreter.eval(scriptClone);
			boolean parseResult = (Boolean) result;
			return parseResult;
		} catch (EvalError e) {
			logger.debug(e.getScriptStackTrace());
			return false;
		}
	}

	/**
	 * 这条语句可能开销比较大或者存在一些问题。 拼接sql 语句 语句类型：
	 * 
	 * @see QuartzCfg 语句
	 * @param dbId
	 * @param batchMap
	 * @return
	 */
	private String findExistSQL(String dbId, Map<String, SAPBatch> batchMap) {
		StringBuffer selectKey = new StringBuffer();
		StringBuffer where = new StringBuffer();
		String tableName = null;
		String dbType = null;
		String existSQL = null;
		String pattern = null;

		try {
			CompDbcp compDbcp = (CompDbcp) compDbcpService
					.findByPrimaryKey(dbId);
			dbType = compDbcp.getFdType();
		} catch (Exception e) {
			logger.error("没有找到数据源,查找数据源出错~!");
		}

		if ("MY SQL".equalsIgnoreCase(dbType)) {
			pattern = QuartzCfg.STRING_JOIN_MYSQL;
			existSQL = QuartzCfg.FIND_EXIST_MYSQL;
		} else if ("MS SQL Server".equals(dbType)) {
			pattern = QuartzCfg.STRING_JOIN_MSSQLSERVER;
			existSQL = QuartzCfg.FIND_EXIST_MSSQLSERVER;
		} else if ("Oracle".equals(dbType)) {
			pattern = QuartzCfg.STRING_JOIN_ORACLE;
			existSQL = QuartzCfg.FIND_EXIST_ORACLE;
		} else if ("DB2".equals(dbType)) {
			pattern = QuartzCfg.STRING_JOIN_DB2;
			existSQL = QuartzCfg.FIND_EXIST_DB2;
		}
		boolean first = true;
		for (String key : batchMap.keySet()) {
			SAPBatch batch = batchMap.get(key);
			if (first) {
				tableName = batch.getTableName();
				selectKey.append(stringJoin(batch.getKeyNames(), pattern));
				first = false;
			} else {
				where.append(" OR ");
			}
			where.append(batch.getWhereBlock());
		}

		existSQL = existSQL.replace("!{SELECTKEY}", selectKey.toString())
				.replace("!{TABLENAME}", tableName)
				// .replace("!{COMBINEDKEY}",selectKey.toString())
				.replace("!{WHEREBOCK}", where.toString());
		return existSQL;
	}

	/**
	 * 拼接SQL语句字符串源
	 * 
	 * @param source
	 *            字符源
	 * @param pattern
	 *            数据库拼接字符标准or函数
	 * @return
	 */
	private String stringJoin(Collection<String> source, String pattern) {
		boolean first = true;
		// StringBuffer sb = new StringBuffer();
		String sb = "";
		for (String s : source) {
			if (first) {
				first = false;
			} else {
				String fStr = sb.toString();
				s = pattern.replace("{0}", fStr).replace("{1}", s);
			}
			sb = s;
		}
		return sb;
	}

	/**
	 * 插入语句拼接
	 * 
	 * @param params
	 * @param tableName
	 * @return
	 */
	private String insertSQL(Map<String, Object> params, String tableName) {
		// 组装插入语句
		StringBuffer buffer = new StringBuffer("insert into ");
		buffer.append(tableName);
		String fieldString = "(";
		String parameString = "(";
		int index = 0;
		for (String key : params.keySet()) {
			fieldString += key + " ";
			parameString += ":" + key + " ";
			if (index < params.size() - 1) {
				fieldString += ",";
				parameString += ",";
			}
			index++;
		}
		fieldString += ")";
		parameString += ")";
		buffer.append(fieldString);
		buffer.append(" values ");
		buffer.append(parameString);

		return buffer.toString();
	}

	/**
	 * 执行更新批量操作
	 * 
	 * @param sapBatch
	 * @throws Exception
	 */
	private void doUpdateBatchV2(Map<String, SAPBatch> sapBatch,
			TibSapSyncLogDetail qd) throws Exception {
		if (sapBatch == null || sapBatch.isEmpty())
			return;

		Set<String> keyset = sapBatch.keySet();
		SAPBatch titleBatch = null;// sapBatch.get(0);

		int index = 0;
		for (String key : keyset) {
			titleBatch = sapBatch.get(key);
			if (index == 0) {
				break;
			}
		}
		DataSet dataSet = initDataSet(titleBatch.getDbId());
		String sql = updateSQL(titleBatch.getKeyNames(),
				titleBatch.getParams(), titleBatch.getTableName());

		// 构造sql语句===参考dataSet 修改 ,适应批量插入
		StringBuffer sqlBuff = new StringBuffer();
		List<String> paramList = new ArrayList<String>();
		Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");
		Matcher matcher = pattern.matcher(sql);
		while (matcher.find()) {
			paramList.add(matcher.group(0).substring(1));
			matcher.appendReplacement(sqlBuff, "?");
		}
		matcher.appendTail(sqlBuff);
		PreparedStatement pstm = null;
		try {
			pstm = dataSet.getConnection().prepareStatement(sqlBuff.toString());
			dataSet.getConnection().setAutoCommit(false);
			for (String curKey : keyset) {
				SAPBatch curBatch = sapBatch.get(curKey);
				// 开启事务
				Map<String, Object> params = curBatch.getParams();
				for (int length = paramList.size(), i = 0; i < length; ++i) {
					Object value = params.get(paramList.get(i));
					if (value instanceof String)
						pstm.setString(i + 1, (String) value);
					else if (value instanceof Float)
						pstm.setFloat(i + 1, ((Float) value).floatValue());
					else if (value instanceof Integer)
						pstm.setInt(i + 1, ((Integer) value).intValue());
					else if (value instanceof Long)
						pstm.setLong(i + 1, ((Long) value).longValue());
					// 时间类型需要改良，没有对util 进行判断转化
					else if (value instanceof java.sql.Date)
						pstm.setDate(i + 1, (java.sql.Date) value);
					else if (value instanceof Timestamp)
						pstm.setTimestamp(i + 1, (Timestamp) value);
					else
						pstm.setString(i + 1, value.toString());
				}
				pstm.addBatch();
			}
			pstm.executeBatch();
			dataSet.commit();
		} catch (Exception e) {
			dataSet.rollback();
			logger.debug(e.getMessage() + "-更新操作回滚数据");
			// 记录日志
			writeRockBackList(sapBatch, qd);
			// 异常不往上抛,不终止
			// throw e;

		} finally {
			if (pstm != null) {
				pstm.close();
			}
			dataSet.close();
		}
	}

	/**
	 * 执行更新批量操作
	 * 
	 * @param sapBatch
	 * @throws Exception
	 */
	private void doUpdateBatch(List<SAPBatch> sapBatch, TibSapSyncLogDetail qd)
			throws Exception {
		if (sapBatch == null || sapBatch.isEmpty())
			return;

		SAPBatch titleBatch = sapBatch.get(0);
		DataSet dataSet = initDataSet(titleBatch.getDbId());
		String sql = updateSQL(titleBatch.getKeyNames(),
				titleBatch.getParams(), titleBatch.getTableName());

		// 构造sql语句===参考dataSet 修改 ,适应批量插入
		StringBuffer sqlBuff = new StringBuffer();
		List<String> paramList = new ArrayList<String>();
		Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");
		Matcher matcher = pattern.matcher(sql);
		while (matcher.find()) {
			paramList.add(matcher.group(0).substring(1));
			matcher.appendReplacement(sqlBuff, "?");
		}
		matcher.appendTail(sqlBuff);
		PreparedStatement pstm = null;
		try {
			pstm = dataSet.getConnection().prepareStatement(sqlBuff.toString());
			dataSet.getConnection().setAutoCommit(false);
			for (SAPBatch curBatch : sapBatch) {
				// 开启事务
				Map<String, Object> params = curBatch.getParams();
				for (int length = paramList.size(), i = 0; i < length; ++i) {
					Object value = params.get(paramList.get(i));
					if (value instanceof String)
						pstm.setString(i + 1, (String) value);
					else if (value instanceof Float)
						pstm.setFloat(i + 1, ((Float) value).floatValue());
					else if (value instanceof Integer)
						pstm.setInt(i + 1, ((Integer) value).intValue());
					else if (value instanceof Long)
						pstm.setLong(i + 1, ((Long) value).longValue());
					// 时间类型需要改良，没有对util 进行判断转化
					else if (value instanceof java.sql.Date)
						pstm.setDate(i + 1, (java.sql.Date) value);
					else if (value instanceof Timestamp)
						pstm.setTimestamp(i + 1, (Timestamp) value);
					else
						pstm.setString(i + 1, value.toString());
				}
				// logger.debug(sqlBuff.toString() + "data:" +
				// params.toString());
				pstm.addBatch();
			}
			pstm.executeBatch();
			dataSet.commit();
		} catch (Exception e) {
			dataSet.rollback();
			logger.debug(e.getMessage() + "-更新操作回滚数据");
			// 记录日志
			writeRockBackList(sapBatch, qd);
			// 异常不往上抛,不终止
			// throw e;

		} finally {
			if (pstm != null) {
				pstm.close();
			}
			dataSet.close();
		}
	}

	/**
	 * 更新语句拼接
	 * 
	 * @param keyNames
	 * @param params
	 * @param tableName
	 * @return
	 */
	private String updateSQL(List<String> keyNames, Map<String, Object> params,
			String tableName) {
		StringBuffer update_buf = new StringBuffer();
		StringBuffer where_buf = new StringBuffer();
		for (int i = 0, len = keyNames.size(); i < len; i++) {
			String key = keyNames.get(i);
			if (StringUtil.isNull(key))
				continue;
			where_buf.append(key + "=:" + key);
			if (i + 1 < len) {
				where_buf.append(" and ");
			}
		}
		int cur = 0;
		int len = params.size();
		for (Object key : params.keySet()) {
			update_buf.append(key + "=:" + key);
			if (cur + 1 < len) {
				update_buf.append(" , ");
			}
			cur++;
		}
		String where = StringUtil.isNotNull(where_buf.toString()) ? " where "
				+ where_buf.toString() : "";
		String temsql = "update " + tableName + " set " + update_buf.toString()
				+ where;
		return temsql;
	}

	/**
	 * 执行批量插入操作
	 * 
	 * @param sapBatch
	 * @throws Exception
	 */
	private void doInsertBatchV2(Map<String, SAPBatch> sapBatch,
			TibSapSyncLogDetail qd) throws Exception {
		if (sapBatch == null || sapBatch.isEmpty())
			return;

		Set<String> keyset = sapBatch.keySet();
		SAPBatch titleBatch = null;// sapBatch.get(0);

		int index = 0;
		for (String key : keyset) {
			titleBatch = sapBatch.get(key);
			if (index == 0) {
				break;
			}
		}
		DataSet dataSet = initDataSet(titleBatch.getDbId());
		String sql = insertSQL(titleBatch.getParams(), titleBatch
				.getTableName());

		// 构造sql语句===参考dataSet 修改 ,适应批量插入
		StringBuffer sqlBuff = new StringBuffer();
		List<String> paramList = new ArrayList<String>();
		Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");
		Matcher matcher = pattern.matcher(sql);
		while (matcher.find()) {
			paramList.add(matcher.group(0).substring(1));
			matcher.appendReplacement(sqlBuff, "?");
		}
		matcher.appendTail(sqlBuff);
		PreparedStatement pstm = null;
		try {
			pstm = dataSet.getConnection().prepareStatement(sqlBuff.toString());
			// 开启事务
			dataSet.getConnection().setAutoCommit(false);
			for (String curKey : keyset) {
				SAPBatch curBatch = sapBatch.get(curKey);
				Map<String, Object> params = curBatch.getParams();
				printMap(params);
				for (int length = paramList.size(), i = 0; i < length; ++i) {
					Object value = params.get(paramList.get(i));
					if (value instanceof String)
						pstm.setString(i + 1, (String) value);
					else if (value instanceof Float)
						pstm.setFloat(i + 1, ((Float) value).floatValue());
					else if (value instanceof Integer)
						pstm.setInt(i + 1, ((Integer) value).intValue());
					else if (value instanceof Long)
						pstm.setLong(i + 1, ((Long) value).longValue());
					// 时间类型需要改良，没有对util 进行判断转化
					else if (value instanceof java.sql.Date)
						pstm.setDate(i + 1, (java.sql.Date) value);
					else if (value instanceof Timestamp)
						pstm.setTimestamp(i + 1, (Timestamp) value);
					else
						pstm.setString(i + 1, value.toString());
				}
				// logger.debug(sqlBuff.toString() + "data:" +
				// params.toString());
				pstm.addBatch();
			}
			pstm.executeBatch();
			dataSet.commit();
		} catch (Exception e) {

			dataSet.rollback();
			logger.error(e.getMessage() + "-插入操作回滚数据");
			// 写入日志,把这个批次的数据
			writeRockBackList(sapBatch, qd);
			// 异常往上抛,导致整个数据操作回滚
			// throw e;
		} finally {
			if (pstm != null) {
				pstm.close();
			}
			dataSet.close();
		}

	}

	/**
	 * 执行批量插入操作
	 * 
	 * @param sapBatch
	 * @throws Exception
	 */
	private void doInsertBatch(List<SAPBatch> sapBatch, TibSapSyncLogDetail qd)
			throws Exception {
		if (sapBatch == null || sapBatch.isEmpty())
			return;

		SAPBatch titleBatch = sapBatch.get(0);
		DataSet dataSet = initDataSet(titleBatch.getDbId());
		String sql = insertSQL(titleBatch.getParams(), titleBatch
				.getTableName());

		// 构造sql语句===参考dataSet 修改 ,适应批量插入
		StringBuffer sqlBuff = new StringBuffer();
		List<String> paramList = new ArrayList<String>();
		Pattern pattern = Pattern.compile(":[^\\s=)<>,]+");
		Matcher matcher = pattern.matcher(sql);
		while (matcher.find()) {
			paramList.add(matcher.group(0).substring(1));
			matcher.appendReplacement(sqlBuff, "?");
		}
		matcher.appendTail(sqlBuff);
		PreparedStatement pstm = null;
		try {
			pstm = dataSet.getConnection().prepareStatement(sqlBuff.toString());
			// 开启事务
			dataSet.getConnection().setAutoCommit(false);
			for (SAPBatch curBatch : sapBatch) {
				Map<String, Object> params = curBatch.getParams();
				
				printMap(params);
				
				for (int length = paramList.size(), i = 0; i < length; ++i) {
					Object value = params.get(paramList.get(i));
					if (value instanceof String)
						pstm.setString(i + 1, (String) value);
					else if (value instanceof Float)
						pstm.setFloat(i + 1, ((Float) value).floatValue());
					else if (value instanceof Integer)
						pstm.setInt(i + 1, ((Integer) value).intValue());
					else if (value instanceof Long)
						pstm.setLong(i + 1, ((Long) value).longValue());
					// 时间类型需要改良，没有对util 进行判断转化
					else if (value instanceof java.sql.Date)
						pstm.setDate(i + 1, (java.sql.Date) value);
					else if (value instanceof Timestamp)
						pstm.setTimestamp(i + 1, (Timestamp) value);
					else
						pstm.setString(i + 1, value.toString());
				}
				pstm.addBatch();
			}
			pstm.executeBatch();
			dataSet.commit();
		} catch (Exception e) {
			dataSet.rollback();
			logger.error(e.getMessage() + "-插入操作回滚数据");
			// 写入日志,把这个批次的数据
			writeRockBackList(sapBatch, qd);
			// 异常往上抛,导致整个数据操作回滚
			// throw e;
		} finally {
			if (pstm != null) {
				pstm.close();
			}
			dataSet.close();
		}

	}
	public void printMap(Map<String, Object> params){
		logger.warn("========================");
		for(String s:params.keySet()){
			System.out.print(s+":"+(String)params.get(s));
			
		}
		System.out.print("\n");
		
	}
	

	public void writeRockBackList(Map<String, SAPBatch> sapBatch,
			TibSapSyncLogDetail qd) {
		List<String> keyList = new ArrayList<String>();

		for (String sp : sapBatch.keySet()) {
			keyList.add(sapBatch.get(sp).getKeysVal());
		}
		qd.getRockList().addAll(keyList);
	}

	public void writeRockBackList(List<SAPBatch> sapBatch,
			TibSapSyncLogDetail qd) {
		List<String> keyList = new ArrayList<String>();
		for (SAPBatch sp : sapBatch) {
			if (sp.getKeyNames().size() > 0)
				keyList.add(sp.getKeysVal());
			else
				keyList.add(sp.getParams().toString());
		}
		qd.getRockList().addAll(keyList);
	}

	/**
	 * 初始化数据源
	 * 
	 * @param compDbcpId
	 * @return
	 * @throws Exception
	 */
	private DataSet initDataSet(String compDbcpId) throws Exception {
		CompDbcp compDbcp = (CompDbcp) compDbcpService
				.findByPrimaryKey(compDbcpId);
		DataSet dataSet = new DataSet(compDbcp.getFdName());
		// COMPDBCPID = compDbcp.getFdId();
		return dataSet;
	}

	/**
	 * 
	 * @param timpStampVal
	 * @param date
	 * @return true ：执行数据操作 false :不执行
	 */
	public boolean compareTime(String timpStampVal, Date date, String pattern) {
		// null 值过滤;1321494349620 1321407949062 /1321494349062
		if (StringUtil.isNull(timpStampVal)) {
			return true;
		}
		if (date == null) {
			return true;
		}
		// timpStampVal="20111111";
		// 如果timpStampVal 按照date 格式,则通过date转换
		try {
			Date stamp_date = DateUtil.convertStringToDate(timpStampVal,
					pattern);
			if (stamp_date.getTime() < date.getTime()) {
				return false;
			}
		} catch (KmssRuntimeException e) {
			// 如果数据转换错误，则继续执行数据操作，忽略时间比对
			logger.debug(e.getMessage());
			return true;
		}
		return true;
	}

	public boolean compareTime(String timpStampVal, Date date) {
		return compareTime(timpStampVal, date, QuartzCfg.QUARTZ_DEFAULT_PATTERN);
	}

	/**
	 * 获取节点的某个属性,如果xml上不存在这个属性或者属性为null||""都返回默认值
	 * 
	 * @param element
	 *            xml节点
	 * @param attrName
	 *            属性名
	 * @param defaultValue
	 *            默认值
	 * @return 属性值
	 */
	public String getAttrValue(Element element, String attrName,
			String defaultValue) {
		if (StringUtil.isNull(attrName)) {
			return defaultValue;
		}
		Attribute attr = element.attribute(attrName);
		if (attr == null) {
			return defaultValue;
		}
		String attrValue = attr.getValue();
		return StringUtil.isNotNull(attrValue) ? attrValue : defaultValue;
	}

	/**
	 * 根据条件判断是否存在这条记录
	 * 
	 * @param params
	 *            所有封装好参数 Map<key,value> key为字段名，value字段值
	 * @param keyName
	 *            主键值
	 * @param tableName
	 *            要操作的表
	 * @return
	 */
	public boolean existInTable(Map params, List<String> keyNames,
			String tableName, String dbId) {
		StringBuffer select_buf = new StringBuffer();
		StringBuffer where_buf = new StringBuffer();
		for (int i = 0, len = keyNames.size(); i < len; i++) {
			String key = keyNames.get(i);
			if (StringUtil.isNull(key))
				continue;
			select_buf.append(key);
			where_buf.append(key + "=:" + key);
			if (i + 1 < len) {
				select_buf.append(" , ");
				where_buf.append(" and ");
			}
		}

		String sql = "select " + select_buf.toString() + " from " + tableName
				+ " where " + where_buf.toString();
		DataSet dataSet;
		try {
			dataSet = initDataSet(dbId);
		} catch (Exception e1) {
			logger.error(e1.getMessage());
			return false;
		}
		try {
			dataSet.setParametersInPreparation(sql, params);
			ResultSet rs = dataSet.executeQuery();
			if (rs.next()) {
				return true;
			}
			return false;
		} catch (SQLException e) {
			logger.debug(e.getMessage());
			tibSapSyncLogVo.getErrList().add(
					"SAP 查询时使用数据源" + dbId + "出错:" + e.getMessage());
			tibSapSyncLogVo.setFdErr(true);
		} finally {
			dataSet.close();
		}
		return false;
	}

	/**
	 * 清空表中所有数据
	 * 
	 * @param tableName
	 * @param dbId
	 */
	public void emptypTable(String tableName, String dbId) {
		if (StringUtil.isNull(tableName) || StringUtil.isNull(dbId))
			return;
		DataSet dataSet;
		try {
			dataSet = initDataSet(dbId);
		} catch (Exception e1) {
			tibSapSyncLogVo.getErrList().add(
					"SAP===使用数据源-" + dbId + "出错：" + e1.getMessage());
			logger.error(e1.getMessage());
			tibSapSyncLogVo.setFdErr(true);
			return;
		}
		// 分开捕捉异常
		try {
			dataSet.beginTran();
			dataSet.executeUpdate(QuartzCfg.QUARTZ_EMPTY_TABLE.replace(
					"!{TABLENAME}", tableName));
			dataSet.commit();
		} catch (SQLException e) {
			// TODO 自动生成 catch 块
			dataSet.rollback();
			logger.error(e.getMessage());
			tibSapSyncLogVo.getErrList().add(
					"SAP===对数据源-" + dbId + " 清空" + tableName + "出错："
							+ e.getMessage());
			tibSapSyncLogVo.setFdErr(true);
		} finally {
			dataSet.close();
		}

	}

	/**
	 * 检查map 里面的值是否全空
	 * 
	 * @param params
	 * @return
	 */
	public boolean checkParams(Map params) {
		boolean resultCheck = false;
		for (Object key : params.keySet()) {
			Object value = params.get(key);
			boolean check = value != null
					&& StringUtil.isNotNull(value.toString());
			resultCheck = resultCheck || check;
		}
		return resultCheck;
	}
	
	/**
	 * 获得当前表的所有字段
	 * @throws Exception 
	 * 
	 */
	public void getTabField(String dbId,String tableName){
		Map<String, String> tabMap=null;
		try {
			tabMap = TableFieldUtils.getTableFileld(dbId, tableName);
		} catch (Exception e) {
			logger.error(e.getMessage());
			tibSapSyncLogVo.getErrList().add(
					"SAP===对数据源-" + dbId + " 获取表" + tableName + "中的列字段出错："
							+ e.getMessage());
		}
		tabFieldMap.put(tableName, tabMap);
	}
	
	/**
	 * 如果该表中含有fd_id字段，并且该字段未被映射,则用公司自定义id生成器赋值
	 * 
	 */
  public void checkedFdId(String tableName,Map<String,Object> params){
	  if(tabFieldMap.containsKey(tableName)){
			Map fieldMap = tabFieldMap.get(tableName);
			if(fieldMap!=null && fieldMap.size()>0){
				//如果该表中存在fd_id并且该fd_id未被映射的情况下 ,fd_id的值由公司自定义主键生成方式赋值
				if(fieldMap.containsKey("fd_id") && !params.containsKey("fd_id")){
					params.put("fd_id", IDGenerator.generateID());
				}
			}
		}
  }	
	
}
