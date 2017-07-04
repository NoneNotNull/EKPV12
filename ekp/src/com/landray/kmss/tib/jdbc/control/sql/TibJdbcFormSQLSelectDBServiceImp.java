package com.landray.kmss.tib.jdbc.control.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.util.StringUtil;

public class TibJdbcFormSQLSelectDBServiceImp extends HibernateDaoSupport implements
		IXMLDataBean {

	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		List result = new ArrayList();

		// 获得属性框中配置的sql语句
		String sqlvalue = requestInfo.getParameter("sqlvalue");
		String sqlResource = requestInfo.getParameter("sqlResource");

		if (StringUtil.isNotNull(sqlvalue)) {
			// 剔除掉回车和换行
			sqlvalue = sqlvalue.replaceAll("&#13;&#10;", "").replaceAll(
					"\t|\r|\n", " ").toUpperCase();

			ResultSet rs = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				if ((sqlvalue.indexOf("SELECT") == -1 || sqlvalue
						.indexOf("FROM") == -1)) {
					return result;
				}
				if (sqlvalue.indexOf("WHERE") != -1) {
					sqlvalue = sqlvalue.substring(0, sqlvalue.indexOf("WHERE"));
				}
				Map<String, String> map = null;
				if (StringUtil.isNotNull(sqlResource)) {
					conn = this.getCreateConn(sqlResource);
				} else {
					conn = this.getSession().connection();
				}
				pstmt = conn.prepareStatement(sqlvalue);
				rs = pstmt.executeQuery();

				if (rs != null) {
					ResultSetMetaData metaData = rs.getMetaData();
					// 输出数据集的字段集
					for (int i = 1, length = metaData.getColumnCount(); i <= length; i++) {
						map = new HashMap<String, String>();
						map.put("column", metaData.getColumnName(i));
						result.add(map);
					}
					rs.close();
					rs = null;
					map = null;
				}

			} catch (Exception e) {
				Map<String, String> node = new HashMap<String, String>();
				node.put("error", e.getMessage());
				result.add(node);
			} finally {
				try {
					if (rs != null) {
						rs.close();
						rs = null;
					}
					if (pstmt != null) {
						pstmt.close();
						pstmt = null;
					}
					if (conn != null) {
						conn.close();
						conn = null;
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
	 * @param sqlResource
	 * @return
	 * @throws Exception
	 */
	private Connection getCreateConn(String sqlResource) {
		try {
			CompDbcp compDbcps = (CompDbcp) this.getSession().get(
					CompDbcp.class, sqlResource);
			Class.forName(compDbcps.getFdDriver());
			return DriverManager.getConnection(compDbcps.getFdUrl(), compDbcps
					.getFdUsername(), compDbcps.getFdPassword());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return this.getSession().connection();
	}
}
