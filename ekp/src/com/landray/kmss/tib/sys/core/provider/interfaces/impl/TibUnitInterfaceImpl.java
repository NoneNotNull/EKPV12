package com.landray.kmss.tib.sys.core.provider.interfaces.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ArrayUtils;
import org.hibernate.Query;
import org.w3c.dom.Document;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.core.provider.interfaces.ITibUnitInterface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIfaceImpl;
import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.tib.sys.core.provider.process.dispatcher.TibSysCoreDispatcher;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceImplService;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceImplInfo;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceInfo;
import com.landray.kmss.tib.sys.core.provider.vo.IfaceSimpleInfo;
import com.landray.kmss.util.SpringBeanUtil;

public class TibUnitInterfaceImpl implements ITibUnitInterface {

	private ITibSysCoreIfaceService tibSysCoreIfaceService;

	// 分发类
	private TibSysCoreDispatcher tibSysCoreDispatcher;

	public Object executeToData(String key, Object data) throws Exception {
		return tibSysCoreDispatcher.execute(key, data);
	}

	public Document executeToDoc(String inXML) throws Exception {
		Object result = tibSysCoreDispatcher.execute(inXML);
		if(result instanceof String){
			return ProviderXmlOperation.stringToDoc((String)result);
		} else if(result instanceof Document){
			return (Document) result;
		} else {
			return ProviderXmlOperation.stringToDoc(inXML);
		}
	}

	public Document executeToDoc(Document inDoc) throws Exception {
		Object result = tibSysCoreDispatcher.execute(inDoc);
		if(result instanceof String){
			return ProviderXmlOperation.stringToDoc((String)result);
		} else if(result instanceof Document){
			return (Document) result;
		} else {
			return inDoc;
		}
	}

	public String executeToStr(String inXML) throws Exception {
		Object result = tibSysCoreDispatcher.execute(inXML);
		return (String) result;
	}

	public String executeToStr(Document inDoc) throws Exception {
		Object result = tibSysCoreDispatcher.execute(inDoc);
		return (String) result;
	}

	public IfaceInfo getIface(String key) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(" tibSysCoreIface.fdIfaceKey = :fdIfaceKey ");
		hqlInfo.setParameter("fdIfaceKey", key);
		List list = tibSysCoreIfaceService.findList(hqlInfo);
		if (!list.isEmpty()) {
			return parseFuncNameVo((TibSysCoreIface)list.get(0));
		}
		return null;
	}

	public List<IfaceSimpleInfo> getIfaceList(Integer count) {
		String hql = " from com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface ";
		try {
			// 查找所有配置的provider
			Query query = tibSysCoreIfaceService.getBaseDao()
					.getHibernateSession().createQuery(hql);
			query.setFirstResult(0);
			// 0代表查全部
			if (count != null && !count.equals(Integer.valueOf(0))) {
				query.setMaxResults(count);
			}
			List<TibSysCoreIface> result = query.list();
			return parseFuncNameVo(result);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * 数据转化成vo
	 * 
	 * @param result
	 * @return
	 * @throws Exception
	 */
	private List<IfaceSimpleInfo> parseFuncNameVo(List<TibSysCoreIface> result)
			throws Exception {

		List<IfaceSimpleInfo> rtn = new ArrayList<IfaceSimpleInfo>(1);
		for (TibSysCoreIface coreInfo : result) {
			String fdKey = coreInfo.getFdIfaceKey();
			String fdName = coreInfo.getFdIfaceName();
			IfaceSimpleInfo ifaceSimpleInfo = new IfaceSimpleInfo(fdName, fdKey,
					coreInfo.getFdIfaceType(), coreInfo.getFdIfaceControl(),
					coreInfo.getFdControlPattern());
			rtn.add(ifaceSimpleInfo);
		}
		return rtn;
	}

	private IfaceInfo parseFuncNameVo(TibSysCoreIface tibSysCoreIface)
			throws Exception {
		if (tibSysCoreIface != null) {
			String fdKey = tibSysCoreIface.getFdIfaceKey();
			String fdName = tibSysCoreIface.getFdIfaceName();
			IfaceInfo ifaceInfo = new IfaceInfo(fdName, fdKey,
					tibSysCoreIface.getFdIfaceType(), tibSysCoreIface.getFdIfaceXml(), 
					tibSysCoreIface.getFdNote(), tibSysCoreIface.getFdIfaceTagsStr(),  
					null, tibSysCoreIface.getFdIfaceControl(),
					tibSysCoreIface.getFdControlPattern());
			return ifaceInfo;
		} else {
			return null;
		}
	}
	
	public TibSysCoreDispatcher getTibSysCoreDispatcher() {
		return tibSysCoreDispatcher;
	}

	public void setTibSysCoreDispatcher(
			TibSysCoreDispatcher tibSysCoreDispatcher) {
		this.tibSysCoreDispatcher = tibSysCoreDispatcher;
	}

	public ITibSysCoreIfaceService getTibSysCoreIfaceService() {
		return tibSysCoreIfaceService;
	}

	public void setTibSysCoreIfaceService(
			ITibSysCoreIfaceService tibSysCoreIfaceService) {
		this.tibSysCoreIfaceService = tibSysCoreIfaceService;
	}

	public Object executeToData(Object data) throws Exception {
		return tibSysCoreDispatcher.execute(data);
	}

	public List<IfaceImplInfo> getImplList(String key) throws Exception {
		List<IfaceImplInfo> implList = new ArrayList<IfaceImplInfo>();
		ITibSysCoreIfaceImplService ifaceImplService = (ITibSysCoreIfaceImplService) 
		SpringBeanUtil.getBean("tibSysCoreIfaceImplService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysCoreIfaceImpl.tibSysCoreIface.fdIfaceKey=:fdIfaceKey");
		hqlInfo.setParameter("fdIfaceKey", key);
		List<TibSysCoreIfaceImpl> ifaceImplList = ifaceImplService.findList(hqlInfo);
		for (TibSysCoreIfaceImpl ifaceImpl : ifaceImplList) {
			IfaceImplInfo implInfo = new IfaceImplInfo();
			implInfo.setFdName(ifaceImpl.getFdName());
			implInfo.setFdOrderBy(ifaceImpl.getFdOrderBy());
			implInfo.setFdKey(key);
			implInfo.setFdRefFuncName(ifaceImpl.getFdImplRefName());
			implInfo.setFdRefFuncType(ifaceImpl.getFdFuncType());
			implList.add(implInfo);
		}
		// 扩展点找实现（排除sap、soap）
    	List<Map<String, String>> pList = TibSysCoreProviderPlugins.getConfigs();
    	for (Map<String, String> pMap : pList) {
    		String pluginKey = pMap.get("key");
    		if (pluginKey ==  null || "sap".equals(pluginKey) || "soap".equals(pluginKey)) {
    			continue;
    		}
    		// 判断是否包含key
    		boolean flag = ArrayUtils.contains(pluginKey.split(";"), key);
    		if (flag) {
    			IfaceImplInfo implInfo = new IfaceImplInfo();
    			// 实现名称与函数实现类型一致
    			implInfo.setFdName(pMap.get("providerName"));
    			implInfo.setFdOrderBy(pMap.get("orderBy"));
    			implInfo.setFdKey(pMap.get("key"));
    			// 扩展点找出的实现，缺少函数名称
    			implInfo.setFdRefFuncType(pMap.get("providerName"));
    			implList.add(implInfo);
    		}
    	}
		return implList;
	}

}
