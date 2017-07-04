/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe;

import java.util.List;

import com.landray.kmss.common.model.IBaseModel;

/**
 * 查询流程实例接口
 * 
 * @author 龚健
 * @since 2009.09.21
 * @see
 */
public interface IProcessInstanceQuery {
	/**
	 * @return 流程实例集
	 */
	public List<IProcessInstance> list();

	/**
	 * 清空流程实例集
	 */
	public void clear();

	/**
	 * 获得流程实例集。
	 * 
	 * @param template
	 *            模版
	 * @param key
	 *            流程模版key
	 * @return 查询流程实例
	 * @throws Exception
	 */
	public IProcessInstanceQuery getProcessInstance(IBaseModel template,
			String key) throws Exception;

	/**
	 * 获得流程实例集。
	 * 
	 * @param template
	 *            模版
	 * @param key
	 *            流程模版key
	 * @param runningNodeId
	 *            正在运行的节点ID
	 * @return 查询流程实例
	 * @throws Exception
	 */
	public IProcessInstanceQuery getProcessInstance(IBaseModel template,
			String key, String runningNodeId) throws Exception;
}
