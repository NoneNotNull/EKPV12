package com.landray.kmss.work.cases.actions;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.service.ICoreOuterService;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.landray.kmss.work.cases.forms.WorkCasesMainForm;
import com.landray.kmss.work.cases.model.WorkCasesCategory;
import com.landray.kmss.work.cases.model.WorkCasesMain;
import com.landray.kmss.work.cases.service.IWorkCasesCategoryService;
import com.landray.kmss.work.cases.service.IWorkCasesMainService;

 
/**
 * 文档类 Action
 */
public class WorkCasesMainAction extends ExtendAction {
	protected IWorkCasesMainService workCasesMainService;
	protected IWorkCasesCategoryService workCasesCategoryService;
	private ICoreOuterService dispatchCoreService;

	protected ICoreOuterService getDispatchCoreService() {
	if (dispatchCoreService == null) {
		dispatchCoreService = (ICoreOuterService) getBean("dispatchCoreService");
	}
	return dispatchCoreService;
	}
	
	protected IBaseService getWorkCasesCategoryServiceImp() {
		if(workCasesCategoryService == null){
			workCasesCategoryService = (IWorkCasesCategoryService)getBean("workCasesCategoryService");
		}
		return workCasesCategoryService;
	}
	
	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(workCasesMainService == null){
			workCasesMainService = (IWorkCasesMainService)getBean("workCasesMainService");
		}
		return workCasesMainService;
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		CriteriaValue cv = new CriteriaValue(request);
		String docCategory = request.getParameter("q.docCategory");
		if (StringUtil.isNotNull(docCategory)){
			String[] docStatus = new String[]{"30"};
			cv.put("docStatus", docStatus);
		}
		CriteriaUtil.buildHql(cv, hqlInfo, WorkCasesMain.class);
	}
	
	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WorkCasesMainForm mainForm = (WorkCasesMainForm) super.createNewForm(
				mapping, form, request, response);
		// 默认创建时间
		mainForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
						DateUtil.TYPE_DATETIME, request.getLocale()));
        //默认创建者
		mainForm.setDocCreatorName(UserUtil.getUser().getFdName());
		String cateGoryID = request.getParameter("docCategoryId");
		WorkCasesCategory template =(WorkCasesCategory) getWorkCasesCategoryServiceImp().findByPrimaryKey(cateGoryID);
		if (template != null){
			mainForm.setDocCategoryId(cateGoryID);
			mainForm.setDocCategoryName(template.getFdName());
		}
		//从模板中获取配置信息并附加到主文档的Form中,核心方法是各个机制service里面的
		//cloneModelToForm(IExtendForm, IBaseModel, RequestContext)
		getDispatchCoreService().initFormSetting(mainForm, "reviewMainDoc",
				template, "reviewMainDoc", new RequestContext(request));
		return mainForm;

	}
	
	@Override
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		WorkCasesMainForm mainForm = (WorkCasesMainForm) form;
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			String fdId = this.getServiceImp(request).add(mainForm,
					new RequestContext(request));
			if (mainForm.getDocStatus().equals(
					SysDocConstant.DOC_STATUS_DRAFT))
				KmssReturnPage.getInstance(request).addMessages(messages)
						.addButton("button.back",
								"workCasesMain.do?method=edit&fdId=" + fdId, false)
						.save(request);		
	} catch (Exception e) {
			messages.addError(e);
		}
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
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		WorkCasesMainForm mainForm = (WorkCasesMainForm) form;		
	try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			this.getServiceImp(request).update(mainForm,
					new RequestContext(request));
			if (mainForm.getDocStatus().equals(
					SysDocConstant.DOC_STATUS_DRAFT))
				KmssReturnPage.getInstance(request).addMessages(messages)
						.addButton("button.back",
								"workCasesMain.do?method=edit&fdId=" + mainForm.getFdId(), false)
						.save(request);
		} catch (Exception e) {
			messages.addError(e);
		}
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
	
	
	

}

