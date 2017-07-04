package com.landray.kmss.common.dao;

import org.hibernate.type.Type;

public class HQLParameter {
	private String name;

	private Object value;

	private Type type;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}

	public Object getValue() {
		return value;
	}

	public void setValue(Object value) {
		this.value = value;
	}

	public HQLParameter(String name, Object value) {
		super();
		this.name = name;
		this.value = value;
	}

	public HQLParameter(String name, Object value, Type type) {
		super();
		this.name = name;
		this.value = value;
		this.type = type;
	}
}
