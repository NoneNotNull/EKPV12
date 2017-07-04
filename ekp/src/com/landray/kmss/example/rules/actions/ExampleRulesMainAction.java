package com.landray.kmss.example.rules.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;

import com.landray.kmss.example.rules.service.IExampleRulesCategoryService;
import com.landray.kmss.example.rules.service.IExampleRulesMainService;
import com.landray.kmss.sys.organization.service.ISysOrgElementService;

import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.example.rules.model.ExampleRulesMain;
import com.landray.kmss.example.rules.forms.ExampleRulesMainForm;
import com.landray.kmss.sys.organization.forms.SysOrgElementForm;
import com.landray.kmss.example.rules.forms.ExampleRulesCategoryForm;

import com.landray.kmss.common.service.ICoreOuterService;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;


import com.landray.kmss.common.forms.IExtendForm;
 

import com.landray.kmss.example.rules.model.ExampleRulesCategory;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.example.rules.model.ExampleRulesMain;

 
/**
 * 最新案例 Action
 * 
 * @author 戴云
 * @version 1.0 2017-07-04
 */
public class ExampleRulesMainAction extends ExtendAction {
	protected IExampleRulesMainService exampleRulesMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(exampleRulesMainService == null){
			exampleRulesMainService = (IExampleRulesMainService)getBean("exampleRulesMainService");
		}
		return exampleRulesMainService;
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);		
		CriteriaValue cv = new CriteriaValue(request);
		CriteriaUtil.buildHql(cv, hqlInfo, ExampleRulesMain.class);
	}
}

