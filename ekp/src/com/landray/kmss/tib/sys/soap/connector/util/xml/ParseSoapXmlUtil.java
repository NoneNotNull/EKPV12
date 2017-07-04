/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.util.xml;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

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

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.landray.kmss.tib.common.util.DomUtil;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;

/**
 * @author 邱建华
 * @version 1.0 2012-11-5
 */
public class ParseSoapXmlUtil {
	
	public static Log logger = LogFactory.getLog(ParseSoapXmlUtil.class);
	
	/**
	 * 移除不启用的节点
	 * @param xmlStr	XML字符串
	 * @throws TransformerException 
	 * @throws TransformerFactoryConfigurationError 
	 */
	public static String disableFilter(String xmlStr) throws TransformerFactoryConfigurationError, TransformerException {
		Document doc = parseXmlString(xmlStr);
		disableFilter(doc);
		return DomUtil.DocToString(doc);
	}
	
	/**
	 * 移除不启用的节点
	 * @param doc	DOM节点
	 */
	public static void disableFilter(Document doc) {
		NodeList nodeList = doc.getDocumentElement().getChildNodes();
		Set<Node> disableNodeSet = new HashSet<Node>();
		removeDisableLoop(nodeList, disableNodeSet);
		for (Iterator<Node> it = disableNodeSet.iterator(); it.hasNext();) {
			Node curNode = it.next();
			curNode.getParentNode().removeChild(curNode);
		}
	}
	
