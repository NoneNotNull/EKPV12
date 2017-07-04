/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.util.header;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.util.StringUtil;

/**
 * 此类用于处理不同的头部信息的一个信息VO类，
 * 而头部信息主要装有验证用户名密码信息，
 * 需要增加WebService验证方式的都需继承此抽象类。
 * 
 * @author 邱建华
 * @version 1.0 2012-11-13
 */
public class SoapInfo {
	private Log logger = LogFactory.getLog(this.getClass());
	
	private String requestXml;
	private TibSysSoapMain TibSysSoapMain;
	private Document requestDocument;
	
	public Object getSource(){
		
		if(requestDocument!=null){
			return requestDocument;
		}
		else if(StringUtil.isNotNull(requestXml)){
			return requestXml;
		}
		else{
			logger.warn("空数据资源!");
			return null;
		}
	}
	
	public Document getSourceDocument() throws Exception{
		if(requestDocument!=null){
			return requestDocument;
		}
		else if(StringUtil.isNotNull(requestXml)){
			requestDocument =DOMHelper.parseXmlString(requestXml);
			return requestDocument;
		}
		else{
			return null;
		}
	}
	
	
	public SoapInfo(){}
	
	public SoapInfo(String requestXml, TibSysSoapMain tibSysSoapMain,
			Document requestDocument) {
		super();
		this.requestXml = requestXml;
		TibSysSoapMain = tibSysSoapMain;
		this.requestDocument = requestDocument;
	}

	public SoapInfo(String requestXml, TibSysSoapMain tibSysSoapMain) {
		super();
		this.requestXml = requestXml;
		TibSysSoapMain = tibSysSoapMain;
	}

	public String getRequestXml() {
		return requestXml;
	}

	public void setRequestXml(String requestXml) {
		this.requestXml = requestXml;
	}

	public TibSysSoapMain getTibSysSoapMain() {
		return TibSysSoapMain;
	}

	public void setTibSysSoapMain(TibSysSoapMain TibSysSoapMain) {
		this.TibSysSoapMain = TibSysSoapMain;
	}

	public Document getRequestDocument() {
		return requestDocument;
	}

	public void setRequestDocument(Document requestDocument) {
		this.requestDocument = requestDocument;
	}
	
	
	
}
