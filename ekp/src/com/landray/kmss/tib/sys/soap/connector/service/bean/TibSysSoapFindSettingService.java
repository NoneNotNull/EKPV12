package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapFindSettingService implements IXMLDataBean {
	private ITibSysSoapSettCategoryService tibSysSoapSettCategoryService;

	public ITibSysSoapSettCategoryService getTibSysSoapSettCategoryService() {
		return tibSysSoapSettCategoryService;
	}

	public void setTibSysSoapSettCategoryService(
			ITibSysSoapSettCategoryService tibSysSoapSettCategoryService) {
		this.tibSysSoapSettCategoryService = tibSysSoapSettCategoryService;
	}


	/**
	 * 获取选择函数名称
	 */
	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		ITibSysSoapSettingService tibSysSoapSettingService = (ITibSysSoapSettingService) SpringBeanUtil
				.getBean("tibSysSoapSettingService");

		String type = requestInfo.getParameter("type");
		String selectId = requestInfo.getParameter("selectId");
		String keyword = requestInfo.getParameter("keyword");
		String whereBlock = "";
		List<TibSysSoapSettCategory> resList = new ArrayList<TibSysSoapSettCategory>(1);
		
		List<Map<String, String>> rtnValue = new ArrayList<Map<String, String>>();
		Map<String,String> map;
		HQLInfo hqlInfo = new HQLInfo();
		
		if (type.equals("cate")) {
			if (StringUtil.isNull(selectId)) {
				whereBlock = "tibSysSoapSettCategory.hbmParent.fdId is null";
			} else {
				whereBlock = "tibSysSoapSettCategory.hbmParent.fdId=:hbmParentFdId";
				hqlInfo.setParameter("hbmParentFdId", selectId);
			}
			hqlInfo.setWhereBlock(whereBlock);
			resList = (List<TibSysSoapSettCategory>)tibSysSoapSettCategoryService.findList(hqlInfo);
			for (Iterator<TibSysSoapSettCategory> iterator = resList.iterator(); iterator.hasNext();) {
				map = new HashMap<String,String>(1);
				TibSysSoapSettCategory tibSysSoapSettCategory = iterator.next();
				map.put("text", tibSysSoapSettCategory.getFdName());
				map.put("value", tibSysSoapSettCategory.getFdId());
				rtnValue.add(map);
			}
			
		}else if (type.equals("func")) {
			if ("".equals(selectId)) {
				whereBlock = "tibSysSoapSetting.fdEnable=1 ";
			} else {
				String inStr = "";
				hqlInfo.setSelectBlock("tibSysSoapSettCategory.fdId");
				hqlInfo.setWhereBlock("tibSysSoapSettCategory.fdHierarchyId like :fdHierarchyId");
				hqlInfo.setParameter("fdHierarchyId", "%" + selectId + "%");
				resList = tibSysSoapSettCategoryService.findValue(hqlInfo);
				for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
					String idTmp = (String) iterator.next();
					inStr += "".equals(inStr) ? ("'" + idTmp + "'") : (",'"+ idTmp + "'");
				}
				whereBlock = "tibSysSoapSetting.settCategory.fdId in ("
						+ inStr
						+ ") and tibSysSoapSetting.fdEnable=1 ";
			}

			resList = tibSysSoapSettingService.findList(whereBlock, null);
			for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
				map = new HashMap();
				TibSysSoapSetting tibSysSoapSetting  = (TibSysSoapSetting) iterator.next();
				Map<String, String> node = new HashMap<String, String>();
				node.put("name", tibSysSoapSetting.getDocSubject());
				node.put("id", tibSysSoapSetting.getFdId());
				node.put("info", tibSysSoapSetting.getFdWsdlUrl());
				node.put("soap", tibSysSoapSetting.getFdSoapVerson());
				rtnValue.add(node);
			}
			
		}else if("search".equals(type)&&StringUtil.isNotNull(keyword)){
			whereBlock = "tibSysSoapSetting.docSubject like :docSubject ";
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setParameter("docSubject", "%"+ keyword +"%");
			resList = tibSysSoapSettingService.findList(hqlInfo);
			for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
				map = new HashMap();
				TibSysSoapSetting tibSysSoapSetting = (TibSysSoapSetting) iterator.next();
				map.put("name", tibSysSoapSetting.getDocSubject());
				map.put("id", tibSysSoapSetting.getFdId());
				map.put("info", tibSysSoapSetting.getFdWsdlUrl());
				map.put("soap", tibSysSoapSetting.getFdSoapVerson());
				rtnValue.add(map);
			}
			
		}
		return rtnValue;
	}
}
