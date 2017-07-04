package com.landray.kmss.tib.jdbc.iface;

import java.util.Map;

import net.sf.json.JSONObject;

import com.landray.kmss.tib.jdbc.model.TibJdbcRelation;

/**
 * JDBC任务同步
 * @author qiujh
 */
public interface ITibJdbcTaskSync {
	
	/**
	 * 执行同步任务 
	 * @param tibJdbcRelation
	 * @param json
	 * @return					返回日志记录key为message代表成功错误条数，
	 * 							key为errorDetail代表记录错误的id
	 * @throws Exception
	 */
	public Map<String, String> run(TibJdbcRelation tibJdbcRelation, 
			JSONObject json) throws Exception;
	
}
