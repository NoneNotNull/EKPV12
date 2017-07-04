/**
 * 
 */
package com.landray.kmss.api.sys.workflow;

import com.landray.kmss.api.sys.workflow.service.IProcessService;

/**
 * 流程接口
 * 
 * @author 龚健
 * @since 2009.09.20
 * @see
 */
public interface IWorkFlow {
	/**
	 * @return 流程服务
	 */
	public IProcessService getProcessService();
}
