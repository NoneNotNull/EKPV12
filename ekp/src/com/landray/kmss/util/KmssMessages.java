package com.landray.kmss.util;

import java.sql.BatchUpdateException;
import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.common.exception.KmssException;
import com.landray.kmss.common.exception.KmssRuntimeException;

/**
 * 信息列表。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class KmssMessages {
	private boolean error = false;

	/**
	 * @return true：返回列表中包含错误信息
	 */
	public boolean hasError() {
		return error;
	}

	/**
	 * 将信息列表设置为已经包含了错误信息。
	 * 
	 * @return 当前实例
	 */
	public KmssMessages setHasError() {
		this.error = true;
		return this;
	}

	private List<KmssMessage> messages = new ArrayList<KmssMessage>();

	public KmssMessages() {
	}

	/**
	 * 添加信息。
	 * 
	 * @param msg
	 *            信息对象
	 * @return 当前实例
	 */
	public KmssMessages addMsg(KmssMessage msg) {
		messages.add(msg);
		return this;
	}

	/**
	 * 将信息作为错误信息添加。
	 * 
	 * @param e
	 *            信息对象。
	 * @return 当前实例
	 */
	public KmssMessages addError(KmssMessage e) {
		error = true;
		messages.add(e.setMessageType(KmssMessage.MESSAGE_ERROR));
		return this;
	}

	/**
	 * 添加一个异常。
	 * 
	 * @param e
	 *            异常对象
	 * @return 当前实例
	 */
	public KmssMessages addError(Throwable e) {
		error = true;
		if (e instanceof KmssRuntimeException)
			return concat(((KmssRuntimeException) e).getKmssMessages());
		if (e instanceof KmssException)
			return concat(((KmssException) e).getKmssMessages());
		Throwable ex = e;
		while (ex.getCause() != null) {
			ex = ex.getCause();
		}
		if (ex instanceof BatchUpdateException) {
			messages
					.add((new KmssMessage("error.constraintViolationException"))
							.setThrowable(e).setMessageType(
									KmssMessage.MESSAGE_ERROR));
			return this;
		}
		messages.add((new KmssMessage("errors.unknown")).setThrowable(e)
				.setMessageType(KmssMessage.MESSAGE_ERROR));
		return this;
	}

	/**
	 * 添加一个异常，并指定异常的消息。
	 * 
	 * @param msg
	 *            异常信息
	 * @param e
	 *            异常对象
	 * @return 当前实例
	 */
	public KmssMessages addError(KmssMessage msg, Throwable e) {
		error = true;
		messages.add(msg.setThrowable(e).setMessageType(
				KmssMessage.MESSAGE_ERROR));
		return this;
	}

	/**
	 * 链接另外一个信息列表。
	 * 
	 * @param msgs
	 *            信息列表对象
	 * @return 当前实例
	 */
	public KmssMessages concat(KmssMessages msgs) {
		messages.removeAll(msgs.getMessages());
		messages.addAll(msgs.getMessages());
		error = (error || msgs.hasError());
		return this;
	}

	/**
	 * @return 信息列表中的所有信息
	 */
	public List<KmssMessage> getMessages() {
		return messages;
	}
}
