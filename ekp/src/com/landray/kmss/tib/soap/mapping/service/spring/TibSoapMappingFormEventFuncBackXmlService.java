package com.landray.kmss.tib.soap.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.util.SpringBeanUtil;

public class TibSoapMappingFormEventFuncBackXmlService implements IXMLDataBean {


	private static final Log log = LogFactory
			.getLog(TibSoapMappingFormEventFuncBackXmlService.class);
	
	private ITibSysSoapMainService tibSysSoapMainService;

	// 执行函数返回xml
	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		// TODO 自动生成的方法存根
		String xml = requestInfo.getParameter("xml");
		String funcId=requestInfo.getParameter("funcId");
		TibSysSoapMain tibSysSoapMain=(TibSysSoapMain)tibSysSoapMainService.findByPrimaryKey(funcId);
		ITibSysSoap tibSysSoap = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
		SoapInfo soapInfo=new SoapInfo();
		soapInfo.setRequestXml(xml);
		soapInfo.setTibSysSoapMain(tibSysSoapMain);
		
		List<Map<String, String>> rtnList = new ArrayList<Map<String,String>>();
		Map<String, String> map = new HashMap<String, String>(1);
	
		
		ITibSysSoapRtn  tibSysSoapRtn= tibSysSoap.inputToOutputRtn(soapInfo);
		
		Document doc=tibSysSoapRtn.getRtnDocument();
		String result="";
		if(doc!=null){
			result =DOMHelper.nodeToString(doc, true);
		}
		else{
			log.debug("出现空数据~!");
		}
		
		/*******************old
//    正式
		String resultXml=tibSysSoap.inputToAllXml(soapInfo);
		String[] mergeXml=new String[4];
		mergeXml[0]="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		mergeXml[1]="<web ID=\"!{fdId}\">".replace("!{fdId}", funcId);
		mergeXml[2]=resultXml;
		mergeXml[3]="</web>";
		String result=StringUtils.join(mergeXml);
		****************/
		
//		测试
//		InputStream in=TibSoapMappingFormEventFuncBackXmlService.class.getResourceAsStream("respone.xml");
//		String result=IOUtils.toString(in);
//		System.out.println(result);
		try {
//			map.put("funcBackXml", result);
			map.put("funcBackXml", result);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("message", e.toString());
			// if (log.isDebugEnabled()) {
			 log.debug("执行函数时发生错误。执行的xml为\n" + xml);
			// }
		}
		rtnList.add(map);
		return rtnList;
	}

	public ITibSysSoapMainService gettibSysSoapMainService() {
		return tibSysSoapMainService;
	}

	public void settibSysSoapMainService(ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}

	
}
