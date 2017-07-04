package com.landray.kmss.common.service;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;

/**
 * 该接口用于通过AJAX的方式将后台的数据传递给JavaScript变量，具体的操作，请查阅《KMSS开发手册.doc》中的“设置beanName和beanURL参数”部分
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public interface IXMLDataBean {
	/**
	 * @param requestInfo
	 *            数据请求信息
	 * @return 数据列表
	 */
	public abstract List getDataList(RequestContext requestInfo) throws Exception;
}
