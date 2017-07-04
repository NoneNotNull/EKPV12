/**
 * 
 */
package com.landray.kmss.tib.soap.mapping.service.spring;

import net.sf.json.JSONObject;

import org.w3c.dom.Document;

import com.landray.kmss.tib.sys.core.util.stax.JsonXmlSerializer;
import com.landray.kmss.tib.sys.core.util.stax.StaxWriterUtil;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * @author 邱建华
 * @version 1.0 2012-12-29
 */
public class TibSoapMappingFormulaDefinition {

	/**
	 * 用于公式定义器
	 * 
	 * @param Func_Name
	 *            函数名称
	 * @param Request_Content
	 *            采用的JSON数据结构在项目文件中有定义
	 * @return
	 * @throws Exception
	 */
	public static Document soapFuncResult(String Func_Name,
			String Request_Content) throws Exception {
		String requestXml = jsonToXml("{web:" +Request_Content +"}");
		System.out.println("requestXml=" + requestXml);
		ITibSysSoap soapui = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
		String resultXml = soapui.funcNameAndContentToOutput(Func_Name,
				requestXml);
		Document doc = HeaderOperation.stringToDoc(resultXml);
		return doc;
	}

	private static String jsonToXml(String jsonStr) throws Exception {
		JSONObject json = JSONObject.fromObject(jsonStr);
		StaxWriterUtil staxUtil = new StaxWriterUtil();
		staxUtil.init();
		staxUtil.startDocument();
		JsonXmlSerializer.parseXml(json, staxUtil);
		staxUtil.endAllElement();
		staxUtil.endDocument();
		return staxUtil.getStringWriter().toString();
	}

//	private static void parseXml(JSONObject jsonInfo, StaxWriterUtil staxWriter)
//			throws Exception {
//		for (Iterator<String> iterator = jsonInfo.keys(); iterator.hasNext();) {
//			String key = iterator.next();
//			Object result = (Object) jsonInfo.get(key);
//			if (result instanceof JSONObject) {
//				JSONObject n_json = (JSONObject) result;
//				StaxElement st = new StaxElement(key, null, null);
//				staxWriter.addElement(st);
//				parseXml(n_json, staxWriter);
//				staxWriter.endElement();
//			} else if (result instanceof JSONArray) {
//				JSONArray n_array = (JSONArray) result;
//				StaxElement st = new StaxElement(key, null, null);
//				staxWriter.addElement(st);
//				for (Iterator<JSONObject> n_it = n_array.iterator(); n_it
//						.hasNext();) {
//					JSONObject array_field = n_it.next();
//					parseXml(array_field, staxWriter);
//				}
//				staxWriter.endElement();
//			} else {
//				StaxElement st = new StaxElement(key, (String) result, null);
//				staxWriter.addElement(st);
//				staxWriter.endElement();
//			}
//		}
//	}

	public static void main(String[] args) throws Exception {
		// String json =
		// "{\"Input\":{\"soapenv:Envelope\":{\"soapenv:Body\":{\"web:wsTest\":"
		// +
		// "{\"arg0\":{\"arrStr\":\"1111\"}}}}}}";
		String json = "{\"Input\":{\"soap:Envelope\":{\"soap:Body\":{\"web:getMobileCodeInfo\":{\"web:mobileCode\":\"18988772113\"}}}}}";
		soapFuncResult("手机号归属地函数", json);
		// String json =
		// "{\"Input\":{\"soapenv:Envelope\":{\"soapenv:Body\":{\"web:wsTest\":"
		// +
		// "{\"arg0\":{\"arrStr\":\"1111\"}}}}}}";
		// $执行SoapUI$("httpEkp函数",json)
	}
}
