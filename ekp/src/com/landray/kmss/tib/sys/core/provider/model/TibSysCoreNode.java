package com.landray.kmss.tib.sys.core.provider.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;

import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreNode;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;

import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreNodeForm;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceForm;

/**
 * 节点信息
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreNode extends BaseModel {

	/**
	 * node层级
	 */
	protected String fdNodeLevel;
	
	/**
	 * @return node层级
	 */
	public String getFdNodeLevel() {
		return fdNodeLevel;
	}
	
	/**
	 * @param fdNodeLevel node层级
	 */
	public void setFdNodeLevel(String fdNodeLevel) {
		this.fdNodeLevel = fdNodeLevel;
	}
	
	/**
	 * node名称
	 */
	protected String fdNodeName;
	
	/**
	 * @return node名称
	 */
	public String getFdNodeName() {
		return fdNodeName;
	}
	
	/**
	 * @param fdNodeName node名称
	 */
	public void setFdNodeName(String fdNodeName) {
		this.fdNodeName = fdNodeName;
	}
	
	/**
	 * node位置
	 */
	protected String fdNodePath;
	
	/**
	 * @return node位置
	 */
	public String getFdNodePath() {
		return fdNodePath;
	}
	
	/**
	 * @param fdNodePath node位置
	 */
	public void setFdNodePath(String fdNodePath) {
		this.fdNodePath = fdNodePath;
	}
	
	/**
	 * data数据类型
	 */
	protected String fdDataType;
	
	/**
	 * @return data数据类型
	 */
	public String getFdDataType() {
		return fdDataType;
	}
	
	/**
	 * @param fdDataType data数据类型
	 */
	public void setFdDataType(String fdDataType) {
		this.fdDataType = fdDataType;
	}
	
	/**
	 * node是否使用
	 */
	protected Boolean fdNodeEnable;
	
	/**
	 * @return node是否使用
	 */
	public Boolean getFdNodeEnable() {
		return fdNodeEnable;
	}
	
	/**
	 * @param fdNodeEnable node是否使用
	 */
	public void setFdNodeEnable(Boolean fdNodeEnable) {
		this.fdNodeEnable = fdNodeEnable;
	}
	
	/**
	 * node自定义名称
	 */
	protected String fdDefName;
	
	/**
	 * @return node自定义名称
	 */
	public String getFdDefName() {
		return fdDefName;
	}
	
	/**
	 * @param fdDefName node自定义名称
	 */
	public void setFdDefName(String fdDefName) {
		this.fdDefName = fdDefName;
	}
	
	/**
	 * node内容
	 */
	protected String fdNodeContent;
	
	/**
	 * @return node内容
	 */
	public String getFdNodeContent() {
		return fdNodeContent;
	}
	
	/**
	 * @param fdNodeContent node内容
	 */
	public void setFdNodeContent(String fdNodeContent) {
		this.fdNodeContent = fdNodeContent;
	}
	
	/**
	 * node接口信息
	 */
	protected TibSysCoreIface fdIface;
	
	/**
	 * @return node接口信息
	 */
	public TibSysCoreIface getFdIface() {
		return fdIface;
	}
	
	/**
	 * @param fdIface node接口信息
	 */
	public void setFdIface(TibSysCoreIface fdIface) {
		this.fdIface = fdIface;
	}
	
	/**
	 * @param fdAttrJson属性信息
	 */
	private String fdAttrJson;
	
	public String getFdAttrJson() {
		return fdAttrJson;
	}

	public void setFdAttrJson(String fdAttrJson) {
		this.fdAttrJson = fdAttrJson;
	}
	
	/**
	 * 自定义位置
	 */
	private String fdDefPath;

	public String getFdDefPath() {
		return fdDefPath;
	}

	public void setFdDefPath(String fdDefPath) {
		this.fdDefPath = fdDefPath;
	}

	public Class getFormClass() {
		return TibSysCoreNodeForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdIface.fdId", "fdIfaceId");
			toFormPropertyMap.put("fdIface.fdId", "fdIfaceName");
		}
		return toFormPropertyMap;
	}
}
