/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;

/**
 * @author 邱建华
 * @version 1.0 2013-1-7
 */
public interface ITibCommonInoutdataInterceptor {

	/**
	 * 保存之前事件（注意：如果设置baseModel为空，则不保存该对象）
	 * 
	 * @param baseDao
	 * @param baseModel
	 */
	public IBaseModel beforeSave(IBaseDao baseDao, IBaseModel baseModel);

	/**
	 * 更新之前事件（注意：如果设置baseModel为空，则删除该对象）
	 * 
	 * @param baseDao
	 * @param baseModel
	 */
	public IBaseModel beforeUpdate(IBaseDao baseDao, IBaseModel baseModel);

}
