package com.landray.kmss.tib.common.mapping.actions;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.xform.base.service.ISysFormTemplateService;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingFuncForm;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingMainForm;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonPageInfo;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMainService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.sunbor.web.tag.Page;

/**
 * 主文档表 Action
 * 
 * @author
 * @version 1.0 2011-10-16
 */
public class TibCommonMappingMainAction extends ExtendAction {
	private static final Log logger = LogFactory
			.getLog(TibCommonMappingMainAction.class);
	protected ITibCommonMappingMainService tibCommonMappingMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibCommonMappingMainService == null)
			tibCommonMappingMainService = (ITibCommonMappingMainService) getBean("tibCommonMappingMainService");
		return tibCommonMappingMainService;
	}

	protected ISysFormTemplateService sysFormTemplateService;

	protected ISysFormTemplateService getSysFormTemplateServiceImp() {
		if (sysFormTemplateService == null)
			sysFormTemplateService = (ISysFormTemplateService) getBean("sysFormTemplateService");
		return sysFormTemplateService;
	}

	@SuppressWarnings("unchecked")
	@Override
	/*
	 * 需要做以下的判断：1.如果是简单分类直接打开编辑或者新增页面（需要判断是否已经存在对应的文档，存在则为编辑，反之新增）
	 * 2.如果是全局分类则需要打开一个模板的列表
	 */
	public ActionForward add(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-add", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String templateId = request.getParameter("templateId");
			String name = request.getParameter("name");
			String mainModelName = request.getParameter("mainModelName");
			String templateName = request.getParameter("templateName");
			String cateType = request.getParameter("cateType");

			String settingId = request.getParameter("settingId");

			// 得到模板对应的自定义表单文件路径
			HQLInfo hqlInfoFormTemp = new HQLInfo();
			hqlInfoFormTemp.setSelectBlock("sysFormTemplate.fdFormFileName");
			hqlInfoFormTemp.setWhereBlock("sysFormTemplate.fdModelId=:fdModelId");
			hqlInfoFormTemp.setParameter("fdModelId", templateId);
			List<String> formTemplList = getSysFormTemplateServiceImp()
					.findValue(hqlInfoFormTemp);
			String fdFormFileName = "";
			if (!formTemplList.isEmpty()) {
				fdFormFileName = formTemplList.get(0);
				request.setAttribute("fdFormFileName", fdFormFileName);
			}
			// 如果对应的文档存在则跳转到编辑页面,注意还有传递相应的参数
			HQLInfo hqlInfoTemplateId = new HQLInfo();
			hqlInfoTemplateId.setSelectBlock("tibCommonMappingMain.fdId");
			hqlInfoTemplateId.setWhereBlock("tibCommonMappingMain.fdTemplateId=:fdTemplateId");
			hqlInfoTemplateId.setParameter("fdTemplateId", templateId);
			List<?> templateIdList = getServiceImp(request).findValue(hqlInfoTemplateId);
			if (templateIdList != null && !templateIdList.isEmpty()) {
				// 如果是edit，重定向的时候需要在url中传递中文，需要转换周中文字符编码
				name = URLEncoder.encode(name, "UTF-8");

				Map<String, String> parameters = new HashMap<String, String>();

				parameters.put("method", "edit");
				parameters.put("fdId", templateIdList.get(0).toString());
				parameters.put("name", name);
				parameters.put("templateId", templateId);
				parameters.put("mainModelName", mainModelName);
				parameters.put("fdFormFileName", fdFormFileName);
				parameters.put("templateName", templateName);
				parameters.put("settingId", settingId);
				parameters.put("cateType", cateType);
				String ps = parameterMap(parameters, "&");

				ActionForward actionForward = new ActionForward(
						"tibCommonMappingMain.do?" + ps);// 自定义表单路径

				actionForward.setRedirect(true);
				return actionForward;
			}
			ActionForm newForm = createNewForm(mapping, form, request, response);
			if (newForm != form)
				request.setAttribute(getFormName(newForm, request), newForm);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-add", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("edit", mapping, form, request, response);
		}
	}

	private String parameterMap(Map<String, String> parameters, String split) {
		StringBuffer buf = new StringBuffer();
		for (String key : parameters.keySet()) {
			if (buf.length() > 0) {
				buf.append(split);
			}
			buf.append(key + "=" + parameters.get(key));
		}
		return buf.toString();
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 *             用于转发到模块类别树的jsp页面
	 */
	public ActionForward forwardModuleCate(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		KmssMessages messages = new KmssMessages();
		try {

		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("moduleCate", mapping, form, request,
					response);
		}
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 *             用于显示模板列表
	 */
	public ActionForward listTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String parentId = request.getParameter("parentId");
			String templateName = request.getParameter("templateName");
			Page page = ((ITibCommonMappingMainService) getServiceImp(request))
					.listTemplate(parentId, templateName,
							buildTibCommonPageInfo(request));
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listTemplate", mapping, form, request,
					response);
		}
	}

	// 分页公共代码
	private TibCommonPageInfo buildTibCommonPageInfo(HttpServletRequest request)
			throws Exception {
		String s_pageno = request.getParameter("pageno");
		String s_rowsize = request.getParameter("rowsize");
		String ordertype = request.getParameter("ordertype");
		String orderby = request.getParameter("orderby");
		boolean isReserve = false;
		if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
			isReserve = true;
		}
		int pageno = 0;
		int rowsize = 0;
		if (s_pageno != null && s_pageno.length() > 0) {
			pageno = Integer.parseInt(s_pageno);
		}
		if (s_rowsize != null && s_rowsize.length() > 0) {
			rowsize = Integer.parseInt(s_rowsize);
		}
		if (isReserve)
			orderby += " desc";
		TibCommonPageInfo pageInfo = new TibCommonPageInfo();
		pageInfo.setPageno(pageno);
		pageInfo.setRowsize(rowsize);
		pageInfo.setOrderby(orderby);
		pageInfo.setOrdertype(ordertype);
		return pageInfo;
	}

	// 用于产生表单事件的jsp片段文件，现在只处理生成表单事件的jsp文件(已废除生成文件，改为存数据库)
	@SuppressWarnings("unchecked")
	private void generateJspFile(List fdFormEventFunctionListForms)
			throws Exception {
		for (Iterator iterator = fdFormEventFunctionListForms.iterator(); iterator
				.hasNext();) {
			TibCommonMappingFuncForm tibCommonMappingFuncForm = (TibCommonMappingFuncForm) iterator
					.next();
			String fdId = tibCommonMappingFuncForm.getFdId();

			String type = tibCommonMappingFuncForm.getFdIntegrationType();
			Map<String, String> pluginCfg = TibCommonMappingIntegrationPlugins
					.getConfigByType(type);
			if(pluginCfg==null){
				continue;
			}
			/*String path = pluginCfg.get(TibCommonMappingIntegrationPlugins.formEventPath);
			String filePath = ConfigLocationsUtil.getWebContentPath() + "/"
					+ pluginCfg.get(TibCommonMappingIntegrationPlugins.formEventPath);
			File formEventJsp = new File(filePath);
			if (!formEventJsp.exists()) {
				formEventJsp.mkdirs();
				if (logger.isDebugEnabled())
					logger.debug("文件夹不存在，创建：");
			}

			String fileName = fdId + ".jsp";
			tibCommonMappingFuncForm.setFormEventJspFilePath("/" + path + fileName);
			//File file = new File(filePath + fileName);
			String tmpCode = "<%@ page language=\"java\" contentType=\"text/html; charset=UTF-8\" pageEncoding=\"UTF-8\"%>";
			*/
			String funcName = pluginCfg
					.get(TibCommonMappingIntegrationPlugins.formEventFuncName);
			// 改为存实际值，存路径日后会移除
			String fdJspSegmentActual = "";
			// 兼容旧的数据,没有填写回调函数的时候
			if (tibCommonMappingFuncForm.getFdJspSegmen().indexOf(funcName + "()") > 0) {
				fdJspSegmentActual = tibCommonMappingFuncForm.getFdJspSegmen()
						.replace(funcName + "()", funcName + "('" + fdId + "')");
				//writeFile(file, tmpCode + fdJspSegmentActual);
			} else {
				// 有回调函数的时候 doWEB(action) 则转换成doWEB('fdid',action);
				fdJspSegmentActual = tibCommonMappingFuncForm.getFdJspSegmen()
						.replace(funcName + "(", funcName + "('" + fdId + "',");
				//writeFile(file, tmpCode + fdJspSegmentActual);
			}
			tibCommonMappingFuncForm.setFdJspSegmentActual(fdJspSegmentActual);
		}
	}

	@Override
	/*
	 * 重写更新方法，重写路径信息并更新表单事件jsp文件
	 */
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			generateJspFile(((TibCommonMappingMainForm) form)
					.getFdFormEventFunctionListForms());
			getServiceImp(request).update((IExtendForm) form,
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
			return getActionForward("edit", mapping, form, request, response);
		}
	}

	@Override
	/*
	 * 重写save方法，保存路径信息并生成表单事件jsp文件
	 */
	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-save", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			generateJspFile(((TibCommonMappingMainForm) form)
					.getFdFormEventFunctionListForms());
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
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("edit", mapping, form, request, response);
		}
	}

	/**
	 * 写文件
	 * 
	 * @param file
	 * @param content
	 */
	private void writeFile(File file, String content) {
		FileOutputStream out = null;
		Writer outWriter = null;
		try {
			out = new FileOutputStream(file);
			outWriter = new BufferedWriter(new OutputStreamWriter(out, "UTF-8"));
			IOUtils.write(content, outWriter);
		} catch (FileNotFoundException e) {
			throw new RuntimeException("写文件找不到文件错误", e);
		} catch (IOException e) {
			throw new RuntimeException("写文件错误", e);
		} finally {
			IOUtils.closeQuietly(outWriter);
			IOUtils.closeQuietly(out);
		}
	}

	// 查看流程模板
	public ActionForward redirectToTemplate(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		KmssMessages messages = new KmssMessages();
		String templateUrl = null;
		try {
			String fdModelName = request.getParameter("fdModelName");
			String fdModelId = request.getParameter("fdModelId");
			SysDictModel model = SysDataDict.getInstance()
					.getModel(fdModelName);
			templateUrl = model.getUrl();
			templateUrl = templateUrl.substring(0, templateUrl.indexOf("${"));
			templateUrl += fdModelId;
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
//			解决页面跳转问题
			request.setAttribute("redirectto", templateUrl);
			return mapping.findForward("redirect");
			//return (new ActionForward(templateUrl));
		}
	}
}
