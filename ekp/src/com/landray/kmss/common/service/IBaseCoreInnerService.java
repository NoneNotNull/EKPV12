package com.landray.kmss.common.service;

import java.util.List;

import com.landray.kmss.common.model.BaseCoreInnerModel;
import com.landray.kmss.common.model.IBaseModel;

/**
 * 机制类Service接口的基类
 * 
 * @author 叶中奇
 * 
 */
public interface IBaseCoreInnerService extends IBaseService {
	/**
	 * 根据主域模型以及key值查找对应机制的域模型
	 * 
	 * @param mainModel
	 *            主域模型
	 * @param key
	 *            key值，若为null则不过滤该属性
	 * @return
	 * @throws Exception
	 */
	public abstract List getCoreModels(IBaseModel mainModel, String key)
			throws Exception;

	/**
	 * 根据主域模型删除相关机制的域模型
	 * 
	 * @param mainModel
	 *            主域模型
	 * @throws Exception
	 */
	public abstract void deleteCoreModels(IBaseModel mainModel)
			throws Exception;

	public abstract IBaseModel getMainModel(BaseCoreInnerModel coreModel)
			throws Exception;

	public IBaseModel getMainModel(BaseCoreInnerModel coreModel, boolean noLazy)
			throws Exception;

	public abstract void saveMainModel(IBaseModel mainModel) throws Exception;
}