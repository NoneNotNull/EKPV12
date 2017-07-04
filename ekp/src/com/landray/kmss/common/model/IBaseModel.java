package com.landray.kmss.common.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.config.dict.SysDictModel;

public interface IBaseModel {

	/**
	 * @return ID
	 */
	public abstract String getFdId();

	/**
	 * 设置ID
	 * 
	 * @param id
	 */
	public abstract void setFdId(String id);

	/**
	 * 重新计算字段值
	 */
	public abstract void recalculateFields();

	/**
	 * 数据字典对象，供SysDictLoader使用
	 * 
	 * @return
	 */
	public abstract SysDictModel getSysDictModel();

	/**
	 * 数据字典对象，供SysDictLoader使用
	 * 
	 * @param sysDictModel
	 */
	public abstract void setSysDictModel(SysDictModel sysDictModel);

	/**
	 * 获取Form模型的Class
	 * 
	 * @return form class
	 */
	public abstract Class getFormClass();

	/**
	 * @return 域模型到Form模型的特殊属性转换映射表
	 */
	public abstract ModelToFormPropertyMap getToFormPropertyMap();
}