/**
 * 
 */
package com.landray.kmss.tib.jdbc.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSet;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetCategoryService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetService;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-4-29
 */
public class TibJdbcDataSetTreeBean implements IXMLDataBean {
	private ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService;
	private ITibJdbcDataSetService tibJdbcDataSetService;

	public void setTibJdbcDataSetCategoryService(
			ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService) {
		this.tibJdbcDataSetCategoryService = tibJdbcDataSetCategoryService;
	}
	
	public void setTibJdbcDataSetService(
			ITibJdbcDataSetService tibJdbcDataSetService) {
		this.tibJdbcDataSetService = tibJdbcDataSetService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String type = requestInfo.getParameter("type");
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		try {
			if ("cate".equals(type)) {
				getCate(requestInfo, rtnList);
			} else if ("func".equals(type)) {
				getFunc(requestInfo, rtnList);
			} else if ("search".equals(type)) {
				getSearch(requestInfo, rtnList);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return rtnList;
		}
		return rtnList;
	}
	
	public List<Map<String, String>> getCate(RequestContext requestInfo, 
			List<Map<String, String>> rtnList) throws Exception {
		String parentId = requestInfo.getParameter("selectId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibJdbcDataSetCategory.fdName, tibJdbcDataSetCategory.fdId");
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibJdbcDataSetCategory.hbmParent is null");
		} else {
			hqlInfo.setWhereBlock("tibJdbcDataSetCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		List<?> result = tibJdbcDataSetCategoryService.findList(hqlInfo);
		for (int i = 0; i < result.size(); i++) {
			Object[] obj = (Object[]) result.get(i);
			Map<String, String> node = new HashMap<String, String>();
			node.put("text", obj[0].toString());
			node.put("value", obj[1].toString());
			rtnList.add(node);
		}
		return rtnList;
	}
	
	public List<Map<String, String>> getFunc(RequestContext requestInfo, 
			List<Map<String, String>> rtnList) throws Exception {
		String parentId = requestInfo.getParameter("selectId");
		HQLInfo hqlInfo = new HQLInfo();
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibJdbcDataSet.docCategory is null");
		} else {
			hqlInfo.setWhereBlock("tibJdbcDataSet.docCategory.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		List<TibJdbcDataSet> dataSetList = tibJdbcDataSetService.findList(hqlInfo);
		for (TibJdbcDataSet tibJdbcDataSet : dataSetList) {
			Map<String, String> node = new HashMap<String, String>();
			node.put("name", tibJdbcDataSet.getDocSubject());
			node.put("id", tibJdbcDataSet.getFdId());
			node.put("dataSource", tibJdbcDataSet.getFdDataSource());
			node.put("dataSetSql", tibJdbcDataSet.getFdSqlExpression());
			node.put("fdData", tibJdbcDataSet.getFdData());
			rtnList.add(node);
		}
		return rtnList;
	}
	
	public List<Map<String, String>> getSearch(RequestContext requestInfo, 
			List<Map<String, String>> rtnList) throws Exception {
		return null;
	}

}
