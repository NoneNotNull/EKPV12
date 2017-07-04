package com.landray.kmss.tib.sap.mapping.service.spring;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.sys.workflow.engine.INodeServiceActionResult;
import com.landray.kmss.sys.workflow.engine.WorkflowEngineContext;
import com.landray.kmss.sys.workflow.engine.spi.model.SysWfNode;
import com.landray.kmss.sys.workflow.support.oa.robot.interfaces.ISysWfRobotNodeService;
import com.landray.kmss.sys.workflow.support.oa.robot.support.AbstractRobotNodeServiceImp;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMetaParse;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapBusinessException;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapProcessException;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapReturnConstants;
import com.landray.kmss.util.StringUtil;

public class TibSapWfRobotNodeRunSapBapiService extends
		AbstractRobotNodeServiceImp implements ISysWfRobotNodeService {

	private static final Log log = LogFactory
			.getLog(TibSapWfRobotNodeRunSapBapiService.class);
	
	private ITibCommonMappingMetaParse tibCommonMappingMetaParse;
	
	public void setTibCommonMappingMetaParse(
			ITibCommonMappingMetaParse tibCommonMappingMetaParse) {
		this.tibCommonMappingMetaParse = tibCommonMappingMetaParse;
	}

	private ITibCommonMappingFuncService tibCommonMappingFuncService;

	private ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil;

	public void settibSysSapJcoFunctionUtil(
			ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil) {
		this.tibSysSapJcoFunctionUtil = tibSysSapJcoFunctionUtil;
	}

	private ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService;

	public ISysMetadataParser getSysMetadataParser() {
		return sysMetadataParser;
	}

	public ITibCommonMappingFuncService getTibCommonMappingFuncService() {
		return tibCommonMappingFuncService;
	}

	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	public ITibSysSapJcoFunctionUtil getTibSysSapJcoFunctionUtil() {
		return tibSysSapJcoFunctionUtil;
	}

	public void setTibSysSapJcoFunctionUtil(
			ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil) {
		this.tibSysSapJcoFunctionUtil = tibSysSapJcoFunctionUtil;
	}

	public ITibCommonMappingFuncXmlOperateService getTibCommonMappingFuncXmlOperateService() {
		return tibCommonMappingFuncXmlOperateService;
	}

	public void setTibCommonMappingFuncXmlOperateService(
			ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService) {
		this.tibCommonMappingFuncXmlOperateService = tibCommonMappingFuncXmlOperateService;
	}

	public ITibCommonMappingMainService getTibCommonMappingMainService() {
		return tibCommonMappingMainService;
	}

	public void setTibCommonMappingMainService(
			ITibCommonMappingMainService tibCommonMappingMainService) {
		this.tibCommonMappingMainService = tibCommonMappingMainService;
	}

	private ISysMetadataParser sysMetadataParser;

	public void setSysMetadataParser(ISysMetadataParser sysMetadataParser) {
		this.sysMetadataParser = sysMetadataParser;
	}

	private ITibCommonMappingMainService tibCommonMappingMainService;

	public void setErpEkpTempFuncMainService(
			ITibCommonMappingMainService tibCommonMappingMainService) {
		this.tibCommonMappingMainService = tibCommonMappingMainService;
	}

	public INodeServiceActionResult execute(WorkflowEngineContext context,
			SysWfNode node) throws Exception {
		String cfgContent = getConfigContent(context, node);
		if (cfgContent == null) {
			return getDefaultActionResult(context, node);
		}
		// 获得JSON配置
		JSONObject json = (JSONObject) JSONValue.parse(cfgContent);
		String funcId = (String) json.get("funcId");
		if (StringUtil.isNotNull(funcId)) {
			runBapi(funcId, context);
		} else {
			log.warn(" 机器人节点配置的关联SAP映射模板 ID 为空,跳过不执行该机器人节点");
		}
		return getDefaultActionResult(context, node);
	}

	private TibCommonMappingFunc getFunc(String funcId) throws Exception {
		TibCommonMappingFunc tibCommonMappingFunc = (TibCommonMappingFunc) tibCommonMappingFuncService
				.findByPrimaryKey(funcId, TibCommonMappingFunc.class, true);
		return tibCommonMappingFunc;
	}

	private void runBapi(String funcId, WorkflowEngineContext context)
			throws Exception {

		TibCommonMappingFunc tibCommonMappingFunc = null;
		IBaseModel mainModel = null;
		TibSysSapReturnVo sapVo = null;
		try {
			tibCommonMappingFunc = getFunc(funcId);
			if (tibCommonMappingFunc == null) {
				log.error("执行 SAP机器人节点, 执行 SAP TibCommonMappingFunc 中找不到关联的配置映射信息,请检查ErpEkpTempFunc 的"
						+ funcId + "是否存在,或者重新创建机器人节点创建关联关系~");
				return;// throw new
						// Exception("执行 soapui机器人节点, TibCommonMappingFunc 中找不到关联的配置映射信息,请检查ErpEkpTempFunc 的"+funcId+"是否存在,或者重新创建机器人节点创建关联关系~");
			}
			// 判断是否注册启用
			String fdTemplateId = tibCommonMappingFunc.getFdTemplateId();
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setSelectBlock("tibCommonMappingMain.fdMainModelName");
			hqlInfo.setWhereBlock("tibCommonMappingMain.fdTemplateId=:fdTemplateId");
			hqlInfo.setParameter("fdTemplateId", fdTemplateId);
			List list = tibCommonMappingMainService.findValue(hqlInfo);
			if (list != null && !list.isEmpty()) {
				String fdTemplateName = (String) list.get(0);
				if (!tibCommonMappingFuncXmlOperateService.ifRegister(
						fdTemplateName, Constant.FD_TYPE_SAP))
					return;
			}
			Document document = DocumentHelper.parseText(tibCommonMappingFunc
					.getFdRfcParamXml());
			mainModel = context.getMainModel();
			FormulaParser formulaParser = FormulaParser.getInstance(mainModel);
			tibCommonMappingFuncXmlOperateService.setFuncImportXmlByFormula(
					document, formulaParser);
			tibCommonMappingFuncXmlOperateService.setFuncImportTableByFormula(
					document, formulaParser);

			sapVo = tibSysSapJcoFunctionUtil.getXMltoFunction(document.asXML());
			String backXml = (String) sapVo.getResult();
			if (StringUtil.isNotNull(backXml)) {
				// 将执行函数后返回的xml转化为document对象
				document = DocumentHelper.parseText(backXml);
				tibCommonMappingFuncXmlOperateService.setFuncExportXml(
						document, mainModel);
				tibCommonMappingFuncXmlOperateService.setFuncExportTable(
						document, mainModel);
			}
			// zhangtian=========================================
			// ======强制赋值====
			resetFields(mainModel, tibCommonMappingFunc, sapVo.getReturnType());

			// 表单保存事件校验执行模板操作
			if (!checkPass(tibCommonMappingFunc, sapVo.getReturnType())) {
				if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN
						.equals(sapVo.getReturnType())) {
					// throw new Exception("SAP 交互发生异常~!");
					String msg = sapVo.getRtnExcepton() != null ? sapVo
							.getRtnExcepton().getMessage() : "";
					throw new TibSysSapProcessException(true,
							"SAP Program Exception,See Log:" + msg);
				} else if (TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN
						.equals(sapVo.getReturnType())) {
					// 抛出业务异常
					throw new TibSysSapBusinessException(true,
							"SAP busniess Exception - Exception template description:" + tibCommonMappingFunc.getFdId());
				}
			}
			// ====================================
		} catch (Exception e) {
			e.printStackTrace();
			if (e instanceof TibSysSapProcessException) {
				throw e;
			} else if (e instanceof TibSysSapBusinessException) {
				throw e;
			}
			/*************************************
			 * 如果在下面发生程序异常则不处理
			 */
			resetFields(mainModel, tibCommonMappingFunc, sapVo.getReturnType());
			// 表单保存事件校验执行模板操作
			if (!checkPass(tibCommonMappingFunc, sapVo.getReturnType())) {
				if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN
						.equals(sapVo.getReturnType())) {
					String msg = sapVo.getRtnExcepton() != null ? sapVo
							.getRtnExcepton().getMessage() : "";
					throw new TibSysSapProcessException(true,
							"SAP Program Exception,See Log:" + msg);
				} else if (TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN
						.equals(sapVo.getReturnType())) {
					// 抛出业务异常
					throw new TibSysSapBusinessException(true,
							"SAP busniess Exception - Exception template description:" + 
							tibCommonMappingFunc.getFdId());
				}
			}
		} finally {
			// 用传出参数修改model后保存更新此model
			sysMetadataParser.saveModel(mainModel);
		}

	}

	/**
	 * 判断是否通过节点
	 * 
	 * @param tmpFucn
	 *            模板对象
	 * @param returnType
	 *            异常类型
	 * @return
	 */
	private boolean checkPass(TibCommonMappingFunc tmpFucn, String returnType) {
		List<TibCommonMappingFuncExt> extList = tmpFucn.getFdExtend();
		String returnString = "";
		if (TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN
				.equals(returnType)) {
			returnString = TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_DESCRIBE;
		} else if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN
				.equals(returnType)) {
			returnString = TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_DESCRIBE;
		}
		// 通过
		if (StringUtil.isNull(returnString)) {
			return true;
		}
		for (TibCommonMappingFuncExt ext : extList) {
			if (returnString.equals(ext.getFdExceptionType())) {
				// FdIsIgnore 字段是否停止，true：停 false:通过
				return ext.getFdIsIgnore() != null
						&& ext.getFdIsIgnore() == true ? false : true;
			}
		}
		return true;
	}

	public void resetFields(IBaseModel model, TibCommonMappingFunc tmpFucn,
			String returnType) throws Exception {
		// 普通返回值快速忽略
		if (TibSysSapReturnConstants.TIBSYSSAP_SIMPLE_RETURN.equals(returnType)) {
			return;
		}

		List<TibCommonMappingFuncExt> extList = tmpFucn.getFdExtend();
		String returnString = "";
		if (TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN
				.equals(returnType)) {
			returnString = TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_DESCRIBE;
		} else if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN
				.equals(returnType)) {
			returnString = TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_DESCRIBE;
		}
		if (StringUtil.isNull(returnString)) {
			return;
		}
		for (TibCommonMappingFuncExt ext : extList) {
			if (returnString.equals(ext.getFdExceptionType())) {
				if (ext.getFdIsAssign()) {
					String assignId = ext.getFdAssignFieldid();
					String assignVal = ext.getFdAssignVal();
					tibCommonMappingMetaParse.setFieldValue(model, getEkpid(assignId),
							assignVal);
				}
			}
		}
	}

	// 去除ekpid$符号,ekpid原格式为$a$或$a.b$。
	private String getEkpid(String ekpid) {
		if (StringUtil.isNull(ekpid))
			return null;
		int last = ekpid.lastIndexOf("$");
		ekpid = ekpid.substring(1, last);
		return ekpid;
	}
}
