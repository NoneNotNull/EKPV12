package com.landray.kmss.tib.sys.soap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettCategory;


/**
 * 分类信息 Form
 * 
 * @author kezm
 * @version 1.0 2013-06-16
 */
public class TibSysSoapSettCategoryForm extends ExtendForm {

	/**
	 * 名称
	 */
	protected String fdName = null;
	
	/**
	 * @return 名称
	 */
	public String getFdName() {
		return fdName;
	}
	
	/**
	 * @param fdName 名称
	 */
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	
	/**
	 * 层级ID
	 */
	protected String fdHierarchyId = null;
	
	/**
	 * @return 层级ID
	 */
	public String getFdHierarchyId() {
		return fdHierarchyId;
	}
	
	/**
	 * @param fdHierarchyId 层级ID
	 */
	public void setFdHierarchyId(String fdHierarchyId) {
		this.fdHierarchyId = fdHierarchyId;
	}
	
	/**
	 * 上级分类的ID
	 */
	protected String fdParentId = null;
	
	/**
	 * @return 上级分类的ID
	 */
	public String getFdParentId() {
		return fdParentId;
	}
	
	/**
	 * @param fdParentId 上级分类的ID
	 */
	public void setFdParentId(String fdParentId) {
		this.fdParentId = fdParentId;
	}
	
	/**
	 * 上级分类的名称
	 */
	protected String fdParentName = null;
	
	/**
	 * @return 上级分类的名称
	 */
	public String getFdParentName() {
		return fdParentName;
	}
	
	/**
	 * @param fdParentName 上级分类的名称
	 */
	public void setFdParentName(String fdParentName) {
		this.fdParentName = fdParentName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdName = null;
		fdHierarchyId = null;
		fdParentId = null;
		fdParentName = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSoapSettCategory.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdParentId",
					new FormConvertor_IDToModel("fdParent",
						TibSysSoapSettCategory.class));
		}
		return toModelPropertyMap;
	}
}
