/**
 * 
 */
package com.landray.kmss.tib.jdbc.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.tib.jdbc.util.JdbcUtil;

/**
 * @author qiujh
 * @version 1.0 2013-11-7
 */
public class TibJdbcDeleteValidateBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		String dbId = requestInfo.getParameter("dbId");
		String sourceSql = requestInfo.getParameter("sourceSql");
		DataSet ds = null;
		try {
			ds = JdbcUtil.getDataSet(dbId);
			ds.executeQuery(sourceSql);
		} catch (Exception e) {
			//e.printStackTrace();
			map.put("result", "false");
			map.put("errorStr", e.getMessage());
			rtnList.add(map);
			return rtnList;
		} finally {
			if (ds != null) {
				ds.close();
			}
		}
		map.put("result", "true");
		rtnList.add(map);
		return rtnList;
	}

}
