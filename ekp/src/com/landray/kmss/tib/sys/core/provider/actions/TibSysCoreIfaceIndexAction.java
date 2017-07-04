package com.landray.kmss.tib.sys.core.provider.actions;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.Session;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * provider接口信息 Action
 * 
 * @author
 * @version 1.0 2013-03-27
 */
public class TibSysCoreIfaceIndexAction extends ExtendAction {
	protected ITibSysCoreIfaceService tibSysCoreIfaceService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysCoreIfaceService == null)
			tibSysCoreIfaceService = (ITibSysCoreIfaceService) getBean("tibSysCoreIfaceService");
		return tibSysCoreIfaceService;
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
		String tag = request.getParameter("q.tag");
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
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSysCoreIface.class);
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
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		KmssMessages messages = new KmssMessages();
		try {
			ITibSysCoreIfaceService ifaceService = (ITibSysCoreIfaceService) getServiceImp(request);
			ifaceService.importInit();
		} catch (Exception e) {
			messages.addError(e);
		}

		return null;
	}

	public ActionForward getLui_source(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-index", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {

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
			JSONArray array = new JSONArray();
			for (int i = 0; i < list.size(); i++) {
				Object[] objs = list.get(i);
				JSONObject obj = new JSONObject();
				// obj.put("text", objs[1] + "(<font color='blue'>" + objs[2] + "</font>)");
				obj.put("text", objs[1] + "(" + objs[2] + ")");
				obj.put("value", objs[1]);
				array.add(obj);
			}
			request.setAttribute("lui-source", array);

		} catch (Exception e) {
			messages.addError(e);
			e.printStackTrace();
		}

		TimeCounter.logCurrentTime("Action-index", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}
}
