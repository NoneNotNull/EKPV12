package com.landray.kmss.tib.common.mapping.service.bean;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictIdProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class TibCommonMappingDictVarTree implements IXMLDataBean{

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, Object>> rtnVal = new ArrayList<Map<String, Object>>();
		String modelName = requestInfo.getParameter("modelName");
		SysDictModel model = SysDataDict.getInstance().getModel(modelName);

		SysDictIdProperty idProperty = model.getIdProperty();
		Map<String, Object> idNode = new HashMap<String, Object>();
		idNode.put("name", idProperty.getName());
		idNode.put("label", "ID");
		idNode.put("type", idProperty.getType());
		rtnVal.add(idNode);

		List<SysDictCommonProperty> properties = model.getPropertyList();
		for (int i = 0; i < properties.size(); i++) {
			SysDictCommonProperty property = properties.get(i);
			if (!property.isCanDisplay()) {
				continue;
			}
			String messageKey = property.getMessageKey();
			String label = ResourceUtil.getString(messageKey, requestInfo.getLocale());
			if (StringUtil.isNull(label)) {
				continue;
			}
			String name = property.getName();
			String type = ModelUtil.getPropertyType(modelName, property.getName());
			String dialogJS = property.getDialogJS();
			Map<String, Object> node = new HashMap<String, Object>();
			node.put("name", name);
			node.put("label", label);
			node.put("type", type);
			rtnVal.add(node);
			/**
			 * 判断为TIB则是定制明细表
			 */
			if ("TIB".equals(dialogJS)) {
				if (type.contains("[]")) {
					type = type.replace("[]", "");
				}
				Class<?> clazz = Class.forName(type);
				Field[] fields = clazz.getDeclaredFields();
				for (Field field : fields) {
					String fieldName = field.getName();
					if (!"fdId".equals(fieldName)) {
						// 认定为定制明细表
						node.put("type", "java.util.List");
						String bundle = messageKey.substring(0, messageKey.indexOf(":"));
						String fieldLabel = ResourceUtil.getString(getModelName(clazz) +"."+ fieldName, bundle);
						if (StringUtil.isNotNull(fieldLabel)) {
							String childType = field.getType().getName();
							childType = childType.substring(childType.lastIndexOf(".") + 1);
							Map<String, Object> childNode = new HashMap<String, Object>();
							childNode.put("name", name +"."+ fieldName);
							childNode.put("label", label +"."+ fieldLabel);
							childNode.put("type", childType +"[]");
							rtnVal.add(childNode);
						}
						
					}
				}
			}
		}
		return rtnVal;
	}
	
	private String getModelName(Class<?> clazz) {
		String modelName = clazz.getName();
		modelName = modelName.substring(modelName.lastIndexOf('.') + 1);
		return modelName.substring(0, 1).toLowerCase() + modelName.substring(1);
	}
	
}
