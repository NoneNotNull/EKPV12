package com.landray.kmss.tib.sys.soap.provider.interfaces.impl;

import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl.TibSysBaseProvider;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;

/**
 * soap服务提供者
 * 
 * @author fat_tian
 * 
 */
public class TibSysSoapProvider extends TibSysBaseProvider {

	private ITibSysSoap tibSysSoap;

	private ITibSysSoapMainService tibSysSoapMainService;

	public void setTibSysSoapMainService(
			ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}

	@Override
	public Object executeData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		String refId = coreStore.getImplFuncId();
		TibSysSoapMain soapMain = (TibSysSoapMain) tibSysSoapMainService
				.findByPrimaryKey(refId, TibSysSoapMain.class, true);
		SoapInfo soapInfo = new SoapInfo();
		if (data instanceof String) {
			soapInfo.setRequestXml((String) data);
		} else if (data instanceof Document) {
			String requestXml = ParseSoapXmlUtil.nodeToString((Document) data);
			soapInfo.setRequestXml(requestXml);
		}
		soapInfo.setTibSysSoapMain(soapMain);
		String result = tibSysSoap.inputToAllXml(soapInfo);
		return "<web>"+ result +"</web>";
	}

	public ITibSysSoap getTibSysSoap() {
		return tibSysSoap;
	}

	public void setTibSysSoap(ITibSysSoap tibSysSoap) {
		this.tibSysSoap = tibSysSoap;
	}

	@Override
	public Object getTemplateXml(String funcId, boolean isDoc) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibSysSoapMain.wsMapperTemplate");
		hqlInfo.setWhereBlock("tibSysSoapMain.fdId = :funcId");
		hqlInfo.setParameter("funcId", funcId);
		List<Object> list = tibSysSoapMainService.findList(hqlInfo);
		Object obj = list.get(0);
		String templateXml = obj.toString();
		Document doc = ProviderXmlOperation.stringToDoc(templateXml);
		// 移除禁用节点
		ParseSoapXmlUtil.getTemplateXmlLoop(doc.getDocumentElement().getChildNodes());
		if (isDoc) {
			return doc;
		} else {
			return ProviderXmlOperation.DocToString(doc);
		}
	}
	
	@Override
	public Object transformFinishData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		Document responseDoc = null;
		if (data instanceof String) {
			responseDoc = ProviderXmlOperation.stringToDoc((String) data);
		} else if (data instanceof Document) {
			responseDoc = (Document) data;
		}
		// 移除注释
		// RemoveComment(responseDoc.getChildNodes());
		StringBuffer tibBackXml = new StringBuffer("");
		String bodyXpath = "/web/Output/Envelope/Body/*";
		List<Element> bodyEleList = ProviderXmlOperation.selectElement(bodyXpath, responseDoc);
		if (bodyEleList != null && bodyEleList.size() > 0) {
			tibBackXml.append("<tib><out>");
			TibSysCoreUtil.loopXMLUnite(bodyEleList.get(0).getChildNodes(), tibBackXml);
			tibBackXml.append("</out><return><result>1</result><message/></return></tib>");
		} else {
			tibBackXml.append("<tib><out/><result>0</result><message>");
			String faultPpath = "/web/Fault";
			Element faultEle = ProviderXmlOperation.selectElement(faultPpath, responseDoc).get(0);
			if (faultEle != null) {
				tibBackXml.append(ParseSoapXmlUtil.nodeToString(faultEle));
			}
			tibBackXml.append("</message></return></tib>");
		}
		return tibBackXml.toString();
	}
}
