package com.landray.kmss.util.version;


/**
 * 创建日期 2010-十一月-05
 * 
 * @author 缪贵荣 组件信息
 */
public class Module {

	/**
	 * 组件名称
	 */
	protected String moduleName;

	public String getModuleName() {
		return moduleName;
	}

	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}

	/**
	 * 组件路径
	 */
	protected String modulePath;

	public String getModulePath() {
		return modulePath;
	}

	public void setModulePath(String modulePath) {
		this.modulePath = modulePath;
	}

	/**
	 * 基线
	 */
	protected String baseline;

	public String getBaseline() {
		return baseline;
	}

	public void setBaseline(String baseline) {
		this.baseline = baseline;
	}

	/**
	 * 模块标识
	 */
	protected String sourceMd5;

	public String getSourceMd5() {
		return sourceMd5;
	}

	public void setSourceMd5(String sourceMd5) {
		this.sourceMd5 = sourceMd5;
	}

	/**
	 * 临时版本
	 */
	protected String tempVersion;

	public String getTempVersion() {
		return tempVersion;
	}

	public void setTempVersion(String tempVersion) {
		this.tempVersion = tempVersion;
	}

	/**
	 * 是否定制
	 */
	protected String isCustom;

	public String getIsCustom() {
		return isCustom;
	}

	public void setIsCustom(String isCustom) {
		this.isCustom = isCustom;
	}

	/**
	 * 版本序列号
	 */
	protected String serialNum;

	public String getSerialNum() {
		return serialNum;
	}

	public void setSerialNum(String serialNum) {
		this.serialNum = serialNum;
	}

	/**
	 * 平行版本
	 */

	protected String parallelVersion = "";

	public String getParallelVersion() {
		return parallelVersion;
	}

	public void setParallelVersion(String parallelVersion) {
		this.parallelVersion = parallelVersion;
	}

}
