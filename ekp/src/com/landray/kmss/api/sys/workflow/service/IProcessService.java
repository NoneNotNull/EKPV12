/**
 * 
 */
package com.landray.kmss.api.sys.workflow.service;

import com.landray.kmss.api.sys.workflow.process.def.IProcessDefinition;
import com.landray.kmss.api.sys.workflow.process.exe.IProcessInstance;
import com.landray.kmss.api.sys.workflow.process.exe.IProcessInstanceQuery;
import com.landray.kmss.common.model.IBaseModel;

/**
 * 流程服务接口
 * 
 * @author 龚健
 * @since 2009.09.21
 * @see
 */
public interface IProcessService {
	/**
	 * 获得流程实例，根据业务主model。
	 * 
	 * @param mainModel
	 * @return
	 * @throws Exception
	 */
	public IProcessInstance getProcess(IBaseModel mainModel) throws Exception;

	/**
	 * 获得流程实例，根据流程实例ID。
	 * 
	 * @param processId
	 * @return
	 * @throws Exception
	 */
	public IProcessInstance getProcess(String processId) throws Exception;

	/**
	 * 获得流程定义，根据模版model。<br>
	 * 此接口可用于流程模版。
	 * 
	 * @param template
	 * @param settingKey
	 *            唯一key
	 * @return
	 * @throws Exception
	 */
	public IProcessDefinition getProcessDefinition(IBaseModel template,
			String settingKey) throws Exception;

	/**
	 * 获得流程定义，根据流程实例ID。
	 * 
	 * @param mainModel
	 * @return
	 * @throws Exception
	 */
	public IProcessDefinition getProcessDefinition(String processId)
			throws Exception;

	/**
	 * 创建流程实例。 若存在相同的mainKey，并且关联相同的主域模型，则抛出异常。
	 * 
	 * @param definition
	 *            流程定义
	 * @param mainModel
	 *            主域模型
	 * @param mainKey
	 *            流程实例关键字
	 * @return
	 * @throws Exception
	 */
	public IProcessInstance createProcessInstance(
			IProcessDefinition definition, IBaseModel mainModel, String mainKey)
			throws Exception;

	/**
	 * @return 查询流程实例接口
	 */
	public IProcessInstanceQuery createProcessInstanceQuery();
}
