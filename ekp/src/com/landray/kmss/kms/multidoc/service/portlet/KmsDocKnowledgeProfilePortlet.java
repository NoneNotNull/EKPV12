package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.common.util.PageBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

public class KmsDocKnowledgeProfilePortlet implements IKmsDataBean {

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

			hqlInfo
					.setWhereBlock(StringUtil
							.linkString(
									hqlInfo.getWhereBlock(),
									" and ",
									"kmsMultidocKnowledge.docStatus = :status and kmsMultidocKnowledge.docIsNewVersion = :isNewVersion"));
			hqlInfo.setParameter("status",
					KmsMultidocKnowledge.DOC_STATUS_PUBLISH);
			hqlInfo.setParameter("isNewVersion", true);
			
			if (StringUtil.isNotNull(keyWord)) {
				hqlInfo.setWhereBlock(StringUtil.linkString(hqlInfo
						.getWhereBlock(), " and ",
						"kmsMultidocKnowledge.docSubject like :keyword"));
				hqlInfo.setParameter("keyword", "%" + keyWord + "%");
			}
			hqlInfo.setOrderBy("docCreateTime desc");
			Page page = kmsMultidocKnowledgeService.findPage(hqlInfo);
			page.setPagingListSize(5);
			List<KmsMultidocKnowledge> list = page.getList();
			for (KmsMultidocKnowledge kmsMultidocKnowledge : list) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("docSubject", StringUtil
						.XMLEscape(kmsMultidocKnowledge.getDocSubject()));
				jsonObject
						.put(
								"kmsMultidocTemplate",
								StringUtil
										.XMLEscape(kmsMultidocKnowledge
												.getKmsMultidocTemplate() != null ? kmsMultidocKnowledge
												.getKmsMultidocTemplate()
												.getFdName()
												: ""));
				jsonObject.put("docCreator", kmsMultidocKnowledge
						.getDocCreator().getFdName());
				jsonObject.put("docCreateTime", DateUtil.convertDateToString(
						kmsMultidocKnowledge.getDocCreateTime(), "yyyy-MM-dd"));
				jsonObject.put("fdUrl", requestInfo.getContextPath()
						+ ModelUtil.getModelUrl(kmsMultidocKnowledge));
				jsonArray.add(jsonObject);
			}
			pageBean = new PageBean(page);
			pageBean.setItemList(jsonArray);
		}
		return pageBean;
	}

	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

}
