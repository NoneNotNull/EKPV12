package com.landray.kmss.util;

public class ExceptionUtil {
	/**
	 * 获取错误的详细信息
	 * 
	 * @param e
	 * @return
	 */
	public static String getExceptionString(Throwable e) {
		StringBuffer rtnVal = new StringBuffer();
		appendExceptionString(e, rtnVal, 0);
		return rtnVal.toString();
	}

	private static void appendExceptionString(Throwable e, StringBuffer rtnVal,
			int time) {
		String strMsg = e.toString();
		if (!StringUtil.isNull(strMsg)) {
			rtnVal.append(strMsg);
			rtnVal.append("\r\n\t");
		}
		StackTraceElement[] ste = e.getStackTrace();
		if (ste.length > 0) {
			rtnVal.append(ste[0].toString());
			for (int i = 1; i < ste.length; i++) {
				rtnVal.append("\r\n\t");
				rtnVal.append(ste[i].toString());
			}
		}
		if (e.getCause() != null) {
			if (time > 10) {
				rtnVal.append("\r\nCaused by:" + e.getCause());
			} else {
				rtnVal.append("\r\nCaused by:");
				appendExceptionString(e.getCause(), rtnVal, time + 1);
			}
		}
	}
}
