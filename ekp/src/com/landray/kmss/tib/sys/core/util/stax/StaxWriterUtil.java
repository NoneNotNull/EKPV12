package com.landray.kmss.tib.sys.core.util.stax;

import java.io.StringWriter;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;

import org.apache.commons.lang.StringUtils;

/**
 * 使用stax 写xml
 * @author zhangtian
 * date :2012-8-8 下午02:46:31
 */
public class StaxWriterUtil {

	private XMLOutputFactory factory;
	private XMLEventFactory eventFactory;
	private StringWriter stringWriter;
	private XMLEventWriter writer;
	private boolean isInit = false;
	private String encoding="UTF-8";
	private String version="1.1";
	private boolean standalone=true;
	private boolean startDoc=false;
	private boolean endDoc=true;
//	节点名字栈,用来记住上一个栈的名字;
	private Stack<QName> elementStack=new Stack<QName>();
	

	public StaxWriterUtil() {

	}
	public void init() throws XMLStreamException {
		if (!isInit) {
			factory = XMLOutputFactory.newInstance();
			eventFactory = XMLEventFactory.newInstance();
			stringWriter = new StringWriter();
			writer = factory.createXMLEventWriter(stringWriter);
			isInit=true;
		}
	}
	
	public void init(String encoding,String version,boolean standalone) throws XMLStreamException {
		if (!isInit) {
			factory = XMLOutputFactory.newInstance();
			eventFactory = XMLEventFactory.newInstance();
			stringWriter = new StringWriter();
			writer = factory.createXMLEventWriter(stringWriter);
			this.encoding=encoding;
			this.version=version;
			this.standalone=standalone;
			isInit=true;
		}
	}
	
	/**
	 * 添加属性
	 * @param staxAttr
	 * @throws XMLStreamException
	 */
	public void addAttrtube(StaxAttr staxAttr) throws XMLStreamException{
		if(!endDoc){
			XMLEvent event = eventFactory.createAttribute(staxAttr.getKey(), null == staxAttr.getValue()
					|| "".equals(staxAttr.getValue()) ? "" : staxAttr.getValue());
			writer.add(event);
		}
	}
	
	
	public void startDocument() throws XMLStreamException{
		endDoc=false;
		startDoc=true;
		writer.add(eventFactory.createStartDocument("UTF-8"));
	}
	
	public void endDocument() throws XMLStreamException{
		endDoc=true;
		startDoc=false;
		endAllElement();
		writer.add(eventFactory.createEndDocument());
		writer.flush();
	}
	
	/**
	 * 添加节点对象,附带属性
	 * @param staxElement
	 * @throws XMLStreamException
	 */
	public void addElement(StaxElement staxElement) throws XMLStreamException{
//		QName nameURI 目前不设定了
		QName elementName= new QName("",staxElement.getTagName());
		StartElement element=eventFactory.createStartElement(elementName,null,null);
		writer.add(element);
		elementStack.push(elementName);
		
		Map<String, StaxAttr> attrMap=staxElement.getAttrs();
		
//		属性
		if(attrMap!=null&&!attrMap.isEmpty()){
//			勾画属性集合
			for(String key:attrMap.keySet()){
				String attrValue=attrMap.get(key).getValue();
				XMLEvent event = eventFactory.createAttribute(key, null == attrValue
						|| "".equals(attrValue) ? "" : attrValue);
				writer.add(event);
			}
		}
		
//		文本值
		String nodeValue=staxElement.getNodeValue();
		if(!StringUtils.isEmpty(nodeValue)){
			XMLEvent event = eventFactory.createCharacters(nodeValue);
			writer.add(event);
		}
		
//		勾画儿子
		List<StaxElement>  listElements=staxElement.getChildStaxElement();
		for(StaxElement child:listElements){
			addElement(staxElement);
		}
	}
	
	
	public void addCharacters(String nodeValue) throws XMLStreamException{
		if(!StringUtils.isEmpty(nodeValue)){
			XMLEvent event = eventFactory.createCharacters(nodeValue);
			writer.add(event);
		}
		
	}
	
	public QName endElement() throws XMLStreamException{
		QName qName=elementStack.pop();
		writer.add(eventFactory.createEndElement(qName, null));
		return qName;
	}
	
//	递归 吐qName
	public void endAllElement() throws XMLStreamException{
		if(!elementStack.isEmpty()){
			endElement();
			endAllElement();
		}
	}
	public XMLOutputFactory getFactory() {
		return factory;
	}
	public void setFactory(XMLOutputFactory factory) {
		this.factory = factory;
	}
	public XMLEventFactory getEventFactory() {
		return eventFactory;
	}
	public void setEventFactory(XMLEventFactory eventFactory) {
		this.eventFactory = eventFactory;
	}
	public StringWriter getStringWriter() {
		return stringWriter;
	}
	public void setStringWriter(StringWriter stringWriter) {
		this.stringWriter = stringWriter;
	}
	public XMLEventWriter getWriter() {
		return writer;
	}
	public void setWriter(XMLEventWriter writer) {
		this.writer = writer;
	}
	
	
	
	
	
	
	

}
