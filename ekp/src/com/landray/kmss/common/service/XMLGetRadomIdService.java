package com.landray.kmss.common.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.StringUtil;

public class XMLGetRadomIdService implements IXMLDataBean {
	public List getDataList(RequestContext requestInfo) throws Exception {
		String count = requestInfo.getParameter("count");
		int n = 1;
		if (StringUtil.isNotNull(count)) {
			n = Integer.parseInt(count);
		}
		List<Map> rtnList = new ArrayList<Map>();
		for (int i = 0; i < n; i++) {
			Map<String, String> node = new HashMap<String, String>();
			node.put("value", IDGenerator.generateID(System.currentTimeMillis()
					+ i));
			rtnList.add(node);
		}
		return rtnList;
	}

}
