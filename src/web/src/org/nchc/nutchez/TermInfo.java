package org.nchc.nutchez;
/**
 * 被 IndexInfo 引用
 * 
 * @web
 * <a href="http://code.google.com/p/nutchez/">http://code.google.com/p/nutchez </a>
 * 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 * 
 */
import org.apache.lucene.index.Term;

public class TermInfo {
  public Term term;
  public int docFreq;
  
  public TermInfo(Term t, int df) {
    this.term = t;
    this.docFreq = df;
  }

}
