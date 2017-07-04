package com.landray.kmss.kms.multidoc.webservice.doc.form;

import com.landray.kmss.kms.common.webservice.form.doc.KmsMaintainDocRequest;

public class KmsMaintainMultidocDocRequest extends KmsMaintainDocRequest {

	private static final long serialVersionUID = -1161635031231672797L;
	private String docExpire;
	// 部门
	private String docDeptId;
	// 岗位
	private String docPostsIds;
	private String outerAuthor;
	// 摘要
	private String fdDescription;
	// 文档内容
	private String docContent;
	//作者类型
	private String docAuthorType;
	// 作者id
	private String docAuthorId;

	public String getDocExpire() {
		return docExpire;
	}

	public void setDocExpire(String docExpire) {
		this.docExpire = docExpire;
	}

	public String getOuterAuthor() {
		return outerAuthor;
	}

	public void setOuterAuthor(String outerAuthor) {
		this.outerAuthor = outerAuthor;
	}

	public String getFdDescription() {
		return fdDescription;
	}

	public void setFdDescription(String fdDescription) {
		this.fdDescription = fdDescription;
	}

	public String getDocContent() {
		return docContent;
	}

	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}

	public String getDocDeptId() {
		return docDeptId;
	}

	public void setDocDeptId(String docDeptId) {
		this.docDeptId = docDeptId;
	}

	public String getDocPostsIds() {
		return docPostsIds;
	}

	public void setDocPostsIds(String docPostsIds) {
		this.docPostsIds = docPostsIds;
	}

	public String getDocAuthorType() {
		return docAuthorType;
	}

	public void setDocAuthorType(String docAuthorType) {
		this.docAuthorType = docAuthorType;
	}

	public String getDocAuthorId() {
		return docAuthorId;
	}

	public void setDocAuthorId(String docAuthorId) {
		this.docAuthorId = docAuthorId;
	}
    
	
}
