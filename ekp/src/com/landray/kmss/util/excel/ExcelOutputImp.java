package com.landray.kmss.util.excel;

import java.io.OutputStream;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;

import com.landray.kmss.util.ResourceUtil;

public class ExcelOutputImp implements ExcelOutput {

	@SuppressWarnings("unchecked")
	public void output(WorkBook workbook, OutputStream outputStream)
			throws Exception {
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFCellStyle titleStyle = buildStyle(wb, "title");
		HSSFCellStyle columnTitleStyle = buildStyle(wb, "columnTitle");
		HSSFCellStyle contentStyle = buildStyle(wb, "content");
		int index = 0;
		for (Iterator iter = workbook.getSheetList().iterator(); iter.hasNext();) {
			Sheet sheet = (Sheet) iter.next();
			String sheetName = getSheetName(workbook, sheet);
			HSSFSheet sheetHSSF = wb.createSheet();
			wb.setSheetName(index++, sheetName);
			HSSFRow row;
			HSSFCell cell;
			int rowNO = 0;
			int columnCount = sheet.getColumnList().size(); // 计算总列数
			if (sheet.isIfCreateSheetTitleLine()) {
				/* 创建标题行 BEGIN */
				row = sheetHSSF.createRow((short) rowNO++); // 标题行
				cell = row.createCell(0);
				cell.setCellValue(sheetName);
				cell.setCellStyle(titleStyle);
				CellRangeAddress range = new CellRangeAddress(0, 0, 0,
						columnCount - 1);
				sheetHSSF.addMergedRegion(range);
				/* 创建标题行 END */
			}

			/* 创建列标题行 BEGIN */
			row = sheetHSSF.createRow((short) rowNO++); // 列标题行
			for (int i = 0; i < columnCount; i++) {
				Column column = (Column) sheet.getColumnList().get(i);
				cell = row.createCell(i);
				// cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				if (column.isRedFont())
					cell.setCellStyle(buildStyle(wb, "columnTitle", "red"));
				else
					cell.setCellStyle(columnTitleStyle);
				cell.setCellValue(getColumnName(workbook, sheet, column));
			}
			/* 创建列标题行 END */

			/* 创建内容 BEGIN */
			for (Iterator<?> it = sheet.getContentList().iterator(); it
					.hasNext();) {
				int firstRow = rowNO++; // 主行在所有行中行号

				Object obj = it.next();

				// 创建行中内容
				SheetRowBuilder rowBuilder = new SheetRowBuilder();
				rowBuilder.workbook = workbook;
				rowBuilder.contentStyle = contentStyle;
				rowBuilder.sheet = sheet;
				rowBuilder.sheetHSSF = sheetHSSF;

				rowBuilder.firstRow = firstRow;
				rowBuilder.rowObj = obj;

				rowBuilder.build();

				rowNO = rowBuilder.rowSpan + firstRow;
			}
			// for (int j = 0, n = sheet.getContentList().size(); j < n; j++) {
			// // j为行号
			// Object obj = sheet.getContentList().get(j);
			// row = sheetHSSF.createRow(j + rowNO);
			// if (obj instanceof Object[] || obj instanceof List) {
			// Object[] oneRow = (obj instanceof List) ? ((List) obj)
			// .toArray() : (Object[]) obj;
			//
			// int colOffset = 0;
			// int maxRowOffset = rowNO;
			//
			// for (int i = 0; i < oneRow.length; i++) { // i为列号，从0开始
			// obj = oneRow[i];
			// int[] rowAndColl = createDetailCell(wb, sheetHSSF,
			// columnTitleStyle, contentStyle, workbook,
			// sheet, row, obj, j, i, i + colOffset, rowNO);
			// maxRowOffset = rowAndColl[0] > maxRowOffset ? rowAndColl[0]
			// : maxRowOffset;
			// // 首行数据时，对标题做出调整
			// /*
			// * if (j == 0 && rowAndColl[1] > 0) {
			// * autoMoveColumnTitle(sheetHSSF, rowNO - 1, i +
			// * colOffset, rowAndColl[1], columnTitleStyle); }
			// */
			// colOffset = colOffset + rowAndColl[1];
			// }
			// if (rowNO != maxRowOffset) {
			// // 自动调整合并单元格
			// autoMergedRegion(sheetHSSF, j + rowNO,
			// j + maxRowOffset,
			// colOffset + oneRow.length - 1, contentStyle);
			// rowNO = maxRowOffset;
			// }
			// } else {
			// createCell(contentStyle, workbook, sheet, row, obj, j);
			// }
			// }
			/* 创建内容 END */
		}
		if (outputStream != null)
			wb.write(outputStream);
		else if (response != null)
			wb.write(response.getOutputStream());
		else
			throw new IllegalArgumentException(
					"outputStream和response不能同时为NULL！");
	}

