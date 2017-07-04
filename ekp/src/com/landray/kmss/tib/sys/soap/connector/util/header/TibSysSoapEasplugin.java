package com.landray.kmss.tib.sys.soap.connector.util.header;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.util.HtmlUtils;

import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.util.executor.SoapExecutor;
import com.landray.kmss.tib.sys.soap.connector.util.executor.handler.TibSysSoapEasHandler;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapEasplugin extends ISoapHeaderType {
	private Log logger = LogFactory.getLog(this.getClass());

	@Override
	public void buildAuthContext(SubmitContext context, WsdlRequest request,
			TibSysSoapSetting soapuiSet) throws Exception {
		executeEAS(soapuiSet);
		super.buildAuthContext(context, request, soapuiSet);
	}

	private ITibSysSoapRtn executeEAS(TibSysSoapSetting soapuiSet)
			throws Exception {

		if (logger.isWarnEnabled()) {
			logger.warn("执行webservice EAS 扩展~!");
		}
		String userName = null;
		String password = null;
		String wsdl = null;
		String soapVersion = null;
		String opernateName = null;
		Map easMap = null;
		wsdl = findEasWsdl(soapuiSet.getFdWsdlUrl());
		if (StringUtil.isNull(wsdl)) {
			if (logger.isWarnEnabled()) {
				logger.warn("webservice 地址为空");
			}
			return null;
		}
		// 获取扩展参数信息
		easMap = soapuiSet.getExtendInfoMap();
		// 受保护
		if (soapuiSet.getFdProtectWsdl()) {
			userName = soapuiSet.getFdloadUser();
			password = soapuiSet.getFdloadPwd();
		}
		soapVersion = soapuiSet.getFdSoapVerson();
		// eas 登录方法名
		opernateName = "login";
		if (logger.isWarnEnabled()) {
			logger.warn("初始化EAS数据成功~!wsdl:" + wsdl);
		}
		TibSysSoapEasHandler easHandler = new TibSysSoapEasHandler(userName,
				password, wsdl, soapVersion, opernateName, easMap);
		SoapExecutor executor = new SoapExecutor(easHandler, easHandler
				.getPostData());
		ITibSysSoapRtn rtn = executor.executeSoapui();
		if (ITibSysSoapRtn.ERP_SOAPUI_EAR_TYPE_SUCCESS.equals(rtn.getRtnType())) {
			return rtn;
		} else {
			// 用抛出异常了让外面的方法停止
			throw new Exception("EAS 登录出现异常,登录异常返回信息：\n"
					+ HtmlUtils.htmlEscape(rtn.getRtnContent()));
		}
	}

	private String findEasWsdl(String sourceWsdl) {
		int lastIndex = sourceWsdl.lastIndexOf("/");
		String realWsdl = null;
		if (lastIndex > -1) {
			realWsdl = sourceWsdl.substring(0, lastIndex + 1) + "EASLogin?wsdl";
		}
		return realWsdl;
	}

}
