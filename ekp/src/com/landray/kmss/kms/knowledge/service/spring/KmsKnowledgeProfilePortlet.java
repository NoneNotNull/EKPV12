package com.landray.kmss.kms.knowledge.service.spring;

import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.common.util.PageBean;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

public class KmsKnowledgeProfilePortlet implements IKmsDataBean {

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		Object object = requestInfo.getAttribute("hqlInfo");
		String s_pageNo = requestInfo.getParameter("pageNo");
		String s_rowsize = requestInfo.getParameter("rowSize");
		String keyWord = requestInfo.getParameter("keyword");
		JSONArray jsonArray = new JSONArray();
		PageBean pageBean = null;
		int pageNo = 1;
		int rowSize = 5;
		if (object != null) {
			HQLInfo hqlInfo = (HQLInfo) object;
			if (StringUtil.isNotNull(s_pageNo)) {
				pageNo = Integer.parseInt(s_pageNo);
			}
			if (StringUtil.isNotNull(s_rowsize)) {
				rowSize = Integer.parseInt(s_rowsize);
			}
			hqlInfo.setPageNo(pageNo);
			hqlInfo.setRowSize(rowSize);
			hqlInfo.setWhereBlock(StringUtil.linkString(
					hqlInfo.getWhereBlock(), " and ",
					"docIsNewVersion ='1'"));
			
			if (StringUtil.isNotNull(keyWord)) {
				hqlInfo.setWhereBlock(StringUtil.linkString(hqlInfo
						.getWhereBlock(), " and ",
						"docSubject like :keyword"));
				hqlInfo.setParameter("keyword", "%" + keyWord + "%");
			}
			hqlInfo.setOrderBy("docCreateTime desc");
			Page page = kmsKnowledgeBaseDocService.findPage(hqlInfo);
			page.setPagingListSize(5);
			List<KmsKnowledgeBaseDoc> list = page.getList();
			for (KmsKnowledgeBaseDoc kmsKnowledgeBaseDoc : list) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("docSubject", StringUtil.XMLEscape(kmsKnowledgeBaseDoc
						.getDocSubject()));
				jsonObject.put("kmsKnowledgeCategory",
						StringUtil.XMLEscape(kmsKnowledgeBaseDoc.getDocCategory().getFdName()));
				jsonObject.put("docCreator", kmsKnowledgeBaseDoc.getDocCreator()
						.getFdName());
				jsonObject.put("docCreateTime", DateUtil.convertDateToString(
						kmsKnowledgeBaseDoc.getDocCreateTime(), "yyyy-MM-dd"));
				jsonObject.put("docReadCount", kmsKnowledgeBaseDoc.getDocReadCount());
				jsonObject.put("fdUrl", requestInfo.getContextPath()
						+ ModelUtil.getModelUrl(kmsKnowledgeBaseDoc));
				jsonArray.add(jsonObject);
			}
			pageBean = new PageBean(page);
			pageBean.setItemList(jsonArray);
		}
		return pageBean;
	}
	private IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService;
	public void setKmsKnowledgeBaseDocService(
			IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService) {
		this.kmsKnowledgeBaseDocService = kmsKnowledgeBaseDocService;
	}
}
