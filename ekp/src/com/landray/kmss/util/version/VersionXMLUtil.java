package com.landray.kmss.util.version;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentFactory;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.XPath;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2010-十一月-05
 * 
 * @author 缪贵荣 提供读写版本信息的xml
 */
public class VersionXMLUtil {

	private static final Log logger = LogFactory.getLog(VersionXMLUtil.class);

	private String filePath = ""; // 文件路径

	private Document doc = null; // xml文档

	private static Map<String, Document> docCache = new ConcurrentHashMap<String, Document>(); // xml文档的cache

	private static VersionXMLUtil versionXMLUtil = new VersionXMLUtil();

	private VersionXMLUtil() {
	}

	/**
	 * 获取实例
	 * 
	 * @param filePath
	 *            文件路径
	 * @return
	 */
	public static VersionXMLUtil getInstance(String filePath) {
		versionXMLUtil.init(filePath);
		return versionXMLUtil;
	}

	/**
	 * 获取实例
	 * 
	 * @param inputStream
	 *            文件输入流
	 * @return
	 */
	public static VersionXMLUtil getInstance(InputStream inputStream) {
		versionXMLUtil.init(inputStream);
		return versionXMLUtil;
	}

	/*
	 * 初始化
	 */
	private void init(String filePath) {
		File file = null;
		try {
			file = getFile(filePath);
			this.filePath = file.getCanonicalPath();
		} catch (Exception e) {
			logger.error("读取文件：" + filePath + "失败!", e);
			throw new RuntimeException("读取文件：" + filePath + "失败!", e);
		}
		String fileNameKey = this.filePath + "_" + file.lastModified();
		if (docCache.containsKey(fileNameKey)) {
			doc = docCache.get(fileNameKey);
			return;
		}
		// 加载XML
		init(file);
		// 更新cache
		String tmpKey = "";
		if (!docCache.isEmpty()) {
			Iterator<String> keyIters = docCache.keySet().iterator();
			while (keyIters.hasNext()) {
				String key = keyIters.next();
				if (key.indexOf(this.filePath) >= 0) {
					tmpKey = key;
					break;
				}
			}
		}
		if (docCache.containsKey(tmpKey)) {
			docCache.remove(tmpKey);
		}
		docCache.put(fileNameKey, doc);
	}

