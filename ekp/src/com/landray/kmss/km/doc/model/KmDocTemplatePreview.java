/**
 * 
 */
package com.landray.kmss.km.doc.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @author zhangwentian 2010-9-9
 */
public class KmDocTemplatePreview {
	/*
	 * 分类的名字
	 */
	protected String tempName = null;
	/*
	 * 第一分类的下一级分类列表，列表保存的是KmDocTemplatePreview类型对象
	 */
	protected List<KmDocTemplatePreview> tempList = new ArrayList<KmDocTemplatePreview>();
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

	public KmDocTemplatePreview() {

	}

	public String getTempName() {
		return tempName;
	}

	public void setTempName(String tempName) {
		this.tempName = tempName;
	}

	public List<KmDocTemplatePreview> getTempList() {
		return tempList;
	}

	public void setTempList(List<KmDocTemplatePreview> tempList) {
		this.tempList = tempList;
	}

	public Integer getDocAmount() {
		return docAmount;
	}

	public void setDocAmount(Integer docAmount) {
		this.docAmount = docAmount;
	}
}
