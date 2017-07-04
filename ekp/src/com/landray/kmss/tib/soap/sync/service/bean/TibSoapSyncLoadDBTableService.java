package com.landray.kmss.tib.soap.sync.service.bean;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 
 * @author zhangtian 获取dbId 数据库的所有tableName
 */
public class TibSoapSyncLoadDBTableService implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		String data = requestInfo.getParameter("dbId");
		String key = requestInfo.getParameter("keyword");
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		if (StringUtil.isNull(data)) {
			return null;
		}
		;
		//延迟加载数据库表就打开这个注析
		// if(StringUtil.isNull(key)) {return rtnList;}
		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(data);
		if (compDbcp != null) {
			DataSet ds = new DataSet(compDbcp.getFdName());
			ResultSet tableSet = null;
			try {
				DatabaseMetaData databaseMetaData = ds.getConnection()
						.getMetaData();
				tableSet = databaseMetaData.getTables(null, "%", "%",
						new String[] { "TABLE" });
				while (tableSet.next()) {
					String tableName = tableSet.getString("TABLE_NAME");
					Map<String, String> map = new HashMap<String, String>();
					if (StringUtil.isNotNull(key)) {
						if (tableName.toLowerCase().indexOf(key.toLowerCase()) >= 0) {
							map.put("name", tableName);
							map.put("id", tableName);
							rtnList.add(map);
						}
					} else {
						map.put("name", tableName);
						map.put("id", tableName);
						rtnList.add(map);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				return rtnList;
			} finally {
				if (tableSet != null) {
					tableSet.close();
				}
				if (ds != null) {
					ds.close();
				}
			}
		}
		return rtnList;
	}

}
