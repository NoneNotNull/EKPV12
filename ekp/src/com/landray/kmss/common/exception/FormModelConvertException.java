package com.landray.kmss.common.exception;

import com.landray.kmss.util.KmssMessage;

/**
 * Form与Model之间转换过程产生的异常
 * 
 * @author 叶中奇
 */
public class FormModelConvertException extends KmssRuntimeException {
	/**
	 * @param e
	 *            导致该异常的源
	 */
	public FormModelConvertException(Exception e) {
		super(new KmssMessage("error.formModelConvert.unknown"), e);
	}

	/**
	 * @param property
	 *            转换该属性时产生异常
	 */
	public FormModelConvertException(String property) {
		super(new KmssMessage("error.formModelConvert.property", property));
	}

	/**
	 * @param property
	 *            转换该属性时产生异常
	 * @param e
	 *            导致该异常的源
	 */
	public FormModelConvertException(String property, Exception e) {
		super(new KmssMessage("error.formModelConvert.property", property), e);
	}

	/**
	 * 由于属性property的映射信息mapProperty未配置导致的异常
	 * 
	 * @param property
	 * @param mapProperty
	 */
	public FormModelConvertException(String property, String mapProperty) {
		super(new KmssMessage("error.formModelConvert.propertyMapRequest",
				property, mapProperty));
	}
}
