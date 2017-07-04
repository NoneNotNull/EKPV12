package com.landray.kmss.kms.multidoc.model;

import com.landray.kmss.kms.common.model.KmsBaseAppConfig;

public class KmsMultidocCount extends KmsBaseAppConfig {

	public KmsMultidocCount() throws Exception {
	}

	// 所有文档
	public String getTotalCount() {
		return this.getValue("totalCount");
	}

	public void setTotalCount(String totalCount) {
		this.setValue("totalCount", totalCount);
	}

	// 所有推荐文档
	public String getIntroTotalCount() {
		return this.getValue("introTotalCount");
	}

	public void setIntroTotalCount(String introTotalCount) {
		this.setValue("introTotalCount", introTotalCount);
	}

	// 获取今日知识更新数
	public String getUpdateTodayCount() {
		return getValue("updateTodayCount");
	}

	public void setUpdateTodayCount(String updateTodayCount) {
		setValue("updateTodayCount", updateTodayCount);
	}

	public String getAuthAreaId() {
		return getValue("authAreaId");
	}

	public void setAuthAreaId(String authAreaId) {
		setValue("authAreaId", authAreaId);
	}

}
