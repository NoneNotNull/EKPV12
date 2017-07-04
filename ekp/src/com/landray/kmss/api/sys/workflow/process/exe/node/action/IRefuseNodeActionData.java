/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

/**
 * 节点驳回操作数据接口
 * 
 * @author 龚健
 * @since 2009.11.08
 * @see
 */
public interface IRefuseNodeActionData extends INodeActionData {
	/**
	 * 处理人操作：驳回
	 */
	public static final String HANDLER_OPERATION_TYPE_REFUSE = "102";

	/**
	 * @return 驳回或跳转到的节点ID
	 */
	public String getJumpToNodeId();

	/**
	 * @param nodeId
	 *            驳回或跳转到的节点ID
	 */
	public void setJumpToNodeId(String nodeId);

	/**
	 * @return 驳回的节点通过后是否直接返回本节点，值有：true 或 false
	 */
	public String getRefusePassedToThisNode();
	
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
