package org.nchc.crawlzilla;
/**
 * Statistics <-- DataInfoBean <- IndexInfo <- this
 * 程式碼引用自 luck & lucene
 * 
 * @web
 * <a href="http://code.google.com/p/crawlzilla/">http://code.google.com/p/crawlzilla </a>
 * 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 * 
 */
public class ProgressNotification {
  public int curValue = 0;
  public int minValue = 0;
  public int maxValue = 0;
  public boolean aborted = false;
  public String message = null;
}
