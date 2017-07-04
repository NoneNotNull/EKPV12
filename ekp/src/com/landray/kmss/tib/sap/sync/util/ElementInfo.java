package com.landray.kmss.tib.sap.sync.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.xml.sax.Attributes;

/**
 * SAX解析封装xml 节点类,涉及到栈的嵌套
 * @author zhangtian
 * @version 2011-12-31
 */
public class ElementInfo  implements Cloneable, Serializable{
	private Log logger = LogFactory.getLog(ElementInfo.class);
	
	private String uri;
	private String qName ;
	private String localName ;
	private String nodeValue;
	private HashMap<String,String> attrs=new HashMap<String, String>();
	private Stack<ElementInfo> childrens=new Stack<ElementInfo>();
	public ElementInfo(){}
	
	ElementInfo(String uri,String localName,String qName,String nodeValue,Attributes attrs)
	{
		this.uri=uri;
		this.qName=qName;
		this.localName=localName;
		this.nodeValue=nodeValue;
		for(int i=0,len=attrs.getLength();i<len;i++){
			this.attrs.put(attrs.getQName(i), attrs.getValue(i));
		}
	}
	public String getUri() {
		return uri;
	}
	public void setUri(String uri) {
		this.uri = uri;
	}
	public String getqName() {
		return qName;
	}
	public void setqName(String qName) {
		this.qName = qName;
	}
	public String getLocalName() {
		return localName;
	}
	public void setLocalName(String localName) {
		this.localName = localName;
	}
	public String getNodeValue() {
		return nodeValue;
	}
	public void setNodeValue(String nodeValue) {
		this.nodeValue = nodeValue;
	}
	public Stack<ElementInfo> getChildrens() {
		return childrens;
	}
	public void setChildrens(Stack<ElementInfo> childrens) {
		this.childrens = childrens;
	}
	
	
	public Map<String, String> getAttrs() {
		return attrs;
	}

	public void setAttrs(HashMap<String, String> attrs) {
		this.attrs = attrs;
	}
	
	public void clearNodeVal(){
		this.nodeValue="";
	}
	

	@Override
	public String toString() {
		StringBuffer buf=new StringBuffer();
		buf.append("uri="+this.uri+"\n");
		buf.append("localName="+this.localName+"\n");
		buf.append("qName="+this.qName+"\n");
		buf.append("nodeValue="+this.nodeValue+"\n");
		buf.append("Attributes:[");
		for(String key : attrs.keySet())
		{
			buf.append(key+"="+attrs.get(key)+"\n");
		}
		buf.append("]");
		return buf.toString();
	}
	@Override
	public Object clone() throws CloneNotSupportedException {
		ElementInfo elementInfo = null;  
		ByteArrayOutputStream memoryBuffer = new ByteArrayOutputStream();
		ObjectOutputStream out = null;
		ObjectInputStream in = null;
		try {
			out = new ObjectOutputStream(memoryBuffer);
			out.writeObject(this);
			out.flush();
			in = new ObjectInputStream(new ByteArrayInputStream(memoryBuffer
					.toByteArray()));
			elementInfo = (ElementInfo) in.readObject();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			if (out != null) {
				try {
					out.close();
					out = null;
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
			if (in != null) {
				try {
					in.close();
					in = null;
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
			if (memoryBuffer != null) {
				try {
					memoryBuffer.close();
					memoryBuffer = null;
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
		}
		return elementInfo;
	}
	
}
