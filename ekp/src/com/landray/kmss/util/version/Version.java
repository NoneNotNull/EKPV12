package com.landray.kmss.util.version;

/**
 * 创建日期 2010-十一月-05
 * 
 * @author 缪贵荣 版本信息
 */
public class Version {

	/**
	 * 修改信息
	 */
	protected Modifies modifies;

	public Modifies getModifies() {
		return modifies;
	}

	public void setModifies(Modifies modifies) {
		this.modifies = modifies;
	}

	protected String xmlns;

	public String getXmlns() {
		return xmlns;
	}

	public void setXmlns(String xmlns) {
		this.xmlns = xmlns;
	}

	protected String xsi;

	public String getXsi() {
		return xsi;
	}

	public void setXsi(String xsi) {
		this.xsi = xsi;
	}

	protected String schemaLocation;

	public String getSchemaLocation() {
		return schemaLocation;
	}

	public void setSchemaLocation(String schemaLocation) {
		this.schemaLocation = schemaLocation;
	}

}
