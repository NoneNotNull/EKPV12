package com.landray.kmss.kms.multidoc.util;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2010-七月-20
 * 
 * @author zhuangwl
 */
public class KmsMultidocKnowledgeUtil {

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
	 * @param kmsMultidocTemplate
	 * @param sPath
	 * @return
	 */
	public static String getSPath(KmsMultidocTemplate kmsMultidocTemplate,
			String sPath) {
		sPath = StringUtil.linkString(kmsMultidocTemplate.getFdName(), ">>",
				sPath);
		if (kmsMultidocTemplate.getFdParent() != null)
			sPath = getSPath((KmsMultidocTemplate) kmsMultidocTemplate
					.getFdParent(), sPath);
		else
			sPath = StringUtil.linkString("按类别", ">>", sPath);
		return sPath;
	}

	/**
	 * 获取服务器url前缀
	 * 
	 * @param request
	 * @return
	 */
	public static String getUrlPrefix(HttpServletRequest request) {
		String contextPath = request.getContextPath();
		String dns = request.getScheme() + "://" + request.getServerName();
		if (request.getServerPort() != 80)
			dns += ":" + request.getServerPort();
		if (StringUtil.isNotNull(contextPath))
			return dns + contextPath;
		return dns;
	}

	/**
	 * 文档封面图片
	 * 
	 * @param expert
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String getImgUrl(KmsMultidocKnowledge kmKnow,
			HttpServletRequest request) throws Exception {
		return "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=docThumb&modelName=com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"
				+ "&" + "fdId=" + kmKnow.getFdId();
	}
}
