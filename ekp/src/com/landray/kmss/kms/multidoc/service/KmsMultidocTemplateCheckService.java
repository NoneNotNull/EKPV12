package com.landray.kmss.kms.multidoc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
/**
 *  校验模板名字不重复
 */
public class KmsMultidocTemplateCheckService implements IXMLDataBean{

	private IKmsMultidocTemplateService kmsMultidocTemplateService;
	
	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		List rtnList = new ArrayList();
		String type = requestInfo.getRequest().getParameter("type");
		if(type.equals("1")){
			//校验项目名称唯一性
			rtnList=checkCateName(requestInfo);
		}
		
		return rtnList;
	}

	
	private List checkCateName(RequestContext requestInfo)throws Exception{
		String fdName = requestInfo.getRequest().getParameter("fdName");
		String fdId = requestInfo.getRequest().getParameter("fdId");
		String parentId = requestInfo.getRequest().getParameter("parentId");
		List rtnList = new ArrayList();
	    //fdName=java.net.URLDecoder.decode(fdName,"UTF-8"); 
		String flag="false";
		boolean b=  kmsMultidocTemplateService.checkTemplateName(fdId,fdName,parentId) ;
		
		if(b){
			flag="false";
		}else
			flag="true";
		
		HashMap node = new HashMap();
		node.put("flag", flag);
		rtnList.add(node);
		return rtnList;
	}
	
}
