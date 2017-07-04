package com.landray.kmss.tib.sys.soap.connector.util.executor.intereptor;

import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;
import com.landray.kmss.util.StringUtil;

/**
 * 用来设置soap头部的扩展点使用的拦击器
 * @author zhangtian
 *
 */
public class TibSysSoapHeadInterceptor extends AbstractInterceptor {

	private TibSysSoapSetting soapuiSet;
	private String springName;
	private String className;
	
	public TibSysSoapHeadInterceptor(TibSysSoapSetting soapuiSet,String springName,String className, int order) {
		super(order);
		// TODO 自动生成的构造函数存根
		this.soapuiSet=soapuiSet;
		this.springName=springName;
		this.className=className;
		
	}

	@Override
	public void handlerMessage(SubmitContext submitContext,
			WsdlRequest wsdlRequest, Document data) throws Exception {
		String soapHeaderCustom = soapuiSet.getSoapHeaderCustom();
		// 合并请求XML，主要是为了建造SoapHeader（此种是从"前"台自定义头部信息）
		if (StringUtil.isNotNull(soapHeaderCustom)) {
			data = HeaderOperation.mergeInputNode(
					soapHeaderCustom, data);
		} else {
			// 获取拥有头部消息的请求参数（此种是从"后"台自定义头部信息）
			 HeaderOperation.reBuildDocNode(data, className,
					springName, soapuiSet);
		}
		
		
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
