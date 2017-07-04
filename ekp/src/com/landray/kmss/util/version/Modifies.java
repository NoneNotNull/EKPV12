package com.landray.kmss.util.version;

import java.util.ArrayList;
import java.util.List;

/**
 * 创建日期 2010-十一月-05
 * 
 * @author 缪贵荣 修改信息
 */
public class Modifies {

	/**
	 * 修改详细信息
	 */
	protected List<Modify> modifyList = new ArrayList<Modify>();

	public List<Modify> getModifyList() {
		return modifyList;
	}

	public void setModifyList(List<Modify> modifyList) {
		this.modifyList = modifyList;
	}

	public void addModify(Modify modify) {
		if (!modifyList.contains(modify)) {
			modifyList.add(0, modify);
		}
	}

}
