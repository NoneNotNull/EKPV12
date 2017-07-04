package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

/**
 * 树产生循环嵌套异常
 * 
 * @author 叶中奇
 */
public class TreeCycleException extends KmssRuntimeException {
	public TreeCycleException() {
		super(new KmssMessage("errors.treeCycle"));
	}
}
