package com.landray.kmss.code.examine;

import java.beans.PropertyDescriptor;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;

import com.landray.kmss.code.create.hbmdict.BaseProperty;
import com.landray.kmss.code.create.hbmdict.HbmBag;
import com.landray.kmss.code.create.hbmdict.HbmClass;
import com.landray.kmss.code.create.hbmdict.HbmList;
import com.landray.kmss.code.create.hbmdict.HbmManyToOne;
import com.landray.kmss.code.create.hbmdict.HbmMapping;
import com.landray.kmss.code.create.hbmdict.HbmProperty;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictListProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.dict.SysDictModelProperty;
import com.landray.kmss.sys.config.dict.SysDictSimpleProperty;
import com.landray.kmss.sys.notify.interfaces.ISysNotifyModel;
import com.landray.kmss.util.EnumerationTypeUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class DataDictExaminer implements IExaminer {
	private static Map typeMap = new HashMap();

	private static List commonProperties;
	static {
		typeMap.put("RTF", "java.lang.String");
		typeMap.put("Date", "java.util.Date");
		typeMap.put("Time", "java.util.Date");
		typeMap.put("DateTime", "java.util.Date");
		commonProperties = Arrays.asList(new String[] { "authAdmins",
				"authReaders", "authEditors", "authOtherReaders",
				"authOtherEditors", "authAllReaders", "authAllEditors",
				"authReaderFlag", "authEditorFlag", "authAttCopys",
				"authAttNocopy", "authAttDownloads", "authAttNodownload",
				"authAttPrints", "authAttNoprint", "authTmpReaders",
				"authTmpEditors", "authTmpAttNodownload", "authTmpAttNocopy",
				"authTmpAttNoprint", "authTmpAttPrints", "authTmpAttCopys",
				"authTmpAttDownloads", "sysFlowModel" });
	}

	public void examine(ExamineContext context) throws Exception {
		Class c = context.getCurrentClass();
		String className = c.getName();
		SysDictModel dictModel = SysDataDict.getInstance().getModel(className);
		if (dictModel == null) {
			context.addError("数据字典（" + className + "）未配置");
			return;
		}
		if (StringUtil.isNull(dictModel.getMessageKey()))
			context.addError("数据字典（" + className + "）的messageKey属性未设置");
		else {
			if (StringUtil.isNull(ResourceUtil.getString(dictModel
					.getMessageKey())))
				context.addError("数据字典（" + className + "）的messageKey属性设置错误");
		}
		if (StringUtil.isNull(dictModel.getTable())) {
			context.addError("数据字典（" + className + "）的table属性未配置");
		} else {
			if (dictModel.getTable().length() > 30)
				context.addError("数据字典（" + className + "）的table属性长度超过30个字符");
		}
		if (ISysNotifyModel.class.isAssignableFrom(c)
				&& StringUtil.isNull(dictModel.getUrl()))
			context.addError("数据字典（" + className + "）的url属性未设置");

		// 比对HBM文件
		List dictProperties = new ArrayList();
		dictProperties.addAll(dictModel.getPropertyList());
		HbmClass hbmClass = getHbmClass(c);
		if (hbmClass == null) {
			context.addWarn(className + "对应的Hibernate文件未找到");
		} else {
			if (!ObjectUtil.equals(dictModel.getTable(), hbmClass.getTable()))
				context.addError("数据字典（" + className + "）的table属性跟hbm的配置不一致");
			if (hbmClass.getId() != null
					&& !ObjectUtil.equals(dictModel.getIdProperty()
							.getGenerator().getType(), hbmClass.getId()
							.getGenerator().getType()))
				context.addError("数据字典（" + className + "）的ID类型跟hbm的配置不一致");
			for (int i = 0; i < hbmClass.getProperties().size(); i++) {
				Object p = hbmClass.getProperties().get(i);
				String name = (String) PropertyUtils.getProperty(p, "name");
				SysDictCommonProperty dictProperty = (SysDictCommonProperty) dictModel
						.getPropertyMap().get(name);
				if (dictProperty == null) {
					context.addError("数据字典（" + className + "）的" + name
							+ "字段未设置");
					continue;
				}
				dictProperties.remove(dictProperty);
				checkDictProperty(context, dictProperty, c);
				if (p instanceof HbmBag) {
					if (!(dictProperty instanceof SysDictListProperty)) {
						context.addError("数据字典（" + className + "）的" + name
								+ "字段应该是List类型的字段");
						continue;
					}
					checkTwoObjectProperties(
							context,
							dictProperty,
							p,
							"table:cascade:inverse:orderBy:column:notNull:unique",
							"table:cascade:inverse:orderBy:key.column:key.notNull:key.unique",
							"数据字典（" + className + "）" + name + "字段的",
							"属性跟hbm的配置不一致");
					HbmBag hbmBag = (HbmBag) p;
					if (hbmBag.getOneToMany() != null) {
						checkTwoObjectProperties(context, dictProperty, p,
								"type", "oneToMany.type", "数据字典（" + className
										+ "）" + name + "字段的", "属性跟hbm的配置不一致");
					} else {
						checkTwoObjectProperties(context, dictProperty, p,
								"type:elementColumn",
								"manyToMany.type:manyToMany.column", "数据字典（"
										+ className + "）" + name + "字段的",
								"属性跟hbm的配置不一致");
					}
					if (p instanceof HbmList) {
						checkTwoObjectProperties(context, dictProperty, p,
								"indexColumn", "index.column", "数据字典（"
										+ className + "）" + name + "字段的",
								"属性跟hbm的配置不一致");
					}
				} else if (p instanceof BaseProperty) {
					if (p instanceof HbmProperty) {
						if (!(dictProperty instanceof SysDictSimpleProperty)) {
							context.addError("数据字典（" + className + "）的" + name
									+ "字段应该是简单类型的字段");
							continue;
						}
						checkTwoObjectProperties(context, dictProperty, p,
								"length", "length", "数据字典（" + className + "）"
										+ name + "字段的", "属性跟hbm的配置不一致");
					} else if (p instanceof HbmManyToOne) {
						if (!(dictProperty instanceof SysDictModelProperty)) {
							context.addError("数据字典（" + className + "）的" + name
									+ "字段应该是Model类型的字段");
							continue;
						}
						checkTwoObjectProperties(context, dictProperty, p,
								"cascade", "cascade", "数据字典（" + className + "）"
										+ name + "字段的", "属性跟hbm的配置不一致");
					}
					checkTwoObjectProperties(context, dictProperty, p,
							"column:notNull:unique", "column:notNull:unique",
							"数据字典（" + className + "）" + name + "字段的",
							"属性跟hbm的配置不一致");
				}
			}
		}

		// 检查HBM文件未定义的其他属性
		for (int i = 0; i < dictProperties.size(); i++)
			checkDictProperty(context, (SysDictCommonProperty) dictProperties
					.get(i), c);
	}

	private void checkTwoObjectProperties(ExamineContext context, Object obj1,
			Object obj2, String property1, String property2, String msg1,
			String msg2) throws Exception {
		String[] properties1 = property1.split(":");
		String[] properties2 = property2.split(":");
		for (int i = 0; i < properties1.length; i++) {
			String v1 = BeanUtils.getProperty(obj1, properties1[i]);
			String v2 = BeanUtils.getProperty(obj2, properties2[i]);
			if (StringUtil.isNotNull(v2) && !ObjectUtil.equals(v1, v2))
				context.addError(msg1 + properties1[i] + msg2);
		}
	}

	private void checkDictProperty(ExamineContext context,
			SysDictCommonProperty property, Class c) throws Exception {
		if ("fdId".equals(property.getName()))
			return;
		String className = c.getName();
		String propertyName = property.getName();
		PropertyDescriptor propertyDescriptor = ObjectUtil
				.getPropertyDescriptor(c, property.getName());
		if (propertyDescriptor == null) {
			context.addError("数据字典（" + className + "）" + propertyName
					+ "字段在域模型中不存在");
			return;
		}
		boolean isRight = true;
		// 检查命名规范
		if (StringUtil.isNotNull(property.getColumn())
				&& property.getColumn().length() > 30) {
			context.addError("数据字典（" + className + "）" + propertyName
					+ "字段的column属性长度超过30个字符");
		}
		if (property instanceof SysDictListProperty) {
			SysDictListProperty listProperty = (SysDictListProperty) property;
			if (StringUtil.isNotNull(listProperty.getElementColumn())
					&& listProperty.getElementColumn().length() > 30) {
				context.addError("数据字典（" + className + "）" + propertyName
						+ "字段的elementColumn属性长度超过30个字符");
			}
			if (StringUtil.isNotNull(listProperty.getIndexColumn())
					&& listProperty.getIndexColumn().length() > 30) {
				context.addError("数据字典（" + className + "）" + propertyName
						+ "字段的indexColumn属性长度超过30个字符");
			}
			if (StringUtil.isNotNull(listProperty.getTable())
					&& listProperty.getTable().length() > 30) {
				context.addError("数据字典（" + className + "）" + propertyName
						+ "字段的table属性长度超过30个字符");
			}
		}
		if (!propertyName.startsWith("fd") && !propertyName.startsWith("doc")
				&& !propertyName.startsWith("hbm")
				&& !commonProperties.contains(propertyName)) {
			if (property.getType().startsWith("com.landray.kmss")) {
				if (!propertyName.equals(ModelUtil.getModelTableName(property
						.getType())))
					isRight = false;
			} else {
				isRight = false;
			}
		}
		if (isRight) {
			if (StringUtil.isNotNull(property.getColumn())
					&& !property.getType().startsWith("com.landray.kmss")) {
				String columnName = getPropertyColumnByName(propertyName);
				if (!property.getColumn().equals(columnName))
					context.addWarn("数据字典（" + className + "）" + propertyName
							+ "字段column属性命名不规范，应该为：" + columnName);
			}
		} else {
			context.addWarn("数据字典（" + className + "）" + propertyName
					+ "字段的命名不规范");
		}
		// 检查类型是否正确
		Class type = propertyDescriptor.getPropertyType();
		if (property.getType().startsWith("com.landray.kmss")) {
			if (!List.class.isAssignableFrom(type)
					&& !Map.class.isAssignableFrom(type)) {
				if (type.isInterface()) {
					Class type2 = Class.forName(property.getType());
					if (!type.isAssignableFrom(type2))
						context.addError("数据字典（" + className + "）"
								+ propertyName + "字段的type属性设置错误");
				} else if (!type.getName().equals(property.getType())) {
					context.addError("数据字典（" + className + "）" + propertyName
							+ "字段的type属性设置错误");
				}
			}
		} else {
			String typeName = "java.lang." + property.getType();
			if (!type.getName().equals(typeName)) {
				typeName = (String) typeMap.get(property.getType());
				if (!type.getName().equals(typeName))
					context.addError("数据字典（" + className + "）" + propertyName
							+ "字段的type属性设置错误");
			}
		}
		if (property.getType().startsWith("com.landray.kmss.")) {
			SysDictModel dictModel = SysDataDict.getInstance().getModel(
					property.getType());
			if (dictModel == null) {
				context.addError("数据字典（" + className + "）" + propertyName
						+ "字段引用了" + property.getType() + "，但该类的数据字典未定义");
			} else {
				if (property.isCanRelation() || property.isCanSearch()
						|| property.isCanSubscribe()) {
					// 对于外键，并且可以搜索的属性，需要配置displayProperty
					if (StringUtil.isNull(dictModel.getDisplayProperty()))
						context.addError("数据字典（" + className + "）"
								+ propertyName + "字段（可搜索）引用了"
								+ property.getType()
								+ "，但该类的数据字典的displayProperty未设置");
					// 对于外键，非级联的属性，建议配置dialogJS
					if (StringUtil.isNull(property.getDialogJS())) {
						if (property instanceof SysDictModelProperty) {
							if (!"all-delete-orphan"
									.equals(((SysDictModelProperty) property)
											.getCascade()))
								context.addWarn("数据字典（" + className + "）"
										+ propertyName + "字段的dialogJS属性未设置");
						} else if (property instanceof SysDictListProperty) {
							if (!"all-delete-orphan"
									.equals(((SysDictListProperty) property)
											.getCascade()))
								context.addWarn("数据字典（" + className + "）"
										+ propertyName + "字段的dialogJS属性未设置");
						}
					}
				}
			}
		}
		// 检查中文信息
		if (StringUtil.isNotNull(property.getMessageKey())) {
			if (StringUtil.isNull(ResourceUtil.getString(property
					.getMessageKey())))
				context.addError("数据字典（" + className + "）" + propertyName
						+ "字段的messageKey设置错误");
		} else if (property.isCanDisplay()) {
			context.addError("数据字典（" + className + "）" + propertyName
					+ "字段（可见的）的messageKey未设置");
		}
		// 检查枚举类型
		if (StringUtil.isNotNull(property.getEnumType())) {
			if (EnumerationTypeUtil.newInstance().getColumnEnums().findType(
					property.getEnumType()) == null) {
				context.addError("数据字典（" + className + "）" + propertyName
						+ "字段的enumType属性设置错误");
			}
		}
	}

	private HbmClass getHbmClass(Class c) {
		try {
			String fileName = ExamineRunner.PATH_SRC + "/"
					+ c.getName().replace('.', '/') + ".hbm.xml";
			HbmMapping mapping = HbmMapping.getInstance(fileName);
			List classes = mapping.getClasses();
			for (int i = 0; i < classes.size(); i++) {
				HbmClass cls = (HbmClass) classes.get(i);
				if (c.getName().equals(cls.getName()))
					return cls;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private String getPropertyColumnByName(String propertyName) {
		StringBuffer rtnVal = new StringBuffer();
		for (int i = 0; i < propertyName.length(); i++) {
			char c = propertyName.charAt(i);
			if (c >= 'A' && c <= 'Z') {
				rtnVal.append('_');
				rtnVal.append(String.valueOf(c).toLowerCase());
			} else {
				rtnVal.append(c);
			}
		}
		return rtnVal.toString();
	}
}
