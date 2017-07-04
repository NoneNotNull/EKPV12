package com.landray.kmss.tib.sys.soap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.sys.edition.forms.SysEditionMainForm;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;


/**
 * WEBSERVCIE服务函数 Form
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapMainForm extends ExtendForm implements ISysEditionMainForm {

	
	protected String fdType;
	
	public String getFdType() {
		return fdType;
	}
	public void setFdType(String fdType) {
		this.fdType = fdType;
	}

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
	 * 文档状态
	 */
	protected String docStatus = "30";
	
	/**
	 * @return 文档状态
	 */
	public String getDocStatus() {
		return docStatus;
	}
	
	/**
	 * @param docStatus 文档状态
	 */
	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
	}
	
	/**
	 * 创建时间
	 */
	protected String docCreateTime = null;
	
	/**
	 * @return 创建时间
	 */
	public String getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 最后修改时间
	 */
	protected String docAlterTime = null;
	
	/**
	 * @return 最后修改时间
	 */
	public String getDocAlterTime() {
		return docAlterTime;
	}
	
	/**
	 * @param docAlterTime 最后修改时间
	 */
	public void setDocAlterTime(String docAlterTime) {
		this.docAlterTime = docAlterTime;
	}
	
	/**
	 * 是否启用
	 */
	protected String wsEnable = null;
	
	/**
	 * @return 是否启用
	 */
	public String getWsEnable() {
		return wsEnable;
	}
	
	/**
	 * @param wsEnable 是否启用
	 */
	public void setWsEnable(String wsEnable) {
		this.wsEnable = wsEnable;
	}
	
	/**
	 * 映射模板
	 */
	protected String wsMapperTemplate = null;
	
	/**
	 * @return 映射模板
	 */
	public String getWsMapperTemplate() {
		return wsMapperTemplate;
	}
	
	/**
	 * @param wsMapperTemplate 映射模板
	 */
	public void setWsMapperTemplate(String wsMapperTemplate) {
		this.wsMapperTemplate = wsMapperTemplate;
	}
	
	/**
	 * soap版本
	 */
	protected String wsSoapVersion = null;
	
	/**
	 * @return soap版本
	 */
	public String getWsSoapVersion() {
		return wsSoapVersion;
	}
	
	/**
	 * @param wsSoapVersion soap版本
	 */
	public void setWsSoapVersion(String wsSoapVersion) {
		this.wsSoapVersion = wsSoapVersion;
	}
	
	/**
	 * 绑定函数
	 */
	protected String wsBindFunc = null;
	
	/**
	 * @return 绑定函数
	 */
	public String getWsBindFunc() {
		return wsBindFunc;
	}
	
	/**
	 * @param wsBindFunc 绑定函数
	 */
	public void setWsBindFunc(String wsBindFunc) {
		this.wsBindFunc = wsBindFunc;
	}
	
	/**
	 * 备注
	 */
	protected String wsMarks = null;
	
	/**
	 * @return 备注
	 */
	public String getWsMarks() {
		return wsMarks;
	}
	
	/**
	 * @param wsMarks 备注
	 */
	public void setWsMarks(String wsMarks) {
		this.wsMarks = wsMarks;
	}
	
	/**
	 * 函数说明
	 */
	protected String wsBindFuncInfo = null;
	
	/**
	 * @return 函数说明
	 */
	public String getWsBindFuncInfo() {
		return wsBindFuncInfo;
	}
	
	/**
	 * @param wsBindFuncInfo 函数说明
	 */
	public void setWsBindFuncInfo(String wsBindFuncInfo) {
		this.wsBindFuncInfo = wsBindFuncInfo;
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
	 * 所属服务的ID
	 */
	protected String wsServerSettingId = null;
	
	/**
	 * @return 所属服务的ID
	 */
	public String getWsServerSettingId() {
		return wsServerSettingId;
	}
	
	/**
	 * @param wsServerSettingId 所属服务的ID
	 */
	public void setWsServerSettingId(String wsServerSettingId) {
		this.wsServerSettingId = wsServerSettingId;
	}
	
	/**
	 * 所属服务的名称
	 */
	protected String wsServerSettingName = null;
	
	/**
	 * @return 所属服务的名称
	 */
	public String getWsServerSettingName() {
		return wsServerSettingName;
	}
	
	/**
	 * @param wsServerSettingName 所属服务的名称
	 */
	public void setWsServerSettingName(String wsServerSettingName) {
		this.wsServerSettingName = wsServerSettingName;
	}
	
	/**
	 * 创建者的ID
	 */
	protected String docCreatorId = null;
	
	/**
	 * @return 创建者的ID
	 */
	public String getDocCreatorId() {
		return docCreatorId;
	}
	
	/**
	 * @param docCreatorId 创建者的ID
	 */
	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}
	
	/**
	 * 创建者的名称
	 */
	protected String docCreatorName = null;
	
	/**
	 * @return 创建者的名称
	 */
	public String getDocCreatorName() {
		return docCreatorName;
	}
	
	/**
	 * @param docCreatorName 创建者的名称
	 */
	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docSubject = null;
		docStatus = "30";
		docCreateTime = null;
		docAlterTime = null;
		wsEnable = null;
		wsMapperTemplate = null;
		wsSoapVersion = null;
		wsBindFunc = null;
		wsMarks = null;
		wsBindFuncInfo = null;
		docCategoryId = null;
		docCategoryName = null;
		wsServerSettingId = null;
		wsServerSettingName = null;
		docCreatorId = null;
		docCreatorName = null;
		docIsLocked = null;
		docIsNewVersion = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSoapMain.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
						TibSysSoapCategory.class));
			toModelPropertyMap.put("wsServerSettingId",
//					修正属性名称
					new FormConvertor_IDToModel("tibSysSoapSetting",
							TibSysSoapSetting.class));
					
					
			toModelPropertyMap.put("docCreatorId",
					new FormConvertor_IDToModel("docCreator",
						SysOrgElement.class));
		}
		return toModelPropertyMap;
	}

	/*
	 * 版本机制
	 */
	protected SysEditionMainForm editionForm = new SysEditionMainForm();

	public SysEditionMainForm getEditionForm() {
		return editionForm;
	}

	public void setEditionForm(SysEditionMainForm editionForm) {
		this.editionForm = editionForm;
	}
	
	protected String docIsLocked = null;
	protected String docIsNewVersion = null;
	public String getDocIsLocked() {
		return docIsLocked;
	}

	public void setDocIsLocked(String docIsLocked) {
		this.docIsLocked = docIsLocked;
	}

	public String getDocIsNewVersion() {
		return docIsNewVersion;
	}

	public void setDocIsNewVersion(String docIsNewVersion) {
		this.docIsNewVersion = docIsNewVersion;
	}
}
