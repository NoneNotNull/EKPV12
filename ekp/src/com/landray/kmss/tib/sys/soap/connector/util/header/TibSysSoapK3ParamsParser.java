package com.landray.kmss.tib.sys.soap.connector.util.header;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.tib.sys.soap.connector.forms.MapVo;
import com.landray.kmss.tib.sys.soap.connector.util.header.licence.ITibSysSoapParamsParser;

public class TibSysSoapK3ParamsParser implements ITibSysSoapParamsParser{
 
	public List<MapVo> paramsParse(HttpServletRequest request) {
		
		List<MapVo> rtnList = new ArrayList<MapVo>();
		String userName = request.getParameter("k3UserName");
		String password = request.getParameter("k3Password");
		String iAisID = request.getParameter("k3IAisID");
		MapVo userNameMap = new MapVo();
		MapVo passwordMap = new MapVo();
		MapVo iAisIDMap = new MapVo();
		
		userNameMap.setKey("k3UserName");
		userNameMap.setValue(userName);
		rtnList.add(userNameMap);
		
		passwordMap.setKey("k3Password");
		passwordMap.setValue(password);
		rtnList.add(passwordMap);

		iAisIDMap.setKey("k3IAisID");
		iAisIDMap.setValue(iAisID);
		rtnList.add(iAisIDMap);

		return rtnList;
	}

}
