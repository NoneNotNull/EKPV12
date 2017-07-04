package com.landray.kmss.tib.sap.sync.util;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.util.SpringBeanUtil;

public class TableFieldUtils {

public static Map<String, String> getTableFileld(String dbId,String tableName)throws Exception {
		ResultSet rs = null;
		ICompDbcpService compDbcpService = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		CompDbcp compDbcp = (CompDbcp) compDbcpService.findByPrimaryKey(dbId);
		DataSet ds = new DataSet(compDbcp.getFdName());
		Map<String, String> tabFieldMap = new HashMap<String, String>();

		if (StringUtils.isNotEmpty(tableName.trim())) {
			DatabaseMetaData databaseMetaData = ds.getConnection().getMetaData();
			ResultSet columnSet = null;
			try {
				columnSet = databaseMetaData.getColumns(null, "%",tableName, "%");
				while (columnSet.next()) {
					String columnName = columnSet.getString("COLUMN_NAME").toLowerCase();
					tabFieldMap.put(columnName, columnName);
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			} finally {
				try {
					if (columnSet != null)
						columnSet.close();
					if (ds != null)
						ds.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return tabFieldMap;
	}
}
