/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.def;

import java.util.List;

import com.landray.kmss.sys.organization.model.SysOrgElement;

/**
 * 节点定义接口
 * 
 * @author 龚健
 * @since 2009.09.18
 * @see
 */
public interface INodeDefinition {
	/**
	 * @return 流程定义
	 */
	public IProcessDefinition getProcessDefinition();

	/**
	 * @return 节点ID
	 */
	public String getNodeId();

	/**
	 * @return 节点名
	 */
	public String getName();

	/**
	 * @return 节点类型
	 */
	public String getNodeType();

	/**
	 * 目前流程定义的开始节点为 起草节点
	 * 
	 * @return 是否是开始节点
	 */
	public Boolean isStartNode();

	/**
	 * @return 是否是结束节点
	 */
	public Boolean isEndNode();

	/**
	 * @return 下一节点定义集
	 */
	public List<INodeDefinition> getNextNodeDefinitions();

	/**
	 * @return 节点附加选项集
	 */
	public List<INodeVariant> getNodeVariants();

	/**
	 * @return 节点处理人
	 */
	public List<SysOrgElement> getAssignee();
}
