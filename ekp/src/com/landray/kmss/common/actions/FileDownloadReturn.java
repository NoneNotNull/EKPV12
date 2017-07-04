package com.landray.kmss.common.actions;

import java.io.File;

import com.landray.kmss.util.KmssMessages;

public class FileDownloadReturn {

	public FileDownloadReturn() {
		super();
	}

	private KmssMessages kmssMessages;

	private File file;

	private String fileName;

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public KmssMessages getKmssMessages() {
		return kmssMessages;
	}

	public void setKmssMessages(KmssMessages kmssMessages) {
		this.kmssMessages = kmssMessages;
	}

}
