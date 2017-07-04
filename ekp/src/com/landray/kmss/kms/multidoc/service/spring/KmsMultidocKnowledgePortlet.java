package com.landray.kmss.kms.multidoc.service.spring;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.sys.workflow.interfaces.SysFlowUtil;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 我的流程portlet(所有发布的文档、我创建的文档、待我审批的文档、我已审批的文档)
 * 
 */
public class KmsMultidocKnowledgePortlet implements IXMLDataBean {
	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	protected IKmsMultidocTemplateService kmsMultidocTemplateService;

	private Log logger = LogFactory.getLog(this.getClass());

	public List getDataList(RequestContext requestInfo) throws Exception {
		String para = requestInfo.getParameter("rowsize");
		String type = requestInfo.getParameter("type");
		int rowsize = 10;
		if (!StringUtil.isNull(para)) {
			rowsize = Integer.parseInt(para);
		}
		HQLInfo hqlInfo = new HQLInfo();
		this.getFindPageHqlInfo(requestInfo, hqlInfo);
		if ("executed".equals(type)) {// 我已审批的文档
			SysFlowUtil.buildLimitBlockForMyApproved("kmsMultidocKnowledge",
					hqlInfo);
		} else if ("unExecuted".equals(type)) {// 待我审批的文档
			SysFlowUtil.buildLimitBlockForMyApproval("kmsMultidocKnowledge",
					hqlInfo);
		}
		hqlInfo
				.setOrderBy("kmsMultidocKnowledge.docAlterTime desc,kmsMultidocKnowledge.docPublishTime desc,kmsMultidocKnowledge.docCreateTime desc");
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setGetCount(false);
		List rtnList = kmsMultidocKnowledgeService.findPage(hqlInfo).getList();
		logger.debug("rtnList.size()=" + rtnList.size());
		for (int i = 0; i < rtnList.size(); i++) {
			KmsMultidocKnowledge knowledge = (KmsMultidocKnowledge) rtnList
					.get(i);
			Map map = new HashMap();
			map.put("text", knowledge.getDocSubject());
			map.put("created", DateUtil.convertDateToString(knowledge
					.getDocCreateTime(), DateUtil.TYPE_DATE, requestInfo
					.getLocale()));
			map.put("creator", knowledge.getDocCreator().getFdName());
			StringBuffer sb = new StringBuffer();
			sb
					.append("/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view");
			// sb.append("&parentId="
			// + knowledge.getDocCategoryMain().getHbmParent().getFdId());
			sb.append("&fdId=" + knowledge.getFdId());
			map.put("href", sb.toString());
			map.put("id", knowledge.getFdId());
			rtnList.set(i, map);
		}
		return rtnList;
	}

	private void getFindPageHqlInfo(RequestContext requestInfo, HQLInfo hqlInfo)
			throws Exception {
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String type = requestInfo.getParameter("type");
		String whereBlock = "";
		// 所有发布的文档（默认）
		if (StringUtil.isNull(type)) {
			whereBlock = "kmsMultidocKnowledge.docStatus ="
					+ SysDocConstant.DOC_STATUS_PUBLISH;
		} else if ("iDrafted".equals(type)) {// 我创建的文档
			whereBlock = StringUtil.linkString(whereBlock, " and ",
					"kmsMultidocKnowledge.docCreator.fdId = :docCreator");
			hqlInfo.setParameter("docCreator", UserUtil.getUser().getFdId());
		}
		// 选择的分类
		String templateProperty = "kmsMultidocKnowledge.kmsMultidocTemplate";
		if (!StringUtil.isNull(fdCategoryId)) {
			ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) kmsMultidocTemplateService
					.findByPrimaryKey(fdCategoryId);
			whereBlock = SimpleCategoryUtil.buildChildrenWhereBlock(category,
					templateProperty, whereBlock);
		}
		hqlInfo.setWhereBlock(whereBlock);
	}

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

}
