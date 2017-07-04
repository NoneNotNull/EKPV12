/**
 * 
 */
package com.landray.kmss.tib.jdbc.service.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-4-15
 */
public class TibJdbcDataSetParamBean extends HibernateDaoSupport implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		String fdDataSource = requestInfo.getParameter("fdDataSource");
		String fdSqlExpression = requestInfo.getParameter("fdSqlExpression");
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		if (StringUtil.isNotNull(fdSqlExpression)) {
			// 剔除掉回车和换行
			fdSqlExpression = fdSqlExpression.replaceAll("&#13;&#10;", "").replaceAll(
					"\t|\r|\n", " ").toUpperCase();
			ResultSet rs = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				int selectIndex = fdSqlExpression.indexOf("SELECT");
				int fromIndex = fdSqlExpression.indexOf("FROM");
				if ((selectIndex == -1 || fromIndex == -1)) {
					return result;
				}
				if (fdSqlExpression.indexOf("WHERE") != -1) {
					fdSqlExpression = fdSqlExpression.substring(0, fdSqlExpression.indexOf("WHERE"));
				}
				String fdSqlAllColumnExpression = fdSqlExpression.substring(0, selectIndex + 6) +" * "+
						fdSqlExpression.substring(fromIndex);
				if (StringUtil.isNotNull(fdDataSource)) {
					conn = this.getCreateConn(fdDataSource);
				} else {
					conn = this.getSession().connection();
				}
				// 求全部列
				pstmt = conn.prepareStatement(fdSqlAllColumnExpression);
				rs = pstmt.executeQuery();
				if (rs != null) {
					ResultSetMetaData metaData = rs.getMetaData();
					// 输出数据集的字段集
					for (int i = 1, length = metaData.getColumnCount(); i <= length; i++) {
						Map<String, String> map = new HashMap<String, String>();
						map.put("tagName", metaData.getColumnName(i));
						map.put("ctype", metaData.getColumnTypeName(i));
						map.put("length", String.valueOf(metaData.getColumnDisplaySize(i)));
						// 默认不是传出参数
						map.put("isOut", "false");
						result.add(map);
					}
				}
				// 查询列
				pstmt = conn.prepareStatement(fdSqlExpression);
				rs = pstmt.executeQuery();
				if (rs != null) {
					ResultSetMetaData metaData = rs.getMetaData();
					// 输出数据集的字段集
					for (int i = 1, length = metaData.getColumnCount(); i <= length; i++) {
						String tagName = metaData.getColumnName(i).toUpperCase();
						// 遍历集合找列 
						for (Iterator<Map<String, String>> it = result.iterator(); it.hasNext();) {
							Map<String, String> map = it.next();
							if (map.get("tagName").toUpperCase().equals(tagName)) {
								map.put("isOut", "true");
							}
						}
					}
				}
			} catch (Exception e) {
				Map<String, String> node = new HashMap<String, String>();
				node.put("error", e.getMessage());
				result.add(node);
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
					if (pstmt != null) {
						pstmt.close();
					}
					if (conn != null) {
						conn.close();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return result;
	}
	
	/**
	 * 获取外部数据库德连接对象
	 * 
	 * @param fdDataSource
	 * @return
	 * @throws Exception
	 */
	private Connection getCreateConn(String fdDataSource) throws Exception {
		CompDbcp compDbcps = (CompDbcp) this.getSession().get(
				CompDbcp.class, fdDataSource);
		Class.forName(compDbcps.getFdDriver());
		return DriverManager.getConnection(compDbcps.getFdUrl(), compDbcps
				.getFdUsername(), compDbcps.getFdPassword());
	}
	
}
