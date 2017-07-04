package com.landray.kmss.tib.sys.core.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.xerces.dom.AttrImpl;
import org.apache.xerces.dom.DocumentImpl;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.sun.org.apache.xerces.internal.util.DOMUtil;

public class DOMHelper {
	
	/**
	 * 判断是否有&特殊字符，然后替换
	 * @author guoyp
	 * @param xml
	 * @return
	 */
	private static String replaceSpecialChar(String xml){
		if(xml.indexOf("&") != -1){
			xml = xml.replaceAll("&", "&amp;");
		}
		return xml;
	}

	/**
	 * 字符串转w3c dom
	 * 
	 * @param xmlstr
	 * @return Document
	 * @throws Exception 
	 */
	public static Document parseXmlString(String xmlstr) throws Exception {
		//过滤&特殊字符
		xmlstr = replaceSpecialChar(xmlstr);
		StringReader sr = new StringReader(xmlstr);
		InputSource is = new InputSource(sr);
		is.setEncoding("UTF-8");
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.parse(is);
		return doc;
	}
	
	
	public static Document parseXmlStream(InputStream stream) {
		try {
			InputSource is = new InputSource(stream);
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(is);
			return doc;
		} catch (IOException e1) {
			e1.printStackTrace();
			return null;
		} catch (ParserConfigurationException e2) {
			e2.printStackTrace();
			return null;
		} catch (SAXException e3) {
			e3.printStackTrace();
			return null;
		}
	}
	
	public static Document Node2Document(Node node) throws Exception{
		if(node!=null){
			String nodeStr=DOMHelper.nodeToString(node, true);
			Document doc=DOMHelper.parseXmlString(nodeStr);
			return doc;	
			
		}
		else{
			return null;
		}
	}
	

	public static Node getElementNode(NodeList nodelist, int index) {
		int curindex = 0;
		for (int i = 0, len = nodelist.getLength(); i < len; i++) {
			Node curNode = nodelist.item(i);
			if (curNode.getNodeType() == Node.ELEMENT_NODE) {
				if (curindex == index) {
					return curNode;
				} else if (curindex > index) {
					return null;
				}
			}
		}
		return null;
	}

	public static String nodeToString(Node node) // 修改过
			throws TransformerFactoryConfigurationError, TransformerException {
		Transformer trans = TransformerFactory.newInstance().newTransformer();
		// 设置编码
		trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		trans.setOutputProperty(OutputKeys.INDENT, "yes");
		trans.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS, "yes");
		StringWriter writer = new StringWriter();
		// 把结果放进字符串输出流，再把DOM信息和结果放入Transformer
		Result result = new StreamResult(writer);
		trans.transform(new DOMSource(node), result);
		String rtnStr = writer.toString();
		return rtnStr;
	}
	
	public static String nodeToString(Node node,boolean hasTitle) throws TransformerFactoryConfigurationError, TransformerException{
		String result=nodeToString(node);
		if(!hasTitle){
			return result.replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
		}
		return result;
		
	}

	public static Node findCommentNode(Node curNode) {

		if (curNode != null) {
			Node preNode = curNode.getPreviousSibling();
			// 上一个节点就是尽头
			if (preNode == null) {
				return null;
			} else if (preNode.getNodeType() == Node.ELEMENT_NODE) {
				return null;
			} else if (preNode.getNodeType() == Node.COMMENT_NODE) {
				return preNode;
			} else {
				return findCommentNode(preNode);
			}
		}
		return null;
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
	 * 验证是否为XML 
	 * @param text
	 * @return
	 * @throws Exception
	 */
	public static Object validateXmlW3c(String text) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = null;
        InputSource is = null;
        try {
            builder = factory.newDocumentBuilder();
            is = new InputSource(new ByteArrayInputStream(text.getBytes("UTF-8")));
    		is.setEncoding("UTF-8");
            Document doc = builder.parse(is);
            return doc;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } 
    }
	
	/**
	 * 验证是否存在此xpath
	 * @param nodeXPath
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static Object isSelectNode(String nodeXPath, Object source) throws XPathExpressionException {
		XPath xpath = XPathFactory.newInstance().newXPath();
		return xpath.evaluate(nodeXPath, source, XPathConstants.NODESET);
	}

}
