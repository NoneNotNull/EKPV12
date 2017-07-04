package com.landray.kmss.kms.knowledge.forms;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.sys.metadata.forms.ExtendDataFormInfo;
import com.landray.kmss.sys.tag.forms.SysTagMainForm;

/**
 * 用于多文档上传
 * 
 * @author Administrator
 * 
 */
public class KmsMultipleUploadEditDocForm extends KmsKnowledgeBaseDocForm {

	private static final long serialVersionUID = 864827895941743403L;

	private String fdNewId;

	public String getFdNewId() {
		return fdNewId;
	}

	public void setFdNewId(String fdNewId) {
		this.fdNewId = fdNewId;
	}
	
	private String spicDeleteAttIds;

	public String getSpicDeleteAttIds() {
		return spicDeleteAttIds;
	}

	public void setSpicDeleteAttIds(String spicDeleteAttIds) {
		this.spicDeleteAttIds = spicDeleteAttIds;
	}
	
	private String spicAttIds;

	public String getSpicAttIds() {
		return spicAttIds;
	}

	public void setSpicAttIds(String spicAttIds) {
		this.spicAttIds = spicAttIds;
	}
	
	private ExtendDataFormInfo extendDataFormInfo = new ExtendDataFormInfo();

	public ExtendDataFormInfo getExtendDataFormInfo() {
		return extendDataFormInfo;
	}

	public void setExtendDataFormInfo(ExtendDataFormInfo extendDataFormInfo) {
		this.extendDataFormInfo = extendDataFormInfo;
	}

	private String extendDataXML;

	public String getExtendDataXML() {
		return extendDataXML;
	}

	public void setExtendDataXML(String extendDataXML) {
		this.extendDataXML = extendDataXML;
	}

	private String extendFilePath;

	public String getExtendFilePath() {
		return extendFilePath;
	}

	public void setExtendFilePath(String extendFilePath) {
		this.extendFilePath = extendFilePath;
	}

	/*
	 * 目标form的class名称
	 */
	private String targetFormName;

	public String getTargetFormName() {
		return targetFormName;
	}

	public void setTargetFormName(String targetFormName) {
		this.targetFormName = targetFormName;
	}

	// ==============标签机制 开始==================
	private SysTagMainForm SysTagMainForm = new SysTagMainForm();

	public SysTagMainForm getSysTagMainForm() {
		return SysTagMainForm;
	}

	// model的class全名称
	private String fdModelName;

	public String getFdModelName() {
		return fdModelName;
	}

	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}

	private String attId;

	public String getAttId() {
		return attId;
	}

	public void setAttId(String attId) {
		this.attId = attId;
	}

	private String batchAttIds;

	public String getBatchAttIds() {
		return batchAttIds;
	}

	public void setBatchAttIds(String batchAttIds) {
		this.batchAttIds = batchAttIds;
	}

	/**
	 * (批量操作)记录有多少个文档记录会引用该form
	 */
	private int batchReferenceCount;

	public int getBatchReferenceCount() {
		return batchReferenceCount;
	}

	public void setBatchReferenceCount(int batchReferenceCount) {
		this.batchReferenceCount = batchReferenceCount;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		super.reset(mapping, request);
	}

	private String delFormIds;

	public String getDelFormIds() {
		return delFormIds;
	}

	public void setDelFormIds(String delFormIds) {
		this.delFormIds = delFormIds;
	}

	// 记录保存的时候
	private Date operateTime = null;

	public Date getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(Date operateTime) {
		this.operateTime = operateTime;
	}

	public Class<?> getModelClass() {
		// TODO 自动生成的方法存根
		return null;
	}

}
