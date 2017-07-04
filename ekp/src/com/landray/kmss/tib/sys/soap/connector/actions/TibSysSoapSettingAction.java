package com.landray.kmss.tib.sys.soap.connector.actions;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.dict.SysDictSimpleProperty;
import com.landray.kmss.tib.common.log.model.TibCommonLogOpt;
import com.landray.kmss.tib.common.log.service.ITibCommonLogOptService;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapSettingForm;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * WEBSERVICE服务配置 Action
 * 
 * @author
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingAction extends ExtendAction {
	
	protected ITibSysSoapSettingService TibSysSoapSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (TibSysSoapSettingService == null)
			TibSysSoapSettingService = (ITibSysSoapSettingService) getBean("tibSysSoapSettingService");
		return TibSysSoapSettingService;
	}

	@Override
	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TibSysSoapSettingForm tibSysSoapSettingForm = (TibSysSoapSettingForm) form;
		String categoryId = request.getParameter("categoryId");
		tibSysSoapSettingForm.setDocCreatorId(UserUtil.getKMSSUser().getUserId());
		tibSysSoapSettingForm.setDocCreatorName(UserUtil.getKMSSUser().getUserName());
		tibSysSoapSettingForm.setDocCreateTime(DateUtil.convertDateToString(new Date(),
				"yyyy-MM-dd HH:mm:ss", request.getLocale()));
		ITibSysSoapSettCategoryService tibSysSoapSettCategoryService = (ITibSysSoapSettCategoryService) SpringBeanUtil
		.getBean("tibSysSoapSettCategoryService");
		if (StringUtil.isNotNull(categoryId)) {
			TibSysSoapSettCategory tibSysSoapSettCategory = (TibSysSoapSettCategory) tibSysSoapSettCategoryService
					.findByPrimaryKey(categoryId);
			tibSysSoapSettingForm.setSettCategoryId(categoryId);
			tibSysSoapSettingForm.setSettCategoryName(tibSysSoapSettCategory.getFdName());
		}
		return tibSysSoapSettingForm;
	}
	
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			TibSysSoapSettingForm mainForm = (TibSysSoapSettingForm) form;
			mainForm.setDocAlterTime(DateUtil.convertDateToString(new Date(),
					"yyyy-MM-dd hh:mm:ss"));
			// 添加操作者
			mainForm.setDocPoolAdmin(UserUtil.getUser().getFdName());
			TibSysSoapSetting TibSysSoapSetting = new TibSysSoapSetting();
			TibSysSoapSetting = (TibSysSoapSetting) getServiceImp(request)
					.convertFormToModel(mainForm, TibSysSoapSetting,
							new RequestContext());
			getServiceImp(request).add((IExtendForm) mainForm,
					new RequestContext(request));
			// 添加操作日志
			logSave(mainForm, request, "", 1);
			
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-save", false, getClass());
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
	
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			TibSysSoapSettingForm mainForm = (TibSysSoapSettingForm) form;
			mainForm.setDocAlterTime(DateUtil.convertDateToString(new Date(),
					"yyyy-MM-dd hh:mm:ss"));
			// 添加操作者
			mainForm.setDocPoolAdmin(UserUtil.getUser().getFdName());
			// 添加操作日志
			logSave(mainForm, request,"",2);
			getServiceImp(request).update((IExtendForm) mainForm,
					new RequestContext(request));
			TibSysSoapSetting TibSysSoapSetting = new TibSysSoapSetting();
			TibSysSoapSetting = (TibSysSoapSetting) getServiceImp(request)
					.convertFormToModel(mainForm, TibSysSoapSetting,
							new RequestContext());

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
	
	/**
	 *  删除方法，添加操作日志
	 */
	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Object result=super.delete(mapping, form, request, response);
		String id = request.getParameter("fdId");
		if(StringUtil.isNotNull(id)){
			logSave(null, request, id, 3);
		}
		return (ActionForward)result;
	}
	
	/**
	 * 
	 *  删除方法，添加操作日志
	 */
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Object result= super.deleteall(mapping, form, request, response);
		String[] ids = request.getParameterValues("List_Selected");
		if (ids != null)
			logSave(null, request, Arrays.toString(ids), 3);
		return (ActionForward)result;
	}
	
	private String logInfoBuilder(TibSysSoapSettingForm mainForm,TibSysSoapSetting model ){
		SysDictModel dictModel = SysDataDict.getInstance().getModel(ModelUtil.getModelClassName(model));
		List<SysDictCommonProperty> properties = dictModel.getPropertyList();
		StringBuffer buffer=new StringBuffer("");
		String unitString="!{messageKey}!:{modelval}-------->!{formval}<br>";
		for(SysDictCommonProperty property : properties )
		{
			String ptName=property.getName();
			//只处理简单类型
			if(property instanceof SysDictSimpleProperty){
				if(PropertyUtils.isReadable(model, ptName)&&PropertyUtils.isReadable(mainForm, ptName)){
					String key=property.getMessageKey();
					String keyVal=ResourceUtil.getString(key);
					String str=unitString.replace("!{messageKey}", keyVal);
					try {
						Object modelval=PropertyUtils.getProperty(model, ptName);
						Object form=PropertyUtils.getProperty(mainForm, ptName);
						if(modelval==form){
							continue;
						}
						if(modelval!=null&&form!=null&&modelval.toString().equals(form)){
							continue;
						}
						if(modelval==null){
							str=str.replace("!{modelval}", " null ");
						}
						else{
							str=str.replace("!{modelval}", modelval.toString());
						}
						if(form==null){
							str=str.replace("!{formval}", " null ");
						}
						else{
							str=str.replace("!{formval}", form.toString());
						}
						buffer.append(str);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		return buffer.toString();
	}
	
	private String buildAddLogInfo(TibSysSoapSettingForm mainForm){
		String className=mainForm.getModelClass().getName();
		SysDictModel dictModel = SysDataDict.getInstance().getModel(className);
		List<SysDictCommonProperty> properties = dictModel.getPropertyList();
		StringBuffer buffer=new StringBuffer("添加新配置项：<br>");
		
		for(SysDictCommonProperty property : properties )
		{
			String ptName=property.getName();
//			if(!property.isCanDisplay()){
//				continue;
//			}
			//只处理简单类型
			if(property instanceof SysDictSimpleProperty){
				if(PropertyUtils.isReadable(mainForm, ptName)){
					String key=property.getMessageKey();
					String keyVal=ResourceUtil.getString(key);
					try {
						Object result=PropertyUtils.getProperty(mainForm, ptName);
						String realVal=result==null?"null":result.toString();
						buffer.append(keyVal+":"+realVal);
						buffer.append("<br>");
					} catch (Exception e) {
						e.printStackTrace();
					} 
				}
			}
		}
		return buffer.toString();
	}
	
	//日志类型 1 添加,2 更新, 3 删除
	public void logSave(TibSysSoapSettingForm mainForm, HttpServletRequest request,Object ext,int type)
			throws Exception {
		TibSysSoapSetting model =null;
			if(mainForm!=null){
				model=(TibSysSoapSetting) getServiceImp(request)
				.findByPrimaryKey(mainForm.getFdId());
			}
		TibCommonLogOpt tibCommonLogOpt = new TibCommonLogOpt();
		tibCommonLogOpt.setFdPerson(UserUtil.getUser().getFdName());
		tibCommonLogOpt.setFdAlertTime(new Date());
		tibCommonLogOpt.setFdUrl(request.getRequestURL().toString());
		String xml = "";
		switch(type){
		case 1:
			xml+=buildAddLogInfo(mainForm);
			break;
		case 2:
			xml=logInfoBuilder(mainForm, model);
		
		break;
		case 3:
			StringBuffer sb=new StringBuffer();
			sb.append(ResourceUtil.getString("tibSysSoapSetting.lang.deleteConfigItem", "tib-sys-soap-connector") +"<br>");
			sb.append(ext.toString());
			xml+=sb.toString();
			break;
		}
		ITibCommonLogOptService tibCommonLogOptService = (ITibCommonLogOptService) SpringBeanUtil
				.getBean("tibCommonLogOptService");
		tibCommonLogOpt.setFdContent(xml);
		if (!(xml.equals("")))
			tibCommonLogOptService.add(tibCommonLogOpt);
	}

	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		String hql=hqlInfo.getWhereBlock();
		//hql=StringUtil.linkString(hql, " and ", "tibSysSoapSetting.docIsNewVersion = :docIsNewVersion");
		//hqlInfo.setParameter("docIsNewVersion", true);
		if(!StringUtil.isNull(categoryId)){
			hql=StringUtil.linkString(hql, " and ", "tibSysSoapSetting.settCategory.fdHierarchyId like :fdHierarchyId ");
			hqlInfo.setParameter("fdHierarchyId", "%"+categoryId+"%");
		}
		hqlInfo.setWhereBlock(hql);
		
		
		
	}
}
