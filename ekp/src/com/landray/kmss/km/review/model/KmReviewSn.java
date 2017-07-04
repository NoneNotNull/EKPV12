package com.landray.kmss.km.review.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.km.review.forms.KmReviewSnForm;
import com.landray.kmss.sys.right.interfaces.BaseAuthModel;

/**
 * 主文档
 * 
 * @author
 * @version 1.0 2010-11-04
 */
public class KmReviewSn extends BaseAuthModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1241837132092711057L;
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

	public Class getFormClass() {
		return KmReviewSnForm.class;
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

	public String getDocSubject() {
		// TODO 自动生成的方法存根
		return null;
	}
}
