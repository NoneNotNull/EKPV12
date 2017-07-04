/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

/**
 * 处理人操作：沟通
 * 
 * @author 傅游翔 2011-05
 * 
 */
public interface ICommunicateNodeActionData extends INodeActionData {
	/**
	 * 处理人操作：沟通
	 */
	public static final String HANDLER_OPERATION_TYPE_COMMUNICATE = "104";

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
