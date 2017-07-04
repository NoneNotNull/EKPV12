package com.landray.kmss.km.review.webservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.review.model.KmReviewDocKeyword;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.km.review.model.KmReviewTemplate;
import com.landray.kmss.km.review.service.IKmReviewMainService;
import com.landray.kmss.sys.authentication.background.IBackgroundAuthService;
import com.landray.kmss.sys.category.model.SysCategoryProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.sys.metadata.service.ISysMetadataService;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.webservice2.forms.AttachmentForm;
import com.landray.kmss.sys.webservice2.interfaces.ISysWsAttService;
import com.landray.kmss.sys.webservice2.interfaces.ISysWsOrgService;
import com.landray.kmss.sys.webservice2.util.SysWsUtil;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm;
import com.landray.kmss.sys.workflow.webservice.DefaultStartParameter;
import com.landray.kmss.sys.workflow.webservice.WorkFlowParameterInitializer;
import com.landray.kmss.sys.xform.base.service.ISysFormTemplateService;
import com.landray.kmss.util.Runner;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmReviewWebserviceServiceImp implements IKmReviewWebserviceService {

	private static final Log logger = LogFactory
			.getLog(KmReviewWebserviceServiceImp.class);

	private IKmReviewMainService kmReviewMainService;

	public void setKmReviewMainService(IKmReviewMainService kmReviewMainService) {
		this.kmReviewMainService = kmReviewMainService;
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

	/**
	 * 启动流程
	 */
	public String addReview(KmReviewParamterForm webParamForm) throws Exception {

		// 切换当前用户
		SysOrgElement creator = sysWsOrgService.findSysOrgElement(webParamForm
				.getDocCreator());
		// 修改切换用户的方法 @作者：曹映辉 @日期：2012年11月15日
		return (String) backgroundAuthService.switchUserById(creator.getFdId(),
				new Runner() {

					public Object run(Object parameter) throws Exception {
						KmReviewParamterForm webForm = (KmReviewParamterForm) parameter;
						
						// modify #4344 增加对组织架构类型json参数的支持 #曹映辉 2014.8.22
						//根据模板id 加载数据字典
						// DictLoadService
						// loader=(DictLoadService)SpringBeanUtil.getBean("sysFormDictLoadService");
						ISysMetadataParser sysMetadataParser = (ISysMetadataParser) SpringBeanUtil
								.getBean("sysMetadataParser");

						ISysFormTemplateService sysFormTemplateService = (ISysFormTemplateService) SpringBeanUtil
								.getBean("sysFormTemplateService");
						HQLInfo hql=new HQLInfo();
						hql.setSelectBlock("fdFormFileName");
						hql.setWhereBlock("fdModelId=:fdModelId and fdModelName=:fdModelName");
						hql.setParameter("fdModelId", webForm.getFdTemplateId());
						hql.setParameter("fdModelName",  KmReviewTemplate.class.getName());
		
						List<String> values = sysFormTemplateService
								.findValue(hql);
						KmReviewMain km=new KmReviewMain();
						km.setExtendFilePath(values.get(0));
						
						SysDictModel dict = sysMetadataParser.getDictModel(km);

						// 初始化表单流程数据
						RequestContext requestContext = getContext(webForm,dict);
						DefaultStartParameter flowParam = getStartParameter(webForm);

						if (logger.isDebugEnabled()) {
							logger.debug("开始启动流程...");
						}

						// 启动流程
						IExtendForm form = kmReviewMainService.initFormSetting(
								null, requestContext);
						// 设置流程API
						WorkFlowParameterInitializer.initialize(
								(ISysWfMainForm) form, flowParam);

						List<AttachmentForm> attForms = webForm
								.getAttachmentForms();
						sysWsAttService.validateAttSize(attForms); // 校验附件大小

						String modelId = kmReviewMainService.add(form,
								requestContext);
						String modelName = form.getModelClass().getName();
						sysWsAttService.save(attForms, modelId, modelName);

						if (logger.isDebugEnabled()) {
							logger.debug("流程启动完毕！");
						}

						return modelId;
					}

				}, webParamForm);

	}

	/**
	 * 初始化主文档及流程表单数据
	 */
	private RequestContext getContext(KmReviewParamterForm webForm,SysDictModel dict)
			throws Exception {
		RequestContext requestContext = new RequestContext();
		requestContext.setParameter("fdTemplateId", webForm.getFdTemplateId());

		Map<String, Object> values = new HashMap<String, Object>();
		requestContext.setAttribute(ISysMetadataService.INIT_MODELDATA_KEY,
				values);
		// 默认为待审状态
		if (StringUtil.isNull(webForm.getDocStatus())) {
			webForm.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
		}

		values.put("docStatus", webForm.getDocStatus());
		values.put("docSubject", webForm.getDocSubject());
		values.put("docContent", webForm.getDocContent());
		values.put("docCreator", UserUtil.getUser());

		// 流程表单数据
		String formJson = webForm.getFormValues();
		if (StringUtil.isNotNull(formJson)) {
			Map<String, Object> formMap = SysWsUtil.json2map(formJson,dict);
			values.putAll(formMap);
		}
		// 文档关键字
		String keywordJsonStr = webForm.getFdKeyword();
		if (StringUtil.isNotNull(keywordJsonStr)) {
			values.put("docKeyword", parseDocKeywords(keywordJsonStr));
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
	private DefaultStartParameter getStartParameter(KmReviewParamterForm webForm) {
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
	private List<KmReviewDocKeyword> parseDocKeywords(String jsonArrStr) {
		JSONArray jsonArr = JSONArray.fromObject(jsonArrStr);
		List<KmReviewDocKeyword> keywordList = new ArrayList<KmReviewDocKeyword>();

		for (Object value : jsonArr) {
			KmReviewDocKeyword docKeyword = new KmReviewDocKeyword();
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
			KmReviewParamterForm webForm) {
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
