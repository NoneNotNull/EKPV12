package com.landray.kmss.kms.knowledge.actions;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionRedirect;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeBaseDocForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService;
import com.landray.kmss.sys.attachment.util.SysAttUtil;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.doc.actions.SysDocBaseInfoAction;
import com.landray.kmss.sys.metadata.service.ISysMetadataService;
import com.landray.kmss.sys.organization.interfaces.ISysOrgCoreService;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.property.service.ISysPropertyFilterService;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 文档基本信息 Action
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeBaseDocAction extends SysDocBaseInfoAction {

	protected IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		return getServiceImp();
	}

	/**
	 * 用于区分子类
	 * 
	 * @return
	 */
	private IKmsKnowledgeBaseDocService getServiceImp() {
		if (kmsKnowledgeBaseDocService == null)
			kmsKnowledgeBaseDocService = (IKmsKnowledgeBaseDocService) getBean("kmsKnowledgeBaseDocService");
		return kmsKnowledgeBaseDocService;
	}

	protected String getParentProperty() {
		return "docCategory";
	}

	/**
	 * 打开阅读页面。<br>
	 * URL中必须包含fdId参数，该参数为记录id。<br>
	 * 该操作一般以HTTP的GET方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回view页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String fdKnowledgeType = request.getParameter("fdKnowledgeType");
		String modelName = KmsKnowledgeConstantUtil
				.getTemplateModelName(fdKnowledgeType);
		String fdId = request.getParameter("fdId");
		ActionForward actionForward = new ActionForward();
		actionForward.setRedirect(true);
		actionForward.setPath(getDocUrl(request, fdId, modelName));
		return actionForward;
	}

	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		String id = request.getParameter("fdId");
		String[] ids = id.split(",");
		if (ids.length > 1) {
			id = ids[0];
		}
		if (!StringUtil.isNull(id)) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(id,
					null, true);
			if (model != null)
				rtnForm = getServiceImp(request).convertModelToForm(
						(IExtendForm) form, model, new RequestContext(request));
		}
		if (rtnForm == null)
			throw new NoRecordException();
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	protected void loadPropertyForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		String id = request.getParameter("fdId");
		String[] ids = id.split(",");
		if (ids.length > 1) {
			id = ids[0];
		}
		if (!StringUtil.isNull(id)) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(id,
					null, true);
			if (model != null) {
				((ISysMetadataService) SpringBeanUtil
						.getBean("sysMetadataService")).convertModelToForm(
						(IExtendForm) form, model, new RequestContext(request));
				rtnForm = (IExtendForm) form;
			}
		}
		if (rtnForm == null)
			throw new NoRecordException();
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	/**
	 * 获取文档url
	 * 
	 * @Override
	 */
	public String getDocUrl(HttpServletRequest request, String docId,
			String modelName) {
		try {
			BaseModel mainModel = (BaseModel) getServiceImp(null).getBaseDao()
					.getHibernateSession().get(modelName, docId);
			String modelUrl = ModelUtil.getModelUrl(mainModel);
			if (modelUrl.contains("type=edition")) {
				modelUrl = modelUrl.substring(0, modelUrl.indexOf("type") - 1);
			}
			String forward = request.getParameter("forward");
			if (StringUtil.isNotNull(forward)) {
				String _forward = "forward";
				if (modelUrl.indexOf("?") > 0)
					_forward = "&" + _forward;
				else
					_forward = "?" + _forward;
				modelUrl += (_forward + "=" + forward);
			}

			return modelUrl;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public IKmsKnowledgeCategoryService getCategoryServiceImp() {
		return ((IKmsKnowledgeBaseDocService) getServiceImp())
				.getCategoryServiceImp();
	}

	public ISysSimpleCategoryService getSysSimpleCategoryService() {
		return (ISysSimpleCategoryService) getCategoryServiceImp();
	}

	public ActionForward editProperty(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String fdId = request.getParameter("fdId");
			String[] ids = fdId.split(",");
			loadPropertyForm(mapping, form, request, response);
			KmsKnowledgeBaseDocForm knowledgeForm = ((KmsKnowledgeBaseDocForm) form);
			knowledgeForm.setMethod_GET("edit");
			knowledgeForm.setIdList(fdId);
			if (ids.length > 1) {
				Map<String, Object> newValueMap = knowledgeForm
						.getExtendDataFormInfo().getFormData();
				Object[] obKey = newValueMap.keySet().toArray();
				int length = obKey.length;
				String[] extendModelKeyItem = new String[length];
				System.arraycopy(obKey, 0, extendModelKeyItem, 0, length);
				for (String item : extendModelKeyItem) {
					knowledgeForm.getExtendDataFormInfo().setValue(item, "");
				}
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		((KmsKnowledgeBaseDocForm) form).setMethod_GET("edit");
		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("editProperty", mapping, form, request,
					response);
		}
	}

	/**
	 * 批量更新属性
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward updateProperty(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		response.setContentType("application/jsonp");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		KmssMessages messages = new KmssMessages();
		try {
			getServiceImp().updateProperty((IExtendForm) form,
					new RequestContext(request));
			JSONObject json = new JSONObject();
			json.element("flag", true);
			out.println(json.toString(1));
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			response.sendError(505);
			out.println(messages);
			return null;
		} else {
			return null;
		}
	}

	@Override
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		JSONObject jsonData = new JSONObject();
		String successForward = request.getParameter("successForward");
		successForward = StringUtil.isNotNull(successForward) ? successForward
				: "success";// lui-source
		String failureForward = request.getParameter("failureForward");
		failureForward = StringUtil.isNotNull(failureForward) ? failureForward
				: "failure";// lui-failure
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");

			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(ids,
						request, "method=delete&fdId=${id}");
				int noAuthIdNum = ids.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					getServiceImp(request).delete(authIds);
			} else if (ids != null) {
				getServiceImp(request).delete(ids);
			}

		} catch (Exception e) {
			if ("{kms-wiki:kmsWikiMain.error.deleteVersion.hasNew}".equals(e
					.getMessage())
					|| "{kms-wiki:kmsWikiMain.error.deleteVersion.lock}"
							.equals(e.getMessage())
					|| "{sys-edition:error.deletelockeddoc}".equals(e
							.getMessage()))
				jsonData.put("errorMessage",
						ResourceUtil.getMessage(e.getMessage()));

			else
				messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError()) {
			return getActionForward(failureForward, mapping, form, request,
					response);
		} else {
			jsonData.put("flag", true);
			request.setAttribute("lui-source", jsonData);
			return getActionForward(successForward, mapping, form, request,
					response);
		}
	}

	// pda统一筛选
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		if (StringUtil.isNull(hqlInfo.getModelName()))
			hqlInfo.setModelName("com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc");
		String[] filterIds = request.getParameterValues("filterSetting");
		if (filterIds != null && filterIds.length > 0) {
			JSONArray jsonArray = new JSONArray();
			for (String filterId : filterIds) {
				JSONObject jsonObject = JSONObject.fromObject(filterId);
				jsonArray.element(jsonObject);
			}
			if (jsonArray.size() > 0) {
				JSONArray jsonArr = jsonArray;
				request.setAttribute("filterIds", jsonArr.toString());
			}
		} else
			request.setAttribute("filterIds", "");
		String parentId = request.getParameter("categoryId");

		// 带筛选过滤条件，有分类模板
		if (StringUtil.isNotNull(parentId)) {
			KmsKnowledgeCategory knowledgeCategory = (KmsKnowledgeCategory) getCategoryServiceImp()
					.findByPrimaryKey(parentId);
			if (knowledgeCategory.getSysPropertyTemplate() != null) {
				List<?> temps = getCategoryServiceImp().getAllChildCategory(
						knowledgeCategory);
				List<String> idLists = new ArrayList<String>();
				for (int i = 0; i < temps.size(); i++) {
					KmsKnowledgeCategory category = (KmsKnowledgeCategory) temps
							.get(i);
					if (category.getSysPropertyTemplate() != null) {
						idLists.add(category.getSysPropertyTemplate().getFdId());
					}
				}
				getSysPropertyFilterService().filterHQLInfo(
						knowledgeCategory.getSysPropertyTemplate(),
						new RequestContext(request), hqlInfo, idLists);
			}
		}
		buildStatusWhereBlock(request, hqlInfo);
	}

	/**
	 * 带状态查询
	 * 
	 * @param request
	 * @param hqlInfo
	 */
	protected void buildStatusWhereBlock(HttpServletRequest request,
			HQLInfo hqlInfo) {
		String statusBlock = "";
		String status = request.getParameter("status");
		String whereBlock = hqlInfo.getWhereBlock();
		if (StringUtil.isNotNull(status) && !status.equals("all")) {
			statusBlock = ModelUtil.getModelTableName(getServiceImp(request)
					.getModelName()) + ".docStatus=:docStatus ";
			hqlInfo.setParameter("docStatus", status);
			hqlInfo.setWhereBlock(StringUtil.linkString(whereBlock, " and ",
					statusBlock));
		} else {
			if (StringUtil.isNotNull(whereBlock)) {
				whereBlock += " and  kmsKnowledgeBaseDoc.docIsNewVersion=1 ";
			} else {
				whereBlock = " kmsKnowledgeBaseDoc.docIsNewVersion=1 ";
			}
			hqlInfo.setWhereBlock(whereBlock
					+ " and kmsKnowledgeBaseDoc.docStatus!='50'");
		}
	}

	protected ISysPropertyFilterService sysPropertyFilterService;

	protected ISysPropertyFilterService getSysPropertyFilterService() {
		if (sysPropertyFilterService == null)
			sysPropertyFilterService = (ISysPropertyFilterService) getBean("sysPropertyFilterService");
		return sysPropertyFilterService;
	}

	public ActionForward loadAuthodInfo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-loadAuthodInfo", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String id = request.getParameter("fdId");
			if (StringUtil.isNotNull(id)) {
				JSONObject rtnJson = new JSONObject();
				ISysOrgCoreService service = (ISysOrgCoreService) SpringBeanUtil
						.getBean("sysOrgCoreService");
				SysOrgPerson authod = (SysOrgPerson) service.findByPrimaryKey(
						id, SysOrgPerson.class);
				if (authod != null) {
					String[] postInfo = ArrayUtil.joinProperty(
							authod.getFdPosts(), "fdId:fdName", ";");
					rtnJson.put("postsIds", postInfo[0]);
					rtnJson.put("postsNames", postInfo[1]);
					rtnJson.put("depId", authod.getFdParent() != null ? authod
							.getFdParent().getFdId().toString() : "");
					rtnJson.put("depName",
							authod.getFdParent() != null ? authod.getFdParent()
									.getFdName() : "");
					request.setAttribute("lui-source", rtnJson);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-loadAuthodInfo", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("lui-source", mapping, form, request,
					response);
	}

	/**
	 * 批量回收
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward recycleall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-recycleall", true, getClass());
		KmssMessages messages = new KmssMessages();
		JSONObject jsonData = new JSONObject();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");

			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(ids,
						request, "method=recycle&fdId=${id}");
				int noAuthIdNum = ids.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					((IKmsKnowledgeBaseService) getServiceImp(request))
							.updateRecycle(authIds);
			} else if (ids != null) {
				((IKmsKnowledgeBaseService) getServiceImp(request))
						.updateRecycle(ids);
			}
		} catch (Exception e) {
			if ("{kms-wiki:kmsWikiMain.error.deleteVersion.hasNew}".equals(e
					.getMessage())
					|| "{kms-wiki:kmsWikiMain.error.deleteVersion.lock}"
							.equals(e.getMessage())
					|| "{sys-edition:error.deletelockeddoc}".equals(e
							.getMessage()))
				jsonData.put("errorMessage",
						ResourceUtil.getMessage(e.getMessage()));
			else
				messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-recycleall", false, getClass());
		if (messages.hasError())
			return getActionForward("lui-failure", mapping, form, request,
					response);
		else {
			jsonData.put("flag", true);
			request.setAttribute("lui-source", jsonData);
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}

	/**
	 * 批量恢复
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward recoverall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-recoverall", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");
			String description = request.getParameter("reason");
			if (ISysAuthConstant.IS_AREA_ENABLED) {
				String[] authIds = SysAuthAreaUtils.removeNoAuthIds(ids,
						request, "method=recover&fdId=${id}");
				int noAuthIdNum = ids.length - authIds.length;
				if (noAuthIdNum > 0) {
					messages.addMsg(new KmssMessage(
							"sys-authorization:area.batch.operation.info",
							noAuthIdNum));
				}

				if (!ArrayUtils.isEmpty(authIds))
					getServiceImp().updateRecover(authIds, description);
			} else if (ids != null) {
				getServiceImp().updateRecover(ids, description);
			}
		} catch (Exception e) {
			messages.addError(e);
		}   

		KmssReturnPage.getInstance(request).addMessages(messages)
				.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-recoverall", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	@SuppressWarnings("unchecked")
	public ActionForward docThumb(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-docThumb", true, getClass());
		KmssMessages messages = new KmssMessages();
		String imgAttUrl = "";
		String fdId = request.getParameter("fdId");
		String type = request.getParameter("knowledgeType");
		String modelName = KmsKnowledgeConstantUtil.getTemplateModelName(type);
		try {
			if (StringUtil.isNotNull(fdId)) {
				SysAttMain attmain = null;
				ISysAttMainCoreInnerService sysAttMainCoreInnerService = (ISysAttMainCoreInnerService) SpringBeanUtil
						.getBean("sysAttMainService");
				List<SysAttMain> attMainList = sysAttMainCoreInnerService
						.findByModelKey(modelName, fdId, "spic");
				// 如果上传了封面图片
				if (attMainList.size() > 0) {
					attmain = attMainList.get(0);
					imgAttUrl = "/sys/attachment/sys_att_main/sysAttMain.do?method=view&filekey=image2thumbnail_s1&fdId="
							+ attmain.getFdId();
				} else {
					List<SysAttMain> attachments = sysAttMainCoreInnerService
							.findByModelKey(modelName, fdId, "attachment");
					// 如果有上传附件
					if (attachments.size() > 0) {
						attmain = attachments.get(0);
						imgAttUrl = KmsKnowledgeUtil
								.getThumbUrlByAttMain(attmain);
					}
				}

			}
			if (StringUtil.isNull(imgAttUrl)) {
				String style = "default";
				String img = "default.png";
				imgAttUrl = "/resource/style/" + style + "/attachment/" + img;
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-docThumb", false, getClass());
		ActionRedirect redirect = new ActionRedirect(imgAttUrl);
		return redirect;
	}
	
	public ActionForward viewOfLearn(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String fdKnowledgeType = request.getParameter("fdKnowledgeType");
		String modelName = KmsKnowledgeConstantUtil
				.getTemplateModelName(fdKnowledgeType);
		String fdId = request.getParameter("fdId");
		ActionForward actionForward = new ActionForward();
		actionForward.setRedirect(true);
		String fdUrl=getDocUrl(request, fdId, modelName);
		fdUrl=fdUrl.replace("method=view", "method=viewOfLearn");
		actionForward.setPath(fdUrl);
		return actionForward;
	}
	
	public ActionForward viewOfLearnOnMobile(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String fdKnowledgeType = request.getParameter("fdKnowledgeType");
		String fdContentId=request.getParameter("fdContentId");
		String fdStatus=request.getParameter("fdStatus");
		String modelName = KmsKnowledgeConstantUtil
				.getTemplateModelName(fdKnowledgeType);
		String fdId = request.getParameter("fdId");
		ActionForward actionForward = new ActionForward();
		actionForward.setRedirect(true);
		String fdUrl=getDocUrl(request, fdId, modelName);
		
		BaseModel mainModel = (BaseModel) getServiceImp(null).getBaseDao()
		.getHibernateSession().get(modelName, fdId);
			fdUrl = ModelUtil.getModelUrl(mainModel);
			if (fdUrl.contains("type=edition")) {
				fdUrl = fdUrl.substring(0, fdUrl.indexOf("type") - 1);
			}
			String forward = request.getParameter("forward");
			if (StringUtil.isNotNull(forward)) {
				String _forward = "forward";
				if (fdUrl.indexOf("?") > 0)
					_forward = "&" + _forward;
				else
					_forward = "?" + _forward;
				fdUrl += (_forward + "=" + forward);
			}
		
		fdUrl=fdUrl.replace("method=view", "method=viewOfLearnOnMobile");
		fdUrl=fdUrl+"&fdStatus="+fdStatus+"&fdContentId="+fdContentId;
		actionForward.setPath(fdUrl);
		return actionForward;
	}


}
