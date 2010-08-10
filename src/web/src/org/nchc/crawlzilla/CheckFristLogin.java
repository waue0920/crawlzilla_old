package org.nchc.crawlzilla;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class CheckFristLogin {
	private boolean ChangePasswdFlag = false;
	public boolean fristLogin() throws IOException{
		FileReader NP = new FileReader("/home/crawler/crawlzilla/system/.passwd");
		BufferedReader stdin = new BufferedReader(NP);
		String nutchuserPasswd = new String(stdin.readLine());
		if (nutchuserPasswd.equals("crawler")
				&& nutchuserPasswd.equals("crawler")) {
			ChangePasswdFlag = true;
		}

		return ChangePasswdFlag;	
	}
}
