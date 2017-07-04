package com.landray.kmss.tib.sys.sap.connector.impl;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;

import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.log.interfaces.ITibCommonLogInterface;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.sys.sap.connector.connect.TibSysSapJcoConnect;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapJcoSettingService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;
import com.landray.kmss.tib.sys.sap.connector.util.SAPXMLTemplateUtil;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.landray.kmss.tib.sys.sap.connector.util.TypesExchange;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Export;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Field;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Import;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.JAXBUtil;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Jco;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Record;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Structure;
import com.landray.kmss.tib.sys.sap.connector.util.xmlbind.Table;
import com.landray.kmss.tib.sys.sap.constant.MessageConstants;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapReturnConstants;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.sap.conn.jco.AbapException;
import com.sap.conn.jco.JCoContext;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoFunctionTemplate;
import com.sap.conn.jco.JCoRecord;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoTable;

public class TibSysSapJcoFunctionUtil implements ITibSysSapJcoFunctionUtil {

	private static Log logger = LogFactory
			.getLog(TibSysSapJcoFunctionUtil.class);
	XMLEventFactory eventFactory = null;
	// 使用一个线程安全的hashtable存储不同线程池（名）的destination,监控的时候对这个hashtable中的destination进行监控
	private static Hashtable<String, JCoDestination> destinations = new Hashtable<String, JCoDestination>();

	private JCoDestination getDestination(String fdPoolName) throws Exception {
		JCoDestination destination = null;
		if (destinations.containsKey(fdPoolName)) {
			destination = destinations.get(fdPoolName);
		} else {
			// System.out.println("_第一次____________");
			try {
				destination = JCoDestinationManager.getDestination(fdPoolName);
			} catch (JCoException e) {
				// 目标不存在，那么重新创建
				ITibSysSapJcoSettingService tibSysSapJcoSettingService = (ITibSysSapJcoSettingService) SpringBeanUtil
						.getBean("tibSysSapJcoSettingService");
				TibSysSapJcoSetting tibSysSapJcoSetting = (TibSysSapJcoSetting) tibSysSapJcoSettingService
						.findList("tibSysSapJcoSetting.fdPoolName='"+ fdPoolName +"'", null).get(0);
				destination = new TibSysSapJcoConnect().doInitialize(tibSysSapJcoSetting);
			}
			destinations.put(fdPoolName, destination);
		}
		return destination;
	}

	public Hashtable<String, JCoDestination> getDestinations() {
		return destinations;
	}

