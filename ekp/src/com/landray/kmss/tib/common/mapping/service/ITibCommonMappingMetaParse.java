package com.landray.kmss.tib.common.mapping.service;

import java.util.List;
import java.util.Map;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.metadata.exception.KmssUnExpectFieldException;

public interface ITibCommonMappingMetaParse {

	/**
	 * 设置某个字段的值
	 * 
	 * @param model
	 * @param fieldName
	 * @param value
	 * @throws KmssUnExpectFieldException
	 * @throws Exception
	 */
	public void setFieldValue(IBaseModel model, String fieldName, Object value)
			throws KmssUnExpectFieldException, Exception;
	
	/**
	 * 获取某个字段的值，支持a.b.c的格式
	 * 
	 * @param model
	 * @param propertyName
	 * @param initDefaultValue
	 *            当返回值为null时候，是否需要初始化值
	 * @return
	 * @throws KmssUnExpectFieldException
	 * @throws Exception
	 */
	public Object getFieldValue(IBaseModel model, String propertyName,
			boolean initDefaultValue) throws KmssUnExpectFieldException,
			Exception;
	
	/**
	 * 定制明细表专用
	 * 
	 * @param model
	 * @throws KmssUnExpectFieldException
	 * @throws Exception
	 */
	public void setCustomizeFieldValue(IBaseModel model, 
			Map<String, List<Map<String, Object>>> bigMap)
			throws Exception;

	/**
	 * 保存Model数据
	 * 
	 * @param model
	 * @throws Exception
	 */
	public void saveModel(IBaseModel model) throws Exception;
}
