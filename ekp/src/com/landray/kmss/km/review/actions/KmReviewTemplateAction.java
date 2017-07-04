package com.landray.kmss.km.review.actions;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.actions.TemplateNodeAction;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.service.ICoreOuterService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.km.review.forms.KmReviewTemplateForm;
import com.landray.kmss.km.review.model.KmReviewTemplate;
import com.landray.kmss.km.review.service.IKmReviewTemplateService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;
import com.landray.kmss.sys.number.forms.SysNumberMainMappForm;
import com.landray.kmss.sys.number.model.SysNumberMainMapp;
import com.landray.kmss.sys.number.service.ISysNumberMainMappService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌
 */
public class KmReviewTemplateAction extends TemplateNodeAction

{
	protected IKmReviewTemplateService kmReviewTemplateService;

	private ISysCategoryMainService categoryMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmReviewTemplateService == null)
			kmReviewTemplateService = (IKmReviewTemplateService) getBean("kmReviewTemplateService");
		return kmReviewTemplateService;
	}

	private ICoreOuterService dispatchCoreService;

	protected ICoreOuterService getDispatchCoreService() {
		if (dispatchCoreService == null) {
			dispatchCoreService = (ICoreOuterService) getBean("dispatchCoreService");
		}
		return dispatchCoreService;
	}

	protected ISysNumberMainMappService sysNumberMainMappService;

	protected ISysNumberMainMappService getSysNumberMainMappImp() {
		if (sysNumberMainMappService == null)
			sysNumberMainMappService = (ISysNumberMainMappService) getBean("sysNumberMainMappService");
		return sysNumberMainMappService;
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		super.createNewForm(mapping, form, request, response);
		KmReviewTemplateForm templateForm = (KmReviewTemplateForm) form;
		templateForm.setFdLableVisiable("true");
		templateForm.setDocCreatorName(UserUtil.getUser().getFdName());
		templateForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
				DateUtil.TYPE_DATETIME, request.getLocale()));
		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}

		String docCategoryId = request.getParameter("parentId");
		if (StringUtil.isNotNull(docCategoryId)) {
			SysCategoryMain sysCategoryMain = (SysCategoryMain) getTreeServiceImp(
					request).findByPrimaryKey(docCategoryId);
			if (UserUtil.checkAuthentication(
					"/km/review/km_review_template/kmReviewTemplate.do?method=save&fdCategoryId="
							+ docCategoryId, "post")) {
				templateForm.setFdCategoryId(docCategoryId);
				templateForm.setFdCategoryName(sysCategoryMain.getFdName());
			} else {
				request.setAttribute("noAccessCategory", sysCategoryMain
						.getFdName());
			}
		}
		return templateForm;
	}

	/**
	 * 根据http请求，获取model，将model转化为form并返回。<br>
	 * URL中必须包含fdId参数，该参数为记录id。<br>
	 * 若获取model不成功，则抛出errors.norecord的错误信息。
	 * 
	 * @param form
	 * @param request
	 * @return form对象
	 * @throws Exception
	 */
	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		KmReviewTemplateForm rtnForm = null;
		String id = request.getParameter("fdId");
		if (!StringUtil.isNull(id)) {
			KmReviewTemplate model = (KmReviewTemplate) getServiceImp(request)
					.findByPrimaryKey(id, null, true);
			if (model != null) {
				rtnForm = (KmReviewTemplateForm) getServiceImp(request)
						.convertModelToForm((IExtendForm) form, model,
								new RequestContext(request));
				rtnForm.setFdCategoryName(getFdCategoryName(model
						.getDocCategory()));
			}
		}
		if (rtnForm == null)
			throw new NoRecordException();
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}

	private String getFdCategoryName(SysCategoryMain sysCategoryMain) {
		String fdCategoryName = sysCategoryMain.getFdName();
		SysCategoryMain fdParent = (SysCategoryMain) sysCategoryMain
				.getFdParent();
		if (fdParent != null) {
			do {
				fdCategoryName = fdParent.getFdName() + "/" + fdCategoryName;
				fdParent = (SysCategoryMain) fdParent.getFdParent();
			} while (fdParent != null);
		}
		return fdCategoryName;
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("GET"))
				throw new UnexpectedRequestException();
			String id = request.getParameter("fdId");
			if (StringUtil.isNull(id))
				messages.addError(new NoRecordException());
			else
				getServiceImp(request).delete(id);
		} catch (Exception e) {
			messages.setHasError();
			KmReviewTemplate template = (KmReviewTemplate) getServiceImp(
					request).findByPrimaryKey(request.getParameter("fdId"));
			messages.addMsg(new KmssMessage(
					"km-review:kmReviewTemplate.delete.tip", template
							.getFdName()));
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		if (messages.hasError())
			return mapping.findForward("failure");
		else
			return mapping.findForward("success");
	}

	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
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
			messages.setHasError();
			messages.addMsg(new KmssMessage(
					"km-review:kmReviewTemplate.deleteall.tip"));
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		if (messages.hasError())
			return mapping.findForward("failure");
		else
			return mapping.findForward("success");
	}

	protected String getParentProperty() {
		return "docCategory";
	}

	protected IBaseService getTreeServiceImp(HttpServletRequest request) {
		if (categoryMainService == null)
			categoryMainService = (ISysCategoryMainService) getBean("sysCategoryMainService");
		return categoryMainService;
	}

	@Override
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			getServiceImp(request).update((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-update", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return getActionForward("edit", mapping, form, request, response);
		} else {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_RETURN).addButton(
							KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}

	@Override
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		String id = null;
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			
			//外部流程模板
			if(((KmReviewTemplateForm)form).getFdIsExternal().equals("true")){
				((KmReviewTemplateForm)form).getSysNumberMainMappForm().setFdMainModelName(null);
			}
			id = getServiceImp(request).add((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-save", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return getActionForward("edit", mapping, form, request, response);
		} else {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(
							"button.back",
							"/km/review/km_review_template/kmReviewTemplate.do?method=edit&fdId="
									+ id, false).addButton(
							KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}
	
	public ActionForward saveadd(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-saveadd", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			
			//外部流程模板
			if(((KmReviewTemplateForm)form).getFdIsExternal().equals("true")){
				((KmReviewTemplateForm)form).getSysNumberMainMappForm().setFdMainModelName(null);
			}
			getServiceImp(request).add((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-saveadd", false, getClass());
		KmssReturnPage.getInstance(request).addMessages(messages).save(request);
		if (messages.hasError())
			return getActionForward("edit", mapping, form, request, response);
		else
			return add(mapping, form, request, response);
	}


	public ActionForward clone(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-clone", true, getClass());
		KmssMessages messages = new KmssMessages();

		try {
			String cloneModelId = request.getParameter("cloneModelId");
			KmReviewTemplateForm newForm = (KmReviewTemplateForm) createNewForm(
					mapping, form, request, response);
			IBaseModel cloneModel = getServiceImp(request).findByPrimaryKey(
					cloneModelId);
			RequestContext requestContext = new RequestContext(request);
			newForm = (KmReviewTemplateForm) getServiceImp(request)
					.cloneModelToForm(newForm, cloneModel, requestContext);
			request.setAttribute("isCloneAction", "true");
			// 获取模板对应编号机制的相关信息
			SysNumberMainMapp mapp = (SysNumberMainMapp) getSysNumberMainMappImp()
					.getSysNumberMainMapp(
							"com.landray.kmss.km.review.model.KmReviewMain",
							cloneModelId);
			if (mapp != null) {
				SysNumberMainMappForm mappForm = newForm
						.getSysNumberMainMappForm();
				if (mappForm != null) {
					mappForm.setFdType(mapp.getFdType());
					mappForm.setFdContent(mapp.getFdContent());
					mappForm.setFdFlowContent(mapp.getFdFlowContent());
					mappForm.setFdNumberId(mapp.getFdNumber() == null ? ""
							: mapp.getFdNumber().getFdId());
				}
			}
			if (newForm != form)
				request.setAttribute(getFormName(newForm, request), newForm);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-clone", false, getClass());

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("edit", mapping, form, request, response);
		}
	}
	protected String getFindPageOrderBy(HttpServletRequest request,String curOrderBy) throws Exception {
		if (curOrderBy == null) {
			curOrderBy = "kmReviewTemplate.fdOrder,kmReviewTemplate.fdId";
		}
		return curOrderBy;
	}
	
}
