package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl;

import net.sf.json.JSONArray;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreProvider;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * 服务提供者基类
 * 
 * @author fat_tian
 * 
 */
public abstract class TibSysBaseProvider implements ITibSysCoreProvider {

	private Log logger = LogFactory.getLog(this.getClass());

	private TibSysEventProxy tibSysEventProxy = new TibSysEventProxy();

	public TibSysBaseProvider() {
		init();
	}

	private void init() {
		tibSysEventProxy = (TibSysEventProxy) SpringBeanUtil
				.getBean("tibSysEventProxy");
	}

	public void interceptError(Object data, String key) {
		getTibSysEventProxy().publicTibEvent(data, key,
				TibSysEventProxy.EVENT_ERROR);
	}

	public void interceptFinish(Object data, String key) {
		getTibSysEventProxy().publicTibEvent(data, key,
				TibSysEventProxy.EVENT_AFTER);
	}

	public void interceptReceive(Object data, String key) {
		getTibSysEventProxy().publicTibEvent(data, key,
				TibSysEventProxy.EVENT_BEFORE);
	}

	/**
	 * 执行对应操作
	 * 
	 * @param key
	 *            接口key
	 * @param data
	 *            数据
	 * @return
	 */
	public Object execute(String key, String funcId, String funcMappJson, Object data) {
		Object f_data = data;
		interceptReceive(data, key);
		try {
			// 找key对应的映射信息
			TibSysCoreStore coreStore = TibSysCoreUtil.getTibSysCoreStore(key, funcId, data);
			// 执行前数据转换
			Object t_data = transformReceiveData(funcId, funcMappJson, data);
			// 执行
			Object rtn_data = executeData(coreStore, t_data);
			// 执行完成数据转换
			f_data = transformFinishData(coreStore, rtn_data);
		} catch (Exception e) {
			e.printStackTrace();
			// 错误事件
			interceptError(f_data, key);
		} finally {
			// 发布完成事件
			interceptFinish(f_data, key);
		}
		return f_data;
	}

	public Object transformFinishData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		return data;
	}

	/**
	 * 数据转换
	 */
	public Object transformReceiveData(String funcId, String funcMappJson, 
			Object data) throws Exception {
		Document doc = null;
		if (data instanceof String) {
			doc = DOMHelper.parseXmlString((String) data);
		} else if (data instanceof Document) {
			doc = (Document) data;
		} else {
			logger.warn(" 没有进行数据转化,非Document,String类型 ~,若要转换请覆盖" + this.getClass().getName()
					+ " transformReceiveData 方法~!");
			return data;
		}
		// 得到模版xml
		Document templateDoc = (Document) getTemplateXml(funcId, true);
		if (null == templateDoc) {
			return data;
		}
		NodeList templateNodeList = templateDoc.getChildNodes();
		JSONArray mappJsonArray = JSONArray.fromObject(funcMappJson);
		TibSysCoreUtil.setTemplateXmlLoop(templateNodeList, doc, "", "", mappJsonArray);
		//System.out.println(ProviderXmlOperation.DocToString(templateDoc));
		return templateDoc;
	}
	
	/**
	 * 执行
	 * 
	 * @param coreFace
	 * @param data
	 * @return
	 */
	public abstract Object executeData(TibSysCoreStore coreStore, Object data)
			throws Exception;

	public Object getTemplateXml(String funcId, boolean isDoc) throws Exception {
		return null;
	}
	
	public TibSysEventProxy getTibSysEventProxy() {
		return tibSysEventProxy;
	}

	public void setTibSysEventProxy(TibSysEventProxy tibSysEventProxy) {
		this.tibSysEventProxy = tibSysEventProxy;
	}

}
