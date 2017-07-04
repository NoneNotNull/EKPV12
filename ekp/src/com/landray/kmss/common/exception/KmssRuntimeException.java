package com.landray.kmss.common.exception;

import org.springframework.core.NestedRuntimeException;

import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;

/**
 * 用于抛出程序过程中的实时错误，建议当处理错误的时候直接调用或者通过继承的方式编写新的异常。<br>
 * 本类结合了{@link com.landray.kmss.util.KmssMessage KmssMessage}，使国际化的实现更加简便。<br>
 * 实时的异常，对调用者来说不一定需要接住或抛出，一旦该异常抛出，若上一层调用没有接住，错误会一致往上冒。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class KmssRuntimeException extends NestedRuntimeException {
	private KmssMessages kmssMessages = null;

	public KmssRuntimeException(Throwable cause) {
		super(cause.toString(), cause);
		kmssMessages = new KmssMessages().addError(cause);
	}

	public KmssRuntimeException(KmssMessage msg) {
		super(msg.toString());
		kmssMessages = new KmssMessages().addError(msg.setThrowable(this));
	}

	public KmssRuntimeException(KmssMessage msg, Throwable cause) {
		super(msg.toString(), cause);
		kmssMessages = new KmssMessages().addError(msg.setThrowable(cause));
	}

	public KmssRuntimeException(KmssMessages msgs) {
		super("errors.unknown");
		kmssMessages = new KmssMessages().concat(msgs).setHasError();
	}

	public KmssRuntimeException(KmssMessages msgs, Throwable cause) {
		super(cause.toString(), cause);
		kmssMessages = new KmssMessages().addError(cause).concat(msgs);
	}

	public KmssMessages getKmssMessages() {
		return kmssMessages;
	}
}
