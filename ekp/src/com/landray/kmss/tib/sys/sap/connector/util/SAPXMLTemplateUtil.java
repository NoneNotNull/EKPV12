package com.landray.kmss.tib.sys.sap.connector.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.events.XMLEvent;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcExportService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcImportService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcTableService;
import com.landray.kmss.tib.sys.sap.constant.MessageConstants;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterField;
import com.sap.conn.jco.JCoParameterFieldIterator;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRecordField;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;

/**
 * 
 * @author 用来存放对XML约定模板的解析,构造XML,以及属性检测 主要提供TibSystibSystibSysSapJcoFunctionUtil 类使用
 */
public class SAPXMLTemplateUtil {
	
	// 用来存储是否启用需要用到的数据
	public static ConcurrentHashMap<String, Map<String, String>> useMapStroe = 
		new ConcurrentHashMap<String, Map<String, String>>();
	
	/**
	 * XML字符转Document 
	 * 
	 * @param xmlstr
	 * @return
	 */
	public static Document getElement(String xmlstr) {
		try {
			
			StringReader sr = new StringReader(xmlstr);
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

	/**
	 * JCOFunction 转换成XML
	 * 
	 * @param writer
	 * @param function
	 * @param eventFactory
	 * @param Id
	 * @return
	 * @throws Exception
	 */
	public static XMLEventWriter parseFunction4XML(XMLEventWriter writer,
			JCoFunction function, XMLEventFactory eventFactory, String Id,
			Integer i) throws Exception {
		// getting instance of writer
		// XMLEventWriter writer =
		// factory.createXMLEventWriter(stringWriter);
		writeStartDocument(writer, eventFactory);
		writeCharacters(writer, "\n", eventFactory);
		writeStartElement(writer, MessageConstants.JCO, eventFactory);
		writeAttribute(writer, MessageConstants.JCO_ATTR_ID, Id, eventFactory);
		// writing NAME
		writeAttribute(writer, MessageConstants.JCO_ATTR_NAME, function
				.getName(), eventFactory);
		// writing TIMESTAMP
		writeAttribute(writer, MessageConstants.JCO_ATTR_TIMESTAMP, String
				.valueOf(new Date().getTime()), eventFactory);
		// writing VERSION
		writeAttribute(writer, MessageConstants.JCO_ATTR_VERSION,
				MessageConstants.JCO_ATTR_VERSION_VALUE, eventFactory);

		// writing Import

		writeCharacters(writer, "\n", eventFactory);
		writeImportElement(writer, function, Id, eventFactory);

		// writing Export
		writeCharacters(writer, "\n", eventFactory);
		writeExportElement(writer, function, Id, eventFactory);

		// writing Tables

		writeCharacters(writer, "\n", eventFactory);
		if (i != null) {
			writeTablesElement(writer, function, Id, i, eventFactory);
		} else {
			writeTablesElement(writer, function, Id, eventFactory);
		}

		// writing JCO end element
		writeEndElement(writer, MessageConstants.JCO, eventFactory);

		// close document

		writeEndDocument(writer, eventFactory);
		writer.flush();
		return writer;
	}

	public static XMLEventWriter parseFunction4XML(XMLEventWriter writer,
			JCoFunction function, XMLEventFactory eventFactory, String Id)
			throws Exception {

		return parseFunction4XML(writer, function, eventFactory, Id, null);
	}

	public static XMLEventWriter writeStartDocument(XMLEventWriter writer,
			XMLEventFactory eventFactory) throws XMLStreamException {
		XMLEvent event = eventFactory
				.createStartDocument(MessageConstants.JCO_CODE);
		writer.add(event);
		return writer;
	}

	public static void writeAttribute(XMLEventWriter writer, String key,
			String value, XMLEventFactory eventFactory)
			throws XMLStreamException {
		XMLEvent event = eventFactory.createAttribute(key, null == value
				|| "".equals(value) ? "" : value);
		writer.add(event);
	}

	public static void writeStartElement(XMLEventWriter writer,
			String elementName, XMLEventFactory eventFactory)
			throws XMLStreamException {
		XMLEvent event = eventFactory.createStartElement("", "", elementName);
		writer.add(event);
	}

	public static void writeCharacters(XMLEventWriter writer,
			String characters, XMLEventFactory eventFactory)
			throws XMLStreamException {
		XMLEvent event = eventFactory.createCharacters(characters);
		writer.add(event);
	}

	public static void writeImportElement(XMLEventWriter writer,
			JCoFunction function, String Id, XMLEventFactory eventFactory)
			throws Exception {

		writeStartElement(writer, MessageConstants.IMPORT, eventFactory);

		// writing inside of IMPORT
		writeParameterList(writer, function.getImportParameterList(), Id,
				"import", eventFactory);
		writeEndElement(writer, MessageConstants.IMPORT, eventFactory);
	}

	public static void writeExportElement(XMLEventWriter writer,
			JCoFunction function, String Id, XMLEventFactory eventFactory)
			throws Exception {
		writeStartElement(writer, MessageConstants.EXPORT, eventFactory);
		// writing inside of EXPORT
		writeParameterList(writer, function.getExportParameterList(), Id,
				"export", eventFactory);
		writeEndElement(writer, MessageConstants.EXPORT, eventFactory);
	}

	public static void writeTablesElement(XMLEventWriter writer,
			JCoFunction function, String Id, XMLEventFactory eventFactory)
			throws Exception {

		writeStartElement(writer, MessageConstants.TABLES, eventFactory);
		// writing inside of TABLES
		writeTableParameterList(writer, function.getTableParameterList(), Id,
				"tables", eventFactory);

		writeEndElement(writer, MessageConstants.TABLES, eventFactory);
	}

	public static void writeTablesElement(XMLEventWriter writer,
			JCoFunction function, String Id, int i, XMLEventFactory eventFactory)
			throws Exception {
		writeStartElement(writer, MessageConstants.TABLES, eventFactory);
		// writing inside of TABLES
		writeTableParameterList(writer, function.getTableParameterList(), Id,
				"tables", i, eventFactory);
		writeEndElement(writer, MessageConstants.TABLES, eventFactory);
	}

	public static void writeEndDocument(XMLEventWriter writer,
			XMLEventFactory eventFactory) throws XMLStreamException {
		XMLEvent event = eventFactory.createEndDocument();
		writer.add(event);
	}

	public static void writeEndElement(XMLEventWriter writer,
			String elementName, XMLEventFactory eventFactory)
			throws XMLStreamException {
		XMLEvent event = eventFactory.createEndElement("", "", elementName);
		writer.add(event);
	}

	public static void writeParameterList(XMLEventWriter writer,
			JCoParameterList parameterList, String Id, String type,
			XMLEventFactory eventFactory) throws Exception {
		if (parameterList == null) {
			return;
		}
		String flag = "true";
		JCoParameterFieldIterator parameterFieldIterator = parameterList
				.getParameterFieldIterator();

		while (parameterFieldIterator.hasNextField()) {
			// getting STRUCTUTE or FIELD
			JCoParameterField parameterField = parameterFieldIterator
					.nextParameterField();

			if (parameterField.isStructure()) {
				// case of STRUCTURE
				String name = parameterField.getName();
				JCoStructure structure = parameterField.getStructure();
				if (StringUtil.isNotNull(Id)) {
					flag = checkUse(parameterField, Id,
							MessageConstants.STRUCTURE + type, parameterField
									.getName());
				}
				if (flag.equals("true")) {
					writeStartElement(writer, MessageConstants.STRUCTURE,
							eventFactory);
					writeAttribute(writer,
							MessageConstants.STRUCTURE_ATTR_NAME, name,
							eventFactory);

					JCoRecordFieldIterator fieldIterator = structure
							.getRecordFieldIterator();

					// process FIELDs inside STRUCTURE

					while (fieldIterator.hasNextField()) {
						JCoRecordField recordField = fieldIterator
								.nextRecordField();
						if (type.equals("import"))
							writeField(writer, recordField, parameterField
									.isOptional(), Id, "import_detail", name,
									eventFactory);
						if (type.equals("export"))
							writeField(writer, recordField, parameterField
									.isOptional(), Id, "export_detail", name,
									eventFactory);
					}
					writeEndElement(writer, MessageConstants.STRUCTURE,
							eventFactory);
				}
			} else {
				// case of FIELD
				writeField(writer, parameterField, parameterField.isOptional(),
						Id, type, parameterField.getName(), eventFactory);
			}
		}
	}

//	这里需要修正========
	public static void writeField(XMLEventWriter writer, JCoField field,
			boolean isop, String Id, String type, String name,
			XMLEventFactory eventFactory) throws Exception {
//		稳定性调整,出现加载bapi函数异常问题可能出现在这里,判断
		
		
		String flag = "true";
		String isback = "0";
		//===转换tibSysSap 必填状态 ======
		isop=!isop;
		//=========
		if (StringUtil.isNotNull(Id)) {
			flag = checkUse(field, Id, type, name);
			if ("export".equals(type))
				isback = checkBack(field, Id);
		}
		if ("true".equals(flag) || StringUtil.isNull(Id)) {
			writeStartElement(writer, MessageConstants.FIELD, eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_NAME, field
					.getName(), eventFactory);
			// modify by zhangtian 修正title非必填
			writeAttribute(writer, MessageConstants.FIELD_ATTR_TITLE,
					StringUtil.isNotNull(field.getDescription()) ? field
							.getDescription() : "", eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.CHAR)
					|| field.getTypeAsString().equals(MessageConstants.NUM)
					|| field.getTypeAsString().equals(MessageConstants.STRING))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_String, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.INT)
					|| field.getTypeAsString().equals(MessageConstants.INT1)
					|| field.getTypeAsString().equals(MessageConstants.INT2))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_int, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.BYTE)
					|| field.getTypeAsString().equals(MessageConstants.XSTRING))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_byte, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.DATE)
					|| field.getTypeAsString().equals(MessageConstants.TIME))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_date, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.BCD)
					|| field.getTypeAsString().equals(MessageConstants.DECF16)
					|| field.getTypeAsString().equals(MessageConstants.DECF34))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.BIGDECIMAL, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.FLOAT))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.DOUBLE, eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_DECIMALS,
					Integer.toString(field.getDecimals()), eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_MAXLENGTH,
					Integer.toString(field.getLength()), eventFactory);
			if (Id != null && Id != "")
				isop = checkOptional(field, Id, type, name, isop);
			if (isop)
				writeAttribute(writer, MessageConstants.FIELD_ATTR_ISOPTIONAL,
						"true", eventFactory);
			else
				writeAttribute(writer, MessageConstants.FIELD_ATTR_ISOPTIONAL,
						"false", eventFactory);

			if ("1".equals(isback)) {
				writeAttribute(writer, MessageConstants.ISBACK, "1",
						eventFactory);
			}
			writeCharacters(writer, field.getString().trim(), eventFactory);
			writeEndElement(writer, MessageConstants.FIELD, eventFactory);
		}
	}

	public static void writeFieldNoROW(XMLEventWriter writer,
			JCoField field, boolean isop, String Id, String type, String name,
			XMLEventFactory eventFactory) throws Exception {
		String flag = "true";
		if (StringUtil.isNotNull(Id)) {
			flag = checkUse(field, Id, type, name);
		}
		if (flag.equals("true") || StringUtil.isNull(Id)) {
			writeStartElement(writer, MessageConstants.FIELD, eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_NAME, field
					.getName(), eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_TITLE, field
					.getDescription(), eventFactory);

			if (field.getTypeAsString().equals(MessageConstants.CHAR)
					|| field.getTypeAsString().equals(MessageConstants.NUM)
					|| field.getTypeAsString().equals(MessageConstants.STRING))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_String, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.INT)
					|| field.getTypeAsString().equals(MessageConstants.INT1)
					|| field.getTypeAsString().equals(MessageConstants.INT2))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_int, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.BYTE)
					|| field.getTypeAsString().equals(MessageConstants.XSTRING))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_byte, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.DATE)
					|| field.getTypeAsString().equals(MessageConstants.TIME))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.java_date, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.BCD)
					|| field.getTypeAsString().equals(MessageConstants.DECF16)
					|| field.getTypeAsString().equals(MessageConstants.DECF34))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.BIGDECIMAL, eventFactory);
			if (field.getTypeAsString().equals(MessageConstants.FLOAT))
				writeAttribute(writer, MessageConstants.FIELD_ATTR_CTYPE,
						MessageConstants.DOUBLE, eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_DECIMALS,
					Integer.toString(field.getDecimals()), eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_MAXLENGTH,
					Integer.toString(field.getLength()), eventFactory);
			if (Id != null && Id != "")
				isop = checkOptional(field, Id, type, name, isop);
			if (isop)
				writeAttribute(writer, MessageConstants.FIELD_ATTR_ISOPTIONAL,
						"true", eventFactory);
			else
				writeAttribute(writer, MessageConstants.FIELD_ATTR_ISOPTIONAL,
						"false", eventFactory);
			writeEndElement(writer, MessageConstants.FIELD, eventFactory);
		}
	}

	public static void writeFieldValue(XMLEventWriter writer,
			JCoField field, boolean isop, String Id, String type, String name,
			XMLEventFactory eventFactory) throws Exception {
		String flag = "true";
		if (StringUtil.isNotNull(Id)) {
			flag = checkUse(field, Id, type, name);
		}
		if (flag.equals("true") || StringUtil.isNull(Id)) {
			writeStartElement(writer, MessageConstants.FIELD, eventFactory);
			writeAttribute(writer, MessageConstants.FIELD_ATTR_NAME, field
					.getName(), eventFactory);
			writeCharacters(writer, field.getString().trim(), eventFactory);
			writeEndElement(writer, MessageConstants.FIELD, eventFactory);
		}
	}

	public static void writeTableParameterList(XMLEventWriter writer,
			JCoParameterList parameterList, String Id, String type,
			XMLEventFactory eventFactory) throws Exception {
		if (parameterList == null) {
			return;
		}
		String flag = "true";
		String isin = "";
		JCoParameterFieldIterator parameterFieldIterator = parameterList
				.getParameterFieldIterator();

		while (parameterFieldIterator.hasNextField()) {

			// System.out.println("tibSysSap================");
			JCoParameterField parameterField = parameterFieldIterator
					.nextParameterField();
			JCoTable jcoTable = parameterField.getTable();
			if (StringUtil.isNotNull(Id)) {
				flag = checkUse(parameterField, Id, "table", parameterField
						.getName());
			}
			if (flag.equals("true")) {
				writeStartElement(writer, MessageConstants.TABLE, eventFactory);
				if (StringUtil.isNotNull(Id)) {
					isin = getPamType(Id, parameterField.getName());
				}
				writeAttribute(writer, MessageConstants.TABLE_ATTR_NAME,
						parameterField.getName(), eventFactory);
				writeAttribute(writer, MessageConstants.TABLE_ISIN, isin,
						eventFactory);
				int numRows = jcoTable.getNumRows();
				if (numRows == 0) {
					writeAttribute(writer, MessageConstants.TABLE_ROW, String
							.valueOf(numRows), eventFactory);

					writeStartElement(writer, MessageConstants.ROW,
							eventFactory);
					writeAttribute(writer, MessageConstants.ROW_ATTR_ID, "0",
							eventFactory);
					JCoFieldIterator iterator = jcoTable.getFieldIterator();
					while (iterator.hasNextField()) {
						JCoField recordField = iterator.nextField();
						writeFieldNoROW(writer, recordField, parameterField
								.isOptional(), Id, type, parameterField
								.getName(), eventFactory);
					}
					writeEndElement(writer, MessageConstants.ROW, eventFactory);
				}
				for (int i = 0; i < numRows; i++) {
					// System.out.println("tibSysSap_row================" + i);
					jcoTable.setRow(i);
					if (i == 0) {
						writeAttribute(writer, MessageConstants.TABLE_ROW,
								String.valueOf(numRows), eventFactory);

						writeStartElement(writer, MessageConstants.ROW,
								eventFactory);
						writeAttribute(writer, MessageConstants.ROW_ATTR_ID,
								"0", eventFactory);
						JCoFieldIterator iterator = jcoTable.getFieldIterator();
						while (iterator.hasNextField()) {
							// System.out.println(parameterField.getName()+"JCoFieldIterator");
							JCoField recordField = iterator.nextField();
							writeField(writer, recordField, parameterField
									.isOptional(), Id, type, parameterField
									.getName(), eventFactory);
						}
						writeEndElement(writer, MessageConstants.ROW,
								eventFactory);
					} else {
						writeStartElement(writer, MessageConstants.ROW,
								eventFactory);
						writeAttribute(writer, MessageConstants.ROW_ATTR_ID,
								String.valueOf(i), eventFactory);
						JCoRecordFieldIterator iteratorNew = jcoTable
								.getRecordFieldIterator();
						while (iteratorNew.hasNextField()) {
							JCoRecordField recordField = iteratorNew
									.nextRecordField();
							writeFieldValue(writer, recordField, parameterField
									.isOptional(), Id, type, parameterField
									.getName(), eventFactory);
						}
						writeEndElement(writer, MessageConstants.ROW,
								eventFactory);
					}
				}
				writeEndElement(writer, MessageConstants.TABLE, eventFactory);
			}
		}
	}

	public static void writeTableParameterList(XMLEventWriter writer,
			JCoParameterList parameterList, String Id, String type, int num,
			XMLEventFactory eventFactory) throws Exception {
		if (parameterList == null) {
			return;
		}
		String flag = "true";
		String isin = "";
		JCoParameterFieldIterator parameterFieldIterator = parameterList
				.getParameterFieldIterator();

		while (parameterFieldIterator.hasNextField()) {
			JCoParameterField parameterField = parameterFieldIterator
					.nextParameterField();
			JCoTable jcoTable = parameterField.getTable();
			if (StringUtil.isNotNull(Id)) {
				flag = checkUse(parameterField, Id, "table", parameterField
						.getName());
			}
			if (flag.equals("true")) {
				writeStartElement(writer, MessageConstants.TABLE, eventFactory);
				if (StringUtil.isNotNull(Id)) {
					isin = getPamType(Id, parameterField.getName());
				}
				writeAttribute(writer, MessageConstants.TABLE_ATTR_NAME,
						parameterField.getName(), eventFactory);
				writeAttribute(writer, MessageConstants.TABLE_ISIN, isin,
						eventFactory);
				int numRows = jcoTable.getNumRows();
				if (numRows == 0) {
					writeAttribute(writer, MessageConstants.TABLE_ROW, String
							.valueOf(numRows), eventFactory);

					writeStartElement(writer, MessageConstants.ROW,
							eventFactory);
					writeAttribute(writer, MessageConstants.ROW_ATTR_ID, "0",
							eventFactory);
					JCoFieldIterator iterator = jcoTable.getFieldIterator();
					while (iterator.hasNextField()) {
						JCoField recordField = iterator.nextField();
						writeFieldNoROW(writer, recordField, parameterField
								.isOptional(), Id, type, parameterField
								.getName(), eventFactory);
					}
					writeEndElement(writer, MessageConstants.ROW, eventFactory);
				}
				for (int i = 0; i < numRows && i < num; i++) {
					jcoTable.setRow(i);
					if (i == 0) {
						writeAttribute(writer, MessageConstants.TABLE_ROW,
								String.valueOf(numRows), eventFactory);

						writeStartElement(writer, MessageConstants.ROW,
								eventFactory);
						writeAttribute(writer, MessageConstants.ROW_ATTR_ID,
								"0", eventFactory);
						JCoFieldIterator iterator = jcoTable.getFieldIterator();
						while (iterator.hasNextField()) {
							JCoField recordField = iterator.nextField();
							writeField(writer, recordField, parameterField
									.isOptional(), Id, type, parameterField
									.getName(), eventFactory);
						}
						writeEndElement(writer, MessageConstants.ROW,
								eventFactory);
					} else {
						writeStartElement(writer, MessageConstants.ROW,
								eventFactory);
						writeAttribute(writer, MessageConstants.ROW_ATTR_ID,
								String.valueOf(i), eventFactory);
						for (JCoRecordFieldIterator iteratorNew = jcoTable
								.getRecordFieldIterator();iteratorNew.hasNextField();) {
							JCoRecordField recordField = iteratorNew
									.nextRecordField();
							writeFieldValue(writer, recordField, parameterField
									.isOptional(), Id, type, parameterField
									.getName(), eventFactory);
						}
						writeEndElement(writer, MessageConstants.ROW,
								eventFactory);
					}
				}
				writeEndElement(writer, MessageConstants.TABLE, eventFactory);
			}
		}
	}

	public static void writeImportFiled(XMLEventWriter writer, Object key,
			Object value, XMLEventFactory eventFactory)
			throws XMLStreamException {
		writeStartElement(writer, MessageConstants.FIELD, eventFactory);
		writeAttribute(writer, MessageConstants.FIELD_ATTR_NAME,
				key.toString(), eventFactory);
		writeCharacters(writer, value.toString().trim(), eventFactory);
		writeEndElement(writer, MessageConstants.FIELD, eventFactory);

	}

	public static void writeImportStructure(XMLEventWriter writer,
			Object key, Object value, XMLEventFactory eventFactory)
			throws XMLStreamException {
		writeStartElement(writer, MessageConstants.STRUCTURE, eventFactory);
		writeAttribute(writer, MessageConstants.STRUCTURE_ATTR_NAME, key
				.toString(), eventFactory);
		JSONObject structrueList = JSONObject.fromObject(value);
		Iterator<?> jsonList = structrueList.keys();
		while (jsonList.hasNext()) {
			Object name = jsonList.next();
			Object field = structrueList.get(name);
			writeImportFiled(writer, name, field, eventFactory);
		}
		writeEndElement(writer, MessageConstants.STRUCTURE, eventFactory);
	}

	public static void writeImportTable(XMLEventWriter writer,
			Object tablekey, Object tablevalue, XMLEventFactory eventFactory)
			throws XMLStreamException {
		writeStartElement(writer, MessageConstants.TABLE, eventFactory);
		writeAttribute(writer, MessageConstants.TABLE_ATTR_NAME, tablekey
				.toString(), eventFactory);
		// ====默认传入参数isin 为 1=====
		writeAttribute(writer, MessageConstants.TABLE_ISIN, "1", eventFactory);
		// ===========
		JSONArray table = JSONArray.fromObject(tablevalue);
		writeAttribute(writer, MessageConstants.TABLE_ROW, Integer
				.toString(table.size()), eventFactory);
		for (int i = 0; i < table.size(); i++) {
			writeStartElement(writer, MessageConstants.ROW, eventFactory);
			writeAttribute(writer, MessageConstants.ROW_ATTR_ID, Integer
					.toString(i), eventFactory);
			JSONObject tableRow = JSONObject.fromObject(table.get(i));
			Iterator<?> jsonList = tableRow.keys();
			while (jsonList.hasNext()) {
				Object name = jsonList.next();
				Object field = tableRow.get(name);
				writeImportFiled(writer, name, field, eventFactory);
			}
			writeEndElement(writer, MessageConstants.ROW, eventFactory);
		}
		writeEndElement(writer, MessageConstants.TABLE, eventFactory);
	}

	public static String getAttributeValue(String name, XMLStreamReader reader) {
		String value = reader.getAttributeValue(reader.getNamespaceURI(), name);
//		int count = reader.getAttributeCount();
//		for (int i = 0; i < count; i++) {
//			if (reader.getAttributeLocalName(i).equals(name)) {
//				String value = reader.getAttributeValue(i);
//				return value;
//			}
//		}
		return value;
	}

	public static void setStoreValue(String funcId, String name, String useValue) {
		Map<String, String> useMap = useMapStroe.get(funcId);
		useMap.put(name, useValue);
	}
	
	public static String getStoreValue(String funcId, String name) {
		Map<String, String> useMap = useMapStroe.get(funcId);
		// 如果缓存中没有，那么存入缓存
		if (useMap != null && !useMap.isEmpty()) {
			return useMap.get(name);
		} else {
			useMap = new HashMap<String, String>();
			useMapStroe.put(funcId, useMap);
			return null;
		}
	}
	
	/**
	 * 检验参数的启用属性
	 * 
	 */
	public static String checkUse(JCoField field, String fdId, String type,
			String name) throws Exception {
		String flag = "false";
		InputStream is = null;
		XMLInputFactory factory = null;
		XMLStreamReader reader = null;
		if ("import".equals(type)) {
			Boolean fdUse = false;
			String value = getStoreValue(fdId, field.getName());
			if (StringUtil.isNotNull(value)) {
				if ("true".equals(value)) {
					fdUse = true;
				}
			} else {
				ITibSysSapRfcImportService tibSysSapRfcImportService = (ITibSysSapRfcImportService) SpringBeanUtil
					.getBean("tibSysSapRfcImportService");
				fdUse =tibSysSapRfcImportService.checkIsUse(fdId, field.getName());
				// 没有缓存则新增缓存
				setStoreValue(fdId, field.getName(), fdUse ? "true" : "false");
			}
			if (fdUse != null && fdUse)
				flag = "true";
		} else if ("structureimport".equals(type)) {
			Boolean fdUse = false;
			String value = getStoreValue(fdId, name);
			if (StringUtil.isNotNull(value)) {
				if ("true".equals(value)) {
					fdUse = true;
				}
			} else {
				ITibSysSapRfcImportService tibSysSapRfcImportService = (ITibSysSapRfcImportService) SpringBeanUtil
						.getBean("tibSysSapRfcImportService");
				fdUse = tibSysSapRfcImportService.checkIsUse(fdId, name);
				// 没有缓存则新增缓存
				setStoreValue(fdId, name, fdUse ? "true" : "false");
			}
			if (fdUse)
				flag = "true";
		} else if ("import_detail".equals(type)) {
			String xml = getStoreValue(fdId, name +"_xml");
			if (StringUtil.isNull(xml)) {
				ITibSysSapRfcImportService tibSysSapRfcImportService = (ITibSysSapRfcImportService) SpringBeanUtil
					.getBean("tibSysSapRfcImportService");
				xml =(String)tibSysSapRfcImportService.getFdRfcParamXml(fdId, name);
				// 没有缓存则新增缓存
				setStoreValue(fdId, name +"_xml", xml);
			}
			factory = XMLInputFactory.newInstance();
			is = new ByteArrayInputStream(xml.toString().getBytes("utf-8"));
			reader = factory.createXMLStreamReader(is);
			flag = checkXmlUse(reader, field.getName());
		} else if ("export".equals(type)) {
			Boolean fdUse = false;
			String value = getStoreValue(fdId, name);
			// 判断缓存中有没有
			if (StringUtil.isNotNull(value)) {
				if ("true".equals(value)) {
					fdUse = true;
				}
			} else {
				ITibSysSapRfcExportService tibSysSapRfcExportService = (ITibSysSapRfcExportService) SpringBeanUtil
					.getBean("tibSysSapRfcExportService");
				fdUse =tibSysSapRfcExportService.checkIsUse(fdId, name);
				// 没有缓存则新增缓存
				setStoreValue(fdId, name, fdUse ? "true" : "false");
			}
			if (fdUse)
				flag = "true";
		} else if ("structureexport".equals(type)) {
			Boolean fdUse = false;
			String value = getStoreValue(fdId, name);
			// 判断缓存中有没有
			if (StringUtil.isNotNull(value)) {
				if ("true".equals(value)) {
					fdUse = true;
				}
			} else {
				ITibSysSapRfcExportService tibSysSapRfcExportService = (ITibSysSapRfcExportService) SpringBeanUtil
					.getBean("tibSysSapRfcExportService");
				fdUse =  tibSysSapRfcExportService.checkIsUse(fdId, name);
				// 没有缓存则新增缓存
				setStoreValue(fdId, name, fdUse ? "true" : "false");
			}
			
			if (fdUse)
				flag = "true";
		} else if ("export_detail".equals(type)) {
			// 取缓存
			String xml = getStoreValue(fdId, name +"_xml");
			if (StringUtil.isNull(xml)) {
				ITibSysSapRfcExportService tibSysSapRfcExportService = (ITibSysSapRfcExportService) SpringBeanUtil
						.getBean("tibSysSapRfcExportService");
				xml = tibSysSapRfcExportService.getFdRfcParamXml(fdId,name);
				// 没有缓存则新增缓存
				setStoreValue(fdId, name +"_xml", xml);
			}
			factory = XMLInputFactory.newInstance();
			is = new ByteArrayInputStream(xml.toString().getBytes("utf-8"));
			reader = factory.createXMLStreamReader(is);
			flag = checkXmlUse(reader, field.getName());
		} else if ("table".equals(type)) {
			Boolean fdUse = false;
			String value = getStoreValue(fdId, name);
			// 判断缓存中有没有
			if (StringUtil.isNotNull(value)) {
				if ("true".equals(value)) {
					fdUse = true;
				}
			} else {
				ITibSysSapRfcTableService tibSysSapRfcTableService = (ITibSysSapRfcTableService) SpringBeanUtil
						.getBean("tibSysSapRfcTableService");
				fdUse =  tibSysSapRfcTableService.checkIsUse(fdId, field.getName());
				// 没有缓存则新增缓存
				setStoreValue(fdId, name, fdUse ? "true" : "false");
			}
			if (fdUse)
				flag = "true";
		} else if ("tables".equals(type)) {
			// 取缓存
			String xml = getStoreValue(fdId, name +"_xml");
			if (StringUtil.isNull(xml)) {
				ITibSysSapRfcTableService tibSysSapRfcTableService = (ITibSysSapRfcTableService) SpringBeanUtil
						.getBean("tibSysSapRfcTableService");
				xml =  tibSysSapRfcTableService.getFdRfcParamXml(fdId, name);
				// 没有缓存则新增缓存
				setStoreValue(fdId, name +"_xml", xml);
			}
			factory = XMLInputFactory.newInstance();
			is = new ByteArrayInputStream(xml.toString().getBytes("utf-8"));
			reader = factory.createXMLStreamReader(is);
			flag = checkXmlUse(reader, field.getName());
		}

		return flag;
	}

	public static String checkXmlUse(XMLStreamReader reader, String name)
			throws XMLStreamException {
		String flag = "false";
		try{
			while (reader.hasNext()) {
				int eventType = reader.next();
				if (XMLStreamReader.START_ELEMENT == eventType) {
					String localName = reader.getLocalName();
					if (MessageConstants.FIELD.equals(localName)) {
						if (getAttributeValue("name", reader).equals(name)) {
							if ("true".equals(getAttributeValue("use", reader))) {
								flag = "true";
								break;
							}
						}
					}
				}
				
			}
			return flag;
		} catch (Exception e) {
			return flag;
		}
		
	}

	public static String checkBack(JCoField field, String fdId)
			throws Exception {
		String isback="";
		ITibSysSapRfcExportService tibSysSapRfcExportService = (ITibSysSapRfcExportService) SpringBeanUtil
				.getBean("tibSysSapRfcExportService");

		HQLInfo hqlInfo= new HQLInfo() ;
		hqlInfo.setSelectBlock(" fdReturnFlag ");
		hqlInfo.setWhereBlock(" fdFunction.fdId= :fdId and fdParameterName =:fdParameterName ");
		hqlInfo.setParameter("fdId", fdId);
		hqlInfo.setParameter("fdParameterName",  field.getName() );
		
		isback =(String)tibSysSapRfcExportService.findFirstValue(hqlInfo);
		
//		isback = (String) tibSysSapRfcExportService.findValue(
//				"fdReturnFlag",
//				"fdFunction.fdId='" + fdId + "' and fdParameterName='"
//						+ field.getName() + "'", null).get(0);
		return isback;
	}

	/**
	 * 检验参数的必填属性
	 * 
	 */
	public static boolean checkOptional(JCoField field, String fdId,
			String type, String name, Boolean isop) throws Exception {
		InputStream is = null;
		XMLInputFactory factory = null;
		XMLStreamReader reader = null;
		if ("import".equals(type)) {
			ITibSysSapRfcImportService tibSysSapRfcImportService = (ITibSysSapRfcImportService) SpringBeanUtil
					.getBean("tibSysSapRfcImportService");
			
			HQLInfo hqlInfo= new HQLInfo() ;
			hqlInfo.setSelectBlock(" fdParameterRequired ");
			hqlInfo.setWhereBlock(" fdFunction.fdId= :fdId and fdParameterName =:fdParameterName ");
			hqlInfo.setParameter("fdId", fdId);
			hqlInfo.setParameter("fdParameterName",  field.getName() );
			
//			isop = (Boolean) tibSysSapRfcImportService.findValue(
//					"fdParameterRequired",
//					"fdFunction.fdId='" + fdId + "' and fdParameterName='"
//							+ field.getName() + "'", null).get(0);
			isop = (Boolean) tibSysSapRfcImportService.findFirstValue(hqlInfo);
			

		}
		if ("structureimport".equals(type)) {
			ITibSysSapRfcImportService tibSysSapRfcImportService = (ITibSysSapRfcImportService) SpringBeanUtil
					.getBean("tibSysSapRfcImportService");
			
			HQLInfo hqlInfo= new HQLInfo() ;
			hqlInfo.setSelectBlock(" fdParameterRequired ");
			hqlInfo.setWhereBlock(" fdFunction.fdId= :fdId and fdParameterName =:fdParameterName ");
			hqlInfo.setParameter("fdId", fdId);
			hqlInfo.setParameter("fdParameterName",  field.getName() );
			
			isop =(Boolean)tibSysSapRfcImportService.findFirstValue(hqlInfo);
			
//			isop = (Boolean) tibSysSapRfcImportService.findValue(
//					"fdParameterRequired",
//					"fdFunction.fdId='" + fdId + "' and fdParameterName='"
//							+ name + "'", null).get(0);
		}
		if ("import_detail".equals(type)) {
			ITibSysSapRfcImportService tibSysSapRfcImportService = (ITibSysSapRfcImportService) SpringBeanUtil
					.getBean("tibSysSapRfcImportService");
			
			String xml =tibSysSapRfcImportService.getFdRfcParamXml(fdId, name);
			
//			String xml = (String) tibSysSapRfcImportService.findValue(
//					"fdRfcParamXml",
//					"fdFunction.fdId='" + fdId + "' and fdParameterName='"
//							+ name + "'", null).get(0);
			factory = XMLInputFactory.newInstance();
			is = new ByteArrayInputStream(xml.toString().getBytes("utf-8"));
			reader = factory.createXMLStreamReader(is);
			isop = checkXmlIsop(reader, field.getName(), isop);
		}
		return isop;
	}

	public static Boolean checkXmlIsop(XMLStreamReader reader, String name,
			Boolean isop) throws XMLStreamException {
		while (reader.hasNext()) {
			int eventType = reader.next();
			if (eventType == XMLStreamReader.START_ELEMENT) {
				String localName = reader.getLocalName();
				if (localName.equals(MessageConstants.FIELD)) {
					if (getAttributeValue("name", reader).equals(name)) {
						if ("true".equals(
								getAttributeValue("isoptional", reader))) {
							isop = true;
						} else {
							isop = false;
						}
					}
				}
			}
		}
		return isop;
	}

	public static String checkSuccess(Object object) throws Exception {
		Document fromDocument = getElement(object.toString());
		NodeList nodeList = fromDocument.getElementsByTagName("export").item(0)
				.getChildNodes();
		Node jcoNode = fromDocument.getElementsByTagName("jco").item(0);
		String fdId = jcoNode.getAttributes().getNamedItem(
				MessageConstants.JCO_ATTR_ID).getNodeValue();
		String flag = "1";
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			if (node.getNodeName().equals(MessageConstants.FIELD)) {
				String name = node.getAttributes().getNamedItem("name")
						.getNodeValue();
				String text = node.getTextContent();
				flag = checkIsBack(name, text, fdId);
				if ("0".equals(flag))
					return flag;
			}
		}
		return flag;
	}

	public static String checkIsBack(String name, String text, String fdId)
			throws Exception {
		String isback;
		String flag = "1";
		ITibSysSapRfcExportService tibSysSapRfcExportService = (ITibSysSapRfcExportService) SpringBeanUtil
				.getBean("tibSysSapRfcExportService");
		
		HQLInfo hqlInfo=new HQLInfo();
		hqlInfo.setSelectBlock(" fdReturnFlag ");
		hqlInfo.setWhereBlock(" fdFunction.fdId =:fdId and fdParameterName= :fdParameterName ");
		hqlInfo.setParameter("fdId", fdId);
		hqlInfo.setParameter("fdParameterName", name);
		isback =(String)tibSysSapRfcExportService.findFirstValue(hqlInfo);
		
//		isback = (String) tibSysSapRfcExportService.findValue(
//				"fdReturnFlag",
//				"fdFunction.fdId='" + fdId + "' and fdParameterName='" + name
//						+ "'", null).get(0);
		
		
//		if (isback.equals("1")) {
		if ("1".equals(isback)) {
//			String content = (String) tibSysSapRfcExportService.findValue(
//					"fdSuccess",
//					"fdFunction.fdId='" + fdId + "' and fdParameterName='"
//							+ name + "'", null).get(0);
			
			HQLInfo hql=new HQLInfo();
			hql.setSelectBlock(" fdSuccess ");
			hql.setWhereBlock(" fdFunction.fdId =:fdId and fdParameterName= :fdParameterName ");
			hql.setParameter("fdId", fdId);
			hql.setParameter("fdParameterName", name);
			
			String content = (String) tibSysSapRfcExportService.findFirstValue(hqlInfo);
			
			
//          空值校验
			if (StringUtil.isNull(text)) {
				flag = "0";
			} else {
				if (text.equals(content))
					flag = "1";
				else {
					flag = "0";
				}
			}
		}
		return flag;
	}

	/**
	 * 检验table的传入传出属性
	 * 
	 */
	public static String getPamType(String fdId, String name) throws Exception {
		ITibSysSapRfcTableService tibSysSapRfcTableService = (ITibSysSapRfcTableService) SpringBeanUtil
				.getBean("tibSysSapRfcTableService");
		
		HQLInfo hqlInfo=new HQLInfo();
		hqlInfo.setSelectBlock(" fdisin ");
		hqlInfo.setWhereBlock(" fdFunction.fdId =:fdId and fdParameterName= :fdParameterName ");
		hqlInfo.setParameter("fdId", fdId);
		hqlInfo.setParameter("fdParameterName", name);
		String fdisin =(String)tibSysSapRfcTableService.findFirstValue(hqlInfo);
		
//		String fdisin = (String) tibSysSapRfcTableService.findValue(
//				"fdisin",
//				"fdFunction.fdId='" + fdId + "' and fdParameterName='" + name
//						+ "'", null).get(0);
		return fdisin;
	}
}
