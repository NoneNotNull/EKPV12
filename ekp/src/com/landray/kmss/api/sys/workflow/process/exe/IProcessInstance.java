/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe;

import java.util.List;

import com.landray.kmss.api.sys.workflow.process.def.IProcessDefinition;
import com.landray.kmss.api.sys.workflow.process.exe.node.IHistoryNodeInstance;
import com.landray.kmss.api.sys.workflow.process.exe.node.INodeAction;
import com.landray.kmss.api.sys.workflow.process.exe.node.INodeInstance;
import com.landray.kmss.api.sys.workflow.process.exe.node.action.INodeActionData;
import com.landray.kmss.common.model.IBaseModel;

/**
 * 流程实例接口
 * 
 * @author 龚健
 * @since 2009.09.20
 * @see
 */
public interface IProcessInstance {
	/**
	 * @return 流程定义
	 */
	public IProcessDefinition getDefinition();

	/**
	 * @return 流程ID
	 */
	public String getId();

	/**
	 * @return 所有节点对象
	 */
	public List<INodeInstance> getNodes();

	/**
	 * @return 当前待处理的节点对象集
	 */
	public List<INodeInstance> getRunningNodeInstances();

	/**
	 * 根据节点ID，获得节点对象
	 * 
	 * @param id
	 *            节点ID
	 * @return 节点对象
	 */
	public INodeInstance getNodeById(String id);

	/**
	 * @return 流程相关的业务主model
	 */
	public IBaseModel getMainModel();

	/**
	 * 创建节点操作对象。<br>
	 * 参数actionData必须是INodeActionData的子接口，若不是则会抛出异常；默认是IPassNodeActionData。
	 * 
	 * @param actionData
	 *            节点操作数据
	 * @return 节点操作对象
	 */
	public INodeAction createNodeAction(INodeActionData actionData)
			throws Exception;

	/**
	 * @return 流程历史节点集
	 */
	public List<IHistoryNodeInstance> getHistoryNodes();

	/**
	 * 保存流程
	 * 
	 * @throws Exception
	 */
	public void save() throws Exception;

	/**
	 * 删除流程
	 * 
	 * @throws Exception
	 */
	public void remove() throws Exception;
}
