/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node;

import java.util.Date;

import com.landray.kmss.api.sys.workflow.process.exe.IProcessInstance;

/**
 * 流程历史节点实例的接口
 * 
 * @author 龚健
 * @since 2009.09.23
 * @see
 */
public interface IHistoryNodeInstance {
	/**
	 * @return 流程实例
	 */
	public IProcessInstance getProcess();

	/**
	 * @return 节点名
	 */
	public String getName();

	/**
	 * @return 节点类型
	 */
	public String getNodeType();

	/**
	 * @return 起始日期
	 */
	public Date getStartDate();

	/**
	 * @return 结束日期
	 */
	public Date getFinishDate();
}
