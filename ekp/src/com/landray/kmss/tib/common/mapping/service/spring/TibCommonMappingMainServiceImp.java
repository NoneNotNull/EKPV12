package com.landray.kmss.tib.common.mapping.service.spring;

import java.util.Iterator;

import org.hibernate.Query;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingFuncExtForm;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingFuncForm;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingMainForm;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonPageInfo;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.ModelUtil;
import com.sunbor.web.tag.Page;

/**
 * 主文档表业务接口实现
 * 
 * @author
 * @version 1.0 2011-10-16
 */
public class TibCommonMappingMainServiceImp extends BaseServiceImp implements
		ITibCommonMappingMainService {
	private ITibCommonMappingModuleService tibCommonMappingModuleService;

	public void setTibCommonMappingModuleService(
			ITibCommonMappingModuleService tibCommonMappingModuleService) {
		this.tibCommonMappingModuleService = tibCommonMappingModuleService;
	}

	public Page listTemplate(String parentId, String templateName,
		   TibCommonPageInfo pageInfo) throws Exception {
		String tableName = ModelUtil.getModelTableName(templateName);
		/*
		 * 通过templateName找到对应启用模块的的一些字段信息，只取第一个 如果存在多个认为相关配置是相同的，可以限制不能配置多个相同的
		 */
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibCommonMappingModule.fdTemplateName=:fdTemplateName " +
				"and tibCommonMappingModule.fdUse=1");
		hqlInfo.setParameter("fdTemplateName", templateName);
		java.util.List<TibCommonMappingModule> tibCommonMappingModuleList = tibCommonMappingModuleService
				.findList(hqlInfo);
		TibCommonMappingModule tibCommonMappingModule = tibCommonMappingModuleList
				.get(0);
		String fdTemNameFieldName = tibCommonMappingModule.getFdTemNameFieldName();// 一般为fdName
		String fdTemCateFieldName = tibCommonMappingModule.getFdTemCateFieldName();// 一般为docCategory
		String fdIntegrationType = tibCommonMappingModule.getFdType();
		Query query = getBaseDao().getHibernateSession().createQuery(
				"select " + tableName + ".fdId," + tableName + "."
						+ fdTemNameFieldName + " from " + templateName + " "
						+ tableName + " where " + tableName + "."
						+ fdTemCateFieldName + ".fdId=:parentId").setString("parentId", parentId);
		
		int total = query.list().size();
		Page page = null;
		page = new Page();
		page.setRowsize(pageInfo.getRowsize());
		page.setPageno(pageInfo.getPageno());
		page.setTotalrows(total);
		page.excecute();
		query.setFirstResult(page.getStart());
		query.setMaxResults(page.getRowsize());
		page.setList(query.list());
		page.setOrderby(fdIntegrationType);
		return page;
	}
	
	@Override
	public void update(IExtendForm form, RequestContext requestContext)
			throws Exception {
//		modify by zhangtian
//		每次上下移动操作的时候hibernate会删除数据再插入数据,那么关联表TibCommonMappingFuncExt就会
//		出现删除后再插入操作在同一个动作产生,会出现不能删除的异常
//		每次更新的时候就给一个全新的ID 给TibCommonMappingFuncExt,让其不删除后插入
//		TibCommonMappingMainForm->TibCommonMappingFunc->TibCommonMappingFuncExt
//		
		refreshList(((TibCommonMappingMainForm)form).getFdFormAddFunctionListForms());
		refreshList(((TibCommonMappingMainForm)form).getFdFormDelFunctionListForms());
		refreshList(((TibCommonMappingMainForm)form).getFdFormEventFunctionListForms());
		refreshList(((TibCommonMappingMainForm)form).getFdRobotFunctionListForms());
		refreshList(((TibCommonMappingMainForm)form).getFdFormSaveFunctionListForms());
		refreshList(((TibCommonMappingMainForm)form).getFdFlowRejectListForms());
		super.update(form, requestContext);
	}
	
	/**
	 * 更新数据中TibCommonMappingFuncExtForm 的ID
	 * @param arrayList
	 */
	private void refreshList(AutoArrayList arrayList){
		if(arrayList==null||arrayList.isEmpty()){
			return ;
		}
		for (Iterator iterator = arrayList.iterator(); iterator.hasNext();) {
			TibCommonMappingFuncForm object = (TibCommonMappingFuncForm) iterator.next();
			AutoArrayList extendForms=object.getFdExtendForms();
			for (Object extend : extendForms) {
				TibCommonMappingFuncExtForm ext=(TibCommonMappingFuncExtForm)extend;
				ext.setFdId(IDGenerator.generateID());
			}
		}
	}
}
