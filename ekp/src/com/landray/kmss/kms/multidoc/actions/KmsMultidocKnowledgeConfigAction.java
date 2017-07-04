package com.landray.kmss.kms.multidoc.actions;

import java.util.Arrays;
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
import com.landray.kmss.kms.multidoc.forms.KmsMultidocKnowledgeConfigForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgeConfig;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.kms.multidoc.util.KmsMultidocKnowledgeUtil;
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
public class KmsMultidocKnowledgeConfigAction extends BaseAction {

	private ISysAppConfigService sysAppConfigService;

	public ISysAppConfigService getSysAppConfigService() {
		if (sysAppConfigService == null)
			sysAppConfigService = (ISysAppConfigService) getBean("sysAppConfigService");
		return sysAppConfigService;
	}

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public IKmsMultidocTemplateService getKmsMultidocTemplateService() {
		if (kmsMultidocTemplateService == null)
			kmsMultidocTemplateService = (IKmsMultidocTemplateService) getBean("kmsMultidocTemplateService");
		return kmsMultidocTemplateService;
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
			KmsMultidocKnowledgeConfigForm configForm = (KmsMultidocKnowledgeConfigForm) form;
			String whereBlock = "sysAppConfig.fdKey = :sysAppConfigKey and sysAppConfig.fdField = 'fdCategoryIds'";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setParameter("sysAppConfigKey",
					"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgeConfig_"
							+ UserUtil.getUser().getFdId());
			List list = getSysAppConfigService().findList(hqlInfo);
			if (!list.isEmpty()) {
				SysAppConfig config = (SysAppConfig) list.get(0);
				String templateId = KmsMultidocKnowledgeUtil
						.replaceToSQLString(config.getFdValue());
				List templateIds = Arrays.asList(config.getFdValue().split(
						"\r\n"));
				String templateNames = "";
				if (StringUtil.isNotNull(templateId)) {
					// 不用findByPrimaryKeys(ids)的原因是考虑到某用户常用文档模板里面有某个模板可能被删除掉，而找不到的情况。
					HQLInfo hqlInfo1 = new HQLInfo();
					hqlInfo1
							.setWhereBlock("kmsMultidocTemplate.fdId in(:templateIds)");
					hqlInfo1.setParameter("templateIds", templateIds);
					List<KmsMultidocTemplate> temList = getKmsMultidocTemplateService()
							.findList(hqlInfo1);
					// 实现用户原有的排序
					String[] ids = config.getFdValue().split("\r\n");
					Map map = new HashMap();
					for (KmsMultidocTemplate template : temList) {
						map.put(template.getFdId(), template.getFdName());
					}
					templateId = "";
					for (int i = 0; i < ids.length; i++) {
						String name = (String) map.get(ids[i]);
						if (StringUtil.isNotNull(name)) {
							templateId = StringUtil.linkString(templateId,
									"\r\n", ids[i]);
							templateNames = StringUtil.linkString(
									templateNames, ";", name);
						}
					}
				}
				configForm.setFdCategoryIds(templateId);
				configForm.setFdCategoryNames(templateNames);
			}
			request.setAttribute("kmsMultidocKnowledgeConfigForm", configForm);
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
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			Page page = null;
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
			HQLInfo hqlInfo = new HQLInfo();
			String whereBlock = "sysAppConfig.fdKey =:sysAppConfigKey and sysAppConfig.fdField = 'fdCategoryIds'";
			hqlInfo.setParameter("sysAppConfigKey",
					"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgeConfig_"
							+ UserUtil.getUser().getFdId());
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
			HQLInfo hql = new HQLInfo();
			if (StringUtil.isNotNull(fdCategoryIds)) {
				hql.setWhereBlock("kmsMultidocTemplate.fdId in (:templateId)");
				hql.setParameter("templateId", Arrays.asList(fdCategoryIds
						.split("\r\n")));
			}
			hql.setOrderBy(orderby);
			hql.setPageNo(pageno);
			hql.setRowSize(rowsize);
			page = getKmsMultidocTemplateService().findPage(hql);
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
			KmsMultidocKnowledgeConfigForm configForm = (KmsMultidocKnowledgeConfigForm) form;
			KmsMultidocKnowledgeConfig config = new KmsMultidocKnowledgeConfig();
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
