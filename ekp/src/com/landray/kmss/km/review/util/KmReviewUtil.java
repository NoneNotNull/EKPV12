package com.landray.kmss.km.review.util;

import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2010-七月-20
 * 
 * @author zhuangwl
 */
public class KmReviewUtil {

	/**
	 * 将“aaa/r/nbbb/r/nccc”的字符串转换为SQL使用的“'aaa','bbb','ccc' ”
	 * 
	 * @param str
	 * @return
	 */
	public static String replaceToSQLString(String str) {
		if (str == null)
			return null;
		String rtnVal = str.trim();
		if (rtnVal.length() == 0)
			return str;
		rtnVal = rtnVal.replaceAll("\r\n", "','");
		return "'" + rtnVal + "'";
	}

	/**
	 * 得到当前路径
	 * 
	 * @param sysCategoryMain
	 * @param sPath
	 * @return
	 */
	public static String getSPath(SysCategoryMain sysCategoryMain, String sPath) {
		sPath = StringUtil.linkString(sysCategoryMain.getFdName(), ">>", sPath);
		if (sysCategoryMain.getFdParent() != null)
			sPath = getSPath((SysCategoryMain) sysCategoryMain.getFdParent(),
					sPath);
		else
			sPath = StringUtil.linkString("按类别", ">>", sPath);
		return sPath;
	}
}
