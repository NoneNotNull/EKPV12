package com.landray.kmss.common.convertor;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.landray.kmss.code.examine.ExamineContext;

/**
 * 域模型到Form模型转换的特殊属性映射表
 * 
 * @author 叶中奇
 */
public class ModelToFormPropertyMap {
	private Map propertyMap = new ConcurrentHashMap();

	/**
	 * 设置关系映射
	 * 
	 * @param sPropertyName
	 *            源属性名
	 * @param tPropertyName
	 *            目标属性名
	 * @return
	 */
	public ModelToFormPropertyMap put(String sPropertyName, String tPropertyName) {
		propertyMap.put(sPropertyName, tPropertyName);
		return this;
	}

	/**
	 * 设置关系映射
	 * 
	 * @param sPropertyName
	 *            源属性名
	 * @param convertor
	 *            使用的转换器
	 * @return
	 */
	public ModelToFormPropertyMap put(String sPropertyName,
			IModelToFormConvertor convertor) {
		if (convertor != null) {
			propertyMap.put(sPropertyName, convertor);
		} else {
			addNoConvertProperty(sPropertyName);
		}
		return this;
	}

	/**
	 * 设置不转换的属性
	 * 
	 * @param sPropertyName
	 *            源属性名
	 * @return
	 */
	public ModelToFormPropertyMap addNoConvertProperty(String sPropertyName) {
		propertyMap.put(sPropertyName, ModelConvertor_Empty.INSTANCE);
		return this;
	}

	/**
	 * 合并映射关系，多用于继承的域模型
	 * 
	 * @param formToModelPropertyMap
	 *            映射表
	 * @return
	 */
	public ModelToFormPropertyMap putAll(
			ModelToFormPropertyMap modelToFormPropertyMap) {
		propertyMap.putAll(modelToFormPropertyMap.getPropertyMap());
		return this;
	}

	/**
	 * 清空现有的映射表
	 * 
	 * @return
	 */
	public ModelToFormPropertyMap clear() {
		propertyMap.clear();
		return this;
	}

	public Map getPropertyMap() {
		return propertyMap;
	}

	public List getPropertyList() {
		return new ArrayList(propertyMap.keySet());
	}

	public void examine(ExamineContext context, Class modelClass,
			Class formClass) {
		for (Iterator iter = propertyMap.keySet().iterator(); iter.hasNext();) {
			String property = (String) iter.next();
			context.setParameter("sProperty", property);
			Object value = propertyMap.get(property);
			if (value != null) {
				if (value instanceof String)
					value = new ModelConvertor_Common(value.toString());
				IModelToFormConvertor convertor = (IModelToFormConvertor) value;
				convertor.examine(context, modelClass, formClass);
			}
		}
	}
}
