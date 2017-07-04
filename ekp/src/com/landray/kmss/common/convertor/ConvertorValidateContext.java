package com.landray.kmss.common.convertor;

import java.util.ArrayList;
import java.util.List;

public class ConvertorValidateContext {
	private List errors = new ArrayList();

	private String fileName;

	private Class fromClass;

	private int lineNumber = 1;

	private Class toClass;

	public List getErrors() {
		return errors;
	}

	public String getFileName() {
		return fileName;
	}

	public Class getFromClass() {
		return fromClass;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public Class getToClass() {
		return toClass;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public void setFromClass(Class fromClass) {
		this.fromClass = fromClass;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public void setToClass(Class toClass) {
		this.toClass = toClass;
	}

}
