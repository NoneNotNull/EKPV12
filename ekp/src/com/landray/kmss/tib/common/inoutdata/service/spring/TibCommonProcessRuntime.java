package com.landray.kmss.tib.common.inoutdata.service.spring;

import java.io.File;
import java.util.Date;
import java.util.LinkedList;
import java.util.Map;

public class TibCommonProcessRuntime {
	public static final int STATUS_STOPED = -3;

	public static final int STATUS_ERROR = -2;

	public static final int STATUS_FINISH = -1;

	public static final int STATUS_READY = 0;

	public static final int STATUS_STARTING = 1;

	public static final int STATUS_RUNNING = 2;

	public static final int STATUS_STOPING = 3;

	private Date startTime;

	private Date endTime;

	private int status = STATUS_READY;

	private int processCount = 0;

	private int successCount = 0;

	private int failureCount = 0;

	private int ignoreCount = 0;

	private StringBuffer errorFile;

	public int getProcessCount() {
		return processCount;
	}

	public void setProcessCount(int processCount) {
		this.processCount = processCount;
	}

	public int getSuccessCount() {
		return successCount;
	}

	public void addSuccessCount() {
		successCount++;
	}

	public int getFailureCount() {
		return failureCount;
	}

	public void addFialureFileInfo(File file) {
		failureCount++;
		errorFile.append(file.getAbsoluteFile()).append("<br>");
	}

	public int getIgnoreCount() {
		return ignoreCount;
	}

	public void addIgnoreCount() {
		ignoreCount++;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
		if (status == STATUS_STARTING) {
			processCount = 0;
			successCount = 0;
			failureCount = 0;
			addCount = 0;
			updateCount = 0;
			deleteCount = 0;
			ignoreCount = 0;
			errorFile = new StringBuffer();
			startTime = new Date();
			endTime = null;
		} else if (status < 0) {
			endTime = new Date();
		}
		// 准备、停止、错误、完成时清空
		if (status <= 0) {
			if (filePathList != null) {
				filePathList.clear();
				filePathList = null;
			}
			if (filePathMap != null) {
				filePathMap.clear();
				filePathMap = null;
			}
		}
	}

	public boolean isRunning() {
		return status > 0;
	}

	public Date getStartTime() {
		return startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public StringBuffer getErrorFile() {
		return errorFile;
	}

	/**
	 * 新增个数
	 */
	private int addCount;

	public int getAddCount() {
		return addCount;
	}

	public void addAddCount() {
		this.addCount++;
	}

	/**
	 * 更新个数
	 */
	private int updateCount;

	public int getUpdateCount() {
		return updateCount;
	}

	public void addUpdateCount() {
		this.updateCount++;
	}

	/**
	 * 删除个数
	 */
	private int deleteCount;

	public int getDeleteCount() {
		return deleteCount;
	}

	public void addDeleteCount() {
		this.deleteCount++;
	}

	/**
	 * 是否随机导入必填字段
	 */
	private boolean isImportRequired;

	public boolean isImportRequired() {
		return isImportRequired;
	}

	public void setImportRequired(boolean isImportRequired) {
		this.isImportRequired = isImportRequired;
	}

	/**
	 * 是否更新原有数据
	 */
	private boolean isUpdate;

	public boolean isUpdate() {
		return isUpdate;
	}

	public void setUpdate(boolean isUpdate) {
		this.isUpdate = isUpdate;
	}

	/**
	 * 导入数据的文件路径
	 */
	private LinkedList<String> filePathList = null;

	public LinkedList<String> getFilePathList() {
		return filePathList;
	}

	public void setFilePathList(LinkedList<String> filePathList) {
		this.filePathList = filePathList;
	}

	private Map<String, String> filePathMap = null;

	public Map<String, String> getFilePathMap() {
		return filePathMap;
	}

	public void setFilePathMap(Map<String, String> filePathMap) {
		this.filePathMap = filePathMap;
	}

}
