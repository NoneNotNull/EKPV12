package com.landray.kmss.kms.multidoc.service.portlet;

import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

public class KmsDocFirstCategoryPortlet implements IKmsDataBean {

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		String s_pageNo = requestInfo.getParameter("pageNo");
		String s_rowsize = requestInfo.getParameter("rowSize");
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		HQLInfo hqlInfo = new HQLInfo();
		String fdCategoryId = requestInfo.getParameter("fdCategoryId");
		String whereBlock = "";
		if (StringUtil.isNotNull(fdCategoryId)) {
			whereBlock = "kmsMultidocTemplate.hbmParent.fdId = :fdCategoryId";
			hqlInfo.setParameter("fdCategoryId", fdCategoryId);
		} else {
			whereBlock = "kmsMultidocTemplate.hbmParent is null";
		}
		int pageNo = 1;
		int rowSize = 20;
		if (StringUtil.isNotNull(s_pageNo)) {
			pageNo = Integer.parseInt(s_pageNo);
		}
		if (StringUtil.isNotNull(s_rowsize)) {
			rowSize = Integer.parseInt(s_rowsize);
		}
		hqlInfo.setPageNo(pageNo);
		hqlInfo.setRowSize(rowSize);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy("docCreateTime desc");
		Page page = kmsMultidocTemplateService.findPage(hqlInfo);
		page.setPagingListSize(5);
		List<KmsMultidocTemplate> list = page.getList();
		for (KmsMultidocTemplate kmsMultidocTemplate : list) {
			JSONObject obj = new JSONObject();
			obj.put("fdName", StringUtil.XMLEscape(kmsMultidocTemplate
					.getFdName()));
			obj
					.put(
							"fdUrl",
							requestInfo.getContextPath()
									+ "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&stype=extend&fdId=com.landray.kmss.kms.multidoc&filterType=template&templateId="
									+ kmsMultidocTemplate.getFdId());
			jsonArray.add(obj);
		}
		jsonObject.element("docList", jsonArray);
		return jsonObject;
	}

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

}
