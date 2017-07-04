package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;

/**
 * 用于抛出程序过程中的错误，建议当处理错误的时候直接调用或者通过继承的方式编写新的异常。<br>
 * 本类结合了{@link com.landray.kmss.util.KmssMessage KmssMessage}，使国际化的实现更加简便。<br>
 * 与实时错误不一样的是，当该错误抛出时，在类中一定要声明异常的抛出，对于调用者来说需要接住或声明抛出。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class KmssException extends Exception {
	public KmssMessages kmssMessages = null;

	public KmssException(Throwable cause) {
		super(cause.toString(), cause);
		kmssMessages = new KmssMessages().addError(cause);
	}

	public KmssException(KmssMessage msg) {
		super(msg.toString());
		kmssMessages = new KmssMessages().addError(msg.setThrowable(this));
	}

	public KmssException(KmssMessage msg, Throwable cause) {
		super(msg.toString(), cause);
		kmssMessages = new KmssMessages().addError(msg.setThrowable(cause));
	}

	public KmssException(KmssMessages msgs) {
		super("errors.unknown");
		kmssMessages = new KmssMessages().concat(msgs).setHasError();
	}

	public KmssException(KmssMessages msgs, Throwable cause) {
		super(cause.toString(), cause);
		kmssMessages = new KmssMessages().addError(cause).concat(msgs);
	}

	public KmssMessages getKmssMessages() {
		return kmssMessages;
	}
}
