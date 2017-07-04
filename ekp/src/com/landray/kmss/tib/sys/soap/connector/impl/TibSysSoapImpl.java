/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.impl;

import java.util.Date;
import java.util.Map;

import javax.wsdl.BindingOperation;
import javax.wsdl.Definition;

import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.eviware.soapui.impl.wsdl.WsdlOperation;
import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.impl.wsdl.WsdlSubmit;
import com.eviware.soapui.impl.wsdl.WsdlSubmitContext;
import com.eviware.soapui.impl.wsdl.support.soap.SoapMessageBuilder;
import com.eviware.soapui.model.iface.Operation;
import com.eviware.soapui.model.iface.Response;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.interfaces.ITibCommonLogInterface;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.executor.SoapExecutor;
import com.landray.kmss.tib.sys.soap.connector.util.executor.SoapExecutorLogProxy;
import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.TibSysSoapModuleExecuteHandler;
import com.landray.kmss.tib.sys.soap.connector.util.executor.intereptor.TibSysSoapContextInterceptor;
import com.landray.kmss.tib.sys.soap.connector.util.executor.intereptor.TibSysSoapHeadInterceptor;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.tib.sys.soap.connector.util.header.TibSysSoapRtn;
import com.landray.kmss.tib.sys.soap.connector.util.header.licence.LicenceHeaderPlugin;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author 邱建华
 * @version 1.0 2012-11-2
 */
public class TibSysSoapImpl implements ITibSysSoap {

	/**
	 * 通过WSDL和当前WebService获取模版参数(初始化状态)的XML
	 * 
	 * @param wsdlUrl
	 *            WSDL地址
	 * @param operationName
	 *            当前操作的WebService
	 * @return 返回Soap传递的参数
	 * @throws Exception
	 */
	private String toXmlTemplate(TibSysSoapSetting soapuiSett,
			String operationName, String soapVersion, String choose)
			throws Exception {
		WsdlOperation operation = TibSysSoapProjectFactory.getWsdlOperation(
				soapuiSett, operationName, soapVersion);
		WsdlInterface iface = TibSysSoapProjectFactory
				.getWsdlInterfaceInstance(soapuiSett, soapVersion);
		// 创建SOAP消息
		SoapMessageBuilder builder = iface.getMessageBuilder();
		Definition definition = iface.getWsdlContext().getDefinition();
		BindingOperation bo = operation.findBindingOperation(definition);
		String soapXml = "";
		// 是否需要拿出输入+输出参数或者单个的参数模版
		if (choose.equals("Input")) {
			soapXml = builder.buildSoapMessageFromInput(bo, true, true);
		} else if (choose.equals("Output")) {
			soapXml = builder.buildSoapMessageFromOutput(bo, true, true);
		} else {
			String tempInputXml = builder.buildSoapMessageFromInput(bo, true,
					true);
			String tempOutputXml = builder.buildSoapMessageFromOutput(bo, true,
					true);
			String tempFalutXml = builder.buildEmptyFault();
			soapXml = addInputDesc(tempInputXml) + addOutputDesc(tempOutputXml)
					+ addFaultDesc(tempFalutXml);// ParseSoapXmlUtil.getFaultTemplate();
		}
		return soapXml;
	}

	/**
	 * 通过WSDL等相关信息，获取请求参数InputXml
	 */
	public String toInputXml(TibSysSoapSetting soapuiSett,
			String operationName, String soapVersion) throws Exception {
		return addInputDesc(toXmlTemplate(soapuiSett, operationName,
				soapVersion, "Input"));
	}

	/**
	 * 主要通过请求参数获取响应参数OutputXml
	 */
	public String inputToOutputXml(SoapInfo soapInfo) throws Exception {
		// 获取响应的XML
		String soapResponse = getResponseByAuth(soapInfo);
		// 判断是否错误节点
		boolean isFault = ParseSoapXmlUtil.isFault(soapResponse);
		if (isFault) {
			// 错误模板包含注析
			String faultString = HeaderOperation.allToPartXmlByPath(
					soapInfo.getRequestXml(), "//Fault");
			soapResponse = ParseSoapXmlUtil.addComment(faultString,
					addFaultDesc(soapResponse), "Fault", true);
		}
		// 如果不是错误返回值处理
		else {
			String outString = HeaderOperation.allToPartXmlByPath(
					soapInfo.getRequestXml(), "//Output");
			// 修正返回数据没有注析 modify by zhang
			soapResponse = ParseSoapXmlUtil.addComment(outString,
					addOutputDesc(soapResponse), "Output", true);
		}
		return soapResponse;
	}

