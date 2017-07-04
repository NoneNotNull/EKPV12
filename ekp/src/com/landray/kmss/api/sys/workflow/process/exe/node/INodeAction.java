/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.exe.node;

/**
 * 节点操作接口
 * 
 * @author 龚健
 * @since 2009.11.08
 * @see
 */
public interface INodeAction {
	/**
	 * 节点操作执行
	 * 
	 * @throws Exception
	 */
	public void execute() throws Exception;
}
