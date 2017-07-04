package com.landray.kmss.common.model;

public interface IBaseTreeModel extends IBaseModel {
	public abstract IBaseTreeModel getFdParent();

	public abstract String getFdHierarchyId();

	public abstract void setFdHierarchyId(String fdHierarchyId);
}
