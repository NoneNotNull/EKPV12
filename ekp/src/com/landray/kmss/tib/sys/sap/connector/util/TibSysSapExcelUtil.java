package com.landray.kmss.tib.sys.sap.connector.util;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.landray.kmss.util.StringUtil;

public class TibSysSapExcelUtil {
	
	private HSSFCellStyle title_style=null;
	private HSSFCellStyle value_style=null;
	
	public HSSFWorkbook xmlForExcel(String xmlData, String rfcName)
			throws DocumentException, IOException {
		HSSFWorkbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
		HSSFSheet sheet = wb.createSheet("传入参数");
		
		//标题行style
		 title_style = wb.createCellStyle();
		// title_style.setFillForegroundColor(HSSFColor.AQUA.index);
		 title_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		 title_style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
//		 title_style.setFillBackgroundColor(HSSFColor.BLUE.index);
		
		 
		//内容行style
//		 value_style = wb.createCellStyle();
//		 value_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
//		 value_style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
		
		
		 Document document = DocumentHelper.parseText(xmlData);
		//==========
//		SAXReader reader = new SAXReader();
//		Document document = reader.read(new File("E:\\j.xml"));
		
		createImportSheet(document, sheet);
		
		// 获取import数据
		HSSFSheet exportSheet = wb.createSheet("传出参数");
		List<Element> export = document.selectNodes("/jco/export");
		buildImport(export, exportSheet);
		
		//==================================
		List<Element> tableList = document
				.selectNodes("/jco/tables/table[@isin='0' or @isin='0;1']");
		for (Element element : tableList) {
			String tableName =getAttrValue(element, "name", "");
			HSSFSheet tableSheet = wb.createSheet(tableName);
			buildTable(element, tableSheet);
		}
		
	   return wb;

	}

	/**
	 * import 格式 <import> <field> </field> </import> table 格式
	 * <table>
	 * <records> <field> </field> <records>
	 * </table>
	 * 
	 * @param doucment
	 * @param importSheet
	 */
	private void createImportSheet(Document document, HSSFSheet importSheet) {

		// 获取import数据
		List<Element> imports = document.selectNodes("/jco/import");
		buildImport(imports, importSheet);
		
		//============================
		List<Element> tableList = document
				.selectNodes("/jco/tables/table[@isin='1']");
		for (Element element : tableList) {
			buildTable(element, importSheet);
		}
		
		
	}
	
	private void buildExport(List<Element> exportElements,HSSFSheet exportSheet)
	{
		
		int exportRow=0;
		for (int i = 0; i < exportElements.size(); i++) {
			Element exportNode = exportElements.get(i);
//			HSSFRow row = exportSheet.createRow(exportRow++);
			
			//row.createCell(0).setCellValue("传出参数 ");
			// 写入import标签的title===================
			if (i == 0) {
				List<Element> fieldList = exportNode.elements();
				HSSFRow title_Row= exportSheet.createRow(exportRow++);
				for (int j = 0; j < fieldList.size(); j++) {
					HSSFCell titleCell=title_Row.createCell((short)j);
					if(this.title_style!=null)
					{
						titleCell.setCellStyle(title_style);
					}
					String name =getAttrValue(fieldList.get(j),"name","");
					String title =getAttrValue(fieldList.get(j),"title","");
					titleCell.setCellValue(name+"("+title+")");
				}
			}
			//=================
			List<Element> valueList = exportNode.elements();
			HSSFRow value_Row= exportSheet.createRow(exportRow++);
			for (int v = 0; v < valueList.size(); v++) {
				HSSFCell titleCell=value_Row.createCell((short)v);
				if(this.value_style!=null)
				{
					titleCell.setCellStyle(value_style);
				}
				titleCell.setCellValue(valueList.get(v).getText());
			}
			List<Element> structList = exportNode.selectNodes("./structure");
			buildStructure(structList, exportSheet, exportRow);
			
		}
		
	}
	
	private void buildImport(List<Element> importElements,HSSFSheet importSheet)
	{
		int importRow=0;
		for (int i = 0; i < importElements.size(); i++) {
			Element importNode = importElements.get(i);
//			HSSFRow row = importSheet.createRow(importRow++);
//			
//			row.createCell(0).setCellValue("传入参数 ");
			// 写入import标签的title===================
			if (i == 0) {
				List<Element> fieldList = importNode.selectNodes("./field");
				HSSFRow title_Row= importSheet.createRow(importRow++);
				for (int j = 0; j < fieldList.size(); j++) {
					HSSFCell titleCell=title_Row.createCell((short)j);
					if(this.title_style!=null)
					{
						titleCell.setCellStyle(title_style);
					}
					
					String name =getAttrValue(fieldList.get(j),"name","");
					String title =getAttrValue(fieldList.get(j),"title","");
					titleCell.setCellValue(name+"("+title+")");
					
//					importSheet.autoSizeColumn(j);
					
				}
			}
			//=================
			List<Element> valueList = importNode.selectNodes("./field");
			HSSFRow value_Row= importSheet.createRow(importRow++);
			for (int v = 0; v < valueList.size(); v++) {
				HSSFCell titleCell=value_Row.createCell((short)v);
				if(this.value_style!=null)
				{
					titleCell.setCellStyle(value_style);
				}
				titleCell.setCellValue(valueList.get(v).getText());
			}
			List<Element> structList = importNode.selectNodes("./structure");
			buildStructure(structList, importSheet, importRow);
		}
		//自动调整宽度
//		for(int lastRowNum=importSheet.getLastRowNum();lastRowNum>0;lastRowNum--)
//		{
//			importSheet.autoSizeColumn(lastRowNum);
//		}
//		System.out.println(importSheet.getRow(0).getPhysicalNumberOfCells());
		
	}
	
