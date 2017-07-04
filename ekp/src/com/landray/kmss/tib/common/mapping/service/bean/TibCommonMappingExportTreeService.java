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
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.dict.SysDictExtendModel;
import com.landray.kmss.sys.metadata.dict.SysDictExtendProperty;
import com.landray.kmss.sys.metadata.dict.SysDictExtendSimpleProperty;
import com.landray.kmss.sys.metadata.dict.SysDictExtendSubTableProperty;
import com.landray.kmss.sys.xform.service.DictLoadService;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author zhangwt
 *         自定义传出参数树,仿照产品中SysFormulaDictVarTree,SysFormDictTreeVarService分别获得数据字典变量
 *         ， 自定义表单扩展变量的逻辑，细节上存可能存在不同
 */
public class TibCommonMappingExportTreeService implements IXMLDataBean {

	private DictLoadService loader;

	/**
	 * @param 数据字典加载类
	 */
	public void setLoader(DictLoadService loader) {
		this.loader = loader;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String modelName = requestInfo.getParameter("modelName");
		String formFileName = requestInfo.getParameter("formFileName");
		String id = requestInfo.getParameter("id");
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>(1);
		Map<String, Object> map;
		String superFieldName = id.replaceAll("\\$", "");
		// 数据字典字段集合
		if (StringUtil.isNull(id)) {// 第一次打开时
			List dictProperties = getDictVarInfo(modelName);
			for (int i = 0; i < dictProperties.size(); i++) {
				SysDictCommonProperty property = (SysDictCommonProperty) dictProperties
						.get(i);
				if (!property.isCanDisplay()) {
					continue;
				}
				String name = property.getName();
				String messageKey = property.getMessageKey();
				String label = ResourceUtil.getString(messageKey,
						requestInfo.getLocale());
				if (StringUtil.isNull(label)) {
					continue;
				}
				map = new HashMap<String, Object>();
				map.put("text", label);
				map.put("value", "$" + name + "$");
				map.put("nodeType", "TEMPLATE");
				rtnList.add(map);
				/**
				 * 判断为TIB则是定制明细表
				 */
				String dialogJS = property.getDialogJS();
				if ("TIB".equals(dialogJS)) {
					// 认定为定制明细表
					// map.put("value", "c_"+ name); 
					map.put("isShowCheckBox", "false");
					map.remove("nodeType");
				}
			}
			// 扩展字段集合
			List<SysDictCommonProperty> extendProperties = getExtendDataFormInfo(formFileName);
			for (int i = 0; i < extendProperties.size(); i++) {
				SysDictCommonProperty p = extendProperties.get(i);
				if (!(p instanceof SysDictExtendProperty))
					continue;
				SysDictExtendProperty property = (SysDictExtendProperty) p;
				if (property instanceof SysDictExtendSubTableProperty) {
					SysDictExtendSubTableProperty subTable = (SysDictExtendSubTableProperty) property;
					map = new HashMap();
					map.put("text", subTable.getLabel());
					map.put("value", subTable.getName() + ".%");// 如果是明细表在value中加个.%进行区别,当单击明细表时用字表id进行取代
					map.put("isShowCheckBox", "false");
					rtnList.add(map);
				} else {
					map = new HashMap();
					map.put("text", property.getLabel());
					map.put("value", "$" + property.getName() + "$");
					map.put("nodeType", "TEMPLATE");
					rtnList.add(map);
				}
			}
		} else if (id.contains(".%")) {// 当点击明细表加号时
			List extendProperties = getExtendDataFormInfo(formFileName);
			for (int i = 0; i < extendProperties.size(); i++) {
				SysDictCommonProperty p = (SysDictCommonProperty) extendProperties
						.get(i);
				if (!(p instanceof SysDictExtendProperty))
					continue;
				SysDictExtendProperty property = (SysDictExtendProperty) p;
				if (property instanceof SysDictExtendSubTableProperty) {
					SysDictExtendSubTableProperty subTable = (SysDictExtendSubTableProperty) property;
					if (subTable.getName().equals(
							id.substring(0, id.indexOf(".%")))) {
						List<SysDictCommonProperty> propertyList = subTable
								.getElementDictExtendModel().getPropertyList();
						SysDictCommonProperty dictProperty = null;
						for (int j = 0; j < propertyList.size(); j++) {
							dictProperty = propertyList.get(j);
							if (!(dictProperty instanceof SysDictExtendSimpleProperty))
								continue;
							SysDictExtendSimpleProperty dictExtendSimpleProperty = (SysDictExtendSimpleProperty) dictProperty;
							map = new HashMap();
							map.put("text", subTable.getLabel() + "."
									+ dictExtendSimpleProperty.getLabel());
							map.put("value", "$" + subTable.getName() + "."
									+ dictExtendSimpleProperty.getName() + "$");
							map.put("nodeType", "TEMPLATE");
							rtnList.add(map);
						}
						break;// 已经找完可终止外层循环
					}
				}
			}
		} else if (isDictTib(modelName, superFieldName)) {
			// 定制明细表特殊处理
			SysDictModel dictModel = SysDataDict.getInstance().getModel(modelName);
			SysDictCommonProperty property = dictModel.getPropertyMap().get(superFieldName);
			if (property != null) {
				String name = property.getName();
				String messageKey = property.getMessageKey();
				String label = ResourceUtil.getString(messageKey, requestInfo.getLocale());
				String type = ModelUtil.getPropertyType(modelName, property.getName());
				if (type.contains("[]")) {
					type = type.replace("[]", "");
				}
				Class<?> clazz = Class.forName(type);
				Field[] fields = clazz.getDeclaredFields();
				for (Field field : fields) {
					String fieldName = field.getName();
					if (!"fdId".equals(fieldName)) {
						String bundle = messageKey.substring(0, messageKey.indexOf(":"));
						String fieldLabel = ResourceUtil.getString(getModelName(clazz) +"."+ fieldName, bundle);
						if (StringUtil.isNotNull(fieldLabel)) {
							String childType = field.getType().getName();
							childType = childType.substring(childType.lastIndexOf(".") + 1);
							Map<String, Object> childNode = new HashMap<String, Object>();
							childNode.put("value", "$"+ name +"."+ fieldName +"$");
							childNode.put("text", label +"."+ fieldLabel);
							childNode.put("nodeType", "TEMPLATE");
							rtnList.add(childNode);
						}
					}
				}
			}
		}
		return rtnList;
	}

