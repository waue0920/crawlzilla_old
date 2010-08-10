package org.nchc.crawlzilla;

import java.io.File;
import java.io.IOException;

public class NutchDBSearchDefaultLinkBean {
	private String searchLinkFileName=null;
	
	// set
	public void setSearchLinkFile(String searchPath) throws IOException{
		File searchFile = new File(searchPath);
		if (searchFile.exists()){
			String searchLink = searchFile.getCanonicalPath();
			File searchLinkFile = new File(searchLink);
			searchLinkFileName = searchLinkFile.getName();
		}
	} 
	
	public String getSearchLinkFile(){
		return searchLinkFileName;
	}
		
	
}
