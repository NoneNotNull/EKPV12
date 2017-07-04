package com.landray.kmss.util.version;

public class Difference {
	/**
	 * 文件路径
	 */
	protected String filePath = null;

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	/**
	 * 产品MD5
	 */
	protected String prodMd5 = null;

	public String getProdMd5() {
		return prodMd5;
	}

	public void setProdMd5(String prodMd5) {
		this.prodMd5 = prodMd5;
	}

	/**
	 * 项目MD5
	 */
	protected String projectMd5 = null;

	public String getProjectMd5() {
		return projectMd5;
	}

	public void setProjectMd5(String projectMd5) {
		this.projectMd5 = projectMd5;
	}

	/**
	 * 类别
	 */
	protected String type = null;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

}
