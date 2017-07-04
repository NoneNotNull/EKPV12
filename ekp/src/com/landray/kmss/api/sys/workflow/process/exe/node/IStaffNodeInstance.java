/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node;

import java.util.List;

import com.landray.kmss.sys.organization.model.SysOrgElement;

/**
 * 人工参与节点实例接口
 * 
 * @author 龚健
 * @since 2009.11.09
 * @see
 */
public interface IStaffNodeInstance extends INodeInstance {
	/**
	 * 设置节点的处理人。<br>
	 * 若节点为当前流程实例正在运行的节点，则此操作为空操作。
	 * 
	 * @param handlers
	 */
	public void setAssignee(List<SysOrgElement> handlers) throws Exception;

	/**
	 * 获取节点的处理人。
	 * 
	 * @return 当前节点的处理人
	 */
	public List<SysOrgElement> getAssignee() throws Exception;
}
