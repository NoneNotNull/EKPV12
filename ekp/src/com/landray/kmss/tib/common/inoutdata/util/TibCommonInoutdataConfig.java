/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.util.ClassUtils;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.landray.kmss.sys.datainit.service.ISysDatainitInterceptor;
import com.landray.kmss.tib.common.inoutdata.model.TibCommonInoutdata;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataInterceptor;
import com.landray.kmss.util.StringUtil;

/**
 * @author 邱建华
 * @version 1.0 2013-1-6
 */
public class TibCommonInoutdataConfig {
	
	private static Log logger = LogFactory.getLog(TibCommonInoutdataConfig.class);
	
	private static boolean isInit = false;

	private static TibCommonInoutdataConfig tibCommonInoutdataConfig = null;
	
	private static Map<String, TibCommonInoutdata> tibCommonInoutdataMap = new HashMap<String, TibCommonInoutdata>();
	
	public static TibCommonInoutdataConfig getInstance() {
		if (tibCommonInoutdataConfig == null) {
			tibCommonInoutdataConfig = new TibCommonInoutdataConfig();
		}
		if (!isInit) {
			init();
		}
		return tibCommonInoutdataConfig;
	}
	
	private static synchronized void init() {
		if (isInit)
			return;
		try {
			File file = new File(ConfigLocationsUtil.getKmssConfigPath()
					+ "/tib/common/inoutdata/datainit.xml");
			InputStream is = null;
			try {
				is = new BufferedInputStream(new FileInputStream(file));
				Document doc = new SAXReader().read(is);
				parse(doc);
			} finally {
				IOUtils.closeQuietly(is);
			}
		} catch (Exception e) {
			System.out.println(e);
			logger.fatal("加载初始化导入导出配置发生错误", e);
		}
		isInit = true;
	}

	/**
	 * 获取导出的属性名称
	 * 
	 * @param modelName
	 * @param name
	 * @return
	 */
	public Set<String> getPropertys(String modelName) {
		TibCommonInoutdata tibCommonInoutdata = getTibCommonInoutdata(modelName);
		return Collections
				.unmodifiableSet(tibCommonInoutdata != null ? tibCommonInoutdata
						.getPropertys() : new HashSet<String>());

	}

	private TibCommonInoutdata getTibCommonInoutdata(String name) {
		if (StringUtil.isNull(name)) {
			return null;
		}
		if (tibCommonInoutdataMap.containsKey(name)) {
			return tibCommonInoutdataMap.get(name);
		}
		return null;
	}
	
	private static void parse(Document doc) {
		final Element root = doc.getRootElement();
		Iterator<?> modelIter = root.elementIterator("model");
		while (modelIter.hasNext()) {
			final Element modelElement = (Element) modelIter.next();
			TibCommonInoutdata tibCommonInoutdata = new TibCommonInoutdata();

			// 名称
			Attribute modelNameAtt = modelElement.attribute("name");
			if (modelNameAtt != null) {
				tibCommonInoutdata.setName(modelNameAtt.getValue());
			}

			// 导出的属性名称
			Set<String> propertys = new HashSet<String>();
			Element relationElement = modelElement.element("relation");
			if (relationElement != null) {
				Iterator<?> propertysPropIter = relationElement
						.elementIterator("property");
				while (propertysPropIter.hasNext()) {
					Element propertyElement = (Element) propertysPropIter
							.next();
					propertys.add(propertyElement.getTextTrim());
				}
				Element whereElement = relationElement.element("where");
				if (whereElement != null) {
					tibCommonInoutdata.setWhere(whereElement.getTextTrim());
				}
			}
			tibCommonInoutdata.setPropertys(propertys);

			// 扩展
			Element interceptorElement = modelElement.element("interceptor");
			if (interceptorElement != null) {
				Attribute classAtt = interceptorElement.attribute("class");
				if (classAtt != null) {
					tibCommonInoutdata.setInterceptor(classAtt.getValue());
				}
			}

			tibCommonInoutdataMap.put(tibCommonInoutdata.getName(),
					tibCommonInoutdata);
		}
	}
	
	/**
	 * 获取导入之前拦截器
	 * 
	 * @param modelName
	 * @return
	 */
	public ITibCommonInoutdataInterceptor getInterceptor(String modelName) {
		TibCommonInoutdata tibCommonInoutdata = getTibCommonInoutdata(modelName);
		if (tibCommonInoutdata != null) {
			String extend = tibCommonInoutdata.getInterceptor();
			if (StringUtil.isNotNull(extend)) {
				try {
					Object obj = ClassUtils.forName(extend).newInstance();
					if (!(obj instanceof ISysDatainitInterceptor)) {
						logger.error("必需实现接口："
								+ ISysDatainitInterceptor.class.getName());
						return null;
					}
					return (ITibCommonInoutdataInterceptor) obj;
				} catch (Exception e) {
					logger.error("不能获取 [" + extend + "] 实例！");
					return null;
				}
			}
		}
		return null;
	}
	
	/**
	 * 导入的条件
	 * 
	 * @param modelName
	 * @return
	 */
	public String getWhere(String modelName) {
		TibCommonInoutdata tibCommonInoutdata = getTibCommonInoutdata(modelName);
		return tibCommonInoutdata != null ? tibCommonInoutdata.getWhere() : null;
	}

	/**
	 * 导入的条件参数
	 * 
	 * @param modelName
	 * @return
	 */
	public List<String> getParams(String modelName) {
		TibCommonInoutdata tibCommonInoutdata = getTibCommonInoutdata(modelName);
		return Collections
				.unmodifiableList(tibCommonInoutdata != null ? tibCommonInoutdata
						.getParams() : new ArrayList<String>());
	}
}
