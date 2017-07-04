package com.landray.kmss.code.create.hbmdict;

public class HbmBag {
	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	private String table;

	public String getTable() {
		return table;
	}

	public void setTable(String table) {
		this.table = table;
	}

	private String cascade;

	public String getCascade() {
		return cascade;
	}

	public void setCascade(String cascade) {
		this.cascade = cascade;
	}

	private String inverse;

	public String getInverse() {
		return inverse;
	}

	public void setInverse(String inverse) {
		this.inverse = inverse;
	}

	private HbmKey key;

	public HbmKey getKey() {
		return key;
	}

	public void setKey(HbmKey key) {
		this.key = key;
	}

	private HbmManyToMany manyToMany;

	public HbmManyToMany getManyToMany() {
		return manyToMany;
	}

	public void setManyToMany(HbmManyToMany manyToMany) {
		this.manyToMany = manyToMany;
	}

	private HbmOneToMany oneToMany;

	public HbmOneToMany getOneToMany() {
		return oneToMany;
	}

	public void setOneToMany(HbmOneToMany oneToMany) {
		this.oneToMany = oneToMany;
	}

	private String orderBy;

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

}
