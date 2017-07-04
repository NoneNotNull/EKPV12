package com.landray.kmss.tib.sys.soap.connector.util.header;


public class TibSysSoapRtn {
	
	//返回标记 @see com.landray.kmss.tib.sys.soap.connector.constant.SoapuiConstant
	private int  returnType;
	//返回数据对象 org.w3c.dom.Document
	private Object returnData;
	private Exception returnException ;
	private String message;
	
	public TibSysSoapRtn(int returnType, Object returnData) {
		super();
		this.returnType = returnType;
		this.returnData = returnData;
	}
	public int getReturnType() {
		return returnType;
	}
	public void setReturnType(int returnType) {
		this.returnType = returnType;
	}
	public Object getReturnData() {
		return returnData;
	}
	public void setReturnData(Object returnData) {
		this.returnData = returnData;
	}
	public Exception getReturnException() {
		return returnException;
	}
	public void setReturnException(Exception returnException) {
		this.returnException = returnException;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
}