	private int[] createDetailCell(HSSFWorkbook wb, HSSFSheet sheetHSSF,
			HSSFCellStyle columnTitleStyle, HSSFCellStyle contentStyle,
			WorkBook workbook, Sheet sheet, HSSFRow row, Object obj, int j,
			int i, int currCol, int rowNO) throws Exception {
		int colOffset = 0;
		if (isSheetCell(obj)) {
			Sheet subTable = (Sheet) obj;
			int currRow = j + rowNO;
			int lasRowIndex = createSheetCell(wb, sheetHSSF, columnTitleStyle,
					contentStyle, workbook, row, subTable, currCol, currRow);
			colOffset = subTable.getColumnList().size() - 1;
			rowNO = rowNO + lasRowIndex - currRow;
		} else {
			createCell(contentStyle, workbook, sheet, row, obj, currCol, i);
		}
		return new int[] { rowNO, colOffset };
	}

	private boolean isSheetCell(Object obj) {
		return (obj instanceof Sheet);
	}

	private void autoMoveColumnTitle(HSSFSheet sheetHSSF, int firstRow,
			int firstCol, int offset, HSSFCellStyle columnTitleStyle) {
		HSSFRow row = sheetHSSF.getRow(firstRow);
		int lastCol = row.getLastCellNum();
		for (int index = lastCol + offset - 1; index > firstCol; index--) {
			HSSFCell cell = row.getCell(index);
			if (cell == null) {
				cell = row.createCell(index);
				cell.setCellStyle(columnTitleStyle);
			}
			HSSFCell preCell = row.getCell(index - offset);
			if (preCell != null) {
				cell.setCellValue(preCell.getStringCellValue());
			} else {
				cell.setCellValue("");
			}
		}
		CellRangeAddress range = new CellRangeAddress(firstRow, firstRow,
				firstCol, firstCol + offset);
		sheetHSSF.addMergedRegion(range);
	}

	private void autoMergedRegion(HSSFSheet sheetHSSF, int firstRow,
			int lastRow, int lastCol, HSSFCellStyle contentStyle) {
		HSSFRow row = sheetHSSF.getRow(firstRow);
		for (int colIndex = 0; colIndex <= lastCol; colIndex++) {
			HSSFCell cell = row.getCell(colIndex);
			if (cell != null && contentStyle.equals(cell.getCellStyle())) {
				for (int rangeRow = firstRow; rangeRow <= lastRow; rangeRow++) {
					HSSFRow emptyRow = sheetHSSF.getRow(rangeRow);
					HSSFCell emptyCell = emptyRow.getCell(colIndex);
					if (emptyCell == null) {
						emptyCell = emptyRow.createCell(colIndex);
					}
					emptyCell.setCellStyle(contentStyle);
				}
				CellRangeAddress range = new CellRangeAddress(firstRow,
						lastRow, colIndex, colIndex);
				sheetHSSF.addMergedRegion(range);
			}
		}
	}