	/**
	 * 根据传进的函数Id得到rfc函数
	 * 
	 */
	public Object getFunctionById(String id) throws Exception {
		ITibSysSapRfcSettingService tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) SpringBeanUtil
				.getBean("tibSysSapRfcSettingService");
		TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) tibSysSapRfcSettingService
				.findByPrimaryKey(id, TibSysSapRfcSetting.class, true);
		String fdPoolName = tibSysSapRfcSetting.getFdPool().getFdPoolName();
		JCoDestination destination = getDestination(fdPoolName);
		JCoRepository repository = null;
		try {
			repository = destination.getRepository();
		} catch (Exception e) {
			destination = JCoDestinationManager.getDestination(fdPoolName);
			destinations.remove(fdPoolName);
			destinations.put(fdPoolName, destination);
			repository = destination.getRepository();
		}

		JCoFunctionTemplate template = repository
				.getFunctionTemplate(tibSysSapRfcSetting.getFdFunction());
		Object object = template.getFunction();
		return object;
	}

	/**
	 * 根据传进的函数名称和所属连接池得到rfc函数
	 * 
	 */
	public Object getFunctionByName(String name, String poolId)
			throws Exception {
		ITibSysSapJcoSettingService tibSysSapJcoSettingService = (ITibSysSapJcoSettingService) SpringBeanUtil
				.getBean("tibSysSapJcoSettingService");
		TibSysSapJcoSetting tibSysSapJcoSetting = (TibSysSapJcoSetting) tibSysSapJcoSettingService
				.findByPrimaryKey(poolId);
		String fdPoolName = tibSysSapJcoSetting.getFdPoolName();
		JCoDestination destination = getDestination(fdPoolName);
		JCoRepository repository = null;
		try {
			repository = destination.getRepository();
		} catch (Exception e) {
			destination = JCoDestinationManager.getDestination(fdPoolName);
			destinations.remove(fdPoolName);
			destinations.put(fdPoolName, destination);
			repository = destination.getRepository();
		}
		JCoFunctionTemplate template = repository.getFunctionTemplate(name);
		Object object = template.getFunction();
		return object;
	}

	/**
	 * 根据连接池名称获得函数管理对象JCoDestination
	 * 
	 */
	public JCoDestination getJCoDestinationByName(String poolName)
			throws Exception {
		JCoDestination destination = getDestination(poolName);
		return destination;
	}

	/**
	 * 将函数模板变为xml格式返回
	 * 
	 */
	public Object getFunctionToXml(Object object, String Id) throws Exception {

		JCoFunction function = (JCoFunction) object;

		XMLOutputFactory factory = XMLOutputFactory.newInstance();
		eventFactory = XMLEventFactory.newInstance();
		StringWriter stringWriter = new StringWriter();
		String result = null;
		XMLEventWriter writer = factory.createXMLEventWriter(stringWriter);
		try {
			SAPXMLTemplateUtil.parseFunction4XML(writer, function,
					eventFactory, Id);
			result = stringWriter.toString();
		} catch (XMLStreamException ex) {
			throw ex;
		} finally {
			// close
			if (writer != null) {
				try {
					writer.close();
				} catch (XMLStreamException ex) {
				}
			}
			if (stringWriter != null) {
				try {
					stringWriter.close();
				} catch (IOException ex) {
				}
			}
		}
		return result;
	}

	public Object getFunctionToXml(Object object, String Id, int i)
			throws Exception {
		// Date start = new Date();
		JCoFunction function = (JCoFunction) object;
		XMLOutputFactory factory = XMLOutputFactory.newInstance();
		eventFactory = XMLEventFactory.newInstance();
		StringWriter stringWriter = new StringWriter();
		String result = null;
		XMLEventWriter writer = factory.createXMLEventWriter(stringWriter);
		try {
			SAPXMLTemplateUtil.parseFunction4XML(writer, function,
					eventFactory, Id, i);
			result = stringWriter.toString();
		} catch (XMLStreamException ex) {
			throw ex;
		} finally {
			// close
			if (writer != null) {
				try {
					writer.close();
				} catch (XMLStreamException ex) {
				}
			}
			if (stringWriter != null) {
				try {
					stringWriter.close();
				} catch (IOException ex) {
				}
			}
		}
		return result;

	}

	/**
	 * 根据传进的函数Id得到函数模板的xml
	 * 
	 */
	public Object getFunctionToXmlById(String Id) throws Exception {
		return getFunctionToXml(getFunctionById(Id), Id);
	}

	/**
	 * 根据传进的参数json得到传出参数的json
	 * 
	 */
	public TibSysSapReturnVo getJsonToJson(String rfc, String json) {

		TibSysSapReturnVo tibSysSapReturnVo = new TibSysSapReturnVo();
		Object outXML = null;
		Date start = new Date(); // 当前执行时间
		JSONObject newJson = new JSONObject();
		JSONObject childObject = new JSONObject();
		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");
		try {
			List<Object> rtnList = convertXMLtoFunction(getJsonToXml(rfc, json));// 将传入XML数据模板转换为执行后的JCOFunction
			JCoFunction function = (JCoFunction) rtnList.get(0);
			String functionId = (String) rtnList.get(1);
			outXML = getFunctionToXml(function, functionId);
			childObject = JSONObject.fromObject(getXmlToJson(getFunctionToXml(
					function, functionId)));
			newJson.element("RFC_ISSUCCESS", 1);
			newJson.element("RFC_RETURN", childObject);

			String flag = SAPXMLTemplateUtil.checkSuccess(outXML); // 是否业务成功
			if (flag.equals("1")) {
				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								rfc,
								start,
								new Date(),
								json,
								outXML.toString(),
								"成功日志:TibSystibSystibSysSapJcoFunctionUtil.getJsonToJson",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
				tibSysSapReturnVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_SIMPLE_RETURN);
			} else {
				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								rfc,
								start,
								new Date(),
								json,
								outXML.toString(),
								"连接SAP成功，但在SAP中执行失败:TibSystibSystibSysSapJcoFunctionUtil.getJsonToJson",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_BIERROR);
				/**********************************/
				tibSysSapReturnVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN);
			}
		} catch (Exception e) {
			e.printStackTrace();
			tibCommonLogInterface.saveTibCommonLogMain(Constant.FD_TYPE_SAP,
					null, "", rfc, start, new Date(), json, outXML.toString(),
					"程序异常:TibSystibSystibSysSapJcoFunctionUtil.getJsonToJson"
							+ e.toString(),
					TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
			newJson.element("RFC_ISSUCCESS", 0);
			newJson.element("RFC_RETURN", e.toString());
			tibSysSapReturnVo
					.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN);
		}
		tibSysSapReturnVo.setResult(newJson);
		return tibSysSapReturnVo;
	}

	/**
	 * 根据传进的BAPI名称和所属连接池得到函数模板的xml
	 * 
	 */
	public Object getFunctionToXmlByName(String name, String pool)
			throws Exception {
		return getFunctionToXml(getFunctionByName(name, pool), "");
	}

	/**
	 * 仅定时任务使用
	 * 
	 */
	public JCoFunction getFunctionFromFunc(JCoFunction jcoFunction,
			String functionId) throws Exception {
		long cur = System.currentTimeMillis();
		try {
			ITibSysSapRfcSettingService tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) SpringBeanUtil
					.getBean("tibSysSapRfcSettingService");
			TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) tibSysSapRfcSettingService
					.findByPrimaryKey(functionId);
			String fdPoolName = tibSysSapRfcSetting.getFdPool().getFdPoolName();
			JCoDestination destination = getDestination(fdPoolName);
			// jcoFunction.execute(destination);
			if (tibSysSapRfcSetting.getFdCommit() == null
					|| tibSysSapRfcSetting.getFdCommit() == false) {
				jcoFunction.execute(destination);
			} else {
				JCoFunction function1 = destination.getRepository()
						.getFunction("BAPI_TRANSACTION_COMMIT");
				function1.getImportParameterList().setValue("WAIT", "X");
				JCoFunction function2 = destination.getRepository()
						.getFunction("BAPI_TRANSACTION_ROLLBACK");
				JCoContext.begin(destination);
				try {
					jcoFunction.execute(destination);
					function1.execute(destination);
				} catch (AbapException e) {
					function2.execute(destination);
					logger.debug(e);
				}
				JCoContext.end(destination);
			}

		} catch (Exception e) {
			throw new Exception("01" + jcoFunction.getName() + "执行报错\n" + e);
		}
		logger.debug("获取定时任务function完成,用时："
				+ (System.currentTimeMillis() - cur) + "ms");
		return jcoFunction;
	}

	/**
	 * @param object
	 *            执行结果XML，需要增加ekpid, ekpname
	 * @param xml
	 *            传入参数XML，包含模板定义(ekpid等)
	 */
	public Object getFunctionDateToXml(Object object, Object xml, Date start,
			String functionId) throws Exception {
		return mergeFunctionXML(object, xml, start, functionId);
	}

	/*****
	 * 修复xml合并逻辑**new******** /** xml 合并
	 * 
	 * @param object
	 * @param xml
	 * @param start
	 * @param functionId
	 */
	public static String mergeFunctionXML(Object object, Object xml,
			Date start, String functionId) {

		Jco result = JAXBUtil.unmarshal(new StringReader((String) object),
				Jco.class);
		Jco template = JAXBUtil.unmarshal(new StringReader((String) xml),
				Jco.class);

		Import imp_s = result.getImportModel();
		Import imp_t = template.getImportModel();

		// merge import
		if (imp_s != null) {
			if (imp_t != null) {
				imp_s.setClocal(imp_t.getClocal());
				mergeImportField(imp_s.getFields(), imp_t);
				if (imp_s.getStructures() != null
						&& !imp_s.getStructures().isEmpty()) {
					for (Structure structure : imp_s.getStructures()) {
						String structName = structure.getName();
						if (StringUtil.isNotNull(structName)) {
							Structure str_t = imp_t
									.getStructureByName(structName);
							if (str_t != null) {
								mergeStructureField(structure.getFields(),
										str_t);
							}
						}
					}
				}
			}
		}

		// merge export
		Export exp_s = result.getExportModel();
		Export exp_t = template.getExportModel();

		if (exp_s != null) {
			if (exp_t != null) {
				exp_s.setClocal(exp_t.getClocal());
				exp_s.setFields(mergeExportField(exp_s.getFields(), exp_t));
				if (exp_s.getStructures() != null
						&& !exp_s.getStructures().isEmpty()) {
					for (Structure structure : exp_s.getStructures()) {
						String structName = structure.getName();
						if (StringUtil.isNotNull(structName)) {
							Structure str_t = exp_t
									.getStructureByName(structName);
							if (str_t != null) {
								mergeStructureField(structure.getFields(),
										str_t);
							}
						}
					}
				}
			}
		}
		// merge table
		List<Table> table_s = result.getTables();
		if (table_s != null && !table_s.isEmpty()) {
			for (Table table : table_s) {
				Table tb_tmp = template.getTablesByName(table.getName());
				if (tb_tmp == null) {
					continue;
				}
				table.setClocal(tb_tmp.getClocal());
				int size = !table.getRecords().isEmpty() ? table.getRecords()
						.size() : 0;
				table.setRows(size + "");
				table.setIsin(tb_tmp.getIsin());
				table.setWriteType(tb_tmp.getWriteType());
				table.setWriteKey(tb_tmp.getWriteKey());
				if (table.getRecords() != null && tb_tmp.getRecords() != null
						&& !table.getRecords().isEmpty()
						&& !tb_tmp.getRecords().isEmpty()) {
					// 只要把第一行的属性合并出来
					Record record_s = table.getRecords().get(0);
					Record record_t = tb_tmp.getRecords().get(0);
					mergeRecordsField(record_s.getFields(), record_t);
					for (int i = 0; i < table.getRecords().size(); i++) {
						table.getRecords().get(i).setRow(i + "");

					}

				}
			}
		}
		return JAXBUtil.marshaller(result, Jco.class).toString();
	}

	/**
	 * 合并传入参数
	 * 
	 * @param field_s
	 *            返回结果数据传入参数
	 * @param imp_t
	 *            模板传入参数对象
	 * @return
	 */
	public static List<Field> mergeImportField(List<Field> field_s, Import imp_t) {
		if (field_s == null) {
			return field_s;
		}
		String[] fieldArray = { "ekpId", "ekpName", "ctype", "maxLength",
				"decimals", "isoptional", "dbiskey", "isBack" };
		// 遍历数据传入参数
		for (Field field : field_s) {
			String fieldName = field.getName();
			if (StringUtil.isNotNull(fieldName)) {
				Field field_t = imp_t.getFieldByName(fieldName);
				if (field_t != null) {
					for (String prop : fieldArray) {
						if (PropertyUtils.isReadable(field_t, prop)
								&& PropertyUtils.isWriteable(field, prop)) {
							try {
								PropertyUtils.setProperty(field, prop,
										PropertyUtils
												.getProperty(field_t, prop));

							} catch (Exception e) {
								logger.info("把XML模板属性：" + prop
										+ " 拷贝到 数据里面出错,忽略当前属性拷贝,跳过~");
								e.printStackTrace();
							}
						}

					}
				}
			}
		}
		return field_s;
	}

	// merge export
	public static List<Field> mergeExportField(List<Field> field_s, Export exp_t) {
		if (field_s == null) {
			return field_s;
		}
		String[] fieldArray = { "ekpId", "ekpName", "ctype", "maxLength",
				"decimals", "isoptional", "dbiskey", "isBack" };
		for (Field field : field_s) {
			String fieldName = field.getName();
			if (StringUtil.isNotNull(fieldName)) {
				Field field_t = exp_t.getFieldByName(fieldName);
				if (field_t != null) {
					for (String prop : fieldArray) {
						if (PropertyUtils.isReadable(field_t, prop)
								&& PropertyUtils.isWriteable(field, prop)) {
							try {
								PropertyUtils.setProperty(field, prop,
										PropertyUtils
												.getProperty(field_t, prop));
							} catch (Exception e) {
								logger.info("把XML模板属性：" + prop
										+ " 拷贝到 数据里面出错,忽略当前属性拷贝,跳过~");
								e.printStackTrace();
							}
						}

					}
				}
			}
		}
		return field_s;
	}

	// merge structure
	public static List<Field> mergeStructureField(List<Field> field_s,
			Structure str_t) {
		if (field_s == null) {
			return field_s;
		}
		String[] fieldArray = { "ekpId", "ekpName", "ctype", "maxLength",
				"decimals", "isoptional", "dbiskey", "isBack" };
		for (Field field : field_s) {
			String fieldName = field.getName();
			if (StringUtil.isNotNull(fieldName)) {
				Field field_t = str_t.getFieldByName(fieldName);
				if (field_t != null) {
					for (String prop : fieldArray) {
						if (PropertyUtils.isReadable(field_t, prop)
								&& PropertyUtils.isWriteable(field, prop)) {
							try {
								PropertyUtils.setProperty(field, prop,
										PropertyUtils
												.getProperty(field_t, prop));
							} catch (Exception e) {
								logger.info("把XML模板属性：" + prop
										+ " 拷贝到 数据里面出错,忽略当前属性拷贝,跳过~");
								e.printStackTrace();
							}
						}

					}
				}
			}
		}
		return field_s;
	}

	// merge record
	public static List<Field> mergeRecordsField(List<Field> field_s,
			Record record_t) {
		if (field_s == null) {
			return field_s;
		}
		// bak: name title value
		String[] fieldArray = { "ekpId", "ekpName", "ctype", "maxLength",
				"decimals", "isoptional", "dbiskey", "isBack" };

		for (Field field : field_s) {
			String fieldName = field.getName();
			if (StringUtil.isNotNull(fieldName)) {
				Field field_t = record_t.getFieldByName(fieldName);
				if (field_t != null) {
					for (String prop : fieldArray) {
						if (PropertyUtils.isReadable(field_t, prop)
								&& PropertyUtils.isWriteable(field, prop)) {
							try {
								PropertyUtils.setProperty(field, prop,
										PropertyUtils
												.getProperty(field_t, prop));
							} catch (Exception e) {
								logger.info("把XML模板属性：" + prop
										+ " 拷贝到 数据里面出错,忽略当前属性拷贝,跳过~");
								e.printStackTrace();
							}
						}

					}
				}
			}
		}
		return field_s;
	}

	/***************
	 * /** 数据转换为json格式输出
	 * 
	 */
	public Object getXmlToJson(Object xml) {
		Document xmlDocument = SAPXMLTemplateUtil.getElement(xml.toString());
		JSONObject json = new JSONObject();
		JSONObject exportjson = new JSONObject();
		JSONObject tablejson = new JSONObject();
		if (xmlDocument.getElementsByTagName(MessageConstants.EXPORT)
				.getLength() != 0) {
			NodeList n1 = xmlDocument.getElementsByTagName(
					MessageConstants.EXPORT).item(0).getChildNodes();
			for (int i = 0; i < n1.getLength(); i++) {
				Node node = n1.item(i);
				if (node.getNodeName().equals(MessageConstants.FIELD)) {
					exportjson.element(node.getAttributes()
							.getNamedItem("name").getNodeValue(), node
							.getTextContent());
				}
				if (node.getNodeName().equals(MessageConstants.STRUCTURE)) {
					JSONObject exportStructrue = new JSONObject();
					exportStructrue = getJson(node);
					exportjson.element(node.getAttributes()
							.getNamedItem("name").getNodeValue(),
							exportStructrue);
				}
			}
		}
		if (xmlDocument.getElementsByTagName(MessageConstants.TABLES)
				.getLength() != 0) {
			NodeList n2 = xmlDocument.getElementsByTagName(
					MessageConstants.TABLES).item(0).getChildNodes();
			for (int j = 0; j < n2.getLength(); j++) {
				JSONArray tableRow = new JSONArray();
				Node tableNode = n2.item(j);
				tableRow = getTableJson(tableNode);
				tablejson.element(tableNode.getAttributes()
						.getNamedItem("name").getNodeValue(), tableRow);
			}
		}
		json.element("exportParams", exportjson);
		json.element("exportTables", tablejson);
		return json;
	}

	public JSONArray getTableJson(Node node) {
		JSONArray json = new JSONArray();
		NodeList nodeList = node.getChildNodes();
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node row = nodeList.item(i);
			JSONObject record = new JSONObject();
			record = getJson(row);
			json.add(record);
		}
		return json;
	}

	public JSONObject getJson(Node node) {
		JSONObject json = new JSONObject();
		NodeList list = node.getChildNodes();
		for (int i = 0; i < list.getLength(); i++) {
			Node childNode = list.item(i);
			json.element(childNode.getAttributes().getNamedItem("name")
					.getNodeValue(), childNode.getTextContent());
		}
		return json;
	}

	/**
	 * json转换为输入参数的xml模板
	 * 
	 * @throws Exception
	 * 
	 */
	public Object getJsonToXml(String rfc, String jsonxml) throws Exception {
		ITibSysSapRfcSettingService tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) SpringBeanUtil
				.getBean("tibSysSapRfcSettingService");
		String fdId = null;
		List fdRfcId = tibSysSapRfcSettingService.findValue("fdId",
				"fdFunctionName='" + rfc + "'", null);
		if (!(fdRfcId.isEmpty()))
			fdId = (String) fdRfcId.get(0);
		StringWriter stringWriter = new StringWriter();
		String result = null;
		JSONObject json = JSONObject.fromObject(jsonxml);
		XMLOutputFactory factory = XMLOutputFactory.newInstance();
		eventFactory = XMLEventFactory.newInstance();
		XMLEventWriter writer = factory.createXMLEventWriter(stringWriter);

		try {
			SAPXMLTemplateUtil.writeStartDocument(writer, eventFactory);
			SAPXMLTemplateUtil.writeCharacters(writer, "\n", eventFactory);
			SAPXMLTemplateUtil.writeStartElement(writer, MessageConstants.JCO,
					eventFactory);
			SAPXMLTemplateUtil.writeAttribute(writer,
					MessageConstants.JCO_ATTR_ID, fdId, eventFactory);
			SAPXMLTemplateUtil.writeCharacters(writer, "\n", eventFactory);
			if (!(json.getJSONObject("importParams").isNullObject())) {
				SAPXMLTemplateUtil.writeStartElement(writer,
						MessageConstants.IMPORT, eventFactory);
				Iterator jsonList = json.getJSONObject("importParams").keys();
				while (jsonList.hasNext()) {
					Object key = jsonList.next();
					Object value = json.getJSONObject("importParams").get(key);
					if (value != null && StringUtil.isNotNull((String) value))
						if (value.toString().charAt(0) == '{')
							SAPXMLTemplateUtil.writeImportStructure(writer,
									key, value, eventFactory);
						else
							SAPXMLTemplateUtil.writeImportFiled(writer, key,
									value, eventFactory);
					else {
						SAPXMLTemplateUtil.writeImportFiled(writer, key, value,
								eventFactory);
					}
				}
				SAPXMLTemplateUtil.writeEndElement(writer,
						MessageConstants.IMPORT, eventFactory);
			}
			SAPXMLTemplateUtil.writeCharacters(writer, "\n", eventFactory);
			if (!(json.getJSONObject("importTables").isNullObject())) {
				SAPXMLTemplateUtil.writeStartElement(writer,
						MessageConstants.TABLES, eventFactory);
				Iterator jsonTableList = json.getJSONObject("importTables")
						.keys();
				while (jsonTableList.hasNext()) {
					Object tablekey = jsonTableList.next();
					Object tablevalue = json.getJSONObject("importTables").get(
							tablekey);
					SAPXMLTemplateUtil.writeImportTable(writer, tablekey,
							tablevalue, eventFactory);
				}
				SAPXMLTemplateUtil.writeEndElement(writer,
						MessageConstants.TABLES, eventFactory);
			}
			SAPXMLTemplateUtil.writeCharacters(writer, "\n", eventFactory);
			SAPXMLTemplateUtil.writeEndElement(writer, MessageConstants.JCO,
					eventFactory);
			writer.flush();
			result = stringWriter.toString();

		} catch (XMLStreamException ex) {
			throw ex;
		} finally {
			// close
			if (writer != null) {
				try {
					writer.close();
				} catch (XMLStreamException ex) {
				}
			}
			if (stringWriter != null) {
				try {
					stringWriter.close();
				} catch (IOException ex) {
				}
			}
		}

		return result;
	}

	public Object getFunctionToXmlByRfc(String name) throws Exception {
		ITibSysSapRfcSettingService tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) SpringBeanUtil
				.getBean("tibSysSapRfcSettingService");
		String rfc = tibSysSapRfcSettingService.findValue("fdId",
				"fdFunctionName='" + name + "'", null).get(0).toString();
		return getFunctionToXmlById(rfc);
	}

	public TibSysSapReturnVo getJson4WebService(String RFCName, Object json)
			throws Exception {
		TibSysSapReturnVo tibSysSapVo = new TibSysSapReturnVo();

		Date start = new Date(); // 当前执行时间
		JSONObject newJson = new JSONObject();
		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");
		Object outXML = null;
		try {
			if (StringUtil.isNull(RFCName)
					|| StringUtil.isNull(json.toString())) {
				throw new Exception("输入参数不正确,请检查!");
			}
			String jsonTransfer = (String) getJsonToXml(RFCName, (String) json);
			List<Object> rtnList = convertXMLtoFunction(jsonTransfer);// 将传入XML数据模板转换为执行后的JCOFunction
			JCoFunction jfn = (JCoFunction) rtnList.get(0);
			String functionId = (String) rtnList.get(1);
			outXML = getFunctionToXml(jfn, functionId);

			String rtnString = jfn.toXML();
			newJson.element("RFC_ISSUCCESS", 1);
			newJson.element("RFC_RETURN", rtnString);

			String flag = SAPXMLTemplateUtil.checkSuccess(outXML); // 是否业务成功
			if (flag.equals("1")) {
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SAP, null, "", RFCName, start,
						new Date(), json.toString(), rtnString, "成功日志",
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
				// tibCommonLogInterface.logSuccess(
				// "TibSystibSystibSysSapJcoFunctionUtil.getJson4WebService()",
				// start, null,
				// null, json.toString(), rtnString,
				// "成功日志",Constant.FD_TYPE_SAP);
				tibSysSapVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_SIMPLE_RETURN);
			} else {

				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								RFCName,
								start,
								new Date(),
								json.toString(),
								rtnString,
								"连接SAP成功，但在SAP中执行失败:TibSystibSystibSysSapJcoFunctionUtil.getJson4WebService()",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_BIERROR);
				// tibCommonLogInterface.logBusinessError(
				// "TibSystibSystibSysSapJcoFunctionUtil.getJson4WebService()",
				// start, null,
				// null, json.toString(), rtnString,
				// "连接SAP成功，但在SAP中执行失败",Constant.FD_TYPE_SAP);
				// TibSysSapJcoLogUtil.saveJcoLogBusiness(start,
				// "02连接SAP成功，但在SAP中执行失败",
				// json, rtnString, functionId);
				tibSysSapVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN);
			}
		} catch (Exception e) {
			newJson.element("RFC_ISSUCCESS", 0);
			newJson.element("RFC_RETURN", e.toString());
			tibCommonLogInterface.saveTibCommonLogMain(Constant.FD_TYPE_SAP,
					null, "", RFCName, start, new Date(), json.toString(),
					outXML.toString(),
					"程序异常:TibSystibSystibSysSapJcoFunctionUtil.getJson4WebService()"
							+ e.toString(),
					TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
			tibSysSapVo
					.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN);
		}
		tibSysSapVo.setResult(newJson);
		return tibSysSapVo;
	}

	public JCoFunction getFunctionByNameAndPool(String name, String poolId)
			throws Exception {
		return (JCoFunction) getFunctionByName(name, poolId);

	}

	// 内部函数：将传入XML数据模板转换为执行后的JCOFunction
	public List<Object> convertXMLtoFunction(Object xml, String defaultFuncId)
			throws Exception {
		// Date start = new Date(); // 当前执行时间
		XMLStreamReader reader = null;
		String localName = null;
		String functionId = null; // jco's id
		String functionName = null; // jco's name
		String tableName = null;
		String structureName = null;
		JCoFunction function = null;
		String fieldName = null;
		String value = null;
		int rowNumber = 1; // 表参数行数
		XMLInputFactory factory = XMLInputFactory.newInstance();
		InputStream is = new ByteArrayInputStream(xml.toString().getBytes(
				"utf-8"));
		reader = factory.createXMLStreamReader(is);
		ArrayList<JCoRecord> records = new ArrayList<JCoRecord>(3);
		JCoRecord record = null;

		Stack<JCoRecord> recordStack = new Stack<JCoRecord>();
		// ITibSysSapJcoLogUtil tibCommonLogInterface = new
		// tibCommonLogInterface();
		try {
			while (reader.hasNext()) {
				int eventType = reader.next();
				if (eventType == XMLStreamReader.START_DOCUMENT) {
					// find START_DOCUMENT
				} else if (eventType == XMLStreamReader.START_ELEMENT) {
					localName = reader.getLocalName();
					if (localName.equals(MessageConstants.JCO)) {
						functionId = SAPXMLTemplateUtil.getAttributeValue(
								MessageConstants.JCO_ATTR_ID, reader);
						functionName = SAPXMLTemplateUtil.getAttributeValue(
								MessageConstants.JCO_ATTR_NAME, reader);

						if (StringUtil.isNull(functionId)) {
							functionId = defaultFuncId;
						}
						function = (JCoFunction) getFunctionById(functionId);
					} else if (functionId != null) {
						if (localName.equals(MessageConstants.IMPORT)) {
							if (function.getImportParameterList() != null) {
								if (record != null) {
									records.add(record);
								}
								record = function.getImportParameterList();
								// 压入栈中
								// recordStack.push(record);
							} else {
								// 压空数据到栈中
								// recordStack.push(null);
							}

						} else if (localName.equals(MessageConstants.EXPORT)) {
							if (function.getExportParameterList() != null) {
								if (record != null)
									records.add(record);
								record = function.getExportParameterList();
								// recordStack.push(record);
							} else {
								// 确保有东西出栈
								// recordStack.push(null);
							}
						} else if (localName.equals(MessageConstants.TABLES)) {
							tableName = null;
							if (function.getTableParameterList() != null) {
								if (record != null)
									records.add(record);
								record = function.getTableParameterList();
							}
						} else if (localName.equals(MessageConstants.TABLE)) {
							String isin = SAPXMLTemplateUtil.getAttributeValue(
									MessageConstants.TABLE_ISIN, reader);
							String tableRow = SAPXMLTemplateUtil
									.getAttributeValue(
											MessageConstants.TABLE_ATTR_ROW,
											reader);
							if (tableRow.equals("0"))
								rowNumber = 0;
							else
								rowNumber = 1;
							/**
							 * 当表格既是传入又是传出的时候
							 *  if ("1".equals(isin)) {
							 */
							if (isin.contains("1")) {
								if (tableName != null) {
									if (!records.isEmpty()) {
										record = (JCoRecord) records
												.remove(records.size() - 1);
									}
								}
								tableName = SAPXMLTemplateUtil
										.getAttributeValue(
												MessageConstants.TABLE_ATTR_NAME,
												reader);
								if (record.getTable(tableName) != null) {
									if (record != null)
										records.add(record);

									record = record.getTable(tableName);
								}
							}
						} else if (localName.equals(MessageConstants.STRUCTURE)) {
							structureName = SAPXMLTemplateUtil
									.getAttributeValue(
											MessageConstants.STRUCTURE_ATTR_NAME,
											reader);
							if (record.getStructure(structureName) != null) {
								if (record != null)
									records.add(record);

								JCoRecord s_record = record
										.getStructure(structureName);
								// 把结构体压入栈中
								recordStack.push(s_record);
							}
						} else if (localName.equals(MessageConstants.ROW)) {
							if (rowNumber == 1) {
								if (record instanceof JCoTable) {
									((JCoTable) record).appendRow();
								}
							}
						} else if (localName.equals(MessageConstants.FIELD)) {
							fieldName = SAPXMLTemplateUtil.getAttributeValue(
									MessageConstants.STRUCTURE_ATTR_NAME,
									reader);
							JCoRecord curRecord;
							// 如果栈不为空，说明这个field是结构体的
							if (!recordStack.isEmpty()) {
								curRecord = recordStack.peek();
							} else {
								// 如果不是空，说明这个field是其他节点的，其他节点暂时不处理
								curRecord = record;
							}
							// ***************修正数据类型转换************************
							String ctype = SAPXMLTemplateUtil
									.getAttributeValue("ctype", reader);
							value = reader.getElementText().trim();
							// System.out.println(xml);
							Object e_value = null;
							if (StringUtil.isNotNull(ctype)) {
								// logger.info("转换数据类型"+ctype);
								e_value = TypesExchange.exSwitchValue(ctype,
										value, false);
							} else {
								logger.info("没有数据类型,使用字符串类型替换");
								e_value = value;
							}
							if (rowNumber == 1) {
								curRecord.setValue(fieldName, e_value);
							}
							// *********************************************
						}
					}
				} else if (eventType == XMLStreamReader.END_ELEMENT) {
					localName = reader.getLocalName();
					if (MessageConstants.IMPORT.equals(localName)) {
						// if(!recordStack.isEmpty()){
						// recordStack.pop();
						// }
					} else if (MessageConstants.EXPORT.equals(localName)) {
						// if(!recordStack.isEmpty()){
						// recordStack.pop();
						// }
					} else if (MessageConstants.TABLES.equals(localName)) {

					} else if (MessageConstants.TABLE.equals(localName)) {

					} else if (MessageConstants.FIELD.equals(localName)) {

					} else if (MessageConstants.STRUCTURE.equals(localName)) {
						if (!recordStack.isEmpty()) {
							recordStack.pop();
						}
					} else if (MessageConstants.ROW.equals(localName)) {

					}
				}
			}
			ITibSysSapRfcSettingService tibSysSapRfcSettingService = (ITibSysSapRfcSettingService) SpringBeanUtil
					.getBean("tibSysSapRfcSettingService");
			// 直接从数据库读取，处理多线程访问Session关闭问题
			TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) tibSysSapRfcSettingService
					.findByPrimaryKey(functionId, TibSysSapRfcSetting.class, true);
			String fdPoolName = tibSysSapRfcSetting.getFdPool().getFdPoolName();
			JCoDestination destination = getDestination(fdPoolName);

			if (tibSysSapRfcSetting.getFdCommit() == null
					|| tibSysSapRfcSetting.getFdCommit() == false) {
				function.execute(destination);
			} else {
				JCoFunction function1 = destination.getRepository()
						.getFunction("BAPI_TRANSACTION_COMMIT");
				function1.getImportParameterList().setValue("WAIT", "X");
				JCoFunction function2 = destination.getRepository()
						.getFunction("BAPI_TRANSACTION_ROLLBACK");
				JCoContext.begin(destination);
				try {
					function.execute(destination);
					function1.execute(destination);
				} catch (AbapException e) {
					function2.execute(destination);
					logger.debug(e);
				}
				JCoContext.end(destination);
			}

		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("01:convertXMLtoFunction:" + functionName
					+ "执行报错\n" + e);
		} finally {
			// close
			if (reader != null) {
				try {
					reader.close();
				} catch (XMLStreamException ex) {
				}
			}
			if (is != null) {
				try {
					is.close();
				} catch (IOException ex) {
				}
			}
		}

		List<Object> rtnList = new ArrayList<Object>();
		rtnList.add(function);// 0函数对象
		rtnList.add(functionId);// 1函数ID
		return rtnList;
	}

	// 内部函数：将传入XML数据模板转换为执行后的JCOFunction
	public List<Object> convertXMLtoFunction(Object xml) throws Exception {
		return convertXMLtoFunction(xml, null);
	}

	/**
	 * 根据传进的参数获得传出参数的xml
	 * 
	 * @param xml
	 *            传入的XML数据模板
	 * @param i
	 *            限制每个JCOTABLE只返回 i 条数据
	 * @throws Exception
	 * 
	 */
	public TibSysSapReturnVo getXMltoFunction(Object xml, int i)
			throws Exception {
		TibSysSapReturnVo tibSysSapReturnVo = new TibSysSapReturnVo();
		Object outEKPXML = "";
		Date start = new Date(); // 当前执行时间
		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");
		String rfcName = "";
		try {
			List<Object> rtnList = convertXMLtoFunction(xml);// 将传入XML数据模板转换为执行后的JCOFunction
			JCoFunction function = (JCoFunction) rtnList.get(0);
			String functionId = (String) rtnList.get(1);

			Object outXML = getFunctionToXml(function, functionId, i);
			outEKPXML = getFunctionDateToXml(outXML, xml, start, functionId);
			rfcName = function.getName() + "/" + functionId;

			String flag = SAPXMLTemplateUtil.checkSuccess(outXML); // 是否业务成功
			if (flag.equals("1")) {
				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								function.getName(),
								start,
								new Date(),
								xml.toString(),
								outEKPXML.toString(),
								"成功日志:TibSysSapJcoFunctionUtil.getXMltoFunction()",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
				tibSysSapReturnVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_SIMPLE_RETURN);
			} else {
				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								function.getName(),
								start,
								new Date(),
								xml.toString(),
								outEKPXML.toString(),
								"连接SAP成功，但在SAP中执行失败:TibSysSapJcoFunctionUtil.getXMltoFunction()",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_BIERROR);
				tibSysSapReturnVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN);
			}
		} catch (Exception e) {
			e.printStackTrace();
			tibCommonLogInterface.saveTibCommonLogMain(Constant.FD_TYPE_SAP,
					null, "", rfcName, start, new Date(), xml.toString(),
					outEKPXML.toString(),
					"程序异常:TibSysSapJcoFunctionUtil.getXMltoFunction()"
							+ e.getMessage(),
					TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
			tibSysSapReturnVo
					.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN);
		}
		tibSysSapReturnVo.setResult(outEKPXML);
		return tibSysSapReturnVo;

	}

	/**
	 * 根据传进的参数获得传出参数的xml
	 * 
	 * @param xml
	 *            传入的XML数据模板
	 * @throws Exception
	 * 
	 */
	public TibSysSapReturnVo getXMltoFunction(Object xml) throws Exception {
		return getXMLtoFunction(null, xml);
	}

	public TibSysSapReturnVo getXMLtoFunction(String defRfcId, Object xml)
			throws Exception {
		TibSysSapReturnVo tibSysSapReturnVo = new TibSysSapReturnVo();
		Object outEKPXML = "";
		Date start = new Date(); // 当前执行时间
		String rfcName = "";
		ITibCommonLogInterface tibCommonLogInterface = (ITibCommonLogInterface) SpringBeanUtil
				.getBean("tibCommonLogInterface");
		try {
			List<Object> rtnList = convertXMLtoFunction(xml, defRfcId);// 将传入XML数据模板转换为执行后的JCOFunction
			JCoFunction function = (JCoFunction) rtnList.get(0);
			String functionId = (String) rtnList.get(1);

			Object outXML = getFunctionToXml(function, functionId);
			outEKPXML = getFunctionDateToXml(outXML, xml, start, functionId);

			String flag = SAPXMLTemplateUtil.checkSuccess(outXML); // 是否业务成功
			rfcName = function.getName() + "/" + functionId;
			if (flag.equals("1")) {
				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								function.getName(),
								start,
								new Date(),
								xml.toString(),
								outEKPXML.toString(),
								"成功日志:TibSysSapJcoFunctionUtil.getXMltoFunction()",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS);
				tibSysSapReturnVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_SIMPLE_RETURN);
			} else {
				tibCommonLogInterface
						.saveTibCommonLogMain(
								Constant.FD_TYPE_SAP,
								null,
								"",
								function.getName(),
								start,
								new Date(),
								xml.toString(),
								outEKPXML.toString(),
								"连接SAP成功，但在SAP中执行失败:TibSysSapJcoFunctionUtil.getXMltoFunction()",
								TibCommonLogConstant.TIB_COMMON_LOG_TYPE_BIERROR);
				tibSysSapReturnVo
						.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_BUSINESS_EXCEPTION_RETURN);
			}
		} catch (Exception e) {
			tibSysSapReturnVo
					.setReturnType(TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN);
			try {
				tibCommonLogInterface.saveTibCommonLogMain(
						Constant.FD_TYPE_SAP, null, "", rfcName, start,
						new Date(), xml.toString(), outEKPXML.toString(),
						"程序异常:TibSysSapJcoFunctionUtil.getXMltoFunction()"
								+ e.getMessage(),
						TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
			return tibSysSapReturnVo;
		}
		tibSysSapReturnVo.setResult(outEKPXML);
		return tibSysSapReturnVo;
	}

	public static void clearTargetCache(String poolName, String funcName) throws JCoException {
		JCoDestination jcoDest = destinations.get(poolName);
		if (jcoDest != null) {
			destinations.remove(poolName);
		}
		JCoRepository repository = jcoDest.getRepository();
		repository.removeFunctionTemplateFromCache(funcName);
		destinations.put(poolName, jcoDest);
	}

}
