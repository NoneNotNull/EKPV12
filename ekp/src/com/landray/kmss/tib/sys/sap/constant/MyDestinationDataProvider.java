package com.landray.kmss.tib.sys.sap.constant;

import java.util.HashMap;
import java.util.Properties;

import com.sap.conn.jco.ext.DestinationDataEventListener;
import com.sap.conn.jco.ext.DestinationDataProvider;



public class MyDestinationDataProvider implements DestinationDataProvider {
	private DestinationDataEventListener eL;

	private HashMap<String, Properties> destinations;

	private static MyDestinationDataProvider provider = new MyDestinationDataProvider();

	private MyDestinationDataProvider() {
			destinations = new HashMap();
	}

	// Static method to retrieve instance
	public static MyDestinationDataProvider getInstance() {

		if(provider==null){
			provider =new MyDestinationDataProvider();
		}
		return provider;
	}

	public Properties getDestinationProperties(String destinationName) {
		if (destinations.containsKey(destinationName)) {
			return destinations.get(destinationName);
		} else {
			throw new RuntimeException("Destination " + destinationName
					+ " is not available");
		}
	}

	public void setDestinationDataEventListener(
			DestinationDataEventListener eventListener) {
		this.eL = eventListener;
	}

	public boolean supportsEvents() {
		return true;
	}

	/**
	 * Add new destination
	 * 
	 * @param properties
	 *            holds all the required data for a destination
	 */
	public void addDestination(String destinationName, Properties properties) {
		synchronized (destinations) {
			destinations.put(destinationName, properties);
		}
	}
}
