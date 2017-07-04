package com.landray.kmss.common.test;

import java.io.File;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.util.ResourceUtil;

public class KmssTestUtil {
	public static String getDefaultUser() {
		return ResourceUtil.getKmssConfigString("kmss.admin.loginName");
	}

	public static String[] getSpringFiles() {
		String path = new File("WebContent").getAbsolutePath();
		return ConfigLocationsUtil.getConfigLocationArray(path, "spring.xml",
				"file:///" + path);
	}
}
