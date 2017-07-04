package com.landray.kmss.kms.multidoc.dict;

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
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyReference;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.sys.property.service.ISysPropertyTemplateService;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 流程公式扩展属性列表
 * 
 * @author 郭昌平
 * @version 1.0 2013-01-05
 */
public class KmsMultidocFormulaDictVarTree implements IXMLDataBean {

	public List<Map<String, String>> getDataList(RequestContext requestInfo)
			throws Exception {
		List<Map<String, String>> rtnVal = new ArrayList<Map<String, String>>();
		String modelName = requestInfo.getParameter("modelName");
		String proTemplateId = requestInfo.getParameter("proTemplateId");
		SysDictModel model = SysDataDict.getInstance().getModel(modelName);

		SysDictIdProperty idProperty = model.getIdProperty();
		Map<String, String> idNode = new HashMap<String, String>();
		idNode.put("name", idProperty.getName());
		idNode.put("label", "ID");
		idNode.put("type", idProperty.getType());
		rtnVal.add(idNode);

		List<?> properties = model.getPropertyList();
		for (int i = 0; i < properties.size(); i++) {
			SysDictCommonProperty property = (SysDictCommonProperty) properties
					.get(i);
			if (!property.isCanDisplay()) {
				continue;
			}
			String label = ResourceUtil.getString(property.getMessageKey(),
					requestInfo.getLocale());
			if (StringUtil.isNull(label)) {
				continue;
			}
			Map<String, String> node = new HashMap<String, String>();
			node.put("name", property.getName());
			node.put("label", label);
			node.put("type", ModelUtil.getPropertyType(modelName, property
					.getName()));
			rtnVal.add(node);
		}

		// 获取扩展属性
		if (StringUtil.isNotNull(proTemplateId)) {
			SysPropertyTemplate template = (SysPropertyTemplate) sysPropertyTemplateService
					.findByPrimaryKey(proTemplateId);
			List<SysPropertyReference> referenceList = template
					.getFdReferences();

			for (int i = 0; i < referenceList.size(); i++) {
				SysPropertyDefine define = (SysPropertyDefine) referenceList
						.get(i).getFdDefine();
				Map<String, String> node = new HashMap<String, String>();
				node.put("name", define.getFdStructureName());
				node.put("label", define.getFdName());
				node.put("type", define.getFdType());
				rtnVal.add(node);
			}
		}
		return rtnVal;
	}

	protected ISysPropertyTemplateService sysPropertyTemplateService = null;

	public void setSysPropertyTemplateService(
			ISysPropertyTemplateService sysPropertyTemplateService) {
		this.sysPropertyTemplateService = sysPropertyTemplateService;
	}
}
