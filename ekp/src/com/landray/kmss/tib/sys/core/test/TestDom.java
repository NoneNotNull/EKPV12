package com.landray.kmss.tib.sys.core.test;

import java.io.InputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.sun.org.apache.xerces.internal.dom.DeferredElementImpl;

public class TestDom {

	public static void main(String[] args) throws Exception {

		
		InputStream is = TestDom.class
				.getResourceAsStream("/com/landray/kmss/tib/sys/core/test/data.xml");
		InputSource is1 = new InputSource(is);
		is1.setEncoding("UTF-8");
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.parse(is1);

		
		
		
		Element elem=doc.getDocumentElement();
		
		elem.getNodeName();
		elem.getFirstChild();
		elem.getChildNodes().getLength();
		elem.getNodeValue();
//		elem.getTextContent();
		getTextContent(elem);
		
		System.out.println();
	}
	
	/**
     * 解决org.w3c.dom.Node.getTextContent 没有实现的问题。
     * 如果加载jdk包会实现这个方法，但是如果应用包先加载就不会
     * （测试类中使用）
     * @param node
     * @return
     */
    public static String getTextContent(Node node){
    	if(node==null){
    		return null;
    	}
    	StringBuffer fBufferStr=null;
    	 Node child = node.getFirstChild();
         if (child != null) {
             Node next = child.getNextSibling();
             if (next == null) {
                 return hasTextContent(child) ? getTextContent(child) : "";
             }
             if (fBufferStr == null){
                 fBufferStr = new StringBuffer();
             }
             else {
                 fBufferStr.setLength(0);
             }
             getTextContent(fBufferStr,node);
             return fBufferStr.toString();
         }
         return "";
    	
    	
    }
    
    

    // internal method taking a StringBuffer in parameter
    private static void getTextContent(StringBuffer buf,Node node) throws DOMException {
    	if(node==null){
    		return ;
    	}
    	
        Node child = node.getFirstChild();
        while (child != null) {
            if (hasTextContent(child)) {
                getTextContent(buf,child);
            }
            child = child.getNextSibling();
        }
    }

    // internal method returning whether to take the given node's text content
    // 此方法？何解？
    private static boolean hasTextContent(Node child) {
    	if (child == null) {
			return false;
		} else {

		}
    	return false;
    }

}
