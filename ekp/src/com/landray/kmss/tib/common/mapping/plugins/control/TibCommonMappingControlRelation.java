/**
 * 
 */
package com.landray.kmss.tib.common.mapping.plugins.control;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsField;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsTemplate;
import com.landray.kmss.sys.xform.base.service.controls.relation.SysFormRelation;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-7-2
 */
public class TibCommonMappingControlRelation extends HibernateDaoSupport implements SysFormRelation {

	public RelationParamsTemplate getParamsTemplate(String key) {
		try {
			String source = key.substring(0, key.indexOf("_"));
			String funcId = key.substring(key.indexOf("_") + 1);
			Map<String, String> map = TibCommonMappingIntegrationPlugins.getConfigByKey(source);
			String infoClass = map.get("infoClass");
			ITibCommonMappingControlDispatcher tibControlDispatcher = (ITibCommonMappingControlDispatcher) SpringBeanUtil.getBean(infoClass);
			String fdData = tibControlDispatcher.getTemplateXml(funcId);
			RelationParamsTemplate paramsTemplate = tibControlDispatcher.getParamsTemplate(funcId, fdData);
			return paramsTemplate;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public RelationParamsTemplate execute(String key,
			RelationParamsTemplate params) {
		try {
			String source = key.substring(0, key.indexOf("_"));
			String funcId = key.substring(key.indexOf("_") + 1);
			Map<String, String> map = TibCommonMappingIntegrationPlugins.getConfigByKey(source);
			String infoClass = map.get("infoClass");
			ITibCommonMappingControlDispatcher tibControlDispatcher = (ITibCommonMappingControlDispatcher) SpringBeanUtil.getBean(infoClass);
			String fdData = tibControlDispatcher.getTemplateXml(funcId);
			boolean flag = isCache(params);
			// 如果没有缓存，那么与接口交互获取数据
			if (!flag) {
				// 接口交互，取数据进行缓存到数据库
				tibControlDispatcher.execute(fdData, params, funcId);
				// 从数据库拿缓存数据
				isCache(params);
			}
			return params;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 判断是否缓存
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	private boolean isCache(RelationParamsTemplate params) throws SQLException {
		boolean flag = false;
		String conditionsUuid = params.getConditionsUUID();
		if (StringUtil.isNull(conditionsUuid)) {
			return flag;
		}
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			// 传出容器
			List<RelationParamsField> newFieldList = new ArrayList<RelationParamsField>();
			List<RelationParamsField> outFieldList = params.getOuts();
			// 创建数据库连接
			conn = this.getSession().connection();
			// 查数据判断是否是取数据库缓存数据tibCommonMappControlField.fdId
			String checkedSql = "select fd_id from tib_common_mapp_control_field " +
					"where conditions_uuid='"+ conditionsUuid +"' and row_index=1";
			ps = conn.prepareStatement(checkedSql);
			rs = ps.executeQuery();
			// 证明数据库缓存着数据，不用再去与第三方系统做交互
			if (rs.next()) {
				int currentPageNum = params.getPageSize();
				int pageNum = params.getPageNum();
				String sql = "select uu_id, field_value, row_index from tib_common_mapp_control_field " +
						"where conditions_uuid='"+ conditionsUuid +"' ";
				// 检查是否需要分页操作
				if (currentPageNum > 0) {
					sql += " and row_index>"+ (currentPageNum-1)*pageNum +" and row_index<="+ currentPageNum*pageNum;
				}
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				while (rs.next()) {
					String uu_id = rs.getString(1);
					String field_value = rs.getString(2);
					int row_index = rs.getInt(3);
					for (RelationParamsField outField : outFieldList) {
						if (uu_id.equals(outField.getUuId())) {
							// 行号大于1证明有多条，需要克隆，并塞值
//							if (row_index > 1) {
								RelationParamsField newField = (RelationParamsField) outField.clone();
								newField.setFieldValue(field_value);
								newField.setRowIndex(row_index);
								newFieldList.add(newField);
//							} else {
//								outField.setFieldValue(field_value);
//							}
							break;
						}
					}
//					System.out.println(rs.getRow());
				}
				flag = true;
			}
			if (newFieldList.size() > 0) {
				outFieldList.clear();
				outFieldList.addAll(newFieldList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				conn.close();
			}
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
		return flag;
	}
	
}
