package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

/**
 * 域模型中某属性无法找到的异常
 * 
 * @author 叶中奇
 * 
 */
public class FieldNotFoundException extends KmssRuntimeException {
	public FieldNotFoundException() {
		super(new KmssMessage("errors.fieldNotFound"));
	}

	public FieldNotFoundException(Throwable e) {
		super(new KmssMessage("errors.fieldNotFound"), e);
	}
}
