package com.landray.kmss.tib.sys.sap.connector.actions;

import java.util.Arrays;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.common.log.model.TibCommonLogOpt;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainService;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapServerSettingForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapServerSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapServerSettingService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * tibSysSap服务器配置 Action
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapServerSettingAction extends ExtendAction {
	protected ITibSysSapServerSettingService tibSysSapServerSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapServerSettingService == null)
			tibSysSapServerSettingService = (ITibSysSapServerSettingService) getBean("tibSysSapServerSettingService");
		return tibSysSapServerSettingService;
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Object result=super.delete(mapping, form, request, response);
		String id = request.getParameter("fdId");
		if(StringUtil.isNotNull(id)){
			LogSave(null, request, id, 3);
		}
		return (ActionForward)result;
	}
	
	@Override
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Object result= super.deleteall(mapping, form, request, response);
		String[] ids = request.getParameterValues("List_Selected");
		if (ids != null)
			LogSave(null, request, Arrays.toString(ids), 3);
		
		return (ActionForward)result;
	}
	
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			TibSysSapServerSettingForm mainForm = (TibSysSapServerSettingForm) form;
			mainForm.setFdUpdateTime(DateUtil.convertDateToString(new Date(),
					"yyyy-MM-dd hh:mm:ss"));
			getServiceImp(request).add((IExtendForm) mainForm,
					new RequestContext(request));
			LogSave(mainForm, request, "", 1);
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
			TibSysSapServerSettingForm mainForm = (TibSysSapServerSettingForm) form;
			mainForm.setFdUpdateTime(DateUtil.convertDateToString(new Date(),
					"yyyy-MM-dd hh:mm:ss"));
			LogSave(mainForm, request,"",2);
			getServiceImp(request).update((IExtendForm) mainForm,
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
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}
	
	//日志类型2 更新 1 添加 3 删除
	public void LogSave(TibSysSapServerSettingForm mainForm, HttpServletRequest request,Object ext,int type)
			throws Exception {
		TibSysSapServerSetting model =null;
			if(mainForm!=null){
				model=(TibSysSapServerSetting) getServiceImp(request)
				.findByPrimaryKey(mainForm.getFdId());
			}
			
		TibCommonLogOpt tibCommonLogOpt = new TibCommonLogOpt();
		tibCommonLogOpt.setFdPerson(UserUtil.getUser().getFdName());
		tibCommonLogOpt.setFdAlertTime(new Date());
		tibCommonLogOpt.setFdUrl(request.getRequestURL().toString());
		String ipAddress = ResourceUtil.getString("tibSysSapServerSetting.lang.ipAddress", "tib-sys-sap-connector"); 
		String clientCode = ResourceUtil.getString("tibSysSapServerSetting.lang.clientCode", "tib-sys-sap-connector"); 
		String tibSysSapCode = ResourceUtil.getString("tibSysSapServerSetting.lang.tibSysSapCode", "tib-sys-sap-connector"); 
		String serverCode = ResourceUtil.getString("tibSysSapServerSetting.lang.serverCode", "tib-sys-sap-connector"); 
		String serverName = ResourceUtil.getString("tibSysSapServerSetting.lang.serverName", "tib-sys-sap-connector"); 
		String language = ResourceUtil.getString("tibSysSapServerSetting.lang.language", "tib-sys-sap-connector"); 
		String addNewServerConfig = ResourceUtil.getString("tibSysSapServerSetting.lang.addNewServerConfig", "tib-sys-sap-connector"); 
		String deleteServerConfig = ResourceUtil.getString("tibSysSapServerSetting.lang.deleteServerConfig", "tib-sys-sap-connector"); 
		String xml = "";
		String[] formField = { "fdServerIp-"+ ipAddress,"fdClientCode-"+ clientCode,
				"fdTibSysSapCode-"+ tibSysSapCode,"fdServerCode-"+ serverCode,
				"fdServerName-"+ serverName ,"fdLanguage-"+ language};
		switch(type){
		case 1:
			StringBuffer buf=new StringBuffer();
			buf.append(addNewServerConfig +"<br>");
			for(String msgKey:formField){
				String[] keys=msgKey.split("-");
				buf.append(keys[1]+":"+PropertyUtils.getProperty(mainForm, keys[0]).toString());
				buf.append("<br>");
			}
			xml+=buf.toString();
			break;
		case 2:
			if (!(model.getFdServerIp().equals(mainForm.getFdServerIp()))) {
				xml += ipAddress +": " + model.getFdServerIp() + "-------->"
						+ mainForm.getFdServerIp() + "<br>";
			}
			if (!(model.getFdClientCode().equals(mainForm.getFdClientCode()))) {
				xml += clientCode +": " + model.getFdClientCode() + "-------->"
						+ mainForm.getFdClientCode() + "<br>";
			}
			if (!(model.getFdTibSysSapCode().equals(mainForm.getFdTibSysSapCode()))) {
				xml += tibSysSapCode +": " + model.getFdTibSysSapCode() + "-------->"
						+ mainForm.getFdTibSysSapCode() + "<br>";
			}
			if (!(model.getFdServerCode().equals(mainForm.getFdServerCode()))) {
				xml += serverCode +": " + model.getFdServerCode() + "-------->"
						+ mainForm.getFdServerCode() + "<br>";
			}
			if (!(model.getFdServerName().equals(mainForm.getFdServerName()))) {
				xml += serverName +": " + model.getFdServerName() + "-------->"
						+ mainForm.getFdServerName() + "<br>";
			}
			if (!(model.getFdLanguage().equals(mainForm.getFdLanguage()))) {
				xml += language +": " + model.getFdLanguage() + "-------->"
						+ mainForm.getFdLanguage() + "<br>";
			}
		break;
		case 3:
			StringBuffer sb=new StringBuffer();
			sb.append(deleteServerConfig +"<br>");
			sb.append(ext.toString());
			xml+=sb.toString();
			break;
		}
		ITibCommonLogMainService tibCommonLogMainService = (ITibCommonLogMainService) SpringBeanUtil
				.getBean("tibCommonLogMainService");
		tibCommonLogOpt.setFdContent(xml);
		if (!(xml.equals("")))
			tibCommonLogMainService.add(tibCommonLogOpt);
	}

}
