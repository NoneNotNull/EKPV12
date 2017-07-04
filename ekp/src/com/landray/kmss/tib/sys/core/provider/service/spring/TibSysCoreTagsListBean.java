package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreTag;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreTagService;
import com.landray.kmss.util.SpringBeanUtil;

public class TibSysCoreTagsListBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String,String>> rtnList=new ArrayList<Map<String,String>>();
		ITibSysCoreTagService tibSysCoreTagService=(ITibSysCoreTagService)SpringBeanUtil.getBean("tibSysCoreTagService");
		HQLInfo hqlInfo =new HQLInfo();
		List<?> dataList=tibSysCoreTagService.findList(hqlInfo);
		rtnList= parseList(dataList);
		return rtnList;
	}
	
	
	private List<Map<String,String>> parseList(List<?> rtnList){
		List<Map<String,String>> pList=new ArrayList<Map<String, String>>(1);
		for(Object rtn :rtnList){
			TibSysCoreTag rTag=(TibSysCoreTag)rtn;
			String tagId=rTag.getFdId();
			String tagName=rTag.getFdTagName();
			Map<String, String> map=new HashMap<String, String>(1);
			map.put("id", tagId);
			map.put("name", tagName);
			pList.add(map);
		}
		return pList;
	}

}
