package com.landray.kmss.km.review;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class ConvertUtil {

	private static Log log = LogFactory.getLog(ConvertUtil.class);

	/**
	 * 将list列表中对象id和name转换成字符串,
	 * 
	 * @param objects
	 *            要转换对象的列表
	 * @param objClass
	 *            列表中包含对象类型
	 * @return 返回list列表中,list[0] 是id字符串,list[1]是name字符串
	 */
	public static List<String> convertIdsAndNames(List<?> objects,
			Class<?> objClass) {
		List<String> list = new ArrayList<String>();
		StringBuffer idBuffer = new StringBuffer();
		StringBuffer nameBuffer = new StringBuffer();
		Method getIdMethod, getNameMethod;
		String id, name;

		try {
			// MethodUtils 自带Method cache性能会好些 by fuyx - 2011/1/19
			getIdMethod = MethodUtils.getAccessibleMethod(objClass, "getFdId",
					new Class[0]);
			getNameMethod = MethodUtils.getAccessibleMethod(objClass,
					"getFdName", new Class[0]);
			for (int i = 0; i < objects.size(); i++) {
				Object obj = objects.get(i);
				id = (String) getIdMethod.invoke(obj, new Object[] {});
				name = (String) getNameMethod.invoke(obj, new Object[] {});
				idBuffer.append(";").append(id);
				nameBuffer.append(";").append(name);
			}
		} catch (Exception e) {
			log.error("转换错误", e);
			return list;
		}
		if (idBuffer.length() > 1 && nameBuffer.length() > 1) {
			list.add(idBuffer.substring(1).toString());
			list.add(nameBuffer.substring(1).toString());
		} else {
			list.add("");
			list.add("");
		}
		return list;
	}
}
