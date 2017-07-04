package com.landray.kmss.tib.jdbc.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.jdbc.forms.TibJdbcDataSetForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSetCategory;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetCategoryService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;


/**
 * 数据集管理 Action
 * 
 * @author 
 * @version 1.0 2014-04-15
 */
public class TibJdbcDataSetAction extends ExtendAction {
	protected ITibJdbcDataSetService tibJdbcDataSetService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibJdbcDataSetService == null)
			tibJdbcDataSetService = (ITibJdbcDataSetService)getBean("tibJdbcDataSetService");
		return tibJdbcDataSetService;
	}

	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TibJdbcDataSetForm tibJdbcDataSetForm = (TibJdbcDataSetForm)form;
		String tempCategoryId = tibJdbcDataSetForm.getDocCategoryId();
		tibJdbcDataSetForm.reset(mapping, request);
		String categoryId = StringUtil.isNotNull(tempCategoryId) ? tempCategoryId : request.getParameter("categoryId");
		ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService = (ITibJdbcDataSetCategoryService) SpringBeanUtil.getBean("tibJdbcDataSetCategoryService");
		if (StringUtil.isNotNull(categoryId)) {
			TibJdbcDataSetCategory tibJdbcDataSetCategory = (TibJdbcDataSetCategory) tibJdbcDataSetCategoryService
					.findByPrimaryKey(categoryId);
			tibJdbcDataSetForm.setDocCategoryId(categoryId);
			tibJdbcDataSetForm.setDocCategoryName(tibJdbcDataSetCategory.getFdName());
		}
		return tibJdbcDataSetForm;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		if(!StringUtil.isNull(categoryId)){
			String hql=hqlInfo.getWhereBlock();
			hql=StringUtil.linkString(hql, " and ", "tibJdbcDataSet.docCategory.fdHierarchyId like :fdHierarchyId ");
			hqlInfo.setParameter("fdHierarchyId", "%"+categoryId+"%");
			hqlInfo.setWhereBlock(hql);
		}
	}
}

