package com.landray.kmss.util;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class ExcelUtil {
	/**
	 * 获取某个单元格的值
	 * 
	 * @param cell
	 * @return
	 */
	public static Object getCellValue(HSSFCell cell) {
		String retStr = "";
		if (cell == null)
			return retStr;
		switch (cell.getCellType()) {
		case 0:
			return new Double(cell.getNumericCellValue());
		case 1:
			retStr = cell.getStringCellValue();
			break;
		case 2:
			return new Double(cell.getNumericCellValue());
		case 3:
			retStr = "";
			break;
		default:
			retStr = cell.getStringCellValue();
		}
		return retStr;
	}
}
