package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;

import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

/**
 * @author zhangtian
 * 提供数据绑定工具,通过对象转换成xml <br>
 * 通过xml转换成对象
 * 
 */
public class JAXBUtil {
	
	/**
	 * 通过   xml reader 转换成 bean
	 * @param reader StringReader 
	 * @param clazz 转换的bean class
	 * @return 对应class 的bean
	 */
    @SuppressWarnings("unchecked")
	public static <T> T unmarshal(StringReader reader,Class<T> clazz){  
        try{  
            JAXBContext jc = JAXBContext.newInstance(clazz);  
            Unmarshaller u = jc.createUnmarshaller();  
			T Object =  (T)u.unmarshal(reader); 
            return Object;  
        }catch(Exception e){  
            throw new RuntimeException(e);  
        }  
    } 
    
    /**
     * 通过xml 流转换成bean
     * @param is xml 流
     * @param clazz 转换的bean class
	 * @return 对应class 的bean
     */
    @SuppressWarnings("unchecked")
	public static <T> T unmarshal(InputStream is,Class<T> clazz){  
        try{  
            JAXBContext jc = JAXBContext.newInstance(clazz);  
            Unmarshaller u = jc.createUnmarshaller();  
            T Object =  (T)u.unmarshal(is); 
            return Object;  
        }catch(Exception e){  
            //throw new RuntimeException(e);  
        	System.out.println("xml 转 对象失败 ");
        	e.printStackTrace();
        	return null;
        }  
    }
      
    /**
     * 对象转xml  
     * @param obj 对象
     * @param clazz 转换的bean class
     * @return StringWriter sr
     */
	@SuppressWarnings("unchecked")
	public static StringWriter marshaller(Object obj,Class clazz){  
        try{  
              JAXBContext jc = JAXBContext.newInstance(clazz);  
              //用于输出元素  
          Marshaller marshaller = jc.createMarshaller();  
          marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
          marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);  
          StringWriter strWriter=new StringWriter();
          marshaller.marshal(obj, strWriter);  
          return strWriter;
        }catch(Exception e){  
        	System.out.println("xml 转 对象失败 ");
        	e.printStackTrace();
        	return null;
        }  
    }
	
	public static void main(String[] args) {
	InputStream is=JAXBUtil.class.getResourceAsStream("/com/landray/kmss/third/erp/tibSysSap/util/xmlbind/temp.xml");
	//xml 转对象
	Jco jcoModel=JAXBUtil.unmarshal(is, Jco.class);
	System.out.println(jcoModel.toString());
	
//	对象转xml
	Table tb=new Table();
	tb.setName("我的表格");
	jcoModel.getTables().add(tb);
	
	StringWriter sw=JAXBUtil.marshaller(jcoModel, Jco.class);
	System.out.println("==============");
	System.out.println(sw.toString());
		
	}
}  