	/**
	 * @param extendFilePath
	 * @return 扩展字段集合
	 * @throws Exception
	 */
	private List getExtendDataFormInfo(String extendFilePath) throws Exception {
		List properties = new ArrayList();
		if (extendFilePath.equals("null") || StringUtil.isNull(extendFilePath)) {
			return properties;// 如果为"null"则说明没有配置自定义表单
		}
		SysDictExtendModel dict = loader.loadDictByFileName(extendFilePath);
		properties = dict.getPropertyList();
		return properties;
	}

	/**
	 * @param extendFilePath
	 * @return 数据字典字段集合
	 */
	private List getDictVarInfo(String modelName) {
		SysDictModel model = SysDataDict.getInstance().getModel(modelName);
		List properties = model.getPropertyList();
		return properties;
	}
	
	private String getModelName(Class<?> clazz) {
		String modelName = clazz.getName();
		modelName = modelName.substring(modelName.lastIndexOf('.') + 1);
		return modelName.substring(0, 1).toLowerCase() + modelName.substring(1);
	}

	private boolean isDictTib(String modelName, String fieldName) {
		SysDictModel dictModel = SysDataDict.getInstance().getModel(modelName);
		SysDictCommonProperty pro = dictModel.getPropertyMap().get(fieldName);
		if (pro != null && "TIB".equals(pro.getDialogJS())) {
			return true;
		} else {
			return false;
		}
	}
}
