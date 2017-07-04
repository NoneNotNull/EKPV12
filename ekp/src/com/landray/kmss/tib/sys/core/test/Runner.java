package com.landray.kmss.tib.sys.core.test;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.code.create.hbmdict.Context;
import com.landray.kmss.code.create.hbmdict.HbmBag;
import com.landray.kmss.code.create.hbmdict.HbmClass;
import com.landray.kmss.code.create.hbmdict.HbmList;
import com.landray.kmss.code.create.hbmdict.HbmManyToOne;
import com.landray.kmss.code.create.hbmdict.HbmMapping;
import com.landray.kmss.code.create.hbmdict.HbmOneToOne;
import com.landray.kmss.code.create.hbmdict.HbmProperty;
import com.landray.kmss.code.create.hbmdict.HbmSubclass;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 数据字典生成 带 messageKey
 * @author 
 *
 */
public class Runner {
	private String hibernatePath = null;

	private String dictPath = null;

	public Runner(String modelPath) {
		String path = new File("src").getAbsolutePath();
		path = path.substring(0, path.length() - "src".length());
		hibernatePath = path + "src/com/landray/kmss/" + modelPath + "/model";
		dictPath = path + "WebContent/WEB-INF/KmssConfig/" + modelPath;
	}

	private static Map typeMap = new HashMap();

	static {
		typeMap.put("boolean", "Boolean");
		typeMap.put("int", "Integer");
		typeMap.put("integer", "Integer");
		typeMap.put("long", "Long");
		typeMap.put("double", "Double");
		typeMap.put("string", "String");
		typeMap.put("date", "DateTime");
		typeMap.put("clob", "RTF");
	}

	public void run() throws Exception {
		File dir = new File(dictPath + "/data-dict");
		if (!dir.exists())
			dir.mkdir();
		dir = new File(hibernatePath);
		String[] fileNames = dir.list();
		for (int i = 0; i < fileNames.length; i++) {
			if (!fileNames[i].endsWith(".hbm.xml"))
				continue;
			String fileName = fileNames[i].substring(0,
					fileNames[i].length() - 8)
					+ ".xml";
			HbmMapping mapping = HbmMapping.getInstance(hibernatePath + "/"
					+ fileNames[i]);
			outputOneMapping(mapping, fileName);
		}
	}