	private static void removeDisableLoop(NodeList nodeList, Set<Node> disableNodeSet) {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (Node.ELEMENT_NODE != curNode.getNodeType()) {
				continue;
			}
			JSONObject jsonObject = findCommentJsonObj(curNode);
			if (null != jsonObject && jsonObject.containsKey("nodeEnable")) {
				String nodeEnable = jsonObject.getString("nodeEnable");
				if (!"checked".equals(nodeEnable)) {
					disableNodeSet.add(curNode);
				}
			}
			if (curNode.hasChildNodes()) {
				removeDisableLoop(curNode.getChildNodes(), disableNodeSet);
			}
		}
	}
	
	/**
	 * 添加注释的方法
	 * @param commentxml
	 * @param resultxml
	 * @return
	 */
	public static String addComment(String commentxml, String resultxml,String tagName,boolean flag) {
		
		logger.debug("commentxml=" + commentxml);
		logger.debug("=====================================================");
		logger.debug("resultxml=" + resultxml);
		Document doc_s = parseXmlString(commentxml);
		Document doc_t = parseXmlString(resultxml);
		NodeList list_s = doc_s.getElementsByTagName(tagName);
		NodeList list_t = doc_t.getElementsByTagName(tagName);
		// 同时获取第一个output节点
		Node node_s = getElementNode(list_s, 0);
		Node node_t = getElementNode(list_t, 0);
		loopComment(node_s, node_t);
		try {
			return nodeToString((Node) doc_t);
		} catch (TransformerFactoryConfigurationError e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		} catch (TransformerException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return null;

	}

	public static void loopComment(Node node_s, Node node_t) {
		if (node_s == null || node_t == null) {
			return;
		}
		if (node_s.getChildNodes().getLength() <= 0
				|| node_t.getChildNodes().getLength() <= 0) {
			return;
		}
		// 找到所有待加注析的节点
		List<Node> nodes = new ArrayList<Node>();
		for (int j = 0, j_len = node_t.getChildNodes().getLength(); j < j_len; j++) {
			if (node_t.getChildNodes().item(j).getNodeType() == Node.ELEMENT_NODE) {
				nodes.add(node_t.getChildNodes().item(j));
			}
		}
		for (int i = 0, len = node_s.getChildNodes().getLength(); i < len; i++) {
			Node cur_node = node_s.getChildNodes().item(i);
			if (cur_node.getNodeType() != Node.ELEMENT_NODE) {
				continue;
			}
			Node comment = findCommentNode(cur_node);
			// 从待加注析的地方找到tagName 相同的
			for (Node node : nodes) {
				if (filterNs(node.getNodeName()).equals(
						filterNs(cur_node.getNodeName()))) {
					if (comment == null) {
						// continue;
					} else {
						Comment comNode = node.getOwnerDocument()
								.createComment(comment.getTextContent());
						node_t.insertBefore(comNode, node);
					}
					loopComment(cur_node, node);
				}
			}
		}
	}

	private static String filterNs(String name) {
		if (name.indexOf(":") > -1) {
			return name.split(":")[1];
		}
		return name;
	}
	
	/**
	 * 字符串转w3c dom
	 * 
	 * @param xmlstr
	 * @return Document
	 */
	public static Document parseXmlString(String xmlStr) {
		try {
			StringReader sr = new StringReader(xmlStr);
			InputSource is = new InputSource(sr);
			is.setEncoding("UTF-8");
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(is);
			return doc;
		} catch (IOException e1) {
			return null;
		} catch (ParserConfigurationException e2) {
			return null;
		} catch (SAXException e3) {
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
				curindex++;
			}
		}
		return null;
	}
	
	public static String nodeToString(Node node) 
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
		trans.transform(new DOMSource(node), result);
		String rtnStr = writer.toString();
		rtnStr = rtnStr.replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
		return rtnStr;
	}
	
	/**
	 * 找当前节点的上一个注释节点
	 * @param curNode
	 * @return
	 */
	private static Node findCommentNode(Node curNode) {

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
	 * 找当前节点的上一个注释，并返回Json格式
	 * @param curNode
	 * @return
	 */
	public static JSONObject findCommentJsonObj(Node curNode) {
		Node commentNode = findCommentNode(curNode);
		if (null != commentNode) {
			String commentStr = commentNode.getTextContent();
			String splitStr = "|erp_web=";
			if (commentStr.lastIndexOf(splitStr) > 0) {
				int start = commentStr.lastIndexOf(splitStr) + splitStr.length();
				String result = commentStr.substring(start);
				JSONObject commentJsonObj = JSONObject.fromObject(result);
				return commentJsonObj;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	
	/**
	 * 判断是否有错误信息
	 * @param responseXml	响应的XML
	 * @return				是否是错误信息
	 * @throws Exception
	 */
	public static boolean isFault(String responseXml) throws Exception {
		boolean flag = false;
		Document doc = HeaderOperation.stringToDoc(responseXml);
		// 找到此节点则不为null,否则为null
		Node node = HeaderOperation.selectNode("//Envelope/Body/Fault", doc);
		if (node != null) {
			flag = true;
		}
		return flag;
	}
	
	/**
	 * 判断是否有错误信息
	 * @param responseXml	响应的XML
	 * @return				是否是错误信息
	 * @throws Exception
	 */
	public static String isFaultInfo(Document doc) throws Exception {
		String faultInfo = "";
		// 找到此节点则不为null,否则为null
		Node node = HeaderOperation.selectNode("//Envelope/Body/Fault", doc);
		if (node != null) {
			faultInfo = HeaderOperation.nodeToString(node);
		}
		return faultInfo;
	}
	
	/**
	 * 设置body值
	 * @param attrXml
	 * @param bodyXml
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	public static String setRequestValue(String attrXml, String bodyXml) 
			throws IOException, Exception {
		Document attrDoc = HeaderOperation.stringToDoc(attrXml);
		Document bodyDoc = HeaderOperation.stringToDoc(bodyXml);
		Node attrNode = HeaderOperation.selectNode("//Input/Envelope/Body", attrDoc);
		Node bodyNode = HeaderOperation.selectNode("//Input/Envelope/Body", bodyDoc);
		// 复制body节点中的值，把body中存在的节点的内容进行赋值
		loopNodeValue(attrNode, bodyNode);
		String requestXml = HeaderOperation.nodeToString(attrDoc);
		return requestXml;
	}
	
	/**
	 * 合并两个XML，主要为了获取请求参数body里面的值
	 * @param attrNode
	 * @param bodyNode
	 */
	public static void loopNodeValue(Node attrNode, Node bodyNode) {
		NodeList attrNodeList = attrNode.getChildNodes();
		NodeList bodyNodeList = bodyNode.getChildNodes();
		// 循环合并节点
		for (int i = 0, len = attrNodeList.getLength(); i < len; i++) {
			Node attrChildNode = attrNodeList.item(i);
			System.out.println("="+attrChildNode.getNodeName());
			short attrType = attrChildNode.getNodeType();
			if (Node.ELEMENT_NODE == attrType) {
				for (int j = 0, leng = bodyNodeList.getLength(); j < leng; j++) {
					Node bodyChildNode = bodyNodeList.item(j);
					String value = bodyChildNode.getTextContent();
					System.out.println("name="+bodyChildNode.getNodeName()+"-content="+value);
					System.out.println("-nodevalue="+bodyChildNode.getNodeValue());
					short bodyType = bodyChildNode.getNodeType();
					if (attrType == bodyType 
							&& attrChildNode.getNodeName().equals(bodyChildNode.getNodeName())) {
						// 没有了子节点才赋值
						if (!attrChildNode.hasChildNodes()) {
							attrChildNode.appendChild(attrChildNode.getOwnerDocument()
									.createTextNode(value));
						}
						// 继续循环
						loopNodeValue(attrChildNode, bodyChildNode);
						break;
					} 
				}
			}
		}
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
	 * 移除禁用节点 
	 * @param nodeList
	 */
	public static void getTemplateXmlLoop(NodeList nodeList) {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (curNode != null && Node.ELEMENT_NODE == curNode.getNodeType()) {
				JSONObject commentJsonObj = ParseSoapXmlUtil.findCommentJsonObj(curNode);
				if (commentJsonObj != null && commentJsonObj.containsKey("nodeEnable")) {
					String nodeEnable = commentJsonObj.getString("nodeEnable");
					if (!"checked".equals(nodeEnable)) {
						curNode.getParentNode().removeChild(curNode);
					}
				}
				if (curNode.hasChildNodes()) {
					getTemplateXmlLoop(curNode.getChildNodes());
				}
			}
		}
	}
	
}
