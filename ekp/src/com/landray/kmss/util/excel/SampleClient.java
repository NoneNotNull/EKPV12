package com.landray.kmss.util.excel;

import java.io.File;
import java.io.FileOutputStream;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import com.landray.kmss.util.ResourceUtil;

public class SampleClient {

	public static void main(String[] args) throws Exception {
		SampleClient _this = new SampleClient();
		// _this.sampleMethod1();
		_this.sampleMethod2();
	}

	/**
	 * 使用资源文件指定表格标题和列标题
	 */
	private void sampleMethod1() throws Exception {
		/* 封装要导出的数据 BEGIN */
		// 创建一个数据容器
		WorkBook workbook = new WorkBook();
		// 模拟一个Locale
		Locale chinaLocale = new Locale("zh", "ZH");
		// 设置缺省Locale
		workbook.setLocale(chinaLocale);
		// 设置缺省bundle
		String bundle = "hr-salary";
		workbook.setBundle(bundle);
		// 创建缺省的日期格式化对象
		KmssDateFormat dateFormat = new KmssDateFormat();
		dateFormat.setPatten(ResourceUtil.getString("date.format.date"));
		dateFormat.setLocale(chinaLocale);
		workbook.setDateFormat(dateFormat);
		// 创建缺省的数字格式化对象
		KmssNumberFormat numberFormat = new KmssNumberFormat();
		// 模拟一个java.text.NumberFormat对象
		NumberFormat nf = NumberFormat.getInstance();
		// 设置小数位数为2
		nf.setMaximumFractionDigits(2);
		numberFormat.setNumberFormat(nf);
		workbook.setNumberFormat(numberFormat);

		// 创建一个工作表
		Sheet sheet = new Sheet();
		sheet.setTitleKey("title.key.sheet1");
		// 创建第1列标题（字符串型）
		Column col1 = new Column();
		col1.setTitleKey("title.key.column1");
		sheet.addColumn(col1);
		// 创建第2列标题（数字型）
		Column col2 = new Column();
		col2.setTitleKey("title.key.column2");
		KmssDefaultNumberFormat kmssDefaultNumberFormat = new KmssDefaultNumberFormat();
		kmssDefaultNumberFormat.setFractionDigits(2);
		col2.setFormat(kmssDefaultNumberFormat);
		sheet.addColumn(col2);
		// 创建第3列标题（日期型）
		Column col3 = new Column();
		col3.setTitleKey("title.key.column3");
		dateFormat = new KmssDateFormat();
		dateFormat.setPatten(ResourceUtil.getString("date.format.date"));
		Locale enLocale = new Locale("en", "EN");
		dateFormat.setLocale(enLocale);
		col3.setFormat(dateFormat);
		sheet.addColumn(col3);
		// 创建第4列标题（枚举型）
		Column col4 = new Column();
		col4.setTitleKey("title.key.column4");
		KmssEnumFormat enumFormat = new KmssEnumFormat();
		enumFormat.setEnumType("enumType");
		col4.setFormat(enumFormat);
		sheet.addColumn(col4);
		// 创建表数据
		List contentList = new ArrayList();
		Object[] row1 = new Object[] { "string1", new Integer(123), new Date(),
				new Byte((byte) 1) };
		Object[] row2 = new Object[] { "string2", new Integer(456), new Date(),
				new Byte((byte) 2) };
		Object[] row3 = new Object[] { "string3", new Integer(789), new Date(),
				new Byte((byte) 1) };
		contentList.add(row1);
		contentList.add(row2);
		sheet.setContentList(contentList);
		sheet.addContent(row3); // 也可单行添加
		// 将工作表添加到workbook
		workbook.addSheet(sheet);
		/* 封装要导出的数据 END */

		/* 导出Excel */
		File file = new File("e:/temp/test.xls");
		if (!file.exists())
			file.createNewFile();
		FileOutputStream outputStream = new FileOutputStream(file);
		ExcelOutput output = new ExcelOutputImp();
		output.output(workbook, outputStream);
		outputStream.close();
		System.out.println("end.");
	}

