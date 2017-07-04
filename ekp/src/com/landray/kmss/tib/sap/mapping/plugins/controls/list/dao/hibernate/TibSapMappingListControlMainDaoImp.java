package com.landray.kmss.tib.sap.mapping.plugins.controls.list.dao.hibernate;

import java.io.InputStream;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import com.landray.kmss.common.dao.BaseDaoImp;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.dao.ITibSapMappingListControlMainDao;

/**
 * 主文档数据访问接口实现
 * 
 * @author 
 * @version 1.0 2013-04-17
 */
public class TibSapMappingListControlMainDaoImp extends BaseDaoImp implements ITibSapMappingListControlMainDao {

	public void clearSapData() throws Exception {
		// 获取配置文件中要删除的期限
		InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("com/landray/kmss/tib/sap/mapping/plugins/controls/list/SapDataByList.properties");
		Properties pro = new Properties();
		pro.load(inputStream);
		String timeLimit = pro.getProperty("timeLimit");
		Calendar clearCalendar = Calendar.getInstance();
		// 算出时间日期
		clearCalendar.add(Calendar.DAY_OF_MONTH, Integer.parseInt(timeLimit));
		Date limitDate = clearCalendar.getTime();
		getSession().createSQLQuery("delete from tib_sap_mapping_list_control " +
				"where doc_create_time <= ?")
				.setTimestamp(0, new Timestamp(limitDate.getTime()))
				.executeUpdate();
	}

}
