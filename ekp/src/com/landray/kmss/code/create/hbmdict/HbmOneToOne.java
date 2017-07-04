package com.landray.kmss.code.create.hbmdict;

public class HbmOneToOne {
	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	private String cascade;

	public String getCascade() {
		return cascade;
	}

	public void setCascade(String cascade) {
		this.cascade = cascade;
	}

	private String type;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	private String constrained;

	public String getConstrained() {
		return constrained;
	}

	public void setConstrained(String constrained) {
		this.constrained = constrained;
	}
}
