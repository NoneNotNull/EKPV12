package com.landray.kmss.tib.jdbc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSet;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSetCategory;


/**
 * 数据集管理 Form
 * 
 * @author 
 * @version 1.0 2014-04-15
 */
public class TibJdbcDataSetForm extends ExtendForm {

	/**
	 * 标题
	 */
	protected String docSubject = null;
	
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
	 * SQL语句
	 */
	protected String fdSqlExpression = null;
	
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
	
	/**
	 * 配置数据
	 */
	protected String fdData = null;
	
	/**
	 * @return 配置数据
	 */
	public String getFdData() {
		return fdData;
	}
	
	/**
	 * @param fdData 配置数据
	 */
	public void setFdData(String fdData) {
		this.fdData = fdData;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docSubject = null;
		fdDataSource = null;
		fdSqlExpression = null;
		docCategoryId = null;
		docCategoryName = null;
		fdData = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibJdbcDataSet.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
						TibJdbcDataSetCategory.class));
		}
		return toModelPropertyMap;
	}
}
