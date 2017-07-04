package com.landray.kmss.sys.news.interfaces;

import java.util.List;

import com.landray.kmss.sys.right.interfaces.IExtendAuthTmpModel;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超
 */
public interface ISysNewsPublishCategoryModel extends IExtendAuthTmpModel {
	/**
	 * 获取发布设置域模型信息
	 * 
	 * @return
	 */
	public abstract List getSysNewsPublishCategorys();

	/**
	 * 设置发布设置域模型信息
	 * 
	 * @param sysNewsPublishCategorys
	 */
	public abstract void setSysNewsPublishCategorys(List sysNewsPublishCategorys);
}
