package com.landray.kmss.code.create.hbmdict;

import java.util.ArrayList;
import java.util.List;

public class HbmClass {
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

	private HbmId id;

	public HbmId getId() {
		return id;
	}

	public void setId(HbmId id) {
		this.id = id;
	}

	private List properties = new ArrayList();

	public List getProperties() {
		return properties;
	}

	public void addOneToOneProperty(HbmOneToOne oneToOne) {
		this.properties.add(oneToOne);
	}

	public void addManyToOneProperty(HbmManyToOne manyToOne) {
		this.properties.add(manyToOne);
	}

	public void addProperty(HbmProperty property) {
		this.properties.add(property);
	}

	public void addBagProperty(HbmBag bag) {
		this.properties.add(bag);
	}

	public void addListProperty(HbmList list) {
		this.properties.add(list);
	}

	private List subclasses = new ArrayList();

	public List getSubclasses() {
		return subclasses;
	}

	public void addSubclass(HbmSubclass subclass) {
		this.subclasses.add(subclass);
	}
}
