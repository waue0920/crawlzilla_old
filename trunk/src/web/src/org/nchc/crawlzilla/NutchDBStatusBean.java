package org.nchc.crawlzilla;

import java.io.File;

public class NutchDBStatusBean {
	private File files[];
	
	public void setFiles(String path){
		File filePath = new File(path); 
		files = filePath.listFiles();
	}
	
	public File[] getFiles(){
		return files;
	}
}
