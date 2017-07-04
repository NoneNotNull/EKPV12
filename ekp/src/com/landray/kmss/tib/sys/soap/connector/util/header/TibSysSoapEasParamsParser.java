package com.landray.kmss.tib.sys.soap.connector.util.header;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;

import com.landray.kmss.tib.sys.soap.connector.forms.MapVo;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.util.header.licence.ITibSysSoapParamsParser;
import com.landray.kmss.tib.sys.soap.connector.util.plugins.EasList;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapEasParamsParser implements ITibSysSoapParamsParser{

	private String easLoginName="EASLogin";
	
	public List<MapVo> paramsParse(HttpServletRequest request) {
		EasList easList = new EasList();
		List<MapVo> rtnList = new ArrayList<MapVo>();
		try {
			BeanUtils.populate(easList, request.getParameterMap());
		} catch (Exception e) {
			// TODO: handle exception
		}
		List easInfos = easList.getFdEas();
		rtnList.addAll(easInfos);
		return rtnList;
		 
	}
	
	
	/**
	 * 根据EAS 规则 查找登录地址
	 * @param executeUrl 源登录地址
	 * @param TibSysSoapSetting 额外参数
	 * @return
	 */
	public String findEASLoginUrl(String executeUrl,TibSysSoapSetting TibSysSoapSetting){
		
		if(StringUtil.isNull(executeUrl)){
			executeUrl=TibSysSoapSetting.getFdWsdlUrl();
		}
		int last=executeUrl.lastIndexOf("/");
		String preUrl=executeUrl.substring(0, last+1); 
		
		return preUrl+easLoginName+"?wsdl";
		
	}
	
	public static void main(String[] args) {
		
		TibSysSoapEasParamsParser pser=new TibSysSoapEasParamsParser();
		String s=pser.findEASLoginUrl("http://222.177.119.193:7888/ormrpc/services/WSWSPurOrderFacade?wsdl", null);
	}
	
	

}
