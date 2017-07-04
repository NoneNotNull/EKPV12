package com.landray.kmss.tib.sys.core.provider.process.dispatcher;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

import com.landray.kmss.tib.sys.core.provider.constants.TibSysCoreConstant;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreProvider;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreProviderVo;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.util.StringUtil;

/**
 * Tib函数分发类
 * @author fat_tian
 *
 */
public class TibSysCoreDispatcher {
	
	private static final Log logger = LogFactory.getLog(TibSysCoreDispatcher.class);
	
	public Object execute(String key ,Object data) throws Exception {
		
		if(logger.isInfoEnabled()){
			logger.info("Tib provider 进入分发阶段~,KEY："+key);
		}
		List<Object> objList = new ArrayList<Object>();
		// 分发
		List<TibSysCoreProviderVo> providerVoList = TibSysCoreUtil.findServiceList(key);
		// key填写错误的情况下，没有找到Provider就不必分发
		if (providerVoList != null && !providerVoList.isEmpty()) {
			String controlPattern = TibSysCoreUtil.parseAttrValue(data, "control");
			if (StringUtil.isNull(controlPattern)) {
				TibSysCoreIface tibSysCoreIface = TibSysCoreUtil.getTibSysCoreIface(key);
				// 调度模式
		    	controlPattern = tibSysCoreIface.getFdControlPattern();
			}
	    	if (TibSysCoreConstant.EXE_NO_IMPL.equals(controlPattern)) {
	    		// 状态为3,一条实现满足那么会执行,多条满足条件则不执行
	    		if (providerVoList.size() == 1) {
	    			TibSysCoreProviderVo providerVo = providerVoList.get(0);
		    		ITibSysCoreProvider provider = providerVo.getITibSysCoreProvider();
		    		Object obj = provider.execute(key, providerVo.getFuncId(), 
		    				providerVo.getFuncMappData(), data);
					objList.add(obj);
	    		}
	    	} else if(TibSysCoreConstant.ORDER_EXE_NO_IMPL.equals(controlPattern)) {
	    		// 状态为4，顺序执行所有满足条件
	    		for (TibSysCoreProviderVo providerVo : providerVoList) {
	    			ITibSysCoreProvider provider = providerVo.getITibSysCoreProvider();
	    			Object obj = provider.execute(key, providerVo.getFuncId(), 
		    				providerVo.getFuncMappData(), data);
					objList.add(obj);
	    		}
	    	} else {
	    		// 否则状态不为3,4。即状态为1,2
	    		for (TibSysCoreProviderVo providerVo : providerVoList) {
	    			Callable<Object> callable = new TibSysCoreThread(providerVo.getITibSysCoreProvider(), 
	    					key, providerVo.getFuncId(), providerVo.getFuncMappData(), data);
	    			FutureTask<Object> futureTask = new FutureTask<Object>(callable);
	    			Thread thread = new Thread(futureTask);
	    			thread.start();
	    			// 接收线程返回值
	    			objList.add(futureTask.get());
	    			// 1: 仅满足条件的第一个实现
	    			if (TibSysCoreConstant.EXE_FIRST_IMPL.equals(controlPattern)) {
	    				break;
	    			}
	    		}
	    	} 
		}
		if(logger.isInfoEnabled()){
			logger.info("Tib provider 进入完成~,KEY:"+key);
		}
		if (objList.size() == 1) {
				return objList.get(0);
		} else if (objList.size() > 1){
			return objList;
		} else {
			String tibXml = "<tib><out/><return><result>0</result><message>未找到Provider实现，或执行模式有误</message></return></tib>";
			return tibXml;
		}
	}
	
	public Object execute(Object data) throws Exception{
		String key =null;
		if(data instanceof String){
			Document doc = defaultParserData((String)data);
			key = TibSysCoreUtil.parseKey(doc);
		} else if(data instanceof Document){
			key = TibSysCoreUtil.parseKey((Document)data);
		} else{
			//			....
		}
		return execute(key, data);
	}

	private Document defaultParserData(String data) throws Exception {
		return DOMHelper.parseXmlString(data);
	}

}
