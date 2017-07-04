package com.landray.kmss.kms.multidoc.webservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgeKeyword;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.authentication.background.IBackgroundAuthService;
import com.landray.kmss.sys.category.model.SysCategoryProperty;
import com.landray.kmss.sys.metadata.service.ISysMetadataService;
import com.landray.kmss.sys.webservice2.forms.AttachmentForm;
import com.landray.kmss.sys.webservice2.interfaces.ISysWsAttService;
import com.landray.kmss.sys.webservice2.interfaces.ISysWsOrgService;
import com.landray.kmss.sys.webservice2.util.SysWsUtil;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm;
import com.landray.kmss.sys.workflow.webservice.DefaultStartParameter;
import com.landray.kmss.sys.workflow.webservice.WorkFlowParameterInitializer;
import com.landray.kmss.util.Runner;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmsMultidocWebserviceService implements
		IKmsMultidocWebserviceService {

	private static final Log logger = LogFactory
			.getLog(KmsMultidocWebserviceService.class);
	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	private ISysWsAttService sysWsAttService;

	public void setSysWsAttService(ISysWsAttService sysWsAttService) {
		this.sysWsAttService = sysWsAttService;
	}

	private ISysWsOrgService sysWsOrgService;

	public void setSysWsOrgService(ISysWsOrgService sysWsOrgService) {
		this.sysWsOrgService = sysWsOrgService;
	}

	private IBackgroundAuthService backgroundAuthService;

	public void setBackgroundAuthService(
			IBackgroundAuthService backgroundAuthService) {
		this.backgroundAuthService = backgroundAuthService;
	}

	public void sayHello(String username, int point) {

	}

	/**
	 * 启动流程
	 */
	public String addMultidoc(KmsMultidocParamterForm webParamForm)
			throws Exception {

		// 切换当前用户 或者传递来的用户
		// SysOrgElement creator = sysWsOrgService.findSysOrgElement(webForm
		// .getDocCreator());
		// 修改切换用户的方式 @作者：曹映辉 @日期：2012年11月15日
		return (String) backgroundAuthService.switchUserById(webParamForm
				.getDocCreator(), new Runner() {

			public Object run(Object parameter) throws Exception {
				KmsMultidocParamterForm webForm = (KmsMultidocParamterForm) parameter;
				// 初始化表单流程数据
				RequestContext requestContext = getContext(webForm);
				DefaultStartParameter flowParam = getStartParameter(webForm);

				if (logger.isDebugEnabled()) {
					logger.debug("开始kmsMultidoc webService启动流程...");
				}

				// 启动流程
				IExtendForm form = kmsMultidocKnowledgeService.initFormSetting(
						null, requestContext);
				// 设置流程API
				WorkFlowParameterInitializer.initialize((ISysWfMainForm) form,
						flowParam);
				// 附件
				List<AttachmentForm> attForms = webForm.getAttachmentForms();
				sysWsAttService.validateAttSize(attForms); // 校验附件大小

				String modelId = kmsMultidocKnowledgeService.add(form,
						requestContext);

				// 标签
				kmsMultidocKnowledgeService.setTagMain(modelId, webForm
						.getTags());
				// 属性
				List<HashMap> list = new ArrayList<HashMap>();
				for (MyEntry entry : webForm.getPropertyList()) {
					HashMap map = new HashMap();
					map.put("propertyName", entry.getKey());
					map.put("propertyValue", entry.getValue());
					list.add(map);
				}
				kmsMultidocKnowledgeService.setPropertyList(modelId, list);

				String modelName = form.getModelClass().getName();
				sysWsAttService.save(attForms, modelId, modelName);

				if (logger.isDebugEnabled()) {
					logger.debug("kmsMultidoc webService流程启动完毕！");
				}

				return modelId;

			}

		}, webParamForm);

	}

	/**
	 * 初始化主文档及流程表单数据
	 */
	private RequestContext getContext(KmsMultidocParamterForm webForm)
			throws Exception {
		RequestContext requestContext = new RequestContext();
		requestContext.setParameter("fdTemplateId", webForm.getFdTemplateId());

		Map<String, Object> values = new HashMap<String, Object>();
		requestContext.setAttribute(ISysMetadataService.INIT_MODELDATA_KEY,
				values);
		// 默认为发布状态
		if (StringUtil.isNull(webForm.getDocStatus())) {
			webForm.setDocStatus(SysDocConstant.DOC_STATUS_PUBLISH);
		}

		values.put("docStatus", webForm.getDocStatus());
		values.put("docSubject", webForm.getDocSubject());
		values.put("docContent", webForm.getDocContent());
		values.put("docCreator", UserUtil.getUser());

		// 流程表单数据
		String formJson = webForm.getFormValues();
		if (StringUtil.isNotNull(formJson)) {
			Map<String, Object> formMap = SysWsUtil.json2map(formJson);
			values.putAll(formMap);
		}
		// 辅类别
		String docPropJsonStr = webForm.getDocProperty();
		if (StringUtil.isNotNull(docPropJsonStr)) {
			values.put("docProperties", parseDocProperties(docPropJsonStr));
		}
		return requestContext;
	}

	/**
	 * 初始化流程参数
	 * 
	 * @param webForm
	 * @return
	 */
	private DefaultStartParameter getStartParameter(
			KmsMultidocParamterForm webForm) {
		DefaultStartParameter param = new DefaultStartParameter();

		param.setDocStatus(webForm.getDocStatus());
		param.setDrafterId(UserUtil.getUser().getFdId());
		setFlowParam(param, webForm);

		return param;
	}

	/**
	 * 解析文档关键字表达式
	 * 
	 * @param jsonArrStr
	 *            格式为["关键字1", "关键字2"...]
	 * @return
	 */
	private List<KmsMultidocKnowledgeKeyword> parseDocKeywords(String jsonArrStr) {
		JSONArray jsonArr = JSONArray.fromObject(jsonArrStr);
		List<KmsMultidocKnowledgeKeyword> keywordList = new ArrayList<KmsMultidocKnowledgeKeyword>();

		for (Object value : jsonArr) {
			KmsMultidocKnowledgeKeyword docKeyword = new KmsMultidocKnowledgeKeyword();
			docKeyword.setDocKeyword((String) value);
			keywordList.add(docKeyword);
		}

		return keywordList;
	}

	/**
	 * 解析辅类别表达式
	 * 
	 * @param jsonArrStr
	 *            格式为["fdId01", "fdId02"...]
	 * @return
	 */
	private List<SysCategoryProperty> parseDocProperties(String jsonArrStr) {
		JSONArray jsonArr = JSONArray.fromObject(jsonArrStr);
		List<SysCategoryProperty> categoryList = new ArrayList<SysCategoryProperty>();

		for (Object value : jsonArr) {
			SysCategoryProperty category = new SysCategoryProperty();
			category.setFdId((String) value);
			categoryList.add(category);
		}

		return categoryList;
	}

	/**
	 * 解析流程参数的表达式
	 * 
	 * @param jsonArrStr
	 *            格式为{auditNode:"", futureNodeId:"",
	 *            changeNodeHandlers:["节点名1：用户ID1; 用户ID2...",
	 *            "节点名2：用户ID1; 用户ID2..."...]}
	 * @return
	 */
	private void setFlowParam(DefaultStartParameter param,
			KmsMultidocParamterForm webForm) {
		JSONObject jsonObj = JSONObject.fromObject(webForm.getFlowParam());

		if (!jsonObj.isNullObject() && !jsonObj.isEmpty()) {
			Object auditNode = jsonObj.get("auditNode"); // 审批意见
			if (auditNode != null) {
				param.setAuditNode(auditNode.toString());
			}

			Object futureNodeId = jsonObj.get("futureNodeId"); // 人工决策节点
			if (futureNodeId != null) {
				param.setFutureNodeId(futureNodeId.toString());
			}

			Object handlers = jsonObj.get("changeNodeHandlers"); // “必须修改节点处理人”节点
			if (handlers != null) {
				JSONArray jsonArr = JSONArray.fromObject(handlers);
				param.setChangeNodeHandlers(jsonArr);
			}

		}
	}

}
