package com.landray.kmss.tib.sys.core.provider.forms;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreTag;
import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.util.AutoArrayList;


/**
 * provider接口信息 Form
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreIfaceForm extends ExtendForm {

	/**
	 * 接口名称
	 */
	protected String fdIfaceName = null;
	
	/**
	 * @return 接口名称
	 */
	public String getFdIfaceName() {
		return fdIfaceName;
	}
	
	/**
	 * @param fdIfaceName 接口名称
	 */
	public void setFdIfaceName(String fdIfaceName) {
		this.fdIfaceName = fdIfaceName;
	}
	
	/**
	 * 接口key
	 */
	protected String fdIfaceKey = null;
	
	/**
	 * @return 接口key
	 */
	public String getFdIfaceKey() {
		return fdIfaceKey;
	}
	
	/**
	 * @param fdIfaceKey 接口key
	 */
	public void setFdIfaceKey(String fdIfaceKey) {
		this.fdIfaceKey = fdIfaceKey;
	}
	
	/**
	 * 接口前台控制
	 */
	protected String fdIfaceControl = null;
	
	/**
	 * @return 接口前台控制
	 */
	public String getFdIfaceControl() {
		return fdIfaceControl;
	}
	
	/**
	 * @param fdIfaceControl 接口前台控制
	 */
	public void setFdIfaceControl(String fdIfaceControl) {
		this.fdIfaceControl = fdIfaceControl;
	}
	
	/**
	 * 调度模式
	 */
	protected String fdControlPattern;
	
	public String getFdControlPattern() {
		return fdControlPattern;
	}

	public void setFdControlPattern(String fdControlPattern) {
		this.fdControlPattern = fdControlPattern;
	}
	
	/**
	 * 统一接口XML
	 */
	protected String fdIfaceXml;
	
	public String getFdIfaceXml() {
		return fdIfaceXml;
	}

	public void setFdIfaceXml(String fdIfaceXml) {
		this.fdIfaceXml = fdIfaceXml;
	}

	protected String fdIfaceTagVos = null;
	
	/**
	 * 关联标签ID的ID列表
	 */
	protected String fdIfaceTagIds = null;
	
	/**
	 * @return 关联标签ID的ID列表
	 */
	public String getFdIfaceTagIds() {
		return fdIfaceTagIds;
	}
	
	/**
	 * @param fdIfaceTagIds 关联标签ID的ID列表
	 */
	public void setFdIfaceTagIds(String fdIfaceTagIds) {
		this.fdIfaceTagIds = fdIfaceTagIds;
	}
	
	/**
	 * 关联标签ID的名称列表
	 */
	protected String fdIfaceTagNames = null;
	
	/**
	 * @return 关联标签ID的名称列表
	 */
	public String getFdIfaceTagNames() {
		return fdIfaceTagNames;
	}
	
	/**
	 * @param fdIfaceTagNames 关联标签ID的名称列表
	 */
	public void setFdIfaceTagNames(String fdIfaceTagNames) {
		this.fdIfaceTagNames = fdIfaceTagNames;
	}
	
	/**
	 * 接口说明
	 */
	private String fdNote;
	
	public String getFdNote() {
		return fdNote;
	}

	public void setFdNote(String fdNote) {
		this.fdNote = fdNote;
	}
	
	/**
	 * 接口类型
	 */
	private String fdIfaceType;

	public String getFdIfaceType() {
		return fdIfaceType;
	}

	public void setFdIfaceType(String fdIfaceType) {
		this.fdIfaceType = fdIfaceType;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdIfaceName = null;
		fdIfaceKey = null;
		fdIfaceControl = "false";
		fdControlPattern = null;
		fdIfaceXml = null;
		fdIfaceTagIds = null;
		fdIfaceTagVos=null;
		fdIfaceTagNames = null;
		fdIfaceType = "0";
		super.reset(mapping, request);
	}
	
	/**
	 * 从新设置名字
	 * @param refKey
	 * @param request
	 * @return
	 */
	public String getRefTypeKeyName(HttpServletRequest request){
		String pdName=null;
		String key =request.getParameter("fdIfaceKey");
		Map<String,String> rtnMap =TibSysCoreProviderPlugins.getConfigByKey(key);
		if(rtnMap!=null&&!rtnMap.isEmpty()){
			 pdName =rtnMap.get("providerName");
		}
		return pdName;
		
	}
	
	public Class getModelClass() {
		return TibSysCoreIface.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdIfaceTagIds", new FormConvertor_IDsToModelList(
					"fdIfaceTags", TibSysCoreTag.class));
		}
		return toModelPropertyMap;
	}

	public String getFdIfaceTagVos() {
		return fdIfaceTagVos;
	}

	public void setFdIfaceTagVos(String fdIfaceTagVos) {
		this.fdIfaceTagVos = fdIfaceTagVos;
	}
	
}