	private void outputOneMapping(HbmMapping mapping, String fileName)
			throws Exception {
		File file = new File(dictPath + "/data-dict/" + fileName);
		if (file.exists()) {
			System.out.println("文件" + dictPath + "/data-dict/" + fileName
					+ "已经存在，忽略该操作");
			return;
		}
		System.out.println("正在生成文件：" + dictPath + "/data-dict/" + fileName);
		file.createNewFile();
		BufferedWriter output = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(file), "UTF-8"));
		output.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		output
				.write("<models xmlns=\"http://www.example.org/design-config\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.example.org/design-config ../../../data-dict.xsd \">\r\n");
		List classes = mapping.getClasses();
		for (int i = 0; i < classes.size(); i++) {
			HbmClass hbmClass = (HbmClass) classes.get(i);
			outputOneClass(hbmClass, output, null);
			for (int j = 0; j < hbmClass.getSubclasses().size(); j++)
				outputOneClass((HbmClass) hbmClass.getSubclasses().get(j),
						output, hbmClass.getName());
		}
		output.write("</models>");
		output.close();
	}

	private void outputOneClass(HbmClass hbmClass, BufferedWriter output,
			String extendClass) throws Exception {
		Context context = new Context(hbmClass, output);
		output.write("<model\r\n");
		context.outputAttribute("modelName", hbmClass.getName());
		context.outputAttribute("messageKey", context.bundle + ":table."
				+ context.tableName, context.ENCODEATTVALUE);
		
		System.out.println( "table."
				+ context.tableName+"=");
		
		
		if (context.checkField("fdName"))
			context.outputAttribute("displayProperty", "fdName");
		if (context.checkField("fdHierarchyId"))
			context.outputAttribute("treeModel", "true");
		context.outputAttribute("serviceBean", ModelUtil
				.getModelTableName(hbmClass.getName())
				+ "Service");
		HbmSubclass subclass = null;
		if (hbmClass instanceof HbmSubclass) {
			subclass = (HbmSubclass) hbmClass;
			if (subclass.getJoin() != null)
				context.outputAttribute("table", subclass.getJoin().getTable());
			context.outputAttribute("extendClass",
					extendClass == null ? subclass.getExtendClass()
							: extendClass);
			context.outputAttribute("discriminatorValue", subclass
					.getDiscriminatorValue());
		} else {
			context.outputAttribute("table", hbmClass.getTable());
			output.write(">\r\n");
			output.write("<idProperty><generator\r\n");
			context.outputAttribute("type", hbmClass.getId().getGenerator()
					.getType());
			output.write("/></idProperty");
		}
		output.write(">\r\n");
		List properties = hbmClass.getProperties();
		for (int i = 0; i < properties.size(); i++) {
			Object property = properties.get(i);
			if (property instanceof HbmProperty) {
				outputSimpleProperty((HbmProperty) property, context);
			} else if (property instanceof HbmOneToOne) {
				outputOneToOneProperty((HbmOneToOne) property, context);
			} else if (property instanceof HbmManyToOne) {
				outputManyToOneProperty((HbmManyToOne) property, context);
			} else if (property instanceof HbmBag) {
				outputBagProperty((HbmBag) property, context);
			} else if (property instanceof HbmList) {
				outputBagProperty((HbmList) property, context);
			}
		}
		if (hbmClass instanceof HbmSubclass) {
			if (subclass.getJoin() != null) {
				properties = subclass.getJoin().getProperties();
				for (int i = 0; i < properties.size(); i++) {
					Object property = properties.get(i);
					if (property instanceof HbmProperty) {
						outputSimpleProperty((HbmProperty) property, context);
					} else if (property instanceof HbmOneToOne) {
						outputOneToOneProperty((HbmOneToOne) property, context);
					} else if (property instanceof HbmManyToOne) {
						outputManyToOneProperty((HbmManyToOne) property,
								context);
					} else if (property instanceof HbmBag) {
						outputBagProperty((HbmBag) property, context);
					} else if (property instanceof HbmList) {
						outputBagProperty((HbmList) property, context);
					}
				}
			}
		}
		output.write("</model>");
	}

	private void outputSimpleProperty(HbmProperty property, Context context)
			throws Exception {
		context.output.write("<simpleProperty\r\n");
		outputCommonAttribute(property.getName(), context);
		context.outputAttribute("type", getPropertyType(context, property
				.getName(), property.getType()), Context.OUTPUTEMPTYATT);
		context.outputAttribute("column", property.getColumn());
		context.outputAttribute("notNull", property.getNotNull());
		context.outputAttribute("unique", property.getUnique());
		context.outputAttribute("length", property.getLength());
		context.output.write("/>\r\n");
	}

	private void outputOneToOneProperty(HbmOneToOne property, Context context)
			throws Exception {
		context.output.write("<modelProperty\r\n");
		outputCommonAttribute(property.getName(), context);
		context.outputAttribute("type", getPropertyType(context, property
				.getName(), property.getType()), Context.OUTPUTEMPTYATT);
		context.outputAttribute("column", "fd_id");
		context.outputAttribute("notNull", "true");
		context.outputAttribute("unique", "true");
		context.outputAttribute("cascade", property.getCascade());
		context.outputAttribute("constrained", property.getConstrained());
		context.output.write("/>\r\n");
	}

	private void outputManyToOneProperty(HbmManyToOne property, Context context)
			throws Exception {
		context.output.write("<modelProperty\r\n");
		outputCommonAttribute(property.getName(), context);
		context.outputAttribute("type", getPropertyType(context, property
				.getName(), property.getType()), Context.OUTPUTEMPTYATT);
		context.outputAttribute("column", property.getColumn());
		context.outputAttribute("notNull", property.getNotNull());
		context.outputAttribute("unique", property.getUnique());
		context.outputAttribute("cascade", property.getCascade());
		context.output.write("/>\r\n");
	}

	private void outputBagProperty(HbmBag property, Context context)
			throws Exception {
		context.output.write("<listProperty\r\n");
		outputCommonAttribute(property.getName(), context);
		context.outputAttribute("column", property.getKey().getColumn());
		context.outputAttribute("notNull", property.getKey().getNotNull());
		context.outputAttribute("unique", property.getKey().getUnique());
		context.outputAttribute("orderBy", property.getOrderBy());
		if (property.getOneToMany() != null) {
			context.outputAttribute("type", property.getOneToMany().getType(),
					Context.OUTPUTEMPTYATT);
		} else {
			context.outputAttribute("type", property.getManyToMany().getType(),
					Context.OUTPUTEMPTYATT);
			context.outputAttribute("elementColumn", property.getManyToMany()
					.getColumn(), Context.OUTPUTEMPTYATT);
			if (property instanceof HbmList)
				context.outputAttribute("indexColumn", ((HbmList) property)
						.getIndex().getColumn());
		}
		context.outputAttribute("table", property.getTable());
		context.outputAttribute("cascade", property.getCascade());
		context.outputAttribute("inverse", property.getInverse());
		context.output.write("/>\r\n");
	}

	private String getPropertyType(Context context, String name, String type)
			throws Exception {
		if (StringUtil.isNull(type)) {
			type = ObjectUtil.getPropertyDescriptor(context.modelClass, name)
					.getPropertyType().getName();
		}
		if (type.equals("com.landray.kmss.common.dao.ClobStringType"))
			return "RTF";
		if (type.startsWith("com.landray.kmss."))
			return type;
		String shortType = type.toLowerCase();
		int i = type.lastIndexOf('.');
		if (i > -1)
			shortType = shortType.substring(i + 1);
		return (String) typeMap.get(shortType);
	}

	private void outputCommonAttribute(String propertyName, Context context)
			throws Exception {
		context.outputAttribute("name", propertyName);
		context.outputAttribute("messageKey", context.bundle + ":"
				+ context.tableName + "." + propertyName,
				Context.ENCODEATTVALUE);
		System.out.println( 
				 context.tableName + "." + propertyName+"=");
	}

	public static void main(String[] args) throws Exception {
//		new Runner("sys/category").run();
//		new Runner("sys/doc").run();
//		new Runner("sys/evaluation").run();
//		new Runner("sys/flow").run();
//		new Runner("sys/introduce").run();
//		new Runner("sys/log").run();
//		new Runner("sys/notify").run();
//		new Runner("sys/organization").run();
//		new Runner("sys/quartz").run();
//		new Runner("sys/readlog").run();
//		new Runner("sys/relation").run();
//		new Runner("sys/subscribe").run();
		
//		new Runner("tib/common/log").run();
		new Runner("tib/common/mapping").run();
		new Runner("tib/common/log").run();
		new Runner("tib/sys/sap/connector").run();
		new Runner("tib/sys/soap/connector").run();
		new Runner("tib/sap/sync").run();
	}
}
