package com.landray.kmss.km.review.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.km.review.model.KmReviewTemplate;
import com.landray.kmss.km.review.service.IKmReviewTemplateService;
import com.landray.kmss.km.review.util.KmReviewUtil;
import com.landray.kmss.sys.appconfig.model.SysAppConfig;
import com.landray.kmss.sys.appconfig.service.ISysAppConfigService;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2010-六月-19
 * 
 * @author zhuangwl 我的常用流程模板portlet
 */
public class KmReviewCommonPortlet implements IXMLDataBean {

	private ISysAppConfigService sysAppConfigService;

	public void setSysAppConfigService(ISysAppConfigService sysAppConfigService) {
		this.sysAppConfigService = sysAppConfigService;
	}

	private IKmReviewTemplateService kmReviewTemplateService;

	public void setKmReviewTemplateService(
			IKmReviewTemplateService kmReviewTemplateService) {
		this.kmReviewTemplateService = kmReviewTemplateService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String param = requestInfo.getParameter("rowsize");
		int rowsize = 10;
		if (!StringUtil.isNull(param))
			rowsize = Integer.parseInt(param);
		String fdTemplateIds = "";
		String whereBlock = "sysAppConfig.fdKey = 'com.landray.kmss.km.review.model.KmReviewCommonConfig_"
				+ UserUtil.getUser().getFdId() + "'";
		whereBlock = StringUtil.linkString(whereBlock, " and ",
				" sysAppConfig.fdField = 'fdTemplateIds'");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setRowSize(rowsize);
		hqlInfo.setPageNo(1);
		Page page = sysAppConfigService.findPage(hqlInfo);
		List<SysAppConfig> list = page.getList();
		if (!list.isEmpty()) {
			SysAppConfig config = list.get(0);
			fdTemplateIds = config.getFdValue();
		}
		List rtnList = new ArrayList();
		if (StringUtil.isNull(fdTemplateIds))
			return rtnList;
		String sqlString = KmReviewUtil.replaceToSQLString(fdTemplateIds);
		List templateList = new ArrayList();
		if (StringUtil.isNotNull(sqlString)) {
			templateList = kmReviewTemplateService.findList(
					"kmReviewTemplate.fdId in (" + sqlString + ")", null);
		}
		String[] templateIds = fdTemplateIds.split("\r\n");
		for (int i = 0; i < templateIds.length; i++) {
			String categoryId = templateIds[i];
			for (int j = 0; j < templateList.size(); j++) {
				KmReviewTemplate kmReviewTemplate = (KmReviewTemplate) templateList
						.get(j);
				if (kmReviewTemplate.getFdId().equals(categoryId)) {
					Map map = new HashMap();
					map.put("text", kmReviewTemplate.getFdName());
					map.put("id", kmReviewTemplate.getFdId());
					map.put("s_path", KmReviewUtil.getSPath(kmReviewTemplate
							.getDocCategory(), kmReviewTemplate.getFdName()));
					rtnList.add(map);
				}
			}
		}
		return rtnList;
	}

}
