package com.landray.kmss.tib.common.mapping.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;

/**
 * 应用模块注册配置表业务对象接口
 * 
 * @author
 * @version 1.0 2011-10-14
 */
public interface ITibCommonMappingModuleService extends IBaseService {
	// 判断此文档对应的模块是否注册和启用
	boolean ifRegister(String templateName,String type) throws Exception;

	// 根据主文档model的name来判断对应的模块是否注册和启用
	boolean ifRegister(IBaseModel model,String type) throws Exception;

	// 根据主文档model的name得到fdModelTemFieldName
	public String getFdModelTemFieldName(String mainName) throws Exception;
	
	public void initRegisterModelHash() throws Exception ;
	
	public ConcurrentHashMap<String, Map<String, Object>> getRegisterModelHash();
	
	public boolean checkModuleContainType(String settingId,String type) throws Exception;
	
	public JSONArray treeView(HttpServletRequest request) throws Exception;
	
}