	/*
	 * 加载xml
	 * 
	 * @param file
	 */
	private void init(File file) {
		InputStream is = null;
		try {
			is = new BufferedInputStream(new FileInputStream(file));
			init(is);
		} catch (FileNotFoundException e) {
			logger.error("不存在文件: + " + file.getPath(), e);
			throw new RuntimeException("不存在文件: + " + file.getPath(), e);
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
				}
			}
		}
	}

	/*
	 * 加载xml
	 * 
	 * @param inputStream
	 */
	private void init(InputStream inputStream) {
		try {
			doc = new SAXReader().read(inputStream);
		} catch (DocumentException e) {
			logger.error("加载XML失败！", e);
			throw new RuntimeException("加载XML失败！", e);
		}
	}

	/*
	 * 保存xml
	 */
	private synchronized void saveDoc() {
		if (isEmpty(filePath)) {
			if (logger.isDebugEnabled()) {
				logger.debug("filePath为空，不做保存！");
			}
			return;
		}
		OutputStream os = null;
		XMLWriter xmlWriter = null;
		try {
			File file = getFile(filePath);
			os = new BufferedOutputStream(new FileOutputStream(file));
			// OutputFormat format = OutputFormat.createPrettyPrint();
			xmlWriter = new XMLWriter(os, createOutputFormat());
			xmlWriter.write(doc);
			xmlWriter.flush();
			if (logger.isDebugEnabled()) {
				logger.info("保存xml:" + filePath + "成功!");
			}
		} catch (Exception e) {
			logger.error("保存xml:" + filePath + "失败!", e);
			throw new RuntimeException("保存xml:" + filePath + "失败!", e);
		} finally {
			if (os != null) {
				try {
					os.close();
				} catch (Exception e) {
				}
			}
			if (xmlWriter != null) {
				try {
					xmlWriter.close();
				} catch (IOException e) {
				}
			}
		}
	}

	/**
	 * 另存xml
	 */
	public synchronized void saveAsDoc(String filePath) {
		if (isEmpty(filePath)) {
			if (logger.isDebugEnabled()) {
				logger.debug("filePath为空，不做保存！");
			}
			return;
		}
		OutputStream os = null;
		XMLWriter xmlWriter = null;
		try {
			File file = new File(filePath);
			if (!file.exists()) {
				file.createNewFile();
			}
			os = new BufferedOutputStream(new FileOutputStream(file));
			// OutputFormat format = OutputFormat.createPrettyPrint();
			xmlWriter = new XMLWriter(os, createOutputFormat());
			xmlWriter.write(doc);
			xmlWriter.flush();
			if (logger.isDebugEnabled()) {
				logger.info("另存xml:" + filePath + "成功!");
			}
		} catch (Exception e) {
			logger.error("另存xml:" + filePath + "成功!", e);
			throw new RuntimeException("另存xml:" + filePath + "成功!", e);
		} finally {
			if (os != null) {
				try {
					os.close();
				} catch (Exception e) {
				}
			}
			if (xmlWriter != null) {
				try {
					xmlWriter.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * 修改描述信息
	 * 
	 * @param description
	 */
	public void setDescription(Description description) {
		final Element root = doc.getRootElement();
		removeElement(root, "module");
		Module module = description.getModule();
		Element moduleElm = addElement(root, "module", null);
		addElement(moduleElm, "module-name", module.getModuleName());
		addElement(moduleElm, "module-path", module.getModulePath());
		if (module.getBaseline() != null) {
			addElement(moduleElm, "baseline", module.getBaseline());
		}
		if (module.getSourceMd5() != null) {
			addElement(moduleElm, "source-md5", module.getSourceMd5());
		}
		if (module.getTempVersion() != null) {
			addElement(moduleElm, "temp-version", module.getTempVersion());
		}
		if (module.getIsCustom() != null) {
			addElement(moduleElm, "is-custom", module.getIsCustom());
		}
		if (module.getSerialNum() != null) {
			addElement(moduleElm, "serial-num", module.getSerialNum());
		}
		if (StringUtil.isNotNull(module.getParallelVersion())) {
			addElement(moduleElm, "parallel-version", module
					.getParallelVersion());
		}
		saveDoc();
	}

	/**
	 * 获取描述信息
	 * 
	 * @return
	 */
	public Description getDescriprion() {
		Description description = null;
		if (doc == null) {
			return description;
		}
		final Element root = doc.getRootElement();
		if (root != null && "description".equals(root.getName())) {
			description = new Description();
			Element moduleElm = root.element("module");
			if (moduleElm != null) {
				Module module = new Module();
				Element moduleNameElm = moduleElm.element("module-name");
				if (moduleNameElm != null) {
					module.setModuleName(moduleNameElm.getTextTrim());
				}
				Element modulePathElm = moduleElm.element("module-path");
				if (modulePathElm != null) {
					module.setModulePath(modulePathElm.getTextTrim());
				}
				Element baselineElm = moduleElm.element("baseline");
				if (baselineElm != null) {
					module.setBaseline(baselineElm.getTextTrim());
				}
				Element sourceMd5 = moduleElm.element("source-md5");
				if (sourceMd5 != null) {
					module.setSourceMd5(sourceMd5.getTextTrim());
				}
				Element tempVersion = moduleElm.element("temp-version");
				if (tempVersion != null) {
					module.setTempVersion(tempVersion.getTextTrim());
				}
				Element isCustom = moduleElm.element("is-custom");
				if (isCustom != null) {
					module.setIsCustom(isCustom.getTextTrim());
				}
				Element serialNum = moduleElm.element("serial-num");
				if (serialNum != null) {
					module.setSerialNum(serialNum.getTextTrim());
				}
				Element parallelVersion = moduleElm.element("parallel-version");
				if (parallelVersion != null) {
					module.setParallelVersion(parallelVersion.getTextTrim());
				}
				description.setModule(module);
			}
		}
		return description;
	}

	/**
	 * 添加一条修改记录
	 * 
	 * @param modify
	 */
	@SuppressWarnings("unchecked")
	public void addModify(Modify modify) {
		final Element root = doc.getRootElement();
		Element modifiesElm = root.element("modifies");
		if (modifiesElm == null) {
			modifiesElm = root.addElement("modifies");
		}
		String uri = root.getNamespaceURI(); // 取得命名空间的URI
		List content = modifiesElm.content();
		Element modifyElm = DocumentFactory.getInstance().createElement(
				"modify", uri);
		// Element modifyElm = DocumentHelper.createElement("modify");
		content.add(0, modifyElm);
		// Element modifyElm = modifiesElm.addElement("modify");
		Element descriptionElm = modifyElm.addElement("description");
		if (!isEmpty(modify.getDescription())) {
			descriptionElm.setText(modify.getDescription());
		}
		if (!isEmpty(modify.getBaseline())) {
			Element baselineElm = modifyElm.addElement("baseline");
			baselineElm.setText(modify.getBaseline());
		}
		Element authorElm = modifyElm.addElement("author");
		if (!isEmpty(modify.getAuthor())) {
			authorElm.setText(modify.getAuthor());
		}
		Element revisionTimeElm = modifyElm.addElement("revision-time");
		if (modify.getRevisionTime() != null) {
			String dateStr = convertDateToString(modify.getRevisionTime(), null);
			revisionTimeElm.setText(dateStr);
		}
		Relation relation = modify.getRelation();
		if (relation != null) {
			List<String> relationModuleList = relation.getRelationModuleList();
			if (!relationModuleList.isEmpty()) {
				Element relationElm = modifyElm.addElement("relation");
				for (String relationModule : relationModuleList) {
					Element relationModuleElm = relationElm
							.addElement("relation-module");
					if (!isEmpty(relationModule)) {
						relationModuleElm.setText(relationModule);
					}
				}
			}
		}
		saveDoc();
	}

	/**
	 * 获取版本信息
	 * 
	 * @return
	 */
	public Version getVersion() {
		Version version = null;
		if (doc == null) {
			return version;
		}
		final Element root = doc.getRootElement();
		if (root != null && "version".equals(root.getName())) {
			version = new Version();
			version.setXmlns(root.getNamespaceURI());
			version.setXsi(root.getNamespaceForPrefix("xsi").getURI());
			Attribute schemaLocationAtt = root.attribute("schemaLocation");
			if (schemaLocationAtt != null) {
				version.setSchemaLocation(schemaLocationAtt.getValue());
			}
			Element modifiesElm = root.element("modifies");
			if (modifiesElm == null) {
				return version;
			}
			Modifies modifies = new Modifies();
			Iterator<?> modifyIters = modifiesElm.elementIterator("modify");
			List<Modify> modifyList = new ArrayList<Modify>();
			while (modifyIters.hasNext()) {
				Element modifyElm = (Element) modifyIters.next();
				Modify modify = getModify(modifyElm);
				if (modify != null) {
					modifyList.add(modify);
				}
			}
			modifies.setModifyList(modifyList);
			version.setModifies(modifies);
		}
		return version;
	}

	/**
	 * 根据modify节点获取修改记录
	 * 
	 * @param modifyElm
	 * @return
	 */
	private static Modify getModify(Element modifyElm) {
		if (!"modify".equals(modifyElm.getName())) {
			return null;
		}
		Modify modify = new Modify();
		Element descriptionElm = modifyElm.element("description");
		if (descriptionElm != null) {
			modify.setDescription(descriptionElm.getTextTrim());
		}
		Element authorElm = modifyElm.element("author");
		if (authorElm != null) {
			modify.setAuthor(authorElm.getTextTrim());
		}
		Element revisionTimeElm = modifyElm.element("revision-time");
		if (revisionTimeElm != null) {
			modify.setRevisionTime(convertStringToDate(revisionTimeElm
					.getTextTrim(), null));
		}
		Element relationElm = modifyElm.element("relation");
		if (relationElm != null) {
			Iterator<?> relationModuleIters = relationElm
					.elementIterator("relation-module");
			Relation relation = new Relation();
			List<String> relationModuleList = relation.getRelationModuleList();
			while (relationModuleIters.hasNext()) {
				Element relationModuleElm = (Element) relationModuleIters
						.next();
				if (relationModuleElm != null) {
					relationModuleList.add(relationModuleElm.getTextTrim());
				}
			}
			modify.setRelation(relation);
		}
		Element baselineElm = modifyElm.element("baseline");
		if (baselineElm != null) {
			modify.setBaseline(baselineElm.getTextTrim());
		}
		return modify;
	}

	/**
	 * 获取所有的修改记录
	 * 
	 * @return
	 */
	public List<Modify> getVersionModify() {
		List<Modify> modifyList = new ArrayList<Modify>();
		List<?> rtnList = getVersionModifyElement();
		for (int i = 0; i < rtnList.size(); i++) {
			Element element = (Element) rtnList.get(i);
			Modify modify = getModify(element);
			if (modify != null) {
				modifyList.add(modify);
			}
		}
		return modifyList;
	}

	private List<?> getVersionModifyElement() {
		final Element root = doc.getRootElement();
		String uri = root.getNamespaceURI(); // 取得命名空间的URI
		Map<String, String> nsMap = new HashMap<String, String>();
		nsMap.put("ns", uri);
		XPath x = doc.createXPath("/ns:version/ns:modifies/ns:modify");
		x.setNamespaceURIs(nsMap);
		List<?> rtnList = x.selectNodes(doc);
		return rtnList;
	}

	/**
	 * 修改版本信息
	 * 
	 * @param version
	 */
	public void setVersion(Version version) {
		doc = DocumentHelper.createDocument();
		setVersion(doc, version);
		saveDoc();
	}

	private static void setVersion(Document document, Version version) {
		Element root = document.addElement("version", version.getXmlns());
		root.addNamespace("xsi", version.getXsi());
		root.addAttribute("xsi:schemaLocation", version.getSchemaLocation());
		setModifies(version, root);
	}

	private static void setModifies(Version version, Element root) {
		Modifies modifies = version.getModifies();
		if (modifies != null) {
			Element modifiesElm = addElement(root, "modifies", null);
			List<Modify> modifyList = modifies.getModifyList();
			for (Modify modify : modifyList) {
				Element modifyElm = addElement(modifiesElm, "modify", null);
				addElement(modifyElm, "description", modify.getDescription());
				addElement(modifyElm, "author", modify.getAuthor());
				addElement(modifyElm, "revision-time", convertDateToString(
						modify.getRevisionTime(), null));
				Relation relation = modify.getRelation();
				if (relation != null) {
					List<String> relationModuleList = relation
							.getRelationModuleList();
					if (!relationModuleList.isEmpty()) {
						Element relationElm = addElement(modifyElm, "relation",
								null);
						for (String relationModule : relationModuleList) {
							addElement(relationElm, "relation-module",
									relationModule);
						}
					}
				}
				if (modify.getBaseline() != null) {
					addElement(modifyElm, "baseline", modify.getBaseline());
				}
			}
		}
	}

	/**
	 * XML文本内容
	 * 
	 * @return
	 */
	public String asXMl() {
		if (doc == null) {
			return null;
		}
		StringWriter out = new StringWriter();
		XMLWriter xmlWriter = new XMLWriter(out, createOutputFormat());
		try {
			xmlWriter.write(doc);
			xmlWriter.flush();
		} catch (IOException e) {
			logger.error("doc转xml字符串失败!", e);
			throw new RuntimeException("doc转xml字符串失败!", e);
		} finally {
			if (xmlWriter != null) {
				try {
					xmlWriter.close();
				} catch (IOException e) {
				}
			}
		}
		return out.toString();
	}

	public static String asXMl(Version version) {
		Document document = DocumentHelper.createDocument();
		setVersion(document, version);
		StringWriter out = new StringWriter();
		XMLWriter xmlWriter = new XMLWriter(out, createOutputFormat());
		try {
			xmlWriter.write(document);
			xmlWriter.flush();
		} catch (IOException e) {
			logger.error("doc转xml字符串失败!", e);
			throw new RuntimeException("doc转xml字符串失败!", e);
		} finally {
			if (xmlWriter != null) {
				try {
					xmlWriter.close();
				} catch (IOException e) {
				}
			}
		}
		return out.toString();
	}

	private static OutputFormat createOutputFormat() {
		OutputFormat format = new OutputFormat();
		format.setNewLineAfterDeclaration(false);
		format.setIndent("\t");
		format.setNewlines(true);
		format.setTrimText(true);
		format.setPadText(false);
		return format;
	}

	/**
	 * 清空doc缓存
	 */
	public void clearDocCache() {
		docCache.clear();
	}

	public static final String DATE_FORMAT = "yyyy-MM-dd";

	public static Date convertStringToDate(String strDate, String pattern) {
		if (isEmpty(strDate))
			return null;
		if (isEmpty(pattern))
			pattern = DATE_FORMAT;
		SimpleDateFormat df = new SimpleDateFormat(pattern);
		try {
			return df.parse(strDate);
		} catch (ParseException e) {
			logger.error("时间转换出错!" + "时间：" + strDate + "; 格式：" + pattern, e);
			throw new RuntimeException(e);
		}
	}

	public static Date convertStringToDate(String strDate) {
		return convertStringToDate(strDate, null);
	}

	public static String convertDateToString(Date aDate, String pattern) {
		if (aDate == null)
			return null;
		if (isEmpty(pattern))
			pattern = DATE_FORMAT;
		SimpleDateFormat df = new SimpleDateFormat(pattern);
		return df.format(aDate);
	}

	public static String convertDateToString(Date aDate) {
		return convertDateToString(aDate, null);
	}

	/*
	 * 添加xml子节点
	 * 
	 * @param elementParent
	 * 
	 * @param elementName
	 * 
	 * @param elementValue
	 * 
	 * @return
	 */
	private static Element addElement(Element elementParent,
			String elementName, String elementValue) {
		Element element = null;
		if (elementParent == null || isEmpty(elementName)) {
			return element;
		}
		element = elementParent.addElement(elementName);
		if (elementValue != null) {
			element.setText(elementValue);
		}
		return element;
	}

	/*
	 * 移除xml子节点
	 * 
	 * @param elementParent
	 * 
	 * @param elementName
	 * 
	 * @return
	 */
	private static Element removeElement(Element elementParent,
			String elementName) {
		if (elementParent == null || isEmpty(elementName)) {
			return null;
		}
		if (elementParent.element(elementName) != null) {
			elementParent.remove(elementParent.element(elementName));
		}
		return elementParent;
	}

	private static boolean isEmpty(String str) {
		return str == null || str.length() == 0;
	}

	/*
	 * 获取路径
	 * 
	 * @param fileName
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	private static URL getFileURL(String fileName) throws Exception {
		// 从本类CLASSLOADER相应路径中读取文件
		URL fileURL = VersionXMLUtil.class.getClassLoader().getResource(
				fileName);
		if (fileURL == null) {
			fileURL = VersionXMLUtil.class.getClassLoader().getResource(
					"/" + fileName);
		}
		if (fileURL == null) {
			fileURL = Thread.currentThread().getContextClassLoader()
					.getResource(fileName);
		}
		if (fileURL == null) {
			fileURL = ClassLoader.getSystemResource(fileName);
		}
		if (fileURL == null) {
			fileURL = new File(fileName).toURL();
		}
		return fileURL;
	}

	/*
	 * 获取文件
	 * 
	 * @param fileName
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	private static File getFile(String fileName) throws Exception {
		return new File(getFileURL(fileName).getFile());
	}

}
