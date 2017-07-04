/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node;

import java.util.List;

import com.landray.kmss.api.sys.workflow.process.def.INodeDefinition;
import com.landray.kmss.api.sys.workflow.process.exe.IProcessInstance;

/**
 * 流程节点实例接口
 * 
 * @author 龚健
 * @since 2009.09.20
 * @see
 */
public interface INodeInstance {
	/**
	 * 状态：激活
	 */
	public static final String STATE_ACTIVATED = "20";
	/**
	 * 状态：结束
	 */
	public static final String STATE_COMPLETED = "30";

	/**
	 * @return 流程节点定义
	 */
	public INodeDefinition getDefinition();

	/**
	 * @return 流程实例
	 */
	public IProcessInstance getProcessInstance();

	/**
	 * @return 节点状态
	 */
	public String getStatus();

	/**
	 * @return 下一节点定义集
	 */
	public List<INodeInstance> getNextNodes();
}
