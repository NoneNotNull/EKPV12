/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

import com.landray.kmss.sys.workflow.constant.OAConstant;

/**
 * @author fyx
 * 
 */
public interface IAbandonNodeData extends INodeActionData {
	/**
	 * 处理人操作：废弃
	 */
	public static final String HANDLER_OPERATION_TYPE_ABANDON = String
			.valueOf(OAConstant.HANDLER_OPERATION_TYPE_ABANDON);

	/**
	 * @return 审批意见
	 */
	public String getAuditNode();

	/**
	 * @return 消息通知方式（待办通知方式）
	 */
	public String getNotifyType();
}
