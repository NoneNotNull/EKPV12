package com.landray.kmss.common.model;

import java.util.Date;

/**
 * 需要增加最近修改时间的域模型基类，该基类继承BaseModel基类<br>
 * 所有需要带权限的全文检索必须实现ILastModifiedTimeModel接口<br>
 * 如果已经有的模块的域模型是继承BaseModel基类，则只需要将继承的BaseModel基类修改为LastModifiedTimeModel即可
 * 否则需要独自实现ILastModifiedTimeModel接口
 * 
 * @author 吴兵
 * @version 1.0 2010-01-11
 */
public abstract class LastModifiedTimeModel extends BaseModel implements
		ILastModifiedTimeModel {

	protected Date fdLastModifiedTime = null;

	public Date getFdLastModifiedTime() {
		return fdLastModifiedTime;
	}

	public void setFdLastModifiedTime(Date fdLastModifiedTime) {
		this.fdLastModifiedTime = fdLastModifiedTime;
	}

	public void recalculateFields() {
		super.recalculateFields();
		setFdLastModifiedTime(new Date());
	}

}
