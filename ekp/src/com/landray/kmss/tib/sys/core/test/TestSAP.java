package com.landray.kmss.tib.sys.core.test;

//import java.io.File;
//import java.io.FileOutputStream;
//import java.math.BigDecimal;
//import java.util.Properties;
//
//import com.sap.conn.jco.AbapException;
//import com.sap.conn.jco.JCoContext;
//import com.sap.conn.jco.JCoDestination;
//import com.sap.conn.jco.JCoDestinationManager;
//import com.sap.conn.jco.JCoException;
//import com.sap.conn.jco.JCoFunction;
//import com.sap.conn.jco.JCoParameterList;
//import com.sap.conn.jco.JCoStructure;
//import com.sap.conn.jco.JCoTable;
//import com.sap.conn.jco.ext.DestinationDataProvider;

public class TestSAP {
//	static String ABAP_AS_POOLED = "192.168.2.159"; // 连接池名称
//	static {
//		Properties connectProperties = new Properties();
//		connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST,
//				"192.168.2.159");
//		// connectProperties.setProperty(DestinationDataProvider.JCO_SAPROUTER,
//		// "/H/121.33.189.248/S/3299/H/");
//
//		connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, "00");
//		connectProperties
//				.setProperty(DestinationDataProvider.JCO_CLIENT, "800");
//		connectProperties.setProperty(DestinationDataProvider.JCO_USER, "573");
//		connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD,
//				"573573");
//		connectProperties.setProperty(DestinationDataProvider.JCO_LANG, "ZH");
//		// JCO_PEAK_LIMIT - Maximum number of idle connections kept open by the
//		// destination.
//		connectProperties.setProperty(
//				DestinationDataProvider.JCO_POOL_CAPACITY, "3");
//
//		// JCO_POOL_CAPACITY - Maximum number of active connections that
//		// can be created for a destination simultaneously
//		connectProperties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT,
//				"10");
//		createDataFile(ABAP_AS_POOLED, "jcoDestination", connectProperties);
//	}
//
//	static void createDataFile(String name, String suffix, Properties properties) {
//		File cfg = new File(name + "." + suffix);
//		if (!cfg.exists()) {
//			try {
//				FileOutputStream fos = new FileOutputStream(cfg, false);
//				properties.store(fos, "for tests only !");
//				fos.close();
//			} catch (Exception e) {
//				throw new RuntimeException(
//						"Unable to create the destination file "
//								+ cfg.getName(), e);
//			}
//		}
//	}
//
//	// 测试连接
//	public static void connectWithPooled() throws JCoException {
//		JCoDestination destination = JCoDestinationManager
//				.getDestination(ABAP_AS_POOLED);
//		destination.ping();
//		System.out.println("打印详细信息:");
//		System.out.println(destination.getAttributes());
//		System.out.println();
//	}
//
//	// 执行函数
//	public static void exeFunction() throws JCoException {
//		JCoDestination destination = JCoDestinationManager
//				.getDestination(ABAP_AS_POOLED);
//		JCoFunction function = destination.getRepository().getFunction(
//				"BAPI_ACC_GL_POSTING_POST");// ZHR_PERSONNEL_INFO//ZMM_CREATE_MAT
//		if (function == null)
//			throw new RuntimeException(
//					"BAPI_ACC_GL_POSTING_POST not found in SAP.");
//
//		JCoParameterList paramList = function.getImportParameterList();
//		JCoStructure headStructure = paramList.getStructure("DOCUMENTHEADER");
//		headStructure.setValue("USERNAME", "DDIC");
//		headStructure.setValue("HEADER_TXT", "预制凭证测试31");
//		headStructure.setValue("COMP_CODE", "2800");
//		headStructure.setValue("FISC_YEAR", "2011");
//		headStructure.setValue("DOC_DATE", "20110413");
//		headStructure.setValue("PSTNG_DATE", "20110418");
//		headStructure.setValue("TRANS_DATE", "20110418");
//		headStructure.setValue("FIS_PERIOD", "4");
//		headStructure.setValue("DOC_TYPE", "SA");
//		headStructure.setValue("REF_DOC_NO_LONG", "测试长文本31");
//
//		// Get importPrameterList and set value
//		// function.getImportParameterList().setValue("IP_CASH_ACCOUNT", "X");
//		// function.getImportParameterList().setValue("IP_COST_ACCOUNT", "X");
//		// function.getImportParameterList().setValue("IP_OAACT", "ABC");
//
//		JCoTable table = function.getTableParameterList().getTable("ACCOUNTGL");
//		table.appendRow();
//		table.setValue("ITEMNO_ACC", "1");
//		table.setValue("GL_ACCOUNT", "0011110201");
//		table.setValue("COMP_CODE", "2800");
//		table.setValue("PSTNG_DATE", "20110418");
//		table.setValue("DOC_TYPE", "SA");
//		table.setValue("FISC_YEAR", "2011");
//		table.setValue("FIS_PERIOD", "4");
//		table.setValue("ITEM_TEXT", "ffffffffff");
//
//		table.appendRow();
//		table.setValue("ITEMNO_ACC", "2");
//		table.setValue("GL_ACCOUNT", "0013010101");
//		table.setValue("COMP_CODE", "2800");
//		table.setValue("PSTNG_DATE", "20110418");
//		table.setValue("DOC_TYPE", "SA");
//		table.setValue("FISC_YEAR", "2011");
//		table.setValue("FIS_PERIOD", "4");
//		table.setValue("ITEM_TEXT", "gggggggggg");
//
//		JCoTable table2 = function.getTableParameterList().getTable(
//				"CURRENCYAMOUNT");
//		table2.appendRow();
//		table2.setValue("ITEMNO_ACC", "1");
//		table2.setValue("CURRENCY", "CNY");
//		table2.setValue("AMT_DOCCUR", new BigDecimal(24));
//
//		table2.appendRow();
//		table2.setValue("ITEMNO_ACC", "2");
//		table2.setValue("CURRENCY", "CNY");
//		table2.setValue("AMT_DOCCUR", new BigDecimal(-24));
//
//		JCoFunction function1 = destination.getRepository().getFunction(
//				"BAPI_TRANSACTION_COMMIT");
//		function1.getImportParameterList().setValue("WAIT", "X");
//
//		JCoFunction function2 = destination.getRepository().getFunction(
//				"BAPI_TRANSACTION_ROLLBACK");
//		try {
//			JCoContext.begin(destination);
//
//			function.execute(destination);
//
//			function1.execute(destination);
//
//			// function2.execute(destination);
//
//			JCoContext.end(destination);
//
//		} catch (AbapException e) {
//			System.out.println(e.toString());
//			return;
//		}
//
//		System.out.println("执行完毕：");
//		// get export paramter and retrieve value
//		System.out.println(" OBJ_KEY: "
//				+ function.getExportParameterList().getString("OBJ_KEY"));
//		System.out.println(" OBJ_SYS: "
//				+ function.getExportParameterList().getString("OBJ_SYS"));
//		System.out.println(" OBJ_TYPE: "
//				+ function.getExportParameterList().getString("OBJ_TYPE"));
//		System.out.println();
//
//		JCoTable tableOut = function.getTableParameterList().getTable("RETURN");
//		System.out.println("RETURN rows：" + tableOut.getNumRows());
//
//	}
//
//	public static void main(String[] args) throws Exception {
//		try {
//			exeFunction();
//
//			System.out.println("done");
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//
//		}
//	}
}
