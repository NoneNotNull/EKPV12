package com.landray.kmss.tib.sys.sap.connector.test;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.sap.conn.jco.AbapException;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;

public class TestSap {
	static String ABAP_AS_POOLED = "ABAP4"; // 连接池名称
	static {
		Properties connectProperties = new Properties();
		connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST,
				"10.10.12.41");
		connectProperties.setProperty(DestinationDataProvider.JCO_SAPROUTER,
				"/H/219.141.250.71/H/");

		connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, "10");
		connectProperties
				.setProperty(DestinationDataProvider.JCO_CLIENT, "830");
		connectProperties.setProperty(DestinationDataProvider.JCO_USER,
				"RB_ekp");
		connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD,
				"redbull");
		connectProperties.setProperty(DestinationDataProvider.JCO_LANG, "ZH");
		// JCO_PEAK_LIMIT - Maximum number of idle connections kept open by the
		// destination.
		connectProperties.setProperty(
				DestinationDataProvider.JCO_POOL_CAPACITY, "3");

		// JCO_POOL_CAPACITY - Maximum number of active connections that
		// can be created for a destination simultaneously
		connectProperties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT,
				"10");
		createDataFile(ABAP_AS_POOLED, "jcoDestination", connectProperties);
	}

	static void createDataFile(String name, String suffix, Properties properties) {
		File cfg = new File(name + "." + suffix);
		if (!cfg.exists()) {
			try {
				FileOutputStream fos = new FileOutputStream(cfg, false);
				properties.store(fos, "for tests only !");
				fos.close();
			} catch (Exception e) {
				throw new RuntimeException(
						"Unable to create the destination file "
								+ cfg.getName(), e);
			}
		}
	}

	// 连接连接池
	public static void connectWithPooled() throws JCoException {
		JCoDestination destination = JCoDestinationManager
				.getDestination(ABAP_AS_POOLED);
		destination.ping();
		System.out.println("Attributes:");
		System.out.println(destination.getAttributes());
		System.out.println();
	}

	// 执行简单函数
	public static void exeFunctionCall() throws JCoException {
		JCoDestination destination = JCoDestinationManager
				.getDestination(ABAP_AS_POOLED);
		JCoFunction function = destination.getRepository().getFunction(
				"BAPI_CUSTOMER_GETLIST");// ZHR_PERSONNEL_INFO//ZMM_CREATE_MAT
		// BAPI_INFORECORD_GETLIST
		// 1.得到RFC传入参数
		// 1.1.字段
		// JCoParameterList inJCoParameterList =
		// function.getImportParameterList();
		// inJCoParameterList.getParameterFieldIterator()

		// 1.2.结构

		// 1.3.表
		JCoTable table = function.getTableParameterList().getTable("IDRANGE");
		table.appendRow();
		table.setValue("SIGN", "I");
		table.setValue("OPTION", "EQ");
		table.setValue("LOW", "0000000001");
		table.setValue("HIGH", "0000005000");

		// 2.得到RFC传出参数
		// 2.1.字段
		function.getImportParameterList().setValue("MAXROWS", "5");
		function.getImportParameterList().setValue("CPDONLY", "");

		// 2.2.结构

		// 2.3.表

		if (function == null)
			throw new RuntimeException(
					"BAPI_CUSTOMER_GETLIST not found in SAP.");

		// Get importPrameterList and set value
		// function.getImportParameterList().setValue("STAT", "1");
		// function.getImportParameterList().setValue("IP_ENDDA", "99991231");
		// function.getImportParameterList().setValue("IP_OAACT", "ABC");
		// function.getImportParameterList().setValue("PERNR", "00000001");
		// function.getImportParameterList().setValue("GENERAL_DATA", "X");
		// function.getImportParameterList().setValue("PURCHORG_DATA", "X");
		//
		// function.getImportParameterList().setValue("VENDOR", "X");
		// function.getImportParameterList().setValue("MATERIAL", "X");
		// function.getImportParameterList().setValue("PLANT", "1090");

		try {
			function.execute(destination);
		} catch (AbapException e) {
			System.out.println(e.toString());
			return;
		}

		System.out.println("执行结束");
		// get export paramter and retrieve value
		// System.out.println(" EP_YEAR: "
		// + function.getExportParameterList().getString("EP_YEAR"));
		// System.out.println(" EP_MONTH: "
		// + function.getExportParameterList().getString("EP_MONTH"));
		// System.out.println();

		JCoParameterList tableParameterList = function.getTableParameterList();
		JCoTable tableOut = function.getTableParameterList().getTable(
				"SPECIALDATA");
		System.out.println("取表结束");
		System.out.println(tableOut.getNumRows());

		// JCoStructure exportStructure = function.getExportParameterList()
		// .getStructure("EP_PERSON_INFO");
		// System.out.println("System info for "
		// + destination.getAttributes().getSystemID() + ":/n");
		// for (int i = 0; i < exportStructure.getMetaData().getFieldCount();
		// i++) {
		// System.out.println(exportStructure.getMetaData().getName(i) + ":/t"
		// + exportStructure.getString(i));
		// }
		System.out.println("读取结束");
	}

	public static Map<String, String> mapValue() {
		Map<String, String> map = new HashMap<String, String>();
		map.put("m_name", "ZSD_FD32");
		return map;
	}

	// public static List<String> listValue()
	// {
	//
	// map.put("m_name", "ZHR_PERSONNEL_INFO");
	// return map;
	// }

	// 执行简单函数
	public static void exeFunctionCall2() throws JCoException {
		JCoDestination destination = JCoDestinationManager
				.getDestination(ABAP_AS_POOLED);

		Map<String, String> map = mapValue();

		JCoFunction function = destination.getRepository().getFunction(
				map.get("m_name"));// ZHR_PERSONNEL_INFO//ZMM_CREATE_MAT
		if (function == null)
			throw new RuntimeException("ZHR_VACATION_APPROVE not found in SAP.");

		// Get importPrameterList and set value

		// function.getImportParameterList().setValue("IP_CASH_ACCOUNT", "X");
		// function.getImportParameterList().setValue("IP_COST_ACCOUNT", "X");
		// function.getImportParameterList().setValue("IP_OAACT", "ABC");

		function.getTableParameterList().getTable("ZSD_FD32");

		try {
			function.execute(destination);
		} catch (AbapException e) {
			System.out.println(e.toString());
			return;
		}

		System.out.println("STFC_CONNECTION finished:");
		// get export paramter and retrieve value
		// System.out.println(" EP_YEAR: "
		// + function.getExportParameterList().getString("EP_YEAR"));
		// System.out.println(" EP_MONTH: "
		// + function.getExportParameterList().getString("EP_MONTH"));
		// System.out.println();

		JCoParameterList tableParameterList = function.getTableParameterList();
		JCoTable table = function.getTableParameterList().getTable(
				"TB_CASH_ACCOUNT");

		System.out.println(table.getNumRows());

	}

	// 读取结构
	public static void accessSAPStructure() throws JCoException {
		JCoDestination destination = JCoDestinationManager
				.getDestination(ABAP_AS_POOLED);
		JCoFunction function = destination.getRepository().getFunction(
				"ZHR_PERSONNEL_SALARY");
		if (function == null)
			throw new RuntimeException("ZHR_PERSONNEL_SALARY not found in SAP.");

		try {
			function.execute(destination);
		} catch (AbapException e) {
			System.out.println(e.toString());
			return;
		}

		JCoStructure exportStructure = function.getExportParameterList()
				.getStructure("RFCSI_EXPORT");
		System.out.println("System info for "
				+ destination.getAttributes().getSystemID() + ":/n");
		for (int i = 0; i < exportStructure.getMetaData().getFieldCount(); i++) {
			System.out.println(exportStructure.getMetaData().getName(i) + ":/t"
					+ exportStructure.getString(i));
		}
		System.out.println();

		// JCo still supports the JCoFields, but direct access via getXX is more
		// efficient as field iterator
		System.out.println("The same using field iterator: /nSystem info for "
				+ destination.getAttributes().getSystemID() + ":/n");
		for (JCoField field : exportStructure) {
			System.out.println(field.getName() + ":/t" + field.getString());
		}
		System.out.println();
	}

	public static void test_ZMM_GET_RFQ(JCoFunction function) {
		// import
		function.getImportParameterList().setValue("IP_EKORG", "1000");
		function.getImportParameterList().setValue("IP_BSART", "AN");
		// no-------------

	}

	public static void test_ZMM_GET_SOURCELIST(JCoFunction function) {
		// import
		function.getImportParameterList().setValue("IP_EKORG", "8000");
		// no import
		function.getImportParameterList().setValue("IP_WERKS_LOW", "1030");

	}

	public static void test_ZHR_VACATION_APPROVE(JCoFunction function) {
		JCoTable table1 = function.getTableParameterList().getTable(
				"TB_VACATION_APPLY");
		table1.appendRow();
		table1.setValue("OAACT", "1234");
		table1.setValue("PERNR", "01000098");
		table1.setValue("AWART", "E001");
		table1.setValue("BEGDA", "2011-11-08");
		table1.setValue("ENDDA", "2011-11-18");
		// table1.setValue("STDAZ", "0.00");
		// table1.setValue("RET_MSG", "");

	}

	public static void test_ZMM_CREATE_MAT(JCoFunction function) {

		JCoTable table1 = function.getTableParameterList().getTable("TB_MARA");
		table1.appendRow();
		table1.setValue("MATNR", "ZFIN010");
		table1.setValue("MTART", "ZFIN");
		table1.setValue("MBRSH", "M");

		table1.setValue("MATKL", "1301");
		table1.setValue("BISMT", "08976");
		table1.setValue("MEINS", "PCS");

		table1.setValue("BRGEW", "10.000");
		table1.setValue("NTGEW", "0.000");
		table1.setValue("GEWEI", "20.000");
		// -----------------非必填
		// table1.setValue("FERTH", "");
		// table1.setValue("GROES", "");
		// table1.setValue("VOLUM", "");
		// table1.setValue("VOLEH", "");
		// table1.setValue("SPART", "");
		// table1.setValue("EXTWG", "");
		// table1.setValue("TRAGR", "");
		// table1.setValue("BSTME", "");

		// next table=================================

		JCoTable table2 = function.getTableParameterList().getTable("TB_MAKT");
		table2.appendRow();
		table2.setValue("MATNR", "ZFIN010");
		table2.setValue("SPRAS", "1");
		table2.setValue("MAKTX", "TEST FOR KEMI");
		// no
		table2.setValue("LONGTXT", "TEST FOR KEMI");

		// next table=======================================
		JCoTable table3 = function.getTableParameterList().getTable("TB_MARC");
		table3.appendRow();
		table3.setValue("MATNR", "ZFIN010");
		table3.setValue("WERKS", "1000");
		table3.setValue("DISMM", "PD");
		table3.setValue("DISPO", "S02");
		table3.setValue("DISLS", "EX");
		table3.setValue("FHORI", "000");
		table3.setValue("MTVFP", "01");
		// no-----------------------------

		// next table=======================================
		JCoTable table4 = function.getTableParameterList().getTable("TB_MVKE");
		table4.appendRow();
		table4.setValue("MATNR", "ZFIN010");
		table4.setValue("VKORG", "1010");
		table4.setValue("VTWEG", "01");
		table4.setValue("VRKME", "PPC");
		table4.setValue("DWERK", "1000");
		// NO------------------
		// table4.setValue("KONDM", "");
		// table4.setValue("KTGRM", "");

		// next table=======================================
		JCoTable table5 = function.getTableParameterList().getTable("TB_MBEW");
		table5.appendRow();
		table5.setValue("MATNR", "ZFIN010");
		table5.setValue("BWKEY", "1000");
		table5.setValue("VPRSV", "S");
		table5.setValue("BKLAS", "7920");
		table5.setValue("PEINH", "10");

		table5.setValue("VJVPR", "S");
		// NO------------

		JCoTable table6 = function.getTableParameterList()
				.getTable("TB_SMEINH");
		table6.appendRow();
		table6.setValue("MATNR", "ZFIN010");
		table6.setValue("MEINH", "PPC");
		table6.setValue("UMREZ", "3");
		table6.setValue("UMREN", "1");
	}

	public static void test_ZSD_FD32(JCoFunction function) {

		JCoTable table1 = function.getTableParameterList().getTable("TB_FD32");
		table1.appendRow();
		table1.setValue("KUNNR", "C_1010");
		table1.setValue("KKBER", "0001");
		table1.setValue("KLIMK", "10.00");
		// --非必填
		table1.setValue("CTLPC", "001");
		table1.setValue("NXTRV", "20111111");

	}

	public static void test_ZMM_PR_CREAT(JCoFunction function) {
		JCoTable table1 = function.getTableParameterList().getTable(
				"TB_PR_CREAT");
		table1.appendRow();
		table1.setValue("MATNR", "01.01.0081");
		table1.setValue("BSART", "ZNP");
		table1.setValue("WERKS", "1010");
		table1.setValue("LFDAT", "20111111");
		table1.setValue("MENGE", "100");
	}

	public static void test_ZBSF_I_CRM_GET_CREDIT_INFO(JCoFunction function) {
		function.getImportParameterList().setValue("IP_KUNNR", "1");
		function.getImportParameterList().setValue("IP_KKBER", "1010");
	}

	public static void test_ZOA_SEARCH_HELP(JCoFunction function) {
		function.getImportParameterList().setValue("IP_KUNNR_FLAG", "X");
		function.getImportParameterList().setValue("IP_PAEDT_LOW", "20101212");
		function.getImportParameterList().setValue("IP_PAEDT_HIGH", "20111212");

	}

	// 转换为XML
	public static void functionToXmlTransformer() throws JCoException {
		JCoDestination destination = JCoDestinationManager
				.getDestination(ABAP_AS_POOLED);
		JCoFunction function = destination.getRepository().getFunction(
				"ZOA_SEARCH_HELP");// ZHR_PERSONNEL_INFO//ZMM_CREATE_MAT//ZSD_FD32
		if (function == null)
			throw new RuntimeException(" not found in SAP.");

		// test_ZSD_FD32(function);
		// test_ZMM_PR_CREAT(function);
		// test_ZMM_CREATE_MAT(function);
		// test_ZMM_GET_RFQ(function);
		// test_ZMM_GET_SOURCELIST(function);
		// test_ZHR_VACATION_APPROVE(function);
		test_ZOA_SEARCH_HELP(function);

		// JCoListMetaData listMetaData = function.getTableParameterList()
		// .getListMetaData();
		// if (listMetaData != null && listMetaData.getFieldCount() > 0) {
		//
		// for (int i = 0; i < listMetaData.getFieldCount(); i++) {
		// String tableName = listMetaData.getName(i);
		//
		// // JCoMetaData metaData = listMetaData.get(i);
		// // System.out.println(listMetaData.getRecordMetaData(i));
		// JCoRecordMetaData jcoRecordMetaData = listMetaData
		// .getRecordMetaData(i);
		//
		// System.out.println(listMetaData.isOptional(i));
		// System.out.println(tableName);
		// JCoTable table = function.getTableParameterList().getTable(
		// tableName);
		//
		// }
		// }
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			System.out.println("当前时间1:"
					+ df.format(new Date(new Date().getTime() + 28800000)));
			function.execute(destination);
			// System.out.println(function.getTableParameterList().toXML());
			// System.out.println(function.getImportParameterList().toXML());
			System.out.println(function.toXML());

			// JcoFunctionToXmlTransformer transformer = new
			// JcoFunctionToXmlTransformer();
			// String xmlString = (String) transformer
			// .transform(function, "UTF-8");
			System.out.println("当前时间last:"
					+ df.format(new Date(new Date().getTime() + 28800000)));
			System.out.println("result");
			// System.out.println(xmlString);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 执行简单函数
	public static void exeFunctionCall1() throws JCoException {
		JCoDestination destination = JCoDestinationManager
				.getDestination(ABAP_AS_POOLED);
		JCoFunction function = destination.getRepository().getFunction(
				"ZRFC_READ_TABLE_N_TEST");// ZHR_PERSONNEL_INFO//ZMM_CREATE_MAT
		// BAPI_INFORECORD_GETLIST
		// 1.得到RFC传入参数
		// 1.1.字段
		// JCoParameterList inJCoParameterList =
		// function.getImportParameterList();
		// inJCoParameterList.getParameterFieldIterator()

		// 1.2.结构

		// 1.3.表
		// JCoTable table = function.getTableParameterList().getTable(
		// "TB_VACATION_APPLY");
		// table.appendRow();
		// table.setValue("OAACT", "LIANGJZ");
		// table.setValue("AWART", "D001");

		if (function == null)
			throw new RuntimeException(
					"BAPI_PRICES_CONDITIONS not found in SAP.");

		// function.getImportParameterList().setValue("GENERAL_DATA", "X");
		// function.getImportParameterList().setValue("PURCHORG_DATA", "X");
		//
		// function.getImportParameterList().setValue("VENDOR", "X");
		// function.getImportParameterList().setValue("MATERIAL", "X");
		// function.getImportParameterList().setValue("PLANT", "1090");

		try {
			function.execute(destination);
		} catch (AbapException e) {
			System.out.println(e.toString());
			return;
		}

		System.out.println("执行结束");

		JCoParameterList tableParameterList = function.getTableParameterList();
		JCoTable tableOut = function.getTableParameterList().getTable(
				"TI_BAPICONDCT");
		Object otmp = tableOut.getString("OPERATION");
		// for (int i = 0; i < tableOut.getNumRows(); i++) {
		// tableOut.setRow(i);
		// Iterator it = displayField.iterator();
		// // get fields of current record
		// while (it.hasNext()) {
		// String fieldName = (String) it.next();
		// String value = tableOut.getString(fieldName);
		// // do what you need to do with the field and value
		// }
		// }
		System.out.println(otmp);
		System.out.println("取表结束");
		System.out.println(tableOut.getNumRows());

		System.out.println("读取结束");
	}

	public static void main(String[] args) throws JCoException {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		System.out.println("当前时间1:"
				+ df
						.format(new Date(new Date().getTime() + 8 * 60 * 60
								* 1000)));
		connectWithPooled();
		System.out.println("当前时间2:"
				+ df.format(new Date(new Date().getTime() + 28800000)));

		// connectWithPooled();
		exeFunctionCall();
		// functionToXmlTransformer();
		// exeFunctionCall();
		System.out.println("当前时间3:"
				+ df.format(new Date(new Date().getTime() + 28800000)));

		try {
			// SimpleResource simpleResource = new SimpleResource();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}