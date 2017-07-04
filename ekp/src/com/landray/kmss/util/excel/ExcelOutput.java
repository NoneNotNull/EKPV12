package com.landray.kmss.util.excel;

import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

public interface ExcelOutput {
	public void output(WorkBook workbook, OutputStream outputStream) throws Exception;
	public void output(WorkBook workbook, HttpServletResponse response) throws Exception;
}
