package com.landray.kmss.tib.jdbc.iface;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import oracle.sql.TIMESTAMP;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.component.dbop.ds.DataSet;
import com.landray.kmss.tib.jdbc.constant.TibJdbcConstant;
import com.landray.kmss.tib.jdbc.model.TibJdbcRelation;
import com.landray.kmss.tib.jdbc.util.JdbcUtil;
import com.landray.kmss.util.IDGenerator;

/**
 * JDBC任务同步，基础服务类
 * 
 * @author qiujh
 */
public abstract class TibJdbcTaskBaseSync implements ITibJdbcTaskSync {

	public abstract Map<String, String> run(TibJdbcRelation tibJdbcRelation, JSONObject json)
			throws Exception;

	/**
	 * 删除目标数据
	 * @param dbId
	 * @param deleteSql
	 * @throws Exception
	 */
	public void deleteTargetDB(String targetDBId, String deleteSql) throws Exception {
		DataSet dataSet = null;
		try {
			dataSet = JdbcUtil.getDataSet(targetDBId);
			dataSet.executeUpdate(deleteSql);
		}catch(Exception e){
  			throw e;
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
		}
	}
	
	/**
	 * 查询数据的方法
	 * @param dbId
	 * @param querySql
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> queryData(String dbId, String querySql) throws Exception {
		List<Map<String, Object>> objListList = new ArrayList<Map<String, Object>>();
		DataSet dataSet = null;
		ResultSet rs = null;
		try {
			dataSet = JdbcUtil.getDataSet(dbId);
			rs = dataSet.executeQuery(querySql);
			int columnCount = rs.getMetaData().getColumnCount();
			while (rs.next()) {
				Map<String, Object> objMap = new HashMap<String, Object>();
				for (int i = 1; i <= columnCount; i++) {
					Object obj = rs.getObject(i);
					ResultSetMetaData  rsmd = rs.getMetaData();
					String columnName = rsmd.getColumnName(i);
					objMap.put(columnName, obj);
				}
				objListList.add(objMap);
			}
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return objListList;
	}
	
	/**
	 * 求总数
	 * @param dbId
	 * @param sql
	 * @return
	 * @throws Exception
	 */
	public int getTotalCount(String dbId, String sql) throws Exception {
		int totalCount = 0;
		DataSet dataSet = null;
		ResultSet rs = null;
		try {
			dataSet = JdbcUtil.getDataSet(dbId);
			rs = dataSet.executeQuery(sql);
			if (rs.next()) {
				totalCount = rs.getInt(1);
			}
		}catch(Exception e){
			throw e;
		} finally {
			if (dataSet != null) {
				dataSet.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return totalCount;
	}
	
	/**
	 * 删除目标数据
	 * （此方法请删除，业务放到各自实现中）	
	 * @param syncType
	 * @param dbId
	 * @param tabList
	 * @param deleteCondition
	 * @throws Exception
	 */
	public void deleteTargetDB(String syncType, String dbId,
			List<String> tabList, Map<String, String> deleteCondition)
			throws Exception {
		String targetTabName = "";
		String conditionSql = "";
		String mainTabDeletSql = "delete from ";
		for (int i = 0; i < tabList.size(); i++)
			targetTabName = (String) tabList.get(i);
		if (syncType.equals("1")) {
			mainTabDeletSql += targetTabName;
		} else if (syncType.equals("2")) {
			if (deleteCondition != null && deleteCondition.size() > 0) {
				conditionSql = deleteCondition.get(targetTabName);
				if (StringUtils.isNotEmpty(conditionSql)) {
					mainTabDeletSql += targetTabName + " where "
							+ conditionSql;
				}
			}

		} else {
			// 待处理
		}
		mainTabDeletSql = mainTabDeletSql.replaceAll("&#13;&#10;", "")
				.replaceAll("\t|\r|\n", " ").toUpperCase();
		// 修复 by qiujh
		deleteTargetDB(dbId, mainTabDeletSql);
	}
	
	/**
	 * 解析自定义公式表达式函数
	 * @param expressionText
	 * @return
	 */
	public String parseExpression(String expressionText) {
		String text = expressionText;
		if (TibJdbcConstant.SWITCH_MAP.containsKey(expressionText)) {
			short sign = TibJdbcConstant.SWITCH_MAP.get(expressionText);
			
			switch(sign) {
			// 生成主键
			case TibJdbcConstant.EXPRESSION_FDID :
				text = IDGenerator.generateID();
				break;
			// 当前日期时间
			case TibJdbcConstant.EXPRESSION_CUR_DATETIME :
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				text = sdf.format(new Date());
				break;
				
			//当前日期	
			case TibJdbcConstant.EXPRESSION_CUR_DATE :
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
				text = sdf2.format(new Date());
				break;
			}
		}
		return text;
	}
	
	/**
	 * 为预处理设值，兼容多种非标准类型
	 * @param ps
	 * @param count
	 * @param obj
	 * @throws SQLException
	 * @throws IOException
	 */
	public void setObjectColumn(PreparedStatement ps, int count, Object obj) 
			throws SQLException, IOException {
		if (obj instanceof byte[]) {
			InputStream input = new ByteArrayInputStream((byte[]) obj);
			ps.setBinaryStream(count, input, input.available());
		} else {
			// Oracle下timestamp做处理  by qiujh
			if (obj instanceof TIMESTAMP) {
				obj = ((TIMESTAMP) obj).timestampValue();
			} 
			ps.setObject(count, obj);
		}
	}
}
