package com.landray.kmss.common.model;

import com.landray.kmss.constant.BaseTreeConstant;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;

public abstract class BaseTreeModel extends BaseModel implements IBaseTreeModel {
	protected String fdHierarchyId = BaseTreeConstant.HIERARCHY_ID_SPLIT
			+ getFdId() + BaseTreeConstant.HIERARCHY_ID_SPLIT;

	public String getFdHierarchyId() {
		return fdHierarchyId;
	}

	public void setFdHierarchyId(String fdHierarchyId) {
		this.fdHierarchyId = fdHierarchyId;
	}

	protected IBaseTreeModel fdParent;

	public IBaseTreeModel getFdParent() {
		return fdParent;
	}

	public void setFdParent(IBaseTreeModel parent) {
		IBaseTreeModel oldParent = getHbmParent();
		if (!ObjectUtil.equals(oldParent, parent)) {
			ModelUtil.checkTreeCycle(this, parent, "fdParent");
			setHbmParent(parent);
		}
	}

	public IBaseTreeModel getHbmParent() {
		return fdParent;
	}

	public void setHbmParent(IBaseTreeModel parent) {
		this.fdParent = parent;
	}
}