	// 返回值为当前已经占用到的行号
	@SuppressWarnings("unchecked")
	private int createSheetCell(HSSFWorkbook wb, HSSFSheet sheetHSSF,
			HSSFCellStyle columnTitleStyle, HSSFCellStyle contentStyle,
			WorkBook workbook, HSSFRow row, Sheet subTable, int currCol,
			int currRow) throws Exception {
		int startRowNo = currRow;
		int currRowIndex = startRowNo;
		int startColNo = currCol;
		int columnCount = subTable.getColumnList().size();

		/*
		 * HSSFRow titleRow = row; // sheetHSSF.createRow(startRowNo++); // 列标题行
		 * for (int i = 0; i < columnCount; i++) { Column column = (Column)
		 * subTable.getColumnList().get(i); HSSFCell cell =
		 * titleRow.createCell(i + startColNo); if (column.isRedFont())
		 * cell.setCellStyle(buildStyle(wb, "columnTitle", "red")); else
		 * cell.setCellStyle(columnTitleStyle);
		 * cell.setCellValue(getColumnName(workbook, subTable, column)); }
		 * 
		 * startRowNo++;
		 */
		for (int rowIndex = 0, n = subTable.getContentList().size(); rowIndex < n; rowIndex++) { // j为行号
			currRowIndex++;
			Object obj = subTable.getContentList().get(rowIndex);
			HSSFRow contentRow = sheetHSSF.getRow(rowIndex + startRowNo);
			if (contentRow == null) {
				contentRow = sheetHSSF.createRow(rowIndex + startRowNo);
			}
			if (obj instanceof Object[]) {
				Object[] oneRow = (Object[]) obj;
				for (int colIndex = 0; colIndex < oneRow.length; colIndex++) { // i为列号，从0开始
					obj = oneRow[colIndex];
					createCell(contentStyle, workbook, subTable, contentRow,
							obj, colIndex + startColNo, colIndex);
				}
			} else if (obj instanceof List) {
				List oneRow = (List) obj;
				for (int colIndex = 0; colIndex < oneRow.size(); colIndex++) { // i为列号，从0开始
					obj = oneRow.get(colIndex);
					createCell(contentStyle, workbook, subTable, contentRow,
							obj, colIndex + startColNo, colIndex);
				}
			} else {
				createCell(contentStyle, workbook, subTable, contentRow, obj,
						startColNo);
			}
		}

		return currRowIndex;
	}

	private void createCell(HSSFCellStyle contentStyle, WorkBook workbook,
			Sheet sheet, HSSFRow row, Object obj, int cellIndex, int dataIndex)
			throws Exception {
		String cellValue;
		HSSFCell cell = row.createCell(cellIndex);
		// cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellStyle(contentStyle);
		KmssFormat kmssFormat = ((Column) sheet.getColumnList().get(dataIndex))
				.getFormat();
		if (kmssFormat == null && obj instanceof Date
				&& workbook.getDateFormat() != null)
			kmssFormat = workbook.getDateFormat();
		if (kmssFormat == null
				&& workbook.getNumberFormat() != null
				&& (obj instanceof Double || obj instanceof Float
						|| obj instanceof Long || obj instanceof Integer
						|| obj instanceof Short || obj instanceof Byte))
			kmssFormat = workbook.getNumberFormat();
		if (kmssFormat != null) {
			cellValue = kmssFormat.format(obj);
			/* 如果不需要将数字、日期转换为字符串输出，则使用下面代码重新转回来 */
			if (false) {
				if (kmssFormat instanceof KmssDefaultNumberFormat) {
					cell.setCellValue(Double.parseDouble(cellValue));
					return;
				} else if (kmssFormat instanceof KmssDateFormat) {
					// KmssDateFormat kmssDateFormat = (KmssDateFormat)
					// kmssFormat;
					// SimpleDateFormat sf = new
					// SimpleDateFormat(kmssDateFormat.getPatten(),
					// kmssDateFormat.getLocale());
					// short index =
					// HSSFDataFormat.getBuiltinFormat(kmssDateFormat.getPatten());
					// System.out.println("index=" + index);
					// if (index > 0)
					// contentStyle.setDataFormat(index);
					// cell.setCellValue(sf.parse(cellValue));
					// return;
					// TODO
				}
			}
			/* 如果不需要将数字、日期转换为字符串输出，则使用上面代码重新转回来 */
		} else {
			if (obj != null)
			{
				cellValue = obj.toString();
				/**
				 * 超出excel单元格最大长度则截取并追加提示说明
				 */
				if (cellValue.getBytes().length>=32767) {
					cellValue=cellValue.substring(0, 10000)+"（内容过长请直接到系统中查看）";
				}
			}
			else
				cellValue = null;
		}
		cell.setCellValue(cellValue);
	}

