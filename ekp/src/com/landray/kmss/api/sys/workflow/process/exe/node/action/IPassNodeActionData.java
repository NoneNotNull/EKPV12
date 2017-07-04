/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

import java.util.List;
import java.util.Map;

/**
 * 节点通过操作数据接口
 * 
 * @author 龚健
 * @since 2009.11.08
 * @see
 */
public interface IPassNodeActionData extends INodeActionData {
	/**
	 * 处理人操作：通过
	 */
	public static final String HANDLER_OPERATION_TYPE_PASS = "101";

	/**
	 * @return 审批意见
	 */
	public String getAuditNode();

	/**
	 * @return 消息通知方式（待办通知方式）
	 */
	public String getNotifyType();

	/**
	 * @return 即将流向节点ID
	 */
	public String getFutureNodeId();

	/**
	 * @return 流程通过后的通知
	 */
	public String getNotifyOnFinish();

	// --------- 即将流向修改处理人 ---------

	/**
	 * 
	 * @return 后续节点被修改成的处理人
	 */
	public String getFutureNodeHandlerIds();

	/**
	 * 
	 * @return 后续节点被修改成的处理人
	 */
	public String getFutureNodeHandlerNames();

	/**
	 * @return 修改后续节点处理人
	 */
	public boolean isModifyFutureNodeHandler();

	// ------ 其它节点修改处理人 --------

	/**
	 * @return 是否修改其它节点处理人
	 */
	public boolean isModifyOtherNodeHandlers();

	/**
	 * @return 修改其它节点处理人参数
	 */
	public List<Map<String, String>> getOtherHandlers();
}
