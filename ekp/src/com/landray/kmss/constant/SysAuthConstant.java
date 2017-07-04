package com.landray.kmss.constant;

public interface SysAuthConstant {
	/**
	 * 权限过滤参数标识
	 */
	@Deprecated
	public static final String AUTH_CHECK_TYPE = "AUTH_CHECK_TYPE";

	/**
	 * 使用环境：findList/findValue/findPage的checkType参数<br>
	 * 查找数据的同时进行作者域的过滤
	 */
	@Deprecated
	public static final String AUTH_CHECK_EDITOR = "SYS_EDITOR";

	/**
	 * 使用环境：findList/findValue/findPage的checkType参数<br>
	 * 查找数据时进行数据过滤的方式，当前设置为AUTH_CHECK_NONE
	 */
	@Deprecated
	public static final String AUTH_CHECK_DEFAULT = "SYS_NONE";

	/**
	 * 使用环境：findList/findValue/findPage的checkType参数<br>
	 * 查找数据的同时不进行数据过滤
	 */
	@Deprecated
	public static final String AUTH_CHECK_NONE = "SYS_NONE";

	/**
	 * 使用环境：findList/findValue/findPage的checkType参数<br>
	 * 查找数据的同时进行读者域的过滤
	 */
	@Deprecated
	public static final String AUTH_CHECK_READER = "SYS_READER";

	/**
	 * 数据过滤参数类型。AuthCheck 权限过滤参数；AreaCheck 场所过滤参数；AllCheck 全局过滤参数；AreaSpecified
	 * 表示对指定的场所进行数据过滤，此时过滤参数应设为场所ID；AreaIsolation 场所数据隔离类型。
	 */
	enum CheckType {
		AuthCheck, AreaCheck, AllCheck, AreaSpecified, AreaIsolation;
	}

	/**
	 * 场所过滤参数。YES 表示查找数据的同时进行场所过滤；NO 表示查找数据的同时不进行场所过滤。
	 */
	enum AreaCheck implements SysAuthConstant {
		YES, NO;
	}

	/**
	 * 全局过滤参数，可以用作数据过滤的默认设置。DEFAULT 表示查找数据的时候进行读者域的权限过滤和场所过滤；NO
	 * 表示查找数据的时候不进行任何数据过滤。
	 */
	enum AllCheck implements SysAuthConstant {
		DEFAULT, NO;
	}

	/**
	 * 权限过滤参数。SYS_READER 表示查找数据的同时进行读者域的过滤；SYS_EDITOR 表示查找数据的同时进行作者域的过滤；SYS_NONE
	 * 表示查找数据的同时不进行数据过滤。
	 */
	enum AuthCheck implements SysAuthConstant {
		SYS_READER, SYS_EDITOR, SYS_NONE;
	}

	/**
	 * 场所数据隔离类型，包括扩展的类型。SELF 表示对本场所的数据可见；CHILD 表示对下级场所的数据可见；SUPER 表示对上级场所的数据可见； BRANCH
	 * 表示对上下级场所的数据都可见。
	 */
	enum AreaIsolation implements SysAuthConstant {
		SELF, CHILD, SUPER, BRANCH;
	}
}
