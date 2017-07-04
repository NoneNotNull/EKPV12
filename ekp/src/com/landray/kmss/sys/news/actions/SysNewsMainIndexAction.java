package com.landray.kmss.sys.news.actions;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.SQLQuery;

import com.landray.kmss.common.actions.DataAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.news.model.SysNewsMain;
import com.landray.kmss.sys.news.service.ISysNewsMainService;
import com.landray.kmss.sys.news.service.ISysNewsTemplateService;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2013-10-31
 * 
 * @author 谭又豪
 */
public class SysNewsMainIndexAction extends DataAction {
	protected ISysNewsMainService sysNewsMainService;
	protected ISysNewsTemplateService sysNewsTemplateService;

	@Override
	protected IBaseService getCategoryServiceImp(HttpServletRequest request) {
		return (ISysSimpleCategoryService) getSysNewsTemplateService();
	}

	public ISysNewsTemplateService getSysNewsTemplateService() {
		if (sysNewsTemplateService == null)
			sysNewsTemplateService = (ISysNewsTemplateService) getBean("sysNewsTemplateService");
		return sysNewsTemplateService;
	}

	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (sysNewsMainService == null)
			sysNewsMainService = (ISysNewsMainService) getBean("sysNewsMainService");
		return sysNewsMainService;
	}

	protected String getParentProperty() {
		return "fdTemplate";
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		// 设置排序
		if (StringUtil.isNotNull(hqlInfo.getOrderBy())) {
			if (hqlInfo.getOrderBy().indexOf(";") > -1) {// 联合查询
				String[] ors = hqlInfo.getOrderBy().split(";");
				String order = "";
				if (hqlInfo.getOrderBy().indexOf("desc") > -1) {
					order = "sysNewsMain." + ors[0] + " desc," + "sysNewsMain."
							+ ors[1] + " desc," + "sysNewsMain." + ors[2];
				} else {
					order = "sysNewsMain." + ors[0] + ",sysNewsMain." + ors[1]
							+ ",sysNewsMain." + ors[2];
				}
				hqlInfo.setOrderBy(order);
			}
		}
		// 组装hql
		doBuildPersonAndZoneHql(request, hqlInfo);
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				SysNewsMain.class);

		List<HQLParameter> hqlParmeters = hqlInfo.getParameterList();
		String status = null;
		String top = null;
		for (int i = 0; i < hqlParmeters.size(); i++) {
			if (hqlParmeters.get(i).getName().equals("docStatus")) {
				status = hqlParmeters.get(i).getValue().toString();
			}
			if (hqlParmeters.get(i).getName().equals("fdIsTop")) {
				top = hqlParmeters.get(i).getValue().toString();
			}
		}
		request.setAttribute("docStatus", status);
		request.setAttribute("top", top);
	}

	// 重写list方法，主要是为了查询标签，提供给摘要视图
	@Override
	public ActionForward listChildren(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionForward forward = super.listChildren(mapping, form, request,
				response);

		// 查询标签机制中的标签
		Page p = (Page) request.getAttribute("queryPage");
		if (p != null) {
			List<SysNewsMain> list = p.getList();
			String fdIds = "";
			int i = 0;
			for (SysNewsMain sysNewsMain : list) {
				fdIds += i == 0 ? "'" + sysNewsMain.getFdId() + "'" : ",'"
						+ sysNewsMain.getFdId() + "'";
				i++;
			}
			JSONObject tagJson = new JSONObject();
			if (StringUtil.isNotNull(fdIds)) {
				IBaseDao baseDao = (IBaseDao) SpringBeanUtil
						.getBean("KmssBaseDao");
				String sql = "select m.fd_model_id,r.fd_tag_name from sys_tag_main_relation r left join sys_tag_main m on r.fd_main_id = m.fd_id where m.fd_model_id in ("
						+ fdIds + ")";
				SQLQuery query = baseDao.getHibernateSession().createSQLQuery(
						sql);
				for (Object obj : query.list()) {
					Object[] k = (Object[]) obj;
					String key = k[0].toString();
					if (tagJson.get(k[0]) != null) {
						tagJson
								.element(key, tagJson
										.getString(k[0].toString())
										+ " | "
										+ buildTagUrl(request, k[1].toString()));
					} else {
						tagJson.element(key, buildTagUrl(request, k[1]
								.toString()));
					}
				}
				request.setAttribute("tagJson", tagJson);
			}

		}
		return forward;
	}

	/**
	 * 组装标签链接
	 * 
	 * @param tagName
	 * @return
	 */
	public String buildTagUrl(HttpServletRequest request, String tagName)
			throws UnsupportedEncodingException {
		String preUrl = request.getContextPath();
		String htmlText;
		htmlText = "<a class=\"com_subject\" target=\"_blank\" href=\""
				+ preUrl
				+ "/sys/ftsearch/searchBuilder.do?method=search&modelName=SysNewsMain&searchFields=tag&newLUI=true&queryString="
				+ URLEncoder.encode(tagName, "UTF-8") + "\">" + tagName
				+ "</a>";
		return htmlText;
	}

	/**
	 * 组装个人中心hql
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void doBuildPersonAndZoneHql(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		String news = StringUtil.isNotNull(new CriteriaValue(request)
				.poll("myNews")) ? new CriteriaValue(request).poll("myNews")
				: new CriteriaValue(request).poll("taNews");
		String type = request.getParameter("type");
		String userId = StringUtil.isNotNull(type) && type.equals("person") ? UserUtil
				.getUser().getFdId()
				: request.getParameter("userId");
		if (StringUtil.isNotNull(news)) {
			String whereBlock = "1=1";
			// xx创建的
			if (news.equals("create")) {
				whereBlock += " and sysNewsMain.docCreator.fdId=:userId";
				hqlInfo.setParameter("userId", userId);
				hqlInfo.setWhereBlock(whereBlock);
				// xx点评的
			} else if (news.equals("ev")) {
				StringBuffer hqlBuffer = new StringBuffer();
				hqlBuffer.append("sysNewsMain.fdId in ");
				// 拼接子查询
				hqlBuffer
						.append("(select distinct sysEvaluationMain.fdModelId from ");
				hqlBuffer
						.append(" com.landray.kmss.sys.evaluation.model.SysEvaluationMain"
								+ " as sysEvaluationMain ");
				hqlBuffer
						.append("where sysEvaluationMain.fdModelName = :fdModelName ");
				hqlBuffer
						.append("and sysEvaluationMain.fdEvaluator.fdId = :fdEvaluatorId)");
				hqlInfo.setWhereBlock(hqlBuffer.toString());
				hqlInfo.setParameter("fdModelName",
						"com.landray.kmss.sys.news.model.SysNewsMain");
				hqlInfo.setParameter("fdEvaluatorId", userId);
				// 待xx审的
			} else if (news.equals("approval")) {
				SysFlowUtil
						.buildLimitBlockForMyApproval("sysNewsMain", hqlInfo);
				hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
						SysAuthConstant.AllCheck.NO);
				// xx审批的
			} else if (news.equals("approvaled")) {
				SysFlowUtil
						.buildLimitBlockForMyApproved("sysNewsMain", hqlInfo);
				hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
						SysAuthConstant.AllCheck.NO);
			}
		}
	}

	public ActionForward showKeydataUsed(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		KmssMessages messages = new KmssMessages();
		String whereBlock = "";
		String keydataIdStr = "";
		String keydataId = request.getParameter("keydataId");
		if (StringUtil.isNotNull(keydataId)) {
			keydataIdStr = " and kmKeydataUsed.keydataId = '" + keydataId + "'";
		}
		whereBlock += "sysNewsMain.fdId in (select kmKeydataUsed.modelId from com.landray.kmss.km.keydata.base.model.KmKeydataUsed kmKeydataUsed"
				+ " where kmKeydataUsed.formName='sysNewsMainForm'"
				+ keydataIdStr + ")";
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			String nodeType = request.getParameter("nodeType");

			if (StringUtil.isNull(nodeType))
				nodeType = "node";

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
			// if (checkAuth != null)
			// hqlInfo.setAuthCheckType(checkAuth);
			changeFindPageHQLInfo(request, hqlInfo);
			String whereBlockOri = hqlInfo.getWhereBlock();
			if (StringUtil.isNotNull(whereBlockOri)) {
				whereBlock = whereBlockOri + " and (" + whereBlock + ")";
			}
			hqlInfo.setWhereBlock(whereBlock);
			Page page = getServiceImp(request).findPage(hqlInfo);
			if (page != null) {
				List<SysNewsMain> list = page.getList();
				String fdIds = "";
				int i = 0;
				for (SysNewsMain sysNewsMain : list) {
					fdIds += i == 0 ? "'" + sysNewsMain.getFdId() + "'" : ",'"
							+ sysNewsMain.getFdId() + "'";
					i++;
				}
				JSONObject tagJson = new JSONObject();
				if (StringUtil.isNotNull(fdIds)) {
					IBaseDao baseDao = (IBaseDao) SpringBeanUtil
							.getBean("KmssBaseDao");
					String sql = "select m.fd_model_id,r.fd_tag_name from sys_tag_main_relation r left join sys_tag_main m on r.fd_main_id = m.fd_id where m.fd_model_id in ("
							+ fdIds + ")";
					SQLQuery query = baseDao.getHibernateSession()
							.createSQLQuery(sql);
					for (Object obj : query.list()) {
						Object[] k = (Object[]) obj;
						String key = k[0].toString();
						if (tagJson.get(k[0]) != null) {
							tagJson.element(key, tagJson.getString(k[0]
									.toString())
									+ " | "
									+ buildTagUrl(request, k[1].toString()));
						} else {
							tagJson.element(key, buildTagUrl(request, k[1]
									.toString()));
						}
					}
					request.setAttribute("tagJson", tagJson);
				}

			}
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return getActionForward("list", mapping, form, request, response);
		}
	}
}
