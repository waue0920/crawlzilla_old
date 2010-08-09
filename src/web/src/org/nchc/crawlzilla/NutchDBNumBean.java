// Search numbers of nutch DB 
package org.nchc.nutchez;

import java.io.*;

public class NutchDBNumBean {
	
	private File files[];
	private int num;

	// set
	public void setFiles(String path) throws IOException{
		File filePath = new File(path); 
		files = filePath.listFiles();	
	}
	
	public void setNum(String path) throws IOException{
		File filePath = new File(path); 
		files = filePath.listFiles();	
		num = files.length;		
	}
	
	public NutchDBNumBean(){
		
	}
	
	// get
	public int getNum(){
		return num;
	}
	
	public File[] getFiles(){
		return files;
	}
}
