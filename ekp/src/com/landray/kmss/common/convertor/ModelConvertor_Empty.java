package com.landray.kmss.common.convertor;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.code.examine.ExamineContext;

/**
 * Model的空转换器，常用于属性不执行转换
 * 
 * @author 缪贵荣
 * 
 */
public class ModelConvertor_Empty implements IModelToFormConvertor {

	public static final IModelToFormConvertor INSTANCE = new ModelConvertor_Empty();

	public String getTPropertyName() {
		return StringUtils.EMPTY;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		// do nothing
	}

	@SuppressWarnings("unchecked")
	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		// do nothing
	}

}
