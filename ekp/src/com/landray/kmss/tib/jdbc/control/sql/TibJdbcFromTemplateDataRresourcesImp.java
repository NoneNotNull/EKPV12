package com.landray.kmss.tib.jdbc.control.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.util.ArrayUtil;

/**
 * 获取配置的数据源
 * 
 * @author djt 2011-05-17
 * 
 */
public class TibJdbcFromTemplateDataRresourcesImp extends HibernateDaoSupport
		implements IXMLDataBean {

	private ICompDbcpService compDbcpService;

	public void setCompDbcpService(ICompDbcpService compDbcpService) {
		this.compDbcpService = compDbcpService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		List result = new ArrayList();
		try {
			HQLInfo info = new HQLInfo();
			List<CompDbcp> compDbcps = compDbcpService.findList(info);

			Map<String, String> map = null;
			for (CompDbcp compDbcp : compDbcps) {
				map = new HashMap<String, String>();
				map.put("fdId", compDbcp.getFdId());
				map.put("fdName", compDbcp.getFdName());
				result.add(map);
			}

		} catch (Exception e) {
			Map<String, String> node = new HashMap<String, String>();
			node.put("error", e.getMessage());
			result.add(node);
		}
		return result;
	}

	/**
	 * 获取数据库链接对象
	 * 
	 * @param dataName
	 *            数据源名称
	 * @return
	 */
	public Connection getConnect(String dataName) {
		try {
			HQLInfo info = new HQLInfo();
			info.setWhereBlock(" compDbcp.fdName='" + dataName + "'");// 设置查询条件
			List list = compDbcpService.findList(info);// 得到数据连接地址
			if (ArrayUtil.isEmpty(list)) {
				return null;
			}
			CompDbcp compDbcps = (CompDbcp) list.get(0);
			Class.forName(compDbcps.getFdDriver());// 加在驱动
			return DriverManager.getConnection(compDbcps.getFdUrl(), compDbcps
					.getFdUsername(), compDbcps.getFdPassword());// 返回数据链接对象
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
