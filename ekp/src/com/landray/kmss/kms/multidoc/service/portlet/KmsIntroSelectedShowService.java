package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.common.annotations.HttpJSONP;
import com.landray.kmss.kms.common.service.spring.KmsBaseDataBeanService;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.util.StringUtil;

public class KmsIntroSelectedShowService extends KmsBaseDataBeanService{
	// 知识推荐排行
	@HttpJSONP
	
	public JSON findKnowledgeSortByIntroduce(RequestContext requestInfo)
			throws Exception {
		JSONArray returnObject = new JSONArray();
		JSONObject json = new JSONObject();
		String fdCategoryId = "";
		String fdCategoryNameList0 = requestInfo.getParameter("fdCategoryName");
		String[] fdCategoryNameList =fdCategoryNameList0.split(",");
		if(fdCategoryNameList.length>0){
			for(int a=0;a<fdCategoryNameList.length;a++){
		HQLInfo Info = new HQLInfo();
		Info.setParameter("fdname", fdCategoryNameList[a]);
		Info.setWhereBlock("kmsMultidocTemplate.fdName=:fdname");
		List<KmsMultidocTemplate> list = kmsMultidocTemplateService.findPage(
				Info).getList();
		if(list.size()>0){
		for (KmsMultidocTemplate knowledge : list) {
			fdCategoryId = knowledge.getFdId();
		}
		HQLInfo hqlInfo = new HQLInfo();
		String s_rowsize = requestInfo.getParameter("rowsize");
		int rowsize = (StringUtil.isNotNull(s_rowsize)) ? Integer
				.parseInt(s_rowsize) : 8;
		
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
			hqlInfo.setParameter("fdCategoryId", "x" + fdCategoryId + "%");
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
		}
		}
		}
		json.accumulate("docList", returnObject);
		return json;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService = null;

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}
}
