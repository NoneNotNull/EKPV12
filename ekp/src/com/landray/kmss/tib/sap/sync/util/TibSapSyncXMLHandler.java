package com.landray.kmss.tib.sap.sync.util;

import java.io.Serializable;
import java.io.StringReader;
import java.util.Stack;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import com.landray.kmss.tib.sys.sap.connector.util.TypesExchange;
import com.landray.kmss.tib.sys.sap.constant.MessageConstants;


/**
 * SAP 使用sax解析xml 解决内存溢出
 * 
 * @author zhangtian
 * @version 2011-12-30
 */
public abstract class TibSapSyncXMLHandler extends DefaultHandler implements Serializable {

	private static final long serialVersionUID = -5890449308128121649L;
	// 收集数据临时栈
	private Stack<ElementInfo> stackTmp = new Stack<ElementInfo>();
	// 栈的深度标记，ElementInfo 里面还有栈,涉及栈的嵌套
	private int stackTmpDeeps = 0;
	private long begin=0;
	private Log logger = LogFactory.getLog(TibSapSyncXMLHandler.class);

	/**
	 * 根据文件路径建立 SAX解析器
	 * 
	 * @param uri
	 */
	public void parseURI(String uri) {
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
		long end=System.currentTimeMillis();
		logger.debug("结束解析xml文档..."+"本次执行花费时间："+(end-begin)+"ms");
		super.endDocument();
		this.stackTmp = new Stack<ElementInfo>();
		stackTmpDeeps = 0;
		
		
	}

	/**
	 * 开始解析xml
	 */
	@Override
	public void startElement(String paramString1, String paramString2,
			String paramString3, Attributes paramAttributes)
			throws SAXException {
		// 收集数据压入栈中
		ElementInfo elem = new ElementInfo(paramString1, paramString2,
				paramString3, null, paramAttributes);
		getStackByDeep(stackTmpDeeps, stackTmp).push(elem);
		stackTmpDeeps++;

	}

	@Override
	public void endElement(String paramString1, String paramString2,
			String paramString3) throws SAXException {
		// field 标签不出栈,收集到栈中
		if (MessageConstants.FIELD.equalsIgnoreCase(paramString3)) {
			stackTmpDeeps--;
		}
		// STRUCTURE 标签不出栈,收集到栈中
		else if (MessageConstants.STRUCTURE.equalsIgnoreCase(paramString3)) {
			stackTmpDeeps--;
		}
		// EXPORT 标签doExport处理
		else if (MessageConstants.EXPORT.equalsIgnoreCase(paramString3)) {
			ElementInfo elem = getStackByDeep(stackTmpDeeps - 1, stackTmp)
					.pop();
			doExport(elem);
			stackTmpDeeps--;
		}
		// EXPORT 标签doExport处理
		else if (MessageConstants.IMPORT.equalsIgnoreCase(paramString3)) {
			ElementInfo elem = getStackByDeep(stackTmpDeeps - 1, stackTmp)
					.pop();
			doImport(elem);
			stackTmpDeeps--;
		}
		// records 标签doRecord处理
		else if (MessageConstants.ROW.equalsIgnoreCase(paramString3)) {
			ElementInfo tablesElement = getStackByDeep(stackTmpDeeps - 2,
					stackTmp).peek();
			ElementInfo elem = getStackByDeep(stackTmpDeeps - 1, stackTmp)
					.pop();
			//针对table isin=0 做数据处理。
			if(!TypesExchange.getBoolean(tablesElement.getAttrs().get("isin"))){
				doExportRecord(tablesElement, elem);
			}else if (TypesExchange.getBoolean(tablesElement.getAttrs().get("isin"))){
				doImportRecord(tablesElement, elem);
			}
			stackTmpDeeps--;
		} 
		else if (MessageConstants.JCO.equalsIgnoreCase(paramString3)){
			ElementInfo  jcoElem= getStackByDeep(stackTmpDeeps - 1, stackTmp).pop();
			doJcoElem(jcoElem);
			stackTmpDeeps--;
		}
		else {
			getStackByDeep(stackTmpDeeps - 1, stackTmp).pop();
			stackTmpDeeps--;
		}
	}
	
	public abstract void doJcoElem(ElementInfo jcoElem);
	
	/**
	 * 处理Import 标签传出参数对象
	 * 
	 * @param importElement
	 */
	public abstract void doImport(ElementInfo importElement);
	
	/**
	 * 处理record 函数(如：需要保存数据库)
	 * 
	 * @param parentElement
	 *            xml table 节点对象
	 * @param fieldElement
	 *            xml records 节点对象
	 */
	public abstract void doExportRecord(ElementInfo parentElement,
			ElementInfo fieldElement);
	
	/**
	 * 处理传入参数table 函数(如：需要保存数据库)
	 * 
	 * @param parentElement
	 *            xml table 节点对象
	 * @param fieldElement
	 *            xml records 节点对象
	 */
	public abstract void doImportRecord(ElementInfo parentElement,
			ElementInfo fieldElement);
	

//	public void printElementInfo(ElementInfo elem) {
//		System.out.println(elem.toString());
//	}

	/**
	 * 处理Exprot 标签传出参数对象
	 * 
	 * @param exportElement
	 */
	public abstract void doExport(ElementInfo exportElement);

	@Override
	public void characters(char[] paramArrayOfChar, int paramInt1, int paramInt2)
			throws SAXException {
		// 收集xml文本值加入栈中
		String str = new String(paramArrayOfChar, paramInt1, paramInt2);
		getStackByDeep(stackTmpDeeps - 1, stackTmp).peek().setNodeValue(str);

	}

	/**
	 * 递归获取深度栈。
	 * 
	 * @param i
	 * @param fatherStack
	 * @return
	 */
	public Stack<ElementInfo> getStackByDeep(int i,
			Stack<ElementInfo> fatherStack) {
		return i <= 0 ? fatherStack : getStackByDeep(--i, fatherStack.peek()
				.getChildrens());
	}

}
