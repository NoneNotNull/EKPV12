package com.landray.kmss.km.doc.model;

import java.util.Date;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.authorization.model.SysAuthArea;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库概览文档
 */
public class KmDocKnowledgePre extends BaseModel implements
		InterceptFieldEnabled,ISysAuthAreaModel // 大字段加入延时加载实现接口
{
	public KmDocKnowledgePre() {
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
