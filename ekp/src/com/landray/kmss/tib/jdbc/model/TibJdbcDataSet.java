package com.landray.kmss.tib.jdbc.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.jdbc.forms.TibJdbcDataSetForm;

/**
 * 数据集管理
 * 
 * @author 
 * @version 1.0 2014-04-15
 */
public class TibJdbcDataSet extends BaseModel {

	/**
	 * 标题
	 */
	protected String docSubject;
	
	/**
	 * @return 标题
	 */
	public String getDocSubject() {
		return docSubject;
	}
	
	/**
	 * @param docSubject 标题
	 */
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}
	
	/**
	 * 数据源
	 */
	protected String fdDataSource;
	
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
	 * SQL语句
	 */
	protected String fdSqlExpression;
	
	/**
	 * @return SQL语句
	 */
	public String getFdSqlExpression() {
		return fdSqlExpression;
	}
	
	/**
	 * @param fdSqlExpression SQL语句
	 */
	public void setFdSqlExpression(String fdSqlExpression) {
		this.fdSqlExpression = fdSqlExpression;
	}
	
	/**
	 * 所属分类
	 */
	protected TibJdbcDataSetCategory docCategory;
	
	/**
	 * @return 所属分类
	 */
	public TibJdbcDataSetCategory getDocCategory() {
		return docCategory;
	}
	
	/**
	 * @param docCategory 所属分类
	 */
	public void setDocCategory(TibJdbcDataSetCategory docCategory) {
		this.docCategory = docCategory;
	}
	
	/**
	 * 配置数据
	 */
	protected String fdData;
	
	/**
	 * @return 配置数据
	 */
	public String getFdData() {
		return (String) readLazyField("fdData", fdData);
	}
	
	/**
	 * @param fdData 配置数据
	 */
	public void setFdData(String fdData) {
		this.fdData = (String) writeLazyField("fdData",
				this.fdData, fdData);
	}
	
	public Class getFormClass() {
		return TibJdbcDataSetForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
		}
		return toFormPropertyMap;
	}
}
