package com.landray.kmss.tib.sap.mapping.plugins;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.springframework.transaction.TransactionStatus;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingMain;
import com.landray.kmss.tib.common.mapping.plugins.IBaseTibCommonMappingIntegration;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapBusinessException;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapReturnConstants;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.TransactionUtils;

/**
 * 模块拆解,代码级别模块分离使用这个扩展点集成类;
 * 
 * @author zhangtian date :2012-10-9 下午06:11:22
 */
public class TibSapMappingIntegration implements
		IBaseTibCommonMappingIntegration {

	private Log log = LogFactory.getLog(this.getClass());

	public HQLInfo findSettingNameHQLByTempId(String fdTemplateId,
			String fdIntegrationType) {
		HQLInfo saphqlInfo = new HQLInfo();
		// saphqlInfo.setSelectBlock("tibCommonMappingFunc.fdRfcSetting.fdFunctionName ,tibCommonMappingFunc.fdInvokeType ");
		saphqlInfo
				.setSelectBlock("tibCommonMappingFunc.fdRefName ,tibCommonMappingFunc.fdInvokeType ");
		saphqlInfo
				.setWhereBlock("tibCommonMappingFunc.fdTemplateId=:fdTemplateId and tibCommonMappingFunc.fdIntegrationType=:fdIntegrationType");
		saphqlInfo
				.setOrderBy("tibCommonMappingFunc.fdInvokeType asc,tibCommonMappingFunc.fdOrder asc");
		saphqlInfo.setParameter("fdIntegrationType", fdIntegrationType);
		saphqlInfo.setParameter("fdTemplateId", fdTemplateId);
		return saphqlInfo;
	}

	public List<TibCommonMappingFunc> getFormEventIncludeList(
			HttpServletRequest request) throws Exception {
		// 在编辑页面,驳回页面也能获取到模板ID也能获取模板
		String fdTemplateId = "";// =request.getParameter("kmReviewMainForm.fdTemplateId");//基于每个新建文档时都会传递模板id，且都为fdTemplateId

		ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) SpringBeanUtil
				.getBean("tibCommonMappingModuleService");
		// 使用缓存记录的modelName;
		tibCommonMappingModuleService.initRegisterModelHash();
		ConcurrentHashMap<String, Map<String, Object>> tibCommonMappingModuleList = tibCommonMappingModuleService
				.getRegisterModelHash();
		if (tibCommonMappingModuleList.isEmpty()) {
			fdTemplateId = null;
		} else {
			Iterator<String> modelSet = tibCommonMappingModuleList.keySet()
					.iterator();
			while (modelSet.hasNext()) {
				String modelName = modelSet.next();
				if ("init".equals(modelName)) {
					continue;
				}

				try {
					Object obj = Class.forName(modelName).newInstance();
					if (obj != null && (obj instanceof IBaseModel)) {
						Class formClass = (Class) PropertyUtils.getProperty(
								obj, "formClass");
						String formName = formClass.getSimpleName();
						// 注意，如果form 的model 为KmReviewForm 那么 对应的form 在struct
						// 里面配置一定要为 kmReviewForm;首字母小写
						formName = formName.substring(0, 1).toLowerCase()
								+ formName.substring(1, formName.length());
						Object resForm = request.getAttribute(formName);
						if (resForm != null) {
							if (PropertyUtils.isReadable(resForm,
									"fdTemplateId")) {
								fdTemplateId = (String) PropertyUtils
										.getProperty(resForm, "fdTemplateId");
								// System.out.println(fdTemplateId);
							}
						}
					}
				} catch (Exception e) {
					Log log = LogFactory.getLog(this.getClass());
					log.warn("不存在modelName:" + modelName
							+ " 的类,请到SAP应用注册模块取消注册 ");
				}

			}
		}
		ITibCommonMappingMainService tibCommonMappingMainService = (ITibCommonMappingMainService) SpringBeanUtil
				.getBean("tibCommonMappingMainService");
		List<TibCommonMappingMain> list = tibCommonMappingMainService.findList(
				"tibCommonMappingMain.fdTemplateId='" + fdTemplateId + "'",
				null);
		if (!list.isEmpty()) {
			TibCommonMappingMain tibCommonMappingMain = list.get(0);
			List<TibCommonMappingFunc> tibCommonMappingFuncList = new ArrayList<TibCommonMappingFunc>();
			boolean use = tibCommonMappingModuleService.ifRegister(
					tibCommonMappingMain.getFdMainModelName(),
					Constant.FD_TYPE_SAP);// 判断是否注册并启用的了
			if (use)
				tibCommonMappingFuncList = tibCommonMappingMain
						.getFdFormEventFunctionList();// 得到表单事件的函数列表
			List<TibCommonMappingFunc> erptempList = new ArrayList<TibCommonMappingFunc>();
			// 一般加入模板不会太多，
			for (TibCommonMappingFunc tempfunc : tibCommonMappingFuncList) {
				// 加入sap判断，当主模板中不存在对应模板存在,那么久不加入引入列表当中
				if (Constant.FD_TYPE_SAP
						.equals(tempfunc.getFdIntegrationType())) {
					erptempList.add(tempfunc);
				}
			}
			return erptempList;
		}

		return null;
	}

	/**
	 * invokeType 3为机器人节点类型，还有表单事件，流程驳回事件也同样可以用
	 */
	public List<Map<String, String>> getSettingNameInfo(String templateId,
			String invokeType) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(
				1);
		ITibCommonMappingFuncService service = (ITibCommonMappingFuncService) SpringBeanUtil
				.getBean("tibCommonMappingFuncService");

		// 防止sql注入
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(" tibCommonMappingFunc.fdTemplateId=:fdTemplateId and " +
				"tibCommonMappingFunc.fdInvokeType=:fdInvokeType and " +
				"tibCommonMappingFunc.fdIntegrationType=:fdIntegrationType ");
		hqlInfo.setOrderBy(" tibCommonMappingFunc.fdOrder asc");
		hqlInfo.setParameter("fdTemplateId", templateId);
		hqlInfo.setParameter("fdInvokeType", Integer.valueOf(invokeType));
		hqlInfo.setParameter("fdIntegrationType", Constant.FD_TYPE_SAP);
		List<TibCommonMappingFunc> tibCommonMappingFuncList = service
				.findList(hqlInfo);
		for (int i = 0; i < tibCommonMappingFuncList.size(); i++) {
			Map<String, String> map = new HashMap<String, String>(1);
			TibCommonMappingFunc tibCommonMappingFunc = tibCommonMappingFuncList
					.get(i);
			map.put("text", tibCommonMappingFunc.getFdRefName());
			map.put("value", tibCommonMappingFunc.getFdId());
			rtnList.add(map);
		}
		return rtnList;
	}

	private IBaseModel executeInitModel(IBaseModel model) throws Exception {

		ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) SpringBeanUtil
				.getBean("tibCommonMappingModuleService");
		// 取得webservice 的实现
		ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService = (ITibCommonMappingFuncXmlOperateService) SpringBeanUtil
				.getBean("sapErpEkpFuncXmlOperateService");

		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");

		long cur = System.currentTimeMillis();
		String modelName = ModelUtil.getModelClassName(model);
		// String fdModelTemFieldName = getErpEkpModuleSetting(modelName);
		String fdModelTemFieldName = tibCommonMappingModuleService
				.getFdModelTemFieldName(modelName);
		String fdTemplateId = (String) PropertyUtils.getProperty(model,
				fdModelTemFieldName + ".fdId");// 一般为fdTemplate.fdId
		List<TibCommonMappingFunc> tibCommonMappingFuncList = tibCommonMappingFuncXmlOperateService
				.getFuncList(fdTemplateId, Integer
						.valueOf(Constant.INVOKE_TYPE_FORMSAVE),
						Constant.FD_TYPE_SAP);// 按顺序得到保存事件需要执行的函数列表
		if (tibCommonMappingFuncList == null
				|| tibCommonMappingFuncList.isEmpty())
			return model;// 如果没有函数则返回

		log.debug("end 查找模板 ...花费：" + (System.currentTimeMillis() - cur)
				+ "ms \n 交互sap");
		long cur2 = System.currentTimeMillis();

		FormulaParser formulaParser = FormulaParser.getInstance(model);// 根据model得到公式解析器
		for (int i = 0; i < tibCommonMappingFuncList.size(); i++) {
			TibCommonMappingFunc tibCommonMappingFunc = tibCommonMappingFuncList
					.get(i);
			Document document = DocumentHelper.parseText(tibCommonMappingFunc
					.getFdRfcParamXml());
			tibCommonMappingFuncXmlOperateService.setFuncImportXmlByFormula(
					document, formulaParser);
			tibCommonMappingFuncXmlOperateService.setFuncImportTableByFormula(
					document, formulaParser);
			TibSysSapReturnVo tibSysSapVo = tibSysSapJcoFunctionUtil
					.getXMltoFunction(document.asXML());
			String backXml = (String) tibSysSapVo.getResult();
			if (StringUtil.isNotNull(backXml)) {
				document = DocumentHelper.parseText(backXml);// 将执行函数后返回的xml转化为document对象
				tibCommonMappingFuncXmlOperateService.setFuncExportXml(
						document, model);
				tibCommonMappingFuncXmlOperateService.setFuncExportTable(
						document, model);
				log.debug("模板 交互花费： " + (System.currentTimeMillis() - cur2)
						+ "ms \n 交互sap");
				cur2 = System.currentTimeMillis();
			}
			// ====================modify by
			log.debug("交互后检查异常以及重置字段。。。");
			long cur3 = System.currentTimeMillis();
			// zhangtian=========================================
			// 表单保存事件校验执行模板操作
			if (!checkPass(tibCommonMappingFunc, tibSysSapVo.getReturnType())) {
				if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN
						.equals(tibSysSapVo.getReturnType())) {
					if (PropertyUtils.isWriteable(model, "docStatus")) {
						PropertyUtils.setProperty(model, "docStatus",
								SysDocConstant.DOC_STATUS_DRAFT);
					}
					throw new Exception(ResourceUtil.getString("tibSapMapping.interactiveException", "tib-sap"));
				} else if (TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN
						.equals(tibSysSapVo.getReturnType())) {
					// 抛出业务异常
					if (PropertyUtils.isWriteable(model, "docStatus")) {
						PropertyUtils.setProperty(model, "docStatus",
								SysDocConstant.DOC_STATUS_DRAFT);
					}
					throw new TibSysSapBusinessException(true,
							ResourceUtil.getString("tibSapMapping.busniessException", "tib-sap") + tibCommonMappingFunc.getFdId());
				}
			}
			// ======强制赋值====
			resetFields(model, tibCommonMappingFunc, tibSysSapVo
					.getReturnType());
			log.debug("交互后检查异常以及重置字段。。。花费"
					+ (System.currentTimeMillis() - cur3));
			// ==========================================================================
		}
		return model;
	}

	public IBaseModel addMethodInvoke(IBaseModel model) throws Exception {

		return executeInitModel(model);
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

	private void resetFields(IBaseModel model, TibCommonMappingFunc tmpFucn,
			String returnType) throws Exception {
		ISysMetadataParser sysMetadataParser = (ISysMetadataParser) SpringBeanUtil
				.getBean("sysMetadataParser");

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

					sysMetadataParser.setFieldValue(model, getEkpid(assignId),
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

	public void deleteMethodInvoke(IBaseModel model) throws Exception {

		ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) SpringBeanUtil
				.getBean("tibCommonMappingModuleService");
		// 取得webservice 的实现
		ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService = (ITibCommonMappingFuncXmlOperateService) SpringBeanUtil
				.getBean("webErpEkpWebServiceXmlOperateServiceImp");

		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");

		String modelName = ModelUtil.getModelClassName(model);
		// String fdModelTemFieldName = getErpEkpModuleSetting(modelName);
		String fdModelTemFieldName = tibCommonMappingModuleService
				.getFdModelTemFieldName(modelName);
		String fdTemplateId = (String) PropertyUtils.getProperty(model,
				fdModelTemFieldName + ".fdId");// 一般为fdTemplate.fdId
		List<TibCommonMappingFunc> tibCommonMappingFuncList = tibCommonMappingFuncXmlOperateService
				.getFuncList(fdTemplateId, Integer
						.valueOf(Constant.INVOKE_TYPE_FORMDEL),
						Constant.FD_TYPE_SAP);// 按顺序得到保存事件需要执行的函数列表
		if (tibCommonMappingFuncList == null
				|| tibCommonMappingFuncList.isEmpty())
			return;// 如果没有函数则返回

		try {

			FormulaParser formulaParser = FormulaParser.getInstance(model);// 根据modeldedao公式解析器
			for (int i = 0; i < tibCommonMappingFuncList.size(); i++) {
				TibCommonMappingFunc tibCommonMappingFunc = tibCommonMappingFuncList
						.get(i);
				Document document = DocumentHelper
						.parseText(tibCommonMappingFunc.getFdRfcParamXml());
				tibCommonMappingFuncXmlOperateService
						.setFuncImportXmlByFormula(document, formulaParser);
				tibCommonMappingFuncXmlOperateService
						.setFuncImportTableByFormula(document, formulaParser);

				TibSysSapReturnVo tibSysSapVo = tibSysSapJcoFunctionUtil
						.getXMltoFunction(document.asXML());
				String backXml = (String) tibSysSapVo.getResult();
				// System.out.print(backXml);
				if (StringUtil.isNotNull(backXml)) {
					document = DocumentHelper.parseText(backXml);// 将执行函数后返回的xml转化为document对象
					tibCommonMappingFuncXmlOperateService.setFuncExportXml(
							document, model);
					tibCommonMappingFuncXmlOperateService.setFuncExportTable(
							document, model);
				}
				// 这种方式的调用接下来的操作是什么。。。。。。。。。
				// ==================异常处理================

				if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN
						.equals(tibSysSapVo.getReturnType())) {
					throw new Exception(ResourceUtil.getString("tibSapMapping.delete.interactiveException", "tib-sap"));
				} else if (TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN
						.equals(tibSysSapVo.getReturnType())) {
					throw new TibSysSapBusinessException(
							ResourceUtil.getString("tibSapMapping.delete.busniessException", "tib-sap"));
				}
				// ============================================
			}
		} catch (Exception e) {
			throw e;
		}
	}

	public IBaseModel updateMethodInvoke(IBaseModel model) throws Exception {

		TransactionStatus status = null;
		try {
			if (null == status) {
				status = TransactionUtils.beginNewReadTransaction();
			}
			Object servie = SpringBeanUtil.getBean(model.getSysDictModel()
					.getServiceBean());
			Method method = servie.getClass().getMethod("findByPrimaryKey",
					String.class);
			IBaseModel result = (IBaseModel) method.invoke(servie, model
					.getFdId());
			String docStatus = null;
			if (PropertyUtils.isReadable(result, "docStatus")) {
				docStatus = (String) PropertyUtils.getProperty(result,
						"docStatus");
			}
			TransactionUtils.getTransactionManager().commit(status);
			status = null;
			// ============end
			// ReadTransaction================================================
			// 驳回状态可能存在不驳回到起草节点,===
			if (SysDocConstant.DOC_STATUS_DRAFT.equals(docStatus)
					|| SysDocConstant.DOC_STATUS_REFUSE.equals(docStatus)) {
				executeInitModel(model);
			}
		} finally {
		}
		return model;
	}
}
