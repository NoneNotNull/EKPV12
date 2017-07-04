package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.util.StringUtil;

public class KmsDocKnowledgeIntroPortlet implements IKmsDataBean {

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String whereBlock = "kmsMultidocKnowledge.docStatus = :docStatus and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion and kmsMultidocKnowledge.fdId in (select intro.fdModelId from com.landray.kmss.sys.introduce.model.SysIntroduceMain intro where intro.fdIntroduceToEssence is true and intro.fdModelName = :fdModelName)";
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock += " and kmsMultidocKnowledge.kmsMultidocTemplate.fdHierarchyId like :fdHierarchyId";
			hqlInfo.setParameter("fdHierarchyId", "%" + fdCategoryId + "%");
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("kmsMultidocKnowledge.docIntrCount DESC");
		hqlInfo.setParameter("docStatus", "30");
		hqlInfo.setParameter("fdModelName",
				"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge");
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
			returnValue.put("docSubject", kmsMultidocKnowledge.getDocSubject());
			returnValue.put("docCategory", kmsMultidocKnowledge
					.getKmsMultidocTemplate().getFdName());
			String fdUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId="
					+ kmsMultidocKnowledge.getFdId();
			String docCategoryUrl = requestInfo.getContextPath()
					+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&templateId="
					+ kmsMultidocKnowledge.getKmsMultidocTemplate().getFdId()
					+ "&filterType=template";
			returnValue.put("docCategoryUrl", docCategoryUrl);
			returnValue.put("fdUrl", fdUrl);
			returnObject.add(returnValue);
		}
		json.accumulate("dataList", returnObject);
		return json;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

}
