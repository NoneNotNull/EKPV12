package com.landray.kmss.tib.sys.soap.connector.util.executor;

import java.util.HashMap;
import java.util.Map;

import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.eviware.soapui.impl.wsdl.WsdlOperation;
import com.eviware.soapui.model.iface.Response;
import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.TibSysSoapEasHandler;
import com.landray.kmss.tib.sys.soap.connector.util.executor.helper.SoapHelper;
import com.landray.kmss.tib.sys.soap.constant.TibSysSoapConstant;

public class TestExecutor {
	
	public static void main(String[] args) throws Exception {
		
		String wsdl="http://localhost:9000/SoapContext/SoapPort?wsdl";
		String soapVs=TibSysSoapConstant.SOAPVERSON_SOAP11;
		
//		ITibSysSoapExecuteHandler handler=new TibSysSoapDefaultExecuteHandler(wsdl,soapVs,"login");
		
		WsdlInterface[]  faces=SoapHelper.getWsdlInterfacesNoCache(wsdl, soapVs, null, null);
		
		System.out.println(faces.length);
		Map hMap=new HashMap<String, String>();
		
		hMap.put("dbType", "1");
		hMap.put("dcName", "dcName");
		hMap.put("password", "123");
		hMap.put("slnName", "123444");
		//构造执行过程中的控制类
		TibSysSoapEasHandler handler=new TibSysSoapEasHandler(null,null,wsdl,soapVs,"login",hMap);
		
		WsdlInterface  iface= handler.getTargetWsdlFace();
		WsdlOperation operation= iface.getOperationByName("login");
		
//		设置执行器
		SoapExecutor executor=new SoapExecutor(handler,handler.getPostData());
//		执行目标函数
		Response  response=(Response)executor.executeSoapui();
		System.out.println(response.getContentAsString());
		
		
	}

}
