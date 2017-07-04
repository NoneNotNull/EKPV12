package com.landray.kmss.code.examine;

import java.util.List;

import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class ModelPrinter {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		SysDataDict dataDict = SysDataDict.getInstance();
		List dataDictList = dataDict.getModelInfoList();
		for (int i = 0; i < dataDictList.size(); i++) {
			SysDictModel dictModel = dataDict.getModel(dataDictList.get(i)
					.toString());
			if (StringUtil.isNotNull(dictModel.getMessageKey())) {
				System.out.println(dictModel.getModelName() + " = "
						+ ResourceUtil.getString(dictModel.getMessageKey())+" - "+dictModel.getMessageKey());
			}
		}
	}

}
