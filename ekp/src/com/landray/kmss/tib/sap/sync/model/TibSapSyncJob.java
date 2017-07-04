package com.landray.kmss.tib.sap.sync.model;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sap.sync.forms.TibSapSyncJobForm;

/**
 * 定时任务
 * 
 * @author 
 * @version 1.0 2011-10-20
 */
public class TibSapSyncJob extends BaseModel {

	/**
	 * 主域模块名
	 */
	protected String fdModelName;
	
	/**
	 * @return 主域模块名
	 */
	public String getFdModelName() {
		return fdModelName;
	}
	
	/**
	 * @param fdModelName 主域模块名
	 */
	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}
	
	/**
	 * 主域模块id
	 */
	protected String fdModelId;
	
	/**
	 * @return 主域模块id
	 */
	public String getFdModelId() {
		return fdModelId;
	}
	
	/**
	 * @param fdModelId 主域模块id
	 */
	public void setFdModelId(String fdModelId) {
		this.fdModelId = fdModelId;
	}
	
	/**
	 * key
	 */
	protected String fdKey;
	
	/**
	 * @return key
	 */
	public String getFdKey() {
		return fdKey;
	}
	
	/**
	 * @param fdKey key
	 */
	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}
	
	/**
	 * 标题
	 */
	protected String fdSubject;
	
	/**
	 * @return 标题
	 */
	public String getFdSubject() {
		return fdSubject;
	}
	
	/**
	 * @param fdSubject 标题
	 */
	public void setFdSubject(String fdSubject) {
		this.fdSubject = fdSubject;
	}
	
	/**
	 * job调用服务
	 */
	protected String fdJobService;
	
	/**
	 * @return job调用服务
	 */
	public String getFdJobService() {
		return fdJobService;
	}
	
	/**
	 * @param fdJobService job调用服务
	 */
	public void setFdJobService(String fdJobService) {
		this.fdJobService = fdJobService;
	}
	
	/**
	 * job调用方法
	 */
	protected String fdJobMethod;
	
	/**
	 * @return job调用方法
	 */
	public String getFdJobMethod() {
		return fdJobMethod;
	}
	
	/**
	 * @param fdJobMethod job调用方法
	 */
	public void setFdJobMethod(String fdJobMethod) {
		this.fdJobMethod = fdJobMethod;
	}
	
	/**
	 * 链接
	 */
	protected String fdLink;
	
	/**
	 * @return 链接
	 */
	public String getFdLink() {
		return fdLink;
	}
	
	/**
	 * @param fdLink 链接
	 */
	public void setFdLink(String fdLink) {
		this.fdLink = fdLink;
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
	 * 时间表达式
	 */
	protected String fdCronExpression;
	
	/**
	 * @return 时间表达式
	 */
	public String getFdCronExpression() {
		return fdCronExpression;
	}
	
	/**
	 * @param fdCronExpression 时间表达式
	 */
	public void setFdCronExpression(String fdCronExpression) {
		this.fdCronExpression = fdCronExpression;
	}
	
	/**
	 * 是否激活
	 */
	protected Boolean fdEnabled=false;
	
	/**
	 * @return 是否激活
	 */
	public Boolean getFdEnabled() {
		return fdEnabled;
	}
	
	/**
	 * @param fdEnabled 是否激活
	 */
	public void setFdEnabled(Boolean fdEnabled) {
		this.fdEnabled = fdEnabled;
	}
	
	/**
	 * 是否定时任务
	 */
	protected Boolean fdIsSysJob=false;
	
	/**
	 * @return 是否定时任务
	 */
	public Boolean getFdIsSysJob() {
		return fdIsSysJob;
	}
	
	/**
	 * @param fdIsSysJob 是否定时任务
	 */
	public void setFdIsSysJob(Boolean fdIsSysJob) {
		this.fdIsSysJob = fdIsSysJob;
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
	 * 运行时间
	 */
	protected Date fdRunTime;
	
	/**
	 * @return 运行时间
	 */
	public Date getFdRunTime() {
		return fdRunTime;
	}
	
	/**
	 * @param fdRunTime 运行时间
	 */
	public void setFdRunTime(Date fdRunTime) {
		this.fdRunTime = fdRunTime;
	}
	
	/**
	 * 是否需要
	 */
	protected Boolean fdRequired=false;
	
	/**
	 * @return 是否需要
	 */
	public Boolean getFdRequired() {
		return fdRequired;
	}
	
	/**
	 * @param fdRequired 是否需要
	 */
	public void setFdRequired(Boolean fdRequired) {
		this.fdRequired = fdRequired;
	}
	
	/**
	 * 触发器
	 */
	protected Boolean fdTriggered;
	
	/**
	 * @return 触发器
	 */
	public Boolean getFdTriggered() {
		return fdTriggered;
	}
	
	/**
	 * @param fdTriggered 触发器
	 */
	public void setFdTriggered(Boolean fdTriggered) {
		this.fdTriggered = fdTriggered;
	}
	
	/**
	 * ekp定时任务
	 */
	protected String fdQuartzEkp;
	
	/**
	 * @return ekp定时任务
	 */
	public String getFdQuartzEkp() {
		return fdQuartzEkp;
	}
	
	/**
	 * @param fdQuartzEkp ekp定时任务
	 */
	public void setFdQuartzEkp(String fdQuartzEkp) {
		this.fdQuartzEkp = fdQuartzEkp;
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
	 * 定时任务映射信息
	 */
	protected List<TibSapSyncTempFunc> fdSapInfo;
	
	/**
	 * @return 定时任务映射信息
	 */
	public List<TibSapSyncTempFunc> getFdSapInfo() {
		return fdSapInfo;
	}
	
	/**
	 * @param fdSapInfo 定时任务映射信息
	 */
	public void setFdSapInfo(List<TibSapSyncTempFunc> fdSapInfo) {
		this.fdSapInfo = fdSapInfo;
	}
	
	/**
	 * 所属分类
	 */
	protected TibSapSyncCategory docCategory;
	
	/**
	 * @return 所属分类
	 */
	public TibSapSyncCategory getDocCategory() {
		return docCategory;
	}
	
	/**
	 * @param docCategory 所属分类
	 */
	public void setDocCategory(TibSapSyncCategory docCategory) {
		this.docCategory = docCategory;
	}
	
	public Class getFormClass() {
		return TibSapSyncJobForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
			toFormPropertyMap.put("fdSapInfo",
					new ModelConvertor_ModelListToFormList("fdSapInfoForms"));
		}
		return toFormPropertyMap;
	}
}
