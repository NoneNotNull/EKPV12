package com.landray.kmss.kms.multidoc.model;

import java.util.Date;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.DateUtil;

public class KmsMultidocSnContext {
	/**
	 * 最大号
	 */
	protected Long fdMaxNumber;

	/**
	 * 日期字符串 建议格式：yyyyMMdd
	 */
	protected String fdDate = DateUtil.convertDateToString(new Date(),
			"yyyyMMdd");

	/**
	 * 模块名
	 */
	protected String fdModelName;

	/**
	 * 模板
	 */
	protected IBaseModel fdTemplate;

	/**
	 * 流水号前缀
	 */
	protected String fdPrefix;

	/**
	 * @return fdMaxNumber
	 */
	public Long getFdMaxNumber() {
		return fdMaxNumber;
	}

	/**
	 * @return fdDate
	 */
	public String getFdDate() {
		return fdDate;
	}

	/**
	 * @return fdModelName
	 */
	public String getFdModelName() {
		return fdModelName;
	}

	/**
	 * @return fdTemplateId
	 */
	public IBaseModel getFdTemplate() {
		return fdTemplate;
	}

	/**
	 * @return fdPrefix
	 */
	public String getFdPrefix() {
		return fdPrefix;
	}

	/**
	 * @param fdSn
	 *            要设置的 fdMaxNumber
	 */
	public void setFdSn(Long fdMaxNumber) {
		this.fdMaxNumber = fdMaxNumber;
	}

	/**
	 * @param fdDate
	 *            要设置的 fdDate
	 */
	public void setFdDate(String fdDate) {
		this.fdDate = fdDate;
	}

	/**
	 * @param fdModelName
	 *            要设置的 fdModelName
	 */
	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}

	/**
	 * @param fdTemplate
	 *            要设置的 fdTemplate
	 */
	public void setFdTemplate(IBaseModel fdTemplate) {
		this.fdTemplate = fdTemplate;
	}

	/**
	 * @param fdPrefix
	 *            要设置的 fdPrefix
	 */
	public void setFdPrefix(String fdPrefix) {
		this.fdPrefix = fdPrefix;
	}

}
