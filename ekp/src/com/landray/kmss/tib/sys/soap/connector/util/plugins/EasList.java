package com.landray.kmss.tib.sys.soap.connector.util.plugins;

import java.util.List;

import com.landray.kmss.tib.sys.soap.connector.forms.MapVo;
import com.landray.kmss.util.AutoArrayList;

/**
 * 用来组装eas 登录的数据
 * @author zhangtian
 * date :2013-1-9 下午06:56:09
 */
public class EasList{
	private List fdEas=new AutoArrayList(MapVo.class);

	public List getFdEas() {
		return fdEas;
	}

	public void setFdEas(List fdEas) {
		this.fdEas = fdEas;
	}
	
}
