package com.landray.kmss.spi.query;

import java.util.ArrayList;
import java.util.List;

public class CriteriaQuery implements Cloneable {
	private String modelName;
	private int pageNo;
	private int pageSize;
	private List<String> resultProperty = new ArrayList<String>();
	private CollectionQuery collectionQuery = new CollectionQuery();
	private List<QueryOrder> collectionOrder = new ArrayList<QueryOrder>();

	public CriteriaQuery() {
	}

	public CriteriaQuery(List<String> resultProperty) {
		this.resultProperty = resultProperty;
	}

	public CriteriaQuery(String modelName) {
		this.modelName = modelName;
	}

	public CriteriaQuery(Class<?> clazz) {
		this.modelName = clazz.getName();
	}

	public CriteriaQuery(int _pageNo, int _pageSize) {
		this.pageNo = _pageNo;
		this.pageSize = _pageSize;
	}

	public CriteriaQuery clone() {
		CriteriaQuery clo = new CriteriaQuery();
		clo.setModelName(this.getModelName());
		clo.setPageNo(this.pageNo);
		clo.setPageSize(this.getPageSize());
		clo.getCollectionQuery().getAndList().addAll(
				this.getCollectionQuery().getAndList());
		clo.getCollectionQuery().getOrList().addAll(
				this.getCollectionQuery().getOrList());
		clo.getCollectionOrder().addAll(this.getCollectionOrder());
		clo.getResultProperty().addAll(this.getResultProperty());
		return clo;
	}

	public String getModelName() {
		return modelName;
	}

	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

	public CriteriaQuery putResultProperty(String key) {
		this.resultProperty.add(key);
		return this;
	}

	public CriteriaQuery clearResultProperty() {
		this.resultProperty.clear();
		return this;
	}

	public void andQuery(BaseQuery query) {
		collectionQuery.and(query);
	}

	public void orQuery(BaseQuery query) {
		collectionQuery.or(query);
	}

	public void addOrder(QueryOrder order) {
		collectionOrder.add(order);
	}

	public String string() throws Exception {
		return collectionQuery.string();
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public CollectionQuery getCollectionQuery() {
		return collectionQuery;
	}

	public void setCollectionQuery(CollectionQuery collectionQuery) {
		this.collectionQuery = collectionQuery;
	}

	public List<QueryOrder> getCollectionOrder() {
		return collectionOrder;
	}

	public void setCollectionOrder(List<QueryOrder> collectionOrder) {
		this.collectionOrder = collectionOrder;
	}

	public List<String> getResultProperty() {
		return resultProperty;
	}

	public void setResultProperty(List<String> resultProperty) {
		this.resultProperty = resultProperty;
	}
}
