package com.landray.kmss.tib.sys.sap.connector.actions;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcSettingForm;
import com.landray.kmss.tib.sys.sap.connector.impl.TibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSearchInfo;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcCategoryService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSearchInfoService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;
import com.landray.kmss.tib.sys.sap.connector.util.SAPXMLTemplateUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * RFC函数配置 Action
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcSettingAction extends ExtendAction {

	protected ITibSysSapRfcSettingService tibSysSapRfcSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapRfcSettingService == null)
			tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) getBean("tibSysSapRfcSettingService");
		return tibSysSapRfcSettingService;
	}

	public ActionForward detail(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("detail", mapping, form, request, response);
		}
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TibSysSapRfcSettingForm mainForm = (TibSysSapRfcSettingForm) form;
		mainForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
				DateUtil.PATTERN_DATETIME));
		mainForm.setDocCreatorId(UserUtil.getUser().getFdId());
		String fdTemplateId = request.getParameter("fdTemplateId");

		if (StringUtil.isNull(fdTemplateId))
			return mainForm;

		ITibSysSapRfcCategoryService service = (ITibSysSapRfcCategoryService) SpringBeanUtil
				.getBean("tibSysSapRfcCategoryService");
		TibSysSapRfcCategory category = (TibSysSapRfcCategory) service
				.findByPrimaryKey(fdTemplateId);
		mainForm.setDocCategoryId(fdTemplateId);
		mainForm.setDocCategoryName(category.getFdName());
		return mainForm;
	}

	public ActionForward detailView(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("detailView", mapping, form, request,
					response);
		}
	}

	public ActionForward xmlView(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String fdId = request.getParameter("fdId");
			TibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = new TibSysSapJcoFunctionUtil();
			Object xml = tibSysSapJcoFunctionUtil.getFunctionToXmlById(fdId);
			response.setContentType("text/xml;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.print(xml);
			out.close();
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			mapping.findForward("xmlView");
			return null;
		}
	}


	public ActionForward newEdition(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String originId = request.getParameter("originId");
			if (StringUtil.isNull(originId))
				throw new NoRecordException();
			TibSysSapRfcSettingForm tibSysSapRfcSettingForm = (TibSysSapRfcSettingForm) form;
			TibSysSapRfcSettingForm mainForm = new TibSysSapRfcSettingForm();
			TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) getServiceImp(request)
					.findByPrimaryKey(originId);
			mainForm = (TibSysSapRfcSettingForm) getServiceImp(request)
					.cloneModelToForm(tibSysSapRfcSettingForm, tibSysSapRfcSetting,
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

	public ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = 0;

			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
				hqlInfo.setWhereBlock(hqlInfo.getWhereBlock()
						+ " and docOriginDoc=null");
			} else {
				hqlInfo.setWhereBlock("docOriginDoc=null");
			}
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("list", mapping, form, request, response);
		}
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request, HQLInfo hqlInfo)
			throws Exception {
		String categoryId = request.getParameter("categoryId");
		if (StringUtil.isNotNull(categoryId)) {
			hqlInfo.setWhereBlock(" tibSysSapRfcSetting.docCategory.fdHierarchyId like :docCategoryFdHierarchyId");
			hqlInfo.setParameter("docCategoryFdHierarchyId", "%" + categoryId + "%");
		}
	}

	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		form.reset(mapping, request);
		IExtendForm rtnForm = null;
		String id = request.getParameter("fdId");
		Boolean isHasNewVersion = new Boolean(false);
		if (!StringUtil.isNull(id)) {
			IBaseModel model = getServiceImp(request).findByPrimaryKey(id,
					null, true);
			if (model != null)
				rtnForm = getServiceImp(request).convertModelToForm(
						(IExtendForm) form, model, new RequestContext(request));
			if (rtnForm == null)
				throw new NoRecordException();
			if (model != null) {
				// 判断是否有新版本，以便view页面提示(该文档已有新版本)
				if (((TibSysSapRfcSetting) model).getDocOriginDoc() != null
						&& ((TibSysSapRfcSetting) model).getDocStatus().startsWith(
								"3")) {
					isHasNewVersion = true;
				}
			}
		}
		request.setAttribute("isHasNewVersion", isHasNewVersion);
		request.setAttribute(getFormName(rtnForm, request), rtnForm);
	}
	
	
//	清空缓存
	public ActionForward clearCache(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String poolName =request.getParameter("poolName");
		String funcName =request.getParameter("funcName");
		if(!StringUtil.isNull(poolName)){
			TibSysSapJcoFunctionUtil.clearTargetCache(poolName, funcName);
		}
		return null;
	}

	/**
	 * 重写，目的是清除是否启用缓存
	 */
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
			// 移除缓存
			SAPXMLTemplateUtil.useMapStroe.remove(((IExtendForm) form).getFdId());
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
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}

	@Override
	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-delete", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("GET"))
				throw new UnexpectedRequestException();
			String id = request.getParameter("fdId");
			// 移除缓存
			SAPXMLTemplateUtil.useMapStroe.remove(id);
			if (StringUtil.isNull(id))
				messages.addError(new NoRecordException());
			else
				getServiceImp(request).delete(id);
		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-delete", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	@Override
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-deleteall", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String[] ids = request.getParameterValues("List_Selected");
			for (String id : ids) {
				// 移除缓存
				SAPXMLTemplateUtil.useMapStroe.remove(id);
			}
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
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_RETURN).save(request);
		TimeCounter.logCurrentTime("Action-deleteall", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}
	
	 //更新函数
	public ActionForward updateFunction(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception{
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		
		TibSysSapRfcSettingForm tibSysSapRfcSettingForm = (TibSysSapRfcSettingForm) form;
		try {
			super.update(mapping, tibSysSapRfcSettingForm, request, response);
			String ids[]=null;
			String fdSettingId = tibSysSapRfcSettingForm.getFdId();
			List<TibSysSapRfcSearchInfo> histroyData = new ArrayList<TibSysSapRfcSearchInfo>();
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock("tibSysSapRfcSearchInfo.fdRfc.fdId=:fdSettingId");
			hqlInfo.setParameter("fdSettingId", fdSettingId);
			ITibSysSapRfcSearchInfoService tibSysSapRfcSearchInfoService=
				(ITibSysSapRfcSearchInfoService)SpringBeanUtil.getBean("tibSysSapRfcSearchInfoService");
			histroyData = tibSysSapRfcSearchInfoService.findList(hqlInfo);
			if(histroyData.size()>0){
				ids= new String[histroyData.size()];
				int i=0;
				for (TibSysSapRfcSearchInfo tibSysSapRfcSearchInfo : histroyData) {
					ids[i]=tibSysSapRfcSearchInfo.getFdId();
					i++;
				}
			}
			//删除该函数关联的 历史查询记录
			if(ids.length>0){
			  tibSysSapRfcSearchInfoService.delete(ids);
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		
		TimeCounter.logCurrentTime("Action-update", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(request);
			return getActionForward("edit", mapping, form, request, response);
		} else {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}
}
