package com.landray.kmss.km.doc.actions;

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
import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.service.IKmDocKnowledgeService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

public class KmDocKnowledgeIndexAction extends DataAction {
	protected IKmDocKnowledgeService kmDocKnowledgeService;
	protected IKmDocTemplateService kmDocTemplateService;

	@Override
	protected String getParentProperty() {
		return "kmDocTemplate";
	}

	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmDocKnowledgeService == null)
			kmDocKnowledgeService = (IKmDocKnowledgeService) getBean("kmDocKnowledgeService");
		return kmDocKnowledgeService;
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		StringBuilder hql = new StringBuilder(
				" kmDocKnowledge.docIsNewVersion=1 ");
		CriteriaValue cv = new CriteriaValue(request);
		String docProperties = cv.poll("docProperties");
		if (StringUtil.isNotNull(docProperties)) {
			hql
					.append(" and kmDocKnowledge.docProperties.fdId = :docProperties");
			hqlInfo.setParameter("docProperties", docProperties);
		}
		hqlInfo.setWhereBlock(hql.toString());
		CriteriaUtil.buildHql(cv, hqlInfo, KmDocKnowledge.class);
		buildHomeZoneHql(cv, hqlInfo, request);
	}

	private void buildHomeZoneHql(CriteriaValue cv, HQLInfo hqlInfo,
			HttpServletRequest request) {

		// create edit comment recommend
		String self = cv.poll("selfdoc");
		String tadoc = cv.poll("tadoc");
		boolean isSelfDoc = StringUtil.isNotNull(self);
		String mydoc = isSelfDoc ? self : tadoc;
		String userId = isSelfDoc ? UserUtil.getUser().getFdId() : request
				.getParameter("userid");

		if (StringUtil.isNull(userId) || StringUtil.isNull(mydoc)) {
			return;
		}
		String whereStr = hqlInfo.getWhereBlock();
		StringBuilder where = new StringBuilder(
				StringUtil.isNull(whereStr) ? "1=1 " : whereStr);

		if (StringUtil.isNotNull(mydoc)) {
			mydoc = mydoc.toLowerCase();
			if ("create".equals(mydoc)) {
				where.append(" and kmDocKnowledge.docCreator.fdId=:docCreator");
				hqlInfo.setParameter("docCreator", userId);

			} else if ("author".equals(mydoc)) {
				where.append(" and kmDocKnowledge.docAuthor.fdId=:docAuthor");
				hqlInfo.setParameter("docAuthor", userId);

			} else if ("evaluation".equals(mydoc)) {
				StringBuffer buff = new StringBuffer();
				if (StringUtil.isNotNull(hqlInfo.getJoinBlock())) {
					buff.append(hqlInfo.getJoinBlock());
				}
				buff
						.append(", com.landray.kmss.sys.evaluation.model.SysEvaluationMain sysEvaluationMain ");
				hqlInfo.setJoinBlock(buff.toString());

				where
						.append(" and sysEvaluationMain.fdModelId = kmDocKnowledge.fdId and sysEvaluationMain.fdEvaluator.fdId=:fdEvaluator");
				where.append(" and kmDocKnowledge.docStatus='30'");
				hqlInfo.setParameter("fdEvaluator", userId);
			} else if ("introduce".equals(mydoc)) {
				StringBuffer buff = new StringBuffer();
				if (StringUtil.isNotNull(hqlInfo.getJoinBlock())) {
					buff.append(hqlInfo.getJoinBlock());
				}
				buff
						.append(", com.landray.kmss.sys.introduce.model.SysIntroduceMain sysIntroduceMain ");
				hqlInfo.setJoinBlock(buff.toString());

				where
						.append(" and sysIntroduceMain.fdModelId = kmDocKnowledge.fdId and sysIntroduceMain.fdIntroducer.fdId=:fdIntroducer");
				where.append(" and kmDocKnowledge.docStatus='30'");
				hqlInfo.setParameter("fdIntroducer", userId);
			}

			// 多表联合查询无法排序处理
			if ("evaluation".equals(mydoc) || "introduce".equals(mydoc)) {
				String orderBy = hqlInfo.getOrderBy();
				if (orderBy.contains(".")) {
					hqlInfo.setOrderBy(orderBy);
				} else {
					hqlInfo.setOrderBy(" kmDocKnowledge." + orderBy);
				}
			}
		}
		hqlInfo.setWhereBlock(where.toString());

	}

	// 重写SimpleCategoryNodeAction中的listChildren方法、manageList方法和listChildrenBase方法
	@Override
	public ActionForward listChildren(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return listChildrenBase(mapping, form, request, response,
				"listChildren", null);
	}

	private ActionForward listChildrenBase(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, String forwordPage, String checkAuth)
			throws Exception {
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			String parentId = request.getParameter("categoryId");
			String s_IsShowAll = request.getParameter("isShowAll");
			String excepteIds = request.getParameter("excepteIds");
			boolean isShowAll = true;
			if (StringUtil.isNotNull(s_IsShowAll)
					&& s_IsShowAll.equals("false"))
				isShowAll = false;
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
			if (checkAuth != null)
				hqlInfo.setAuthCheckType(checkAuth);
			changeFindPageHQLInfo(request, hqlInfo);
			// 插入搜索条件查询语句
			// changeSearchInfoFindPageHQLInfo(request, hqlInfo);
			String whereBlock = hqlInfo.getWhereBlock();
			if (!StringUtil.isNull(parentId)) {
				if (StringUtil.isNull(whereBlock))
					whereBlock = "";
				else
					whereBlock = "(" + whereBlock + ") and ";
				String tableName = ModelUtil.getModelTableName(getServiceImp(
						request).getModelName());
				if (isShowAll) {
					IBaseTreeModel treeModel = (IBaseTreeModel) getCategoryServiceImp(
							request).findByPrimaryKey(parentId);

					if (StringUtil.isNull(treeModel.getFdHierarchyId())) {
						whereBlock += tableName + "." + getParentProperty()
								+ ".fdId=:_treeFdId";
						hqlInfo.setParameter("_treeFdId", treeModel.getFdId());
					} else {
						// whereBlock += "substring(" + tableName + "."
						// + getParentProperty() + ".fdHierarchyId,1,"
						// + treeModel.getFdHierarchyId().length()
						// + ")= :treeHierarchyId";
						whereBlock += tableName + "." + getParentProperty()
								+ ".fdHierarchyId like :_treeHierarchyId";
						hqlInfo.setParameter("_treeHierarchyId", treeModel
								.getFdHierarchyId()
								+ "%");
					}
				} else {
					whereBlock += tableName + "." + getParentProperty()
							+ ".fdId=:_treeParentId";
					hqlInfo.setParameter("_treeParentId", parentId);
				}
				if (StringUtil.isNotNull(excepteIds)) {
					whereBlock += " and "
							+ HQLUtil.buildLogicIN(tableName + ".fdId not",
									ArrayUtil.convertArrayToList(excepteIds
											.split("\\s*[;,]\\s*")));
				}
				if (("manageList").equals(forwordPage)) {
					whereBlock += " and " + tableName
							+ ".docStatus <> :_treeDocStatus";
					hqlInfo.setParameter("_treeDocStatus",
							SysDocConstant.DOC_STATUS_DRAFT);
				}
			}
			hqlInfo.setWhereBlock(whereBlock);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);

			// 查询标签机制中的标签
			List<KmDocKnowledge> list = page.getList();
			String fdIds = "";
			int i = 0;
			for (KmDocKnowledge kmDocKnowledge : list) {
				fdIds += i == 0 ? "'" + kmDocKnowledge.getFdId() + "'" : ",'"
						+ kmDocKnowledge.getFdId() + "'";
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

		} catch (Exception e) {
			messages.addError(e);
		}
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return mapping.findForward("failure");
		} else {
			return getActionForward(forwordPage, mapping, form, request,
					response);
		}
	}

	/**
	 * 组装标签链接
	 * 
	 * @param tagName
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public String buildTagUrl(HttpServletRequest request, String tagName)
			throws UnsupportedEncodingException {
		String preUrl = request.getContextPath();
		String htmlText = "<a class=\"com_subject\" target=\"_blank\" href=\""
				+ preUrl
				+ "/sys/ftsearch/searchBuilder.do?method=search&modelName=KmDocKnowledge&searchFields=tag&newLUI=true&queryString="
				+ URLEncoder.encode(tagName, "UTF-8") + "\">" + tagName
				+ "</a>";
		return htmlText;
	}

	@Override
	protected IBaseService getCategoryServiceImp(HttpServletRequest request) {
		if (kmDocTemplateService == null)
			kmDocTemplateService = (IKmDocTemplateService) getBean("kmDocTemplateService");
		return kmDocTemplateService;
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
		whereBlock += "kmDocKnowledge.fdId in (select kmKeydataUsed.modelId from com.landray.kmss.km.keydata.base.model.KmKeydataUsed kmKeydataUsed"
				+ " where kmKeydataUsed.formName='kmDocKnowledgeForm'"
				+ keydataIdStr + ")";
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
			String whereBlockOri = hqlInfo.getWhereBlock();
			if (StringUtil.isNotNull(whereBlockOri)) {
				whereBlock = whereBlockOri + " and (" + whereBlock + ")";
			}
			hqlInfo.setWhereBlock(whereBlock);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);

			List<KmDocKnowledge> list = page.getList();
			String fdIds = "";
			int i = 0;
			for (KmDocKnowledge kmDocKnowledge : list) {
				fdIds += i == 0 ? "'" + kmDocKnowledge.getFdId() + "'" : ",'"
						+ kmDocKnowledge.getFdId() + "'";
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

		} catch (Exception e) {
			messages.addError(e);
		}

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listChildren", mapping, form, request,
					response);
		}
	}
}
