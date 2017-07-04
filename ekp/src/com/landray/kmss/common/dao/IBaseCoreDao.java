package com.landray.kmss.common.dao;

import java.util.List;

import com.landray.kmss.common.model.IBaseModel;

/**
 * 机制类代码通用的Dao接口类。<br>
 * 作用范围：机制类的Dao代码，可直接作为实现接口或作为接口的基类继承。
 * 
 * @author 叶中奇
 * @version 1.0 2006-6-16
 */
public interface IBaseCoreDao extends IBaseDao {
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
}
