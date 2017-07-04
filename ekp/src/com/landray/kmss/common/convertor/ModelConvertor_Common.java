package com.landray.kmss.common.convertor;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.util.DateUtil;

/**
 * 将域模型的简单属性转换为Form模型的属性，常用于普通类型的转换
 * 
 * @author 叶中奇
 */
public class ModelConvertor_Common extends BaseModelConvertor implements
		IModelToFormConvertor {
	private static final Log logger = LogFactory
			.getLog(ModelConvertor_Common.class);

	// 设置缓存，内存存储100个对象，30分钟后无效，1分钟后不用则放磁盘
	private static KmssCache cache = new KmssCache(ModelConvertor_Common.class,
			100, true, 1800, 60);

	private static List<Class<?>> cacheClassList = new ArrayList<Class<?>>();

	/**
	 * 添加缓存类
	 * 
	 * @param cls
	 */
	public static void addCacheClass(Class<?> cls) {
		if (!cacheClassList.contains(cls))
			cacheClassList.add(cls);
	}

	private String dateTimeType;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 */
	public ModelConvertor_Common(String tPropertyName) {
		this.tPropertyName = tPropertyName;
	}

	@SuppressWarnings("unchecked")
	public void excute(ConvertorContext ctx) throws Exception {
		Object value;
		String sPropertyName = ctx.getSPropertyName();
		Object sObject = ctx.getSObject();
		int index = sPropertyName.lastIndexOf('.');
		if (index == -1 || sPropertyName.endsWith(".fdId")) {
			// 直接读取数据
			value = getProperty(sObject, sPropertyName);
		} else {
			// 以docCreator.fdName样例注释
			// 读取属性名，如：docCreator
			String property = sPropertyName.substring(0, index);
			value = getProperty(sObject, property);
			if (value != null) {
				// 判断是否采用缓存
				Class cacheClass = null;
				for (Class cls : cacheClassList) {
					if (cls.isAssignableFrom(value.getClass())
							&& !cls.isAssignableFrom(sObject.getClass())) {
						// cls.isAssignableFrom(obj.getClass())，如：判断docCreator属于SysOrgElement类型
						// !cls.isAssignableFrom(sObject.getClass())，如：判断主文档不是属于SysOrgElement类型，也就是不是自关联的类型
						// ----注意：比如组织架构的父部门是自关联的类型，在维护组织架构的时候经常会修改一些值，这使用用缓存就会产生错觉
						cacheClass = cls;
						break;
					}
				}
				// 读取最后的属性
				property = sPropertyName.substring(index + 1);
				if (cacheClass == null || !(value instanceof IBaseModel)) {
					// 不用缓存
					value = getProperty(value, property);
				} else {
					// 使用缓存
					IBaseModel model = (IBaseModel) value;
					String key = cacheClass.getName() + "#" + model.getFdId()
							+ "#" + property;
					Object valueInCache = cache.get(key);
					if (valueInCache == null) {
						value = getProperty(value, property);
						cache.put(key, value == null ? "" : value);
						if (logger.isDebugEnabled())
							logger.debug("写入缓存，key=" + key);
					} else {
						value = valueInCache;
						if (logger.isDebugEnabled())
							logger.debug("从缓存中读取，key=" + key);
					}
				}
			}
		}
		if (value != null && value instanceof Date) {
			// 日期类型，转换格式
			if (PropertyUtils.getPropertyType(ctx.getTObject(),
					getTPropertyName()).isAssignableFrom(String.class))
				value = DateUtil.convertDateToString((Date) value,
						getDateTimeType(), ctx.getRequestContext().getLocale());
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), value);
	}

	private Object getProperty(Object bean, String property) throws Exception {
		try {
			return PropertyUtils.getProperty(bean, property);
		} catch (NestedNullException e) {
			return null;
		}
	}

	public String getDateTimeType() {
		return dateTimeType;
	}

	/**
	 * 设置日期的转换格式，为DateUtil中的常量
	 * 
	 * @param dateTimeType
	 * @return
	 */
	public ModelConvertor_Common setDateTimeType(String dateTimeType) {
		this.dateTimeType = dateTimeType;
		return this;
	}

	public ModelConvertor_Common setTPropertyName(String propertyName) {
		tPropertyName = propertyName;
		return this;
	}
}
