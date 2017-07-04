package com.landray.kmss.tib.sys.sap.provider.interfaces.impl;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl.TibSysBaseProvider;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.landray.kmss.tib.sys.sap.constant.TibSysSapReturnConstants;
import com.landray.kmss.util.SpringBeanUtil;

public class TibSysSapJcoProvider extends TibSysBaseProvider {

	TibSysSapJcoProvider() {
		super();
	}
	
	private ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil;
	

	public ITibSysSapJcoFunctionUtil getTibSysSapJcoFunctionUtil() {
		return tibSysSapJcoFunctionUtil;
	}

	public void setTibSysSapJcoFunctionUtil(
			ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil) {
		this.tibSysSapJcoFunctionUtil = tibSysSapJcoFunctionUtil;
	}

	@Override
	public Object executeData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		String rfcId = coreStore.getImplFuncId();
		String requestXml = "";
		if (data instanceof String) {
			requestXml = (String)data;
		} else if (data instanceof Document) {
			requestXml = ProviderXmlOperation.DocToString((Document)data);
		}
		TibSysSapReturnVo rtnVo = new TibSysSapReturnVo();
		rtnVo = tibSysSapJcoFunctionUtil.getXMLtoFunction(
				rfcId, requestXml);
		return rtnVo;
	}
	
	@Override
	public Object transformFinishData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		Document responseDoc = null;
		StringBuffer tibBackXml = new StringBuffer("");
		// SAP返回类型 进行处理
		if (data instanceof TibSysSapReturnVo) {
			TibSysSapReturnVo tvo = (TibSysSapReturnVo) data;
			// 出现异常进行处理
			if (TibSysSapReturnConstants.TIBSYSSAP_EXCEPTION_RETURN.equals(tvo
					.getReturnType())) {
				tibBackXml.append("<tib><out/><return><result>0</result><message>");
				Exception error = tvo.getRtnExcepton();
				if (error == null) {
					error = new Exception(" SAP 交互发生错误~  ");
				}
				tibBackXml.append(error.getMessage());
				tibBackXml.append("</message></return></tib>");
			} else {
				tibBackXml.append("<tib><out>");
				responseDoc = ProviderXmlOperation.stringToDoc((String)tvo.getResult());
				String outXpath = "/jco/export/structure/*";
				String outTableXpath = "/jco/tables/table[@isin='0']/*";
				NodeList eleList = ProviderXmlOperation.selectNode(outXpath, responseDoc);
				NodeList eleTableList = ProviderXmlOperation.selectNode(outTableXpath, responseDoc);
				TibSysCoreUtil.loopXMLUnite(eleList, tibBackXml);
				TibSysCoreUtil.loopXMLUnite(eleTableList, tibBackXml);
				tibBackXml.append("</out><return><result>1</result><message/></return></tib>");
			}
		}
		return tibBackXml.toString();
	}
	
	@Override
	public Object getTemplateXml(String funcId, boolean isDoc) throws Exception {
		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
		String funcXml = (String) tibSysSapJcoFunctionUtil
				.getFunctionToXmlById(funcId);
		if (isDoc) {
			return ProviderXmlOperation.stringToDoc(funcXml);
		} else {
			return funcXml;
		}
	}

}
