/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node.action;

import com.landray.kmss.sys.organization.model.SysOrgElement;

/**
 * 节点操作数据接口
 * 
 * @author 龚健
 * @since 2009.11.08
 * @see
 */
public interface INodeActionData {
	/**
	 * @return 操作节点ID
	 */
	public String getNodeId();

	/**
	 * 操作类型选项，请查看相关子接口描述。
	 * 
	 * @return 操作类型
	 */
	public String getOperationType();

	/**
	 * @return 操作人
	 */
	public SysOrgElement getAssignee();
	
}
