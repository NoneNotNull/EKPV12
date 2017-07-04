package com.landray.kmss.kms.multidoc.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.kms.multidoc.util.KmsMultidocKnowledgeUtil;
import com.landray.kmss.sys.appconfig.model.SysAppConfig;
import com.landray.kmss.sys.appconfig.service.ISysAppConfigService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

public class KmsMultidocKnowledgeCommonPortlet implements IXMLDataBean {

	private ISysAppConfigService sysAppConfigService;

	public void setSysAppConfigService(ISysAppConfigService sysAppConfigService) {
		this.sysAppConfigService = sysAppConfigService;
	}

	private IKmsMultidocTemplateService kmsMultidocTemplateService;

	public IKmsMultidocTemplateService getKmsMultidocTemplateService() {
		return kmsMultidocTemplateService;
	}

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String param = requestInfo.getParameter("rowsize");
		int rowsize = 10;
		if (!StringUtil.isNull(param))
			rowsize = Integer.parseInt(param);
		String fdCategoryIds = "";
		String whereBlock = "sysAppConfig.fdKey = :appFdKey and sysAppConfig.fdField = :fdCategoryIds";
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setParameter("appFdKey",
				"com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledgeConfig_"
						+ UserUtil.getUser().getFdId());
		hqlInfo.setParameter("fdCategoryIds", "fdCategoryIds");
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
		String sqlString = KmsMultidocKnowledgeUtil
				.replaceToSQLString(fdCategoryIds);
		List templateList = new ArrayList();
		if (StringUtil.isNotNull(sqlString)) {
			templateList = kmsMultidocTemplateService.findList(
					"kmsMultidocTemplate.fdId in (" + sqlString + ")", null);
		}
		String[] categoryIds = fdCategoryIds.split("\r\n");
		for (int i = 0; i < categoryIds.length; i++) {
			String categoryId = categoryIds[i];
			for (int j = 0; j < templateList.size(); j++) {
				KmsMultidocTemplate kmsMultidocTemplate = (KmsMultidocTemplate) templateList
						.get(j);
				if (kmsMultidocTemplate.getFdId().equals(categoryId)) {
					Map map = new HashMap();
					map.put("text", kmsMultidocTemplate.getFdName());
					map.put("id", kmsMultidocTemplate.getFdId());
					map.put("s_path", KmsMultidocKnowledgeUtil.getSPath(
							kmsMultidocTemplate, ""));
					rtnList.add(map);
				}
			}
		}
		return rtnList;
	}

}
