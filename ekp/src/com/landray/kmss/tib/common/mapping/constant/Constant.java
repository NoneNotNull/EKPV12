package com.landray.kmss.tib.common.mapping.constant;

public interface Constant {
	// ===WebService
	public static final String FD_TYPE_WEBSERVICE = "2";
	
	public static final String FD_TYPE_SAP = "1";
	
	public static final String FD_TYPE_SOAP = "3";
	
	public static final String FD_TYPE_JDBC = "4";
	
	
	/**
	 * 表单事件
	 */
	public static final String INVOKE_TYPE_FORMEVENT= "0";
	
	/**
	 * 表单新增
	 */
	@Deprecated
	public static final String INVOKE_TYPE_FORMADD= "1";
	
	/**
	 * 表单删除
	 */
	public static final String INVOKE_TYPE_FORMDEL= "2";
	
	/**
	 * 表单保存
	 */
	public static final String INVOKE_TYPE_FORMSAVE= "4";
	
	/**
	 * 机器人节点
	 */
	public static final String INVOKE_TYPE_FORMROBOT= "3";
	
	/**
	 * 表单控件
	 */
	public static final String INVOKE_TYPE_FORMCONTROL= "5";
	
	/**
	 * 流程驳回
	 */
	public static final String INVOKE_TYPE_FLOWREJECT= "6";
}
