package com.landray.kmss.tib.jdbc.service.bean;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibJdbcLoadDBTablService implements IXMLDataBean {
	public List getDataList(RequestContext requestInfo) throws Exception {
		String data = requestInfo.getParameter("dbId");
		String key = requestInfo.getParameter("keyword");
		String tabType=requestInfo.getParameter("tabType");
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		if (StringUtil.isNull(data)) {
			return null;
		}
		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(data);
		if (compDbcp != null) {
			DataSet ds = new DataSet(compDbcp.getFdName());
			DatabaseMetaData databaseMetaData = ds.getConnection()
					.getMetaData();
			ResultSet tableSet = databaseMetaData.getTables(null, "%", "%",
					new String[] { "TABLE" });
			try {
				while (tableSet.next()) {
					String tableName = tableSet.getString("TABLE_NAME");
					Map<String, String> map = new HashMap<String, String>();
					if(StringUtils.isNotEmpty(tabType)){
						tabType = tabType.trim().toUpperCase();
						// boolean flag =tableName.matches("^sys_log_[1-9]+$");
						//boolean flag = tableName.toLowerCase().contains("sys_log_");
						if(tabType.equals("SYSLOG")){ //&& flag){
							int index = tableName.toLowerCase().indexOf("tib_jdbclog_");
							if (index >= 0) {
								tableName = tableName.substring(index +"tib_jdbclog_".length());
								map.put("name", tableName.toLowerCase());
								map.put("id", tableName.toLowerCase());
								rtnList.add(map);
							}
						}
					}else{
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

				}
			} finally {
				if (tableSet != null)
					tableSet.close();
				if (ds != null)
					ds.close();
			}
		}
		return rtnList;
	}

}
