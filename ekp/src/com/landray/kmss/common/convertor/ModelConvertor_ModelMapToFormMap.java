package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将域模型Map转换为Form模型Map，常用于一对多的关系
 * 
 * @author 叶中奇
 * 
 */
public class ModelConvertor_ModelMapToFormMap extends BaseModelConvertor
		implements IModelToFormConvertor {
	private static final Log logger = LogFactory
			.getLog(ModelConvertor_ModelMapToFormMap.class);

	/**
	 * @param tPropertyName
	 *            目标属性名
	 */
	public ModelConvertor_ModelMapToFormMap(String tPropertyName) {
		this.tPropertyName = tPropertyName;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		Map sMap;
		try {
			sMap = (Map) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			sMap = null;
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName() + "的值时中间出现null值");
		}
		Map tMap = (Map) PropertyUtils.getProperty(ctx.getTObject(),
				getTPropertyName());
		if (tMap == null)
			tMap = new HashMap();
		else
			tMap.clear();
		if (sMap != null) {
			Iterator keys = sMap.keySet().iterator();
			while (keys.hasNext()) {
				Object key = keys.next();
				IBaseModel sModel = (IBaseModel) sMap.get(key);
				if (sModel != null)
					tMap.put(key, ctx.getBaseService().convertModelToForm(null,
							sModel, ctx));
			}
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), tMap);
	}

	public ModelConvertor_ModelMapToFormMap setTPropertyName(String propertyName) {
		tPropertyName = propertyName;
		return this;
	}

	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		String sProperty = (String) context.getParameter("sProperty");
		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				fromClass, sProperty);
		if (descriptor == null || descriptor.getReadMethod() == null)
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "无getter方法");
		else if (!Map.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "必须是Map类型");

		descriptor = ObjectUtil.getPropertyDescriptor(toClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(fromClass, "getToFormPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
		else {
			if (!Map.class.isAssignableFrom(descriptor.getPropertyType()))
				context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
						+ tPropertyName + "必须是Map类型");
			try {
				Object obj = PropertyUtils.getProperty(context
						.getParameter("form"), tPropertyName);
				if (obj == null)
					context.addError(fromClass, "getToModelPropertyMap", 1,
							"目标属性" + tPropertyName + "在Form中必须有初值");
				if (!(obj instanceof AutoHashMap))
					context.addError(fromClass, "getToModelPropertyMap", 1,
							"目标属性" + tPropertyName
									+ "在Form中必须初始化为一个AutoHashMap的实体");
			} catch (Exception e) {
				context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
						+ tPropertyName + "无法获取");
			}
		}
	}
}
