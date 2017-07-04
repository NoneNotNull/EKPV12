package com.landray.kmss.kms.multidoc.service.spring;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.framework.plugin.core.config.IExtension;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataModel;
import com.landray.kmss.sys.metadata.interfaces.ISysDictLoader;
import com.landray.kmss.sys.property.interfaces.ISysPropertyTemplate;
import com.landray.kmss.sys.property.util.SysPropertyUtil;
import com.landray.kmss.sys.search.interfaces.ISysSearchCategoryDictLoader;
import com.landray.kmss.sys.search.service.spring.SysSearchDictLoaderImp;
import com.landray.kmss.sys.search.util.SysSearchPlugin;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 搜索数据字典加载器（扩展点实现）
 * 
 * @author 缪贵荣
 * @version 1.0 2011-03-16
 */
public class KmsMultidocSearchCategoryDictLoader extends SysSearchDictLoaderImp
		implements ISysSearchCategoryDictLoader {

	private ISysDictLoader sysDictLoader;

	public void setSysDictLoader(ISysDictLoader sysDictLoader) {
		this.sysDictLoader = sysDictLoader;
	}

	public SysDictModel loadDict(IExtension extension, String cateId)
			throws Exception {
		SysSearchPlugin plugin = new SysSearchPlugin(extension);
		if (StringUtil.isNotNull(cateId)) {
			Class<?> modelClass = plugin.getModelClass();
			Class<?> templateClass = plugin.getTemplateClass();
			if (modelClass != null
					&& templateClass != null
					&& IExtendDataModel.class.isAssignableFrom(modelClass)
					&& ISysPropertyTemplate.class
							.isAssignableFrom(templateClass)) {
				SysDataDict dict = SysDataDict.getInstance();
				String templateServiceName = dict.getModel(
						plugin.getTemplateName()).getServiceBean();
				IBaseService templateService = (IBaseService) SpringBeanUtil
						.getBean(templateServiceName);

				ISysPropertyTemplate template = (ISysPropertyTemplate) templateService
						.findByPrimaryKey(cateId);

				IExtendDataModel dataModel = (IExtendDataModel) modelClass
						.newInstance();

				// 设置元数据路径
				dataModel.setExtendFilePath(SysPropertyUtil
						.getExtendFilePath(template));

				SysDictModel dictModel = sysDictLoader.loadDict(dataModel);

				return dictModel;
			}
		}
		return loadDict(plugin.getModelName());
	}

}
