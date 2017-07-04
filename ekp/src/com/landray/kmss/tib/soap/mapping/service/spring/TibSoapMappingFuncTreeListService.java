package com.landray.kmss.tib.soap.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.util.StringUtil;

public class TibSoapMappingFuncTreeListService implements IXMLDataBean {

	private ITibSysSoapCategoryService tibSysSoapCategoryService;

	private ITibSysSoapMainService tibSysSoapMainService;

	public List getDataList(RequestContext requestInfo) throws Exception {
		// TODO 自动生成的方法存根
		String type = requestInfo.getParameter("type");
		String selectId = requestInfo.getParameter("selectId");
		String keyword = requestInfo.getParameter("keyword");
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		// 分类查找
		if ("cate".equals(type)) {
			HQLInfo hqlInfo = new HQLInfo();
			if (StringUtil.isNull(selectId)) {
				hqlInfo.setWhereBlock("tibSysSoapCategory.hbmParent.fdId is null");
				hqlInfo.setOrderBy("tibSysSoapCategory.fdOrder");
			} else {
				hqlInfo.setWhereBlock(" tibSysSoapCategory.hbmParent.fdId =:fdId ");
				hqlInfo.setParameter("fdId", selectId);
				hqlInfo.setOrderBy("tibSysSoapCategory.fdOrder");
			}
			List<TibSysSoapCategory> dbList = tibSysSoapCategoryService
					.findList(hqlInfo);
			for (TibSysSoapCategory tibSysSoapCategory : dbList) {
				Map<String, String> h_map = new HashMap<String, String>();
				h_map.put("text", tibSysSoapCategory.getFdName());
				h_map.put("value", tibSysSoapCategory.getFdId());
				rtnList.add(h_map);
			}
		} else if ("func".equals(type)) {
			// 函数查找
			HQLInfo hqlInfo = new HQLInfo();
			if (StringUtil.isNull(selectId)) {
				hqlInfo.setWhereBlock("tibSysSoapMain.wsEnable = 1");
			} else {
				hqlInfo.setWhereBlock("tibSysSoapMain.wsEnable = 1 and tibSysSoapMain.docIsNewVersion =:docIsNewVersion and "
								+ " tibSysSoapMain.docCategory.fdId in "
								+ " (select tibSysSoapCategory.fdId from com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory tibSysSoapCategory where tibSysSoapCategory.fdHierarchyId like :selectId ) ");
				hqlInfo.setParameter("selectId", "%" + selectId + "%");
				hqlInfo.setParameter("docIsNewVersion", true);
			}
			List<TibSysSoapMain> dbList = tibSysSoapMainService.findList(hqlInfo);
			for (TibSysSoapMain tibSysSoapMain : dbList) {
				Map<String, String> h_map = new HashMap<String, String>();
				h_map.put("name", tibSysSoapMain.getDocSubject());
				h_map.put("id", tibSysSoapMain.getFdId());
				rtnList.add(h_map);
			}
		} else if ("search".equals(type) && StringUtil.isNotNull(keyword)) {
			// 搜索
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock("tibSysSoapMain.docSubject like :keyword and tibSysSoapMain.docIsNewVersion =:docIsNewVersion");
			hqlInfo.setParameter("keyword", "%" + keyword + "%");
			hqlInfo.setParameter("docIsNewVersion", true);
			List<TibSysSoapMain> dbList = tibSysSoapMainService.findList(hqlInfo);
			for (TibSysSoapMain tibSysSoapMain : dbList) {
				Map<String, String> h_map = new HashMap<String, String>();
				h_map.put("name", tibSysSoapMain.getDocSubject());
				h_map.put("id", tibSysSoapMain.getFdId());
				rtnList.add(h_map);
			}
		}
		return rtnList;
	}

	public ITibSysSoapCategoryService gettibSysSoapCategoryService() {
		return tibSysSoapCategoryService;
	}

	public void settibSysSoapCategoryService(
			ITibSysSoapCategoryService tibSysSoapCategoryService) {
		this.tibSysSoapCategoryService = tibSysSoapCategoryService;
	}

	public ITibSysSoapMainService gettibSysSoapMainService() {
		return tibSysSoapMainService;
	}

	public void settibSysSoapMainService(
			ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}

}
