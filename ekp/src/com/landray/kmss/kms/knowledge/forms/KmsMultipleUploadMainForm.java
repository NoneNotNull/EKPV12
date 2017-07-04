package com.landray.kmss.kms.knowledge.forms;

import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.util.AutoHashMap;

public class KmsMultipleUploadMainForm extends ExtendForm {

	private static final long serialVersionUID = 7180804073522213709L;

	/*
	 * 附件机制
	 */
	private AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return attachmentForms;
	}

	private String fdIds;

	public String getFdIds() {
		return fdIds;
	}

	public void setFdIds(String fdIds) {
		this.fdIds = fdIds;
	}

	public Class getModelClass() {
		return null;
	}

	private String modelPath;
	private String fdCategoryModelName;

	private String title;

	private String modelClassName;

	private String fdKey;

	private String fdCategoryId;
	
	private String fdCategoryName;

	public String getModelPath() {
		return modelPath;
	}

	public void setModelPath(String modelPath) {
		this.modelPath = modelPath;
	}

	public String getFdCategoryId() {
		return fdCategoryId;
	}

	public void setFdCategoryId(String fdCategoryId) {
		this.fdCategoryId = fdCategoryId;
	}
	
	public String getFdCategoryName() {
		return fdCategoryName;
	}

	public void setFdCategoryName(String fdCategoryName) {
		this.fdCategoryName = fdCategoryName;
	}

	public String getModelClassName() {
		return modelClassName;
	}

	public void setModelClassName(String modelClassName) {
		this.modelClassName = modelClassName;
	}

	public String getFdKey() {
		return fdKey;
	}

	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}

	public String getFdCategoryModelName() {
		return fdCategoryModelName;
	}

	public void setFdCategoryModelName(String fdCategoryModelName) {
		this.fdCategoryModelName = fdCategoryModelName;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * 这个值灰常重要，主要是用来在初始化流程的时候，构造requestContext对象使用 比如多维库的该字段名称为:fdTemplateId
	 */
	private String categoryIndicateName;

	public String getCategoryIndicateName() {
		return categoryIndicateName;
	}

	public void setCategoryIndicateName(String categoryIndicateName) {
		this.categoryIndicateName = categoryIndicateName;
	}

	private String attaFileNames;

	public String getAttaFileNames() {
		return attaFileNames;
	}

	public void setAttaFileNames(String attaFileNames) {
		this.attaFileNames = attaFileNames;
	}

	// 附件自身ID与数据库的FD_id关联关关系
	private String fdAttIdsJson;

	public String getFdAttIdsJson() {
		return fdAttIdsJson;
	}

	public void setFdAttIdsJson(String fdAttIdsJson) {
		this.fdAttIdsJson = fdAttIdsJson;
	}

	// 附件自身的ID与附件名称对应关系
	private String attIdAndAttNameJson;

	public String getAttIdAndAttNameJson() {
		return attIdAndAttNameJson;
	}

	public void setAttIdAndAttNameJson(String attIdAndAttNameJson) {
		this.attIdAndAttNameJson = attIdAndAttNameJson;
	}

	// 批量操作的附件自身的ID与对应的公有属性form对象的id对应关系
	private String batchIdJson;

	public String getBatchIdJson() {
		return batchIdJson;
	}

	public void setBatchIdJson(String batchIdJson) {
		this.batchIdJson = batchIdJson;
	}
	
	private String fdDocAddIds;

	public String getFdDocAddIds() {
		return fdDocAddIds;
	}

	public void setFdDocAddIds(String fdDocAddIds) {
		this.fdDocAddIds = fdDocAddIds;
	}
	
	private String fdDelIds;

	public String getFdDelIds() {
		return fdDelIds;
	}

	public void setFdDelIds(String fdDelIds) {
		this.fdDelIds = fdDelIds;
	}
}
