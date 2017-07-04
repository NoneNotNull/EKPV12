package com.landray.kmss.kms.knowledge.model;

import java.util.Date;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeDocTemplateForm;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.AutoHashMap;


/**
 * 文档知识模版
 * 
 * @author 
 * @version 1.0 2013-11-07
 */
public class KmsKnowledgeDocTemplate extends BaseModel implements IAttachment,InterceptFieldEnabled {

	/**
	 * 名称
	 */
	protected String fdName;
	
	/**
	 * @return 名称
	 */
	public String getFdName() {
		return fdName;
	}
	
	/**
	 * @param fdName 名称
	 */
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	
	/**
	 * 排序号
	 */
	protected Integer fdOrder;

	/**
	 * @return 排序号
	 */
	public Integer getFdOrder() {
		return fdOrder;
	}

	/**
	 * @param fdOrder
	 *            排序号
	 */
	public void setFdOrder(Integer fdOrder) {
		this.fdOrder = fdOrder;
	}
	
	
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
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 模版内容
	 */
	protected String docContent;
	
	/**
	 * @return 模版内容
	 */
	public String getDocContent() {
		return (String) readLazyField("docContent", docContent);
	}
	
	/**
	 * @param docContent 模版内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * 创建者
	 */
	protected SysOrgElement docCreator;
	
	/**
	 * @return 创建者
	 */
	public SysOrgElement getDocCreator() {
		return docCreator;
	}
	
	/**
	 * @param docCreator 创建者
	 */
	public void setDocCreator(SysOrgElement docCreator) {
		this.docCreator = docCreator;
	}
	
	public Class getFormClass() {
		return KmsKnowledgeDocTemplateForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
		}
		return toFormPropertyMap;
	}

	// =====附件机制(开始)=====
	protected AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return attachmentForms;
	}
}
