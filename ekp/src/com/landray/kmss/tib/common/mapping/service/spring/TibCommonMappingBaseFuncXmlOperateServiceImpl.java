package com.landray.kmss.tib.common.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Element;

import com.landray.kmss.sys.formula.parser.FormulaParser;
import com.landray.kmss.util.StringUtil;

/**
 * 基础Erp xml数据操作基类,包含数据操作的工具
 * date :2012-12-12 上午09:31:27
 */
public class TibCommonMappingBaseFuncXmlOperateServiceImpl {

	/**
	 * 得到相同field的text
	 * @param sameFieldList 相同名称的field
	 * @return
	 */
	protected List<String> getSameFieldText(List<Element> sameFieldList) {
		List<String> sameFieldTextList = new ArrayList<String>();
		for (int i = 0; i < sameFieldList.size(); i++) {
			sameFieldTextList.add(sameFieldList.get(i).getText());
		}
		return sameFieldTextList;
	}


	/**
	 * 去除ekpid$符号,ekpid原格式为$a$或$a.b$;将转义的&quot;还原为"。
	 * @param ekpid
	 * @return
	 */
	protected String getEkpid(String ekpid) {
		if (StringUtil.isNull(ekpid))
			return null;
		int last = ekpid.lastIndexOf("$");
		ekpid = ekpid.substring(1, last);
		return ekpid;
	}


	/**
	 * 将转义的&quot;还原为"
	 * @param str
	 * @return
	 */
	protected String filter(String str) {
		if (StringUtil.isNull(str))
			return null;
		return str.replace("&quot;", "\"");
	}

	
	/**
	 *用公式定义器对field进行解析，得到的fieldValue 可能是基本类型值，也有可能是明细表字段的list
	 *如果传入的ekpid是$a.b$格式的得到的是明细表list
	 * @param fields
	 * @param parser
	 * @return
	 * @throws Exception
	 */
	protected Map getFieldMap(List<Element> fields, FormulaParser parser)
			throws Exception {
		Map fieldMap = new HashMap(1);
		Element field;
		int importRecodsLength;
		boolean tag = false;
		for (int i = 0; i < fields.size(); i++) {
			field = fields.get(i);
			Object fieldValue = parser.parseValueScript(filter(field
					.attributeValue("ekpid")));
			fieldValue = fieldValue == null ? "" : fieldValue;// 有些传入参数没有配置对应的表单字段，为null需要转化为"";
			if (tag == false && fieldValue instanceof List) {
				importRecodsLength = ((List) fieldValue).size();// 通过得到某列数据的长度得到records的长度
				fieldMap.put("importRecodsLength", importRecodsLength);// 放进map中用于for循环，这个变量应该不会和bapi中的有重复
				tag = true;// 得到长度后把这个标志变为true,防止重复执行
			}
			// 在一个records中field的name是不一样的
			fieldMap.put(field.attributeValue("name"), fieldValue);
		}
		return fieldMap;
	}

}