	private String getResponseByAuth(SoapInfo soapInfo) throws Exception {
		// 获取主Model，存放SOAP信息的VO
		TibSysSoapMain main = soapInfo.getTibSysSoapMain();
		String operationName = main.getWsBindFunc();
		String soapVersion = main.getWsSoapVersion();
		// 把不属于请求参数的XML去除，提取请求的inputXML
		String inputParamXml = HeaderOperation.allToPartXml(
				soapInfo.getRequestXml(), "//Input");
		TibSysSoapSetting soapuiSet = main.getTibSysSoapSetting();
		// 创建请求
		WsdlRequest request = TibSysSoapProjectFactory.getRequest(soapuiSet,
				operationName, soapVersion);
		SubmitContext context = new WsdlSubmitContext(request);
		// 是否设置加密方式
		if (StringUtil.isNotNull(soapuiSet.getPasswordType()))
			request.setWssPasswordType(soapuiSet.getPasswordType());
		// 加入受HTTP保护的验证信息
		if (soapuiSet.getFdProtectWsdl()) {
			request.setUsername(soapuiSet.getFdloadUser());
			request.setPassword(soapuiSet.getFdloadPwd());
		}
		// 判断何种登录方式，根据登录方式赋值给予不同Soap消息头信息
		if (soapuiSet.getFdCheck()) {
			// 设置用户名密码
			if (!soapuiSet.getFdProtectWsdl()) {
				request.setUsername(soapuiSet.getFdUserName());
				request.setPassword(soapuiSet.getFdPassword());
			}
			String fdAuthMethod = soapuiSet.getFdAuthMethod();
			// 获取扩展点中存放的Map信息
			Map<String, String> map = LicenceHeaderPlugin
					.getConfigByKey(fdAuthMethod);
			String isExtSelf = map.get(LicenceHeaderPlugin.isExtSelf);
			String springName = map.get(LicenceHeaderPlugin.handlerSpringName);
			String className = map.get(LicenceHeaderPlugin.handlerClassName);
			// 判断是否需要自己扩展头部信息
			if ("true".equals(isExtSelf)) {
				String soapHeaderCustom = soapuiSet.getSoapHeaderCustom();
				// 合并请求XML，主要是为了建造SoapHeader（此种是从"前"台自定义头部信息）
				if (StringUtil.isNotNull(soapHeaderCustom)) {
					inputParamXml = HeaderOperation.mergeInputXml(
							soapHeaderCustom, inputParamXml);
				} else {
					// 获取拥有头部消息的请求参数（此种是从"后"台自定义头部信息）
					inputParamXml = HeaderOperation.getInputAndHeaderXml(
							inputParamXml, className, springName, soapuiSet);
				}
			} else if ("false".equals(isExtSelf)) {
				HeaderOperation.setAuthContext(context, request, soapuiSet,
						springName, className);
			} else {
				String soapHeaderCustom = soapuiSet.getSoapHeaderCustom();
				// 合并请求XML，主要是为了建造SoapHeader（此种是从"前"台自定义头部信息）
				if (StringUtil.isNotNull(soapHeaderCustom)) {
					inputParamXml = HeaderOperation.mergeInputXml(
							soapHeaderCustom, inputParamXml);
				} else {
					// 获取拥有头部消息的请求参数（此种是从"后"台自定义头部信息）
					inputParamXml = HeaderOperation.getInputAndHeaderXml(
							inputParamXml, className, springName, soapuiSet);
				}
				HeaderOperation.setAuthContext(context, request, soapuiSet,
						springName, className);
			}
		}
		// 设置请求的输入参数
		request.setRequestContent(inputParamXml);
		WsdlSubmit<WsdlRequest> submit = (WsdlSubmit<WsdlRequest>) request
				.submit(context, false);
		Response response = submit.getResponse();
		// 获取了返回的输出参数的XML
		String soapResponse = response.getContentAsString();
		return soapResponse;
	}

