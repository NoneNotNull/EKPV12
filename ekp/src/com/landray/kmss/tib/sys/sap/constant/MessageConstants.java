/*
 * $Id: MessageConstants.java 22 2009-07-22 19:03:01Z yyamano $
 *
 * Copyright (c) Osaka Gas Information System Research Institute Co., Ltd.
 * All rights reserved.  http://www.ogis-ri.co.jp/
 * 
 * The software in this package is published under the terms of the CPAL v1.0
 * license, a copy of which has been included with this distribution in the
 * LICENSE.txt file.
 */
package com.landray.kmss.tib.sys.sap.constant;

public interface MessageConstants {
	String JCO = "jco";
	String JCO_ATTR_NAME = "name";
	String JCO_ATTR_ID = "id";
	String JCO_ATTR_VERSION = "version";
	String JCO_ATTR_VERSION_VALUE = "3.0";
	String JCO_ATTR_VERSION_VALUE_FIRST = "1.0";
	String JCO_ATTR_TIMESTAMP = "timestamp";
	String JCO_CODE = "utf-8";

	String IMPORT = "import";
	String EXPORT = "export";
	String TABLES = "tables";

	String FIELD = "field";
	String FIELD_ATTR_NAME = "name";
	String FIELD_ATTR_TITLE = "title";
	String FIELD_ATTR_CTYPE = "ctype";
	String FIELD_ATTR_MAXLENGTH = "maxlength";
	String FIELD_ATTR_DECIMALS = "decimals";
	String FIELD_ATTR_ISOPTIONAL = "isoptional";

	String ROW = "records";
	String TABLE_ROW = "rows";
	String ROW_ATTR_ID = "row";

	String STRUCTURE = "structure";
	String STRUCTURE_ATTR_NAME = "name";

	String TABLE = "table";
	String TABLE_ISIN = "isin";
	String TABLE_ATTR_NAME = "name";
	String TABLE_ATTR_ROW = "rows";

	String ERRORS = "errors";
	String ERROR = "error";
	String ERROR_ATTR_KEY = "key";

	String CHAR = "CHAR";
	String NUM = "NUM";
	String BYTE = "BYTE";
	String INT = "INT";
	String BCD = "BCD";
	String INT1 = "INT1";
	String INT2 = "INT2";
	String FLOAT = "FLOAT";
	String DATE = "DATE";
	String TIME = "TIME";
	String DECF16 = "DECF16";
	String DECF34 = "DECF34";
	String STRING = "STRING";
	String XSTRING = "XSTRING";

	String java_String = "String";
	String java_byte = "Byte()";
	String java_int = "Int";
	String java_date = "Date";
	String DOUBLE = "Double";
	String BIGDECIMAL = "BigDecimal";

	String ISBACK = "isback";
	String VALUE = "value";
}
