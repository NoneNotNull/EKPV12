package com.landray.kmss.km.doc.actions;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.BaseAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.km.doc.forms.KmDocKnowledgeConfigForm;
import com.landray.kmss.km.doc.model.KmDocKnowledgeConfig;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.km.doc.util.KmDocKnowlegeUtil;
import com.landray.kmss.sys.appconfig.model.SysAppConfig;
import com.landray.kmss.sys.appconfig.service.ISysAppConfigService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2010-六月-13
 * 
 * @author zhuangwl 我的常用文档目录配置
 */
public class KmDocKnowledgeConfigAction extends BaseAction {

	private ISysAppConfigService sysAppConfigService;

	public ISysAppConfigService getSysAppConfigService() {
		if (sysAppConfigService == null)
			sysAppConfigService = (ISysAppConfigService) getBean("sysAppConfigService");
		return sysAppConfigService;
	}

	private IKmDocTemplateService kmDocTemplateService;

	public IKmDocTemplateService getKmDocTemplateService() {
		if (kmDocTemplateService == null)
			kmDocTemplateService = (IKmDocTemplateService) getBean("kmDocTemplateService");
		return kmDocTemplateService;
	}

	/**
	 * 我的常用文档目录配置页面。<br>
	 * 该操作一般以HTTP的GET方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回edit页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			KmDocKnowledgeConfigForm configForm = (KmDocKnowledgeConfigForm) form;
			String whereBlock = "sysAppConfig.fdKey = 'com.landray.kmss.km.doc.model.KmDocKnowledgeConfig_"
					+ UserUtil.getUser().getFdId() + "'";
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					" sysAppConfig.fdField = 'fdCategoryIds'");
			List list = getSysAppConfigService().findList(whereBlock, null);
			if (!list.isEmpty()) {
				SysAppConfig config = (SysAppConfig) list.get(0);
				String templateIds = KmDocKnowlegeUtil
						.replaceToSQLString(config.getFdValue());
				String templateNames = "";
				if (StringUtil.isNotNull(templateIds)) {
					// 不用findByPrimaryKeys(ids)的原因是考虑到某用户常用文档模板里面有某个模板可能被删除掉，而找不到的情况。
					List<KmDocTemplate> temList = getKmDocTemplateService()
							.findList(
									"kmDocTemplate.fdId in(" + templateIds
											+ ")", null);
					// 实现用户原有的排序
					String[] ids = config.getFdValue().split("\r\n");
					Map map = new HashMap();
					for (KmDocTemplate template : temList) {
						map.put(template.getFdId(), template.getFdName());
					}
					templateIds = "";
					for (int i = 0; i < ids.length; i++) {
						String name = (String) map.get(ids[i]);
						if (StringUtil.isNotNull(name)) {
							templateIds = StringUtil.linkString(templateIds,
									"\r\n", ids[i]);
							templateNames = StringUtil.linkString(
									templateNames, ";", name);
						}
					}
				}
				configForm.setFdCategoryIds(templateIds);
				configForm.setFdCategoryNames(templateNames);
			}
			request.setAttribute("kmDocKnowledgeConfigForm", configForm);
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return mapping.findForward("edit");
		}
	}

	/**
	 * 打开列表页面。<br>
	 * 该操作一般以HTTP的GET方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回list页面，否则返回failure页面
	 * @throws Exception
	 */
	public ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		Page page = new Page();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
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

			String fdCategoryIds = "";
			String whereBlock = "sysAppConfig.fdKey = 'com.landray.kmss.km.doc.model.KmDocKnowledgeConfig_"
					+ UserUtil.getUser().getFdId() + "'";
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					" sysAppConfig.fdField = 'fdCategoryIds'");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setRowSize(rowsize);
			hqlInfo.setPageNo(1);
			Page appConfigPage = getSysAppConfigService().findPage(hqlInfo);
			List list = appConfigPage.getList();
			if (!list.isEmpty()) {
				SysAppConfig config = (SysAppConfig) list.get(0);
				fdCategoryIds = config.getFdValue();
			}

			if (StringUtil.isNull(fdCategoryIds)) {
				page = Page.getEmptyPage();
				request.setAttribute("queryPage", page);
				return mapping.findForward("list");
			}
			String sqlString = KmDocKnowlegeUtil
					.replaceToSQLString(fdCategoryIds);

			String whereBlockDocTemplate = "";
			if (StringUtil.isNotNull(sqlString)) {
				whereBlockDocTemplate = "kmDocTemplate.fdId in (" + sqlString
						+ ")";
			}
			page = getKmDocTemplateService().findPage(whereBlockDocTemplate,
					orderby, pageno, rowsize);

			request.setAttribute("queryPage", page);

		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return mapping.findForward("list");
		}
	}

	/**
	 * 保存我的常用文档目录且转向我的常用文档目录配置页面。<br>
	 * 该操作一般以HTTP的POST方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回success页面，否则返回manage页面
	 * @throws Exception
	 */
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			KmDocKnowledgeConfigForm configForm = (KmDocKnowledgeConfigForm) form;
			KmDocKnowledgeConfig config = new KmDocKnowledgeConfig();
			config.setFdCategoryIds(configForm.getFdCategoryIds());
			config.save();
		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return mapping.findForward("edit");
		} else {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("success");
		}
	}

}
