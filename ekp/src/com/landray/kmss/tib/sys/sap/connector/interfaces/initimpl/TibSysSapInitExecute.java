package com.landray.kmss.tib.sys.sap.connector.interfaces.initimpl;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.tib.common.init.interfaces.ITibCommonInitExecute;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapJcoSettingService;
import com.landray.kmss.tib.sys.sap.constant.MyDestinationDataProvider;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.ext.DestinationDataProvider;
import com.sap.conn.jco.ext.Environment;

public class TibSysSapInitExecute implements ITibCommonInitExecute {

	public String testConn(HttpServletRequest request) {
		String fdPoolId= request.getParameter("fdPoolId");
		if(StringUtil.isNotNull(fdPoolId)){
			request.setAttribute("fdPoolId", fdPoolId);
		}
		TibSysSapJcoSetting model = null;
		ITibSysSapJcoSettingService tibSysSapJcoSettingService = (ITibSysSapJcoSettingService) SpringBeanUtil
				.getBean("tibSysSapJcoSettingService");
		MyDestinationDataProvider myProvider = MyDestinationDataProvider.getInstance();
		try {
			model =(TibSysSapJcoSetting) tibSysSapJcoSettingService.findByPrimaryKey(fdPoolId);
			
			Properties connectProperties = new Properties();

			String destinationName = model.getFdPoolName();
			/* IP */
			connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST,
					model.getFdTibSysSapCode().getFdServerIp());

			/* 扩展参数 */
			for (int i = 0; i < model.getFdTibSysSapCode().getFdTibSysSapExtList().size(); i++) {
				connectProperties.setProperty(
						(String) DestinationDataProvider.class.getField(
								model.getFdTibSysSapCode()
										.getFdTibSysSapExtList().get(i)
										.getFdExtName()).get(myProvider), model
								.getFdTibSysSapCode().getFdTibSysSapExtList()
								.get(i).getFdExtValue());
			}
			/* 系统编号 */
			connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR,
					model.getFdTibSysSapCode().getFdTibSysSapCode());
			/* 客户端编号 */
			connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT,
					model.getFdTibSysSapCode().getFdClientCode());
			/* 用户名 */
			connectProperties.setProperty(DestinationDataProvider.JCO_USER,
					model.getFdPoolAdmin());
			/* 密码 */
			connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD,
					model.getFdPoolSecret());
			/* 语言 */
			connectProperties.setProperty(DestinationDataProvider.JCO_LANG,
					model.getFdTibSysSapCode().getFdLanguage());
			// if (com.tibSysSap.conn.jco.ext.Environment
			// .isDestinationDataProviderRegistered()) {
			//
			// } else {

			// }

			myProvider.addDestination(destinationName, connectProperties);
			Environment.registerDestinationDataProvider(myProvider);

			JCoDestination ABAP_AS = JCoDestinationManager
					.getDestination(destinationName);

			ABAP_AS.ping();
			Environment.unregisterDestinationDataProvider(myProvider);

			return null;
			
		} catch (Exception e) {
			Environment.unregisterDestinationDataProvider(myProvider);
			e.printStackTrace();
			return e.toString();
		}
	}

	public void importInitJar(HttpServletRequest request) throws Exception {
		// TODO 自动生成的方法存根
		
	}
	
}