/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.util.header;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
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

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author 邱建华
 * @version 1.0 2012-11-13
 */
public class HeaderOperation {
	
	public static Log logger = LogFactory.getLog(HeaderOperation.class);
	
	/**
	 * 通过头部类型，去选择创造何种头部信息
	 * @param inputXml		InputXML模版
	 * @param headerType	头部类型
	 * @return String		返回带有头部信息的Input
	 * @throws Exception
	 */
	public static String getInputAndHeaderXml(String inputXml, String className, String springName, 
			TibSysSoapSetting soapuiSet) throws Exception {
		// 重新建造一个包含头部信息的新的DOM
		Document doc = reBuildDoc(inputXml, className, springName, soapuiSet);
		inputXml = nodeToString(doc);
		return inputXml;
	}
	
	/**
	 * 重新建造一个包含头部信息的新的DOM
	 * @param xml
	 * @param headerType
	 * @return
	 * @throws Exception
	 */
	private static Document reBuildDoc(String xml, String className, String springName, 
			TibSysSoapSetting soapuiSet) throws Exception {
		// 把XML字符串转化为DOM对象
		Document doc = stringToDoc(xml);
		// 判断使用何种头部类型(此处的SpringBean名称或class类名从扩展点中获取)
		ISoapHeaderType headerType = getHeaderType(springName, className);
		// EKP方式建造SOAP头部消息
		headerType.buildDocTemplate(doc, soapuiSet);
		return doc;
	}
	
	public static Document reBuildDocNode(Document doc, String className, String springName, 
			TibSysSoapSetting soapuiSet) throws Exception {
		
		// 判断使用何种头部类型(此处的SpringBean名称或class类名从扩展点中获取)
		ISoapHeaderType headerType = getHeaderType(springName, className);
		// EKP方式建造SOAP头部消息
		headerType.buildDocTemplate(doc, soapuiSet);
		return doc;
	}
	
	
	
	/**
	 * 获取权限验证接口
	 * @param springName
	 * @param className
	 * @return
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	private static ISoapHeaderType getHeaderType(String springName, String className) 
			throws ClassNotFoundException, InstantiationException, IllegalAccessException {
		ISoapHeaderType headerType = null;
		if(StringUtil.isNotNull(springName)) {
			headerType = (ISoapHeaderType) SpringBeanUtil.getBean(springName);
		} else if (StringUtil.isNotNull(className)) {
			Class<?> clazz = Class.forName(className);
			headerType = (ISoapHeaderType) clazz.newInstance();
		} else {
			//log.info("没有发现此登录方式ClassName或SpringName的扩展点");
		}
		return headerType;
	}
	
	/**
	 * 给出路径，获取Node类
	 * @param elePath		定位的节点路径
	 * @param source
	 * @return
	 * @throws XPathExpressionException
	 */
	public static Node selectNode(String nodePath, Object source) throws XPathExpressionException{
        XPath xpath = XPathFactory.newInstance().newXPath();
        Node node = (Node) xpath.evaluate(nodePath, source, XPathConstants.NODE);
        return node;
    }
	
	/**
	 * String类型的XML转换为DOM对象
	 * @param xml
	 * @return
	 * @throws Exception
	 * @throws IOException
	 */
	public static Document stringToDoc(String xml) throws Exception, IOException {
		// 把XML字符串转化为输入流
		ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(xml.getBytes("UTF-8"));
		DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder= factory.newDocumentBuilder();
		Document doc = docBuilder.parse(byteArrayInputStream);
		return doc;
	}
	
	/**
	 * DOM转换成String类型
	 * @param doc
	 * @return
	 * @throws TransformerFactoryConfigurationError
	 * @throws TransformerException
	 */
	public static String nodeToString(Node node)		
			throws TransformerFactoryConfigurationError, TransformerException {
		TimeCounter.logCurrentTime("HeaderOperation-nodeToString", true, HeaderOperation.class);
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
		String rtnStr=writer.toString();
		rtnStr =rtnStr.replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
		TimeCounter.logCurrentTime("HeaderOperation-nodeToString", false, HeaderOperation.class);
		
		return rtnStr;
	}
	
	public static String allToOutputXml(String allXml) throws Exception {
		String rtnStr = "";
		// 把XML字符串转化为DOM对象
		Document doc = stringToDoc(allXml);
		Node node = selectNode("//Output", doc);
		if (node != null) {
			Node rtnNode = findNextNode(node);
			rtnStr = nodeToString(rtnNode);
		} 
		return rtnStr;
	}
	
	/**
	 * 获取指定XML，并返回String
	 * @param allXml
	 * @return
	 * @throws Exception
	 */
	public static String allToPartXml(String allXml, String xpath) throws Exception {
		
		
		// 把XML字符串转化为DOM对象
		Document doc = stringToDoc(allXml);
		Node node = selectNode(xpath, doc);
		Node rtnNode=findNextNode(node);
		return nodeToString(rtnNode);
	}
	
