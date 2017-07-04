package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictComplexProperty;
import com.landray.kmss.sys.config.dict.SysDictIdProperty;
import com.landray.kmss.sys.config.dict.SysDictListProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.config.dict.SysDictModelProperty;
import com.landray.kmss.sys.config.dict.SysDictSimpleProperty;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 公式定义器变量选择
 * 
 * @author LINMINGMING
 * 
 */
public class TibCommonMappingFormulaDictVarTree implements IXMLDataBean {
	
//	全局控制层次
	private int level=7;
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List rtnVal = new ArrayList(1);
		String modelName = requestInfo.getParameter("modelName");
		rtnVal=loopFormulaDict(modelName, rtnVal, "","",0);
		return rtnVal;
	}

	/**
	 * @param extendFilePath
	 * @return 数据字典字段集合
	 */
	private List getDictVarInfo(String modelName) {
		SysDictModel model = SysDataDict.getInstance().getModel(modelName);
		if(model!=null){
		List properties = model.getPropertyList();
		return properties;
		}
		else{
			return null;
		}
	}
	
	/**
	 * 层级解析数据字典    lev 控制层次  
	 * @param modelName
	 * @param rtn
	 * @return
	 */
	private List loopFormulaDict(String modelName,List<Map<String,String>> rtn,String preName,String preLabel,int lev){
		
		SysDictModel model = SysDataDict.getInstance().getModel(modelName);
		if(model==null)
			 return rtn;
		
//		读取ID列
		SysDictIdProperty idProperty = model.getIdProperty();
		Map<String,String> ptMap=setterPropertyMap(preName, preLabel,idProperty);
		rtn.add(ptMap);
		
		List<SysDictCommonProperty> properties = model.getPropertyList();
		for(SysDictCommonProperty property : properties )
		{
			String ptName=property.getName();
			
			if(!property.isCanDisplay()){
				continue;
			}
			
			if(property instanceof SysDictSimpleProperty){
//				简单类型直接干掉
				Map<String,String> nextMap=setterPropertyMap(preName,preLabel, property);
				rtn.add(nextMap);
			}
			else if(property instanceof SysDictModelProperty){
				String nextModelName=property.getType();
				String label= StringUtil.isNotNull(preLabel)?preLabel+"."+ResourceUtil.getString(property.getMessageKey()):ResourceUtil.getString(property.getMessageKey());
                String nextPreName=StringUtil.isNotNull(preName)?preName+"."+ptName:ptName;
		//				防止死循环	
				if(!nextModelName.equals(modelName)&&lev<level){
//					防止死循环
					rtn=loopFormulaDict(nextModelName, rtn, nextPreName,label,lev+1);
				}
				else{
					Map<String,String> nextMap=setterPropertyMap(preName, preLabel,property);
					rtn.add(nextMap);
				}
			}
			else if(property instanceof SysDictListProperty)
			{
				String nextModelName=property.getType();
				 String nextPreName=StringUtil.isNotNull(preName)?preName+"."+ptName:ptName;
				if(!nextModelName.equals(modelName)&&lev<level){
					String label= StringUtil.isNotNull(preLabel)?preLabel+"."+ResourceUtil.getString(property.getMessageKey()):ResourceUtil.getString(property.getMessageKey());
//					防止死循环
					rtn=loopFormulaDict(nextModelName, rtn, nextPreName,label,lev+1);
				}
				else{
					Map<String,String> nextMap=setterPropertyMap(preName, preLabel,property);
					rtn.add(nextMap);
				}
			}
//			混合类型的??
			else if(property instanceof SysDictComplexProperty){
				
			}
		}
		return rtn;
		
		
	}
	
	private Map<String,String> setterPropertyMap(String preName,String preLabel ,SysDictCommonProperty property){
		Map<String,String> node = new HashMap<String, String>();
		if(property!=null){
			String label=property.getClass()==SysDictIdProperty.class?"ID": ResourceUtil.getString(property.getMessageKey());
//					requestInfo.getLocale());
			String name=property.getName();
			if(StringUtil.isNotNull(preName)){
				label=preLabel+"."+label;
				name=preName+"."+name;
			}
			node.put("name", name);
			node.put("label",label);
			node.put("type", property.getType());
		}
		return node;
	}
	
	
	
	
	
	
}



