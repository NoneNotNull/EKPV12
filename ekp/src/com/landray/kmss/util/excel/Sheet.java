package com.landray.kmss.util.excel;

import java.util.ArrayList;
import java.util.List;


/**
 * 工作表对象
 * @author 苏轶
 *
 */
public class Sheet {
	private String title; // 工作表标题和名称
	private String titleKey; // 工作表标题和名称资源Key值
	private String bundle; // 工作表标题和名称资源bundle
	private List columnList = new ArrayList(); // 表格列的列表
	private List contentList; // 表格数据，每个元素通常是一个List或者Object[]
	
	private boolean ifCreateSheetTitleLine = false; // 是否创建表格标题行（合并了所有列的那行，非列标题行）
	
	public List getColumnList() {
		return columnList;
	}
	
	public void setColumnList(List columnList) {
		this.columnList = columnList;
	}
	
	public boolean addColumn(Column col) {
		return columnList.add(col);
	}
	
	public List getContentList() {
		return contentList;
	}
	
	public void setContentList(List contentList) {
		this.contentList = contentList;
	}
	
	public boolean addContent(List oneRow) {
		if (contentList == null) contentList = new ArrayList();
		return contentList.add(oneRow);
	}
	
	public boolean addContent(Object[] oneRow) {
		if (contentList == null) contentList = new ArrayList();
		return contentList.add(oneRow);
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}

	
	public String getBundle() {
		return bundle;
	}

	
	public void setBundle(String bundle) {
		this.bundle = bundle;
	}

	
	public String getTitleKey() {
		return titleKey;
	}

	
	public void setTitleKey(String titleKey) {
		this.titleKey = titleKey;
	}

	public boolean isIfCreateSheetTitleLine() {
		return ifCreateSheetTitleLine;
	}

	public void setIfCreateSheetTitleLine(boolean ifCreateSheetTitleLine) {
		this.ifCreateSheetTitleLine = ifCreateSheetTitleLine;
	}
}
