package com.landray.kmss.tib.sys.soap.connector.model;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.edition.interfaces.ISysEditionAutoDeleteModel;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainModel;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.sys.core.mapping.model.TibSysCoreMappingBaseSettingModel;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapMainForm;

/**
 * WEBSERVCIE服务函数
 * 
 * @author
 * @version 1.0 2012-08-06
 */
@SuppressWarnings("serial")
public class TibSysSoapMain extends TibSysCoreMappingBaseSettingModel implements
		ISysEditionAutoDeleteModel {
	//设置类型默认值
	public TibSysSoapMain(){
		setFdType(Constant.FD_TYPE_SOAP);
	}
	
	
//	/**
//	 * 标题
//	 */
//	protected String docSubject;
//
//	/**
//	 * @return 标题
//	 */
//	public String getDocSubject() {
//		return docSubject;
//	}
//
//	/**
//	 * @param docSubject
//	 *            标题
//	 */
//	public void setDocSubject(String docSubject) {
//		this.docSubject = docSubject;
//	}
//
//	/**
//	 * 文档状态
//	 */
//	protected String docStatus;
//
//	/**
//	 * @return 文档状态
//	 */
//	public String getDocStatus() {
//		return docStatus;
//	}
//
//	/**
//	 * @param docStatus
//	 *            文档状态
//	 */
//	public void setDocStatus(String docStatus) {
//		this.docStatus = docStatus;
//	}

	/**
	 * 创建时间
	 */
	protected Date docCreateTime;

	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return docCreateTime;
	}

	/**
	 * @param docCreateTime
	 *            创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}

	/**
	 * 最后修改时间
	 */
	protected Date docAlterTime;

	/**
	 * @return 最后修改时间
	 */
	public Date getDocAlterTime() {
		return docAlterTime;
	}

	/**
	 * @param docAlterTime
	 *            最后修改时间
	 */
	public void setDocAlterTime(Date docAlterTime) {
		this.docAlterTime = docAlterTime;
	}

	/**
	 * 是否启用
	 */
	protected Boolean wsEnable;

	/**
	 * @return 是否启用
	 */
	public Boolean getWsEnable() {
		return wsEnable;
	}

	/**
	 * @param wsEnable
	 *            是否启用
	 */
	public void setWsEnable(Boolean wsEnable) {
		this.wsEnable = wsEnable;
	}

	/**
	 * 映射模板
	 */
	protected String wsMapperTemplate;

	/**
	 * @return 映射模板
	 */
	public String getWsMapperTemplate() {
		return (String) readLazyField("wsMapperTemplate", wsMapperTemplate);
	}

	/**
	 * @param wsMapperTemplate
	 *            映射模板
	 */
	public void setWsMapperTemplate(String wsMapperTemplate) {
		this.wsMapperTemplate = (String) writeLazyField("wsMapperTemplate",
				this.wsMapperTemplate, wsMapperTemplate);
	}

	/**
	 * soap版本
	 */
	protected String wsSoapVersion;

	/**
	 * @return soap版本
	 */
	public String getWsSoapVersion() {
		return wsSoapVersion;
	}

	/**
	 * @param wsSoapVersion
	 *            soap版本
	 */
	public void setWsSoapVersion(String wsSoapVersion) {
		this.wsSoapVersion = wsSoapVersion;
	}

	/**
	 * 绑定函数
	 */
	protected String wsBindFunc;

	/**
	 * @return 绑定函数
	 */
	public String getWsBindFunc() {
		return wsBindFunc;
	}

	/**
	 * @param wsBindFunc
	 *            绑定函数
	 */
	public void setWsBindFunc(String wsBindFunc) {
		this.wsBindFunc = wsBindFunc;
	}

	/**
	 * 备注
	 */
	protected String wsMarks;

	/**
	 * @return 备注
	 */
	public String getWsMarks() {
		return wsMarks;
	}

	/**
	 * @param wsMarks
	 *            备注
	 */
	public void setWsMarks(String wsMarks) {
		this.wsMarks = wsMarks;
	}

	/**
	 * 函数说明
	 */
	protected String wsBindFuncInfo;

	/**
	 * @return 函数说明
	 */
	public String getWsBindFuncInfo() {
		return wsBindFuncInfo;
	}

	/**
	 * @param wsBindFuncInfo
	 *            函数说明
	 */
	public void setWsBindFuncInfo(String wsBindFuncInfo) {
		this.wsBindFuncInfo = wsBindFuncInfo;
	}

	/**
	 * 所属分类
	 */
	protected TibSysSoapCategory docCategory;

	/**
	 * @return 所属分类
	 */
	public TibSysSoapCategory getDocCategory() {
		return docCategory;
	}

	/**
	 * @param docCategory
	 *            所属分类
	 */
	public void setDocCategory(TibSysSoapCategory docCategory) {
		this.docCategory = docCategory;
	}

	/**
	 * 所属服务
	 */
	protected TibSysSoapSetting tibSysSoapSetting;


	public TibSysSoapSetting getTibSysSoapSetting() {
		return tibSysSoapSetting;
	}

	public void setTibSysSoapSetting(TibSysSoapSetting tibSysSoapSetting) {
		this.tibSysSoapSetting = tibSysSoapSetting;
	}


	/**
	 * 创建者
	 */
	protected SysOrgPerson docCreator;

	/**
	 * @return 创建者
	 */
	public SysOrgPerson getDocCreator() {
		return docCreator;
	}

	/**
	 * @param docCreator
	 *            创建者
	 */
	public void setDocCreator(SysOrgPerson docCreator) {
		this.docCreator = docCreator;
	}

	public Class getFormClass() {
		return TibSysSoapMainForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
/*			toFormPropertyMap.put("wsServerSetting.fdId", "wsServerSettingId");
			toFormPropertyMap.put("wsServerSetting.docSubject",
					"wsServerSettingName");*/
//			修正属性名称
			toFormPropertyMap.put("tibSysSoapSetting.fdId", "wsServerSettingId");
			toFormPropertyMap.put("tibSysSoapSetting.docSubject",
					"wsServerSettingName");
			
			
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
		}
		return toFormPropertyMap;
	}

	// ==== 版本机制（开始） =====
	/**
	 * 是否是新版本
	 */
	protected Boolean docIsNewVersion = new Boolean(true);

	public Boolean getDocIsNewVersion() {
		return docIsNewVersion;
	}

	public void setDocIsNewVersion(Boolean docIsNewVersion) {
		this.docIsNewVersion = docIsNewVersion;
	}

	/**
	 * 版本锁定
	 */
	protected Boolean docIsLocked = new Boolean(false);

	public Boolean getDocIsLocked() {
		return docIsLocked;
	}

	public void setDocIsLocked(Boolean docIsLocked) {
		this.docIsLocked = docIsLocked;
	}

	/**
	 * 主版本号
	 */
	protected Long docMainVersion = new Long(1);

	public Long getDocMainVersion() {
		return docMainVersion;
	}

	public void setDocMainVersion(Long docMainVersion) {
		this.docMainVersion = docMainVersion;
	}

	/**
	 * 辅版本号
	 */
	protected Long docAuxiVersion = new Long(0);

	public Long getDocAuxiVersion() {
		return docAuxiVersion;
	}

	public void setDocAuxiVersion(Long docAuxiVersion) {
		this.docAuxiVersion = docAuxiVersion;
	}

	/**
	 * 主文档
	 */
	protected ISysEditionMainModel docOriginDoc;

	public ISysEditionMainModel getDocOriginDoc() {
		return docOriginDoc;
	}

	public void setDocOriginDoc(ISysEditionMainModel docOriginDoc) {
		this.docOriginDoc = docOriginDoc;
	}

	/**
	 * 历史版本
	 */
	protected List docHistoryEditions;

	public List getDocHistoryEditions() {
		return docHistoryEditions;
	}

	public void setDocHistoryEditions(List docHistoryEditions) {
		this.docHistoryEditions = docHistoryEditions;
	}
	
	@Override
	public void setFdType(String fdType) {
		// TODO 自动生成的方法存根
		super.setFdType(Constant.FD_TYPE_SOAP);
	}
	
	@Override
	public String getFdType() {
		// TODO 自动生成的方法存根
		return Constant.FD_TYPE_SOAP;
	}

	// ==== 版本机制（结束） =====

}
