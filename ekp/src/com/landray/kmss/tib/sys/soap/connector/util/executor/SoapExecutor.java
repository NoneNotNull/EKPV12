package com.landray.kmss.tib.sys.soap.connector.util.executor;

import org.w3c.dom.Document;

import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.ITibSysSoapExecuteHandler;

/**
 * 组装好执行webservice的工具
 * @author zhangtian
 * date :2013-1-15 上午12:36:12
 */
public class SoapExecutor extends AbstractSoapExecutor {

	public SoapExecutor(ITibSysSoapExecuteHandler tibSysSoapExecuteHandler,Document postData) {
		super(tibSysSoapExecuteHandler,postData);
	}

}
