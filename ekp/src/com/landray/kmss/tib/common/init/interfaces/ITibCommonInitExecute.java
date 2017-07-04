package com.landray.kmss.tib.common.init.interfaces;

import javax.servlet.http.HttpServletRequest;

public interface ITibCommonInitExecute {
	
	/**
	 * 测试是否链接成功
	 * @param request		装满页面数据的request请求
	 * @return
	 * @throws Exception
	 */
	public String testConn(HttpServletRequest request);
	
	public void importInitJar(HttpServletRequest request) throws Exception;
	
}
