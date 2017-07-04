package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces;

import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;

/**
 * tib 服务提供者接口
 * @author fat_tian
 *
 */
public interface ITibSysCoreProvider {

	
	/**
	 * 接受数据之后的前置动作
	 * @param data
	 * @param key
	 */
	public void interceptReceive(Object data,String key);
	
	/**
	 * 发生错误产生的错误动作
	 * @param data
	 * @param key
	 */
	public void interceptError(Object data,String key);
	
	/**
	 * 执行完成以后的后置动作
	 * @param data
	 * @param key
	 */
	public void interceptFinish(Object data,String key);
	
	/**
	 * 接受数据后转化数据动作
	 * @param store
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public Object transformReceiveData(String funcId, String funcMappData, 
			Object data)throws Exception;
	
	/**
	 * 返回执行完数据以后转化数据动作
	 * @param store
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public Object transformFinishData(TibSysCoreStore coreStore, Object data)throws Exception;
	
	/**
	 * 执行动作
	 * @param key
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public Object execute(String key, String funcId, String funcMappData, Object data) throws Exception;
	
	/**
	 * 获取XML模版
	 * @return
	 * @throws Exception
	 */
	public Object getTemplateXml(String funcId, boolean isDoc) throws Exception;
	
	
}
