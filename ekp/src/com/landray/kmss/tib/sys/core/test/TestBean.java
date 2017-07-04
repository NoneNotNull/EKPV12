//package com.landray.kmss.tib.sys.core.test;
//
//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.InputStreamReader;
//import java.util.List;
//
//import com.landray.kmss.common.actions.RequestContext;
//import com.landray.kmss.common.service.IXMLDataBean;
//import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
//import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
//import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreNode;
//import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
//import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreNodeService;
//import com.landray.kmss.tib.sys.soap.provider.interfaces.ITibSysSoapProvider;
//import com.landray.kmss.tib.sys.soap.provider.interfaces.impl.TibSysSoapProvider;
//import com.landray.kmss.util.SpringBeanUtil;
//
//public class TestBean implements IXMLDataBean {
//
//	public List getDataList(RequestContext requestInfo) throws Exception {
////		String jsFilePath = "d://templateXml.txt";
////		File jsFile = new File(jsFilePath); 
////		BufferedReader bis = new BufferedReader(new InputStreamReader(new FileInputStream(jsFile), "UTF-8"));
////		String temp = "";
////		StringBuffer jsStr = new StringBuffer("");
////		while ((temp = bis.readLine()) != null) {
////			jsStr.append(temp+"\n");  
////		}
////		
////		ITibSysSoapProvider provider = new TibSysSoapProvider();
////		
////		provider.transformReceiveData(jsStr.toString());
//		createTableData();
//		return null;
//	}
//	
//	public void createTableData() throws Exception {
//		ITibSysCoreIfaceService tibSysCoreIfaceService = (ITibSysCoreIfaceService) SpringBeanUtil.getBean("tibSysCoreIfaceService");
//		TibSysCoreIface tibSysCoreIface = (TibSysCoreIface) 
//				tibSysCoreIfaceService.findByPrimaryKey("13de32b6235f0f610ec228241c6b9afa");
//		ITibSysCoreNodeService tibSysCoreNodeService = (ITibSysCoreNodeService) SpringBeanUtil.getBean("tibSysCoreNodeService");
//		TibSysCoreNode coreNodeTib = new TibSysCoreNode();
//		coreNodeTib.setFdIface(tibSysCoreIface);
//		coreNodeTib.setFdDataType("object");
//		coreNodeTib.setFdDefName("tib");
//		coreNodeTib.setFdNodeContent("");
//		coreNodeTib.setFdNodeEnable(true);
//		coreNodeTib.setFdNodeLevel("1");
//		coreNodeTib.setFdNodeName("web");
//		coreNodeTib.setFdNodePath("/web");
//		coreNodeTib.setFdDefPath("/tib");
//		tibSysCoreNodeService.add(coreNodeTib);
//		//
//		TibSysCoreNode coreNodeIn = new TibSysCoreNode();
//		coreNodeIn.setFdIface(tibSysCoreIface);
//		coreNodeIn.setFdDataType("object");
//		coreNodeIn.setFdDefName("in");
//		coreNodeIn.setFdNodeContent("");
//		coreNodeIn.setFdNodeEnable(true);
//		coreNodeIn.setFdNodeLevel("2");
//		coreNodeIn.setFdNodeName("Input");
//		coreNodeIn.setFdNodePath("/web/Input");
//		coreNodeIn.setFdDefPath("/tib/in");
//		tibSysCoreNodeService.add(coreNodeIn);
//		//
//		TibSysCoreNode coreNode = new TibSysCoreNode();
//		coreNode.setFdIface(tibSysCoreIface);
//		coreNode.setFdDataType("object");
//		coreNode.setFdDefName("字段1");
//		coreNode.setFdNodeContent("字段1的内容");
//		coreNode.setFdNodeEnable(true);
//		coreNode.setFdNodeLevel("3");
//		coreNode.setFdNodeName("Envelope");
//		coreNode.setFdNodePath("/web/Input/Envelope");
//		coreNode.setFdDefPath("/tib/in/字段1");
//		tibSysCoreNodeService.add(coreNode);
//		//
//		TibSysCoreNode coreNode3 = new TibSysCoreNode();
//		coreNode3.setFdIface(tibSysCoreIface);
//		coreNode3.setFdDataType("object");
//		coreNode3.setFdDefName("字段3");
//		coreNode3.setFdNodeContent("字段3的内容");
//		coreNode3.setFdNodeEnable(true);
//		coreNode3.setFdNodeLevel("4");
//		coreNode3.setFdNodeName("soap:Body");
//		coreNode3.setFdNodePath("/web/Input/Envelope/Body");
//		coreNode3.setFdDefPath("/tib/in/字段1/字段3");
//		tibSysCoreNodeService.add(coreNode3);
//		//
//		TibSysCoreNode coreNode4 = new TibSysCoreNode();
//		coreNode4.setFdIface(tibSysCoreIface);
//		coreNode4.setFdDataType("object");
//		coreNode4.setFdDefName("字段4");
//		coreNode4.setFdNodeContent("字段4的内容");
//		coreNode4.setFdNodeEnable(true);
//		coreNode4.setFdNodeLevel("5");
//		coreNode4.setFdNodeName("web:getMobileCodeInfo");
//		coreNode4.setFdNodePath("/web/Input/Envelope/Body/getMobileCodeInfo");
//		coreNode4.setFdDefPath("/tib/in/字段1/字段3/字段4");
//		tibSysCoreNodeService.add(coreNode4);
//		//
//		TibSysCoreNode coreNode5 = new TibSysCoreNode();
//		coreNode5.setFdIface(tibSysCoreIface);
//		coreNode5.setFdDataType("string");
//		coreNode5.setFdDefName("字段4_1");
//		coreNode5.setFdNodeContent("字段4_1的内容");
//		coreNode5.setFdNodeEnable(true);
//		coreNode5.setFdNodeLevel("6");
//		coreNode5.setFdNodeName("web:mobileCode");
//		coreNode5.setFdNodePath("/web/Input/Envelope/Body/getMobileCodeInfo/mobileCode");
//		coreNode5.setFdDefPath("/tib/in/字段1/字段3/字段4/字段4_1");
//		tibSysCoreNodeService.add(coreNode5);
//		//
//		TibSysCoreNode coreNode6 = new TibSysCoreNode();
//		coreNode6.setFdIface(tibSysCoreIface);
//		coreNode6.setFdDataType("string");
//		coreNode6.setFdDefName("字段4_2");
//		coreNode6.setFdNodeContent("字段4_2的内容");
//		coreNode6.setFdNodeEnable(true);
//		coreNode6.setFdNodeLevel("6");
//		coreNode6.setFdNodeName("web:userID");
//		coreNode6.setFdNodePath("/web/Input/Envelope/Body/getMobileCodeInfo/userID");
//		coreNode6.setFdDefPath("/tib/in/字段1/字段3/字段4/字段4_2");
//		tibSysCoreNodeService.add(coreNode6);
//		
//		//
//	}
//
//}
