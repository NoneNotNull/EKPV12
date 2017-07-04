package com.landray.kmss.tib.sys.core.test;

import java.io.Serializable;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreNode;

public class TestProviderHandler extends DefaultHandler implements Serializable {

	private static final long serialVersionUID = 1L;

	private Log logger = LogFactory.getLog(TestProviderHandler.class);

	private static List<TibSysCoreNode> cacheList = new ArrayList<TibSysCoreNode>(
			1);

	private Stack<String> stackPath = new Stack<String>();
	
	private Stack<String> defPath = new Stack<String>();

	private Stack<TibSysCoreNode> stackTmp = new Stack<TibSysCoreNode>();
	private long begin = 0;

	public static List<TibSysCoreNode> getCacheList() {
		return cacheList;
	}

	public static void setCacheList(List<TibSysCoreNode> cacheList) {
		TestProviderHandler.cacheList = cacheList;
	}

	/**
	 * 根据文件路径建立 SAX解析器
	 * 
	 * @param uri
	 */
	public void parseURI(String uri) {
		cacheList.clear();
		stackPath.clear();
		stackTmp.clear();

		try {
			SAXParserFactory spf = SAXParserFactory.newInstance();
			SAXParser sp = spf.newSAXParser();
			sp.parse(uri, this);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void parseXMLString(String xml) {
		try {
			StringReader read = new StringReader(xml);
			InputSource source = new InputSource(read);
			SAXParserFactory spf = SAXParserFactory.newInstance();
			SAXParser sp = spf.newSAXParser();
			XMLReader reader = sp.getXMLReader();
			reader.setContentHandler(this);
			reader.parse(source);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void startDocument() throws SAXException {
		begin = System.currentTimeMillis();
		logger.debug("开始解析xml文档,执行映射操作...");
		super.startDocument();
	}

	@Override
	public void endDocument() throws SAXException {
		long end = System.currentTimeMillis();
		logger.debug("结束解析xml文档..." + "本次执行花费时间：" + (end - begin) + "ms");
		super.endDocument();

	}

	/**
	 * 开始解析xml
	 */
	@Override
	public void startElement(String paramString1, String paramString2,
			String tagName, Attributes paramAttributes) throws SAXException {
		String path = getRealTagName(tagName);
		stackPath.push(path);

		TibSysCoreNode tcn = buildNodeInfo(tagName, paramAttributes);
		
		String defName=tcn.getFdDefName();
		if(StringUtils.isEmpty(defName)){
			defPath.add(tagName);
		}
		else{
			defPath.add(defName);
		}
		
		tcn.setFdDefPath(getDefPath());  

		stackTmp.push(tcn);

		// 收集数据压入栈中
		// ElementInfo elem = new ElementInfo(paramString1, paramString2,
		// paramString3, null, paramAttributes);
		// getStackByDeep(stackTmpDeeps, stackTmp).push(elem);
		// stackTmpDeeps++;
	}

	private TibSysCoreNode buildNodeInfo(String tagName,
			Attributes paramAttributes) {
		TibSysCoreNode tibSysCoreNode = new TibSysCoreNode();

		JSONObject json = attrJson(paramAttributes);
		String tgName = getRealTagName(tagName);

		tibSysCoreNode.setFdAttrJson(json != null ? json.toString() : "");

		tibSysCoreNode.setFdNodeName(tagName);

		tibSysCoreNode.setFdNodeLevel(String.valueOf(stackPath.size()));

		tibSysCoreNode.setFdNodePath(getCurPath());

		if (json.containsKey("eb")) {
			tibSysCoreNode.setFdNodeEnable(true);
		} else {
			tibSysCoreNode.setFdNodeEnable(false);
		}

		if (json.containsKey("def")) {
			String def = (String) json.get("def");
			tibSysCoreNode.setFdDefName(def);
		} else {
			tibSysCoreNode.setFdDefName(tgName);
		}

		return tibSysCoreNode;

	}

	private String getCurPath() {
		StringBuffer buf=new StringBuffer("/");
		buf.append(StringUtils.join(stackPath.toArray(), "/"));
		
		return buf.toString();
	}
	
	private String getDefPath() {
		StringBuffer buf=new StringBuffer("/");
		buf.append(StringUtils.join(defPath.toArray(), "/"));
		
		return buf.toString();
	}
	

	private String getRealTagName(String curNode) {
		String realName = curNode;
		if (curNode.indexOf(":") > 0) {
			realName = curNode.split(":")[1];
		}
		return realName;
	}

	private JSONObject attrJson(Attributes attrs) {

		if (attrs != null) {
			JSONObject json = new JSONObject();
			for (int i = 0, len = attrs.getLength(); i < len; i++) {
				json.accumulate(attrs.getQName(i), attrs
						.getValue(i));
			}
			return json;
		} else {
			return null;
		}

	}

	@Override
	public void endElement(String paramString1, String paramString2,
			String paramString3) throws SAXException {
		TibSysCoreNode tcn = stackTmp.pop();
		cacheList.add(tcn);
		String path = stackPath.pop();
		defPath.pop();
		
		System.out.println(path);

	}

	@Override
	public void characters(char[] paramArrayOfChar, int paramInt1, int paramInt2)
			throws SAXException {

		
		
		TibSysCoreNode tcn = stackTmp.peek();
		// 收集xml文本值加入栈中
		String str = new String(paramArrayOfChar, paramInt1, paramInt2);
		tcn.setFdNodeContent(str);
	}

}
