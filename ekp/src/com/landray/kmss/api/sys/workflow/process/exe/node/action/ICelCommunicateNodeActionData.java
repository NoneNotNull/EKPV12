/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

/**
 * 处理人操作：取消沟通
 * 
 * @author 傅游翔 2011-05
 * 
 */
public interface ICelCommunicateNodeActionData extends INodeActionData {

	public static final String HANDLER_OPERATION_TYPE_CELCOMMUNICATE = "108";
	
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
