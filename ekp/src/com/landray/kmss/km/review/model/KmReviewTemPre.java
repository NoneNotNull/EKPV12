package com.landray.kmss.km.review.model;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2013-12-5
 * 
 * @author 朱湖强 流程分类概览
 */
public class KmReviewTemPre extends BaseModel {

	/*
	 * 分类的名字
	 */
	protected String tempName = null;
	/*
	 * 第一分类的下一级分类列表，列表保存的是KmReviewPre类型对象
	 */
	protected List<KmReviewTemPre> tempList = new ArrayList<KmReviewTemPre>();
	/*
	 * 分类的文档数量
	 */
	protected Integer docAmount = 0;

	/*
	 * 是否是一级分类,1表示为一级分类，0表示不是
	 */
	protected String isFirstCate = null;

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

	/*
	 * 是分类还是模板，因为在链接时参数会有所不同，要加以区分,其中0为分类，1为模板
	 */
	protected String isTemOrCate = null;

	public String getIsTemOrCate() {
		return isTemOrCate;
	}

	public void setIsTemOrCate(String isTemOrCate) {
		this.isTemOrCate = isTemOrCate;
	}

	public String getTempName() {
		return tempName;
	}

	public void setTempName(String tempName) {
		this.tempName = tempName;
	}

	public List<KmReviewTemPre> getTempList() {
		return tempList;
	}

	public void setTempList(List<KmReviewTemPre> tempList) {
		this.tempList = tempList;
	}

	public Integer getDocAmount() {
		return docAmount;
	}

	public void setDocAmount(Integer docAmount) {
		this.docAmount = docAmount;
	}

	public String getIsFirstCate() {
		return isFirstCate;
	}

	public void setIsFirstCate(String isFirstCate) {
		this.isFirstCate = isFirstCate;
	}

	public KmReviewTemPre() {
		super();
	}

	public Class getFormClass() {
		return null;
	}
}
