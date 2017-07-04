package com.landray.kmss.tib.sys.sap.connector.connect;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.ext.DestinationDataProvider;

/**
 * This class is to connect to SAP server using JCO Library 3.0.
 * 
 * @author <a href="mailto:makoto@zebra"></a>
 * @version 1.0
 */
public class TibSysSapJcoConnect {
	private JCoDestination destination;

	public synchronized JCoDestination doInitialize(TibSysSapJcoSetting model)
			throws JCoException, IllegalArgumentException,
			IllegalAccessException, NoSuchFieldException, SecurityException {
		Properties connectProperties = new Properties();
		String destinationName = model.getFdPoolName();
		/* IP */
		connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, model
				.getFdTibSysSapCode().getFdServerIp());

		/* 扩展参数 */
		for (int i = 0; i < model.getFdTibSysSapCode().getFdTibSysSapExtList().size(); i++) {
			connectProperties.setProperty(
					(String) DestinationDataProvider.class.getField(
							model.getFdTibSysSapCode().getFdTibSysSapExtList().get(i)
									.getFdExtName()).get(
							DestinationDataProvider.class), model
							.getFdTibSysSapCode().getFdTibSysSapExtList().get(i)
							.getFdExtValue());
		}
		/* 系统编号 */
		connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, model
				.getFdTibSysSapCode().getFdTibSysSapCode());
		/* 客户端编号 */
		connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, model
				.getFdTibSysSapCode().getFdClientCode());
		/* 用户名 */
		connectProperties.setProperty(DestinationDataProvider.JCO_USER, model
				.getFdPoolAdmin());
		/* 密码 */
		connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, model
				.getFdPoolSecret());
		/* 语言 */
		connectProperties.setProperty(DestinationDataProvider.JCO_LANG, model
				.getFdTibSysSapCode().getFdLanguage());
		if (model.getFdConnectType() == 2) {
			/* 最大空闲连接数 */
			connectProperties.setProperty(
					DestinationDataProvider.JCO_POOL_CAPACITY, model
							.getFdPoolCapacity().toString());
			/* 超时 */
			connectProperties.setProperty(
					DestinationDataProvider.JCO_MAX_GET_TIME, model
							.getFdPoolTime().toString());
			/* 最大活动连接数 */
			connectProperties.setProperty(
					DestinationDataProvider.JCO_PEAK_LIMIT, model
							.getFdPoolNumber().toString());
		}
		createDataFile(destinationName, "jcoDestination", connectProperties);
		destination = JCoDestinationManager.getDestination(destinationName);
		
		return destination;
	}

	static void createDataFile(String name, String suffix, Properties properties) {
		FileOutputStream fos = null;
		File cfg = new File(name + "." + suffix);
		try {
			fos = new FileOutputStream(cfg, false);
			properties.store(fos, "for connection");
		} catch (Exception e) {
			throw new RuntimeException("Unable to create the destination file "
					+ cfg.getName(), e);
		} finally {
			if (null != fos) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
