package com.landray.kmss.tib.jdbc.control;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.codec.binary.Base64;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsField;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsTemplate;
import com.landray.kmss.tib.common.mapping.plugins.control.ITibCommonMappingControlDispatcher;
import com.landray.kmss.tib.common.mapping.plugins.control.TibCommonMappingControlTreeVo;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSet;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSetCategory;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetCategoryService;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetService;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibJdbcControlTreeInfo extends HibernateDaoSupport implements ITibCommonMappingControlDispatcher {
	
	private ITibJdbcDataSetService tibJdbcDataSetService;
	private ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService;

	public ITibJdbcDataSetService getTibJdbcDataSetService() {
		return tibJdbcDataSetService;
	}

	public void setTibJdbcDataSetService(
			ITibJdbcDataSetService tibJdbcDataSetService) {
		this.tibJdbcDataSetService = tibJdbcDataSetService;
	}
	
	public ITibJdbcDataSetCategoryService getTibJdbcDataSetCategoryService() {
		return tibJdbcDataSetCategoryService;
	}

	public void setTibJdbcDataSetCategoryService(
			ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService) {
		this.tibJdbcDataSetCategoryService = tibJdbcDataSetCategoryService;
	}

	public List<TibCommonMappingControlTreeVo> getCateInfo(String selectId,String pluginKey) throws Exception {
		
			List<TibCommonMappingControlTreeVo> cateList=new ArrayList<TibCommonMappingControlTreeVo>(1);
		
			HQLInfo hqlInfo = new HQLInfo();
			String whereBlock="";
			if (StringUtil.isNull(selectId)) {
				whereBlock = " tibJdbcDataSetCategory.hbmParent.fdId is null ";
			} else {
				whereBlock = " tibJdbcDataSetCategory.hbmParent.fdId=:hbmParentFdId ";
				hqlInfo.setParameter("hbmParentFdId", selectId);
			}
			
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy(" tibJdbcDataSetCategory.fdOrder ");
			List<TibJdbcDataSetCategory> resList = (List<TibJdbcDataSetCategory>)tibJdbcDataSetCategoryService.findList(hqlInfo);
			for (Iterator<TibJdbcDataSetCategory> iterator = resList.iterator(); iterator.hasNext();) {
				Map map = new HashMap<String,String>(1);
				TibJdbcDataSetCategory tibJdbcDataSetCategory = iterator
						.next();
				TibCommonMappingControlTreeVo tibSysCateVo =new TibCommonMappingControlTreeVo(tibJdbcDataSetCategory.getFdId(),tibJdbcDataSetCategory.getFdName(),pluginKey);
				cateList.add(tibSysCateVo);
			}
			return cateList;
	}
	
	public List<TibCommonMappingControlTreeVo> getFuncDataList(String cateId,String pluginKey) throws Exception{
		
		List<TibCommonMappingControlTreeVo> tibSysFuncVos=new ArrayList<TibCommonMappingControlTreeVo>();
		HQLInfo hqlFunc=new HQLInfo();
		if (StringUtil.isNotNull(cateId)) {
			hqlFunc.setWhereBlock("tibJdbcDataSet.docCategory.fdId in (select tibJdbcDataSetCategory.fdId from com.landray.kmss.tib.jdbc.model.TibJdbcDataSetCategory tibJdbcDataSetCategory where tibJdbcDataSetCategory.fdHierarchyId like :fdHierarchyId )");
			hqlFunc.setParameter("fdHierarchyId", "%"+ cateId +"%");
		}
		List<TibJdbcDataSet> resList = tibJdbcDataSetService.findList(hqlFunc);
		for (Iterator<TibJdbcDataSet> iterator = resList.iterator(); iterator.hasNext();) {
			TibJdbcDataSet tibJdbcDataSet = iterator.next();
			TibCommonMappingControlTreeVo treeVo=new TibCommonMappingControlTreeVo(tibJdbcDataSet.getFdId(),
					tibJdbcDataSet.getDocSubject(), pluginKey);
			tibSysFuncVos.add(treeVo);
		}
		return tibSysFuncVos;
	}

	public String getTemplateXml(String funcId) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibJdbcDataSet.fdData");
		hqlInfo.setWhereBlock("tibJdbcDataSet.fdId=:funcId");
		hqlInfo.setParameter("funcId", funcId);
		List<Object> list = tibJdbcDataSetService.findList(hqlInfo);
		if (list != null && !list.isEmpty()) {
			return String.valueOf(list.get(0));
		}
		return null;
	}

	public RelationParamsTemplate getParamsTemplate(String key, String fdData)
			throws Exception {
		RelationParamsTemplate paramsTemplate = new RelationParamsTemplate();
		List<RelationParamsField> insParamsField = new ArrayList<RelationParamsField>();
		List<RelationParamsField> outsParamsField = new ArrayList<RelationParamsField>();
		paramsTemplate.set_source("TIB_JDBC");
		paramsTemplate.set_key(key);
		JSONObject jsonObject = JSONObject.fromObject(fdData);
		// 传入
		JSONArray inJsonArr = jsonObject.getJSONArray("in");
		for (Iterator<JSONObject> it = inJsonArr.iterator(); it.hasNext();) {
			JSONObject columnObj = it.next();
			String tagName = columnObj.getString("tagName");
			RelationParamsField childField = new RelationParamsField();
			childField.set_multi("0");
			childField.set_ctype(columnObj.getString("ctype"));
			childField.set_required("checked".equals(columnObj.getString("required")) ? "1" : "0");
			childField.set_minlength("0");
			childField.set_maxlength(columnObj.getString("length"));
			childField.setFieldId(tagName);
			childField.set_xpath(tagName);
			childField.setUuId(new String(Base64.encodeBase64(tagName.getBytes())));
			insParamsField.add(childField);
		}
		// 传出
		JSONArray outJsonArr = jsonObject.getJSONArray("out");
		for (Iterator<JSONObject> it = outJsonArr.iterator(); it.hasNext();) {
			JSONObject columnObj = it.next();
			String tagName = columnObj.getString("tagName");
			RelationParamsField childField = new RelationParamsField();
			childField.set_multi("1");
			childField.set_ctype(columnObj.getString("ctype"));
			//childField.set_disp(columnObj.getString("disp"));
			childField.set_minlength("0");
			childField.set_maxlength(columnObj.getString("length"));
			childField.setFieldId(tagName);
			childField.set_xpath(tagName);
			childField.setUuId(new String(Base64.encodeBase64(tagName.getBytes())));
			outsParamsField.add(childField);
		}
		paramsTemplate.setIns(insParamsField);
		paramsTemplate.setOuts(outsParamsField);
		return paramsTemplate;
	}

	public RelationParamsTemplate execute(String fdData,
			RelationParamsTemplate params, String funcId) throws Exception {
		TibJdbcDataSet tibJdbcDataSet = (TibJdbcDataSet) tibJdbcDataSetService.findByPrimaryKey(funcId);
		String dataSource = tibJdbcDataSet.getFdDataSource();
		String sqlExpression = tibJdbcDataSet.getFdSqlExpression();
		// 替换传入值，传入塞值
		for (RelationParamsField paramsField : params.getIns()) {
			String fieldValue = paramsField.getFieldValueForm();
			if (fieldValue == null) {
				fieldValue = "";
			}
			String tagName = new String(Base64.decodeBase64(paramsField.getUuId().getBytes()));
			sqlExpression = sqlExpression.replaceAll(":"+ tagName, "'"+ fieldValue +"'");
		}
		List<RelationParamsField> outFieldList = params.getOuts();
		List<RelationParamsField> newFieldList = new ArrayList<RelationParamsField>();
		// 如果为空，那么从模版获取
		if (outFieldList.isEmpty()) {
			outFieldList.addAll(getParamsTemplate(params.get_key(), fdData).getOuts());
		} 
		String conditionsUuid = params.getConditionsUUID();
		// 获取数据源,获取传出，之后塞值
		ICompDbcpService dbs = (ICompDbcpService) SpringBeanUtil
				.getBean("compDbcpService");
		CompDbcp compDbcp = (CompDbcp) dbs.findByPrimaryKey(dataSource);
		Class.forName(compDbcp.getFdDriver());
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection connControl = null;
		PreparedStatement psControl = null;
		try {
			// 把数据插入缓存表
			String sql = "insert into tib_common_mapp_control_field" +
					"(fd_id, uu_id, conditions_uuid,  field_value, row_index, doc_create_time) values (?, ?, ?, ?, ?, ?)";
			connControl = this.getSession().connection();
			connControl.setAutoCommit(false);
			psControl = connControl.prepareStatement(sql);
			// 执行sql表达式取传出数据
			conn = DriverManager.getConnection(compDbcp.getFdUrl(), compDbcp
					.getFdUsername(), compDbcp.getFdPassword());
			ps = conn.prepareStatement(sqlExpression);
			rs = ps.executeQuery();
			ResultSetMetaData metaData = rs.getMetaData();
			int length = metaData.getColumnCount();
			// 标记为0是第一条数据
			int count = 0;
			while (rs.next()) {
				for (int i = 1; i <= length; i++) {
					Object obj = rs.getObject(i);
					if (obj == null) {
						obj = "";
					}
					String columnName = metaData.getColumnName(i);
					// 遍历传出字段对象，一一对应塞value值
					for (RelationParamsField outField : outFieldList) {
						String tagName = new String(Base64.decodeBase64(outField.getUuId().getBytes()));
						if (columnName.equals(tagName)) {
							// 存缓存数据库表
							psControl.setString(1, IDGenerator.generateID());
							psControl.setString(2, outField.getUuId());
							psControl.setString(3, conditionsUuid);
							psControl.setString(4, String.valueOf(obj));
							psControl.setInt(5, count + 1);
							psControl.setTimestamp(6, new Timestamp(new java.util.Date().getTime()));
//							if (count == 0) {
//								// 第一条数据
//								outField.setFieldValue(String.valueOf(obj));
//							} else {
//								// 多条则进行克隆
//								RelationParamsField newField = (RelationParamsField) outField.clone();
//								newField.setFieldValue(String.valueOf(obj));
//								newFieldList.add(newField);
//							}
							psControl.addBatch();
							// 3000条进行一次批量插入，否则在最后一条时插入
							if(i != 0 && i % 3000 == 0) {
								psControl.executeBatch();
								connControl.commit();
								psControl.clearBatch();
							} else if (rs.isLast()){
								psControl.executeBatch();
								connControl.commit();
								psControl.clearBatch();
							}
						}
					}
				}
				count++;
			}
			// 合并克隆的值
//			if (newFieldList.size() > 0) {
//				outFieldList.addAll(newFieldList);
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if (conn != null) {
				conn.close();
			}
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
			if (connControl != null) {
				connControl.close();
			}
			if (psControl != null) {
				psControl.close();
			}
		}
		return params;
	}
	
}

