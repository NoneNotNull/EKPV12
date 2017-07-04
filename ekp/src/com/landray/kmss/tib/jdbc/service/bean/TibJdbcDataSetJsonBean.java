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
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetService;

/**
 * @author qiujh
 * @version 1.0 2014-5-5
 */
public class TibJdbcDataSetJsonBean implements IXMLDataBean {

	private ITibJdbcDataSetService tibJdbcDataSetService;
	
	public void setTibJdbcDataSetService(
			ITibJdbcDataSetService tibJdbcDataSetService) {
		this.tibJdbcDataSetService = tibJdbcDataSetService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		String funcId = requestInfo.getParameter("funcId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibJdbcDataSet.fdData");
		hqlInfo.setWhereBlock("tibJdbcDataSet.fdId=:funcId");
		hqlInfo.setParameter("funcId", funcId);
		List<Object> list = tibJdbcDataSetService.findValue(hqlInfo);
		if (null != list && !list.isEmpty()) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("dataJson", String.valueOf(list.get(0)));
			rtnList.add(map);
		}
		return rtnList;
	}

}
