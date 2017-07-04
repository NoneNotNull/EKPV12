package com.landray.kmss.tib.sap.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.Element;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataModel;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingMetaParse;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.tib.common.mapping.service.spring.TibCommonMappingBaseFuncXmlOperateServiceImpl;
import com.landray.kmss.util.StringUtil;

/**
 * @author zhangwt 函数xml操作方法实现
 */
public class TibSapMappingFuncXmlOperateServiceImp extends
		TibCommonMappingBaseFuncXmlOperateServiceImpl implements
		ITibCommonMappingFuncXmlOperateService {

	private ITibCommonMappingMetaParse tibCommonMappingMetaParse;
	
	public void setTibCommonMappingMetaParse(
			ITibCommonMappingMetaParse tibCommonMappingMetaParse) {
		this.tibCommonMappingMetaParse = tibCommonMappingMetaParse;
	}

	private ITibCommonMappingFuncService tibCommonMappingFuncService;

	public ITibCommonMappingFuncService getTibCommonMappingFuncService() {
		return tibCommonMappingFuncService;
	}

	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	public ITibCommonMappingModuleService getTibCommonMappingModuleService() {
		return tibCommonMappingModuleService;
	}

	public void setTibCommonMappingModuleService(
			ITibCommonMappingModuleService tibCommonMappingModuleService) {
		this.tibCommonMappingModuleService = tibCommonMappingModuleService;
	}

	private ITibCommonMappingModuleService tibCommonMappingModuleService;

	// 按顺序得到指定类型函数
	public List<TibCommonMappingFunc> getFuncList(String fdTemplateId,
			int fdInvokeType, String fdIntegrationType) throws Exception {
		// 防止sql注入以及sql调整
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("tibCommonMappingFunc.fdTemplateId=:fdTemplateId "
						+ "and tibCommonMappingFunc.fdInvokeType =:fdInvokeType "
						+ "and fdIntegrationType=:fdIntegrationType ");
		hqlInfo.setOrderBy("tibCommonMappingFunc.fdOrder asc");
		hqlInfo.setParameter("fdTemplateId", fdTemplateId);
		hqlInfo.setParameter("fdInvokeType", fdInvokeType);
		hqlInfo.setParameter("fdIntegrationType", fdIntegrationType);
		return (List<TibCommonMappingFunc>) tibCommonMappingFuncService
				.findList(hqlInfo);
	}

	// 判断此文档对应的模块是否注册和启用
	public boolean ifRegister(String templateName, String fdType)
			throws Exception {
		return tibCommonMappingModuleService.ifRegister(templateName, fdType);
	}

	// 重载ifRegister方法，根据主文档model的name来判断对应的模块是否注册和启用
	public boolean ifRegister(IBaseModel model, String fdType) throws Exception {
		return tibCommonMappingModuleService.ifRegister(model, fdType);
	}

	// 设置传出参数中table类型的参数,只支持a或a.b格式
	public void setFuncExportTable(Document document, IBaseModel baseModel)
			throws Exception {
		// 用于存放定制明细表信息
		Map<String, List<Map<String, Object>>> bigMap = new HashMap<String, List<Map<String, Object>>>();
		List tables = document.selectNodes("/jco/tables/table[@isin='0' or @isin='0;1']");
		for (int i = 0; i < tables.size(); i++) {
			Element table = (Element) tables.get(i);
			List records = table.elements();
			Element record = (Element) records.get(0);
			List fields = record.elements();
			// 当表格既是传入又是传出的时候
			String writeType = table.attributeValue("writeType");
			String writeKey = table.attributeValue("writeKey");
			Map<Integer, Integer> keyIndexMap = new HashMap<Integer, Integer>();
			Map<String, List<Object>> subOldMap = new HashMap<String, List<Object>>();
			// 当表格既是传入又是传出的时候，即存在写入方式（更新、删除后新增）
			if (StringUtil.isNotNull(writeType)) {
				List<Element> keyFieldList = document.selectNodes("/jco/tables/table[@name='"
						+ table.attributeValue("name")
						+ "']/records/field[@name='" + writeKey + "']");
				String keyEkpid = getEkpid(keyFieldList.get(0).attributeValue("ekpid"));
				if (keyEkpid != null) {
					int fieldIndex = keyEkpid.indexOf(".");
					if (fieldIndex > -1) {
						String firstProperty = keyEkpid.substring(0, fieldIndex);
						// 取出明细表全部旧数据
						IExtendDataModel dataModel = (IExtendDataModel) baseModel;
						List<Map<String, Object>> subValue = (List<Map<String, Object>>) dataModel
								.getExtendDataModelInfo().getModelData().get(firstProperty);
						// 取出当前列的所有数据
						List<Object> keyOldList = (List<Object>) tibCommonMappingMetaParse
								.getFieldValue(baseModel, keyEkpid, true);
						// 循环一列所有行
						for (int kf = 0; kf < keyFieldList.size(); kf++) {
							String keyValue = keyFieldList.get(kf).getText();
							for (int ko = 0; ko < keyOldList.size(); ko++) {
								// 相同
								if (keyValue.equals(keyOldList.get(ko))) {
									// 表格是更新模式
									if ("1".equals(writeType)) {
										// 把需要修改的行的映射关系放入map
										keyIndexMap.put(kf, ko);
									} else {
										// 删除后新增模式，整行删除
										subValue.remove(ko);
									}
									// 找到了比较的，就不再进行里面循环了
									break;
								} 
							}
						}
						// 删除后新增，必须先做删除后保存操作
						if ("2".equals(writeType)) {
							tibCommonMappingMetaParse.saveModel(baseModel);
						}
						// 转换旧数据，将旧数据从list<map>转换成map<string, list>
						for (Map<String, Object> subMap : subValue) {
							for (String subKey : subMap.keySet()) {
								String oldEkpid = firstProperty +"."+ subKey;
								if (subOldMap.containsKey(oldEkpid)) {
									List<Object> subOldList = subOldMap.get(oldEkpid);
									subOldList.add(subMap.get(subKey));
								} else {
									List<Object> subOldList = new ArrayList<Object>();
									subOldList.add(subMap.get(subKey));
									subOldMap.put(oldEkpid, subOldList);
								}
							}
						}
					}
				}
			}
			// 遍历所有列，进行新增
			for (int j = 0; j < fields.size(); j++) {
				Element field = (Element) fields.get(j);
				String fieldName = field.attributeValue("name");
				List<Element> sameFieldList = document
						.selectNodes("/jco/tables/table[@name='"
								+ table.attributeValue("name")
								+ "']/records/field[@name='"
								+ fieldName + "']");
				String ekpid = getEkpid(field.attributeValue("ekpid"));
				if (ekpid == null)
					continue;
				int fieldIndex = ekpid.indexOf(".");
				if (fieldIndex > -1) {
					String supFieldName = ekpid.substring(0, fieldIndex);
					String subFieldName = ekpid.substring(fieldIndex + 1);
					// className的截取
					String className = baseModel.getClass().getName();
					int index = className.indexOf("$");
					if (index != -1) {
						className = className.substring(0, index);
					}
					// 判断是否是定制明细表
					boolean isDictTib = isDictTib(className, supFieldName);
					if (isDictTib) {
						// set 定制明细表信息
						List<Map<String, Object>> tableList = bigMap.get(supFieldName);
						if (tableList == null) {
							// 第一次加入则新建一个
							tableList = new ArrayList<Map<String, Object>>();
							bigMap.put(supFieldName, tableList);
						}
						for (int f = 0, lenF = sameFieldList.size(); f < lenF; f++) {
							String fieldValue = sameFieldList.get(f).getText();
							if (tableList.size() > f) {
								Map<String, Object> cellMap = tableList.get(f);
								cellMap.put(subFieldName, fieldValue);
							} else {
								Map<String, Object> cellMap = new HashMap<String, Object>();
								cellMap.put(subFieldName, fieldValue);
								tableList.add(cellMap);
							}
						}
					} else {
						// 自定义表单明细表
						List<String> fieldValueList = getSameFieldText(sameFieldList);
						// 取出原有列值
						List<Object> oldValueList = subOldMap.get(ekpid);
						// 表格为更新
						if (StringUtil.isNotNull(writeType) && "1".equals(writeType)) {
							List<String> removeList = new ArrayList<String>();
							// 遍历根据Key相同而映射的值
							for (int kf : keyIndexMap.keySet()) {
								int ko = keyIndexMap.get(kf);
								// 获取新数据的值
								String keyFieldValue = fieldValueList.get(kf);
								// 移除老数据，加入新数据
								oldValueList.remove(ko);
								oldValueList.add(ko, keyFieldValue);
								// 保存需要移除的数据
								removeList.add(keyFieldValue);
							}
							// 移除数据
							fieldValueList.removeAll(removeList);
						}
						// 在原有数据上，填充新数据
						oldValueList.addAll(fieldValueList);
						// 明细表设值
						this.tibCommonMappingMetaParse.setFieldValue(baseModel, ekpid,
								oldValueList);
					}
				} else {
					this.tibCommonMappingMetaParse.setFieldValue(baseModel, ekpid,
							getSameFieldText(sameFieldList).get(0));
				}
			}
			// 清空
			keyIndexMap.clear();
		}
		this.tibCommonMappingMetaParse.setCustomizeFieldValue(baseModel, bigMap);
	}

	// 设置函数xml传出参数field内容或者structure下的field
	public void setFuncExportXml(Document document, IBaseModel mainModel)
			throws Exception {
		Element element;
		List<Element> fields = document
				.selectNodes("/jco/export/field|/jco/export/structure/field");
		for (int i = 0; i < fields.size(); i++) {
			element = fields.get(i);
			String ekpId = getEkpid(element.attributeValue("ekpid"));
			if (ekpId == null)
				continue;
			tibCommonMappingMetaParse
					.setFieldValue(mainModel, ekpId, element.getText());
		}
	}

	// 设置传入参数table类型参数field内容
	/***************************************************************************
	 * 注意row0的field中既有数据也有影射信息 基于表单中的明细表和表参数是一致的包括行数是一致的，只是有些字段可能映射的是非明细表中的字段
	 * 两种处理逻辑：1.映射的是自定义表单中明细表的字段，结果形如$a
	 * .b$,公式解析后得到的是list;2.映射的是非明细表的字段形如$a$,得到的是单一数据;
	 **************************************************************************/
	public void setFuncImportTableByFormula(Document document,
			FormulaParser parser) throws Exception {
		Element table;
		Element record;
		Element firstRecordClone;
		Element recordClone;
		List<Element> tables;
		List<Element> fields;
		List<Element> records;
		// 得到所有的传入参数table
		tables = document.selectNodes("/jco/tables/table[@isin='1']");
		for (int i = 0; i < tables.size(); i++) {
			table = tables.get(i);
			records = table.elements();
			record = records.get(0);// 得到初始的的第一个record 0
			fields = record.elements();
			Map fieldMap = getFieldMap(fields, parser);
			firstRecordClone = (Element) record.clone();// 先把第一个record进行clone
			table.remove(record);// 然后移除第一个record
			Object length = fieldMap.get("importRecodsLength");
			// 特殊情况，table中的field都映射非明细表字段，既只有一行记录,将importRecodsLength设置为1
			int importRecodsLength = (length == null ? 1 : (Integer) length);
			for (int j = 0; j < importRecodsLength; j++) {
				recordClone = (Element) firstRecordClone.clone();
				recordClone.setAttributeValue("row", String.valueOf(j));// 设置record的row
				fields = recordClone.elements();
				for (int z = 0; z < fields.size(); z++) {
					Element field = fields.get(z);
					Object fieldValue = fieldMap.get(field
							.attributeValue("name"));
					if (fieldValue instanceof List) {// 如果是明细表list类型的，取得对应行的字段
						Object text = ((List) fieldValue).get(j);
						if (text == null)
							continue;
						field.setText(text.toString());
					} else {
						field.setText(String.valueOf(fieldValue));// 如果是基本类型的，直接取得，每一行这个字段都是一样的
					}
				}
				table.add(recordClone);// 在table中加入此行
			}
			table.setAttributeValue("rows", String.valueOf(importRecodsLength));// 设置table的rows
		}
	}

	// 设置函数xml传入参数field内容或者structure下的field
	public void setFuncImportXmlByFormula(Document document,
			FormulaParser parser) throws Exception {
		List<Element> fields = document
				.selectNodes("/jco/import/field|/jco/import/structure/field");
		Element element;
		for (int i = 0; i < fields.size(); i++) {
			element = fields.get(i);
			String value = (String) parser.parseValueScript(filter(element
					.attributeValue("ekpid")), "String");
			element.setText(StringUtil.isNull(value) || value.equals("[]") ? ""
					: value);// 对于xml的参数来说都是string,sap服务器会解析
		}
	}

	@Deprecated
	public void setInputParamXmlByFormula(List<Element> nodeList,
			FormulaParser parser) throws Exception {
	}

	@Deprecated
	public void setOutputParamXml(List<Element> nodeList, IBaseModel mainModel)
			throws Exception {
	}

	public void businessException(Document document,
			TibCommonMappingFunc tibCommonMappingFunc, IBaseModel mainModel)
			throws Exception {
	}

	public void programException(Exception e,
			TibCommonMappingFuncExt exProgram, IBaseModel mainModel) {
	}

	public void setInputInfo(NodeList nodeList, FormulaParser parser) {
	}

	public boolean setOutputInfo(NodeList nodeList, FormulaParser parser,
			IBaseModel mainModel, boolean flag) {
		return false;
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
