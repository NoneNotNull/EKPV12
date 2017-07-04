package com.landray.kmss.kms.multidoc.model;

import java.util.Date;

import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.authorization.model.SysAuthArea;

/**
 * 多维知识库知识预览
 * 
 * @author yangf
 */
public class KmsMultidocKnowledgePre extends BaseModel implements
		ISysAuthAreaModel {
	public KmsMultidocKnowledgePre() {
		super();
	}

	public Class getFormClass() {
		return null;
	}

	private String fdPreContent;

	public String getFdPreContent() {
		return (String) readLazyField("fdPreContent", fdPreContent);
	}

	public void setFdPreContent(String fdPreContent) {
		this.fdPreContent = (String) writeLazyField("fdPreContent",
				this.fdPreContent, fdPreContent);
	}

	private Date docAlterTime;

	public Date getDocAlterTime() {
		return docAlterTime;
	}

	public void setDocAlterTime(Date docAlterTime) {
		this.docAlterTime = docAlterTime;
	}

	/**
	 * 所属分类
	 */
	private String fdCategoryId;

	public String getFdCategoryId() {
		return fdCategoryId;
	}

	public void setFdCategoryId(String fdCategoryId) {
		this.fdCategoryId = fdCategoryId;
	}

	/*
	 * 所属场所
	 */
	protected SysAuthArea authArea;

	public SysAuthArea getAuthArea() {
		return authArea;
	}

	public void setAuthArea(SysAuthArea authArea) {
		this.authArea = authArea;
	}

}
