package com.landray.kmss.tib.sys.soap.connector.util.executor.intereptor;

import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;

public class TibSysSoapContextInterceptor extends AbstractInterceptor {
	private TibSysSoapSetting soapuiSet;
	private String springName;
	private String className;
	
	public TibSysSoapContextInterceptor(TibSysSoapSetting soapuiSet,String springName,String className, int order) {
		super(order);
		// TODO 自动生成的构造函数存根
		this.soapuiSet=soapuiSet;
		this.springName=springName;
		this.className=className;
		
	}

	@Override
	public void handlerMessage(SubmitContext submitContext,
			WsdlRequest wsdlRequest, Document data) throws Exception {
		// TODO 自动生成的方法存根
		HeaderOperation.setAuthContext(submitContext, wsdlRequest, soapuiSet, springName, className);
	}

	public TibSysSoapSetting getSoapuiSet() {
		return soapuiSet;
	}

	public void setSoapuiSet(TibSysSoapSetting soapuiSet) {
		this.soapuiSet = soapuiSet;
	}

	public String getSpringName() {
		return springName;
	}

	public void setSpringName(String springName) {
		this.springName = springName;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}
	
	


}
