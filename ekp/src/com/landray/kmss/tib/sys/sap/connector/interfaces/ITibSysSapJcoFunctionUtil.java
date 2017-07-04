package com.landray.kmss.tib.sys.sap.connector.interfaces;

import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;

public interface ITibSysSapJcoFunctionUtil {
	/**
	 * 根据传进的函数名称和所属连接池得到rfc函数
	 * 
	 * @note 不记录日志，未执行JCOFunction
	 * @param name
	 *            函数名称
	 * @param poolId
	 *            连接池ID
	 * @return JCoFunction
	 * @throws Exception
	 */
	public JCoFunction getFunctionByNameAndPool(String name, String poolId)
			throws Exception;

	/**
	 * webservice 接口 传入RFCName(在ekp 集成平台配置的webservice 名字) 传入json格式
	 * 
	 * @note 记录日志，执行了JCOFunction
	 * @param RFCName
	 * @param json
	 * @return TibSysSapReturnVo 对象
	 * @throws Exception
	 */
	public TibSysSapReturnVo getJson4WebService(String RFCName, Object json)
			throws Exception;

	/**
	 * 根据functionId 获取JCOfunction 对象(定时任务获取)
	 * 
	 * @note 不记录日志
	 * @param id
	 *            functionId
	 * @return JCOfunction
	 * @throws Exception
	 */
	public Object getFunctionById(String id) throws Exception;

	/**
	 * 仅供给定时任务 使用
	 * 
	 * @note 不记录日志
	 * @param jcoFunction
	 *            已经填充好参数的jcoFunction 对象
	 * @param funcId
	 * @return JCoFunction对象
	 * @throws Exception
	 */
	public JCoFunction getFunctionFromFunc(JCoFunction jcoFunction,
			String funcId) throws Exception;

	/**
	 * 根据传进的函数Id得到函数模板的xml
	 * 
	 * @note 不记录日志，未执行JCOFunction
	 */
	public Object getFunctionToXmlById(String Id) throws Exception;

	/**
	 * 根据传进的配置函数名称得到函数模板的xml
	 * 
	 * @note 不记录日志，未执行JCOFunction
	 */
	public Object getFunctionToXmlByRfc(String name) throws Exception;

	/**
	 * 根据传进的BAPI名称和所属连接池得到函数模板的xml
	 * 
	 * @note 不记录日志，未执行JCOFunction
	 */
	public Object getFunctionToXmlByName(String name, String poolId)
			throws Exception;

	/**
	 * 根据传进的参数或得传出参数的xml
	 * 
	 */
	public TibSysSapReturnVo getXMltoFunction(Object xml) throws Exception;

	/**
	 * 根据传进的参数和数目获得传出参数的xml(table返回条数为i)
	 * 
	 */
	public TibSysSapReturnVo getXMltoFunction(Object xml, int i) throws Exception;

	/**
	 * 根据传进的参数json得到传出参数的json
	 * 
	 */
	public TibSysSapReturnVo getJsonToJson(String rfc, String json) throws Exception;
	
	/**
	 * 根据分类ID跟数据执行SAP
	 * @param rfcId 函数ID
	 * @param xml
	 * @return
	 * @throws Exception
	 */
	public TibSysSapReturnVo getXMLtoFunction(String rfcId, Object xml) throws Exception;
	

	/**
	 * 根据连接池名称获得函数管理对象JCoDestination
	 * 
	 * @note 不记录日志，未执行JCOFunction
	 */
	public JCoDestination getJCoDestinationByName(String poolName)
			throws Exception;

}
