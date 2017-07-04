/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service.spring;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;
import org.hibernate.Query;
import org.hibernate.Session;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.IBaseDao;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictListProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.dict.SysDictModelProperty;
import com.landray.kmss.sys.config.dict.SysDictSimpleProperty;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataInterceptor;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataProcessService;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataService;
import com.landray.kmss.tib.common.inoutdata.util.TibCommonInoutdataConfig;
import com.landray.kmss.tib.common.inoutdata.util.TibCommonInoutdataFileUtil;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author 邱建华
 * @version 1.0 2013-1-6
 */
public class TibCommonInoutdataProcessServiceImp implements
		ITibCommonInoutdataProcessService {
	
	private static Log logger = LogFactory
			.getLog(TibCommonInoutdataProcessServiceImp.class);
	
	public void exportToFile(IBaseModel model) throws Exception {
		exportToFile(model, ModelUtil.getModelClassName(model));
	}

	public void exportToFile(String id, String modelName) throws Exception {
		// 准备数据
		IBaseModel model = baseDao.findByPrimaryKey(id, modelName, true);
		exportToFile(model, modelName);
	}

	private void exportToFile(IBaseModel model, String modelName)
			throws Exception {
		String id = model.getFdId();
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("fdId", model.getFdId());
		data.put("class", modelName);
		storeModelData(model, data);

		// 计算文件路径
		String[] arr = modelName.split("\\.");
		String filePath = "_" + arr[arr.length - 1] + ".xml";
		// TODO 此处可以为判断全局分类而把文件存入当前使用分类的模块
//		if (model instanceof IBaseCoreInnerModel
//				&& StringUtil.isNotNull(((IBaseCoreInnerModel) model)
//						.getFdModelName())) {
//			arr = ((IBaseCoreInnerModel) model).getFdModelName().split("\\.");
//		}
		/*
		 * String dirPath = ConfigLocationsUtil.getKmssConfigPath() + "/temp/" +
		 * arr[3] + "/" + arr[4] + "/initdata/"; // 创建文件目录 File dir = new
		 * File(dirPath); if (!dir.exists()) dir.mkdirs();
		 */
		int index = findModelIndex(arr);
		String tempPath;
		File temp;
		if (index < 0) {
			tempPath = ITibCommonInoutdataService.INIT_PATH
					+ ITibCommonInoutdataService.CONF_PATH + "/" + arr[3] + "/"
					+ arr[4] + "/initdata/";

			temp = new File(tempPath);
		}
//		===================
		else{
			tempPath=ITibCommonInoutdataService.INIT_PATH
			+ ITibCommonInoutdataService.CONF_PATH;
			
			for(int i=3;i<index;i++){
				tempPath+="/"+arr[i];
			}
			tempPath+="/initdata/";
			 temp = new File(tempPath);
		}
//		===================
		if (!temp.exists()) {
			temp.mkdirs();
		}
		filePath = tempPath + id + filePath;
		XMLEncoder tempout = new XMLEncoder(new FileOutputStream(filePath));
		try {
			tempout.writeObject(data);
		} finally {
			tempout.close();
		}
		/*
		 * File tempfile = new File(ResourceUtil
		 * .getKmssConfigString("kmss.resource.path") + "/tempinitdata/" +
		 * arr[3]); zip(ResourceUtil.getKmssConfigString("kmss.resource.path") +
		 * "/tempinitdata/" + arr[3] + ".zip", tempfile); // 导出数据 filePath =
		 * dirPath + id + filePath; XMLEncoder out = new XMLEncoder(new
		 * FileOutputStream(filePath)); try { out.writeObject(data); } finally {
		 * out.close(); }
		 */

	}
	
	/*
	 * el的数据加载到data对象中
	 * 
	 * @param model @param data @throws Exception
	 */
	private void storeModelData(IBaseModel model, Map<String, Object> data)
			throws Exception {
		SysDictModel dictModel = SysDataDict.getInstance().getModel(
				ModelUtil.getModelClassName(model));
		List<SysDictCommonProperty> properties = dictModel.getPropertyList();
		for (int i = 0; i < properties.size(); i++) {
			SysDictCommonProperty property = properties.get(i);
			// column为空，则非数据库映射对象，不处理
			if (StringUtil.isNull(property.getColumn()))
				continue;
			Object value = PropertyUtils.getProperty(model, property.getName());
			// 不写入空值
			if (value == null)
				continue;

			if (property instanceof SysDictSimpleProperty) {
				// 简单类型，直接塞值
				if (value instanceof Date) {
					// 注意：这里取出的日期是java.sql.Date类型，不转换无法保存
					value = new Date(((Date) value).getTime());
				}
				data.put(property.getName(), value);
			} else if (property instanceof SysDictModelProperty) {
				// 对象类型，创建子对象后塞值
				IBaseModel childModel = (IBaseModel) value;
				Map<String, Object> childData = new HashMap<String, Object>();
				childData.put("fdId", childModel.getFdId());
				childData.put("class", property.getType());
				data.put(property.getName(), childData);

				// 若是级联数据，则需要把子对象也加载了
				String cascade = ((SysDictModelProperty) property).getCascade();
				if (cascade != null && !cascade.equals("none")) {
					storeModelData(childModel, childData);
				} else {
					// 导出配置的额外属性
					storeExtendModelData(childData, childModel);
				}
			} else if (property instanceof SysDictListProperty) {
				// 列表类型，创建子列表后塞值
				List<IBaseModel> childModels = (List<IBaseModel>) value;
				if (childModels.isEmpty())
					continue;
				List<Map<String, Object>> childDatas = new ArrayList<Map<String, Object>>();
				data.put(property.getName(), childDatas);
				String cascade = ((SysDictListProperty) property).getCascade();
				for (int j = 0; j < childModels.size(); j++) {
					IBaseModel childModel = childModels.get(j);
					Map<String, Object> childData = new HashMap<String, Object>();
					childData.put("fdId", childModel.getFdId());
					// 避免多态的情况，获取的modelName不正确
					childData.put("class", ModelUtil
							.getModelClassName(childModel));
					// childData.put("class", property.getType());
					childDatas.add(childData);
					// 若是级联数据，则需要把子对象也加载了
					if (cascade != null && !cascade.equals("none")) {
						storeModelData(childModel, childData);
					} else {
						// 导出配置的额外属性
						storeExtendModelData(childData, childModel);
					}
				}
			}
		}
	}

	/**
	 * 导出配置的额外属性
	 * 
	 * @param childData
	 * @param exportPropertys
	 * @param model
	 * @throws Exception
	 */
	private void storeExtendModelData(Map<String, Object> childData,
			IBaseModel model) throws Exception {
		Set<String> Props = TibCommonInoutdataConfig.getInstance().getPropertys(
				ModelUtil.getModelClassName(model));
		for (String prop : Props) {
			Object val = getProperty(model, prop);
			if (val != null) {
				childData.put(prop, val);
			}
		}
	}
	
	private Object getProperty(Object bean, String property) throws Exception {
		try {
			return PropertyUtils.getProperty(bean, property);
		} catch (NestedNullException e) {
			return null;
		}
	}
	
	public void downloadData(String[] filePaths) throws Exception {

		File tempfile = new File(ITibCommonInoutdataService.INIT_PATH
				+ ITibCommonInoutdataService.PARENT_PATH +"/");
		String rootPath = ITibCommonInoutdataService.INIT_PATH
				+ ITibCommonInoutdataService.CONF_PATH;
		List<String> modulePathList = new ArrayList<String>();
		List<String> modelNameList = new ArrayList<String>();
		for (int i = 0; i < filePaths.length; i++) {
			String[] modulePath = filePaths[i].split("_");
			String pathName = modulePath[0];
			String modelName = modulePath[1];
			// 分析是否是全局分类或简单分类，如果是，那么包名要改
//			IBaseModel model = baseDao.findByPrimaryKey(id, modelName, true);
//			if (model instanceof IBaseCoreInnerModel
//					&& StringUtil.isNotNull(((IBaseCoreInnerModel) model)
//							.getFdModelName())) {
//				modelName = ((IBaseCoreInnerModel) model).getFdModelName();
//			}
			modelNameList.add(modelName);
			if (modulePathList.contains(pathName))
				continue;
			File path = new File(rootPath + pathName + "initdata");
			modulePathList.add(path.toString());
		}
		zip(ITibCommonInoutdataService.INIT_PATH + "/" + ITibCommonInoutdataService.EXPORT_ZIP, tempfile,
				modulePathList, modelNameList);

	}

	public static void zip(String zipFileName, File file, List path,
			List modelNamelist) throws Exception {

		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
				zipFileName));
		try {
			zip(out, file, null, path, modelNamelist);
		} finally {
			out.close();
		}
	}

	/*
	 * 递归的读取文件夹和文件，加入到zip
	 */
	private static void zip(ZipOutputStream out, File f, String base,
			List path, List modelNameList) throws Exception {
		out.flush();
		if (f.isDirectory()) {
			File[] fc = f.listFiles();
			if (base != null)
				out.putNextEntry(new ZipEntry(base + "/"));
			base = base == null ? "" : base + "/";
			for (int i = 0; i < fc.length; i++) {
				for (int j = 0; j < path.size(); j++) {
					if (((String) path.get(j)).indexOf(f.toString()) != -1) {
						zip(out, fc[i], base + fc[i].getName(), path,
								modelNameList);
						break;
					}
				}

			}
		} else {
			XMLDecoder xmlIn = null;
			Map<String, Object> data = null;
			try {
				xmlIn = new XMLDecoder(new FileInputStream(f));
				data = (Map<String, Object>) xmlIn.readObject();
			} finally {
				if (xmlIn != null) {
					xmlIn.close();
				}
			}
			InputStream in = null;
			try {
				in = new FileInputStream(f);
				for (int i = 0; i < modelNameList.size(); i++) {
					if (data.get("class").equals((String) modelNameList.get(i))) {
						out.putNextEntry(new ZipEntry(base));
						byte[] b = new byte[in.available()];
						in.read(b);
						out.write(b);
						break;
					}
				}
			} finally {
				// 关闭流
				IOUtils.closeQuietly(in);
			}
		}
	}
	
	/**
	 * 解压上传的文件
	 * @param zipFile
	 * @param destination
	 * @throws Exception 
	 */
	public void unzip(String zipFile, String destination) throws Exception {
		ZipFile zip = new ZipFile(zipFile);
		Enumeration en = zip.getEntries();
		ZipEntry entry = null;
		byte[] buffer = new byte[8192];
		int length = -1;
		InputStream input = null;
		BufferedOutputStream bos = null;
		File file = null;
		try {
			// 先删除之前旧数据目录
			File tempFile = new File(destination);
			if (tempFile.exists()) {
				TibCommonInoutdataFileUtil.deleteDir(tempFile);
			}
			while (en.hasMoreElements()) {
				entry = (ZipEntry) en.nextElement();
				if (entry.isDirectory()) {
					continue;
				}
				input = zip.getInputStream(entry);
				file = new File(destination, entry.getName());
				if (!file.getParentFile().exists()) {
					// 创建存放目录
					file.getParentFile().mkdirs();
				} 
				bos = new BufferedOutputStream(new FileOutputStream(file));
				try {
					while (true) {
						length = input.read(buffer);
						if (length == -1)
							break;
						bos.write(buffer, 0, length);
					}
				} finally {
					bos.close();
					input.close();
				}
			}
		} finally {
			zip.close();
		}

	}
	
	public void importFile(File file, TibCommonProcessRuntime processRuntime) {
		Map<String, IBaseModel> modelCache = new HashMap<String, IBaseModel>();
		importFromFile(file, modelCache, processRuntime, true);
	}

	public void importFromFile(File file, Map<String, IBaseModel> modelCache,
			TibCommonProcessRuntime processRuntime, boolean flush) {
		try {
			if (importMainModel(file, modelCache, processRuntime, flush)) {
				processRuntime.addSuccessCount();
				if (logger.isDebugEnabled())
					logger.debug("成功导入文件信息：" + file.getAbsolutePath());
			} else {
				processRuntime.addIgnoreCount();
				if (logger.isDebugEnabled())
					logger.debug("数据信息已经存在：" + file.getAbsolutePath());
			}
		} catch (Throwable e) {
			processRuntime.addFialureFileInfo(file);
			logger.error("导入文件信息时发生错误：" + file.getAbsolutePath(), e);
		}
	}

	private boolean importMainModel(File file,
			Map<String, IBaseModel> modelCache, TibCommonProcessRuntime processRuntime,
			boolean flush) throws Exception {
		// 读取数据
		XMLDecoder in = null;
		Map<String, Object> data = null;
		try {
			in = new XMLDecoder(new FileInputStream(file));
			data = (Map<String, Object>) in.readObject();
		} finally {
			if (in != null) {
				in.close();
			}
		}
		// 删除该导入路径，避免再次导入
		processRuntime.getFilePathList().remove(file.getCanonicalPath());
		String childModelKey = getModelKey(data);
		processRuntime.getFilePathMap().remove(childModelKey);

		// 判断数据是否存在，是否更新原有数据
		IBaseModel model = getModel(data);
		if (model != null && !processRuntime.isUpdate()) {
			return false;
		}
		// 转换数据后，更新到数据库中
		IBaseModel baseModel = restoreModelData(model, data, modelCache,
				processRuntime);
		boolean rtn = saveOrUpdate(baseModel, modelCache, processRuntime);
		if (flush) {
			baseDao.getHibernateTemplate().flush();
		}
		return rtn;
	}

	private boolean saveOrUpdate(IBaseModel baseModel,
			Map<String, IBaseModel> modelCache, TibCommonProcessRuntime processRuntime)
			throws Exception {
		String fdId = baseModel.getFdId();
		String className = ModelUtil.getModelClassName(baseModel);
		IBaseModel model = baseDao.findByPrimaryKey(fdId, className, true);
		// 保存或者更新之前拦截事件
		ITibCommonInoutdataInterceptor tibCommonInoutdataInterceptor = TibCommonInoutdataConfig
				.getInstance().getInterceptor(
						ModelUtil.getModelClassName(baseModel));
		if (model != null) {
			if (processRuntime.isUpdate()) {
				if (tibCommonInoutdataInterceptor != null) {
					baseModel = tibCommonInoutdataInterceptor.beforeUpdate(baseDao,
							baseModel);
				}
				if (baseModel != null) {
					baseDao.getHibernateTemplate().update(baseModel);
					processRuntime.addUpdateCount();
				} else {
					baseDao.getHibernateTemplate().delete(model);
					modelCache.remove(className + "#" + fdId);
					processRuntime.addDeleteCount();
					return false;
				}
			}
		} else {
			if (tibCommonInoutdataInterceptor != null) {
				baseModel = tibCommonInoutdataInterceptor.beforeSave(baseDao,
						baseModel);
			}
			if (baseModel != null) {
				baseDao.getHibernateTemplate().save(baseModel);
				processRuntime.addAddCount();
			} else {
				modelCache.remove(className + "#" + fdId);
				return false;
			}
		}
		return true;
	}
	
	private IBaseModel restoreModelData(IBaseModel model,
			Map<String, Object> data, Map<String, IBaseModel> modelCache,
			TibCommonProcessRuntime processRuntime) throws Exception {
		// 获取model类路径和id，创建对象，并在modelCache中缓存，以便子对父的关系可以获取到正确的对象
		String modelName = (String) data.get("class");
		if (model == null) {
			model = (IBaseModel) Class.forName(modelName).newInstance();
		}
		model.setFdId((String) data.get("fdId"));
		modelCache.put(getModelKey(data), model);

		IBaseModel tempBaseModel = null;
		List propertyList = SysDataDict.getInstance().getModel(modelName)
				.getPropertyList();
		// 遍历数据字典，查找数据，并存到model中
		for (int n = 0; n < propertyList.size(); n++) {
			SysDictCommonProperty property = (SysDictCommonProperty) propertyList
					.get(n);
			if (StringUtil.isNull(property.getName())) {
				continue;
			}

			// 数据不可写入，忽略该属性的操作
			if (!PropertyUtils.isWriteable(model, property.getName())) {
				if (logger.isDebugEnabled()) {
					logger.debug("属性：" + property.getName() + "不可写入");
				}
				continue;
			}

			Object value = data.get(property.getName());
			if (property instanceof SysDictModelProperty) {
				Map<String, Object> childData = (Map<String, Object>) value;
				// 对象类型，若是级联关系，则连子信息一起获取，否则，到数据库中找相应对象
				SysDictModelProperty sysDictModelProperty = (SysDictModelProperty) property;
				value = importChildModel(sysDictModelProperty.getCascade(),
						sysDictModelProperty, childData, modelCache,
						processRuntime);
				// 获取值为空，属性必填，并且是随机导入必填字段
				if (value == null && sysDictModelProperty.isNotNull()
						&& processRuntime.isImportRequired()) {
					value = getRandomModel(sysDictModelProperty);
				}
			} else if (property instanceof SysDictListProperty) {
				// 列表类型，若是级联关系，则连子信息一起获取，否则，到数据库中找相应对象
				SysDictListProperty sysDictListProperty = (SysDictListProperty) property;
				List childModels = (List) PropertyUtils.getProperty(model,
						sysDictListProperty.getName());
				if (childModels == null) {
					childModels = new ArrayList();
				}
				// 清空数据
				childModels.clear();
				List<Map<String, Object>> childDatas = (List<Map<String, Object>>) value;
				if (childDatas != null) {
					for (int i = 0; i < childDatas.size(); i++) {
						Map<String, Object> childData = childDatas.get(i);
						IBaseModel childModel = importChildModel(
								sysDictListProperty.getCascade(),
								sysDictListProperty, childData, modelCache,
								processRuntime);
						if (childModel != null) {
							childModels.add(childModel);
						} else {
							// 获取值为空，属性必填，并且是随机导入必填字段
							if (childModels.isEmpty()
									&& sysDictListProperty.isNotNull()
									&& processRuntime.isImportRequired()) {
								childModel = getRandomModel(sysDictListProperty);
								if (childModel != null) {
									childModels.add(childModel);
								}
							}
						}
					}
				} else {
					// 获取值为空，属性必填，并且是随机导入必填字段
					if (childModels.isEmpty()
							&& sysDictListProperty.isNotNull()
							&& processRuntime.isImportRequired()) {
						IBaseModel childModel = getRandomModel(sysDictListProperty);
						if (childModel != null) {
							childModels.add(childModel);
						}
					}
				}
				value = childModels;
			} else if (property instanceof SysDictSimpleProperty) {
				// 获取值为空，属性必填，并且是随机导入必填字段
				if (StringUtil.isNull(String.valueOf(value)) && property.isNotNull()
						&& processRuntime.isImportRequired()) {
					if (tempBaseModel == null) {
						tempBaseModel = getRandomModel(modelName, null);
						if (tempBaseModel != null) {
							value = PropertyUtils.getProperty(tempBaseModel,
									property.getName());
						}
					}
				}
			}
			// 设值
			PropertyUtils.setProperty(model, property.getName(), value);
		}
		return model;
	}

	/**
	 * 导入子对象
	 * 
	 * @param cascade
	 *            关联
	 * @param childData
	 *            子对象数据
	 * @param modelCache
	 * @param processRuntime
	 * @return
	 * @throws Exception
	 */
	private IBaseModel importChildModel(String cascade,
			SysDictCommonProperty property, Map<String, Object> childData,
			Map<String, IBaseModel> modelCache, TibCommonProcessRuntime processRuntime)
			throws Exception {
		if (childData == null) {
			return null;
		}
		IBaseModel childModel = null;
		if (cascade != null && !cascade.equals("none")) {
			IBaseModel model = getModel(childData);
			childModel = restoreModelData(model, childData, modelCache,
					processRuntime);
			try {
				if (false == saveOrUpdate(childModel, modelCache,
						processRuntime)) {
					childModel = null;
				}
			} catch (Exception e) {
				logger.error("保存或更新子对象失败！ " + " 属性：" + property.getName(), e);
				childModel = null;
			}
		} else {
			childModel = getModelInCache(childData, modelCache);
			if (childModel == null) {
				// 判断是否需要导入
				String childModelKey = getModelKey(childData);
				if (processRuntime.getFilePathMap().containsKey(childModelKey)) {
					String childModelValue = processRuntime.getFilePathMap()
							.get(childModelKey);
					File childModelFile = new File(childModelValue);
					if (childModelFile.exists()) {
						// 关联优先导入子对象（递归）
						importFromFile(childModelFile, modelCache,
								processRuntime, false);

						childModel = getModel(childData);
					}
				}
			}
			if (childModel == null) {
				// 根据扩展导出属性进行查找关联
				String where = TibCommonInoutdataConfig.getInstance().getWhere(
						property.getType());
				if (where != null) {
					List<String> params = TibCommonInoutdataConfig.getInstance()
							.getParams(property.getType());
					List<HQLParameter> paramList = new ArrayList<HQLParameter>();
					for (String param : params) {
						HQLParameter hqlParameter = new HQLParameter(param,
								childData.get(param));
						paramList.add(hqlParameter);
					}
					childModel = getModel(property.getType(), where, paramList);
				}
			}
		}
		return childModel;
	}
	
	/**
	 * 获取随机数据
	 * 
	 * @param type
	 * @param where
	 * @return
	 */
	private IBaseModel getRandomModel(String type, String where) {
		Session session = baseDao.getHibernateSession();
		String sql = "from " + type + " " + ModelUtil.getModelTableName(type)
				+ (StringUtil.isNotNull(where) ? " where " + where : "");
		try {
			Query query = session.createQuery("select count(*) " + sql);
			int n = ((Long) query.uniqueResult()).intValue();
			if (n == 0) {
				// 没有数据
				return null;
			}
			// 随机取值
			Random random = new Random();
			query = session.createQuery(sql);
			query.setFirstResult(random.nextInt(n));
			query.setMaxResults(1);
			return (IBaseModel) query.uniqueResult();
		} catch (Exception e) {
			logger.error("获取随机数据失败！" + sql, e);
			return null;
		}
	}

	private IBaseModel getModel(String type, String where,
			List<HQLParameter> parameterList) {
		Session session = baseDao.getHibernateSession();
		String sql = "from " + type + " " + ModelUtil.getModelTableName(type)
				+ (StringUtil.isNotNull(where) ? " where " + where : "");
		try {
			Query query = session.createQuery(sql);
			HQLUtil.setParameters(query, parameterList);
			query.setMaxResults(1);
			return (IBaseModel) query.uniqueResult();
		} catch (Exception e) {
			logger.error("根据扩展导出属性获取导入数据失败！type：" + type + " sql: " + sql, e);
			return null;
		}
	}

	private IBaseModel getRandomModel(SysDictModelProperty property) {
		return getRandomModel(property.getType(), property.getWhere());
	}

	private IBaseModel getRandomModel(SysDictListProperty property) {
		return getRandomModel(property.getType(), property.getWhere());
	}
	
	/**
	 * 从缓存中加载数据，若缓存中没有，则从数据库加载
	 * 
	 * @param data
	 * @param modelCache
	 * @return
	 * @throws Exception
	 */
	private IBaseModel getModelInCache(Map<String, Object> data,
			Map<String, IBaseModel> modelCache) throws Exception {
		String key = getModelKey(data);
		if (modelCache.containsKey(key)) {
			return modelCache.get(key);
		}
		IBaseModel model = getModel(data);
		if (model != null) {
			modelCache.put(key, model);
		}
		return model;
	}

	private String getModelKey(Map<String, Object> data) {
		return (String) data.get("class") + "#" + (String) data.get("fdId");
	}

	private IBaseModel getModel(Map<String, Object> data) throws Exception {
		String id = (String) data.get("fdId");
		String modelName = (String) data.get("class");
		IBaseModel model = baseDao.findByPrimaryKey(id, modelName, true);
		return model;
	}
	
	/**
	 * 支持多层model 只要class 里面到model 层为终止点
	 * @param attr
	 * @return
	 */
	public int findModelIndex(String[] attr){
		for(int i=0;i<attr.length;i++){
			if("model".equalsIgnoreCase(attr[i])){
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * 返回相关联的Model数据
	 * @param id
	 * @param modelName
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	private List<Map<String, String>> getModelInfo(
			String id, String modelName) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Class<?> clazz = Class.forName(modelName);
		IBaseModel model = (IBaseModel) baseDao.getHibernateSession().get(clazz, id);
		SysDictModel dictModel = SysDataDict.getInstance().getModel(
				ModelUtil.getModelClassName(model));
		List<SysDictCommonProperty> properties = dictModel.getPropertyList();
		Map<String, String> notRelationData = new HashMap<String, String>();
		for (int i = 0; i < properties.size(); i++) {
			SysDictCommonProperty property = properties.get(i);
			// column为空，则非数据库映射对象，不处理
			String column = property.getColumn();
			if (StringUtil.isNull(column))
				continue;
			Object value = PropertyUtils.getProperty(model, property.getName());
			// 空值不处理
			if (value == null)
				continue;
			if (property instanceof SysDictSimpleProperty) {
				if ("fd_template_id".equals(column)) {
					notRelationData.put("fdId", String.valueOf(value));
				}
				if ("fd_template_name".equals(column)) {
					notRelationData.put("modelName", String.valueOf(value));
				}
				if ("fd_ref_id".equals(column)) {
					notRelationData.put("fdId", String.valueOf(value));
				}
				// 获取相关联函数,设置相关联函数的model
				if ("fd_integration_type".equals(column)) {
					notRelationData.put("fdIntegrationType", String.valueOf(value));
					if ("1".equals(String.valueOf(value))) {
						notRelationData.put("modelName", "com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting");
					} else if ("3".equals(String.valueOf(value))) {
						notRelationData.put("modelName", "com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain");
					}
					
				}
			} else if (property instanceof SysDictModelProperty) {
				String childModelName = property.getType();
				if(childModelName.contains(ITibCommonInoutdataService.RELATION_HEAD_PATH) 
						|| childModelName.contains(ITibCommonInoutdataService.GLOBAL_CATEGORY_PATH)) {
					// 对象类型，创建子对象
					IBaseModel childModel = (IBaseModel) value;
					Map<String, String> childData = new HashMap<String, String>();
					childData.put("fdId", childModel.getFdId());
					childData.put("modelName", childModelName);
					rtnList.add(childData);
				}
			} else if (property instanceof SysDictListProperty) {
				// 列表类型，创建子列表
				List<IBaseModel> childModels = (List<IBaseModel>) value;
				if (childModels.isEmpty())
					continue;
				for (int j = 0; j < childModels.size(); j++) {
					IBaseModel childModel = childModels.get(j);
					String childModelName = ModelUtil.getModelClassName(childModel);
					if(childModelName.contains(ITibCommonInoutdataService.RELATION_HEAD_PATH) 
							|| childModelName.contains(ITibCommonInoutdataService.GLOBAL_CATEGORY_PATH)) {
						Map<String, String> childData = new HashMap<String, String>();
						childData.put("fdId", childModel.getFdId());
						// 避免多态的情况，获取的modelName不正确
						childData.put("modelName", childModelName);
						rtnList.add(childData);	
					}
				}
			}
		}
		// 特殊情况处理，这里是为了解决没有关联对象，但实际关联的情况
		if (!notRelationData.isEmpty() 
				&& StringUtil.isNotNull(notRelationData.get("modelName"))
				&& StringUtil.isNotNull(notRelationData.get("fdId"))) {
			rtnList.add(notRelationData);
			// 如果是相关联函数的话，则无需下一步
			if (notRelationData.containsKey("fdIntegrationType")) {
				return rtnList;
			}
			String notRelationFdId = notRelationData.get("fdId");
			String notRelationModelName = notRelationData.get("modelName");
			// 设置加入需要导出的对象
			setModelInfoList(rtnList, notRelationFdId, notRelationModelName);
			/*
			 * 解决应用模块注册没有关联的情况
			 * 通过templateName找到对应启用模块的的一些字段信息，
			 * 只取第一个 如果存在多个认为相关配置是相同的，可以限制不能配置多个相同的
			 */
			ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) 
					SpringBeanUtil.getBean("tibCommonMappingModuleService");
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setWhereBlock("tibCommonMappingModule.fdTemplateName=:fdTemplateName " +
					"and tibCommonMappingModule.fdUse=1");
			hqlInfo.setParameter("fdTemplateName", notRelationModelName);
			List<TibCommonMappingModule> tibCommonMappingModuleList = tibCommonMappingModuleService
					.findList(hqlInfo);
			TibCommonMappingModule moduleSett = tibCommonMappingModuleList.get(0);
			// 添加需要导出的对象
			Map<String, String> moduleSettMap = new HashMap<String, String>();
			moduleSettMap.put("fdId", moduleSett.getFdId());
			moduleSettMap.put("modelName", ModelUtil.getModelClassName(moduleSett));
			rtnList.add(moduleSettMap);
		}
		return rtnList;
	}
	
	/**
	 * 把相关联的model信息加入list集合，递归一层一层找
	 */
	public void setModelInfoList (List<Map<String, String>> modelInfoList, 
			String id, String modelName) throws Exception {
		List<Map<String, String>> mapList = getModelInfo(id, modelName);
		outer:
		for (Map<String, String> map : mapList) {
			// 是否已经存在此文件
			for (Map<String, String> m : modelInfoList) {
				if (m.get("fdId").equals(map.get("fdId"))) {
					continue outer;
				}
			}
			if (!modelInfoList.contains(map)) {
				// 加入需要导出的map
				modelInfoList.add(map);
				setModelInfoList(modelInfoList, map.get("fdId"), map.get("modelName"));
			}
		}
	}
	
	private IBaseDao baseDao = null;
	
	public void setBaseDao(IBaseDao baseDao) {
		this.baseDao = baseDao;
	}

	public IBaseDao getBaseDao() {
		return baseDao;
	}

}
