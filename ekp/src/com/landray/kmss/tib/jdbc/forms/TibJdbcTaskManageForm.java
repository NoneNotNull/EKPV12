package com.landray.kmss.tib.jdbc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.jdbc.model.TibJdbcTaskCategory;
import com.landray.kmss.tib.jdbc.model.TibJdbcTaskManage;
import com.landray.kmss.util.AutoArrayList;


/**
 * 任务管理 Form
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcTaskManageForm extends ExtendForm {

	/**
	 * 任务名称
	 */
	protected String fdSubject = null;
	
	/**
	 * @return 任务名称
	 */
	public String getFdSubject() {
		return fdSubject;
	}
	
	/**
	 * @param fdSubject 任务名称
	 */
	public void setFdSubject(String fdSubject) {
		this.fdSubject = fdSubject;
	}
	
	/**
	 * 主表ID
	 */
	protected String fdModelId = null;
	
	/**
	 * @return 主表ID
	 */
	public String getFdModelId() {
		return fdModelId;
	}
	
	/**
	 * @param fdModelId 主表ID
	 */
	public void setFdModelId(String fdModelId) {
		this.fdModelId = fdModelId;
	}
	
	/**
	 * 主表域模型
	 */
	protected String fdModelName = null;
	
	/**
	 * @return 主表域模型
	 */
	public String getFdModelName() {
		return fdModelName;
	}
	
	/**
	 * @param fdModelName 主表域模型
	 */
	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}
	
	/**
	 * 关键字
	 */
	protected String fdKey = null;
	
	/**
	 * @return 关键字
	 */
	public String getFdKey() {
		return fdKey;
	}
	
	/**
	 * @param fdKey 关键字
	 */
	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}
	
	/**
	 * 任务service
	 */
	protected String fdJobService = null;
	
	/**
	 * @return 任务service
	 */
	public String getFdJobService() {
		return fdJobService;
	}
	
	/**
	 * @param fdJobService 任务service
	 */
	public void setFdJobService(String fdJobService) {
		this.fdJobService = fdJobService;
	}
	
	/**
	 * 任务方法
	 */
	protected String fdJobMethod = null;
	
	/**
	 * @return 任务方法
	 */
	public String getFdJobMethod() {
		return fdJobMethod;
	}
	
	/**
	 * @param fdJobMethod 任务方法
	 */
	public void setFdJobMethod(String fdJobMethod) {
		this.fdJobMethod = fdJobMethod;
	}
	
	/**
	 * 参数
	 */
	protected String fdParameter = null;
	
	/**
	 * @return 参数
	 */
	public String getFdParameter() {
		return fdParameter;
	}
	
	/**
	 * @param fdParameter 参数
	 */
	public void setFdParameter(String fdParameter) {
		this.fdParameter = fdParameter;
	}
	
	/**
	 * 是否系统任务
	 */
	protected String fdIsSysJob = null;
	
	/**
	 * @return 是否系统任务
	 */
	public String getFdIsSysJob() {
		return fdIsSysJob;
	}
	
	/**
	 * @param fdIsSysJob 是否系统任务
	 */
	public void setFdIsSysJob(String fdIsSysJob) {
		this.fdIsSysJob = fdIsSysJob;
	}
	
	/**
	 * 是否启用(是否激活)
	 */
	protected String fdIsEnabled = null;
	
	/**
	 * @return 是否启用
	 */
	public String getFdIsEnabled() {
		return fdIsEnabled;
	}
	
	/**
	 * @param fdIsEnabled 是否启用
	 */
	public void setFdIsEnabled(String fdIsEnabled) {
		this.fdIsEnabled = fdIsEnabled;
	}
	
	/**
	 * 是否必须
	 */
	protected String fdIsRequired = null;
	
	/**
	 * @return 是否必须
	 */
	public String getFdIsRequired() {
		return fdIsRequired;
	}
	
	/**
	 * @param fdIsRequired 是否必须
	 */
	public void setFdIsRequired(String fdIsRequired) {
		this.fdIsRequired = fdIsRequired;
	}
	
	/**
	 * 是否曾经触发
	 */
	protected String fdIsTriggered = null;
	
	/**
	 * @return 是否曾经触发
	 */
	public String getFdIsTriggered() {
		return fdIsTriggered;
	}
	
	/**
	 * @param fdIsTriggered 是否曾经触发
	 */
	public void setFdIsTriggered(String fdIsTriggered) {
		this.fdIsTriggered = fdIsTriggered;
	}
	
	/**
	 * 触发时间表达式
	 */
	protected String fdCronExpression = null;
	
	/**
	 * @return 触发时间表达式
	 */
	public String getFdCronExpression() {
		return fdCronExpression;
	}
	
	/**
	 * @param fdCronExpression 触发时间表达式
	 */
	public void setFdCronExpression(String fdCronExpression) {
		this.fdCronExpression = fdCronExpression;
	}
	
	/**
	 * 运行类型
	 */
	protected String fdRunType = null;
	
	/**
	 * @return 运行类型
	 */
	public String getFdRunType() {
		return fdRunType;
	}
	
	/**
	 * @param fdRunType 运行类型
	 */
	public void setFdRunType(String fdRunType) {
		this.fdRunType = fdRunType;
	}
	
	/**
	 * 预期运行时间
	 */
	protected String fdRunTime = null;
	
	/**
	 * @return 预期运行时间
	 */
	public String getFdRunTime() {
		return fdRunTime;
	}
	
	/**
	 * @param fdRunTime 预期运行时间
	 */
	public void setFdRunTime(String fdRunTime) {
		this.fdRunTime = fdRunTime;
	}
	
	/**
	 * EKP定时任务
	 */
	protected String fdQuartzEkp = null;
	
	/**
	 * @return EKP定时任务
	 */
	public String getFdQuartzEkp() {
		return fdQuartzEkp;
	}
	
	/**
	 * @param fdQuartzEkp EKP定时任务
	 */
	public void setFdQuartzEkp(String fdQuartzEkp) {
		this.fdQuartzEkp = fdQuartzEkp;
	}
	
	/**
	 * 相关链接
	 */
	protected String fdLink = null;
	
	/**
	 * @return 相关链接
	 */
	public String getFdLink() {
		return fdLink;
	}
	
	/**
	 * @param fdLink 相关链接
	 */
	public void setFdLink(String fdLink) {
		this.fdLink = fdLink;
	}
	
	/**
	 * 用途说明
	 */
	protected String fdUseExplain = null;
	
	/**
	 * @return 用途说明
	 */
	public String getFdUseExplain() {
		return fdUseExplain;
	}
	
	/**
	 * @param fdUseExplain 用途说明
	 */
	public void setFdUseExplain(String fdUseExplain) {
		this.fdUseExplain = fdUseExplain;
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
	 * 所属任务的表单
	 */
	protected AutoArrayList tibJdbcRelationListForms = new AutoArrayList(TibJdbcRelationForm.class);
	
	/**
	 * @return 所属任务的表单
	 */
	public AutoArrayList getTibJdbcRelationListForms() {
		return tibJdbcRelationListForms;
	}
	
	/**
	 * @param tibJdbcRelationListForms 所属任务的表单
	 */
	public void setTibJdbcRelationListForms(AutoArrayList tibJdbcRelationListForms) {
		this.tibJdbcRelationListForms = tibJdbcRelationListForms;
	}
	
	/**
	 * 临时表达式
	 */
	private String fdTempCronExpression;

	public String getFdTempCronExpression() {
		if (this.fdTempCronExpression == null)
			this.fdTempCronExpression = this.fdCronExpression;
		return this.fdTempCronExpression;
	}

	public void setFdTempCronExpression(String fdTempCronExpression) {
		this.fdTempCronExpression = fdTempCronExpression;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdSubject = null;
		fdModelId = null;
		fdModelName = null;
		fdKey = null;
		fdJobService = null;
		fdJobMethod = null;
		fdParameter = null;
		fdIsSysJob = null;
		fdIsEnabled = null;
		fdIsRequired = null;
		fdIsTriggered = null;
		fdCronExpression = "0 0 1 * * ?";
		fdTempCronExpression=null;
		fdRunType = null;
		fdRunTime = null;
		fdQuartzEkp = null;
		fdLink = null;
		fdUseExplain = null;
		docCategoryId = null;
		docCategoryName = null;
		tibJdbcRelationListForms = new AutoArrayList(TibJdbcRelationForm.class);
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibJdbcTaskManage.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
						TibJdbcTaskCategory.class));
			toModelPropertyMap.put("tibJdbcRelationListForms", new FormConvertor_FormListToModelList(
					"tibJdbcRelationList", "tibJdbcTaskManage"));
		}
		return toModelPropertyMap;
	}
}
