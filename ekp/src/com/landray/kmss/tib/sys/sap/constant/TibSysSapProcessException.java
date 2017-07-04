package com.landray.kmss.tib.sys.sap.constant;

import com.landray.kmss.util.ResourceUtil;

/**
 * 业务数据异常
 * @author zhangtian
 *
 */
public class TibSysSapProcessException extends Exception {
	
	private static final long serialVersionUID = 1L;

	TibSysSapProcessException(){
		super();
	}
	
	/**
	 * 根据资源文件key,提示msg
	 * @param key
	 */
	public TibSysSapProcessException(String key) {
		super(ResourceUtil.getString(key, "tib-sys-sap-connector"));
	}
	
	/**
	 * 自定义异常信息
	 * @param defMsg
	 * @param msg
	 */
	public TibSysSapProcessException(boolean defMsg,String msg) {
		super(msg);
	}

}
