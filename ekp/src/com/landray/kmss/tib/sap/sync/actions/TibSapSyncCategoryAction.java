package com.landray.kmss.tib.sap.sync.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.exception.ConstraintViolationException;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sap.sync.forms.TibSapSyncCategoryForm;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncCategory;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncCategoryService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;


/**
 * 配置/分类信息 Action
 * 
 * @author 
 * @version 1.0 2011-11-09
 */
public class TibSapSyncCategoryAction extends ExtendAction {
	protected ITibSapSyncCategoryService tibSapSyncCategoryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSapSyncCategoryService == null)
			tibSapSyncCategoryService = (ITibSapSyncCategoryService)getBean("tibSapSyncCategoryService");
		return tibSapSyncCategoryService;
	}
	
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String parentId = request.getParameter("parentId");
		TibSapSyncCategoryForm categoryForm = (TibSapSyncCategoryForm) super
				.createNewForm(mapping, form, request, response);
		if (StringUtil.isNotNull(parentId)) {
			TibSapSyncCategory category = (TibSapSyncCategory) getServiceImp(request)
					.findByPrimaryKey(parentId);
			if (category != null) {
				// 设置父类
				categoryForm.setFdParentId(category.getFdId());
				categoryForm.setFdParentName(category.getFdName());
			}
		}
		return categoryForm;

	}
	
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		String forward = "failure";
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected_Node");
			if (ids != null)
				getServiceImp(request).delete(ids);
		} catch (Exception e) {
			//当分类删除出现错误,设置跳转页面
			messages.addError(e);
			if (e.getCause() instanceof ConstraintViolationException) {
				forward="cateError";
			} else if (e instanceof ConstraintViolationException) {
				forward="cateError";
			}
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError())
			return getActionForward(forward, mapping, form, request, response);
		else
			return getActionForward("tree", mapping, form, request, response);
	}
	
	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-delete", true, getClass());
		KmssMessages messages = new KmssMessages();
		String forward = "failure";
		try {
			if (!request.getMethod().equals("GET"))
				throw new UnexpectedRequestException();
			String id = request.getParameter("fdId");
			if (StringUtil.isNull(id))
				messages.addError(new NoRecordException());
			else
				getServiceImp(request).delete(id);
		} catch (Exception e) {
			//当分类删除出现错误,设置跳转页面
			messages.addError(e);
			if (e.getCause() instanceof ConstraintViolationException) {
				forward="cateError";
			} else if (e instanceof ConstraintViolationException) {
				forward="cateError";
			}
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-delete", false, getClass());
		if (messages.hasError())
			return getActionForward(forward, mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}
	
	public ActionForward saveadd(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-saveadd", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
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
	
}

