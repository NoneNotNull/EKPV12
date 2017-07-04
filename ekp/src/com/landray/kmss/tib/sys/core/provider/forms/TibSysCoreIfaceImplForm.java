package com.landray.kmss.tib.sys.core.provider.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIfaceImpl;


/**
 * 接口实现 Form
 * 
 * @author 
 * @version 1.0 2013-08-08
 */
public class TibSysCoreIfaceImplForm extends ExtendForm {

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
	 * 关联实现函数
	 */
	protected String fdImplRef = null;
	
	/**
	 * @return 关联实现函数
	 */
	public String getFdImplRef() {
		return fdImplRef;
	}
	
	/**
	 * @param fdImplRef 关联实现函数
	 */
	public void setFdImplRef(String fdImplRef) {
		this.fdImplRef = fdImplRef;
	}
	
	/**
	 * 关联实现函数名称
	 */
	protected String fdImplRefName = null;
	
	/**
	 * @return 关联实现函数名称
	 */
	public String getFdImplRefName() {
		return fdImplRefName;
	}
	
	/**
	 * @param fdImplRefName 关联实现函数名称
	 */
	public void setFdImplRefName(String fdImplRefName) {
		this.fdImplRefName = fdImplRefName;
	}
	
	/**
	 * 函数类型
	 */
	protected String fdFuncType = null;
	
	/**
	 * @return 函数类型
	 */
	public String getFdFuncType() {
		return fdFuncType;
	}
	
	/**
	 * @param fdFuncType 函数类型
	 */
	public void setFdFuncType(String fdFuncType) {
		this.fdFuncType = fdFuncType;
	}
	
	/**
	 * 函数类型名称
	 */
	protected String fdFuncTypeName = null;
	
	public String getFdFuncTypeName() {
		return fdFuncTypeName;
	}

	public void setFdFuncTypeName(String fdFuncTypeName) {
		this.fdFuncTypeName = fdFuncTypeName;
	}

	/**
	 * 映射数据
	 */
	protected String fdImplRefData = null;
	
	/**
	 * @return 映射数据
	 */
	public String getFdImplRefData() {
		return fdImplRefData;
	}
	
	/**
	 * @param fdImplRefData 映射数据
	 */
	public void setFdImplRefData(String fdImplRefData) {
		this.fdImplRefData = fdImplRefData;
	}
	
	/**
	 * 所属接口的ID
	 */
	protected String tibSysCoreIfaceId = null;
	
	/**
	 * @return 所属接口的ID
	 */
	public String getTibSysCoreIfaceId() {
		return tibSysCoreIfaceId;
	}
	
	/**
	 * @param tibSysCoreIfaceId 所属接口的ID
	 */
	public void setTibSysCoreIfaceId(String tibSysCoreIfaceId) {
		this.tibSysCoreIfaceId = tibSysCoreIfaceId;
	}
	
	/**
	 * 所属接口的名称
	 */
	protected String tibSysCoreIfaceName = null;
	
	/**
	 * @return 所属接口的名称
	 */
	public String getTibSysCoreIfaceName() {
		return tibSysCoreIfaceName;
	}
	
	/**
	 * @param tibSysCoreIfaceName 所属接口的名称
	 */
	public void setTibSysCoreIfaceName(String tibSysCoreIfaceName) {
		this.tibSysCoreIfaceName = tibSysCoreIfaceName;
	}
	
	/**
	 * 所属接口Xml目前状态。0：未改变，1：已变动
	 */
	protected String fdIfaceXmlStatus;
	
	public String getFdIfaceXmlStatus() {
		return fdIfaceXmlStatus;
	}

	public void setFdIfaceXmlStatus(String fdIfaceXmlStatus) {
		this.fdIfaceXmlStatus = fdIfaceXmlStatus;
	}
	
	/**
	 * 实现执行的顺序
	 */
	protected String fdOrderBy;

	public String getFdOrderBy() {
		return fdOrderBy;
	}

	public void setFdOrderBy(String fdOrderBy) {
		this.fdOrderBy = fdOrderBy;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdName = null;
		fdImplRef = null;
		fdImplRefName = null;
		fdFuncType = null;
		fdFuncTypeName = null;
		fdImplRefData = null;
		tibSysCoreIfaceId = null;
		tibSysCoreIfaceName = null;
		fdIfaceXmlStatus = "0";
		fdOrderBy = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysCoreIfaceImpl.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("tibSysCoreIfaceId",
					new FormConvertor_IDToModel("tibSysCoreIface",
						TibSysCoreIface.class));
		}
		return toModelPropertyMap;
	}
}
