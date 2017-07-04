package com.landray.kmss.tib.common.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;



public class DomUtil {
	
	private static Transformer trans = null;
	
	static {
		try {
			trans = TransformerFactory.newInstance().newTransformer();
			// 设置编码
			trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			trans.setOutputProperty(OutputKeys.INDENT, "yes");
			trans.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS, "yes");
			trans.setOutputProperty(OutputKeys.VERSION, "1.0");
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		} catch (TransformerFactoryConfigurationError e) {
			e.printStackTrace();
		}
		
	}
	
	private static DocumentBuilder builder;
	
	private static DocumentBuilder getBuilderInstance() throws ParserConfigurationException {
		if (builder == null) {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			builder = factory.newDocumentBuilder();
		}
		return builder;
	}
	
	/**
	 * 创建一个Document
	 * @return
	 * @throws ParserConfigurationException
	 */
	public static Document initDocument() throws ParserConfigurationException {
		return getBuilderInstance().newDocument();
	}
	
	/**
	 * DOM读取文件
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static Document fileToDom(File file) throws Exception {
		Document doc = null;
		BufferedReader reader = null;
		try {
			reader = FileUtil.getBufferedReader(file, "UTF-8");
			InputSource is = new InputSource(reader); 
			DocumentBuilder builder = getBuilderInstance();
			doc = builder.parse(is);
		} finally {
			if (reader != null) {
				reader.close();
			}
			
		}
		return doc;
	}
	
	/**
	 * DOM写入文件
	 * @param doc			dom
	 * @param file			文件
	 * @param append		是否追加内容
	 * @throws Exception
	 */
	public static void domToFile(Document doc, File file, boolean append) throws Exception {
		BufferedWriter bw = null;
		try {
			bw = FileUtil.getBufferedWriter(file, "UTF-8", append);
			// 把结果放进字符串输出流，再把DOM信息和结果放入Transformer
			Result result = new StreamResult(bw);
			trans.transform(new DOMSource(doc), result);
		} finally {
			if (bw != null) {
				bw.close();
			}
		}
	}
	
	/**
	 * 字符串转DOM
	 * @param xmlStr
	 * @return
	 * @throws Exception
	 */
	public static Document stringToDoc(String xmlStr) throws Exception {   
        StringReader sr = new StringReader(xmlStr);   
        InputSource is = new InputSource(sr);   
        is.setEncoding("UTF-8");
        DocumentBuilder builder = getBuilderInstance();
        Document doc = builder.parse(is);   
        return doc;
	}
	
	/**
	 * DOM转字符串
	 * @param doc
	 * @return
	 * @throws TransformerFactoryConfigurationError
	 * @throws TransformerException
	 */
	public static String DocToString(Document doc) 
			throws TransformerFactoryConfigurationError, TransformerException {
		StringWriter writer = new StringWriter();
		// 把结果放进字符串输出流，再把DOM信息和结果放入Transformer
		Result result = new StreamResult(writer);
		trans.transform(new DOMSource(doc), result);
		String rtnStr = writer.toString();
		return rtnStr;
	}
	
	/**
	 * 根据XPath选取节点
	 * @param nodeXPath
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static NodeList selectNode(String nodeXPath, Object source) 
			throws XPathExpressionException {
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodeList = (NodeList) xpath.evaluate(nodeXPath, source, XPathConstants.NODESET);
		return nodeList;
	}
	
	/**
	 * 根据XPath选取节点列表
	 * @param nodeXPath
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static List<Element> selectEleList(String nodeXPath, 
			Object source) throws XPathExpressionException {
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
	 * xpath选取节点
	 * @param nodeXPath
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static Element selectEle(String nodeXPath, 
			Object source) throws XPathExpressionException {
		List<Element> eleList = selectEleList(nodeXPath, source);
		if (eleList != null && eleList.size() > 0) {
			return eleList.get(0);
		}
		return null;
	}
	
	public static String getNodeAttrValue(Node node, String attrName) throws Exception {
		Node attrNode = node.getAttributes().getNamedItem(attrName);
		return attrNode.getNodeValue();
	}
	
}
