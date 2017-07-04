package com.landray.kmss.km.doc.util;

import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2010-七月-20
 * 
 * @author zhuangwl
 */
public class KmDocKnowlegeUtil {

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
	 * @param kmDocTemplate
	 * @param sPath
	 * @param isCurrent
	 * @return
	 */
	public static String getSPath(KmDocTemplate kmDocTemplate, String sPath) {
		String tmpName = kmDocTemplate.getFdName();
		sPath = StringUtil.linkString(tmpName, "  >  ", sPath);
		if (kmDocTemplate.getFdParent() != null)
			sPath = getSPath((KmDocTemplate) kmDocTemplate.getFdParent(), sPath);
		else
			sPath = StringUtil.linkString(ResourceUtil.getString("km-doc",
					"kmDoc.tree.maindirectory"), "  >  ", sPath);
		return sPath;
	}

}
