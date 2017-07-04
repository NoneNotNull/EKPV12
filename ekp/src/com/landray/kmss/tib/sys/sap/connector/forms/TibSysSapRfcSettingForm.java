package com.landray.kmss.tib.sys.sap.connector.forms;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.sys.edition.forms.SysEditionMainForm;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainForm;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.tib.sys.core.mapping.forms.TibSysCoreMappingBaseSettingForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.util.AutoArrayList;

/**
 * RFC函数配置 Form
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcSettingForm extends TibSysCoreMappingBaseSettingForm
		implements ISysEditionMainForm {

	protected String docStatus = "30";
	protected String docIsLocked = null;
	protected String docIsNewVersion = null;
	protected String docCreatorName = null;
	protected String docCreatorId = null;
	protected String docCreateTime = null;
	protected String docSubject = null;
	/**
	 * 启用
	 */
	protected String fdUse = null;

	public List<TibSysSapRfcTableForm> getTibSysSapRfcTable() {
		return tibSysSapRfcTable;
	}

	public void setTibSysSapRfcTable(
			List<TibSysSapRfcTableForm> tibSysSapRfcTable) {
		this.tibSysSapRfcTable = tibSysSapRfcTable;
	}

	/**
	 * @return 启用
	 */
	public String getFdUse() {
		return fdUse;
	}

	/**
	 * @param fdUse
	 *            启用
	 */
	public void setFdUse(String fdUse) {
		this.fdUse = fdUse;
	}

	/**
	 * 版本号
	 */
	protected String fdVersion = null;

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
	protected String fdFunctionName = null;

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
	protected String fdFunction = null;

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
	protected String fdCommit = null;

	public String getFdCommit() {
		return fdCommit;
	}

	public void setFdCommit(String fdCommit) {
		this.fdCommit = fdCommit;
	}

	/**
	 * 是否启用webservice
	 */
	protected String fdWeb = null;

	/**
	 * @return 是否启用webservice
	 */
	public String getFdWeb() {
		return fdWeb;
	}

	/**
	 * @param fdWeb
	 *            是否启用webservice
	 */
	public void setFdWeb(String fdWeb) {
		this.fdWeb = fdWeb;
	}

	/**
	 * 备注
	 */
	protected String fdDescribe = null;

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
	 * @param docCategoryId
	 *            所属分类的ID
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
	 * @param docCategoryName
	 *            所属分类的名称
	 */
	public void setDocCategoryName(String docCategoryName) {
		this.docCategoryName = docCategoryName;
	}

	/**
	 * 所属连接池的ID
	 */
	protected String fdPoolId = null;

	/**
	 * @return 所属连接池的ID
	 */
	public String getFdPoolId() {
		return fdPoolId;
	}

	/**
	 * @param fdPoolId
	 *            所属连接池的ID
	 */
	public void setFdPoolId(String fdPoolId) {
		this.fdPoolId = fdPoolId;
	}

	/**
	 * 所属连接池的名称
	 */
	protected String fdPoolName = null;

	/**
	 * @return 所属连接池的名称
	 */
	public String getFdPoolName() {
		return fdPoolName;
	}

	/**
	 * @param fdPoolName
	 *            所属连接池的名称
	 */
	public void setFdPoolName(String fdPoolName) {
		this.fdPoolName = fdPoolName;
	}

	protected List<TibSysSapRfcExportForm> tibSysSapRfcExport = new AutoArrayList(
			TibSysSapRfcExportForm.class);
	protected List<TibSysSapRfcImportForm> tibSysSapRfcImport = new AutoArrayList(
			TibSysSapRfcImportForm.class);
	protected List<TibSysSapRfcTableForm> tibSysSapRfcTable = new AutoArrayList(
			TibSysSapRfcTableForm.class);

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdUse = null;
		fdVersion = null;
		fdFunctionName = null;
		fdFunction = null;
		fdCommit = null;
		fdWeb = null;
		fdDescribe = null;
		docCategoryId = null;
		docCategoryName = null;
		fdPoolId = null;
		fdPoolName = null;
		docStatus = "30";
		docCreatorName = null;
		docCreatorId = null;
		docCreateTime = null;
		docSubject = null;
		docIsLocked = null;
		docIsNewVersion = null;
		rfcSearchForms = new AutoArrayList(TibSysSapRfcSearchInfoForm.class);
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSapRfcSetting.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
							TibSysSapRfcCategory.class));
			toModelPropertyMap.put("fdPoolId", new FormConvertor_IDToModel(
					"fdPool", TibSysSapJcoSetting.class));
			toModelPropertyMap.put("docCreatorId", new FormConvertor_IDToModel(
					"docCreator", SysOrgPerson.class));
			toModelPropertyMap.put("tibSysSapRfcExport",
					new FormConvertor_FormListToModelList("tibSysSapRfcExport",
							"TibSysSapRfcSetting"));
			toModelPropertyMap.put("tibSysSapRfcImport",
					new FormConvertor_FormListToModelList("tibSysSapRfcImport",
							"TibSysSapRfcSetting"));
			toModelPropertyMap.put("tibSysSapRfcTable",
					new FormConvertor_FormListToModelList("tibSysSapRfcTable",
							"TibSysSapRfcSetting"));
			toModelPropertyMap
					.put("rfcSearchForms",
							new FormConvertor_FormListToModelList("rfcSearch",
									"fdRfc"));
		}
		return toModelPropertyMap;
	}

	public List<TibSysSapRfcExportForm> getTibSysSapRfcExport() {
		return tibSysSapRfcExport;
	}

	public void setTibSysSapRfcExport(
			List<TibSysSapRfcExportForm> tibSysSapRfcExport) {
		this.tibSysSapRfcExport = tibSysSapRfcExport;
	}

	public List<TibSysSapRfcImportForm> getTibSysSapRfcImport() {
		return tibSysSapRfcImport;
	}

	public void setTibSysSapRfcImport(
			List<TibSysSapRfcImportForm> tibSysSapRfcImport) {
		this.tibSysSapRfcImport = tibSysSapRfcImport;
	}

	public String getDocStatus() {
		return docStatus;
	}

	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
	}

	public String getDocCreatorName() {
		return docCreatorName;
	}

	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}

	public String getDocCreatorId() {
		return docCreatorId;
	}

	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}

	public String getDocCreateTime() {
		return docCreateTime;
	}

	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}

	public String getDocSubject() {
		return fdFunctionName;
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

	/**
	 * rfc函数_id的表单
	 */
	protected AutoArrayList rfcSearchForms = new AutoArrayList(
			TibSysSapRfcSearchInfoForm.class);

	/**
	 * @return rfc函数_id的表单
	 */
	public AutoArrayList getRfcSearchForms() {
		return rfcSearchForms;
	}

	/**
	 * @param rfcSearchForms
	 *            rfc函数_id的表单
	 */
	public void setRfcSearchForms(AutoArrayList rfcSearchForms) {
		this.rfcSearchForms = rfcSearchForms;
	}

}
