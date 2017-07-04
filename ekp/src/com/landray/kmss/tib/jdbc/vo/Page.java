package com.landray.kmss.tib.jdbc.vo;

import java.io.Serializable;

/**
 * 分页
 * @author qiujh
 */
public class Page implements Serializable{

	private static final long serialVersionUID = 2330938326334029552L;
	
	private Integer pageCount;		// 一页多少条
	private Integer currentPage;	// 当前页
	private Integer totalCount;		// 总条数
	private Integer totalPage;		// 总页数
	private String querySourceSql;	// sql语句
	private String sourceKeyField;	// 源数据库表主键
	
	//public Page() {}
	
	public Page(Integer currentPage, Integer pageCount, Integer totalCount) {
		this.pageCount = pageCount;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
	}
	
	public Page(Integer currentPage, Integer pageCount, Integer totalCount,
			String querySourceSql, String sourceKeyField) {
		this(currentPage, pageCount, totalCount);
		this.querySourceSql = querySourceSql;
		this.sourceKeyField = sourceKeyField;
	}
	
	public Integer getPageCount() {
		return pageCount;
	}
	public void setPageCount(Integer pageCount) {
		this.pageCount = pageCount;
	}
	public Integer getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(Integer currentPage) {
		this.currentPage = currentPage;
	}
	public Integer getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}
	public Integer getTotalPage() {
		if (totalPage == null) {
			if(totalCount % pageCount == 0){
				this.totalPage = totalCount / pageCount;
			}else{
				this.totalPage = totalCount / pageCount + 1;
			}
		}
		return totalPage;
	}
	public void setTotalPage(Integer totalCount) {
		if(totalCount % pageCount == 0){
			this.totalPage = totalCount / pageCount;
		}else{
			this.totalPage = totalCount / pageCount + 1;
		}
	}
	public String getQuerySourceSql() {
		return querySourceSql;
	}

	public void setQuerySourceSql(String querySourceSql) {
		this.querySourceSql = querySourceSql;
	}

	public String getSourceKeyField() {
		return sourceKeyField;
	}

	public void setSourceKeyField(String sourceKeyField) {
		this.sourceKeyField = sourceKeyField;
	}

}
