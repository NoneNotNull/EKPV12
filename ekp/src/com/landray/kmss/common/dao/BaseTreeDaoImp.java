package com.landray.kmss.common.dao;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.model.IBaseTreeModel;
import com.landray.kmss.constant.BaseTreeConstant;

public class BaseTreeDaoImp extends BaseDaoImp implements BaseTreeConstant {
	private String getTreeHierarchyId(IBaseTreeModel treeModel) {
		if (treeModel.getFdParent() != null)
			return treeModel.getFdParent().getFdHierarchyId()
					+ treeModel.getFdId() + HIERARCHY_ID_SPLIT;
		else
			return HIERARCHY_ID_SPLIT + treeModel.getFdId()
					+ HIERARCHY_ID_SPLIT;
	}

	public String add(IBaseModel modelObj) throws Exception {
		IBaseTreeModel treeModel = (IBaseTreeModel) modelObj;
		treeModel.setFdHierarchyId(getTreeHierarchyId(treeModel));
		return super.add(modelObj);
	}

	public void update(IBaseModel modelObj) throws Exception {
		IBaseTreeModel treeModel = (IBaseTreeModel) modelObj;
		String hierarchyId = getTreeHierarchyId(treeModel);
		String oldHierarchyId = treeModel.getFdHierarchyId();
		treeModel.setFdHierarchyId(hierarchyId);
		super.update(modelObj);
		if (oldHierarchyId != null && !hierarchyId.equals(oldHierarchyId)) {
			String hqlStr = "update " + getModelName() + " set fdHierarchyId='"
					+ hierarchyId + "' || substring(fdHierarchyId, "
					+ (oldHierarchyId.length() + 1)
					+ ", length(fdHierarchyId)) where fdHierarchyId like '"
					+ oldHierarchyId + "%'"; 
			getHibernateSession().createQuery(hqlStr).executeUpdate();
		}
	}
}