	public static Node allToPartNode(Document doc, String xpath) throws Exception {
		// 把XML字符串转化为DOM对象
		Node node = selectNode(xpath, doc);
		Node rtnNode=findNextNode(node);
		return rtnNode;
	}
	
	/**
	 * 获取指定XML，并返回String
	 * @param allXml
	 * @return
	 * @throws Exception
	 */
	public static String allToPartXmlByPath(String allXml, String xpath) throws Exception {
		// 把XML字符串转化为DOM对象
		Document doc = stringToDoc(allXml);
		Node node = selectNode(xpath, doc);
		return nodeToString(node);
	}
	
	/**
	 * 找出子节点
	 * @param node
	 * @return
	 */
	public static Node findNextNode(Node node){
		NodeList nodeList=node.getChildNodes();
		for(int i =0,len=nodeList.getLength();i<len;i++){
			Node n_node=nodeList.item(i);
			if(n_node!=null&&n_node.getNodeType()==Node.ELEMENT_NODE){
				return n_node;
			}
		}
		return node;
	}
	
	/**
	 * 获取Soap头信息模版
	 * @param wsdlUrl
	 * @param soapVersion
	 * @param proUsername
	 * @param proPassword
	 * @return
	 * @throws Exception
	 */
	public static String loadHeaderTemplate(String inputXml) throws Exception {
		Document doc = (Document) stringToDoc(inputXml);
		Node bodyNode = selectNode("/Envelope/Body", doc);
		bodyNode.getParentNode().removeChild(bodyNode);
		String headTemplate = nodeToString(doc);
		return headTemplate;
	}
	
	/**
	 * 合并XML，主要是把请求XML中的body加入headTemplate中
	 * @param headTemplate
	 * @param inputXml
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	public static String mergeInputXml(String headTemplate, String inputXml) throws IOException, Exception {
		Document headDoc = stringToDoc(headTemplate);
		Node headNode = headDoc.getFirstChild();
		Node inputNode = stringToDoc(inputXml);
		Node inputBodyNode = selectNode("/Envelope/Body", inputNode);
		
		Node headBodyNode = headDoc.createElement(inputBodyNode.getNodeName());
		// 拥有头部模版的XML加入body信息
		loopNode(inputBodyNode, headBodyNode);
		headNode.appendChild(headBodyNode);
		String mergeXml = nodeToString(headDoc); 
		return mergeXml;
	}
	
	
	/**
	 * 使用dom合并节点, 减少数据转换的运行时间
	 * @param headTemplate
	 * @param inputNode
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	public static Document mergeInputNode(String headTemplate, Node inputNode) throws IOException, Exception {
		Document headDoc = stringToDoc(headTemplate);
		Node headNode = headDoc.getFirstChild();
		Node inputBodyNode = selectNode("/Envelope/Body", inputNode);
		
		Node headBodyNode = headDoc.createElement(inputBodyNode.getNodeName());
		// 拥有头部模版的XML加入body信息
		loopNode(inputBodyNode, headBodyNode);
		headNode.appendChild(headBodyNode);
		return headDoc;
	}
	
	
	/**
	 * 把body加入headTemplate中
	 * @param bodyNode
	 * @param rootNode
	 */
	public static void loopNode(Node bodyNode, Node rootNode) {
		NodeList nodeList = bodyNode.getChildNodes();
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node bodyChildNode = nodeList.item(i);
			short nodeType = bodyChildNode.getNodeType();
			switch(nodeType) {
			case Node.ELEMENT_NODE:
				Node newNode = rootNode.getOwnerDocument().createElement(bodyChildNode.getNodeName());
				newNode.setTextContent(bodyChildNode.getTextContent().replaceAll("\n", "").trim());
				rootNode.appendChild(newNode);
				loopNode(bodyChildNode, newNode);
				break;
			case Node.COMMENT_NODE:
				Node cmtNode = rootNode.getOwnerDocument().createComment(bodyChildNode.getTextContent());
				rootNode.appendChild(cmtNode);
				loopNode(bodyChildNode, cmtNode);
				break;
			}
			
		}
	}
	
	/**
	 * 获取主modelId
	 * @param xml
	 * @param attrName
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	public static String getMainId(String xml, String attrName) throws IOException, Exception {
		Document xmlDoc = stringToDoc(xml);
		Node node = xmlDoc.getFirstChild();
		NamedNodeMap nodeMap = node.getAttributes();
		Node attrNode = nodeMap.getNamedItem(attrName);
		String attrValue = attrNode.getNodeValue();
		return attrValue;
	}
	
	/**
	 * 设置权限内容
	 * @param context
	 * @param request
	 * @param soapuiSet
	 * @param springName
	 * @param className
	 * @throws Exception
	 */
	public static void setAuthContext(SubmitContext context, WsdlRequest request, 
			TibSysSoapSetting soapuiSet, String springName, String className) throws Exception {
		ISoapHeaderType soapHeaderType = getHeaderType(springName, className);
		soapHeaderType.buildAuthContext(context, request, soapuiSet);
	}
}
