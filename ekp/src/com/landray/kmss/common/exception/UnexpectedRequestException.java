package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

/**
 * 无效的请求异常
 * 
 * @author 叶中奇
 */
public class UnexpectedRequestException extends KmssRuntimeException {
	public UnexpectedRequestException() {
		super(new KmssMessage("error.unexpectedRequest"));
	}
}
