package com.landray.kmss.tib.sap.sync.model;

import com.landray.kmss.util.StringUtil;

public class ClocalVo {

	private String tableName;
	private String dsID;
	private String type;
	private String timestampName;
	private String tempfuncId;

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getDsID() {
		return dsID;
	}

	public void setDsID(String dsID) {
		this.dsID = dsID;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTimestampName() {
		return timestampName;
	}

	public void setTimestampName(String timestampName) {
		this.timestampName = timestampName;
	}
	
	public String getTempfuncId() {
		return tempfuncId;
	}

	public void setTempfuncId(String tempfuncId) {
		this.tempfuncId = tempfuncId;
	}

	@Override
	public boolean equals(Object arg0) {
	    if(!(arg0 instanceof ClocalVo)) return false;
	 	ClocalVo arg = (ClocalVo) arg0;
		if (StringUtil.isNotNull(arg.getDsID())
				&& StringUtil.isNotNull(tableName)
				&& StringUtil.isNotNull(arg.getTableName())
				&& StringUtil.isNotNull(dsID)) {
			
			if(arg.getDsID().equals(dsID)&&arg.getTableName().equals(tableName))
			{
				return true;
			}
		}
		return false;
	}
	
	@Override
	public int hashCode() {
		   int result;
		   result = (tableName == null?0:tableName.hashCode());
		   result = 37*result + (dsID == null?0:dsID.hashCode());
		return result;
	}
}
