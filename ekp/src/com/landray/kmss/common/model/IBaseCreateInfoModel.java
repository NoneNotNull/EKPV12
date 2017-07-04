package com.landray.kmss.common.model;

import java.util.Date;

import com.landray.kmss.sys.organization.model.SysOrgPerson;

public interface IBaseCreateInfoModel {

	public abstract Date getDocCreateTime();

	public abstract void setDocCreateTime(Date createTime);

	public abstract SysOrgPerson getDocCreator();

	public abstract void setDocCreator(SysOrgPerson creator);

}