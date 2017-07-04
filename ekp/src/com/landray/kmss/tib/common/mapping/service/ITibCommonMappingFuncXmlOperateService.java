package com.landray.kmss.tib.common.mapping.service;

import java.util.List;

import org.dom4j.Document;
import org.dom4j.Element;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;

public interface ITibCommonMappingFuncXmlOperateService {
	
	/**
	 * 判断此文档对应的模块是否注册和启用
	 * @param templateName 对应注册的modelName
	 * @return 是否注册 ,true则注册 反之
	 * @throws Exception
	 */
	boolean ifRegister(String templateName,String fdType) throws Exception;

	/**
	 * 根据主文档model的name来判断对应的模块是否注册和启用
	 * @param model 判断主model
	 * @return 是否注册 ,true则注册 反之
	 * @throws Exception
	 */
	boolean ifRegister(IBaseModel model,String fdType) throws Exception;

	/**
	 * 按顺序得到指定类型函数
	 * @param fdTemplateId 模板ID
	 * @param fdInvokeType 类型 表单事件,机器人节点 @see com.landray.kmss.tib.common.mapping.constant.Constant
	 * @param fdIntegrationType
	 * @return
	 * @throws Exception
	 */
	List<TibCommonMappingFunc> getFuncList(String fdTemplateId, int fdInvokeType,String fdIntegrationType  )
			throws Exception;

	// 设置函数xml传入参数field内容或者structure下的field
	void setFuncImportXmlByFormula(Document document, FormulaParser parser)
			throws Exception;

	// 设置传入参数table类型参数field内容
	void setFuncImportTableByFormula(Document document, FormulaParser parser)
			throws Exception;

	// 设置函数xml传出参数field内容或者structure下的field
	void setFuncExportXml(Document document, IBaseModel mainModel)
			throws Exception;

	// 设置传出参数中table类型的参数,只支持a或a.b格式
	void setFuncExportTable(Document document, IBaseModel baseModel)
			throws Exception;
	
	
	/**
	 * 设置输入参数
	 * webservice模块使用,待修正
	 * @param nodeList
	 * @param parser
	 * @throws Exception
	 */
	void setInputParamXmlByFormula(List<Element> nodeList, FormulaParser parser)
			throws Exception;

	/**
	 * 设置输出参数
	 * webservice模块使用,待修正
	 * @param nodeList
	 * @param mainModel
	 * @throws Exception
	 */
	void setOutputParamXml(List<Element> nodeList, IBaseModel mainModel)
			throws Exception;
	/**
	 * 处理业务失败的方法
	 * @param document
	 * @param tibCommonMappingFunc
	 * @param mainModel
	 * @throws Exception
	 */
	public void businessException(Document document,
			TibCommonMappingFunc tibCommonMappingFunc, IBaseModel mainModel)
			throws Exception;
	
	/**
	 * 处理程序异常的方法
	 * @param e
	 * @param exProgram
	 * @param mainModel
	 * @throws Exception
	 */
	public void programException(Exception e, TibCommonMappingFuncExt exProgram,
			IBaseModel mainModel) throws Exception;
	
	
	public void setInputInfo(NodeList nodeList,FormulaParser parser);
	
	public boolean setOutputInfo(NodeList nodeList, FormulaParser parser,
			IBaseModel mainModel, boolean flag) throws Exception;
	
}
