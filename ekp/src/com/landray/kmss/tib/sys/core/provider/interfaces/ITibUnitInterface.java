package com.landray.kmss.tib.sys.core.provider.interfaces;

import java.util.List;

import org.w3c.dom.Document;

import com.landray.kmss.tib.sys.core.provider.vo.IfaceImplInfo;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceInfo;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceSimpleInfo;

public interface ITibUnitInterface {

	/**
	 * 返回能够调用的若干个接口清单
	 * 
	 * @param count
	 *            最多返回多少函数，0代表返回所有
	 * @return 返回函数清单
	 */
	public List<IfaceSimpleInfo> getIfaceList(Integer count)throws Exception;

	/**
	 * 根据接口key返回接口信息
	 * @param key
	 * @return
	 */
	public IfaceInfo getIface(String key)throws Exception;
	
	/**
	 * 根据接口Key，返回实现该接口的Provider信息
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public List<IfaceImplInfo> getImplList(String key)throws Exception;

	/**
	 * 根据传入参数，返回执行后的结果（XML格式）
	 * 
	 * @Description 用于单个接口实现
	 * @param inXML
	 *            传入参数的XML格式
	 * @return 执行后的结果
	 * @throws Exception
	 */
	public String executeToStr(String inXML) throws Exception;

	/**
	 * 根据传入参数，返回执行后的结果（XML格式）
	 * 
	 * @Description 用于单个接口实现
	 * @param inDoc
	 *            传入参数的Document格式
	 * @return 执行后的结果
	 * @throws Exception
	 */
	public String executeToStr(Document inDoc) throws Exception;

	/**
	 * 根据传入参数，返回执行后的结果（Document格式）
	 * 
	 * @Description 用于单个接口实现
	 * @param inXML
	 *            传入参数的XML格式
	 * @return 执行后的结果
	 * @throws Exception
	 */
	public Document executeToDoc(String inXML) throws Exception;

	/**
	 * 根据传入参数，返回执行后的结果（Document格式）
	 * 
	 * @Description 用于单个接口实现
	 * @param inDoc
	 *            传入参数的Document格式
	 * @return 执行后的结果
	 * @throws Exception
	 */
	public Document executeToDoc(Document inDoc) throws Exception;

	/**
	 * 根据传入参数，返回执行后的结果
	 * 
	 * @Description 仅用于数据传输组件，根据扩展点开发的自定义组件也可以使用
	 * @param data 	传入的对象，（只支持Document、String类型，其它类型请调用重载方法）
	 * @return 		执行后的结果，支持多实现，多实现则返回List<Object>
	 * @throws Exception
	 * 
	 */
	public Object executeToData(Object data) throws Exception;
	
	/**
	 * 根据传入参数，返回执行后的结果
	 * 
	 * @Description 仅用于数据传输组件，根据扩展点开发的自定义组件也可以使用
	 * @param key   接口的唯一key
	 * @param data  传入的对象
	 * @return 对于数据传输组件来说，如果没有加扩展点，则原样返回data
	 * @throws Exception
	 * 
	 */
	public Object executeToData(String key, Object data) throws Exception;

}
