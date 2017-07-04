package com.landray.kmss.tib.sys.k3.connector.interfaces;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.tib.common.init.interfaces.ITibCommonInitExecute;
import com.landray.kmss.util.ResourceUtil;

public interface ITibSysK3InitExecute extends ITibCommonInitExecute {
	public static final String K3_NAME = "K3";
	public static final String ZIP_INIT_PATH = ConfigLocationsUtil.getWebContentPath();
	public static final String TEMP_INIT_PATH = ResourceUtil.getKmssConfigString("kmss.resource.path");
	public static final String ZIPFILE = ZIP_INIT_PATH +"/WEB-INF/KmssConfig/tib/sys/k3/connector/TibInit_k3.zip";
	public static final String DESTPATH = TEMP_INIT_PATH +"/TIB/TibInit_k3";
	public static final String UPDATE_FILE = "_TibSysSoapSetting.xml";
}
