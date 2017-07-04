package com.landray.kmss.tib.sap.mapping.plugins.controls.list.util;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.json.JSONException;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.landray.kmss.util.StringUtil;

public class ControlXmlDataParseUtil {
	
	/**
	 * 初始化Doc
	 * @return
	 * @throws ParserConfigurationException
	 */
	public static Document initDocument() throws ParserConfigurationException {
        DocumentBuilderFactory factory = DocumentBuilderFactory
                .newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.newDocument();
    }

	/**
	 * 根据XPath选取节点
	 * @param nodeXPath
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static NodeList selectNode(String nodeXPath, Object source) throws XPathExpressionException {
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodeList = (NodeList) xpath.evaluate(nodeXPath, source, XPathConstants.NODESET);
		return nodeList;
	}
	
	/**
	 * 根据XPath选取节点
	 * @param nodeXPath
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static List<Element> selectElement(String nodeXPath, Object source) throws XPathExpressionException {
		List<Element> eleList = new ArrayList<Element>();
		NodeList nodeList = selectNode(nodeXPath, source);
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node node = nodeList.item(i);
			if (Node.ELEMENT_NODE == node.getNodeType()) {
				eleList.add((Element)node);
			}
		}
		return eleList;
	}
	
	/**
	 * 节点对象转XML
	 * @param doc
	 * @return
	 * @throws TransformerFactoryConfigurationError
	 * @throws TransformerException
	 */
	public static String DocToString(Node doc) 
			throws TransformerFactoryConfigurationError, TransformerException {
		Transformer trans = TransformerFactory.newInstance().newTransformer();
		// 设置编码
		trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		trans.setOutputProperty(OutputKeys.INDENT, "yes");
		trans.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS, "yes");
		trans.setOutputProperty(OutputKeys.VERSION, "1.0");
		StringWriter writer = new StringWriter();
		// 把结果放进字符串输出流，再把DOM信息和结果放入Transformer
		Result result = new StreamResult(writer);
		trans.transform(new DOMSource(doc), result);
		String rtnStr = writer.toString();
		return rtnStr;
	}
	
	public static Element getElement(Document document, 
			String fdNodeName, String fdNodeContent, String fdAttrJson) throws JSONException {
		Element element = document.createElement(fdNodeName);
		element.setTextContent(fdNodeContent);
		if (StringUtil.isNotNull(fdAttrJson)) {
			JSONObject jsonObj = (JSONObject) JSONValue.parse(fdAttrJson);//new JSONObject(fdAttrJson);
			for (Iterator<String> it = jsonObj.keySet().iterator(); it.hasNext();) {
				String key = it.next();
				element.setAttribute(key, (String) jsonObj.get(key));
			}
		}
		return element;
	}
	
	public static Document stringToDoc(String xmlStr) throws Exception {
		// 字符串转XML DOM
		StringReader sr = new StringReader(xmlStr);
		InputSource is = new InputSource(sr);
		is.setEncoding("UTF-8");
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document doc = builder.parse(is);
		return doc;
	}

	/**
	 * 查找该节点中的属性
	 * @param node   当前节点
	 * @param name   属性名称
	 * @return
	 */
	public static String findAttrValue(Node node, String attrName) {
		NamedNodeMap namedNodeMap = node.getAttributes();
		Node attrNode = namedNodeMap.getNamedItem(attrName);
		String nodeValue = "";
		if (attrNode != null) {
			nodeValue = attrNode.getNodeValue();
		}
		return nodeValue;
	}
}