	/**
	 * 用于扩展函数或公式定义器
	 */
	private String inputToOutputOrFault(SoapInfo soapInfo) throws Exception {
		// 获取响应的XML
		String soapResponse = getResponseByAuth(soapInfo);
		// 判断是否错误节点
		boolean isFault = ParseSoapXmlUtil.isFault(soapResponse);
		if (isFault) {
			return addFaultDesc(soapResponse);
		} else {
			return addOutputDesc(soapResponse);
		}
	}

	/**
	 * 用于扩展函数或公式定义器
	 */
	public String funcNameAndContentToOutput(String Func_Name,
			String Request_Content) throws Exception {
		ITibSysSoapMainService TibSysSoapMainService = (ITibSysSoapMainService) SpringBeanUtil
				.getBean("tibSysSoapMainService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysSoapMain.docSubject=:docSubject");
		hqlInfo.setParameter("docSubject", Func_Name);
		TibSysSoapMain tibSysSoapMain = (TibSysSoapMain) TibSysSoapMainService
				.findList(hqlInfo).get(0);
		// 获取input模版
		String inputXml = toInputXml(tibSysSoapMain.getTibSysSoapSetting(),
				tibSysSoapMain.getWsBindFunc(),
				tibSysSoapMain.getWsSoapVersion());
		// 为body赋值
		String requestXml = ParseSoapXmlUtil.setRequestValue(inputXml,
				Request_Content);
		SoapInfo soapInfo = new SoapInfo();
		soapInfo.setTibSysSoapMain(tibSysSoapMain);
		soapInfo.setRequestXml(requestXml);
		String resultXml = inputToOutputOrFault(soapInfo);
		return resultXml;
	}
	
	
	public Document inputToOutputDocument(SoapInfo soapInfo)
			throws Exception {
		
		ITibSysSoapRtn rtn =inputToOutputRtn(soapInfo);
		return rtn.getRtnDocument();
		
	}

	public ITibSysSoapRtn inputToOutputRtn(SoapInfo soapInfo)
			throws Exception {

		TibSysSoapModuleExecuteHandler handler = new TibSysSoapModuleExecuteHandler(
				soapInfo);
		// 获取主Model，存放SOAP信息的VO
		TibSysSoapMain main = soapInfo.getTibSysSoapMain();
		TibSysSoapSetting soapuiSet = main.getTibSysSoapSetting();
		if (soapuiSet.getFdCheck()) {
			String fdAuthMethod = soapuiSet.getFdAuthMethod();
			if(StringUtil.isNotNull(fdAuthMethod)){
				// 获取扩展点中存放的Map信息
				Map<String, String> map = LicenceHeaderPlugin
						.getConfigByKey(fdAuthMethod);
				String isExtSelf = map.get(LicenceHeaderPlugin.isExtSelf);
				String springName = map.get(LicenceHeaderPlugin.handlerSpringName);
				String className = map.get(LicenceHeaderPlugin.handlerClassName);
				// 判断是否需要自己扩展头部信息，此处isExSelf看plugin.xml扩展点处描述
				if ("true".equals(isExtSelf)) {
					TibSysSoapHeadInterceptor tibSysSoapHeadInterceptor = new TibSysSoapHeadInterceptor(
							soapuiSet, springName, className, 0);
					handler.getBeforeInterceptors().add(tibSysSoapHeadInterceptor);
		
				} else if ("false".equals(isExtSelf)) {
					TibSysSoapContextInterceptor tibSysSoapContextInterceptor = new TibSysSoapContextInterceptor(
							soapuiSet, springName, className, 1);
					handler.getBeforeInterceptors().add(tibSysSoapContextInterceptor);
				} else {
					TibSysSoapHeadInterceptor tibSysSoapHeadInterceptor = new TibSysSoapHeadInterceptor(
							soapuiSet, springName, className, 0);
					handler.getBeforeInterceptors().add(tibSysSoapHeadInterceptor);
					TibSysSoapContextInterceptor tibSysSoapContextInterceptor = new TibSysSoapContextInterceptor(
							soapuiSet, springName, className, 1);
					handler.getBeforeInterceptors().add(tibSysSoapContextInterceptor);
		
				}
			}
		}
		SoapExecutor executor = new SoapExecutor(handler, handler.getPostData());
		SoapExecutorLogProxy proxy=new SoapExecutorLogProxy(executor, soapInfo);
		ITibSysSoapRtn tibSysSoapRtn = proxy.executeSoapui();
		return tibSysSoapRtn;
	}

