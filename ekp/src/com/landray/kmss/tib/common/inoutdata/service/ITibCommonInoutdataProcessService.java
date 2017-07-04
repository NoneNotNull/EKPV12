/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.tib.common.inoutdata.service.spring.TibCommonProcessRuntime;

/**
 * @author 邱建华
 * @version 1.0 2013-1-6
 */
public interface ITibCommonInoutdataProcessService {

	/**
	 * 将一个model导出到文件中
	 * 
	 * @param id
	 * @param modelName
	 * @throws Exception
	 */
	public void exportToFile(String id, String modelName) throws Exception;

	/**
	 * 将一个model导出到文件中
	 * 
	 * @param model
	 * @throws Exception
	 */
	public void exportToFile(IBaseModel model) throws Exception;
	
	public void downloadData(String[] filePaths) throws Exception;
	
	/**
	 * 解压上传的文件
	 * 
	 * @param zipFilePath
	 * @param targetPath
	 */
	public void unzip(String zipFilePath, String targetPath) throws Exception;
	
	/**
	 * 将一个文件导入到系统中（新开事务），返回true表示导入成功，false表示文件已经存在
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public void importFile(File file, TibCommonProcessRuntime processRuntime);
	
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
	
	public IBaseDao getBaseDao();
}
