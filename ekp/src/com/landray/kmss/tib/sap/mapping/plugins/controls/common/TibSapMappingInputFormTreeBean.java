package com.landray.kmss.tib.sap.mapping.plugins.controls.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.dict.SysDictExtendModel;
import com.landray.kmss.sys.metadata.dict.SysDictExtendProperty;
import com.landray.kmss.sys.metadata.dict.SysDictExtendSimpleProperty;
import com.landray.kmss.sys.metadata.dict.SysDictExtendSubTableProperty;
import com.landray.kmss.sys.xform.service.DictLoadService;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;
/**
 * SAP控件选择数据字典
 * @author qiujh
 *
 */
public class TibSapMappingInputFormTreeBean {
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
		List rtnList = new ArrayList(1);
		Map map;
		// 数据字典字段集合
		if (StringUtil.isNull(id)) {// 第一次打开时
			List dictProperties = getDictVarInfo(modelName);
			for (int i = 0; i < dictProperties.size(); i++) {
				SysDictCommonProperty property = (SysDictCommonProperty) dictProperties.get(i);
				if (!property.isCanDisplay()) {
					continue;
				}
				String label = ResourceUtil.getString(property.getMessageKey(),
						requestInfo.getLocale());
				if (StringUtil.isNull(label)) {
					continue;
				}
				map = new HashMap();
				map.put("text", label);
				map.put("value", "$" + property.getName() + "$");
				map.put("nodeType", "TEMPLATE");
				rtnList.add(map);
			}

			// 扩展字段集合
			List extendProperties = getExtendDataFormInfo(formFileName);
			for (int i = 0; i < extendProperties.size(); i++) {
				SysDictCommonProperty p = (SysDictCommonProperty) extendProperties
						.get(i);
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
}
