package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.common.service.spring.KmsBaseDataBeanService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;

public class KmsSelectedShowService extends KmsBaseDataBeanService{
	public JSON getSelectedDataJSON(RequestContext requestInfo) throws Exception {
		List<KmsMultidocKnowledge> latestDocList = new ArrayList<KmsMultidocKnowledge>();
		int rowsize = 10;
		String s_rowsize = requestInfo.getParameter("rowsize");
		String fdCategoryId = "";
		String fdCategoryName = requestInfo.getParameter("fdCategoryName");
		String ordertype = requestInfo.getParameter("ordertype");
		String orderby = requestInfo.getParameter("orderby");
		orderby += " desc";
		HQLInfo Info = new HQLInfo();
		Info.setParameter("fdname", fdCategoryName);
		Info.setWhereBlock("kmsMultidocTemplate.fdName=:fdname");
		List<KmsMultidocTemplate> list = kmsMultidocTemplateService.findPage(
				Info).getList();
		for (KmsMultidocTemplate knowledge : list) {
			fdCategoryId = knowledge.getFdId();
		}
		if (StringUtil.isNotNull(s_rowsize)) {
			rowsize = Integer.parseInt(s_rowsize);
		}

		if (StringUtil.isNotNull(s_rowsize)) {
			rowsize = Integer.parseInt(s_rowsize);
		}
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setPageNo(1);
		hqlInfo.setRowSize(rowsize);
		String whereBlock = "kmsMultidocKnowledge.docStatus = '"
				+ SysDocConstant.DOC_STATUS_PUBLISH
				+ "' and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion";
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock += " and kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like '%"
					+ fdCategoryId + "%'";
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderby);
		hqlInfo.setParameter("isNewVersion", true);
		hqlInfo.setGetCount(false);
		latestDocList = kmsMultidocKnowledgeService.findPage(hqlInfo).getList();
		JSONObject returnData = new JSONObject();
		JSONArray dataList = new JSONArray();
		for (int i = 0; i < latestDocList.size(); i++) {
			KmsMultidocKnowledge doc = latestDocList.get(i);
			JSONObject dataItem = new JSONObject();
			dataItem.accumulate("fdId", doc.getFdId());
			dataItem.accumulate("docSubject", doc.getDocSubject());
			if (doc.getDocAuthor() != null) {
				dataItem.put("docCreator", doc.getDocAuthor().getFdName());
			} else if (StringUtil.isNotNull(doc.getOuterAuthor())) {
				dataItem.put("docCreator", doc.getOuterAuthor());
			}
			dataItem.accumulate("docCreateTime", DateUtil.convertDateToString(
					doc.getDocCreateTime(), DateUtil.TYPE_DATE, requestInfo
							.getLocale()));
			dataItem.accumulate("docCategory", doc.getKmsMultidocTemplate()
					.getFdName());
			dataItem
					.accumulate(
							"docCategoryUrl",
							requestInfo.getContextPath()
									+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
									+ doc.getKmsMultidocTemplate().getFdId()
									+ "&filterType=template");
			dataItem
					.accumulate(
							"fdUrl",
							requestInfo.getContextPath()
									+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
									+ doc.getFdId());
			dataList.add(dataItem);
		}

		returnData.accumulate("docList", dataList);
		returnData.accumulate("selectId", fdCategoryId);
		return returnData;
	}
	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}
	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService = null;

	public void setkmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

}
