package com.landray.kmss.tib.sys.core.provider.actions;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.Session;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceForm;
import com.landray.kmss.tib.sys.core.provider.interfaces.ITibUnitInterface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * provider接口信息 Action
 * 
 * @author
 * @version 1.0 2013-03-27
 */
public class TibSysCoreIfaceAction extends ExtendAction {
	protected ITibSysCoreIfaceService tibSysCoreIfaceService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysCoreIfaceService == null)
			tibSysCoreIfaceService = (ITibSysCoreIfaceService) getBean("tibSysCoreIfaceService");
		return tibSysCoreIfaceService;
	}

	/**
	 * 进入数据执行页面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward dataExecute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		TibSysCoreIfaceForm rtnForm = null;
		try {
			String fdId = request.getParameter("fdId");
			TibSysCoreIface tibSysCoreIface = (TibSysCoreIface) getServiceImp(
					request).findByPrimaryKey(fdId);
			rtnForm = (TibSysCoreIfaceForm) getServiceImp(request)
					.convertModelToForm((IExtendForm) form, tibSysCoreIface,
							new RequestContext(request));
			request.setAttribute("fdIfaceXml", tibSysCoreIface.getFdIfaceXml());
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, rtnForm, request,
					response);
		} else {
			return getActionForward("dataExecute", mapping, rtnForm, request,
					response);
		}
	}

	public ActionForward dataExecuteAndBack(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		TimeCounter.logCurrentTime("Action-edit", true, getClass());
		KmssMessages messages = new KmssMessages();
		TibSysCoreIfaceForm rtnForm = null;
		try {
			String tibDataFill = request.getParameter("tibDataFill").trim();
			String executeBackXml = ((ITibSysCoreIfaceService) getServiceImp(request))
					.dataExecute(tibDataFill);
			request.setAttribute("executeBackXml", executeBackXml);
			String fdId = request.getParameter("fdId");
			TibSysCoreIface tibSysCoreIface = (TibSysCoreIface) getServiceImp(
					request).findByPrimaryKey(fdId);
			rtnForm = (TibSysCoreIfaceForm) getServiceImp(request)
					.convertModelToForm((IExtendForm) form, tibSysCoreIface,
							new RequestContext(request));
			request.setAttribute("ifaceRefData", tibSysCoreIface
					.getFdIfaceXml());
			request.setAttribute("tibDataFill", tibDataFill);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-edit", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, rtnForm, request,
					response);
		} else {
			return getActionForward("dataExecute", mapping, rtnForm, request,
					response);
		}
	}

	public ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-list", true, getClass());
		KmssMessages messages = new KmssMessages();
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
			int rowsize = SysConfigParameters.getRowSize();
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
			// 展示标签信息
			Session session = getServiceImp(request).getBaseDao()
					.getHibernateSession();
			String hql = "SELECT fdIfaceTag.fdId, fdIfaceTag.fdTagName, count(tibSysCoreIface.fdId) "
					+ "FROM com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface tibSysCoreIface "
					+ "right join  tibSysCoreIface.fdIfaceTags fdIfaceTag group by fdIfaceTag.fdTagName, fdIfaceTag.fdId";
			List<Object[]> list = session.createQuery(hql).list();
			// 查询其他标签
			String hql2 = "SELECT tibSysCoreIface.fdId "
					+ "FROM com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface tibSysCoreIface "
					+ "left join  tibSysCoreIface.fdIfaceTags fdIfaceTag where fdIfaceTag is null";
			int size = session.createQuery(hql2).list().size();
			list.add(new Object[] {
					"",
					ResourceUtil.getString("tibSysCoreTag.other",
							"tib-sys-core-provider"), size });
			request.setAttribute("list", list);
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("list", mapping, form, request, response);
		}
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String tag = request.getParameter("tag");
		if (StringUtil.isNotNull(tag)) {
			if (!tag.equals(ResourceUtil.getString("tibSysCoreTag.other",
					"tib-sys-core-provider"))) {
				hqlInfo
						.setWhereBlock(" tibSysCoreIface.fdIfaceTags.fdTagName = :tag");
				hqlInfo.setParameter("tag", tag);
			} else {
				hqlInfo.setFromBlock("TibSysCoreIface tibSysCoreIface");
				hqlInfo
						.setWhereBlock(" tibSysCoreIface.fdId not in (select tibSysCoreTag.tibSysCoreIfaces.fdId from TibSysCoreTag tibSysCoreTag)");
			}

		} else {
			hqlInfo.setFromBlock("TibSysCoreIface tibSysCoreIface");
		}
	}

	/**
	 * 获取tib接口清单
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getFunJson(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String countStr = request.getParameter("count");
		String key = request.getParameter("key");
		ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
		String returnJson = ifaceService.getIfaceJson(key, countStr);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(returnJson);
		return null;
	}

	/**
	 * 获取tib接口XML
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getFunXml(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String key = request.getParameter("key");
		ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
		String returnXml = ifaceService.getIfaceJsonXml(key);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(returnXml);
		return null;
	}

	/**
	 * 获取tib接口XML
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getFunBackXml(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String returnXml = "";
		String inXML = request.getParameter("inXML");
		ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
		if (StringUtil.isNotNull(inXML) && ifaceService.isControl(inXML)) {
			ITibUnitInterface tibUnitIface = (ITibUnitInterface) SpringBeanUtil
					.getBean("tibUnitInterface");
			returnXml = tibUnitIface.executeToStr(inXML);
		}
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(returnXml);
		return null;
	}

	/**
	 * 获取tib接口下所有实现Provider信息
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getImplList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String key = request.getParameter("key");
		ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
		String returnJson = ifaceService.getImplListJson(key);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(returnJson);
		return null;
	}

	/**
	 * 开始导入初始化数据
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward importInit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
			ifaceService.importInit();
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_RETURN).save(request);
			return mapping.findForward("failure");
		} else {
			return mapping.findForward("status");
		}
	}

	/**
	 * 回调接口xml，（接口实现中使用）
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward getIfaceXml(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		try {
			String ifaceId = request.getParameter("ifaceId");
			TibSysCoreIface tibSysCoreIface = (TibSysCoreIface) getServiceImp(
					request).findByPrimaryKey(ifaceId);
			String ifaceXml = tibSysCoreIface.getFdIfaceXml();
			out.print(ifaceXml);
		} catch (Exception e) {
			out.print("");
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将浏览器提交的表单数据更新到数据库中。<br>
	 * 该操作一般以HTTP的POST方式触发。
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return 执行成功，返回success页面，否则返回edit页面
	 * @throws Exception
	 */
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			TibSysCoreIfaceForm ifaceForm = (TibSysCoreIfaceForm) form;
			String fdId = ifaceForm.getFdId();
			TibSysCoreIface iface = (TibSysCoreIface) getServiceImp(request)
					.findByPrimaryKey(fdId);
			String oldIfaceXml = iface.getFdIfaceXml().trim();
			String newIfaceXml = ifaceForm.getFdIfaceXml().trim();
			// 接口xml有变动则提醒接口实现
			if (!oldIfaceXml.equals(newIfaceXml)) {
				ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
				ifaceService.updateImplIfaceXmlStatus(fdId);
			}
			getServiceImp(request).update(ifaceForm,
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
}
