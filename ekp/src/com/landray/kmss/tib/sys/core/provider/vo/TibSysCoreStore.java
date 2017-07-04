package com.landray.kmss.tib.sys.core.provider.vo;

public class TibSysCoreStore {
	// 接口key
	private String key;
	private String control;
	// 接口自定义id
	private String id;
	// 接口自定义className
	private String modelName;
	// 自定义数据源
	private String tagdb;
	// 接口实现的函数ID，为null则为扩展点实现方式
	private String implFuncId;
	// 接口模版xml
	private String ifaceXml;
	
	public TibSysCoreStore() {}
	
	public TibSysCoreStore(String key, String implFuncId, String ifaceXml) {
		this.key = key;
		this.implFuncId = implFuncId;
		this.ifaceXml = ifaceXml;
	}
	
	public TibSysCoreStore(String key, String control, String implFuncId, String ifaceXml,
			String id, String modelName, String tagdb) {
		this(key, implFuncId, ifaceXml);
		this.control = control;
		this.id = id;
		this.modelName = modelName;
		this.tagdb = tagdb;
	}
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getControl() {
		return control;
	}

	public void setControl(String control) {
		this.control = control;
	}

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
	public String getTagdb() {
		return tagdb;
	}
	public void setTagdb(String tagdb) {
		this.tagdb = tagdb;
	}
	public String getImplFuncId() {
		return implFuncId;
	}
	public void setImplFuncId(String implFuncId) {
		this.implFuncId = implFuncId;
	}
	public String getIfaceXml() {
		return ifaceXml;
	}
	public void setIfaceXml(String ifaceXml) {
		this.ifaceXml = ifaceXml;
	}
}
