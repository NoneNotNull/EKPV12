package com.landray.kmss.work.cases.actions;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryAction;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.UserUtil;
import com.landray.kmss.work.cases.forms.WorkCasesCategoryForm;
import com.landray.kmss.work.cases.service.IWorkCasesCategoryService;

 
/**
 * 分类信息 Action
 */
public class WorkCasesCategoryAction extends SysSimpleCategoryAction {
	protected IWorkCasesCategoryService workCasesCategoryService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(workCasesCategoryService == null){
			workCasesCategoryService = (IWorkCasesCategoryService)getBean("workCasesCategoryService");
		}
		return workCasesCategoryService;
	}
	
	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		WorkCasesCategoryForm mainForm = (WorkCasesCategoryForm) super.createNewForm(
				mapping, form, request, response); 
		// 默认创建时间
		mainForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
				DateUtil.TYPE_DATETIME, request.getLocale()));
        //默认创建者
		mainForm.setDocCreatorName(UserUtil.getUser().getFdName());
		return mainForm;

	}
	
	
}

