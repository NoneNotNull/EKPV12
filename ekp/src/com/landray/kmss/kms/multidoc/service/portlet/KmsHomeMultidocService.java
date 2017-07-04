package com.landray.kmss.kms.multidoc.service.portlet;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONNull;
import net.sf.json.JSONObject;

import org.hibernate.Hibernate;
import org.hibernate.Query;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.common.annotations.HttpJSONP;
import com.landray.kmss.kms.common.service.spring.KmsBaseDataBeanService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocCount;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgePreService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.kms.multidoc.service.IRequestJSONP;
import com.landray.kmss.spi.interfaces.AbstractQueryBuilder;
import com.landray.kmss.spi.query.CriteriaBuilder;
import com.landray.kmss.spi.query.CriteriaQuery;
import com.landray.kmss.spi.query.QueryOrder;
import com.landray.kmss.spi.query.SearchType;
import com.landray.kmss.sys.property.ext.SysPropertySearch;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilter;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.sys.property.model.SysPropertyReference;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.sys.property.service.ISysPropertyFilterMainService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterSettingService;
import com.landray.kmss.sys.property.service.ISysPropertyReferenceService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

public class KmsHomeMultidocService extends KmsBaseDataBeanService implements
		IRequestJSONP {

	private ISysPropertyFilterMainService sysPropertyFilterMainService;

	public void setSysPropertyFilterMainService(
			ISysPropertyFilterMainService sysPropertyFilterMainService) {
		this.sysPropertyFilterMainService = sysPropertyFilterMainService;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService = null;

	public void setkmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	private ISysPropertyFilterSettingService sysPropertyFilterSettingService;

	public void setSysPropertyFilterSettingService(
			ISysPropertyFilterSettingService sysPropertyFilterSettingService) {
		this.sysPropertyFilterSettingService = sysPropertyFilterSettingService;
	}

	private ISysPropertyFilterService sysPropertyFilterService;

	public void setSysPropertyFilterService(
			ISysPropertyFilterService sysPropertyFilterService) {
		this.sysPropertyFilterService = sysPropertyFilterService;
	}

	private ISysPropertyReferenceService sysPropertyReferenceService;

	public void setSysPropertyReferenceService(
			ISysPropertyReferenceService sysPropertyReferenceService) {
		this.sysPropertyReferenceService = sysPropertyReferenceService;
	}

	private void pageParams(HttpServletRequest request, HQLInfo hqlInfo) {
		// 分页条件
		String s_pageno = request.getParameter("currentPage");
		String s_rowsize = request.getParameter("pageSize");
		String orderby = request.getParameter("sortOn");
		String ordertype = request.getParameter("sortBy");
		boolean isReserve = false;
		if (ordertype != null && ordertype.equalsIgnoreCase("DESC")) {
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

		if ("kmsMultidocTemplate".equals(orderby)) {
			orderby = "kmsMultidocTemplate.fdName";
		}
		if (isReserve)
			orderby += " desc";

		if (StringUtil.isNotNull(orderby)) {
			hqlInfo.setOrderBy("kmsMultidocKnowledge." + orderby);
		}
		hqlInfo.setPageNo(pageno);
		hqlInfo.setRowSize(rowsize);
	}

	public JSONObject findDoc(RequestContext requestInfo) throws Exception {
		if (SysPropertySearch.existExtendSearchService()) {
			return findDocInOther(requestInfo);
		} else {
			return findDocInDB(requestInfo);
		}
	}

	public JSONObject findDocInOther(RequestContext requestInfo)
			throws Exception {
		// 获取传递参数
		String templateId = requestInfo.getParameter("templateId");
		String filterIds = requestInfo.getRequest().getParameter("filterIds");
		// 构建查询条件对象
		CriteriaQuery query = new CriteriaQuery(KmsMultidocKnowledge.class);
		// 文档状态
		query.andQuery(CriteriaBuilder.buildQuery("docStatus", SearchType.EQ,
				"30"));
		// 文档版本
		query.andQuery(CriteriaBuilder.buildQuery("docIsNewVersion",
				SearchType.EQ, true));
		// 文档分类
		if (StringUtil.isNotNull(templateId)) {
			query.andQuery(CriteriaBuilder.buildQuery("kmsMultidocTemplate",
					SearchType.PREFIX, kmsMultidocTemplateService
							.findByPrimaryKey(templateId)));
		}
		JSONArray jsonArr = null;
		if (StringUtil.isNotNull(filterIds)) {
			jsonArr = JSONArray.fromObject(filterIds);
		} else {
			jsonArr = new JSONArray();
		}

		// 筛选条件
		for (int i = 0; i < jsonArr.size(); i++) {
			Object obj = jsonArr.get(i);
			if (obj instanceof JSONNull) {
				continue;
			} else {
				JSONObject json = (JSONObject) obj;
				String selectVal = (String) json.get("selectVal");
				String settingId = (String) json.get("settingId");
				String property = (String) json.get("property");
				String type = (String) json.get("type");
				if (StringUtil.isNull(selectVal)
						|| StringUtil.isNull(settingId)) {
					continue;
				} else {
					if (property.startsWith("property:")) {
						property = property.substring("property:".length());
					}
					// 还不支持between操作 改为>=和<=的方式
					if ("BT".equals(type)) {
						query.andQuery(CriteriaBuilder.buildQuery(property,
								SearchType.getTypeByString("ge"), selectVal
										.substring(0, selectVal.indexOf(";"))));
						query
								.andQuery(CriteriaBuilder.buildQuery(property,
										SearchType.getTypeByString("le"),
										selectVal.substring(selectVal
												.indexOf(";") + 1)));
					} else
						query.andQuery(CriteriaBuilder.buildQuery(property,
								SearchType.getTypeByString(type), selectVal));
				}
			}
		}
		HttpServletRequest request = requestInfo.getRequest();
		// page
		String s_pageno = request.getParameter("currentPage");
		String s_rowsize = request.getParameter("pageSize");
		String orderby = request.getParameter("sortOn");
		String ordertype = request.getParameter("sortBy");
		boolean isReserve = true;
		if (ordertype != null && ordertype.equalsIgnoreCase("ASC")) {
			isReserve = false;
		}
		if (StringUtil.isNull(orderby)) {
			orderby = "docCreateTime";
		}
		int pageno = 0;
		int rowsize = 0;
		if (s_pageno != null && s_pageno.length() > 0) {
			pageno = Integer.parseInt(s_pageno);
		}
		if (s_rowsize != null && s_rowsize.length() > 0) {
			rowsize = Integer.parseInt(s_rowsize);
		}

		if ("kmsMultidocTemplate".equals(orderby)) {
			orderby = "kmsMultidocTemplate.fdName";
		}
		// if (isReserve)
		// orderby += " desc";

		if (StringUtil.isNotNull(orderby)) {
			query.addOrder(new QueryOrder(orderby, isReserve));
		}
		query.setPageNo(pageno);
		query.setPageSize(rowsize);
		AbstractQueryBuilder.loadAuthInfo(query);
		Page results = SysPropertySearch.getExtendSearchService().searchPage(
				query);
		// page
		return processPage(results, requestInfo.getRequest().getContextPath());
	}

	// 点击顶部框内的筛选和点击筛选项的筛选
	public JSONObject findDocInDB(RequestContext requestInfo) throws Exception {
		boolean hasTemplate = false;
		String filterConfigId = requestInfo.getParameter("filterConfigId");
		String templateId = requestInfo.getParameter("templateId");
		String optionId = requestInfo.getParameter("optionId");
		// String propertyId = requestInfo.getParameter("propertyId");
		JSONObject rtnObj = null;

		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsMultidocKnowledge.docStatus = :docStatus and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion");
		hqlInfo.setParameter("docStatus",
				KmsMultidocKnowledge.DOC_STATUS_PUBLISH);
		hqlInfo.setParameter("isNewVersion", true);
		String whereBlock = hqlInfo.getWhereBlock();
		if (StringUtil.isNull(hqlInfo.getModelName())) {
			hqlInfo
					.setModelName("com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
		}
		// 由文档类型进入页面时
		KmsMultidocTemplate template = null;
		if (StringUtil.isNotNull(templateId)) {
			template = (KmsMultidocTemplate) kmsMultidocTemplateService
					.findByPrimaryKey(templateId);
			hasTemplate = true;
			whereBlock = StringUtil
					.linkString(
							whereBlock,
							" and ",
							" kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like :templateId or "
									+ "kmsMultidocKnowledge in (select elements(kmsMultidocTemplate.knowledges) "
									+ "from KmsMultidocTemplate kmsMultidocTemplate  where kmsMultidocTemplate.fdId=:templateId0)");
			hqlInfo.setParameter("templateId0", templateId);
			hqlInfo.setParameter("templateId", template.getFdHierarchyId()
					+ "%");
		}

		// 由筛选设置的进入页面时
		if (StringUtil.isNotNull(filterConfigId)) {
			// 下面代码可能可以优化
			String filterSettingId = sysPropertyFilterMainService
					.findFirstFilterId(filterConfigId);
			rtnObj = new JSONObject();
			rtnObj.put("selectVal", optionId);
			rtnObj.put("settingId", filterSettingId);
		}
		String filterIds = requestInfo.getRequest().getParameter("filterIds");
		JSONArray jsonArr = JSONArray.fromObject(filterIds);
		if (rtnObj != null)
			jsonArr.add(rtnObj);
		requestInfo.getRequest().setAttribute("filterIds", jsonArr.toString());
		hqlInfo.setWhereBlock(whereBlock);
		Page results = null;
		// 点击筛选项
		// 带筛选过滤条件，有分类模板
		if (hasTemplate) {
			// 查找本类下，包含之类的文档
			if (template.getSysPropertyTemplate() != null) {
				// 查找出所有子类的模板ID,
				List<KmsMultidocTemplate> temps = kmsMultidocTemplateService
						.findChildrenAll(template);
				// idLists为该分类下所有子类的模板Id列表
				List<String> idLists = new ArrayList<String>();
				for (int i = 0; i < temps.size(); i++) {
					if (temps.get(i).getSysPropertyTemplate() != null) {
						idLists.add(temps.get(i).getSysPropertyTemplate()
								.getFdId());
					}
				}
				// 修改hqlInfo
				sysPropertyFilterService.filterHQLInfo(template
						.getSysPropertyTemplate(), requestInfo, hqlInfo,
						idLists);
			}
		} else { // 找所有的属性模板
			sysPropertyFilterService.filterHQLInfo(null, requestInfo, hqlInfo,
					null);
		}
		hqlInfo.setOrderBy("docCreateTime desc");
		this.pageParams(requestInfo.getRequest(), hqlInfo); // 分页条件设置
		results = kmsMultidocKnowledgeService.findPage(hqlInfo);
		return processPage(results, requestInfo.getRequest().getContextPath());
	}

	private JSONObject processPage(Page results, String contextPath) {
		JSONObject obj = new JSONObject();
		JSONArray rets = new JSONArray();
		JSONObject item = null;
		for (int i = 0; i < results.getList().size(); i++) {
			if (results.getList().get(i) instanceof HashMap) {
				HashMap row = (HashMap) results.getList().get(i);
				item = new JSONObject();
				if (row.get("_totalhits") != null) {
					continue;
				}
				item.put("fdId", row.get("fdId"));
				item.put("docSubject", StringUtil.XMLEscape(row.get(
						"docSubject").toString()));
				item.put("kmsMultidocTemplate", StringUtil.XMLEscape(row.get(
						"kmsMultidocTemplate.fdName").toString()));
				item.put("docCreator", row.get("docCreator.fdName").toString());
				String createTime = DateUtil.convertDateToString(DateUtil
						.convertStringToDate(row.get("docCreateTime")
								.toString(), "yyyy-MM-hh"), "yyyy-MM-hh");
				item.put("docCreateTime", createTime);
				item.put("docScore", row.get("docScore") == null ? "" : row
						.get("docScore").toString());
				item.put("docReadCount", row.get("docReadCount").toString());
				item.put("docDept", row.get("docDept.fdName") == null ? ""
						: row.get("docDept.fdName").toString());
				item
						.put(
								"fdUrl",
								contextPath
										+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
										+ row.get("fdId"));
				rets.add(item);
			} else {
				KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) results
						.getList().get(i);
				item = new JSONObject();
				item.put("fdId", kmsMultidocKnowledge.getFdId());
				item.put("docSubject", StringUtil
						.XMLEscape(kmsMultidocKnowledge.getDocSubject()));
				item
						.put(
								"kmsMultidocTemplate",
								StringUtil
										.XMLEscape(kmsMultidocKnowledge
												.getKmsMultidocTemplate() != null ? kmsMultidocKnowledge
												.getKmsMultidocTemplate()
												.getFdName()
												: ""));
				item.put("docCreator", kmsMultidocKnowledge.getDocCreator()
						.getFdName());
				item.put("docCreateTime", DateUtil.convertDateToString(
						kmsMultidocKnowledge.getDocCreateTime(), "yyyy-MM-dd"));
				item.put("docScore", kmsMultidocKnowledge.getDocScore());
				item
						.put("docReadCount", kmsMultidocKnowledge
								.getDocReadCount());
				item
						.put(
								"docDept",
								kmsMultidocKnowledge.getDocDept() != null ? kmsMultidocKnowledge
										.getDocDept().getFdName()
										: "");
				item.put("fdUrl", contextPath
						+ ModelUtil.getModelUrl(kmsMultidocKnowledge));
				rets.add(item);
			}
		}
		obj.put("data", rets);
		obj.put("total", results.getTotalrows());
		return obj;
	}

	// 对比 listB 所有元素是否都在ListA里出现过，是=true 否=false
	private boolean compareList(List<SysPropertyFilter> listA,
			List<SysPropertyFilterSetting> listB) {
		if (listA == null || listA.isEmpty() || listB == null
				|| listB.isEmpty())
			return false;
		else {
			List<SysPropertyFilterSetting> tempList = new ArrayList<SysPropertyFilterSetting>();
			for (SysPropertyFilterSetting filter : listB) {
				for (SysPropertyFilter settingA : listA) {
					if (filter.getFdId().equals(
							settingA.getFdFilterSetting().getFdId())) {
						tempList.add(filter);
						break;
					}
				}
			}
			if (tempList.size() == listB.size())
				return true;
			else
				return false;
		}
	}

	private String findInSql(List list) {
		if (!list.isEmpty()) {
			StringBuffer sb = new StringBuffer("('0'");
			for (int i = 0; i < list.size(); i++) {
				String id = (String) list.get(i);
				sb.append(",'" + id + "'");
			}
			sb.append(")");
			return sb.toString();
		} else
			return "";
	}

	/*
	 * 得到 文档数量(包括其子类文档数量)
	 */
	public JSONObject calculateDocCount(RequestContext requestContext)
			throws Exception {
		JSONObject jsonObj = new JSONObject();
		String optionId = requestContext.getParameter("optionId");// 筛选项ID
		String filterConfigId = requestContext.getParameter("filterConfigId");// 配置项ID
		String templateId = requestContext.getParameter("templateId"); // 筛选项的可选项ID

		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("count(*)");
		hqlInfo.setWhereBlock("kmsMultidocKnowledge.docStatus="
				+ KmsMultidocKnowledge.DOC_STATUS_PUBLISH
				+ " and kmsMultidocKnowledge.docIsNewVersion = true");
		String whereBlock = hqlInfo.getWhereBlock();

		if (StringUtil.isNotNull(templateId)) {
			KmsMultidocTemplate template = (KmsMultidocTemplate) kmsMultidocTemplateService
					.findByPrimaryKey(templateId);
			whereBlock = StringUtil
					.linkString(whereBlock, " and",
							"  kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like :templateId");
			hqlInfo.setParameter("templateId", template.getFdHierarchyId()
					+ "%");
			hqlInfo.setWhereBlock(whereBlock);
			List<?> results = kmsMultidocKnowledgeService.findList(hqlInfo);
			if (!results.isEmpty()) {
				int n = ((Long) results.get(0)).intValue();
				jsonObj.put("count", String.valueOf(n));
				return jsonObj;
			}
		}

		if (StringUtil.isNotNull(filterConfigId)) {
			String filterSettingId = sysPropertyFilterMainService
					.findFirstFilterId(filterConfigId);
			SysPropertyFilterSetting filter = (SysPropertyFilterSetting) sysPropertyFilterSettingService
					.findByPrimaryKey(filterSettingId);
			SysPropertyDefine define = filter.getFdDefine();

			if (define == null) {// 固有属性
				String propertyName = filter.getFdPropertyName();
				if (propertyName.equals("docPublishTime")
						&& StringUtil.isNotNull(optionId)) {// 按年度
					whereBlock = StringUtil
							.linkString(whereBlock, " and",
									" year(kmsMultidocKnowledge.docPublishTime) = :year");
					hqlInfo.setParameter("year", Integer.valueOf(optionId));
				}
				if (propertyName.equals("docDept")
						&& StringUtil.isNotNull(optionId)) {// 按部门
					whereBlock = StringUtil.linkString(whereBlock, " and",
							"  kmsMultidocKnowledge.docDept.fdId = :orgId");
					hqlInfo.setParameter("orgId", optionId);
				}
				if (propertyName.equals("docPosts")
						&& StringUtil.isNotNull(optionId)) {// 按岗位
					whereBlock = StringUtil.linkString(whereBlock, " and",
							"  kmsMultidocKnowledge.docPosts.fdId = :postId");
					hqlInfo.setParameter("postId", optionId);
				}
				/**
				 * if (propertyName.endsWith("docProperties") &&
				 * StringUtil.isNotNull(optionId)) { // 辅类别 whereBlock =
				 * StringUtil .linkString(whereBlock, " and ",
				 * "kmsMultidocKnowledge.docProperties.fdId = :propertyId");
				 * hqlInfo.setParameter("propertyId", optionId); }
				 **/

				hqlInfo.setWhereBlock(whereBlock);
				List<?> results = kmsMultidocKnowledgeService.findList(hqlInfo);
				if (!results.isEmpty()) {
					int n = ((Long) results.get(0)).intValue();
					jsonObj.put("count", String.valueOf(n));
					return jsonObj;
				}

			} else { // 自定义属性
				// 根据filterId得到属性定义
				// 根据属性引用表，得到其中使用这个属性的的模板
				// 得到上述模板，也就得到存放属性值的表 ekp_prop_133aa6386180cb88aecdc
				// 再根据此属性的值，(关联查询)查找ekp_prop_133aa6386180cb88aecdc相应字段是否有此值，用Like
				// 累计
				String filedName = define.getFdStructureName();
				List<SysPropertyReference> referenceList = sysPropertyReferenceService
						.findList("fdDefine.fdId='" + define.getFdId() + "'",
								null);
				List<SysPropertyTemplate> templateList = new ArrayList<SysPropertyTemplate>();
				for (SysPropertyReference reference : referenceList) {
					templateList.add(reference.getFdTemplate());
				}
				int num = 0;
				if (!templateList.isEmpty()) {
					for (SysPropertyTemplate template : templateList) {
						String tId = template.getFdId();
						String s = "";
						String tableName = "ekp_prop_" + tId.substring(0, 21);
						if (define.getFdDisplayType().equals("tree")) { // 自定义树
							s = "select fd_id from sys_property_tree "
									+ " where  fd_hierarchy_id  like :hierarchyId";
							Query query = sysPropertyReferenceService
									.getBaseDao().getHibernateSession()
									.createSQLQuery(s);
							query
									.setString("hierarchyId", "%" + optionId
											+ "%");
							//
							String ids = findInSql(query.list());
							s = "select count(*) from " + tableName + " where "
									+ filedName + " in " + ids;
						} else {
							s = "select count(*) from " + tableName + " where "
									+ filedName + " like '%" + optionId + "%'";

						}
						Query query = sysPropertyReferenceService.getBaseDao()
								.getHibernateSession().createSQLQuery(s);
						Object o = query.list().get(0);
						if (o instanceof Integer) // sqlserver
							num = ((Integer) query.list().get(0)).intValue()
									+ num;
						if (o instanceof BigInteger) // mysql
							num = ((BigInteger) query.list().get(0)).intValue()
									+ num;

					}
				}

				jsonObj.put("count", num);
				return jsonObj;
			}
		}
		jsonObj.put("count", "0");
		return jsonObj;
	}

	public JSONArray findPopDoc(RequestContext requestContext) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String templateId = requestContext.getParameter("templateId");
		if (StringUtil.isNotNull(templateId)) {
			KmsMultidocTemplate template = (KmsMultidocTemplate) kmsMultidocTemplateService
					.findByPrimaryKey(templateId);
			hqlInfo
					.setWhereBlock("kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like :templateId");
			hqlInfo.setParameter("templateId", template.getFdHierarchyId()
					+ "%");
		}
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docReadCount DESC");
		hqlInfo.setRowSize(10);
		hqlInfo.setGetCount(false);
		JSONArray jsonArray = new JSONArray();
		List<?> res = kmsMultidocKnowledgeService.findPage(hqlInfo).getList();
		for (int i = 0; i < res.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) res
					.get(i);
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("docSubject", StringUtil.XMLEscape(kmsMultidocKnowledge
					.getDocSubject()));
			jsonObj.put("fdUrl", requestContext.getRequest().getContextPath()
					+ ModelUtil.getModelUrl(kmsMultidocKnowledge));
			jsonObj.put("docCreator", StringUtil.XMLEscape(kmsMultidocKnowledge
					.getDocCreator().getFdName()));
			jsonObj.put("docReadCount", kmsMultidocKnowledge.getDocReadCount());
			jsonArray.add(jsonObj);
		}
		return jsonArray;
	}

	/*
	 * 最新知识portlet
	 */
	@HttpJSONP
	public JSON findNewsetKnowledge(RequestContext requestInfo)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsMultidocKnowledge.docStatus = :docStatus and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion");
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docCreateTime DESC");
		hqlInfo.setParameter("docStatus",
				KmsMultidocKnowledge.DOC_STATUS_PUBLISH);
		hqlInfo.setParameter("isNewVersion", true);
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setGetCount(false);
		List<?> resultList = kmsMultidocKnowledgeService.findPage(hqlInfo)
				.getList();
		JSONArray returnObject = new JSONArray();
		JSONObject json = new JSONObject();
		for (int i = 0; i < resultList.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) resultList
					.get(i);
			JSONObject returnValue = new JSONObject();
			returnValue.put("text", StringUtil.XMLEscape(kmsMultidocKnowledge
					.getDocSubject()));
			if (kmsMultidocKnowledge.getDocAuthor() != null) {
				returnValue.put("creator", kmsMultidocKnowledge.getDocAuthor()
						.getFdName());
			} else if (StringUtil.isNotNull(kmsMultidocKnowledge
					.getOuterAuthor())) {
				returnValue.put("creator", kmsMultidocKnowledge
						.getOuterAuthor());
			}
			returnValue.put("created", com.landray.kmss.util.DateUtil
					.convertDateToString(kmsMultidocKnowledge
							.getDocCreateTime(), "date", requestInfo
							.getLocale()));
			returnValue.put("templateName", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getKmsMultidocTemplate()
							.getFdName()));
			String templateNameUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
					+ kmsMultidocKnowledge.getKmsMultidocTemplate().getFdId()
					+ "&filterType=template";
			String href = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			returnValue.put("href", href);
			returnValue.put("templateNameUrl", templateNameUrl);
			// returnValue.put("isNew", 8);
			returnObject.add(returnValue);
		}
		json.accumulate("newestKnowledges", returnObject);
		return json;
	}

	// 知识阅读排行
	@HttpJSONP
	public JSON findKnowledgeSortByReadCount(RequestContext requestInfo)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String ordertype = requestInfo.getParameter("ordertype");
		String orderby = requestInfo.getParameter("orderby");
		boolean isReserve = false;
		if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
			isReserve = true;
		}
		if (isReserve)
			orderby += " desc";
		hqlInfo.setRowSize(rowsize);
		String whereBlock = "kmsMultidocKnowledge.docStatus = :docStatus and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion";
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock += " and kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like '%"
					+ fdCategoryId + "%'";
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderby);
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		hqlInfo.setParameter("isNewVersion", true);
		hqlInfo.setGetCount(false);
		List<?> resultList = kmsMultidocKnowledgeService.findPage(hqlInfo)
				.getList();
		JSONArray returnObject = new JSONArray();
		JSONObject json = new JSONObject();
		for (int i = 0; i < resultList.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) resultList
					.get(i);
			JSONObject returnValue = new JSONObject();
			returnValue.put("docSubject", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getDocSubject()));
			returnValue.put("docCreateTime", com.landray.kmss.util.DateUtil
					.convertDateToString(kmsMultidocKnowledge
							.getDocCreateTime(), "yyyy-MM-dd"));
			if (kmsMultidocKnowledge.getDocAuthor() != null) {
				returnValue.put("docCreator", kmsMultidocKnowledge
						.getDocAuthor().getFdName());
			} else if (StringUtil.isNotNull(kmsMultidocKnowledge
					.getOuterAuthor())) {
				returnValue.put("docCreator", kmsMultidocKnowledge
						.getOuterAuthor());
			}
			returnValue
					.put("readCount", kmsMultidocKnowledge.getDocReadCount());
			returnValue.put("docCategory", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getKmsMultidocTemplate()
							.getFdName()));
			String fdUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			String templateNameUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
					+ kmsMultidocKnowledge.getKmsMultidocTemplate().getFdId()
					+ "&filterType=template";
			returnValue.put("docCategoryUrl", templateNameUrl);
			returnValue.put("fdUrl", fdUrl);
			returnObject.add(returnValue);
		}
		json.put("docList", returnObject);
		return json;
	}

	// 知识点评排行
	@HttpJSONP
	public JSON findKnowledgeSortByEvaluation(RequestContext requestInfo)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String ordertype = requestInfo.getParameter("ordertype");
		String orderby = requestInfo.getParameter("orderby");
		boolean isReserve = false;
		if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
			isReserve = true;
		}
		if (isReserve)
			orderby += " desc";
		hqlInfo.setRowSize(rowsize);
		String whereBlock = "kmsMultidocKnowledge.docStatus = :docStatus and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion";
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock += " and kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like '%"
					+ fdCategoryId + "%'";
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderby);
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		hqlInfo.setParameter("isNewVersion", true);
		hqlInfo.setGetCount(false);
		List<?> resultList = kmsMultidocKnowledgeService.findPage(hqlInfo)
				.getList();
		JSONArray returnObject = new JSONArray();
		JSONObject json = new JSONObject();

		for (int i = 0; i < resultList.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) resultList
					.get(i);
			JSONObject returnValue = new JSONObject();
			returnValue.put("docSubject", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getDocSubject()));
			if (kmsMultidocKnowledge.getDocAuthor() != null) {
				returnValue.put("docCreator", kmsMultidocKnowledge
						.getDocAuthor().getFdName());
			} else if (StringUtil.isNotNull(kmsMultidocKnowledge
					.getOuterAuthor())) {
				returnValue.put("docCreator", kmsMultidocKnowledge
						.getOuterAuthor());
			}
			returnValue.put("docCreateTime", com.landray.kmss.util.DateUtil
					.convertDateToString(kmsMultidocKnowledge
							.getDocCreateTime(), "date", requestInfo
							.getLocale()));
			returnValue.put("docCategory", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getKmsMultidocTemplate()
							.getFdName()));
			String fdUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			String docCategoryUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
					+ kmsMultidocKnowledge.getKmsMultidocTemplate().getFdId()
					+ "&filterType=template";
			returnValue.put("docCategoryUrl", docCategoryUrl);
			returnValue.put("fdUrl", fdUrl);
			returnValue.put("score", kmsMultidocKnowledge.getDocScore());
			returnObject.add(returnValue);
		}
		json.accumulate("docList", returnObject);
		return json;
	}

	// 知识推荐排行
	@HttpJSONP
	public JSON findKnowledgeSortByIntroduce(RequestContext requestInfo)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String ordertype = requestInfo.getParameter("ordertype");
		String orderby = requestInfo.getParameter("orderby");
		boolean isReserve = false;
		if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
			isReserve = true;
		}
		if (isReserve)
			orderby += " desc";
		hqlInfo.setRowSize(rowsize);
		String whereBlock = "kmsMultidocKnowledge.docStatus = :docStatus and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion and kmsMultidocKnowledge.fdId in (select intro.fdModelId from com.landray.kmss.sys.introduce.model.SysIntroduceMain intro where intro.fdIntroduceToEssence is true and intro.fdModelName = :fdModelName)";
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock += " and kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like :fdCategoryId";
			hqlInfo.setParameter("fdCategoryId", "%" + fdCategoryId + "%");
		}
		hqlInfo.setGetCount(false);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderby);
		hqlInfo.setParameter("docStatus", SysDocConstant.DOC_STATUS_PUBLISH);
		hqlInfo.setParameter("isNewVersion", true);
		hqlInfo.setParameter("fdModelName",
				"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
		List<?> resultList = kmsMultidocKnowledgeService.findPage(hqlInfo)
				.getList();
		JSONArray returnObject = new JSONArray();
		JSONObject json = new JSONObject();

		for (int i = 0; i < resultList.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) resultList
					.get(i);
			JSONObject returnValue = new JSONObject();
			returnValue.put("docSubject", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getDocSubject()));
			if (kmsMultidocKnowledge.getDocAuthor() != null) {
				returnValue.put("docCreator", kmsMultidocKnowledge
						.getDocAuthor().getFdName());
			} else if (StringUtil.isNotNull(kmsMultidocKnowledge
					.getOuterAuthor())) {
				returnValue.put("docCreator", kmsMultidocKnowledge
						.getOuterAuthor());
			}
			returnValue.put("docCreateTime", com.landray.kmss.util.DateUtil
					.convertDateToString(kmsMultidocKnowledge
							.getDocCreateTime(), "date", requestInfo
							.getLocale()));
			returnValue.put("docCategory", StringUtil
					.XMLEscape(kmsMultidocKnowledge.getKmsMultidocTemplate()
							.getFdName()));
			String fdUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			String docCategoryUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
					+ kmsMultidocKnowledge.getKmsMultidocTemplate().getFdId()
					+ "&filterType=template";
			returnValue.put("docCategoryUrl", docCategoryUrl);
			returnValue.put("fdUrl", fdUrl);
			// returnValue.put("score", kmsMultidocKnowledge.getDocScore());
			returnValue.put("introCount", kmsMultidocKnowledge
					.getDocIntrCount());
			returnObject.add(returnValue);
		}
		json.accumulate("docList", returnObject);
		return json;
	}

	/*
	 * 推荐知识portlet
	 */
	public JSONArray findIntroducedKnowledge(RequestContext requestInfo)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsMultidocKnowledge.docStatus = :docStatus and KmsMultidocKnowledge.docIsIntroduced = true");
		hqlInfo.setParameter("docStatus", "30");
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docCreateTime DESC");
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setGetCount(false);
		List<?> resultList = kmsMultidocKnowledgeService.findPage(hqlInfo)
				.getList();
		JSONArray returnObject = new JSONArray();
		for (int i = 0; i < resultList.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) resultList
					.get(i);
			JSONObject returnValue = new JSONObject();
			returnValue.put("text", StringUtil.XMLEscape(kmsMultidocKnowledge
					.getDocSubject()));
			returnValue.put("creator", kmsMultidocKnowledge.getDocAuthor()
					.getFdName());
			returnValue.put("created", com.landray.kmss.util.DateUtil
					.convertDateToString(kmsMultidocKnowledge
							.getDocCreateTime(), "date", requestInfo
							.getLocale()));
			String href = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			String templateNameUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
					+ kmsMultidocKnowledge.getKmsMultidocTemplate().getFdId()
					+ "&filterType=template";
			returnValue.put("templateNameUrl", templateNameUrl);
			returnValue.put("href", href);
			returnValue.put("isNew", 8);
			returnObject.add(returnValue);
		}
		return returnObject;
	}

	/*
	 * 根据分类ID查找知识文档
	 */
	public JSONArray findMultidocByTemplateId(RequestContext requestInfo,
			String fdTemplateId) throws Exception {

		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsMultidocKnowledge.docStatus = :docStatus "
						+ "and kmsMultidocKnowledge.kmsMultidocTemplate.fdId = :fdTemplateId");
		hqlInfo.setParameter("fdTemplateId", fdTemplateId);
		hqlInfo.setParameter("docStatus", "30");
		hqlInfo.setOrderBy("KmsMultidocKnowledge.docCreateTime DESC");
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setGetCount(false);
		List<?> resultList = kmsMultidocKnowledgeService.findPage(hqlInfo)
				.getList();
		JSONArray returnObject = new JSONArray();
		for (int i = 0; i < resultList.size(); i++) {
			KmsMultidocKnowledge kmsMultidocKnowledge = (KmsMultidocKnowledge) resultList
					.get(i);
			JSONObject returnValue = new JSONObject();
			returnValue.put("text", StringUtil.XMLEscape(kmsMultidocKnowledge
					.getDocSubject()));
			if (kmsMultidocKnowledge.getDocAuthor() != null) {
				returnValue.put("creator", kmsMultidocKnowledge.getDocAuthor()
						.getFdName());
			} else if (StringUtil.isNotNull(kmsMultidocKnowledge
					.getOuterAuthor())) {
				returnValue.put("creator", kmsMultidocKnowledge
						.getOuterAuthor());
			}
			returnValue.put("created", DateUtil.convertDateToString(
					kmsMultidocKnowledge.getDocCreateTime(), "yyyy-MM-dd"));
			String href = requestInfo.getContextPath()
					+ "/kms/multidoc/km_multidoc_knowledge/KmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			returnValue.put("href", href);
			returnObject.add(returnValue);
		}
		return returnObject;
	}

	// 多维知识库主页概览
	@HttpJSONP
	public JSON updateMultidocPreview(RequestContext requestInfo)
			throws Exception {
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		JSONObject json = new JSONObject();
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String content = kmsMultidocKnowledgePreService.updatePre(fdCategoryId);
		Boolean more = true;
		String s_more = requestInfo.getParameter("more");
		if (StringUtil.isNotNull(s_more)) {
			more = Boolean.parseBoolean(s_more);
		}
		jsonObject.put("content", content);
		jsonArray.add(jsonObject);
		json.accumulate("jsonArray", jsonArray);
		json.accumulate("more", more);
		json.accumulate("fdCategoryId", fdCategoryId);
		return json;
	}

	/**
	 * 多维库知识数定时任务
	 * 
	 * @return
	 * @throws Exception
	 */
	public void updateDocCount() throws Exception {

		KmsMultidocCount kmsMultidocCount = new KmsMultidocCount();
		List<Map> list = kmsMultidocCount.getKmaBaseAppConfigs();
		int len = list.size();
		for (Map map : list) {
			kmsMultidocCount.setDataMap(map);
			updateDocCountDetail(kmsMultidocCount);
		}
	}

	/**
	 * 统计更新
	 * 
	 * @param kmsMultidocCount
	 * @throws Exception
	 */
	private void updateDocCountDetail(KmsMultidocCount kmsMultidocCount)
			throws Exception {

		Date preDate = DateUtil.getDate(0);
		Date nowDate = DateUtil.getDate(1);
		HQLInfo hql = new HQLInfo();
		hql.setSelectBlock("count(*)");
		String authAreaId = kmsMultidocCount.getAuthAreaId();
		hql.setCheckParam(SysAuthConstant.CheckType.AreaSpecified, authAreaId);
		hql.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
				SysAuthConstant.AuthCheck.SYS_NONE);

		// 统计总数
		String whereBlock = "kmsMultidocKnowledge.docStatus="
				+ SysDocConstant.DOC_STATUS_PUBLISH
				+ " and kmsMultidocKnowledge.docIsNewVersion = true";
		hql.setWhereBlock(whereBlock);
		Long totalCount = (Long) kmsMultidocKnowledgeService.findValue(hql)
				.get(0);

		// 统计推荐
		whereBlock = "kmsMultidocKnowledge.docIntrCount > 0 and kmsMultidocKnowledge.docStatus="
				+ SysDocConstant.DOC_STATUS_PUBLISH;
		hql.setWhereBlock(whereBlock);
		Long introCount = (Long) kmsMultidocKnowledgeService.findValue(hql)
				.get(0);

		// 统计今日更新
		whereBlock = "kmsMultidocKnowledge.docAlterTime >=:preDate and kmsMultidocKnowledge.docAlterTime <:nowDate and kmsMultidocKnowledge.docStatus="
				+ SysDocConstant.DOC_STATUS_PUBLISH;
		hql.setWhereBlock(whereBlock);
		hql.setParameter("preDate", preDate, Hibernate.TIMESTAMP);
		hql.setParameter("nowDate", nowDate, Hibernate.TIMESTAMP);
		Long updateTodayCount = (Long) kmsMultidocKnowledgeService.findValue(
				hql).get(0);

		kmsMultidocCount.setIntroTotalCount(introCount.toString());
		kmsMultidocCount.setTotalCount(totalCount.toString());
		kmsMultidocCount.setUpdateTodayCount(updateTodayCount.toString());
		kmsMultidocCount.save();

	}

	/**
	 * 页面获取知识数
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public JSON getCount(RequestContext request) throws Exception {
		JSONObject jsonObject = new JSONObject();
		KmsMultidocCount kmsMultidocCount = new KmsMultidocCount();
		Map map = kmsMultidocCount.getDataMap();

		if (map.isEmpty()) {
			String authAreaId = UserUtil.getKMSSUser().getAuthAreaId();
			kmsMultidocCount.setAuthAreaId(authAreaId);
			updateDocCountDetail(kmsMultidocCount);
			map = kmsMultidocCount.getDataMap();
		}
		jsonObject = JSONObject.fromObject(map);
		return jsonObject;
	}

	private IKmsMultidocKnowledgePreService kmsMultidocKnowledgePreService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public void setKmsMultidocKnowledgePreService(
			IKmsMultidocKnowledgePreService kmsMultidocKnowledgePreService) {
		this.kmsMultidocKnowledgePreService = kmsMultidocKnowledgePreService;
	}

	public String getFilterIdByTemplateId(String templateId) throws Exception {
		boolean flag = false;
		String filterId = null;
		if (StringUtil.isNotNull(templateId)) {
			KmsMultidocTemplate template = (KmsMultidocTemplate) kmsMultidocTemplateService
					.findByPrimaryKey(templateId);
			if (template != null) {
				SysPropertyTemplate sysTemplate = template
						.getSysPropertyTemplate();
				if (sysTemplate == null) {
					flag = true;
				} else {
					List<SysPropertyFilter> filterList = sysPropertyFilterService
							.findList("fdTemplate.fdId='"
									+ sysTemplate.getFdId() + "'", null);
					if (filterList.isEmpty()) {
						flag = true;
					} else {
						for (SysPropertyFilter filter : filterList) {
							SysPropertyFilterSetting setting = filter
									.getFdFilterSetting();
							if (setting.getFdModelName() != null
									&& setting.getFdPropertyName() != null) {
								if (setting.getFdModelName().equals(
										"kmsMultidocTemplate")
										&& setting
												.getFdPropertyName()
												.equals(
														"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge")) {
									filterId = setting.getFdId();
									break;
								}
							}
						}
						if (filterId == null)
							flag = true;
					}
				}
			}
			if (flag) {
				List<SysPropertyFilterSetting> list = sysPropertyFilterSettingService
						.findList(
								"fdPropertyName='kmsMultidocTemplate' and fdIsEnabled='1' and fdModelName='com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge'",
								null);
				if (!list.isEmpty()) {
					SysPropertyFilterSetting setting = (SysPropertyFilterSetting) list
							.get(0);
					filterId = setting.getFdId();
				}
			}
		}

		return filterId;
	}

}
