package com.landray.kmss.tib.common.mapping.plugins;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;

/**
 * 代码级别拆解模块接口
 * @author zhangtian
 * date :2012-10-9 下午06:20:19
 */
public interface IBaseTibCommonMappingIntegration {

	/**
	 * 根据模板Id 获取对应ekp集成配置的 子模板名字
	 * @param templateId
	 * @return
	 */
	public HQLInfo findSettingNameHQLByTempId(String templateId,String fdIntegrationType);
	
	/**
	 * 获取到进入目标主文档的时候需要引入的jsp文件以及脚本资源
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public List<TibCommonMappingFunc>  getFormEventIncludeList(HttpServletRequest request) throws Exception;

	
	/**
	 * 
	 * 用来拆解对应目标id
	 * 当在流程配置的时候选择机器人节点的时候
	 * 需要显示对应配置的名称以及ID
	 * @param templateId
	 * @param invokeType
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> getSettingNameInfo(String templateId,String invokeType) throws Exception;


	/**
	 * 表单add事件触发的实现
	 * @return
	 * @throws Exception
	 */
	public IBaseModel addMethodInvoke(IBaseModel baseModel) throws Exception;
	
	/**
	 * 表单delete事件触发的实现
	 * @return
	 * @throws Exception
	 */
	public void deleteMethodInvoke(IBaseModel baseModel) throws Exception;
	
	
	public IBaseModel updateMethodInvoke(IBaseModel baseModel) throws Exception;
	
}