	private void buildStructure(List<Element> structList,HSSFSheet sheet,int rowNum)
	{
		
		for (Element struct : structList) {
			HSSFRow struct_title= sheet.createRow(rowNum++);
			struct_title.createCell((short)0).setCellValue("结构体："+getAttrValue(struct, "name", ""));
			if(this.title_style!=null)
			{
				struct_title.getCell((short)0).setCellStyle(title_style);
			}
			
			List<Element> fieldList= struct.elements();
			HSSFRow title_Row= sheet.createRow(rowNum++);
			HSSFRow value_Row= sheet.createRow(rowNum++);
			for (int j = 0; j < fieldList.size(); j++) {
				HSSFCell titleCell=title_Row.createCell((short)j);
				if(this.title_style!=null)
				{
					titleCell.setCellStyle(title_style);
				}
				
				HSSFCell valueCell=value_Row.createCell((short)j);
				if(this.value_style!=null)
				{
					valueCell.setCellStyle(value_style);
				}
				
				String name =getAttrValue(fieldList.get(j),"name","");
				String title =getAttrValue(fieldList.get(j),"title","");
				titleCell.setCellValue(name+"("+title+")");
				valueCell.setCellValue(fieldList.get(j).getText());
//				sheet.autoSizeColumn(j);
			}
		}
	}
	
	
	private void buildTable(Element tableElement ,HSSFSheet targetSheet)
	{
		int rowNum=targetSheet.getLastRowNum();
		HSSFRow row=targetSheet.createRow(rowNum+1);
		String tableName =getAttrValue(tableElement, "name", "");
		row.createCell((short)0).setCellValue(tableName);
		if(this.title_style!=null)
		{
			row.getCell((short)0).setCellStyle(title_style);
		}
		List<Element> recordsList=tableElement.elements();
		
		//写入表头===============
		if(recordsList.size()>0)
		{
			List<Element> title_table=recordsList.get(0).elements();
			HSSFRow title_Row=targetSheet.createRow(rowNum+2);
			title_Row.createCell((short)0).setCellValue("序号");
			if(this.title_style!=null)
			{
				title_Row.getCell((short)0).setCellStyle(title_style);
			}
//			targetSheet.autoSizeColumn(0);
			for(int i=0;i<title_table.size();i++)
			{
				HSSFCell titleCell=title_Row.createCell((short)(i+1));
				if(this.title_style!=null)
				{
					titleCell.setCellStyle(title_style);
				}
				String name =getAttrValue(title_table.get(i),"name","");
				String title =getAttrValue(title_table.get(i),"title","");
				titleCell.setCellValue(name+"("+title+")");
//				targetSheet.autoSizeColumn(i+1);
			}
		}
		//=====写表数据========================
		String xml_rows=getAttrValue(tableElement, "rows", "");
		String isin=getAttrValue(tableElement, "isin", "");
		if((StringUtil.isNull(xml_rows)||Integer.parseInt(xml_rows.trim())<=0)&&(isin.contains("0")?true:false))
			return ;
		for(int j=0;j<recordsList.size();j++)
		{
			HSSFRow value_Row=targetSheet.createRow(rowNum+3+j);
			List<Element> fieldValue=recordsList.get(j).elements();
			value_Row.createCell((short)0).setCellValue(j+1);
			  if(this.value_style!=null)
				{
				  value_Row.getCell((short)0).setCellStyle(value_style);
				}
			
			for(int v=0;v<fieldValue.size();v++)
			{
                HSSFCell titleCell=value_Row.createCell((short)(v+1));
                if(this.value_style!=null)
				{
					titleCell.setCellStyle(value_style);
				}
				titleCell.setCellValue(fieldValue.get(v).getText());
			}
		}
		
	}
	
	/**
	 * 获取节点的某个属性,如果xml上不存在这个属性或者属性为null||""都返回默认值
	 * @param element xml节点
	 * @param attrName 属性名
	 * @param defaultValue 默认值
	 * @return 属性值
	 */
	private String getAttrValue(Element element, String attrName,
			String defaultValue) {
		String rtn = defaultValue;
		if (StringUtil.isNull(attrName)) {
			return defaultValue;
		}
		Attribute attr = element.attribute(attrName);
		if (attr == null) {
			return defaultValue;
		}
		String attrValue = attr.getValue();
		return StringUtil.isNotNull(attrValue) ? attrValue : defaultValue;

	}
	

	public static void main(String[] args) {
		TibSysSapExcelUtil su = new TibSysSapExcelUtil();
		try {
			HSSFWorkbook wb=su.xmlForExcel(null, null);
			OutputStream os=new FileOutputStream("E:\\workbook.xls");
			wb.write(os);
			os.flush();
			os.close();
			System.out.println("end");
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
