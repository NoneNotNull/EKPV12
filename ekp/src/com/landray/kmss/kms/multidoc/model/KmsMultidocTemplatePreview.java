/**
 * 
 */
package com.landray.kmss.kms.multidoc.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @author zhangwentian 2010-9-9
 */
public class KmsMultidocTemplatePreview {
	/*
	 * 分类的名字
	 */
	protected String tempName = null;
	/*
	 * 第一分类的下一级分类列表，列表保存的是KmsMultidocTemplatePreview类型对象
	 */
	protected List<KmsMultidocTemplatePreview> tempList = new ArrayList<KmsMultidocTemplatePreview>();
	/*
	 * 分类的文档数量
	 */
	protected Integer docAmount = 0;
	/*
	 * 在table中需要的tr个数
	 */
	protected Integer trAmount = 0;
	/*
	 * 在分类Id
	 */
	protected String categoryId = null;

	public String getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}

	public Integer getTrAmount() {
		return trAmount;
	}

	public void setTrAmount(Integer trAmount) {
		this.trAmount = trAmount;
	}

	public KmsMultidocTemplatePreview() {

	}

	public String getTempName() {
		return tempName;
	}

	public void setTempName(String tempName) {
		this.tempName = tempName;
	}

	public List<KmsMultidocTemplatePreview> getTempList() {
		return tempList;
	}

	public void setTempList(List<KmsMultidocTemplatePreview> tempList) {
		this.tempList = tempList;
	}

	public Integer getDocAmount() {
		return docAmount;
	}

	public void setDocAmount(Integer docAmount) {
		this.docAmount = docAmount;
	}

	// 多维知识库概览增加属性 by hongzq 20120116
	protected String filterId = null;

	/**
	 * @return filterId
	 */
	public String getFilterId() {
		return filterId;
	}

	/**
	 * @param filterId
	 *            要设置的 filterId
	 */
	public void setFilterId(String filterId) {
		this.filterId = filterId;
	}

}
