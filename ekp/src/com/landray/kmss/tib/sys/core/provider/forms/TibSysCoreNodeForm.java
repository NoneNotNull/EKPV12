package com.landray.kmss.tib.sys.core.provider.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreNode;


/**
 * 节点信息 Form
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreNodeForm extends ExtendForm {

	/**
	 * node层级
	 */
	protected String fdNodeLevel = null;
	
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
	protected String fdNodeName = null;
	
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
	protected String fdNodePath = null;
	
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
	protected String fdDataType = null;
	
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
	protected String fdNodeEnable = null;
	
	/**
	 * @return node是否使用
	 */
	public String getFdNodeEnable() {
		return fdNodeEnable;
	}
	
	/**
	 * @param fdNodeEnable node是否使用
	 */
	public void setFdNodeEnable(String fdNodeEnable) {
		this.fdNodeEnable = fdNodeEnable;
	}
	
	/**
	 * node自定义名称
	 */
	protected String fdDefName = null;
	
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
	protected String fdNodeContent = null;
	
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
	 * node接口信息的ID
	 */
	protected String fdIfaceId = null;
	
	/**
	 * @return node接口信息的ID
	 */
	public String getFdIfaceId() {
		return fdIfaceId;
	}
	
	/**
	 * @param fdIfaceId node接口信息的ID
	 */
	public void setFdIfaceId(String fdIfaceId) {
		this.fdIfaceId = fdIfaceId;
	}
	
	/**
	 * node接口信息的名称
	 */
	protected String fdIfaceName = null;
	
	/**
	 * @return node接口信息的名称
	 */
	public String getFdIfaceName() {
		return fdIfaceName;
	}
	
	/**
	 * @param fdIfaceName node接口信息的名称
	 */
	public void setFdIfaceName(String fdIfaceName) {
		this.fdIfaceName = fdIfaceName;
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
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdNodeLevel = null;
		fdNodeName = null;
		fdNodePath = null;
		fdDataType = null;
		fdNodeEnable = null;
		fdDefName = null;
		fdNodeContent = null;
		fdIfaceId = null;
		fdIfaceName = null;
		fdAttrJson = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysCoreNode.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdIfaceId",
					new FormConvertor_IDToModel("fdIface",
						TibSysCoreIface.class));
		}
		return toModelPropertyMap;
	}
}
