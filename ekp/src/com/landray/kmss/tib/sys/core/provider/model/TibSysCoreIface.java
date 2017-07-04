package com.landray.kmss.tib.sys.core.provider.model;

import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceForm;

/**
 * provider接口信息
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreIface extends BaseModel implements InterceptFieldEnabled {

	/**
	 * 接口名称
	 */
	protected String fdIfaceName;
	
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
	protected String fdIfaceKey;
	
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
	protected Boolean fdIfaceControl;
	
	/**
	 * @return 接口前台控制
	 */
	public Boolean getFdIfaceControl() {
		return fdIfaceControl;
	}
	
	/**
	 * @param fdIfaceControl 接口前台控制
	 */
	public void setFdIfaceControl(Boolean fdIfaceControl) {
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
		return (String) readLazyField("fdIfaceXml", fdIfaceXml);
	}
	
	// 去除\
	public String getFdIfaceXmlTrans() {
		String ifaceXml = (String) readLazyField("fdIfaceXml", fdIfaceXml);
		ifaceXml = ifaceXml.replaceAll("\\\\", "");
		return ifaceXml ;
	}

	public void setFdIfaceXml(String fdIfaceXml) {
		this.fdIfaceXml = (String) writeLazyField("fdIfaceXml",
				this.fdIfaceXml, fdIfaceXml.trim());
	}

	/**
	 * 关联标签ID
	 */
	protected List<TibSysCoreTag> fdIfaceTags;
	
	/**
	 * @return 关联标签ID
	 */
	public List<TibSysCoreTag> getFdIfaceTags() {
		return fdIfaceTags;
	}
	
	/**
	 * @param fdIfaceTags 关联标签ID
	 */
	public void setFdIfaceTags(List<TibSysCoreTag> fdIfaceTags) {
		this.fdIfaceTags = fdIfaceTags;
	}
	
	public String getFdIfaceTagsStr() {
		List<TibSysCoreTag> tagList = getFdIfaceTags();
		String tagStr = "";
		for (TibSysCoreTag tag : tagList) {
			tagStr += tag.getFdTagName() +";";
		}
		return tagStr == "" ? "" : tagStr.substring(0, tagStr.length() - 1);
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

	public Class getFormClass() {
		return TibSysCoreIfaceForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdIfaceTags",
					new ModelConvertor_ModelListToString(
							"fdIfaceTagIds:fdIfaceTagNames", "fdId:fdTagName"));
		}
		return toFormPropertyMap;
	}

}
