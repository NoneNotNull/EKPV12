package com.landray.kmss.km.doc.service.spring;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.service.IKmDocKnowledgeService;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.sys.portal.util.PortletTimeUtil;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmDocKnowledgePortlet implements IXMLDataBean {
	protected IKmDocKnowledgeService kmDocKnowledgeService;

	protected IKmDocTemplateService kmDocTemplateService;

	private Log logger = LogFactory.getLog(this.getClass());

	public List getDataList(RequestContext requestInfo) throws Exception {
		String showIntroduced = requestInfo.getParameter("showIntroduced");

		String para = requestInfo.getParameter("rowsize");
		String type = requestInfo.getParameter("type");
		int rowsize = 10;
		if (!StringUtil.isNull(para))
			rowsize = Integer.parseInt(para);
		HQLInfo hqlInfo = new HQLInfo();
		String whereBlock = this.getFindPageWhereBlock(requestInfo, hqlInfo);
		hqlInfo.setWhereBlock(whereBlock);
		if ("executed".equals(type)) {// 我已审批的文档
			SysFlowUtil.buildLimitBlockForMyApproved("kmDocKnowledge", hqlInfo);
		} else if ("unExecuted".equals(type)) {// 待我审批的文档
			SysFlowUtil.buildLimitBlockForMyApproval("kmDocKnowledge", hqlInfo);
		}
		// 时间范围参数
		String scope = requestInfo.getParameter("scope");
		if (StringUtil.isNotNull(scope) && !scope.equals("no")) {
			String block = hqlInfo.getWhereBlock();
			if (StringUtil.isNull(type)) {// 最新知识
				hqlInfo.setWhereBlock(StringUtil.linkString(block, " and ",
						"kmDocKnowledge.docPublishTime > :fdStartTime"));
			} else {// 我的知识
				hqlInfo.setWhereBlock(StringUtil.linkString(block, " and ",
						"kmDocKnowledge.docCreateTime > :fdStartTime"));
			}
			hqlInfo.setParameter("fdStartTime", PortletTimeUtil
					.getDateByScope(scope));
		}
		hqlInfo
				.setOrderBy("kmDocKnowledge.docPublishTime desc,kmDocKnowledge.docAlterTime desc,kmDocKnowledge.docCreateTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setGetCount(false);
		List rtnList = kmDocKnowledgeService.findPage(hqlInfo).getList();
		logger.debug("rtnList.size()=" + rtnList.size());
		for (int i = 0; i < rtnList.size(); i++) {
			KmDocKnowledge knowledge = (KmDocKnowledge) rtnList.get(i);
			Map map = new HashMap();
			if ("true".equals(showIntroduced)) {
				if (knowledge.getDocIsIntroduced() != null
						&& knowledge.getDocIsIntroduced()) {
					map.put("isintroduced", true);
				}
			}
			map.put("catename", knowledge.getKmDocTemplate().getFdName());
			map.put("catehref", "/km/doc/?categoryId="
					+ knowledge.getKmDocTemplate().getFdId());
			map.put("text", knowledge.getDocSubject());
			map.put("created", DateUtil.convertDateToString(knowledge
					.getDocPublishTime(), DateUtil.TYPE_DATE, requestInfo
					.getLocale()));
			/*
			 * map.put("publishTime", DateUtil.convertDateToString(knowledge
			 * .getDocPublishTime(), DateUtil.TYPE_DATE, requestInfo
			 * .getLocale()));
			 */
			map.put("creator", knowledge.getDocCreator().getFdName());
			StringBuffer sb = new StringBuffer();
			sb.append("/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view");
			// sb.append("&parentId="
			// + knowledge.getDocCategoryMain().getHbmParent().getFdId());
			sb.append("&fdId=" + knowledge.getFdId());
			map.put("href", sb.toString());
			map.put("id", knowledge.getFdId());
			rtnList.set(i, map);
		}
		return rtnList;
	}

	private String getFindPageWhereBlock(RequestContext requestInfo,
			HQLInfo hqlInfo) throws Exception {
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String type = requestInfo.getParameter("type");
		// 增加查询条件，为新版本时才显示
		String whereBlock = "kmDocKnowledge.docIsNewVersion = 1";
		// 所有发布的文档（默认）
		if (StringUtil.isNull(type)) {
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docStatus = :docStatus");
			hqlInfo
					.setParameter("docStatus",
							SysDocConstant.DOC_STATUS_PUBLISH);
		} else if ("iDrafted".equals(type)) {// 我创建的文档
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmDocKnowledge.docCreator.fdId =:docCreatorId");
			hqlInfo.setParameter("docCreatorId", UserUtil.getUser().getFdId());
		}
		// 选择的分类
		String templateProperty = "kmDocKnowledge.kmDocTemplate";
		if (!StringUtil.isNull(fdCategoryId)) {
			ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) kmDocTemplateService
					.findByPrimaryKey(fdCategoryId);
			whereBlock = SimpleCategoryUtil.buildChildrenWhereBlock(category,
					templateProperty, whereBlock);
		}
		return whereBlock;
	}

	public void setKmDocKnowledgeService(
			IKmDocKnowledgeService kmDocKnowledgeService) {
		this.kmDocKnowledgeService = kmDocKnowledgeService;
	}

	public void setKmDocTemplateService(
			IKmDocTemplateService kmDocTemplateService) {
		this.kmDocTemplateService = kmDocTemplateService;
	}

}