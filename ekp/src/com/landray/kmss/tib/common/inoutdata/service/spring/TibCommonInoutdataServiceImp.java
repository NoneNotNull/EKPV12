package com.landray.kmss.tib.common.inoutdata.service.spring;

import java.beans.XMLDecoder;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.upload.FormFile;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.common.service.IDispatchCoreService;
import com.landray.kmss.sys.config.design.SysCfgModule;
import com.landray.kmss.sys.config.design.SysConfigs;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataProcessService;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataService;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 主文档业务接口实现
 * 
 * @author 邱建华
 * @version 1.0 2013-01-05
 */
public class TibCommonInoutdataServiceImp extends BaseServiceImp 
		implements ITibCommonInoutdataService, Runnable {

	private static Log logger = LogFactory
			.getLog(TibCommonInoutdataServiceImp.class);
	
	private ITibCommonInoutdataProcessService tibCommonInoutdataProcessService;
	
	public void setTibCommonInoutdataProcessService(
			ITibCommonInoutdataProcessService tibCommonInoutdataProcessService) {
		this.tibCommonInoutdataProcessService = tibCommonInoutdataProcessService;
	}

	private IDispatchCoreService dispatchCoreService;

	public void setDispatchCoreService(IDispatchCoreService dispatchCoreService) {
		this.dispatchCoreService = dispatchCoreService;
	}
	
	private TibCommonProcessRuntime processRuntime = new TibCommonProcessRuntime();

	public TibCommonProcessRuntime getProcessRuntime() {
		return processRuntime;
	}

	public void exportToFile(String modelName, String[] ids) throws Exception {
		for (int i = 0; i < ids.length; i++) {
			exportToFile(modelName, ids[i]);
		}		
	}
	
	public void exportToFile(String modelName, String id) throws Exception {
		tibCommonInoutdataProcessService.exportToFile(id, modelName);
		List<?> datas = dispatchCoreService.exportData(id, modelName);
		for (int i = 0; i < datas.size(); i++) {
			tibCommonInoutdataProcessService.exportToFile((IBaseModel) datas.get(i));
		}
	}
	
	public void startExport(String[] filePaths) throws Exception {
		tibCommonInoutdataProcessService.downloadData(filePaths);
	}

	public void uploadInitData(FormFile formFile) throws Exception {
		File file = new File(INIT_PATH);
		if (!file.exists()) {
			file.mkdirs();
		}
		FileOutputStream fos = new FileOutputStream(INIT_PATH
				+ "/" + UPLOAD_ZIP);// 获取文件流对象
		fos.write(formFile.getFileData());// 开始写入
		fos.flush();
		fos.close();
		// 上传了数据之后，需要解压zip包到指定的位置
		String zipFilePath = INIT_PATH + "/" + UPLOAD_ZIP;
		String targetPath = INIT_PATH + PARENT_PATH +"/";
		tibCommonInoutdataProcessService.unzip(zipFilePath, targetPath);

	}
	
//	public List getBaseDataFileDirInfos(Locale locale) throws Exception {
//		return getFileDirInfos(locale, ConfigLocationsUtil.getWebContentPath(),
//				BASE_DATA_PATH);
//	}

	private List getFileDirInfos(Locale locale, String path, String basePath)
			throws Exception {
		String[] dirs = ConfigLocationsUtil.getConfigLocationArray(path,
				"initdata", path);
		SysConfigs configs = SysConfigs.getInstance();
		List<String> modulePathList = new ArrayList<String>();
		JSONArray array = new JSONArray();
		for (int i = 0; i < dirs.length; i++) {
			if (dirs[i] == null || basePath == null
					|| dirs[i].length() < basePath.length()) {
				continue;
			}
			String modulePath = dirs[i].substring(basePath.length());
			File isnull = new File(dirs[i]);
			if (!isnull.exists()) {
				continue;
			}
			String[] childrens = isnull.list();
			if (childrens.length != 0) {
				String[] arr = modulePath.split("/");
				
				String resultArrPath = getModelPathByArr(modulePath);
				if(StringUtil.isNull(resultArrPath)){
					continue;
				}
				modulePath =resultArrPath;
				// 修改为循环获取到为止
				List<Object> moduleList = loopDesign(configs, modulePath);
				if (moduleList == null) {
					continue;
				}
				SysCfgModule module = (SysCfgModule) moduleList.get(0);
				modulePath = (String) moduleList.get(1);
				if (module == null) {
					logger.warn("没有找到模块design.xml配置：" + modulePath);
					continue;
				}
//				if (modulePathList.contains(modulePath))
//					continue;
				modulePathList.add(modulePath);
				
				String name = module.getMessageKey();
				if (StringUtil.isNotNull(name))
					name = ResourceUtil.getString(name, locale);
				if (StringUtil.isNull(name))
					name = modulePath;

				File file = new File(dirs[i]);
				File[] datafiles = file.listFiles();
				int count = 1;
				Map<String, Integer> countMap = new HashMap<String, Integer>();
				JSONObject jObj = getJObj(array, modulePath);
				// 是否已经存在此元素标记
				boolean flag = true;
				if (jObj.isEmpty()) {
					jObj.put("text", name);
					jObj.put("value", modulePath);
				} else {
					flag = false;
				}
				
				for (int j = 0; j < datafiles.length; j++) {
					XMLDecoder xmlIn = new XMLDecoder(new FileInputStream(
							datafiles[j]));
					Map<String, Object> data = (Map<String, Object>) xmlIn
							.readObject();
					xmlIn.close();
					String modelPath = (String) data.get("class");
					if (countMap.get(modelPath) == null) {
						countMap.put(modelPath, count);
					} else {
						int dataCount = countMap.get(modelPath);
						countMap.put(modelPath, dataCount + 1);
					}
				}
				JSONArray jarray = null;
				// 如果是不存在的元素则new一个，否则不需要
				if (flag) {
					jarray = new JSONArray();
				} else {
					jarray = (JSONArray) jObj.get("children");
				}
				Iterator it = countMap.entrySet().iterator();
				while (it.hasNext()) {
					JSONObject childObj = new JSONObject();
					Entry en = (Entry) it.next();
					SysDictModel sysDictModel = SysDataDict.getInstance()
							.getModel((String) en.getKey());
					String key = sysDictModel.getMessageKey();
					// MessageKey为空，取modelName
					if (StringUtil.isNull(key)) {
						key = sysDictModel.getModelName();
					} else {
						key = ResourceUtil.getString(key, locale);
					}
					childObj.put("text", key + "(" + en.getValue() + ")");
					childObj.put("value", modulePath + "_" + en.getKey());
					jarray.add(childObj);
				}
				// 如果是不存在的元素需要下面操作，否则不需要
				if (flag) {
					jObj.put("children", jarray);
					array.add(jObj);
				}
			}
		}
		return array;
	}
	
	/**
	 * 为了design中message
	 * @param configs
	 * @param modulePath
	 * @return
	 */
	private List<Object> loopDesign(SysConfigs configs, String modulePath) {
		SysCfgModule module = configs.getModule(modulePath);
		if (module == null) {
			String temp = modulePath.substring(0, modulePath.length()-1);
			modulePath = temp.substring(0, temp.lastIndexOf("/") + 1);
			if (StringUtil.isNotNull(modulePath))
				return loopDesign(configs, modulePath);
			else 
				return null;
		} else {
			List<Object> list = new ArrayList<Object>();
			list.add(module);
			list.add(modulePath);
			return list;
		}
	}
	
	private JSONObject getJObj(JSONArray jarray, String modulePath) {
		for (int k = 0, len = jarray.size(); k < len; k++){
			JSONObject tempJObj = (JSONObject) jarray.get(k);
			if (tempJObj.containsValue(modulePath)) {
				return tempJObj;
			}
		}
		return new JSONObject();
	}
	
	private String getModelPathByArr(String modulePath){
		if (isDataInit(modulePath)) {
			return modulePath.substring(0, modulePath.lastIndexOf("/") + 1);
		} else {
			return null;
		}
	}
	
	private boolean isDataInit(String modulePath){
		String initData=modulePath.substring(modulePath.lastIndexOf("/")+1, modulePath.length()) ;
		if ("initdata".equals(initData)) {
			return true;
		}
		return false;
	}
	
	public List getFileDirInfos(Locale locale) throws Exception {
		String path = INIT_PATH + PARENT_PATH;
		String basePath = INIT_PATH + CONF_PATH;
		return getFileDirInfos(locale, path, basePath);
	}
	
	public void startImport(String type, String[] filePaths,
			boolean isImportRequired, boolean isUpdate, String pathPrefex) throws Exception {
		if (processRuntime.isRunning())
			return;
		LinkedList<String> filePathList = new LinkedList<String>();
		Map<String, String> filePathMap = new HashMap<String, String>();
		//String pathPrefex = INIT_PATH + CONF_PATH;
//		if ("baseImport".equals(type)) {
//			// 系统基础数据导入路径
//			pathPrefex = BASE_DATA_PATH;
//		}

		for (int i = 0; i < filePaths.length; i++) {
			String[] dir = filePaths[i].split("_");
			if (dir.length > 1) {
				appendFileList(new File(pathPrefex + dir[0]), dir[1],
						filePathList, filePathMap);
			}
		}
		Collections.sort(filePathList, new Comparator<String>() {
			public int compare(String o1, String o2) {
				return o1.compareTo(o2);
			}
		});
		processRuntime.setImportRequired(isImportRequired);
		processRuntime.setUpdate(isUpdate);
		processRuntime.setFilePathList(filePathList);
		processRuntime.setFilePathMap(filePathMap);
		new Thread(this).start();
	}
	
	private void appendFileList(File dir, String modelName,
			List<String> filePathList, Map<String, String> filePathMap)
			throws Exception {
		File[] files = dir.listFiles();
		for (int i = 0; i < files.length; i++) {
			File file = files[i];
			if (file.isDirectory()) {
				appendFileList(file, modelName, filePathList, filePathMap);
			} else {
				XMLDecoder xmlIn = null;
				if (file.getName().endsWith(".xml")) {
					try {
						xmlIn = new XMLDecoder(new FileInputStream(file));
						Map<String, Object> data = (Map<String, Object>) xmlIn
								.readObject();
						if (data.get("class").equals(modelName)) {
							filePathList.add(file.getCanonicalPath());
							filePathMap.put((String) data.get("class") + "#"
									+ (String) data.get("fdId"), file
									.getCanonicalPath());
						}
					} finally {
						if (xmlIn != null) {
							xmlIn.close();
						}
					}
				}
			}
		}
	}

	public void run() {
		processRuntime.setStatus(TibCommonProcessRuntime.STATUS_STARTING);
		try {
			if (checkStop())
				return;
			processRuntime.setStatus(TibCommonProcessRuntime.STATUS_RUNNING);
			LinkedList<String> filePathList = processRuntime.getFilePathList();
			processRuntime.setProcessCount(filePathList.size());
			int i = 0;
			while (!filePathList.isEmpty()) {
				if (checkStop())
					return;
				File file = new File(filePathList.poll());
				if (file.exists()) {
					tibCommonInoutdataProcessService.importFile(file, processRuntime);
					if (++i % 10 == 0) {
						IBaseDao baseDao = tibCommonInoutdataProcessService
								.getBaseDao();
						baseDao.getHibernateSession().flush();
						baseDao.getHibernateSession().clear();
					}
				}
			}
			processRuntime.setStatus(TibCommonProcessRuntime.STATUS_FINISH);
		} catch (Throwable e) {
			processRuntime.setStatus(TibCommonProcessRuntime.STATUS_ERROR);
			logger.error("初始化数据时发生错误", e);
		}
	}
	
	private boolean checkStop() {
		if (processRuntime.getStatus() == TibCommonProcessRuntime.STATUS_STOPING) {
			processRuntime.setStatus(TibCommonProcessRuntime.STATUS_STOPED);
			return true;
		}
		return false;
	}
	
	/**
	 * 停止导入
	 */
	public void stopImport() {
		if (processRuntime.isRunning())
			processRuntime.setStatus(TibCommonProcessRuntime.STATUS_STOPING);
	}

	public void setModelInfoList(List<Map<String, String>> modelInfoList,
			String id, String modelName) throws Exception {
		tibCommonInoutdataProcessService.setModelInfoList(modelInfoList, id, modelName);
	}
	
}
