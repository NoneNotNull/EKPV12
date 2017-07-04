package com.landray.kmss.code.examine;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import com.landray.kmss.util.StringUtil;

public class ExamineContext {
	public ExamineContext(String modulePath) {
		this.modulePath = modulePath;
	}

	private String modulePrefix = null;

	private String modulePath = null;

	private Class currentClass = null;

	private File currentFile = null;

	private StringBuffer errorInfo = new StringBuffer();

	private int errorNumber = 0;

	private Map parameter = new HashMap();

	private StringBuffer warnInfo = new StringBuffer();

	private int warnNumber = 0;

	public void addError(Class c, String methodName, int lineNumber,
			String message) {
		String className = c.getName();
		int i = className.lastIndexOf('.');
		errorInfo.append(className).append('.').append(methodName);
		errorInfo.append('(').append(className.substring(i + 1)).append(
				".java:").append(lineNumber).append(')');
		if (!StringUtil.isNull(message))
			errorInfo.append(" - ").append(message);
		errorInfo.append("\r\n");
		errorNumber++;
	}

	public void addError(String message) {
		errorInfo.append(message);
		errorInfo.append("\r\n");
		errorNumber++;
	}

	public void addWarn(Class c, String methodName, int lineNumber,
			String message) {
		String className = c.getName();
		int i = className.lastIndexOf('.');
		warnInfo.append(className).append('.').append(methodName);
		warnInfo.append('(').append(className.substring(i + 1))
				.append(".java:").append(lineNumber).append(')');
		if (!StringUtil.isNull(message))
			warnInfo.append(" - ").append(message);
		warnInfo.append("\r\n");
		warnNumber++;
	}

	public void addWarn(String message) {
		warnInfo.append(message);
		warnInfo.append("\r\n");
		warnNumber++;
	}

	public Class getCurrentClass() {
		return currentClass;
	}

	public File getCurrentFile() {
		return currentFile;
	}

	public Object getParameter(String key) {
		return parameter.get(key);
	}

	public void printError() {
		System.out.println("==================== 在" + modulePath + "共找到 "
				+ errorNumber + " 处错误信息 ====================");
		System.out.println(errorInfo);
	}

	public void printWarn() {
		System.out.println("==================== 在" + modulePath + "共找到 "
				+ warnNumber + " 处警告信息 ====================");
		System.out.println(warnInfo);
	}

	public void reset() {
		parameter.clear();
	}

	public void setCurrentClass(Class currentClass) {
		this.currentClass = currentClass;
	}

	public void setCurrentFile(File currentFile) {
		this.currentFile = currentFile;
	}

	public void setParameter(String key, Object value) {
		parameter.put(key, value);
	}

	public String getModulePrefix() {
		if (modulePrefix == null) {
			String[] strArr = modulePath.split("/");
			modulePrefix = strArr[0] + strArr[1].substring(0, 1).toUpperCase()
					+ strArr[1].substring(1);
		}
		return modulePrefix;
	}

	public String getModulePath() {
		return modulePath;
	}
}
