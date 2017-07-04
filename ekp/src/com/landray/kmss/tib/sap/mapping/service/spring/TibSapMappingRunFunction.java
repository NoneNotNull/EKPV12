package com.landray.kmss.tib.sap.mapping.service.spring;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMetaParse;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapBusinessException;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapProcessException;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapReturnConstants;
import com.landray.kmss.util.StringUtil;

public class TibSapMappingRunFunction {
	private static final Log log = LogFactory
		.getLog(TibSapMappingRunFunction.class);
	
	private ITibCommonMappingMainService tibCommonMappingMainService;
	private ITibCommonMappingMetaParse tibCommonMappingMetaParse;
	private ITibCommonMappingFuncXmlOperateService tibSapMappingFuncXmlOperateServiceImp;
	private ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil;
	
	public void setTibCommonMappingMainService(
			ITibCommonMappingMainService tibCommonMappingMainService) {
		this.tibCommonMappingMainService = tibCommonMappingMainService;
	}
	public void setTibCommonMappingMetaParse(
			ITibCommonMappingMetaParse tibCommonMappingMetaParse) {
		this.tibCommonMappingMetaParse = tibCommonMappingMetaParse;
	}
	public void setTibSapMappingFuncXmlOperateServiceImp(
			ITibCommonMappingFuncXmlOperateService tibSapMappingFuncXmlOperateServiceImp) {
		this.tibSapMappingFuncXmlOperateServiceImp = tibSapMappingFuncXmlOperateServiceImp;
	}
	public void setTibSysSapJcoFunctionUtil(
			ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil) {
		this.tibSysSapJcoFunctionUtil = tibSysSapJcoFunctionUtil;
	}
	
	public void runBapi(TibCommonMappingFunc tibCommonMappingFunc, IBaseModel mainModel)
			throws Exception {
		TibSysSapReturnVo sapVo = null;
		try {
			if (tibCommonMappingFunc == null) {
				log.error("执行 SAP TibCommonMappingFunc 中找不到关联的配置映射信息," +
						"请检查TibCommonMappingFunc是否存在");
				return;
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
				if (!tibSapMappingFuncXmlOperateServiceImp.ifRegister(
						fdTemplateName, Constant.FD_TYPE_SAP))
					return;
			}
			Document document = DocumentHelper.parseText(tibCommonMappingFunc
					.getFdRfcParamXml());
			FormulaParser formulaParser = FormulaParser.getInstance(mainModel);
			tibSapMappingFuncXmlOperateServiceImp.setFuncImportXmlByFormula(
					document, formulaParser);
			tibSapMappingFuncXmlOperateServiceImp.setFuncImportTableByFormula(
					document, formulaParser);
			// 获取sap数据
			sapVo = tibSysSapJcoFunctionUtil.getXMltoFunction(document.asXML());
			String backXml = (String) sapVo.getResult();
			if (StringUtil.isNotNull(backXml)) {
				// 将执行函数后返回的xml转化为document对象
				document = DocumentHelper.parseText(backXml);
				tibSapMappingFuncXmlOperateServiceImp.setFuncExportXml(
						document, mainModel);
				tibSapMappingFuncXmlOperateServiceImp.setFuncExportTable(
						document, mainModel);
			}
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
			tibCommonMappingMetaParse.saveModel(mainModel);
		}
	}
	
	private void resetFields(IBaseModel model, TibCommonMappingFunc tmpFucn,
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
	
	// 去除ekpid$符号,ekpid原格式为$a$或$a.b$。
	private String getEkpid(String ekpid) {
		if (StringUtil.isNull(ekpid))
			return null;
		int last = ekpid.lastIndexOf("$");
		ekpid = ekpid.substring(1, last);
		return ekpid;
	}
}
