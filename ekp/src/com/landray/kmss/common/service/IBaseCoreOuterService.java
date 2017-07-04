package com.landray.kmss.common.service;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;

/**
 * 机制核心服务接口
 * 
 * @author 叶中奇
 */
public interface IBaseCoreOuterService {
	/**
	 * 被代理的源类
	 */
	public abstract Class<?> getSourceClass();

	/**
	 * 当主域模型保存时触发
	 * 
	 * @param model
	 * @throws Exception
	 */
	public abstract void add(IBaseModel model) throws Exception;

	/**
	 * 克隆Model的值到新的Form中
	 * 
	 * @param form
	 * @param settingModel
	 * @throws Exception
	 */
	public abstract void cloneModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception;

	/**
	 * 当主Form模型到主域模型转换时触发
	 * 
	 * @param form
	 * @param model
	 * @param requestContext
	 * @throws Exception
	 */
	public abstract void convertFormToModel(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception;

	/**
	 * 当主域模型到主Form模型转换时触发
	 * 
	 * @param form
	 * @param model
	 * @param requestContext
	 * @throws Exception
	 */
	public abstract void convertModelToForm(IExtendForm form, IBaseModel model,
			RequestContext requestContext) throws Exception;

	/**
	 * 当删除主域模型时触发
	 * 
	 * @param model
	 * @throws Exception
	 */
	public abstract void delete(IBaseModel model) throws Exception;

	/**
	 * 从模板中获取配置信息并附加到主文档的Form中
	 * 
	 * @param form
	 * @param settingModel
	 * @throws Exception
	 */
	public abstract void initFormSetting(IExtendForm mainForm, String mainKey,
			IBaseModel settingModel, String settingKey,
			RequestContext requestContext) throws Exception;

	/**
	 * 从模板中获取配置信息并附加到主文档的Model中
	 * 
	 * @param form
	 * @param settingModel
	 * @throws Exception
	 */
	public abstract void initModelSetting(IBaseModel mainModel, String mainKey,
			IBaseModel settingModel, String settingKey) throws Exception;

	/**
	 * 当主域模型保存时触发
	 * 
	 * @param model
	 * @throws Exception
	 */
	public abstract void update(IBaseModel model) throws Exception;

	/**
	 * 导出相关机制数据
	 * 
	 * @param id
	 * @param modelName
	 * @throws Exception
	 */
	public abstract List<?> exportData(String id, String modelName)
			throws Exception;
}