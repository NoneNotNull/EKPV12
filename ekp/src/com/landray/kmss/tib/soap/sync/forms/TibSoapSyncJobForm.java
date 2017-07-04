package com.landray.kmss.tib.soap.sync.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncCategory;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncJob;
import com.landray.kmss.util.AutoArrayList;


/**
 * 定时任务 Form
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public class TibSoapSyncJobForm extends ExtendForm {

	/**
	 * 主域模块名
	 */
	protected String fdModelName = null;
	
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
	protected String fdModelId = null;
	
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
	protected String fdKey = null;
	
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
	protected String fdSubject = null;
	
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
	protected String fdJobService = null;
	
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
	protected String fdJobMethod = null;
	
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
	protected String fdLink = null;
	
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
	 * 时间表达式
	 */
	protected String fdCronExpression = null;
	
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
	protected String fdEnabled = null;
	
	/**
	 * @return 是否激活
	 */
	public String getFdEnabled() {
		return fdEnabled;
	}
	
	/**
	 * @param fdEnabled 是否激活
	 */
	public void setFdEnabled(String fdEnabled) {
		this.fdEnabled = fdEnabled;
	}
	
	/**
	 * 是否定时任务
	 */
	protected String fdIsSysJob = null;
	
	/**
	 * @return 是否定时任务
	 */
	public String getFdIsSysJob() {
		return fdIsSysJob;
	}
	
	/**
	 * @param fdIsSysJob 是否定时任务
	 */
	public void setFdIsSysJob(String fdIsSysJob) {
		this.fdIsSysJob = fdIsSysJob;
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
	 * 运行时间
	 */
	protected String fdRunTime = null;
	
	/**
	 * @return 运行时间
	 */
	public String getFdRunTime() {
		return fdRunTime;
	}
	
	/**
	 * @param fdRunTime 运行时间
	 */
	public void setFdRunTime(String fdRunTime) {
		this.fdRunTime = fdRunTime;
	}
	
	/**
	 * 是否需要
	 */
	protected String fdRequired = null;
	
	/**
	 * @return 是否需要
	 */
	public String getFdRequired() {
		return fdRequired;
	}
	
	/**
	 * @param fdRequired 是否需要
	 */
	public void setFdRequired(String fdRequired) {
		this.fdRequired = fdRequired;
	}
	
	/**
	 * 触发器
	 */
	protected String fdTriggered = null;
	
	/**
	 * @return 触发器
	 */
	public String getFdTriggered() {
		return fdTriggered;
	}
	
	/**
	 * @param fdTriggered 触发器
	 */
	public void setFdTriggered(String fdTriggered) {
		this.fdTriggered = fdTriggered;
	}
	
	/**
	 * ekp定时任务
	 */
	protected String fdQuartzEkp = null;
	
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
	 * 上级分类
	 */
	protected String fdParentId = null;
	
	/**
	 * @return 上级分类
	 */
	public String getFdParentId() {
		return fdParentId;
	}
	
	/**
	 * @param fdParentId 上级分类
	 */
	public void setFdParentId(String fdParentId) {
		this.fdParentId = fdParentId;
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
	 * 定时任务id的表单
	 */
	protected AutoArrayList fdSoapInfoForms = new AutoArrayList(TibSoapSyncTempFuncForm.class);
	
	/**
	 * @return 定时任务id的表单
	 */
	public AutoArrayList getFdSoapInfoForms() {
		return fdSoapInfoForms;
	}
	
	/**
	 * @param fdSoapInfoForms 定时任务id的表单
	 */
	public void setFdSoapInfoForms(AutoArrayList fdSoapInfoForms) {
		this.fdSoapInfoForms = fdSoapInfoForms;
	}

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
		fdModelName = null;
		fdModelId = null;
		fdKey = null;
		fdSubject = null;
		fdJobService = null;
		fdJobMethod = null;
		fdLink = null;
		fdParameter = null;
		fdCronExpression = "0 0 1 * * ?";
		fdEnabled = null;
		fdIsSysJob = null;
		fdRunType = null;
		fdRunTime = null;
		fdRequired = null;
		fdTriggered = null;
		fdQuartzEkp = null;
		fdUseExplain = null;
		fdParentId = null;
		docCategoryId = null;
		docCategoryName = null;
		fdTempCronExpression=null;
		fdSoapInfoForms = new AutoArrayList(TibSoapSyncTempFuncForm.class);
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSoapSyncJob.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
						TibSoapSyncCategory.class));
			toModelPropertyMap.put("fdSoapInfoForms", new FormConvertor_FormListToModelList(
					"fdSoapInfo", "fdQuartz"));
		}
		return toModelPropertyMap;
	}
}