	private void createCell(HSSFCellStyle contentStyle, WorkBook workbook,
			Sheet sheet, HSSFRow row, Object obj, int i) throws Exception {
		createCell(contentStyle, workbook, sheet, row, obj, i, i);
	}

	private HSSFCellStyle buildStyle(HSSFWorkbook wb, String type, String color) {
		HSSFCellStyle style = wb.createCellStyle();
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setLeftBorderColor(HSSFColor.BLACK.index);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		HSSFFont font = wb.createFont();
		if ("red".equals(color))
			font.setColor(HSSFFont.COLOR_RED);
		if ("title".equals(type)) { // 表格标题，粗体，居中，12号字
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			font.setFontHeightInPoints((short) 12);
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
		} else if ("columnTitle".equals(type)) { // 表格列标题，粗体，居中，10号字
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			font.setFontHeightInPoints((short) 10);
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
		} else if ("content".equals(type)) { // 内容，10号字
			font.setFontHeightInPoints((short) 10);
			style.setFont(font);
		}
		return style;
	}

	private HSSFCellStyle buildStyle(HSSFWorkbook wb, String type) {
		return buildStyle(wb, type, null);
	}

	private String getColumnName(WorkBook workbook, Sheet sheet, Column column)
			throws Exception {
		String columnName;
		if (column.getTitleKey() != null) { // 如果设置了TitleKey，则优先使用
			String bundle = column.getBundle();
			if (bundle == null)
				bundle = sheet.getBundle();
			if (bundle == null)
				bundle = workbook.getBundle();
			if (bundle == null)
				throw new IllegalArgumentException(
						"如果要使用资源文件，则Column、Sheet和WorkBook的bundle属性不能同时为空！");
			Locale locale = workbook.getLocale();
			columnName = ResourceUtil.getString(column.getTitleKey(), bundle,
					locale);
			if (columnName == null)
				throw new Exception("获取资源失败，Key:" + column.getTitleKey()
						+ " Bundle:" + bundle + " Locale:" + locale);
		} else
			columnName = column.getTitle();
		if (columnName == null)
			throw new IllegalArgumentException(
					"Column对象的title属性和titleKey属性不能同时为空！");
		return columnName;
	}

	private String getSheetName(WorkBook workbook, Sheet sheet) {
		String sheetName;
		if (sheet.getTitleKey() != null) { // 如果设置了TitleKey，则优先使用
			String bundle = sheet.getBundle();
			if (bundle == null) // 如果Sheet没有设置bundle，则使用WorkBook的
				bundle = workbook.getBundle();
			if (bundle == null)
				throw new IllegalArgumentException(
						"如果要使用资源文件，则Sheet和WorkBook的bundle属性不能同时为空！");
			Locale locale = workbook.getLocale();
			sheetName = ResourceUtil.getString(sheet.getTitleKey(), bundle,
					locale);
		} else
			sheetName = sheet.getTitle();
		if (sheetName == null)
			throw new IllegalArgumentException(
					"Sheet对象的title属性和titleKey属性不能同时为空！");
		/* 替换掉一些特殊字符（ /\?*[] ） */
		String pattern = "[/\\\\\\?\\*\\[\\]]+";
		sheetName = sheetName.replaceAll(pattern, "");
		/* 如果长度超过31，则截掉，加上三个句点“.” */
		if (sheetName.length() > 31)
			sheetName = sheetName.substring(0, 28) + "...";
		return sheetName;
	}

