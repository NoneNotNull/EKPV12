package com.landray.kmss.util.excel;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;


/**
 * Excel文件对象
 * @author 苏轶
 *
 */
public class WorkBook {
	private List sheetList = new ArrayList(); // 工作表列表
	private Locale locale;
	private String bundle; // 缺省bundle
	private KmssFormat dateFormat; // 全局日期Format对象，当没有指定具体某列的Format对象时使用
	private KmssFormat numberFormat; // 全局日期Format对象，当没有指定具体某列的Format对象时使用
	private String filename; // 文件名
	
	
	public String getFilename() {
		return filename;
	}

	
	public void setFilename(String filename) {
		this.filename = filename;
	}

	public KmssFormat getDateFormat() {
		return dateFormat;
	}
	
	public void setDateFormat(KmssFormat dateFormat) {
		this.dateFormat = dateFormat;
	}
	
	public KmssFormat getNumberFormat() {
		return numberFormat;
	}
	
	public void setNumberFormat(KmssFormat numberFormat) {
		this.numberFormat = numberFormat;
	}
	
	public List getSheetList() {
		return sheetList;
	}
	
	public void setSheetList(List sheetList) {
		this.sheetList = sheetList;
	}
	/**
	 * 将一个Sheet对象添加到Sheet队列末尾。
	 * @param sheet 要添加的Sheet
	 * @return true为添加成功，false为添加失败
	 */
	public boolean addSheet(Sheet sheet) {
		return sheetList.add(sheet);
	}
	
	public Locale getLocale() {
		return locale;
	}

	
	public void setLocale(Locale locale) {
		this.locale = locale;
	}

	
	public String getBundle() {
		return bundle;
	}

	
	public void setBundle(String bundle) {
		this.bundle = bundle;
	}
}
