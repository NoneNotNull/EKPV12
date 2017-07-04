package com.landray.kmss.tib.sys.core.provider.constants;

public interface TibSysCoreConstant {
	/**
	 * 仅满足条件的第一个实现
	 */
	static final String EXE_FIRST_IMPL = "1";
	/**
	 * 执行多个满足的实现
	 */
	static final String EXE_ALL_IMPL = "2";
	/**
	 * 多个满足条件则不执行
	 */
	static final String EXE_NO_IMPL = "3";
	/**
	 * 顺序执行多个满足的实现
	 */
	static final String ORDER_EXE_NO_IMPL = "4";
}
