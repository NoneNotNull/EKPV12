package com.landray.kmss.kms.multidoc.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.kms.multidoc.forms.KmsMultidocSnForm;

/**
 * 主文档
 * 
 * @author
 * @version 1.0 2010-11-04
 */
public class KmsMultidocSn extends BaseModel {

	private static final long serialVersionUID = -7715067338008359995L;
	/**
	 * 最大号
	 */
	protected Long fdMaxNumber = new Long(1);

	/**
	 * @return 最大号
	 */
	public Long getFdMaxNumber() {
		return fdMaxNumber;
	}

	/**
	 * @param fdMaxNumber
	 *            最大号
	 */
	public void setFdMaxNumber(Long fdMaxNumber) {
		this.fdMaxNumber = fdMaxNumber;
	}

	/**
	 * 日期
	 */
	protected String fdDate;

	/**
	 * @return 日期
	 */
	public String getFdDate() {
		return fdDate;
	}

	/**
	 * @param fdDate
	 *            日期
	 */
	public void setFdDate(String fdDate) {
		this.fdDate = fdDate;
	}

	/**
	 * 模块名
	 */
	protected String fdModelName;

	/**
	 * @return 模块名
	 */
	public String getFdModelName() {
		return fdModelName;
	}

	/**
	 * @param fdModelName
	 *            模块名
	 */
	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}

	/**
	 * 模板ID
	 */
	protected String fdTemplateId;

	/**
	 * @return 模板ID
	 */
	public String getFdTemplateId() {
		return fdTemplateId;
	}

	/**
	 * @param fdTemplateId
	 *            模板ID
	 */
	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}

	/**
	 * 流水号前缀
	 */
	protected String fdPrefix;

	public Class<?> getFormClass() {
		return KmsMultidocSnForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	@Override
	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
		}
		return toFormPropertyMap;
	}

	/**
	 * @return fdPrefix
	 */
	public String getFdPrefix() {
		return fdPrefix;
	}

	/**
	 * @param fdPrefix
	 *            要设置的 fdPrefix
	 */
	public void setFdPrefix(String fdPrefix) {
		this.fdPrefix = fdPrefix;
	}
}
