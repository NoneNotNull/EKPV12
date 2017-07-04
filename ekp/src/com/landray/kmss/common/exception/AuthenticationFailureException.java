package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

/**
 * 验证过程发生错误产生的异常
 * 
 * @author 叶中奇
 * 
 */
public class AuthenticationFailureException extends KmssRuntimeException {
	public AuthenticationFailureException(String key) {
		super(new KmssMessage(key));
	}
}
