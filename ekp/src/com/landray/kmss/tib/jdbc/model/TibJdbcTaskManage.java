package com.landray.kmss.tib.jdbc.model;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.jdbc.forms.TibJdbcTaskManageForm;

/**
 * 任务管理
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcTaskManage extends BaseModel {

	/**
	 * 任务名称
	 */
	protected String fdSubject;
	
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
	protected String fdModelId;
	
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
	protected String fdModelName;
	
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
	protected String fdKey;
	
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
	protected String fdJobService;
	
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
	protected String fdJobMethod;
	
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
	protected String fdParameter;
	
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
	 * 是否系统任务 (定时任务)
	 */
	protected Boolean fdIsSysJob=false;
	
	/**
	 * @return 是否系统任务
	 */
	public Boolean getFdIsSysJob() {
		return fdIsSysJob;
	}
	
	/**
	 * @param fdIsSysJob 是否系统任务
	 */
	public void setFdIsSysJob(Boolean fdIsSysJob) {
		this.fdIsSysJob = fdIsSysJob;
	}
	
	/**
	 * 是否启用 (是否激活)
	 */
	protected Boolean fdIsEnabled=false;
	
	/**
	 * @return 是否启用
	 */
	public Boolean getFdIsEnabled() {
		return fdIsEnabled;
	}
	
	/**
	 * @param fdIsEnabled 是否启用
	 */
	public void setFdIsEnabled(Boolean fdIsEnabled) {
		this.fdIsEnabled = fdIsEnabled;
	}
	
	/**
	 * 是否必须
	 */
	protected Boolean fdIsRequired=false;
	
	/**
	 * @return 是否必须
	 */
	public Boolean getFdIsRequired() {
		return fdIsRequired;
	}
	
	/**
	 * @param fdIsRequired 是否必须
	 */
	public void setFdIsRequired(Boolean fdIsRequired) {
		this.fdIsRequired = fdIsRequired;
	}
	
	/**
	 * 是否曾经触发
	 */
	protected Boolean fdIsTriggered;
	
	/**
	 * @return 是否曾经触发
	 */
	public Boolean getFdIsTriggered() {
		return fdIsTriggered;
	}
	
	/**
	 * @param fdIsTriggered 是否曾经触发
	 */
	public void setFdIsTriggered(Boolean fdIsTriggered) {
		this.fdIsTriggered = fdIsTriggered;
	}
	
	/**
	 * 触发时间表达式
	 */
	protected String fdCronExpression;
	
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
	protected Integer fdRunType;
	
	/**
	 * @return 运行类型
	 */
	public Integer getFdRunType() {
		return fdRunType;
	}
	
	/**
	 * @param fdRunType 运行类型
	 */
	public void setFdRunType(Integer fdRunType) {
		this.fdRunType = fdRunType;
	}
	
	/**
	 * 预期运行时间
	 */
	protected Date fdRunTime;
	
	/**
	 * @return 预期运行时间
	 */
	public Date getFdRunTime() {
		return fdRunTime;
	}
	
	/**
	 * @param fdRunTime 预期运行时间
	 */
	public void setFdRunTime(Date fdRunTime) {
		this.fdRunTime = fdRunTime;
	}
	
	/**
	 * EKP定时任务
	 */
	protected String fdQuartzEkp;
	
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
	protected String fdLink;
	
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
	protected String fdUseExplain;
	
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
	 * 所属分类
	 */
	protected TibJdbcTaskCategory docCategory;
	
	/**
	 * @return 所属分类
	 */
	public TibJdbcTaskCategory getDocCategory() {
		return docCategory;
	}
	
	/**
	 * @param docCategory 所属分类
	 */
	public void setDocCategory(TibJdbcTaskCategory docCategory) {
		this.docCategory = docCategory;
	}
	
	/**
	 * 映射关系列表
	 */
	protected List<TibJdbcRelation> tibJdbcRelationList;
	
	/**
	 * @return 映射关系列表
	 */
	public List<TibJdbcRelation> getTibJdbcRelationList() {
		return tibJdbcRelationList;
	}
	
	/**
	 * @param tibJdbcRelationList 映射关系列表
	 */
	public void setTibJdbcRelationList(List<TibJdbcRelation> tibJdbcRelationList) {
		this.tibJdbcRelationList = tibJdbcRelationList;
	}
	
	public Class getFormClass() {
		return TibJdbcTaskManageForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
			toFormPropertyMap.put("tibJdbcRelationList",
					new ModelConvertor_ModelListToFormList("tibJdbcRelationListForms"));
		}
		return toFormPropertyMap;
	}
}
