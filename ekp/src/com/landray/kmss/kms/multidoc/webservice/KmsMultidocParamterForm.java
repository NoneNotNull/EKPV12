package com.landray.kmss.kms.multidoc.webservice;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.sys.webservice2.forms.AttachmentForm;

public class KmsMultidocParamterForm {

	// 文档标题 (必填)
	private String docSubject;

	// 文档模板id(必填)
	private String fdTemplateId;
	
	// 文档作者，流程发起人 (必填)
	private String docCreator;
	
	// 文档内容文本
	private String docContent;

	// 表单数据参数
	private String formValues;

	// 标签（多个标签用分号;隔开）
	private String tags;
	
	// 文档状态
	private String docStatus;

	// 
	//private String fdKeyword;

	// 辅类别ID
	private String docProperty;

	// 流程参数
	private String flowParam;

	// 附件
	private List<AttachmentForm> attachmentForms = new ArrayList<AttachmentForm>();
	
	// 属性
	 
	private List<MyEntry>   propertyList = new ArrayList<MyEntry> ();

	public List<AttachmentForm> getAttachmentForms() {
		return attachmentForms;
	}

	public void setAttachmentForms(List<AttachmentForm> attachmentForms) {
		this.attachmentForms = attachmentForms;
	}

	public String getDocSubject() {
		return docSubject;
	}

	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}

	public String getFdTemplateId() {
		return fdTemplateId;
	}

	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}

	public String getDocContent() {
		return docContent;
	}

	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}

	public String getFormValues() {
		return formValues;
	}

	public void setFormValues(String formValues) {
		this.formValues = formValues;
	}

	public String getDocStatus() {
		return docStatus;
	}

	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
	}

	public String getDocCreator() {
		return docCreator;
	}

	public void setDocCreator(String docCreator) {
		this.docCreator = docCreator;
	}

	public List<MyEntry>  getPropertyList() {
		return propertyList;
	}

	public void setPropertyList(List<MyEntry> propertyList) {
		this.propertyList = propertyList;
	}

	public String getDocProperty() {
		return docProperty;
	}

	public void setDocProperty(String docProperty) {
		this.docProperty = docProperty;
	}

	public String getFlowParam() {
		return flowParam;
	}

	public void setFlowParam(String flowParam) {
		this.flowParam = flowParam;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

}
