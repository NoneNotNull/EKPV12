package com.landray.kmss.tib.common.mapping.service.bean;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.exception.KmssUnExpectFieldException;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataDao;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMetaParse;

public class TibCommonMappingMetaParseImpl implements ITibCommonMappingMetaParse {

	private ISysMetadataParser sysMetadataParser;

	public void setSysMetadataParser(ISysMetadataParser sysMetadataParser) {
		this.sysMetadataParser = sysMetadataParser;
	}
	
	private IExtendDataDao extendDataDao = null;
	
	public void setExtendDataDao(IExtendDataDao extendDataDao) {
		this.extendDataDao = extendDataDao;
	}
	
	/**
	 * 定制明细表的写入（利用反射）
	 */
	public void setCustomizeFieldValue(IBaseModel model,  
			Map<String, List<Map<String, Object>>> bigMap)
			throws Exception {
		SysDictModel dictModel = sysMetadataParser.getDictModel(model);
		String className = model.getClass().getName();
		String setMainModelName = "set"+ className.substring(className.lastIndexOf(".") + 1);
		// 循环出表
		for (String tableName : bigMap.keySet()) {
			SysDictCommonProperty property = dictModel.getPropertyMap().get(tableName);
			String modelName = property.getType();
			List<Map<String, Object>> tableList = bigMap.get(tableName);
			// 循环出每一行
			for (Map<String, Object> rowMap : tableList) {
				IBaseModel customizeModel = (IBaseModel)Class.forName(modelName).newInstance();
				// 设置主Model
				Method mainMethod = customizeModel.getClass().getMethod(setMainModelName, model.getClass());
				mainMethod.invoke(customizeModel, model);
				// 循环出每一列，再进行设值
				for (String fieldName : rowMap.keySet()) {
					Object value = rowMap.get(fieldName);
					// 得到set方法
					String setMethodName = "set"+ toFirstLetterUpperCase(fieldName);
					Method method = customizeModel.getClass().getMethod(setMethodName, value.getClass());
					method.invoke(customizeModel, value);
				}
				extendDataDao.add(customizeModel);
			}
		}
	}

	public void saveModel(IBaseModel model) throws Exception {
		extendDataDao.update(model);
	}

	/**
	 * 首字母转大写
	 * @param str
	 * @return
	 */
	private static String toFirstLetterUpperCase(String str) {
		if (str == null) {
			return str;
		}
		String firstLetter = str.substring(0, 1).toUpperCase();
		return firstLetter + str.substring(1, str.length());
	}
	
	public void setFieldValue(IBaseModel model, String fieldName,
			Object value) throws KmssUnExpectFieldException, Exception {
		sysMetadataParser.setFieldValue(model, (String) fieldName, value);
	}

	public Object getFieldValue(IBaseModel model, String propertyName,
			boolean initDefaultValue) throws KmssUnExpectFieldException,
			Exception {
		return sysMetadataParser.getFieldValue(model, propertyName, initDefaultValue);
	}
}
