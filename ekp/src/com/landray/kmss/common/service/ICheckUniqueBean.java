package com.landray.kmss.common.service;

import com.landray.kmss.common.actions.RequestContext;

public interface ICheckUniqueBean {
	/**
	 * 在页面上检验名称是否重复
	 * 
	 * @param requestInfo
	 *            数据请求信息
	 * @return "0" 表示重复了
	 */
	public abstract String checkUnique(RequestContext requestInfo)
			throws Exception;
}
