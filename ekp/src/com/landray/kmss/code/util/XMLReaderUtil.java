package com.landray.kmss.code.util;

import java.io.File;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.commons.betwixt.io.BeanReader;

public class XMLReaderUtil {
	public synchronized static Object getInstance(File file, Class cls)
			throws Exception {
		// 获取SAX工厂对象
		SAXParserFactory factory = SAXParserFactory.newInstance();
		factory.setNamespaceAware(false);
		factory.setValidating(false);
		// 获取SAX解析
		SAXParser parser = factory.newSAXParser();
		parser
				.getXMLReader()
				.setFeature(
						"http://apache.org/xml/features/nonvalidating/load-external-dtd",
						false);
		BeanReader xmlReader = new BeanReader(parser);
		xmlReader.registerBeanClass(cls);
		return xmlReader.parse(file);
	}
}
