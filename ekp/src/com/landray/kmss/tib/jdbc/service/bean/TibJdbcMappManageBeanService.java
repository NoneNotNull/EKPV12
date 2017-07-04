package com.landray.kmss.tib.jdbc.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.jdbc.service.ITibJdbcMappCategoryService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcMappManageService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibJdbcMappManageBeanService implements IXMLDataBean {

public List getDataList(RequestContext requestInfo) throws Exception {
	List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
	String type = requestInfo.getParameter("type");

	if ("cate".equals(type)) {
		rtnList = executeCate(requestInfo);
	} else if ("func".equals(type)) {
		rtnList = executeFunc(requestInfo);
	} else if ("search".equals(type)) {
		rtnList = executeSearch(requestInfo);
	}
	return rtnList;
}

public List<Map<String, String>> executeCate(RequestContext requestInfo)throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibJdbcMappCategory.fdName, tibJdbcMappCategory.fdId");
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibJdbcMappCategory.hbmParent is null");
		} else {
			hqlInfo.setWhereBlock("tibJdbcMappCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		ITibJdbcMappCategoryService tibJdbcMappCategoryService=(ITibJdbcMappCategoryService)SpringBeanUtil.getBean("tibJdbcMappCategoryService");
		List<?> result = tibJdbcMappCategoryService.findList(hqlInfo);
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		for (int i = 0; i < result.size(); i++) {
			Object[] obj = (Object[]) result.get(i);
			Map<String, String> node = new HashMap<String, String>();
			node.put("text", obj[0].toString());
			node.put("value", obj[1].toString());
			rtnList.add(node);
		}
		return rtnList;
}

public List<Map<String, String>> executeFunc(RequestContext requestInfo)throws Exception {
	    String selecteId = requestInfo.getParameter("selecteId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibJdbcMappManage.docSubject, tibJdbcMappManage.fdId");
		if (StringUtil.isNotNull(selecteId)) {
			hqlInfo.setWhereBlock("tibJdbcMappManage.docCategory.fdId=:selecteId and tibJdbcMappManage.fdIsEnabled=true");
			hqlInfo.setParameter("selecteId", selecteId);
		}
		ITibJdbcMappManageService tibJdbcMappManageService=(ITibJdbcMappManageService)SpringBeanUtil.getBean("tibJdbcMappManageService");
		List<?> result = tibJdbcMappManageService.findList(hqlInfo);
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		for (int i = 0; i < result.size(); i++) {
			Object[] obj = (Object[]) result.get(i);
			Map<String, String> node = new HashMap<String, String>();
			//这里的key必须取id,name
			node.put("name", obj[0].toString());
			node.put("id", obj[1].toString());
			rtnList.add(node);
		}
		return rtnList;
}

public List<Map<String, String>> executeSearch(RequestContext requestInfo)
		throws Exception {

    String selecteId = requestInfo.getParameter("selecteId");
    String keyWord= requestInfo.getParameter("keyword");
    
	HQLInfo hqlInfo = new HQLInfo();
	hqlInfo.setSelectBlock("tibJdbcMappManage.docSubject, tibJdbcMappManage.fdId");
	if (StringUtil.isNotNull(selecteId)) {
		hqlInfo.setWhereBlock("tibJdbcMappManage.docCategory.fdId=:selecteId");
		hqlInfo.setParameter("selecteId", selecteId);
	}
	
	String hqlInformation=hqlInfo.getWhereBlock();
	if(StringUtil.isNotNull(keyWord)){
		hqlInformation=StringUtil.linkString(hqlInformation, " and ", "tibJdbcMappManage.docSubject like :keyWord ");
		hqlInfo.setParameter("keyWord", "%"+keyWord+"%");
	}
	hqlInfo.setWhereBlock(hqlInformation);
	
	ITibJdbcMappManageService tibJdbcMappManageService=(ITibJdbcMappManageService)SpringBeanUtil.getBean("tibJdbcMappManageService");
	List<?> result = tibJdbcMappManageService.findList(hqlInfo);
	List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
	for (int i = 0; i < result.size(); i++) {
		Object[] obj = (Object[]) result.get(i);
		Map<String, String> node = new HashMap<String, String>();
		node.put("name", obj[0].toString());
		node.put("id", obj[1].toString());
		rtnList.add(node);
	}
	return rtnList;

}

}
