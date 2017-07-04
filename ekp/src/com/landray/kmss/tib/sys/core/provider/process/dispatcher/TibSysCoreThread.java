package com.landray.kmss.tib.sys.core.provider.process.dispatcher;

import java.util.concurrent.Callable;

import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreProvider;

/**
 * 用于线程分发
 * @author 
 */
public class TibSysCoreThread implements Callable<Object> {
	
	private ITibSysCoreProvider provider;
	private String key;
	private String funcId;
	private String funcMappData;
	private Object data;
	
	public TibSysCoreThread() {}
	
	public TibSysCoreThread(ITibSysCoreProvider provider, 
			String key, String funcId, String funcMappData, Object data) {
		this.provider = provider;
		this.key = key;
		this.funcId = funcId;
		this.data = data;
		this.funcMappData = funcMappData;
	}
	
	public Object call() throws Exception {
		Object obj = provider.execute(key, funcId, funcMappData, data);
		return obj;
	}

}
