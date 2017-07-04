package com.landray.kmss.tib.common.inoutdata.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.inoutdata.service.spring.TibCommonProcessRuntime;
import com.landray.kmss.util.ResourceUtil;

/**
 * 主文档业务对象接口
 * 
 * @author 邱建华
 * @version 1.0 2013-01-05
 */
public interface ITibCommonInoutdataService extends IBaseService {
	/**
	 * 将一批的文件导出到文件系统中
	 * 
	 * @param modelName
	 * @param ids
	 * @throws Exception
	 */
	public void exportToFile(String modelName, String[] ids) throws Exception;
	
	/**
	 * 将某个文件导出到文件系统中
	 * 
	 * @param modelName
	 * @param ids
	 * @throws Exception
	 */
	public void exportToFile(String modelName, String id) throws Exception;
	
	public void startExport(String[] filePaths) throws Exception;
	
	/**
	 * 上传初始化数据
	 * 
	 * @param locale
	 * @return
	 * @throws Exception
	 */
	public void uploadInitData(FormFile formFile) throws Exception;
	
	/**
	 * 获取系统基础数据的模块列表
	 * (暂时不需要用，因为sys/initdata已经有此功能)
	 * @param locale
	 * @return
	 * @throws Exception
	 */
	//public List getBaseDataFileDirInfos(Locale locale) throws Exception;
	
	/**
	 * 获取可初始化数据的模块列表
	 * 
	 * @param locale
	 * @return
	 * @throws Exception
	 */
	public List getFileDirInfos(Locale locale) throws Exception;
	
	/**
	 * 开始导入，传入模块路径_model的名字 例如:/km/doc/_com.landray.kmss.km.doc.model.ModelName
	 * 
	 * @param type
	 *            导入类型
	 * @param filePaths
	 * @param isImportRequired
	 *            是否随机导入必填字段（当字段为空时）
	 * @param isUpdate
	 *            是否更新原有数据
	 */
	public void startImport(String type, String[] filePaths,
			boolean isImportRequired, boolean isUpdate, String pathPrefex) throws Exception;
	
	/**
	 * 把相关联的model信息加入list集合，递归一层一层找
	 * @param request
	 * @param modelInfoList
	 * @param id
	 * @param modelName
	 * @throws Exception
	 */
	public void setModelInfoList (List<Map<String, String>> modelInfoList, 
			String id, String modelName) throws Exception;
	/**
	 * 获取导入操作的实时数据
	 * 
	 * @return
	 */
	public TibCommonProcessRuntime getProcessRuntime();
	
	/**
	 * 停止导入
	 */
	public void stopImport();
	
	/**
	 * Constant
	 */
	public static final String INIT_PATH = ResourceUtil
			.getKmssConfigString("kmss.resource.path");
	// 存放导出文件的路径
	public static final String CONF_PATH = "/TibTempInoutdata/WEB-INF/KmssConfig";
	// 存放文件resource后的一级文件名，PARENT_PATH要与CONF_PATH的开头路径一致
	public static final String PARENT_PATH = "/TibTempInoutdata";
	// 上传存放压缩包ZIP的名称
	public static final String UPLOAD_ZIP = "TibUploadInout.zip";
	// 导出存放压缩包ZIP的名称
	public static final String EXPORT_ZIP = "TibInoutdata.zip";
	// 需要导出的相关联文件的头路径
	public static final String RELATION_HEAD_PATH = "com.landray.kmss.tib";
	// 全局分类记录
	public static final String GLOBAL_CATEGORY_PATH = "com.landray.kmss.sys.category.model";
	

	/**
	 * 系统基础数据存放路径
	 */
//	public static final String BASE_DATA_PATH = ConfigLocationsUtil
//			.getKmssConfigPath() + "/third/tibCommon/common/baseinitdata";

}
