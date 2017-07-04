package com.landray.kmss.tib.common.log.service;

import net.sf.json.JSONArray;

import com.landray.kmss.common.service.IBaseService;

/**
 * TIB_COMMON日志管理业务对象接口
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public interface ITibCommonLogMainService extends IBaseService {
	public void backup()throws Exception;
	
	public JSONArray treeView(String type, String path) throws Exception;
}
