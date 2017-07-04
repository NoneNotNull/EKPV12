/**
 * 
 */
package com.landray.kmss.api.sys.workflow.process.def;

/**
 * 流程节点附加选项
 * 
 * @author 龚健
 * @since 2009.11.09
 * @see
 */
public interface INodeVariant {
	/**
	 * @return 附加选项名
	 */
	public String getName();

	/**
	 * @return 附加选项值
	 */
	public String getValue();
}
