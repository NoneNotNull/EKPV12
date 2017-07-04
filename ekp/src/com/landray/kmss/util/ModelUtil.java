package com.landray.kmss.util;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.exception.TreeCycleException;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.config.design.SysCfgFilter;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictListProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;

public class ModelUtil {
	/**
	 * 获取一个域模型的URL
	 * 
	 * @param mainModel
	 * @return
	 */
	public static String getModelUrl(Object mainModel) {
		String className = getModelClassName(mainModel);
		String url = null;
		SysDictModel model = SysDataDict.getInstance().getModel(className);
		while (model != null) {
			if (!StringUtil.isNull(model.getUrl()))
				url = model.getUrl();
			if (StringUtil.isNull(model.getDiscriminatorProperty()))
				break;
			try {
				className = BeanUtils.getProperty(mainModel, model
						.getDiscriminatorProperty());
			} catch (Exception e) {
				break;
			}
			if (StringUtil.isNull(className))
				break;
			model = SysDataDict.getInstance().getModel(className);
		}
		return formatModelUrl(mainModel, url);
	}

	/**
	 * 获取一个域模型的URL
	 * 
	 * @param mainModel
	 * @param className
	 * @return
	 */
	public static String getModelUrl(Object mainModel, String className) {
		SysDictModel model = SysDataDict.getInstance().getModel(className);
		if (model == null)
			return null;
		return formatModelUrl(mainModel, model.getUrl());
	}

	/**
	 * 根据域对象的值对URL中的${property}信息进行替换
	 * 
	 * @param mainModel
	 * @param url
	 * @return
	 */
	private static String formatModelUrl(Object mainModel, String url) {
		if (StringUtil.isNull(url))
			return null;
		Pattern p = Pattern.compile("\\$\\{([^}]+)\\}");
		Matcher m = p.matcher(url);
		while (m.find()) {
			String property = m.group(1);
			try {
				String value = BeanUtils.getProperty(mainModel, property);
				url = StringUtil.replace(url, "${" + property + "}", value);
			} catch (Exception e) {
			}
		}
		return url;
	}

	/**
	 * 判断一个对象是否被Hibernate的延时加载机制给修改，并返回正确的类名
	 * 
	 * @param mainModel
	 * @return
	 */
	public static String getModelClassName(Object mainModel) {
		String rtnVal = mainModel.getClass().getName();
		int i = rtnVal.indexOf('$');
		if (i > -1)
			rtnVal = rtnVal.substring(0, i);
		return rtnVal;
	}

	/**
	 * 返回HQL语句中用于查询使用的表名，如：sysOrgElement
	 * 
	 * @param mainModel
	 * @return
	 */
	public static String getModelTableName(Object mainModel) {
		String rtnVal = mainModel instanceof String ? (String) mainModel
				: getModelClassName(mainModel);
		int i = rtnVal.lastIndexOf('.');
		if (i > -1)
			rtnVal = rtnVal.substring(i + 1);
		return rtnVal.substring(0, 1).toLowerCase() + rtnVal.substring(1);
	}

