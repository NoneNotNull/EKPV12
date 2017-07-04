package com.landray.kmss.tib.jdbc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSet;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappCategory;
import com.landray.kmss.tib.jdbc.model.TibJdbcMappManage;


/**
 * 映射配置 Form
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcMappManageForm extends ExtendForm {

	/**
	 * 映射名称
	 */
	protected String docSubject = null;
	
	/**
	 * @return 映射名称
	 */
	public String getDocSubject() {
		return docSubject;
	}
	
	/**
	 * @param docSubject 映射名称
	 */
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}
	
	/**
	 * 数据集模版SQL
	 */
	protected String fdDataSetSql;
	
	public String getFdDataSetSql() {
		return fdDataSetSql;
	}

	public void setFdDataSetSql(String fdDataSetSql) {
		this.fdDataSetSql = fdDataSetSql;
	}
	
	/**
	 * 数据集
	 */
	protected String tibJdbcDataSetId;
	protected String tibJdbcDataSetName;
	
	public String getTibJdbcDataSetId() {
		return tibJdbcDataSetId;
	}

	public void setTibJdbcDataSetId(String tibJdbcDataSetId) {
		this.tibJdbcDataSetId = tibJdbcDataSetId;
	}

	public String getTibJdbcDataSetName() {
		return tibJdbcDataSetName;
	}

	public void setTibJdbcDataSetName(String tibJdbcDataSetName) {
		this.tibJdbcDataSetName = tibJdbcDataSetName;
	}

	/**
	 * 数据源
	 */
	protected String fdDataSource = null;
	
	/**
	 * @return 数据源
	 */
	public String getFdDataSource() {
		return fdDataSource;
	}
	
	/**
	 * @param fdDataSource 数据源
	 */
	public void setFdDataSource(String fdDataSource) {
		this.fdDataSource = fdDataSource;
	}
	
	/**
	 * 是否启用
	 */
	protected String fdIsEnabled = null;
	
	/**
	 * @return 是否启用
	 */
	public String getFdIsEnabled() {
		return fdIsEnabled;
	}
	
	/**
	 * @param fdIsEnabled 是否启用
	 */
	public void setFdIsEnabled(String fdIsEnabled) {
		this.fdIsEnabled = fdIsEnabled;
	}
	
	/**
	 * 数据源SQL
	 */
	protected String fdDataSourceSql = null;
	
	/**
	 * @return 数据源SQL
	 */
	public String getFdDataSourceSql() {
		return fdDataSourceSql;
	}
	
	/**
	 * @param fdDataSourceSql 数据源SQL
	 */
	public void setFdDataSourceSql(String fdDataSourceSql) {
		this.fdDataSourceSql = fdDataSourceSql;
	}
	
	/**
	 * 目标数据源
	 */
	protected String fdTargetSource = null;
	
	/**
	 * @return 目标数据源
	 */
	public String getFdTargetSource() {
		return fdTargetSource;
	}
	
	/**
	 * @param fdTargetSource 目标数据源
	 */
	public void setFdTargetSource(String fdTargetSource) {
		this.fdTargetSource = fdTargetSource;
	}
	
	/**
	 * 目标数据库已选表
	 */
	protected String fdTargetSourceSelectedTable = null;
	
	/**
	 * @return 目标数据库已选表
	 */
	public String getFdTargetSourceSelectedTable() {
		return fdTargetSourceSelectedTable;
	}
	
	/**
	 * @param fdTargetSourceSelectedTable 目标数据库已选表
	 */
	public void setFdTargetSourceSelectedTable(String fdTargetSourceSelectedTable) {
		this.fdTargetSourceSelectedTable = fdTargetSourceSelectedTable;
	}
	
	/**
	 * 映射关系JSON
	 */
	protected String fdMappConfigJson = null;
	
	/**
	 * @return 映射关系JSON
	 */
	public String getFdMappConfigJson() {
		return fdMappConfigJson;
	}
	
	/**
	 * @param fdMappConfigJson 映射关系JSON
	 */
	public void setFdMappConfigJson(String fdMappConfigJson) {
		this.fdMappConfigJson = fdMappConfigJson;
	}
	
	/**
	 * 所属分类的ID
	 */
	protected String docCategoryId = null;
	
	/**
	 * @return 所属分类的ID
	 */
	public String getDocCategoryId() {
		return docCategoryId;
	}
	
	/**
	 * @param docCategoryId 所属分类的ID
	 */
	public void setDocCategoryId(String docCategoryId) {
		this.docCategoryId = docCategoryId;
	}
	
	/**
	 * 所属分类的名称
	 */
	protected String docCategoryName = null;
	
	/**
	 * @return 所属分类的名称
	 */
	public String getDocCategoryName() {
		return docCategoryName;
	}
	
	/**
	 * @param docCategoryName 所属分类的名称
	 */
	public void setDocCategoryName(String docCategoryName) {
		this.docCategoryName = docCategoryName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docSubject = null;
		fdDataSource = null;
		fdIsEnabled = null;
		fdDataSourceSql = null;
		fdTargetSource = null;
		fdTargetSourceSelectedTable = null;
		fdMappConfigJson = null;
		docCategoryId = null;
		docCategoryName = null;
		tibJdbcDataSetId = null;
		tibJdbcDataSetName = null;
		fdDataSetSql = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibJdbcMappManage.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
						TibJdbcMappCategory.class));
			toModelPropertyMap.put("tibJdbcDataSetId",
					new FormConvertor_IDToModel("tibJdbcDataSet",
							TibJdbcDataSet.class));
		}
		return toModelPropertyMap;
	}
}
