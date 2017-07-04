package com.landray.kmss.tib.sys.sap.connector.util;

/**
 * SAP 业务数据传输对象
 * 
 * @author zhangtian
 * 
 */
public class TibSysSapReturnVo {
	
	private Exception rtnExcepton ;
	/**
	 * 返回数据类型
	 */
	private String returnType;
	/**
	 * 返回的数据
	 */
	private Object result;

	public TibSysSapReturnVo() {
	}

	public TibSysSapReturnVo(String returnType, Object result) {
		this.returnType = returnType;
		this.result = result;
	}

	public String getReturnType() {
		return returnType;
	}

	public void setReturnType(String returnType) {
		this.returnType = returnType;
	}

	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

	public Exception getRtnExcepton() {
		return rtnExcepton;
	}

	public void setRtnExcepton(Exception rtnExcepton) {
		this.rtnExcepton = rtnExcepton;
	}

}
