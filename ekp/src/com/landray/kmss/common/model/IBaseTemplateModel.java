package com.landray.kmss.common.model;

import java.util.List;

import com.landray.kmss.sys.category.model.SysCategoryMain;

public interface IBaseTemplateModel extends IBaseModel {
	public abstract SysCategoryMain getDocCategory();

	public abstract String getFdName();

	public abstract List getAuthAllEditors();

	public abstract List getAuthAllReaders();

	public abstract Boolean getAuthReaderFlag();
}
