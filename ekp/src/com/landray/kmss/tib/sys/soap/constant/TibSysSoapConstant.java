package com.landray.kmss.tib.sys.soap.constant;

/**
 *
 * 一般性全局变量定义
 * date :2012-11-13 下午10:30:39
 */
public interface TibSysSoapConstant {
	
	public final String SOAPVERSON_SOAP11="SOAP 1.1";
	
	public final String SOAPVERSON_SOAP12="SOAP 1.2";
	
	public final int SOAPUI_RETURNTYPE_SUCCESS=0; 
	
	public final int SOAPUI_RETURNTYPE_ERROR=1; 
	
	public final int SOAPUI_RETURNTYPE_BIERROR=2; 
	
	/**
	 * soap 类型,输入soap
	 */
	public final String SOAP_NODE_TYPE_IN="Input"; 
	/**
	 * soap 类型,输出soap
	 */
	public final String SOAP_NODE_TYPE_OUT="Output"; 
	/**
	 * soap 类型,错误soap
	 */
	public final String SOAP_NODE_TYPE_FAULT="Fault"; 
}
