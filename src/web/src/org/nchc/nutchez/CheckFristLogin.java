package org.nchc.nutchez;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class CheckFristLogin {
	private boolean ChangePasswdFlag = false;
	public boolean fristLogin() throws IOException{
		FileReader NP = new FileReader("/home/nutchuser/nutchez/system/.passwd");
		BufferedReader stdin = new BufferedReader(NP);
		String nutchuserPasswd = new String(stdin.readLine());
		if (nutchuserPasswd.equals("nutchuser")
				&& nutchuserPasswd.equals("nutchuser")) {
			ChangePasswdFlag = true;
		}

		return ChangePasswdFlag;	
	}
}
