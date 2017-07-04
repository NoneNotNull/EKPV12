package com.landray.kmss.tib.sys.core.provider.service;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.util.ResourceUtil;

/**
 * provider接口信息业务对象接口
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public interface ITibSysCoreIfaceService extends IBaseService {
	
	public String getIfaceJson(String key, String count) throws Exception;
	
	public String getIfaceJsonXml(String key) throws Exception;
	
	public String getImplListJson(String key) throws Exception;
	
	public boolean isControl(String inXml) throws Exception;
	
	/**
	 * 数据执行
	 * @param tibDataFill
	 * @return
	 * @throws Exception
	 */
	public String dataExecute(String tibDataFill) throws Exception;
	
	public void updateImplIfaceXmlStatus(String ifaceId) throws Exception;
	
	/**
	 * 导入初始化数据
	 * @throws Exception
	 */
	public void importInit() throws Exception;
	
	public static final String ZIP_INIT_PATH = ConfigLocationsUtil.getWebContentPath();
	public static final String TEMP_INIT_PATH = ResourceUtil.getKmssConfigString("kmss.resource.path");
	public static final String OPERATION_PATH = "/WEB-INF/KmssConfig/tib/sys/core/provider/tibinitdata";
	// 源路径
	public static final String SOURCE_PATH = ZIP_INIT_PATH + OPERATION_PATH;
	// 目标存放文件路径
	public static final String TARGET_PATH = TEMP_INIT_PATH +"/TIB/TibIface"+ OPERATION_PATH;
	// 目标起始路径
	public static final String TARGET_CONF_PATH = TEMP_INIT_PATH +"/TIB/TibIface/WEB-INF/KmssConfig";
}