	private HttpServletResponse response;

	public void output(WorkBook workbook, HttpServletResponse response)
			throws Exception {
		response.reset();
		response.setContentType("application/vnd.ms-excel; charset=UTF-8");
		if (workbook == null)
			return;
		String filename = workbook.getFilename();
		if (filename == null) {
			logger.warn("workbook中未设置filename属性，当前使用缺省值“Noname”。");
			filename = "Noname";
		}
		filename = new String(filename.getBytes("GBK"), "ISO-8859-1") + ".xls";
		logger.debug("filename=" + filename);
		response.addHeader("Content-Disposition", "attachment;filename="
				+ filename);
		this.response = response;
		OutputStream outputStream = null;
		output(workbook, outputStream);
	}

	private Log logger = LogFactory.getLog(this.getClass());

	class SheetRowBuilder {
		int firstRow = 0; // 主行在所有行中行号
		int colOffset = 0; // 列偏移
		int rowSpan = 1;
		int rowOffset = 0;
		Object rowObj = null;

		HSSFSheet sheetHSSF;
		HSSFRow[] rows;

		HSSFCellStyle contentStyle;
		WorkBook workbook;
		Sheet sheet;

		boolean isListRowObj() {
			return (rowObj instanceof Object[] || rowObj instanceof List);
		}

		Object[] getOneRow() {
			return (rowObj instanceof List) ? ((List) rowObj).toArray()
					: (Object[]) rowObj;
		}

		void setRowSpan() {
			// 确定最大跨行数
			if (isListRowObj()) {
				Object[] oneRow = getOneRow();
				for (int i = 0; i < oneRow.length; i++) {
					Object oneCol = oneRow[i];
					if (oneCol instanceof Sheet) {
						int size = ((Sheet) oneCol).getContentList().size();
						if (size > rowSpan) {
							rowSpan = size;
						}
					}
				}
			}
		}

		void createRows() {
			// 创建所有行
			if (rows != null)
				return;
			rows = new HSSFRow[rowSpan];
			for (int i = 0; i < rowSpan; i++) {
				rows[i] = sheetHSSF.createRow(firstRow + i);
			}
		}

		void build() throws Exception {
			setRowSpan();
			createRows();

			if (isListRowObj()) {
				Object[] oneRow = getOneRow();

				for (int i = 0; i < oneRow.length; i++) {
					Object oneCol = oneRow[i];
					if (oneCol instanceof Sheet) {
						Sheet colSheet = (Sheet) oneCol;
						int lastColOffset = colOffset;
						for (Iterator<?> it = colSheet.getContentList()
								.iterator(); it.hasNext();) {
							Object colRowObj = it.next();

							SheetRowBuilder rowBuilder = new SheetRowBuilder();
							rowBuilder.workbook = workbook;
							rowBuilder.contentStyle = contentStyle;
							rowBuilder.sheet = sheet;

							rowBuilder.rowObj = colRowObj;
							rowBuilder.colOffset = colOffset;
							rowBuilder.rowOffset = rowOffset;
							rowBuilder.rows = rows;

							rowBuilder.build();

							rowOffset++;
							lastColOffset = rowBuilder.colOffset;
						}
						colOffset = lastColOffset;
						rowOffset = 0;
					} else {
						createCell(contentStyle, workbook, sheet,
								rows[rowOffset], oneCol, colOffset);
						if (rowSpan > 1) {
							CellRangeAddress range = new CellRangeAddress(
									firstRow, firstRow + rowSpan - 1,
									colOffset, colOffset);
							sheetHSSF.addMergedRegion(range);
						}
						colOffset++;
					}
				}
			} else {
				// 单列数据
				createCell(contentStyle, workbook, sheet, rows[rowOffset],
						rowObj, colOffset);
			}
		}
	}

}