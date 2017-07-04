package com.landray.kmss.tib.sys.eas.connector.interfaces;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.tib.common.init.interfaces.ITibCommonInitExecute;
import com.landray.kmss.util.ResourceUtil;

public interface ITibSysEasInitExecute extends ITibCommonInitExecute {
	
	public static final String EAS_NAME = "EAS";
	public static final String ZIP_INIT_PATH = ConfigLocationsUtil.getWebContentPath();
	public static final String TEMP_INIT_PATH = ResourceUtil.getKmssConfigString("kmss.resource.path");
	public static final String ZIPFILE = ZIP_INIT_PATH +"/WEB-INF/KmssConfig/tib/sys/eas/connector/TibInit_eas.zip";
	public static final String DESTPATH = TEMP_INIT_PATH +"/TIB/TibInit_eas";
	public static final String UPDATE_FILE = "_TibSysSoapSetting.xml";
}
