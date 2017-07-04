package com.landray.kmss.common.actions;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import com.landray.kmss.util.KmssMessages;

public class FileUploadReturn implements Serializable {

	public FileUploadReturn() {
		super();
	}

	private KmssMessages kmssMessages = new KmssMessages();

	private Map bussinessReturn = new HashMap();

	public Map getBussinessReturn() {
		return bussinessReturn;
	}

	public void setBussinessReturn(Map bussinessReturn) {
		this.bussinessReturn = bussinessReturn;
	}

	public KmssMessages getKmssMessages() {
		return kmssMessages;
	}

	public void setKmssMessages(KmssMessages kmssMessages) {
		this.kmssMessages = kmssMessages;
	}
}
