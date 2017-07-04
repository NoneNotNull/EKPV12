package com.landray.kmss.tib.sys.soap.connector.util.executor.intereptor;

import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.SubmitContext;

public abstract class AbstractInterceptor {
	
	public AbstractInterceptor(int order) {
		this.order=order;
	}
	
	private int order;
	
	public abstract void handlerMessage(SubmitContext submitContext,
			WsdlRequest wsdlRequest,Document data) throws Exception;

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	
	
	
}
