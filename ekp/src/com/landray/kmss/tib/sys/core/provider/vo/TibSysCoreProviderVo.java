package com.landray.kmss.tib.sys.core.provider.vo;

import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreProvider;

public class TibSysCoreProviderVo {
	private String funcId;
	private String funcMappData;
	private ITibSysCoreProvider iTibSysCoreProvider;
	private String orderBy;
	public String getFuncId() {
		return funcId;
	}
	public void setFuncId(String funcId) {
		this.funcId = funcId;
	}
	public String getFuncMappData() {
		return funcMappData;
	}
	public void setFuncMappData(String funcMappData) {
		this.funcMappData = funcMappData;
	}
	public ITibSysCoreProvider getITibSysCoreProvider() {
		return iTibSysCoreProvider;
	}
	public void setITibSysCoreProvider(ITibSysCoreProvider tibSysCoreProvider) {
		iTibSysCoreProvider = tibSysCoreProvider;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
}
