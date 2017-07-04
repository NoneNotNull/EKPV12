/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.def;

import java.util.List;

/**
 * 流程定义接口
 * 
 * @author 龚健
 * @since 2009.09.17
 * @see
 */
public interface IProcessDefinition {
	/**
	 * 若是流程模版，则返回模版ID。若是流程实例的定义，则返回null。（流程实例的定义存储在流程实例中）
	 * 
	 * @return 流程定义ID
	 */
	public String getId();

	/**
	 * @return 流程起始节点定义
	 */
	public INodeDefinition getStartNodeDefinition();

	/**
	 * @return 所有节点对象定义
	 */
	public List<INodeDefinition> getNodeDefinitions();

	/**
	 * 根据节点ID，获得节点对象定义
	 * 
	 * @param id
	 *            节点ID
	 * @return 节点对象定义对象
	 */
	public INodeDefinition getNodeDefinitionById(String id);
}
