package com.landray.kmss.tib.sys.sap.connector.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.edition.interfaces.ISysEditionAutoDeleteModel;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainModel;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.sys.core.mapping.model.TibSysCoreMappingBaseSettingModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcSettingForm;

/**
 * RFC函数配置
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcSetting extends TibSysCoreMappingBaseSettingModel
		implements ISysEditionAutoDeleteModel {

	// protected String docStatus;
	// protected String docSubject;
	public TibSysSapRfcSetting() {
		setFdType(Constant.FD_TYPE_SAP);
	}

	/**
	 * 启用
	 */
	protected Boolean fdUse;

	/**
	 * @return 启用
	 */
	public Boolean getFdUse() {
		return fdUse;
	}

	/**
	 * @param fdUse
	 *            启用
	 */
	public void setFdUse(Boolean fdUse) {
		this.fdUse = fdUse;
	}

	/**
	 * 版本号
	 */
	protected String fdVersion;

	/**
	 * @return 版本号
	 */
	public String getFdVersion() {
		return fdVersion;
	}

	/**
	 * @param fdVersion
	 *            版本号
	 */
	public void setFdVersion(String fdVersion) {
		this.fdVersion = fdVersion;
	}

	/**
	 * 函数名称
	 */
	protected String fdFunctionName;

	/**
	 * @return 函数名称
	 */
	public String getFdFunctionName() {
		return fdFunctionName;
	}

	/**
	 * @param fdFunctionName
	 *            函数名称
	 */
	public void setFdFunctionName(String fdFunctionName) {
		this.fdFunctionName = fdFunctionName;
	}

	/**
	 * 关联函数
	 */
	protected String fdFunction;

	/**
	 * @return 关联函数
	 */
	public String getFdFunction() {
		return fdFunction;
	}

	/**
	 * @param fdFunction
	 *            关联函数
	 */
	public void setFdFunction(String fdFunction) {
		this.fdFunction = fdFunction;
	}

	/**
	 * 是否将BAPI进行commit
	 */
	protected Boolean fdCommit;

	public Boolean getFdCommit() {
		return fdCommit;
	}

	public void setFdCommit(Boolean fdCommit) {
		this.fdCommit = fdCommit;
	}

	/**
	 * 是否启用webservice
	 */
	protected Boolean fdWeb;

	/**
	 * @return 是否启用webservice
	 */
	public Boolean getFdWeb() {
		return fdWeb;
	}

	/**
	 * @param fdWeb
	 *            是否启用webservice
	 */
	public void setFdWeb(Boolean fdWeb) {
		this.fdWeb = fdWeb;
	}

	/**
	 * 备注
	 */
	protected String fdDescribe;

	/**
	 * @return 备注
	 */
	public String getFdDescribe() {
		return fdDescribe;
	}

	/**
	 * @param fdDescribe
	 *            备注
	 */
	public void setFdDescribe(String fdDescribe) {
		this.fdDescribe = fdDescribe;
	}

	/**
	 * 所属分类
	 */
	protected TibSysSapRfcCategory docCategory;

	/**
	 * @return 所属分类
	 */
	public TibSysSapRfcCategory getDocCategory() {
		return docCategory;
	}

	/**
	 * @param docCategory
	 *            所属分类
	 */
	public void setDocCategory(TibSysSapRfcCategory docCategory) {
		this.docCategory = docCategory;
	}

	/**
	 * 所属连接池
	 */
	protected TibSysSapJcoSetting fdPool;

	/**
	 * @return 所属连接池
	 */
	public TibSysSapJcoSetting getFdPool() {
		return fdPool;
	}

	protected List<TibSysSapRfcExport> tibSysSapRfcExport = new ArrayList<TibSysSapRfcExport>();
	protected List<TibSysSapRfcImport> tibSysSapRfcImport = new ArrayList<TibSysSapRfcImport>();

	protected List<TibSysSapRfcTable> tibSysSapRfcTable = new ArrayList<TibSysSapRfcTable>();

	// ====== //添加查询类===========
	/**
	 * RFC查询类
	 */
	protected List<TibSysSapRfcSearchInfo> rfcSearch;

	/**
	 * @return RFC查询类
	 */
	public List<TibSysSapRfcSearchInfo> getRfcSearch() {
		return rfcSearch;
	}

	/**
	 * @param rfcSearch
	 *            RFC查询类
	 */
	public void setRfcSearch(List<TibSysSapRfcSearchInfo> rfcSearch) {
		this.rfcSearch = rfcSearch;
	}

	// ====== //添加查询类===========

	/**
	 * @param fdPool
	 *            所属连接池
	 */
	public void setFdPool(TibSysSapJcoSetting fdPool) {
		this.fdPool = fdPool;
	}

	public Class getFormClass() {
		return TibSysSapRfcSettingForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			toFormPropertyMap.put("fdPool.fdId", "fdPoolId");
			toFormPropertyMap.put("fdPool.fdPoolName", "fdPoolName");
			toFormPropertyMap
					.put("tibSysSapRfcExport",
							new ModelConvertor_ModelListToFormList(
									"tibSysSapRfcExport"));
			toFormPropertyMap
					.put("tibSysSapRfcImport",
							new ModelConvertor_ModelListToFormList(
									"tibSysSapRfcImport"));
			toFormPropertyMap
					.put("tibSysSapRfcTable",
							new ModelConvertor_ModelListToFormList(
									"tibSysSapRfcTable"));
			// 添加查询类
			toFormPropertyMap.put("rfcSearch",
					new ModelConvertor_ModelListToFormList("rfcSearchForms"));
		}
		return toFormPropertyMap;
	}

	public List<TibSysSapRfcExport> getTibSysSapRfcExport() {
		return tibSysSapRfcExport;
	}

	public void setTibSysSapRfcExport(
			List<TibSysSapRfcExport> tibSysSapRfcExport) {
		this.tibSysSapRfcExport = tibSysSapRfcExport;
	}

	public List<TibSysSapRfcImport> getTibSysSapRfcImport() {
		return tibSysSapRfcImport;
	}

	public void setTibSysSapRfcImport(
			List<TibSysSapRfcImport> tibSysSapRfcImport) {
		this.tibSysSapRfcImport = tibSysSapRfcImport;
	}

	public List<TibSysSapRfcTable> getTibSysSapRfcTable() {
		return tibSysSapRfcTable;
	}

	public void setTibSysSapRfcTable(List<TibSysSapRfcTable> tibSysSapRfcTable) {
		this.tibSysSapRfcTable = tibSysSapRfcTable;
	}

	public String getDocStatus() {
		return docStatus;
	}

	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
	}

	// ==== 版本机制（开始） =====

	/*
	 * 是否是新版本
	 */
	protected Boolean docIsNewVersion = new Boolean(true);

	public Boolean getDocIsNewVersion() {
		return docIsNewVersion;
	}

	public void setDocIsNewVersion(Boolean docIsNewVersion) {
		this.docIsNewVersion = docIsNewVersion;
	}

	/*
	 * 版本锁定
	 */
	protected Boolean docIsLocked = new Boolean(false);

	public Boolean getDocIsLocked() {
		return docIsLocked;
	}

	public void setDocIsLocked(Boolean docIsLocked) {
		this.docIsLocked = docIsLocked;
	}

	/*
	 * 主版本号
	 */
	protected Long docMainVersion = new Long(1);

	public Long getDocMainVersion() {
		return docMainVersion;
	}

	public void setDocMainVersion(Long docMainVersion) {
		this.docMainVersion = docMainVersion;
	}

	/*
	 * 辅版本号
	 */
	protected Long docAuxiVersion = new Long(0);

	public Long getDocAuxiVersion() {
		return docAuxiVersion;
	}

	public void setDocAuxiVersion(Long docAuxiVersion) {
		this.docAuxiVersion = docAuxiVersion;
	}

	/*
	 * 主文档
	 */
	protected ISysEditionMainModel docOriginDoc;

	public ISysEditionMainModel getDocOriginDoc() {
		return docOriginDoc;
	}

	public void setDocOriginDoc(ISysEditionMainModel docOriginDoc) {
		this.docOriginDoc = docOriginDoc;
	}

	/*
	 * 历史版本
	 */
	protected List docHistoryEditions;

	public List getDocHistoryEditions() {
		return docHistoryEditions;
	}

	public void setDocHistoryEditions(List docHistoryEditions) {
		this.docHistoryEditions = docHistoryEditions;
	}

	// ==== 版本机制（结束） =====

	protected Date docCreateTime;

	protected SysOrgPerson docCreator;

	public Date getDocCreateTime() {
		return docCreateTime;
	}

	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}

	public SysOrgPerson getDocCreator() {
		return docCreator;
	}

	public void setDocCreator(SysOrgPerson docCreator) {
		this.docCreator = docCreator;
	}

	public String getDocSubject() {
		return fdFunctionName;
	}

}
