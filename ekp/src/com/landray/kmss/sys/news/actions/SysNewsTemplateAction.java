package com.landray.kmss.sys.news.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.news.constant.SysNewsConstant;
import com.landray.kmss.sys.news.forms.SysNewsTemplateForm;
import com.landray.kmss.sys.news.service.ISysNewsTemplateService;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryAction;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌
 */
public class SysNewsTemplateAction extends SysSimpleCategoryAction

{
	protected ISysNewsTemplateService sysNewsTemplateService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (sysNewsTemplateService == null)
			sysNewsTemplateService = (ISysNewsTemplateService) getBean("sysNewsTemplateService");
		return sysNewsTemplateService;
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		SysNewsTemplateForm templateForm = (SysNewsTemplateForm) super
				.createNewForm(mapping, form, request, response);
		templateForm.setFdImportance("3");
		templateForm.setDocContent(null);
		templateForm.setDocKeywordIds(null);
		templateForm.setDocKeywordNames(null);
		templateForm.setFdContentType(SysNewsConstant.FDCONTENTTYPE_RTF);
		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}

		return templateForm;
	}

	// public ActionForward delete(ActionMapping mapping, ActionForm form,
	// HttpServletRequest request, HttpServletResponse response)
	// throws Exception {
	// KmssMessages messages = new KmssMessages();
	// try {
	// if (!request.getMethod().equals("GET"))
	// throw new UnexpectedRequestException();
	// String id = request.getParameter("fdId");
	// if (StringUtil.isNull(id))
	// messages.addError(new NoRecordException());
	// else
	// getServiceImp(request).delete(id);
	// } catch (Exception e) {
	// messages.setHasError();
	// SysNewsTemplate template = (SysNewsTemplate) getServiceImp(request)
	// .findByPrimaryKey(request.getParameter("fdId"));
	// messages
	// .addMsg(new KmssMessage(
	// "sys-news:sysNewsTemplate.delete.tip", template
	// .getFdName()));
	// }
	// KmssReturnPage.getInstance(request).addMessages(messages).addButton(
	// KmssReturnPage.BUTTON_RETURN).save(request);
	// if (messages.hasError())
	// return mapping.findForward("failure");
	// else
	// return mapping.findForward("success");
	// }
	//
	// public ActionForward deleteall(ActionMapping mapping, ActionForm form,
	// HttpServletRequest request, HttpServletResponse response)
	// throws Exception {
	// KmssMessages messages = new KmssMessages();
	// try {
	// if (!request.getMethod().equals("POST"))
	// throw new UnexpectedRequestException();
	// String[] ids = request.getParameterValues("List_Selected");
	// if (ids != null)
	// getServiceImp(request).delete(ids);
	// } catch (Exception e) {
	// messages.setHasError();
	// messages.addMsg(new KmssMessage(
	// "sys-news:sysNewsTemplate.deleteall.tip"));
	// }
	// KmssReturnPage.getInstance(request).addMessages(messages).addButton(
	// KmssReturnPage.BUTTON_RETURN).save(request);
	// if (messages.hasError())
	// return mapping.findForward("failure");
	// else
	// return mapping.findForward("success");
	// }

	protected String getParentProperty() {
		return "hbmParent";
	}

}
