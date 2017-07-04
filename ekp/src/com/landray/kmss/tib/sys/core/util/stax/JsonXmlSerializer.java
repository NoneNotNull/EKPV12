package com.landray.kmss.tib.sys.core.util.stax;

import java.util.Iterator;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class JsonXmlSerializer {

	public static void main(String[] args) throws Exception {
		JSONObject json = JSONObject
				.fromObject("{\"landray\":{\"landray1\":\"test2\",\"landray4\":{\"ok1\":\"okhh\" },\"landray9\":[{\"hk1\":\"hh2132\"},{\"hk2\":\"hhcda2132\"}]}}");
		StaxWriterUtil staxUtil = new StaxWriterUtil();
		staxUtil.init();
		staxUtil.startDocument();
		parseXml(json, staxUtil);
		staxUtil.endAllElement();
		staxUtil.endDocument();
		System.out.println(staxUtil.getStringWriter().toString());
	}

	public static void parseXml(JSONObject jsonInfo, StaxWriterUtil staxWriter)
			throws Exception {

		for (Iterator iterator = jsonInfo.keys(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Object result = (Object) jsonInfo.get(key);

			if (result instanceof JSONObject) {
				JSONObject n_json = (JSONObject) result;
				StaxElement st = new StaxElement(key, null, null);
				staxWriter.addElement(st);
				parseXml(n_json, staxWriter);
				staxWriter.endElement();
			} else if (result instanceof JSONArray) {
				JSONArray n_array = (JSONArray) result;
				StaxElement st = new StaxElement(key, null, null);
				staxWriter.addElement(st);
				for (Iterator n_it = n_array.iterator(); n_it.hasNext();) {
					JSONObject array_field = (JSONObject) n_it.next();
					parseXml(array_field, staxWriter);
				}
				staxWriter.endElement();
			} else {
				StaxElement st = new StaxElement(key, (String) result, null);
				staxWriter.addElement(st);
				staxWriter.endElement();
			}

		}

	}

}
