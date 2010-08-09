package org.nchc.nutchez;
/**
 * LoginBean 用以比對用戶密碼，以及設定密碼
 * 
 * 
 * @web
 * <a href="http://code.google.com/p/nutchez/">http://code.google.com/p/nutchez </a>
 * 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 * 
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LoginBean {
	private String passWord;
	private boolean ChangePasswdFlag = false;

	public boolean getConfirm() throws IOException {
		FileReader NP = new FileReader("/home/nutchuser/nutchez/system/.passwd");
		BufferedReader stdin = new BufferedReader(NP);
		String nutchuserPasswd = new String(stdin.readLine());
		if (nutchuserPasswd.equals(passWord)
				&& nutchuserPasswd.equals("nutchuser")) {
			ChangePasswdFlag = true;
		}

		if (nutchuserPasswd.equals(passWord)) {
			NP.close();
			return true;
		} else {
			NP.close();
			return false;
		}		
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setChangePasswdFlag(boolean ChangePasswdFlag) {
		this.ChangePasswdFlag = ChangePasswdFlag;
	}

	public boolean getChangePasswdFlag() {
		return ChangePasswdFlag;
	}
}
