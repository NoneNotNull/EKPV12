package com.landray.kmss.tib.sys.soap.connector.util.executor;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.impl.wsdl.WsdlSubmit;
import com.eviware.soapui.model.iface.Response;
import com.eviware.soapui.model.iface.SubmitContext;
import com.eviware.soapui.model.iface.Request.SubmitException;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.ITibSysSoapExecuteHandler;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.util.StringUtil;

/**
 * soapui 执行webservice执行器
 * 
 * @author zhangtian
 * date :2013-1-14 上午11:30:44
 */
public abstract class AbstractSoapExecutor {
	
	private Log logger = LogFactory.getLog(this.getClass());
	
	//控制执行过程中的前置，后置，request 设置控制动作类
	private ITibSysSoapExecuteHandler tibSysSoapExecuteHandler;
	
	private Document postData; 
	
	public AbstractSoapExecutor(ITibSysSoapExecuteHandler TibSysSoapExecuteHandler,Document postData){
		this.tibSysSoapExecuteHandler=TibSysSoapExecuteHandler;
		this.postData=postData;
	}
	
	private Response executeSoapuiCore(SubmitContext context, WsdlRequest request) throws SubmitException{
		
		WsdlSubmit<WsdlRequest> submit = (WsdlSubmit<WsdlRequest>) request
				.submit(context, false);
		Response response = submit.getResponse();
		
		return response;
	}
	
	/**
	 * 执行webservice 
	 * @return
	 * @throws Exception
	 */
	public ITibSysSoapRtn executeSoapui() throws Exception{
		
		//执行webservice之前初始化WsdlRequest
		WsdlRequest wsdlRequest= tibSysSoapExecuteHandler.getInitWsdlRequest();
		
		//执行webservice之前初始化submitContext
		SubmitContext submitContext =tibSysSoapExecuteHandler.getInitSubmitContext();
		
		
		//前置操作
		tibSysSoapExecuteHandler.beforeExecute(submitContext, wsdlRequest,postData);
		
		wsdlRequest.setRequestContent(DOMHelper.nodeToString(postData));
		
		//执行webservice
		Response response=executeSoapuiCore(submitContext, wsdlRequest);
		
		//原始返回值
		String content=response.getContentAsString();
		Document document=null;
		//转化为dom
		if(StringUtil.isNotNull(content)){
			document=DOMHelper.parseXmlString(content);
		}
		//处理后续返回值
		Document  doc =tibSysSoapExecuteHandler.afterExecute(submitContext, wsdlRequest, response,document);
		
		//返回值转换
		ITibSysSoapRtn  rtnObject=tibSysSoapExecuteHandler.parseResponse(response,doc);
		
		return rtnObject;
		
	}

	public Document getPostData() {
		return postData;
	}

	public void setPostData(Document postData) {
		this.postData = postData;
	}

	public ITibSysSoapExecuteHandler getTibSysSoapExecuteHandler() {
		return tibSysSoapExecuteHandler;
	}

	public void setTibSysSoapExecuteHandler(
			ITibSysSoapExecuteHandler tibSysSoapExecuteHandler) {
		this.tibSysSoapExecuteHandler = tibSysSoapExecuteHandler;
	}

	
	
	
	
	
	
	

}
