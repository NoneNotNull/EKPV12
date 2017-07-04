package com.landray.kmss.tib.sys.soap.connector.util.taglib;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.jsp.JspException;

import com.landray.kmss.util.StringUtil;
import com.landray.kmss.web.taglib.xform.AbstractDataSourceTag;
import com.landray.kmss.web.taglib.xform.DataSourceType;

public class TibSysSplitStringDateSource extends AbstractDataSourceTag {

	protected String regx = null;
	protected String sourceString = null;

	@Override
	protected List<DataSourceType> acquireResult() throws JspException {
		// TODO 自动生成的方法存根
		List<DataSourceType> result = new ArrayList<DataSourceType>();
		
		if(StringUtil.isNull(regx)||StringUtil.isNull(sourceString)){
			return result ;
		}
		String[] results=sourceString.split(regx);
		
		
		for(String type:results){
			DataSourceType dt=new DataSourceType();
			dt.setName(type);
			dt.setValue(type);
			result.add(dt);
		}
		return result;
	}
	
	public void release() {
		super.release();
		sourceString=null;
		regx=null;
		
	}


	public String getSourceString() {
		return sourceString;
	}

	public void setSourceString(String sourceString) {
		this.sourceString = sourceString;
	}

	public String getRegx() {
		return regx;
	}

	public void setRegx(String regx) {
		this.regx = regx;
	}
	
	
	
	
	

}
