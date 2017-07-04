package com.landray.kmss.code.create.hbmdict;


public class HbmSubclass extends HbmClass {
	private String extendClass;

	public String getExtendClass() {
		return extendClass;
	}

	public void setExtendClass(String extendClass) {
		this.extendClass = extendClass;
	}

	private String discriminatorValue;

	public String getDiscriminatorValue() {
		return discriminatorValue;
	}

	public void setDiscriminatorValue(String discriminatorValue) {
		this.discriminatorValue = discriminatorValue;
	}

	private HbmJoin join;

	public HbmJoin getJoin() {
		return join;
	}

	public void setJoin(HbmJoin join) {
		this.join = join;
	}
}
