package com.landray.kmss.example.rules.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkModel;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;

import com.landray.kmss.example.rules.model.ExampleRulesCategory;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.example.rules.model.ExampleRulesMain;

import com.landray.kmss.example.rules.forms.ExampleRulesMainForm;
import com.landray.kmss.sys.organization.forms.SysOrgElementForm;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.example.rules.forms.ExampleRulesCategoryForm;


import net.sf.cglib.transform.impl.InterceptFieldEnabled;

/**
 * 最新案例
 * 
 * @author 戴云
 * @version 1.0 2017-07-04
 */
public class ExampleRulesMain  extends BaseModel  implements IAttachment{

	/**
	 * 标题
	 */
	private String docSubject;
	
	/**
	 * @return 标题
	 */
	public String getDocSubject() {
		return this.docSubject;
	}
	
	/**
	 * @param docSubject 标题
	 */
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}
	
	/**
	 * 创建时间
	 */
	private Date docCreateTime;
	
	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return this.docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 案例类型
	 */
	private String fdWorkType;
	
	/**
	 * @return 案例类型
	 */
	public String getFdWorkType() {
		return this.fdWorkType;
	}
	
	/**
	 * @param fdWorkType 案例类型
	 */
	public void setFdWorkType(String fdWorkType) {
		this.fdWorkType = fdWorkType;
	}
	
	/**
	 * 发布时间
	 */
	private Date docPublishTime;
	
	/**
	 * @return 发布时间
	 */
	public Date getDocPublishTime() {
		return this.docPublishTime;
	}
	
	/**
	 * @param docPublishTime 发布时间
	 */
	public void setDocPublishTime(Date docPublishTime) {
		this.docPublishTime = docPublishTime;
	}
	
	/**
	 * 内容
	 */
	private String docContent;
	
	/**
	 * @return 内容
	 */
	public String getDocContent() {
		return (String) readLazyField("docContent", this.docContent);
	}
	
	/**
	 * @param docContent 内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * 通知方式
	 */
	private String fdNotifyType;
	
	/**
	 * @return 通知方式
	 */
	public String getFdNotifyType() {
		return this.fdNotifyType;
	}
	
	/**
	 * @param fdNotifyType 通知方式
	 */
	public void setFdNotifyType(String fdNotifyType) {
		this.fdNotifyType = fdNotifyType;
	}
	
	/**
	 * 文档状态
	 */
	private String docStatus;
	
	/**
	 * @return 文档状态
	 */
	public String getDocStatus() {
		return this.docStatus;
	}
	
	/**
	 * @param docStatus 文档状态
	 */
	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
	}
	
	/**
	 * 所属分类
	 */
	private ExampleRulesCategory docCategory;
	
	/**
	 * @return 所属分类
	 */
	public ExampleRulesCategory getDocCategory() {
		return this.docCategory;
	}
	
	/**
	 * @param docCategory 所属分类
	 */
	public void setDocCategory(ExampleRulesCategory docCategory) {
		this.docCategory = docCategory;
	}
	
	/**
	 * 创建者
	 */
	private SysOrgPerson docCreator;
	
	/**
	 * @return 创建者
	 */
	public SysOrgPerson getDocCreator() {
		return this.docCreator;
	}
	
	/**
	 * @param docCreator 创建者
	 */
	public void setDocCreator(SysOrgPerson docCreator) {
		this.docCreator = docCreator;
	}
	
	/**
	 * 通知人
	 */
	private List<SysOrgElement> fdNotifiers;
	
	/**
	 * @return 通知人
	 */
	public List<SysOrgElement> getFdNotifiers() {
		return this.fdNotifiers;
	}
	
	/**
	 * @param fdNotifiers 通知人
	 */
	public void setFdNotifiers(List<SysOrgElement> fdNotifiers) {
		this.fdNotifiers = fdNotifiers;
	}
	
	/**
	 * 可阅读者
	 */
	private List<SysOrgElement> authReaders;
	
	/**
	 * @return 可阅读者
	 */
	public List<SysOrgElement> getAuthReaders() {
		return this.authReaders;
	}
	
	/**
	 * @param authReaders 可阅读者
	 */
	public void setAuthReaders(List<SysOrgElement> authReaders) {
		this.authReaders = authReaders;
	}
	
	/**
	 * 可编辑者
	 */
	private List<SysOrgElement> authEditors;
	
	/**
	 * @return 可编辑者
	 */
	public List<SysOrgElement> getAuthEditors() {
		return this.authEditors;
	}
	
	/**
	 * @param authEditors 可编辑者
	 */
	public void setAuthEditors(List<SysOrgElement> authEditors) {
		this.authEditors = authEditors;
	}
	
	/**
	 * 其它可阅读者
	 */
	private List<SysOrgElement> authOtherReaders;
	
	/**
	 * @return 其它可阅读者
	 */
	public List<SysOrgElement> getAuthOtherReaders() {
		return this.authOtherReaders;
	}
	
	/**
	 * @param authOtherReaders 其它可阅读者
	 */
	public void setAuthOtherReaders(List<SysOrgElement> authOtherReaders) {
		this.authOtherReaders = authOtherReaders;
	}
	
	/**
	 * 所有可阅读者
	 */
	private List<SysOrgElement> authAllReaders;
	
	/**
	 * @return 所有可阅读者
	 */
	public List<SysOrgElement> getAuthAllReaders() {
		return this.authAllReaders;
	}
	
	/**
	 * @param authAllReaders 所有可阅读者
	 */
	public void setAuthAllReaders(List<SysOrgElement> authAllReaders) {
		this.authAllReaders = authAllReaders;
	}
	
	/**
	 * 其它可编辑者
	 */
	private List<SysOrgElement> authOtherEditors;
	
	/**
	 * @return 其它可编辑者
	 */
	public List<SysOrgElement> getAuthOtherEditors() {
		return this.authOtherEditors;
	}
	
	/**
	 * @param authOtherEditors 其它可编辑者
	 */
	public void setAuthOtherEditors(List<SysOrgElement> authOtherEditors) {
		this.authOtherEditors = authOtherEditors;
	}
	
	/**
	 * 所有可编辑者
	 */
	private List<SysOrgElement> authAllEditors;
	
	/**
	 * @return 所有可编辑者
	 */
	public List<SysOrgElement> getAuthAllEditors() {
		return this.authAllEditors;
	}
	
	/**
	 * @param authAllEditors 所有可编辑者
	 */
	public void setAuthAllEditors(List<SysOrgElement> authAllEditors) {
		this.authAllEditors = authAllEditors;
	}
	

	//机制开始
	//机制结束

	public Class<ExampleRulesMainForm> getFormClass() {
		return ExampleRulesMainForm.class;
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
			toFormPropertyMap.put("fdNotifiers",
					new ModelConvertor_ModelListToString(
							"fdNotifierIds:fdNotifierNames", "fdId:fdName"));
			toFormPropertyMap.put("authReaders",
					new ModelConvertor_ModelListToString(
							"authReaderIds:authReaderNames", "fdId:fdName"));
			toFormPropertyMap.put("authEditors",
					new ModelConvertor_ModelListToString(
							"authEditorIds:authEditorNames", "fdId:fdName"));
			toFormPropertyMap.put("authOtherReaders",
					new ModelConvertor_ModelListToString(
							"authOtherReaderIds:authOtherReaderNames", "fdId:fdName"));
			toFormPropertyMap.put("authAllReaders",
					new ModelConvertor_ModelListToString(
							"authAllReaderIds:authAllReaderNames", "fdId:fdName"));
			toFormPropertyMap.put("authOtherEditors",
					new ModelConvertor_ModelListToString(
							"authOtherEditorIds:authOtherEditorNames", "fdId:fdName"));
			toFormPropertyMap.put("authAllEditors",
					new ModelConvertor_ModelListToString(
							"authAllEditorIds:authAllEditorNames", "fdId:fdName"));
		}
		return toFormPropertyMap;
	}

	/**
     * 附件实现
     */
    AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);
	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
	}

}
