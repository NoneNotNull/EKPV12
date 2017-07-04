package com.landray.kmss.tib.sap.mapping.service.spring;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcCategoryService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;
import com.landray.kmss.util.StringUtil;

public class TibSapMappingFuncTreeListService implements IXMLDataBean {
	private ITibSysSapRfcCategoryService tibSysSapRfcCategoryService;
	
	private ITibSysSapRfcSettingService tibSysSapRfcSettingService;

	public void setTibSysSapRfcCategoryService(
			ITibSysSapRfcCategoryService tibSysSapRfcCategoryService) {
		this.tibSysSapRfcCategoryService = tibSysSapRfcCategoryService;
	}

	public void setTibSysSapRfcSettingService(
			ITibSysSapRfcSettingService tibSysSapRfcSettingService) {
		this.tibSysSapRfcSettingService = tibSysSapRfcSettingService;
	}

	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		String type = requestInfo.getParameter("type");
		String selectId = requestInfo.getParameter("selectId");
		String keyword = requestInfo.getParameter("keyword");
		String whereBlock = "";
		List<TibSysSapRfcCategory> resList = new ArrayList<TibSysSapRfcCategory>(1);
		List<Map<String,String>> rtnList = new ArrayList<Map<String,String>>(1);
		Map<String,String> map;
		HQLInfo hqlInfo = new HQLInfo();
		if (type.equals("cate")) {
			if (StringUtil.isNull(selectId)) {
				whereBlock = "tibSysSapRfcCategory.hbmParent.fdId is null";
			} else {
				whereBlock = "tibSysSapRfcCategory.hbmParent.fdId=:parentId";
				hqlInfo.setParameter("parentId", selectId);
			}
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy("tibSysSapRfcCategory.fdOrder");
			resList = (List<TibSysSapRfcCategory>)tibSysSapRfcCategoryService.findList(hqlInfo);
			for (Iterator<TibSysSapRfcCategory> iterator = resList.iterator(); iterator.hasNext();) {
				map = new HashMap<String,String>(1);
				TibSysSapRfcCategory tibSysSapRfcCategory = iterator
						.next();
				map.put("text", tibSysSapRfcCategory.getFdName());
				map.put("value", tibSysSapRfcCategory.getFdId());
				rtnList.add(map);
			}

		} else if (type.equals("func")) {
			if ("".equals(selectId)) {
				whereBlock = "tibSysSapRfcSetting.fdUse=1 and tibSysSapRfcSetting.docOriginDoc =null";
			} else {
				String inStr = "";
				List tibSysSapRfcCategoryFdIdList = new ArrayList();
				HQLInfo hqlInfoCate = new HQLInfo();
				hqlInfoCate.setSelectBlock("tibSysSapRfcCategory.fdId");
				hqlInfoCate.setWhereBlock("tibSysSapRfcCategory.fdHierarchyId like :fdHierarchyId");
				hqlInfoCate.setParameter("fdHierarchyId", "%" + selectId + "%");
				tibSysSapRfcCategoryFdIdList = tibSysSapRfcCategoryService.findValue(hqlInfoCate);
				for (Iterator iterator = tibSysSapRfcCategoryFdIdList.iterator(); iterator
						.hasNext();) {
					String idTmp = (String) iterator.next();
					inStr += "".equals(inStr) ? ("'" + idTmp + "'") : (",'"
							+ idTmp + "'");
				}
				whereBlock = "tibSysSapRfcSetting.docCategory.fdId in ("
						+ inStr
						+ ") and tibSysSapRfcSetting.fdUse=1 and tibSysSapRfcSetting.docOriginDoc =null";
			}

			resList = tibSysSapRfcSettingService.findList(whereBlock, null);
			for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
				map = new HashMap();
				TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) iterator.next();
				map.put("name", tibSysSapRfcSetting.getFdFunctionName());
				map.put("id", tibSysSapRfcSetting.getFdId());
				rtnList.add(map);
			}
			// 搜索暂时不做
		} else if("search".equals(type)&&StringUtil.isNotNull(keyword)){
			whereBlock = "tibSysSapRfcSetting.fdFunctionName like :fdFunctionName ";
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setParameter("fdFunctionName", "%"+ keyword +"%");
			resList = tibSysSapRfcSettingService.findList(hqlInfo);
			for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
				map = new HashMap();
				TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) iterator.next();
				map.put("name", tibSysSapRfcSetting.getFdFunctionName());
				map.put("id", tibSysSapRfcSetting.getFdId());
				rtnList.add(map);
			}
		}
		return rtnList;

	}
}
