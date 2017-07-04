package com.landray.kmss.tib.common.init.service;

import java.util.List;

import com.landray.kmss.common.service.IBaseService;

/**
 * 主文档业务对象接口
 * 
 * @author 
 * @version 1.0 2013-06-17
 */
public interface ITibCommonInitService extends IBaseService {
	public List<String> getJspPathList() throws Exception;
	
}
