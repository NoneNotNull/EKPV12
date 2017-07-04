package com.landray.kmss.api.sys.workflow.process.exe.node.action;

/**
 * 节点回复沟通操作数据接口
 * 
 * @author fyx 2011-04
 * 
 */
public interface IRtncommunicateNodeActionData extends INodeActionData {

	public static final String HANDLER_OPERATION_TYPE_RTNCOMMUNICATE = "107";

	/**
	 * @return 审批意见
	 */
	public String getAuditNode();

	/**
	 * @return 消息通知方式（待办通知方式）
	 */
	public String getNotifyType();
	
	
}
