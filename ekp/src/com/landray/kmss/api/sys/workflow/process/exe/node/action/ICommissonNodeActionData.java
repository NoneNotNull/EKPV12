/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

/**
 * 转办
 * 
 * @author 傅游翔 2011-05
 * 
 */
public interface ICommissonNodeActionData extends INodeActionData {
	/**
	 * 处理人操作：转办
	 */
	public static final String HANDLER_OPERATION_TYPE_COMMISSION = "103";

	public String getToOtherHandlerIds();


	public String getToOtherHandlerNames();

	/**
	 * 处理意见
	 * @return
	 */
	public String getAuditNode();

	/**
	 * @return 通知方式 
	 */
	public String getNotifyType();
}
