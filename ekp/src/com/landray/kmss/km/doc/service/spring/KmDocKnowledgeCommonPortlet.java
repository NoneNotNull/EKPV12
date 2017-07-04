package com.landray.kmss.km.doc.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.km.doc.util.KmDocKnowlegeUtil;
import com.landray.kmss.sys.appconfig.model.SysAppConfig;
import com.landray.kmss.sys.appconfig.service.ISysAppConfigService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

public class KmDocKnowledgeCommonPortlet implements IXMLDataBean {

	private ISysAppConfigService sysAppConfigService;

	public void setSysAppConfigService(ISysAppConfigService sysAppConfigService) {
		this.sysAppConfigService = sysAppConfigService;
	}

	private IKmDocTemplateService kmDocTemplateService;

	public IKmDocTemplateService getKmDocTemplateService() {
		return kmDocTemplateService;
	}

	public void setKmDocTemplateService(
			IKmDocTemplateService kmDocTemplateService) {
		this.kmDocTemplateService = kmDocTemplateService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String param = requestInfo.getParameter("rowsize");
		int rowsize = 10;
		if (!StringUtil.isNull(param))
			rowsize = Integer.parseInt(param);
		String fdCategoryIds = "";
		String whereBlock = "sysAppConfig.fdKey = 'com.landray.kmss.km.doc.model.KmDocKnowledgeConfig_"
				+ UserUtil.getUser().getFdId() + "'";
		whereBlock = StringUtil.linkString(whereBlock, " and ",
				" sysAppConfig.fdField = 'fdCategoryIds'");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setPageNo(1);
		Page page = sysAppConfigService.findPage(hqlInfo);
		List list = page.getList();
		if (!list.isEmpty()) {
			SysAppConfig config = (SysAppConfig) list.get(0);
			fdCategoryIds = config.getFdValue();
		}
		List rtnList = new ArrayList();
		if (StringUtil.isNull(fdCategoryIds))
			return rtnList;
		String sqlString = KmDocKnowlegeUtil.replaceToSQLString(fdCategoryIds);
		List templateList = new ArrayList();
		if (StringUtil.isNotNull(sqlString)) {
			templateList = kmDocTemplateService.findList(
					"kmDocTemplate.fdId in (" + sqlString + ")", null);
		}
		String[] categoryIds = fdCategoryIds.split("\r\n");
		for (int i = 0; i < categoryIds.length; i++) {
			String categoryId = categoryIds[i];
			for (int j = 0; j < templateList.size(); j++) {
				KmDocTemplate kmDocTemplate = (KmDocTemplate) templateList
						.get(j);
				if (kmDocTemplate.getFdId().equals(categoryId)) {
					Map map = new HashMap();
					map.put("text", kmDocTemplate.getFdName());
					map.put("id", kmDocTemplate.getFdId());
					map.put("s_path", KmDocKnowlegeUtil.getSPath(kmDocTemplate,
							""));
					rtnList.add(map);
				}
			}
		}
		return rtnList;
	}

}
