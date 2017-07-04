package com.landray.kmss.tib.common.mapping.actions;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
/**
 * 模板/定时任务对应函数表 Action
 * 
 * @author
 * @version 1.0 2011-10-14
 */
public class TibCommonMappingFuncAction extends ExtendAction {
	protected ITibCommonMappingFuncService tibCommonMappingFuncService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibCommonMappingFuncService == null)
			tibCommonMappingFuncService = (ITibCommonMappingFuncService) getBean("tibCommonMappingFuncService");
		return tibCommonMappingFuncService;
	}
	
	public ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// TODO 自动生成的方法存根
		
//		SysConfigAdminUtil.lo
		return null;
	}
}