	/**
	 * 直接使用字符串作为表格标题和列标题
	 */
	public void sampleMethod2() throws Exception {
		/* 封装要导出的数据 BEGIN */
		// 创建一个数据容器
		WorkBook workbook = new WorkBook();
		// 模拟一个Locale
		Locale chinaLocale = new Locale("zh", "ZH");
		// 设置缺省Locale
		workbook.setLocale(chinaLocale);
		// 设置缺省bundle
		String bundle = "hr-salary";
		workbook.setBundle(bundle);
		// 创建缺省的日期格式化对象
		KmssDateFormat dateFormat = new KmssDateFormat();
		dateFormat.setPatten(ResourceUtil.getString("date.format.date"));
		dateFormat.setLocale(chinaLocale);
		workbook.setDateFormat(dateFormat);
		// 创建缺省的数字格式化对象
		KmssNumberFormat numberFormat = new KmssNumberFormat();
		// 模拟一个java.text.NumberFormat对象
		NumberFormat nf = NumberFormat.getInstance();
		// 设置小数位数为2
		nf.setMaximumFractionDigits(2);
		numberFormat.setNumberFormat(nf);
		workbook.setNumberFormat(numberFormat);

		// 创建一个工作表
		Sheet sheet = new Sheet();
		String title = "XX发放计划计算结果";
		// String title = getStringFromFile();
		// System.out.println(title);
		// title = new String(title.getBytes("UTF-8"), "GBK");
		// title = new String(title.getBytes("UTF-8"), "ISO-8859-1");
		// title = new String(title.getBytes("GBK"), "UTF-8");
		// title = new String(title.getBytes("GBK"), "ISO-8859-1");
		// title = new String(title.getBytes("ISO-8859-1"), "UTF-8");
		// title = new String(title.getBytes("ISO-8859-1"), "GBK");
		// System.out.println(title);
		sheet.setTitle(title);
		// 创建第1列标题（字符串型）
		Column col1 = new Column();
		col1.setTitle("姓名");
		sheet.addColumn(col1);
		// 创建第2列标题（数字型）
		Column col2 = new Column();
		col2.setTitle("实发金额");
		KmssDefaultNumberFormat kmssDefaultNumberFormat = new KmssDefaultNumberFormat();
		kmssDefaultNumberFormat.setFractionDigits(2);
		col2.setFormat(kmssDefaultNumberFormat);
		sheet.addColumn(col2);
		// 创建第3列标题（日期型）
		Column col3 = new Column();
		col3.setTitle("发放日期");
		dateFormat = new KmssDateFormat();
		dateFormat.setPatten(ResourceUtil.getString("date.format.date"));
		Locale enLocale = new Locale("en", "EN");
		dateFormat.setLocale(enLocale);
		col3.setFormat(dateFormat);
		sheet.addColumn(col3);
		// 创建第4列标题（枚举型）
		Column col4 = new Column();
		col4.setTitle("导出项");
		// KmssEnumFormat enumFormat = new KmssEnumFormat();
		// enumFormat.setEnumType("salary_bank_options");
		// enumFormat.setLocale(chinaLocale);
		// col4.setFormat(enumFormat);
		sheet.addColumn(col4);
		// 创建表数据
		List contentList = new ArrayList();
		Object[] row1 = new Object[] { "Tom", new Integer(123), new Date(),
				new Byte((byte) 1) };
		Object[] row2 = new Object[] { "Jack", new Integer(456), new Date(),
				new Byte((byte) 2) };
		Object[] row3 = new Object[] { "Henry", new Integer(789), new Date(),
				new Byte((byte) 3) };
		contentList.add(row1);
		contentList.add(row2);
		sheet.setContentList(contentList);
		sheet.addContent(row3); // 也可单行添加
		// 将工作表添加到workbook
		workbook.addSheet(sheet);
		/* 封装要导出的数据 END */

		/* 导出Excel */
		File file = new File("e:/temp/test.xls");
		if (!file.exists())
			file.createNewFile();
		FileOutputStream outputStream = new FileOutputStream(file);
		ExcelOutput output = new ExcelOutputImp();
		output.output(workbook, outputStream);
		outputStream.close();
		System.out.println("end.");
	}
}
