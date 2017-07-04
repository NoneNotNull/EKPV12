package com.landray.kmss.kms.knowledge.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeDocTemplate;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.AutoHashMap;


/**
 * 文档知识模版 Form
 * 
 * @author 
 * @version 1.0 2013-11-07
 */
public class KmsKnowledgeDocTemplateForm extends ExtendForm implements IAttachmentForm{

	/**
	 * 名称
	 */
	protected String fdName = null;
	
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
	protected String fdOrder = null;
	
	/**
	 * @return 排序号
	 */
	public String getFdOrder() {
		return fdOrder;
	}
	
	/**
	 * @param fdOrder 排序号
	 */
	public void setFdOrder(String fdOrder) {
		this.fdOrder = fdOrder;
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
	 * 模版内容
	 */
	protected String docContent = null;
	
	/**
	 * @return 模版内容
	 */
	public String getDocContent() {
		return docContent;
	}
	
	/**
	 * @param docContent 模版内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = docContent;
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
	
	private AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		AttachmentDetailsForm form=(AttachmentDetailsForm)attachmentForms.get("rattachment") ;
		AutoArrayList list=(AutoArrayList)form.getAttachments();
		for(int i=0;i<list.size();i++){
			SysAttMain main=(SysAttMain)list.get(i);
			String id=main.getFdId(); 
			for(int j=i+1;j<list.size();j++){
				SysAttMain main2=(SysAttMain)list.get(j);
				if(id.equals(main2.getFdId()  )){
				    list.remove(j);
				}
			}
			
		}
		 
		return attachmentForms;
	}

	public void setAttachmentForms(AutoHashMap autoHashMap) {
		this.attachmentForms = autoHashMap;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdName = null;
		fdOrder = null;
		docCreateTime = null;
		docContent = null;
		docCreatorId = null;
		docCreatorName = null;
		attachmentForms = new AutoHashMap(AttachmentDetailsForm.class);
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmsKnowledgeDocTemplate.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCreatorId",
					new FormConvertor_IDToModel("docCreator",
						SysOrgElement.class));
		}
		return toModelPropertyMap;
	}
}
