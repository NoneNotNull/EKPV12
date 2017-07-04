package com.landray.kmss.tib.sys.soap.connector.util.executor;

import org.w3c.dom.Document;

import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.ITibSysSoapExecuteHandler;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;

/**
 * 组装好执行webservice的工具
 * @author zhangtian
 * date :2013-1-15 上午12:36:12
 */
public class SoapModuleExecutor extends AbstractSoapExecutor {

	private SoapInfo soapInfo;
	
	public SoapModuleExecutor(ITibSysSoapExecuteHandler TibSysSoapExecuteHandler,Document postData) {
		super(TibSysSoapExecuteHandler,postData);
	}

	public SoapInfo getSoapInfo() {
		return soapInfo;
	}

	public void setSoapInfo(SoapInfo soapInfo) {
		this.soapInfo = soapInfo;
	}
	
	

}
