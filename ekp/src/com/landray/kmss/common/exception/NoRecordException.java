package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

/**
 * 找不到相关记录异常
 * 
 * @author 叶中奇
 */
public class NoRecordException extends KmssRuntimeException {
	public NoRecordException() {
		super(new KmssMessage("errors.noRecord"));
	}
}
