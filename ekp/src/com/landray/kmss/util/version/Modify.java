package com.landray.kmss.util.version;

import java.util.Date;

/**
 * 创建日期 2010-十一月-05
 * 
 * @author 缪贵荣 修改详细信息
 */
public class Modify {

	/**
	 * 描述
	 */
	protected String description;

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * 作者
	 */
	protected String author;

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	/**
	 * 修订时间
	 */
	protected Date revisionTime;

	public Date getRevisionTime() {
		return revisionTime;
	}

	public void setRevisionTime(Date revisionTime) {
		this.revisionTime = revisionTime;
	}

	/**
	 * 关联信息
	 */
	protected Relation relation;

	public Relation getRelation() {
		return relation;
	}

	public void setRelation(Relation relation) {
		this.relation = relation;
	}

	/**
	 * 基线
	 */
	protected String baseline;

	public String getBaseline() {
		return baseline;
	}

	public void setBaseline(String baseline) {
		this.baseline = baseline;
	}

}
