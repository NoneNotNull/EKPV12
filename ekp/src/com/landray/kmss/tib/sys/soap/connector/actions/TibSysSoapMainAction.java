package com.landray.kmss.tib.sys.soap.connector.actions;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapMainForm;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * WEBSERVCIE服务函数 Action
 * 
 * @author
 * @version 1.0 2012-08-06
 */
public class TibSysSoapMainAction extends ExtendAction {
	
	protected ITibSysSoapMainService TibSysSoapMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (TibSysSoapMainService == null)
			TibSysSoapMainService = (ITibSysSoapMainService) getBean("tibSysSoapMainService");
		return TibSysSoapMainService;
	}

	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TibSysSoapMainForm tibSysSoapMainForm = (TibSysSoapMainForm) form;
		String tempCategoryId = tibSysSoapMainForm.getDocCategoryId();
		tibSysSoapMainForm.reset(mapping, request);
		String categoryId = StringUtil.isNotNull(tempCategoryId) ? tempCategoryId : request.getParameter("categoryId");
		tibSysSoapMainForm.setDocCreatorId(UserUtil.getKMSSUser().getUserId());
		tibSysSoapMainForm.setDocCreatorName(UserUtil.getKMSSUser()
				.getUserName());
		tibSysSoapMainForm.setDocCreateTime(DateUtil.convertDateToString(
				new Date(), "yyyy-MM-dd HH:mm:ss", request.getLocale()));
		ITibSysSoapCategoryService TibSysSoapCategoryService = (ITibSysSoapCategoryService) SpringBeanUtil
				.getBean("tibSysSoapCategoryService");
		if (StringUtil.isNotNull(categoryId)) {
			TibSysSoapCategory TibSysSoapCategory = (TibSysSoapCategory) TibSysSoapCategoryService
					.findByPrimaryKey(categoryId);
			tibSysSoapMainForm.setDocCategoryId(categoryId);
			tibSysSoapMainForm.setDocCategoryName(TibSysSoapCategory.getFdName());
		}

		return tibSysSoapMainForm;
	}

	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		String hql=hqlInfo.getWhereBlock();
		hql=StringUtil.linkString(hql, " and ", "tibSysSoapMain.docIsNewVersion = :docIsNewVersion");
		hqlInfo.setParameter("docIsNewVersion", true);
		if(!StringUtil.isNull(categoryId)){
			hql=StringUtil.linkString(hql, " and ", "tibSysSoapMain.docCategory.fdHierarchyId like :fdHierarchyId ");
			hqlInfo.setParameter("fdHierarchyId", "%"+categoryId+"%");
		}
		hqlInfo.setWhereBlock(hql);
		
		
		
	}

	/**
	 * 生成新版本 该操作一般以HTTP的GET方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回edit页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward newEdition(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String originId = request.getParameter("originId");
			if (StringUtil.isNull(originId))
				throw new NoRecordException();
			TibSysSoapMainForm TibSysSoapMainForm = (TibSysSoapMainForm) form;
			TibSysSoapMain TibSysSoapMain = (TibSysSoapMain) getServiceImp(request)
					.findByPrimaryKey(originId);
			TibSysSoapMainForm mainForm = new TibSysSoapMainForm();
			mainForm = (TibSysSoapMainForm) getServiceImp(request)
					.cloneModelToForm(TibSysSoapMainForm, TibSysSoapMain,
							new RequestContext(request));
			mainForm.setMethod("add");
			mainForm.setMethod_GET("add");
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return mapping.findForward("edit");
		}
	}

	public ActionForward viewQueryEdit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-viewQueryEdit", true, getClass());
		KmssMessages messages = new KmssMessages();
		String funcId = request.getParameter("funcId");
		
		ITibSysSoapMainService TibSysSoapMainService=(ITibSysSoapMainService)SpringBeanUtil.getBean("tibSysSoapMainService");
		TibSysSoapMain TibSysSoapMain=(TibSysSoapMain) TibSysSoapMainService.findByPrimaryKey(funcId);
		String idXml=TibSysSoapMain.getWsMapperTemplate();
		// 移除禁用的节点
		idXml = ParseSoapXmlUtil.disableFilter(idXml);
		request.setAttribute("tibSysSoapMainId", funcId);
		request.setAttribute("tibSysSoapMainName", TibSysSoapMain.getDocSubject());
		request.setAttribute("idXml", idXml);

		TimeCounter.logCurrentTime("Action-viewQueryEdit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("viewQuery", mapping, form, request,
					response);
		}
	}
	
	/**
	 * 重写save方法，为了添加返回按钮
	 */
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			getServiceImp(request).add((IExtendForm) form,
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
			KmssReturnPage.getInstance(request).addMessages(messages).addButton(
					"button.back",
					"tibSysSoapMain.do?method=edit&fdId="
							+ ((IExtendForm) form).getFdId(), false)
					.addButton(KmssReturnPage.BUTTON_CLOSE)
					.save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}
	
	/**
	 * 实现编辑后还可以返回编辑
	 */
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
			KmssReturnPage.getInstance(request).addMessages(messages).addButton(
					"button.back",
					"tibSysSoapMain.do?method=edit&fdId="
							+ ((IExtendForm) form).getFdId(), false)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}
	
	/**
	 * 主要用于之前保存时可用的webservice服务，当再次编辑时已经不可用了，则给出错误提示
	 */
	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			loadActionForm(mapping, form, request, response);
			TibSysSoapMainForm mainForm = (TibSysSoapMainForm)form;
			ITibSysSoapSettingService TibSysSoapSettingService = (ITibSysSoapSettingService)SpringBeanUtil.getBean("tibSysSoapSettingService");
			TibSysSoapSetting sett = (TibSysSoapSetting) TibSysSoapSettingService.findByPrimaryKey(mainForm.getWsServerSettingId());
			ITibSysSoap TibSysSoap=(ITibSysSoap)SpringBeanUtil.getBean("tibSysSoap");
			TibSysSoap.getAllOperation(sett, mainForm.getWsSoapVersion());
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("edit", mapping, form, request, response);
		}
	}

}