	/**
	 * 检查树结构的域模型中是否出现了循环嵌套，校验失败后抛出TreeCycleException异常
	 * 
	 * @param treeModel
	 *            树的域模型
	 * @param parent
	 *            即将要设置父节点
	 * @param parentProperty
	 *            父节点的属性名称
	 * @throws TreeCycleException
	 */
	public static void checkTreeCycle(Object treeModel, Object parent,
			String parentProperty) throws TreeCycleException {
		List parentList = new ArrayList();
		parentList.add(treeModel);
		try {
			for (Object curNode = parent; curNode != null; curNode = PropertyUtils
					.getProperty(curNode, parentProperty)) {
				if (parentList.contains(curNode)) {
					throw new TreeCycleException();
				}
				parentList.add(curNode);
			}
		} catch (TreeCycleException e) {
			throw e;
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
	}

	/**
	 * 对象克隆
	 * 
	 * @param object
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 * @throws InvocationTargetException
	 */
	public static Object clone(Object object) throws InstantiationException,
			IllegalAccessException, ClassNotFoundException,
			InvocationTargetException {
		String clsName = getModelClassName(object);
		Object newObj = Class.forName(clsName).newInstance();
		BeanUtils.copyProperties(newObj, object);
		return newObj;
	}

	/**
	 * 获取域模型中propertyName属性对应的信息，并对枚举、列表等相关信息进行处理
	 * 
	 * @param model
	 *            域模型
	 * @param propertyName
	 *            属性名，格式可以为a.b.c
	 * @param splitStr
	 *            若属性名中间出现列表时使用，多值分隔符
	 * @param locale
	 *            若出现时间、枚举等信息时使用
	 * @return
	 * @throws Exception
	 */
	public static String getModelPropertyString(Object model,
			String propertyName, String splitStr, Locale locale)
			throws Exception {
		int index = propertyName.indexOf('.');
		String subPropertyName = null;
		if (index > -1) {
			subPropertyName = propertyName.substring(index + 1);
			propertyName = propertyName.substring(0, index);
		}
		Object value = PropertyUtils.getProperty(model, propertyName);
		if (value == null)
			return "";
		if (value instanceof List) {
			List values = (List) value;
			if (values.isEmpty())
				return "";
			if (subPropertyName == null) {
				subPropertyName = SysDataDict.getInstance().getModel(
						getModelClassName(values.get(0))).getDisplayProperty();
				if (StringUtil.isNull(subPropertyName))
					throw new KmssRuntimeException(new KmssMessage(
							"error.datadict.displayPropertyUndefined",
							getModelClassName(values.get(0))));
			}
			StringBuffer rtnStr = new StringBuffer();
			for (int i = 0; i < values.size(); i++) {
				String propertyValue = getModelPropertyString(values.get(i),
						subPropertyName, splitStr, locale);
				/*
				 * propertyValue不为空才能执行操作，否则会出现多个分隔符的情况。 苏轶 2007年5月23日修正
				 */
				if (StringUtils.isNotBlank(propertyValue))
					rtnStr.append(splitStr + propertyValue);
			}
			if (rtnStr.length() > 0)
				return rtnStr.substring(splitStr.length());
			else
				return "";
		} else if (value instanceof IBaseModel) {
			if (subPropertyName == null) {
				subPropertyName = SysDataDict.getInstance().getModel(
						getModelClassName(value)).getDisplayProperty();
				if (StringUtil.isNull(subPropertyName))
					throw new KmssRuntimeException(new KmssMessage(
							"error.datadict.displayPropertyUndefined",
							getModelClassName(value)));
			}
			return getModelPropertyString(value, subPropertyName, splitStr,
					locale);
		} else if (value instanceof Date) {// 吴兵 2007年9月16日增加
			String type = getPropertyType(getModelClassName(model),
					propertyName).toLowerCase();
			if (!("datetime".equals(type) || "date".equals(type) || "time"
					.equals(type))) {
				type = "date";
			}
			return DateUtil.convertDateToString((Date) value, type, locale);
		} else {
			SysDictCommonProperty property = (SysDictCommonProperty) SysDataDict
					.getInstance().getModel(getModelClassName(model))
					.getPropertyMap().get(propertyName);
			if (!StringUtil.isNull(property.getEnumType())) {
				if (property.getType().equals("Boolean"))
					value = ((Boolean) value).booleanValue() ? "1" : "0";
				return EnumerationTypeUtil.getColumnEnumsLabel(property
						.getEnumType(), value.toString(), locale);
			} else
				return value.toString();
		}
	}

	/**
	 * 获取域模型某个属性的类型，返回值为数据字典定义的类型
	 * 
	 * @param modelName
	 * @param property
	 *            属性名，可为a.b.c的格式
	 * @return 返回数据字典定义的类型，若为数组，则在返回类型中加上[]，如：String[]
	 */
	public static String getPropertyType(String modelName, String property) {
		SysDataDict dataDict = SysDataDict.getInstance();
		String[] properties = property.split("\\.");
		SysDictCommonProperty dictProperty = null;
		String arr = "";
		for (int i = 0; i < properties.length; i++) {
			dictProperty = (SysDictCommonProperty) dataDict.getModel(modelName)
					.getPropertyMap().get(properties[i]);
			if (dictProperty instanceof SysDictListProperty)
				arr = "[]";
			modelName = dictProperty.getType();
		}
		return modelName + arr;
	}

	/**
	 * 判断某个域模型是否已经持久化
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public static boolean isModelMerge(IBaseModel model) throws Exception {
		return isModelMerge(getModelClassName(model), model.getFdId());
	}

	public static boolean isModelMerge(String modelName, String id)
			throws Exception {
		return ((IBaseDao) SpringBeanUtil.getBean("KmssBaseDao")).isExist(
				modelName, id);
	}

	/**
	 * 根据域模型获取当前模块的角色权限
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public static List getModelRoles(String modelName) throws Exception {
		StringBuffer sb = new StringBuffer();
		SysDictModel sysDictModel = SysDataDict.getInstance().getModel(
				modelName);
		Map map = null;
		if (sysDictModel != null) {
			map = SysDataDict.getInstance().getModel(modelName).getFilters();
		}
		List all = new ArrayList();
		if (map == null) {
			return all;
		}
		String filter, parameter, filterName;
		for (Iterator iter = map.keySet().iterator(); iter.hasNext();) {
			String key = (String) iter.next();
			List list = (List) map.get(key);
			for (int i = 0; i < list.size(); i++) {
				filter = ((SysCfgFilter) list.get(i)).getExpression();
				int j = filter.indexOf('(');
				filterName = filter.substring(0, j);
				if ("roleFilter".equals(filterName)) {
					parameter = filter.substring(j + 1, filter.length() - 1);
					Map pm = StringUtil.getParameterMap(parameter, ",");
					String[] rk = (String[]) pm.get("role");
					for (int m = 0; m < rk.length; m++) {
						String[] roles = rk[m].split("\\s*;\\s*");
						for (int k = 0; k < roles.length; k++) {
							all.add(roles[k]);
						}
					}
				}
			}
		}
		return all;
	}

	public static List getModelRoles(IBaseModel model) throws Exception {
		return getModelRoles(getModelClassName(model));
	}

	/**
	 * 根据模块的域模型名存取该模块的角色权限
	 */
	private static Map<String, List> modelRoles = new HashMap<String, List>();

	public static List getModelRolesInMap(IBaseModel model) throws Exception {
		return getModelRolesInMap(getModelClassName(model));
	}

	public static List getModelRolesInMap(String modelName) throws Exception {
		if (!modelRoles.keySet().contains(modelName)) {
			modelRoles.put(modelName, getModelRoles(modelName));
		}
		return modelRoles.get(modelName);
	}
}
