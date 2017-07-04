package com.landray.kmss.tib.sys.k3.connector.interfaces.impl;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.tools.ant.taskdefs.Zip;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataService;
import com.landray.kmss.tib.common.inoutdata.util.TibCommonInoutdataFileUtil;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.k3.connector.interfaces.ITibSysK3InitExecute;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettCategoryService;
import com.landray.kmss.tib.sys.soap.connector.util.init.TibSysSoapInitExecuteUtil;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class TibSysK3InitExecute implements ITibSysK3InitExecute {
	private ITibCommonInoutdataService tibCommonInoutdataService;
	
	public void setTibCommonInoutdataService(
			ITibCommonInoutdataService tibCommonInoutdataService) {
		this.tibCommonInoutdataService = tibCommonInoutdataService;
	}

	private  Map categoryMap = new HashMap();
	private  Map relationMap = new HashMap();
	
	
	public String testConn(HttpServletRequest request) {
		String message = "";
		String soapVersion = "SOAP 1.1";
		String bindFunc = "GetAisType";
		Map<String, String> map = new HashMap<String, String>();
		String k3DnsIp = request.getParameter("k3DnsIp").trim();
		String k3Port = request.getParameter("k3Port").trim();
		String k3IAisID = request.getParameter("k3IAisID").trim();
		String k3UserName = request.getParameter("k3UserName").trim();
		String k3Password = request.getParameter("k3Password").trim();
		map.put("pub:iAisID", k3IAisID);
		map.put("pub:strUser", k3UserName);
		map.put("pub:strPassword", k3Password);
		JSONObject jsonObject = new JSONObject();
		jsonObject.accumulate("k3DnsIp", k3DnsIp);
		jsonObject.accumulate("k3Port", k3Port);
		jsonObject.accumulate("k3IAisID", k3IAisID);
		jsonObject.accumulate("k3UserName", k3UserName);
		jsonObject.accumulate("k3Password", k3Password);
		request.setAttribute("k3BackJson", jsonObject.toString().replace("\"", "'"));
		// 设置服务注册信息
		TibSysSoapSetting soapuiSett = new TibSysSoapSetting();
		soapuiSett.setFdId("id_"+ k3DnsIp +"_"+ k3Port);
		soapuiSett.setFdWsdlUrl("http://"+ k3DnsIp +":"+ k3Port +"/KDWEBSERVICE/Public.asmx?WSDL");
		soapuiSett.setFdOverTime("3000");
		soapuiSett.setFdResponseTime("3000");
		soapuiSett.setFdCheck(false);
		soapuiSett.setFdProtectWsdl(false);
		try {
			Document responseDoc = TibSysSoapInitExecuteUtil.getResponseDocByInit(soapuiSett, 
					bindFunc, soapVersion, map);
			// 判断是否有错误信息返回，没有错误字符串则为空
			String faultInfo = ParseSoapXmlUtil.isFaultInfo(responseDoc);
			if (StringUtil.isNull(faultInfo)) {
				Element bodyEle = ParseSoapXmlUtil.selectElement("//Envelope/Body", responseDoc).get(0);
				NodeList nodeList = bodyEle.getElementsByTagName("GetAisTypeResult");
				Node node = nodeList.item(0);
				String sessionId = node.getTextContent();
				if (StringUtil.isNull(sessionId)) {
					// sessionId无法返回
					message += ResourceUtil.getString("initK3.GetAisTypeResult", "tib-sys-soap-connector");
				}
			} else {
				// 返回错误信息
				message += faultInfo;
			}
		} catch (Exception e) {
			message += e.toString();
			e.printStackTrace();
		}
		return message;
	}

	public void importInitJar(HttpServletRequest request) throws Exception {
		Map map = new HashMap();
		map.put("dnsIp", request.getParameter("k3DnsIp").trim());
		map.put("port", request.getParameter("k3Port").trim());
		map.put("k3IAisID", request.getParameter("k3IAisID").trim());
		map.put("k3UserName", request.getParameter("k3UserName").trim());
		map.put("k3Password", request.getParameter("k3Password").trim());
		JSONObject jsonObject =  JSONObject.fromObject(map);
		request.setAttribute("k3BackJson", jsonObject.toString().replace("\"", "'"));
		unZip(ZIPFILE, DESTPATH, UPDATE_FILE, map);
	}

	//解压模板文件
	private void unZip(String zipSourcePath, String destpath, String updateFile,
			Map map) throws Exception {
		Set<String> filePathSet = new HashSet<String>();
		ZipFile zipFile = new ZipFile(zipSourcePath);
		Enumeration enumeration =zipFile.getEntries();
		ZipEntry entry = null;
		InputStream inputStream=null;
		//先检查原有目录
		File destFile = new File(destpath);
		if(destFile.exists()){
			TibCommonInoutdataFileUtil.deleteDir(destFile);
		}
		byte[] buffer = new byte[8192];
		String entryName;
		File file=null;
		int length;
		BufferedOutputStream  bufferedOutputStream=null;
	  try{
		while(enumeration.hasMoreElements()){
			entry =(ZipEntry)enumeration.nextElement();
			if(entry.isDirectory()){
				continue;
			}
			
			inputStream=zipFile.getInputStream(entry);
		    entryName =entry.getName();
			file = new File(destpath,entryName);
			//判断父目录是否存在，不存在建立父目录
			if(!file.getParentFile().exists()){
				//建立父目录
				file.getParentFile().mkdirs();
			}
			
			bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(file));
            try{
			  while (true) {
					length = inputStream.read(buffer);
					if (length == -1)
						break;
					bufferedOutputStream.write(buffer, 0, length);
				}
			  }finally{
				  bufferedOutputStream.close();
				  inputStream.close();
			}
			
		      //选择修改文件
			 String fileNewName= updataXmlFile(file, map);
			 int lastIndex =entryName.lastIndexOf("/");
			     fileNewName =entryName.substring(0, lastIndex)+"/"+fileNewName;
			 // 设置文件路径信息
			 setFilePath(entryName, filePathSet);
		}
	  }finally{
		  categoryMap.clear();
		  relationMap.clear();
		  zipFile.close();
	  }
		// 把文件路径存放的Set转为Array
		String[] filePathArr = new String[filePathSet.size()];
		filePathArr = filePathSet.toArray(filePathArr);
		String pathPrefex = DESTPATH +"/WEB-INF/KmssConfig";
		// 导入标准数据包
		tibCommonInoutdataService.startImport(null, filePathArr, false, true, pathPrefex);
	}

	private String updataXmlFile(File file, Map<String,String> map)throws Exception {
		XMLDecoder xmlIn = null;
		XMLEncoder xmlOut = null;
		String newFileName="";
		if (file.getName().endsWith(".xml")) {
			try {
				String[] infor = file.getName().split("_");
				Map<String, Object> data = new HashMap();
				xmlIn = new XMLDecoder(new FileInputStream(file));
				if ("TibSysSoapSetting.xml".equals(infor[1])) {
					// 获取到xml中的所有内容
					data = (Map<String, Object>) xmlIn.readObject();         
					String fdWsdlUrl = (String) data.get("fdWsdlUrl");
					String extendInfoXml = (String) data.get("extendInfoXml");
					
					//将extendInfoXml字符串转换成Document
					Document document=null;
					if(StringUtils.isNotEmpty(extendInfoXml)){
						document= DOMHelper.parseXmlString(extendInfoXml);       
						document =setDocumentValue(document,map);
						
						//设置document节点中的相应值
						extendInfoXml =DOMHelper.nodeToString(document);  
						data.put("extendInfoXml", extendInfoXml);
					}
					
					String fdWsdUrlPrex = "";
					fdWsdUrlPrex =map.get("dnsIp");
					fdWsdUrlPrex +=":"+map.get("port");
					
					 //修改ip与port
					fdWsdlUrl =replaceFiled(fdWsdlUrl,fdWsdUrlPrex);     
					data.put("fdWsdlUrl", fdWsdlUrl);
					
					//生成新的fdId (这里主要是TibSysSoapMain含有TibSysSoapSetting对象)
					String fdId = (String) data.get("fdId");
					String newId =(String) relationMap.get(fdId);
					if(StringUtils.isEmpty(newId)){
						newId=IDGenerator.generateID();
						relationMap.put(fdId, newId);
					}
					data.put("fdId", newId); 
					
					 //修改该xml中的目录ID
					modifyCategoryId(data,"settCategory");                              
					
				}else if("TibSysSoapMain.xml".equals(infor[1])){
				     // 获取到xml中的所有内容
					data = (Map<String, Object>) xmlIn.readObject();     
					//修改模板中的soap服务路径
					String wsMapperTemplate=(String)data.get("wsMapperTemplate");
					Document document = DOMHelper.parseXmlString(wsMapperTemplate);
					NodeList nodeList = DOMHelper.selectNode("//Output/Envelope", document);
					if(nodeList!=null && nodeList.getLength()>0){
						Node node =nodeList.item(0);
						Node currentNode =node.getAttributes().getNamedItem("xmlns:wsg");
						if(currentNode!=null){
							
							String wsdlUrl =currentNode.getNodeValue();
							String ip = map.get("dnsIp");
							String port = map.get("port");
							String newURL=ip+":"+port;
							//修改 wsMapperTemplate 中的ip
							wsdlUrl =replaceFiled(wsdlUrl,newURL);            
							currentNode.setNodeValue(wsdlUrl);
							data.put("wsMapperTemplate", DOMHelper.nodeToString(document));
						}
					}
					//生成新的fdId
					data.put("fdId", IDGenerator.generateID());
					
					//修改该xml中的目录ID
					modifyCategoryId(data,"docCategory");                             
						
					//修改关联tibSysSoapSetting的ID
					modifyRelationId(data,"tibSysSoapSetting");
					
				}else if(infor[1].contains("Category.xml")){
					data = (Map<String, Object>) xmlIn.readObject(); 
					String fdId =(String) data.get("fdId");
					//对目录xml的修改
					String newCategoryId = (String) categoryMap.get(fdId);  
					if(StringUtils.isEmpty(newCategoryId)){
						newCategoryId = IDGenerator.generateID();  
						categoryMap.put(fdId, newCategoryId);
					}
					data.put("fdId", newCategoryId);
					
					//修改对应的hbmParent
			        Map parentMap = (Map) data.get("hbmParent");
					if(parentMap!=null){
						  String oldParentId = (String) parentMap.get("fdId");
					  if(StringUtils.isNotEmpty(oldParentId)){
						  String newParentId =(String) categoryMap.get(oldParentId);
						if(StringUtils.isEmpty(newParentId)){
							newParentId =IDGenerator.generateID();
							categoryMap.put(oldParentId, newParentId);
						}
						  parentMap.put("fdId", newParentId);
					  }
					}
					
					//修改目录名称
					String className = infor[1].substring(0, infor[1].length()-4);
					String categoryName=null;
					if("TibSysSoapSettCategory".equals(className)){
						categoryName=modifyTibSysSoapSettCategoryName(K3_NAME);
					}else if("TibSysSoapCategory".equals(className)){
						categoryName=modifyTibSysSoapCategoryName(K3_NAME);
					}
					data.put("fdName", categoryName);
					//修改层级fdHierarchyId
					String newHierarchyId =modifyCategoryHierarchyId(data);
					data.put("fdHierarchyId", newHierarchyId);
					
				}
				
				//设置创建人员
				Map creatorMap =(Map) data.get("docCreator");
				if(creatorMap!=null){
					String craterId = (String) creatorMap.get("fdId");
					boolean flag =UserUtil.checkUserId(craterId);
					if(!flag){
						creatorMap.put("fdId", UserUtil.getUser().getFdId());
					}
				}
				
				//修改文件的名称
				newFileName =(String) data.get("fdId");
				newFileName+="_"+infor[1];
				File newFile = new File(file.getParent(),newFileName);
				
				//将修改后的内容输出到xml文件中
				xmlOut =new XMLEncoder(new BufferedOutputStream(new FileOutputStream(newFile)));
				xmlOut.writeObject(data);
				//删除修改前的文件
				if(file.exists()){
					file.delete();
				}
				
			}finally {
				if (xmlIn != null) {
					xmlIn.close();
					xmlOut.close();
				}
			}
		}
	    return newFileName;
	}

	
	//修改目录的层级HierarchyId
	private String modifyCategoryHierarchyId(Map data){
		Map hbmParentMap = (Map) data.get("hbmParent");
		String hierarchyId = (String) data.get("fdHierarchyId");
		String newHierarchyId="x";
		if(StringUtils.isNotEmpty(hierarchyId)){
			//去掉前后x符号
			hierarchyId= hierarchyId.substring(1, hierarchyId.length()-1);
			String newId="";
			if(hbmParentMap!=null){
				 String []hierarchyIdArr = hierarchyId.split("x");
				 for(String oldId:hierarchyIdArr){
					 newId=(String) categoryMap.get(oldId);
					 newHierarchyId+=newId+"x";
				 }
			}else{
				newId =(String) categoryMap.get(hierarchyId);
				newHierarchyId+=newId+"x";
			}
		}
		return newHierarchyId;
	}
	
	//修改对象间的关联id
	private void modifyRelationId(Map data,String relationName){
		Map<String, String> relationFiledMap = (HashMap<String, String>) data.get(relationName);
		String oldRelationId = (String) relationFiledMap.get("fdId");
		String newRelationId = (String) relationMap.get(oldRelationId);
		if (StringUtils.isEmpty(newRelationId)) {
			newRelationId = IDGenerator.generateID();
			relationMap.put(oldRelationId, newRelationId);
		}
		relationFiledMap.put("fdId", newRelationId);
	}
	
	//修改TibSysSoapSettCategory目录名称
	private String modifyTibSysSoapSettCategoryName(String categoryName) throws Exception{
		ITibSysSoapSettCategoryService tibSysSoapSettCategoryService = (ITibSysSoapSettCategoryService) SpringBeanUtil
		.getBean("tibSysSoapSettCategoryService");
		
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysSoapSettCategory.fdName like :fdName");
		//以该目录开头的
		hqlInfo.setParameter("fdName", categoryName+"%");
		hqlInfo.setOrderBy("tibSysSoapSettCategory.fdName desc");
		List<TibSysSoapSettCategory> result;
		result = tibSysSoapSettCategoryService.findList(hqlInfo);
		if (result != null && result.size() > 0) {
			int maxIndex=0;
			String preString = "";
			String numString = "";
			for(TibSysSoapSettCategory tibSysSoapSettCategory :result){
				categoryName = tibSysSoapSettCategory.getFdName();
				int startIndex = categoryName.indexOf("(");
				int endIndex = categoryName.indexOf(")");
				int num = 0;
				if (startIndex > 0 && endIndex > 0) {
					try {
						preString = categoryName.substring(0, startIndex) + "(";
						numString = categoryName.substring(startIndex + 1, endIndex);
						num = Integer.parseInt(numString);
						if(num>=maxIndex){
						    maxIndex =num + 1;
						}
					} catch (NumberFormatException exception) {
						continue;
					}
				}else{
					if(maxIndex==0){
					    maxIndex=1;
					}
					preString=K3_NAME+"(";
				}
			}
			categoryName = preString + maxIndex + ")";
		}
		return categoryName;
	}

	
	//修改TibSysSoapCategory目录名称
	private String modifyTibSysSoapCategoryName(String categoryName) throws Exception{
		ITibSysSoapCategoryService tibSysSoapCategoryService = (ITibSysSoapCategoryService) SpringBeanUtil
		.getBean("tibSysSoapCategoryService");
		
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysSoapCategory.fdName like :fdName");
		//以该目录开头的
		hqlInfo.setParameter("fdName", categoryName+"%");
		hqlInfo.setOrderBy("tibSysSoapCategory.fdName desc");
		List<TibSysSoapCategory> result;
		result = tibSysSoapCategoryService.findList(hqlInfo);
		if (result != null && result.size() > 0) {
			int maxIndex=0;
			String preString = "";
			String numString = "";
			for(TibSysSoapCategory tibSysSoapCategory :result){
				categoryName = tibSysSoapCategory.getFdName();
				int startIndex = categoryName.indexOf("(");
				int endIndex = categoryName.indexOf(")");
				int num = 0;
				if (startIndex > 0 && endIndex > 0) {
					try {
						preString = categoryName.substring(0, startIndex) + "(";
						numString = categoryName.substring(startIndex + 1, endIndex);
						num = Integer.parseInt(numString);
						if(num>=maxIndex){
						    maxIndex =num + 1;
						}
					} catch (NumberFormatException exception) {
						continue;
					}
				}else{
					if(maxIndex==0){
					    maxIndex=1;
					}
					preString=K3_NAME+"(";
				}
			}
			categoryName = preString + maxIndex + ")";
		}
		return categoryName;
	}
	
	//修改xml文件中的目录ID
	private void modifyCategoryId(Map data,String categoryName){
		Map<String, String> categoryInforMap = (HashMap<String, String>) data.get(categoryName);
		String oldCategoryId = (String) categoryInforMap.get("fdId");
		String newCategoryId = (String) categoryMap.get(oldCategoryId);
		if (StringUtils.isEmpty(newCategoryId)) {
			newCategoryId = IDGenerator.generateID();
			categoryMap.put(oldCategoryId, newCategoryId);
		}
		categoryInforMap.put("fdId", newCategoryId);
	}
	 
	 //设置document中对应参数的新值
	private Document setDocumentValue(Document doc, Map map) {
		NodeList r1 = doc.getElementsByTagName("void");
		String key = "";
		String value = "";
		if (r1 != null && r1.getLength() > 0) {
			for (int i = 0; i < r1.getLength(); i++) {
				Node node = r1.item(i);
				NodeList childList = node.getChildNodes();
				if (childList != null && childList.getLength() > 0) {
					// nodeType=1表示元素节点
					key = childList.item(1).getTextContent();
					value = (String) map.get(key);
					childList.item(3).setTextContent(value);
				}
			}
		}
		return doc;
	}
	 
	 //修改fdWsdlUrl中的IP和port
	 private String replaceFiled(String fdWsdlUrl,String newValue){
		 String []arr= fdWsdlUrl.split("/");
		 arr[2]=newValue;
		 String value="";
		  for(int i=0;i<arr.length;i++){
			  if(i==0){
				  value+=arr[i];
			  }else if(i==1){
				  value+=arr[i]+"//";
			  }else{
				  value+=arr[i]+"/";
			  }
		 }
		  return value.substring(0, value.length()-1);
	 }
	 
	 
	/**
	 * 把文件路径信息写入HashSet，导入数据前准备
	 * @param entryName
	 * @param filePathSet
	 */
	private void setFilePath(String entryName, Set<String> filePathSet) {
		int start = entryName.indexOf("/KmssConfig/") + "/KmssConfig/".length();
		int end = entryName.indexOf("/initdata/");
		String filePack = entryName.substring(start, end);
		String packageName = filePack.replaceAll("/", ".");
		// 不能超过3个包路径限制
		String[] packageArr = filePack.split("/");
		String filePackage = "/";
		if (packageArr != null) {
			for (int i = 0, len = packageArr.length; i < len; i++) {
				if (i >= 3) {
					break;
				}
				filePackage += packageArr[i] +"/";
			}
		} else {
			filePackage += filePack +"/";
		}
		// 类名
		String objName = entryName.substring(entryName.indexOf("_") + 1, entryName.length() - 4); 
		String filePath = filePackage +"_com.landray.kmss."+ packageName +".model."+ objName;
		filePathSet.add(filePath);
	}
	
}
