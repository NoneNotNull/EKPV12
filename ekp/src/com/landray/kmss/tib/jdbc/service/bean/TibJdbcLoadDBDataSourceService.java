package com.landray.kmss.tib.jdbc.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.util.SpringBeanUtil;

public class TibJdbcLoadDBDataSourceService implements IXMLDataBean {

	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String,String>> dbList = new ArrayList<Map<String,String>>();
		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("compDbcp.fdId,compDbcp.fdName");
		List result = compDbcpService.findList(hqlInfo);
		if(result!=null && result.size()>0){
			for(int i=0;i<result.size();i++){
				Map<String,String> resultMap = new HashMap<String,String>();
				Object[] obj = (Object[]) result.get(i);
				resultMap.put("id",(String) obj[0]);
				resultMap.put("value", (String) obj[1]);
				dbList.add(resultMap);
			}
		}
		return dbList;
	}

}
