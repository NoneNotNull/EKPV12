package com.landray.kmss.tib.sys.sap.connector.actions;

import java.util.Arrays;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.common.log.model.TibCommonLogOpt;
import com.landray.kmss.tib.common.log.service.ITibCommonLogMainService;
import com.landray.kmss.tib.sys.sap.connector.connect.TibSysSapJcoConnect;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapJcoSettingForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapJcoSettingService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * jco配置 Action
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapJcoSettingAction extends ExtendAction {
	protected ITibSysSapJcoSettingService tibSysSapJcoSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapJcoSettingService == null)
			tibSysSapJcoSettingService = (ITibSysSapJcoSettingService) getBean("tibSysSapJcoSettingService");
		return tibSysSapJcoSettingService;
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			TibSysSapJcoSettingForm mainForm = (TibSysSapJcoSettingForm) form;
			mainForm.setFdUpdateTime(DateUtil.convertDateToString(new Date(),
					"yyyy-MM-dd hh:mm:ss"));
			TibSysSapJcoSetting tibSysSapJcoSetting = new TibSysSapJcoSetting();
			tibSysSapJcoSetting = (TibSysSapJcoSetting) getServiceImp(request)
					.convertFormToModel(mainForm, tibSysSapJcoSetting,
							new RequestContext());
			new TibSysSapJcoConnect().doInitialize(tibSysSapJcoSetting);
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
	
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Object result= super.deleteall(mapping, form, request, response);
		String[] ids = request.getParameterValues("List_Selected");
		if (ids != null)
			LogSave(null, request, Arrays.toString(ids), 3);
		return (ActionForward)result;
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			TibSysSapJcoSettingForm mainForm = (TibSysSapJcoSettingForm) form;
			mainForm.setFdUpdateTime(DateUtil.convertDateToString(new Date(),
					"yyyy-MM-dd hh:mm:ss"));
			LogSave(mainForm, request,"",2);
			getServiceImp(request).update((IExtendForm) mainForm,
					new RequestContext(request));
			TibSysSapJcoSetting tibSysSapJcoSetting = new TibSysSapJcoSetting();
			tibSysSapJcoSetting = (TibSysSapJcoSetting) getServiceImp(request)
					.convertFormToModel(mainForm, tibSysSapJcoSetting,
							new RequestContext());
			new TibSysSapJcoConnect().doInitialize(tibSysSapJcoSetting);

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

	public ActionForward test(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String mes = ((ITibSysSapJcoSettingService) getServiceImp(request))
				.testConnection((IExtendForm) form);
		if (StringUtil.isNull(mes)) {
			ActionMessages message = new ActionMessages();
			message.add("success", new ActionMessage(ResourceUtil.getString(
					"tib-sys-sap-connector:connection.success", request.getLocale()),
					false));
			saveMessages(request, message);
		} else {
			ActionMessages message = new ActionMessages();
			message.add("failure", new ActionMessage(ResourceUtil.getString(
					"tib-sys-sap-connector:connection.failure", request.getLocale())
					+ mes, false));
			saveErrors(request, message);
		}
		return mapping.findForward("edit");
	}

	//日志类型 1 添加,2 更新, 3 删除
	public void LogSave(TibSysSapJcoSettingForm mainForm, HttpServletRequest request,Object ext,int type)
			throws Exception {
		TibSysSapJcoSetting model =null;
			if(mainForm!=null){
				model=(TibSysSapJcoSetting) getServiceImp(request)
				.findByPrimaryKey(mainForm.getFdId());
			}
			
		TibCommonLogOpt tibCommonLogOpt = new TibCommonLogOpt();
		tibCommonLogOpt.setFdPerson(UserUtil.getUser().getFdName());
		tibCommonLogOpt.setFdAlertTime(new Date());
		tibCommonLogOpt.setFdUrl(request.getRequestURL().toString());
		String userName = ResourceUtil.getString("tibSysSapJcoSetting.lang.userName", "tib-sys-sap-connector"); 
		String poolName = ResourceUtil.getString("tibSysSapJcoSetting.lang.poolName", "tib-sys-sap-connector"); 
		String poolCapacity = ResourceUtil.getString("tibSysSapJcoSetting.lang.poolCapacity", "tib-sys-sap-connector"); 
		String poolNumber = ResourceUtil.getString("tibSysSapJcoSetting.lang.poolNumber", "tib-sys-sap-connector"); 
		String poolTime = ResourceUtil.getString("tibSysSapJcoSetting.lang.poolTime", "tib-sys-sap-connector"); 
		String tibSysSapCode = ResourceUtil.getString("tibSysSapJcoSetting.lang.tibSysSapCode", "tib-sys-sap-connector"); 
		String addNewConfigItem = ResourceUtil.getString("tibSysSapJcoSetting.lang.addNewConfigItem", "tib-sys-sap-connector"); 
		String deleteConfigItem = ResourceUtil.getString("tibSysSapJcoSetting.lang.deleteConfigItem", "tib-sys-sap-connector"); 
		String xml = "";
		String[] formField = { "fdPoolAdmin-"+ userName, "fdPoolName-"+ poolName,
			"fdPoolCapacity-"+ poolCapacity, "fdPoolNumber-"+ poolNumber, 
			"fdPoolTime-"+ poolTime, "fdTibSysSapCodeId-"+ tibSysSapCode +"Id" };
		switch(type){
		case 1:
			StringBuffer buf=new StringBuffer();
			buf.append(addNewConfigItem +"<br>");
			for(String msgKey:formField){
				String[] keys=msgKey.split("-");
				buf.append(keys[1]+":"+PropertyUtils.getProperty(mainForm, keys[0]).toString());
				buf.append("<br>");
			}
			xml+=buf.toString();
			break;
		case 2:
		if (!(model.getFdPoolAdmin().equals(mainForm.getFdPoolAdmin()))) {
			xml += userName +": " + model.getFdPoolAdmin() + "-------->"
					+ mainForm.getFdPoolAdmin() + "<br>";
		}
		if (!(model.getFdPoolName().equals(mainForm.getFdPoolName()))) {
			xml += poolName +": " + model.getFdPoolName() + "-------->"
					+ mainForm.getFdPoolName() + "<br>";
		}
		if (!(model.getFdPoolCapacity().toString().equals(mainForm.getFdPoolCapacity()))) {
			xml += poolCapacity +": " + model.getFdPoolCapacity() + "-------->"
					+ mainForm.getFdPoolCapacity() + "<br>";
		}
		if (!(model.getFdPoolNumber().toString().equals(mainForm.getFdPoolNumber()))) {
			xml += poolNumber +": " + model.getFdPoolNumber() + "-------->"
					+ mainForm.getFdPoolNumber() + "<br>";
		}
		if (!(model.getFdPoolTime().toString().equals(mainForm.getFdPoolTime()))) {
			xml += poolTime +": " + model.getFdPoolTime() + "-------->"
					+ mainForm.getFdPoolTime() + "<br>";
		}
		if (!(model.getFdTibSysSapCode().getFdServerName().equals(mainForm
				.getFdTibSysSapCodeName()))) {
			xml += tibSysSapCode +": " + model.getFdTibSysSapCode().getFdServerName()
					+ "-------->" + mainForm.getFdTibSysSapCodeName() + "<br>";
		}
		break;
		case 3:
			StringBuffer sb=new StringBuffer();
			sb.append(deleteConfigItem +"<br>");
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