	/**
	 * 通过请求参数获取响应参数，并把请求参数一起返回InputXml+OutputXml
	 */
	public String inputToAllXml(SoapInfo soapInfo) throws Exception {

		Date curDate = new Date();

		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");

		String resultInfo = "";
		try {
			// 通过输入参数的XML获取输出参数
			String OutputXml = inputToOutputXml(soapInfo);
			// 处理其它不属于请求参数的XML
			String inputParamXml = HeaderOperation.allToPartXml(
					soapInfo.getRequestXml(), "//Input");
			resultInfo = addInputDesc(inputParamXml) + OutputXml;

			if (OutputXml.indexOf("<Fault>") > -1) {
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SOAP, null, soapInfo
								.getTibSysSoapMain().getTibSysSoapSetting()
								.getFdWsdlUrl(), soapInfo.getTibSysSoapMain()
								.getDocSubject(), curDate, new Date(), soapInfo
								.getRequestXml(), resultInfo,
						"执行webservice异常:TibSysSoapImpl.inputToAllXml()",
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
			} else {
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SOAP, null, soapInfo
								.getTibSysSoapMain().getTibSysSoapSetting()
								.getFdWsdlUrl(), soapInfo.getTibSysSoapMain()
								.getDocSubject(), curDate, new Date(), soapInfo
								.getRequestXml(), resultInfo,
						"成功日志:TibSysSoapImpl.inputToAllXml()",
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
			}
		} catch (Exception e) {
			tibCommonLogInterface.saveTibCommonLogMain(Constant.FD_TYPE_SOAP,
					null, soapInfo.getTibSysSoapMain().getTibSysSoapSetting()
							.getFdWsdlUrl(), soapInfo.getTibSysSoapMain()
							.getDocSubject(), curDate, new Date(), soapInfo
							.getRequestXml(), resultInfo,
					"程序执行失败:TibSysSoapImpl.inputToAllXml():" + e.getMessage(),
					TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
			throw e;
		}
		return resultInfo;
	}

	/**
	 * 通过WSDL等信息，获取请求参数和响应参数的模版！
	 */
	public String toAllXmlTemplate(TibSysSoapSetting soapuiSett,
			String operationName, String soapVersion) throws Exception {
		// 通过WSDL获取输入和输出参数的XML模版
		return toXmlTemplate(soapuiSett, operationName, soapVersion, "All");
	}

	/**
	 * 获取全部的Operation
	 */
	public Map<String, Operation> getAllOperation(TibSysSoapSetting soapuiSett,
			String soapVersion) throws Exception {
		WsdlInterface iface = TibSysSoapProjectFactory
				.getWsdlInterfaceInstance(soapuiSett, soapVersion);
		Map<String, Operation> opernatesMap = iface.getOperations();
		return opernatesMap;
	}

	/**
	 * 获取Input默认的函数模版 再从模版中获取header头部模版
	 * 
	 * @param wsdlUrl
	 * @param soapVersion
	 * @param proUsername
	 * @param proPassword
	 * @return
	 * @throws Exception
	 */
	public String toDefaultInputXml(TibSysSoapSetting soapuiSett,
			String soapVersion) throws Exception {
		WsdlInterface iface = TibSysSoapProjectFactory
				.getWsdlInterfaceInstance(soapuiSett, soapVersion);
		WsdlOperation wsdlOperation = (WsdlOperation) iface.getOperationList()
				.get(0);
		// 创建SOAP消息
		SoapMessageBuilder builder = iface.getMessageBuilder();
		Definition definition = iface.getWsdlContext().getDefinition();
		BindingOperation bo = wsdlOperation.findBindingOperation(definition);
		String inputXml = builder.buildSoapMessageFromInput(bo, true, true);
		// 从input模版中获取头部header模版
		String headTemplate = HeaderOperation.loadHeaderTemplate(inputXml);
		return headTemplate;
	}

	private String addInputDesc(String inputXml) {
		return "<Input>" + inputXml + "</Input>";
	}

	private String addOutputDesc(String outputXml) {
		return "<Output>" + outputXml + "</Output>";
	}

	private String addFaultDesc(String faultXml) {
		return "<Fault>" + faultXml + "</Fault>";
	}

	public TibSysSoapRtn inputToOutputData(Document doc,
			TibSysSoapMain TibSysSoapMain) throws Exception {
		return null;
	}
}
