package com.landray.kmss.constant;

public interface SysNotifyConstant {
	/**
	 * 使用环境：设置发送待办的类型<br>
	 * 该类型的待办不会自动消失，应在应用程序中手工删除，一般用于审批
	 */
	public static final int NOTIFY_TODOTYPE_MANUAL = 1;

	/**
	 * 使用环境：设置发送待办的类型<br>
	 * 该类型的待办在点击后自动消失，一般用于简单的通知
	 */
	public static final int NOTIFY_TODOTYPE_ONCE = 2;

	/**
	 * 使用环境：设置代办的状态为“挂起”<br>
	 * 
	 */
	public static final int NOTIFY_TODOTYPE_MANUAL_SUSPEND = 3;

	/**
	 * 使用环境：设置发送待办的类型<br>
	 * 待办类型的默认值，目前取值为NOTIFY_TODOTYPE_ALWAY
	 */
	public static final int NOTIFY_TODOTYPE_DEFAULT = 2;

	/**
	 * 使用环境：设置发送待办的类型<br>
	 * 指的是除了NOTIFY_TODOTYPE_MANUAL外的所有其他类型的待办
	 */
	public static final int NOTIFY_TODOTYPE_OTHER = 0;
}
