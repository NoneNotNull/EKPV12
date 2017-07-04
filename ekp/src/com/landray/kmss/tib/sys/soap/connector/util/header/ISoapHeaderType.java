package com.landray.kmss.tib.sys.soap.connector.util.header;

import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;


public abstract class ISoapHeaderType {
	/**
	 * 登录的验证方式，采用在头部加入验证信息
	 * 扩展只要实现这个方法，doc中//Envelope/Header（选取此节点对头部改造）。
	 * 由于只过滤头部无法达到在传入参数内部做验证，因此加以修改 2013-7-19
	 * @param doc			整个请求参数(Input)的DOM节点
	 * @throws Exception	
	 */
	public void buildDocTemplate(Document doc, TibSysSoapSetting soapuiSet) throws Exception{
		// 用于继承使用
	}
	
	/**
	 * 登录的验证方式，采用权限过滤
	 * @param context		提交内容
	 * @param request		请求参数(用户名、密码已经存在了，密码类型等信息需要自己设置)
	 * @throws Exception
	 */
	public void buildAuthContext(SubmitContext context, WsdlRequest request, TibSysSoapSetting soapuiSet) throws Exception{
		// 用于继承使用
	}
}
