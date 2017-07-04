package com.landray.kmss.tib.common.mapping.actions;

import java.io.FileOutputStream;
import java.net.URL;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;

/**
 * 应用模块注册配置表 Action
 * 
 * @author
 * @version 1.0 2011-10-14
 */
public class TibCommonMappingModuleAction extends ExtendAction {
	private Log logger = LogFactory.getLog(this.getClass());
	protected ITibCommonMappingModuleService tibCommonMappingModuleService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibCommonMappingModuleService == null)
			tibCommonMappingModuleService = (ITibCommonMappingModuleService) getBean("tibCommonMappingModuleService");
		return tibCommonMappingModuleService;
	}

	@Override
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return super.update(mapping, form, request, response);
	}

	@Override
	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// TODO 自动生成的方法存根
		ActionForward actionForward = super.delete(mapping, form, request,
				response);
//		generateRegModelFile();
		return actionForward;
	}

	@Override
	public ActionForward deleteall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// TODO 自动生成的方法存根
		ActionForward actionForward = super.deleteall(mapping, form, request,
				response);
//		generateRegModelFile();
		return actionForward;
	}

	/**
	 * 构建模块注册
	 */
	public void generateRegModelFile() {

		URL url = Thread.currentThread().getContextClassLoader()
				.getResource("");
		String fileName = ConfigLocationsUtil.getWebContentPath()
				+ "/third/erp/common/ModelReg.properties";
		logger.debug("创建配置文件：" + fileName);
		Properties props = new Properties();
		StringBuffer buf = new StringBuffer("");
		try {
			tibCommonMappingModuleService.initRegisterModelHash();
			ConcurrentHashMap<String, Map<String, Object>> regMap = tibCommonMappingModuleService
					.getRegisterModelHash();
			if (regMap.isEmpty()) {

			} else {
				boolean first = true;
				for (String modelName : regMap.keySet()) {
					SysDictModel s_model = SysDataDict.getInstance().getModel(
							modelName);
					if (s_model != null) {
						if (first) {
							first = false;
						} else {
							buf.append(",");
						}
						buf.append(s_model.getServiceBean());
					}
				}
			}
			if (buf.length() > 0) {
				props.setProperty("regModelList", buf.toString());
			} else {
				props.setProperty("regModelList", "-*");
			}
			FileOutputStream fos = new FileOutputStream(fileName);
			props.store(fos, "create config for ERP registerModel");
			fos.close();
			logger.info("创建模块注册文件成功：" + fileName);
		} catch (Exception e) {
			logger.info("创建模块注册文件出现异常" + e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 保存方法
	 */
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			getServiceImp(request).add((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-save", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return getActionForward("edit", mapping, form, request, response);
		} else {
			//messages.addMsg(new KmssMessage("tib-common-mapping:tibCommonMappingModule.reLoad"));
			KmssReturnPage.getInstance(request).addMessages(messages).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}
	
}
