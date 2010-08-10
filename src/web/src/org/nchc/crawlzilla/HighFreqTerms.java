package org.nchc.crawlzilla;

/**
 * Statistics <-- DataInfoBean <- IndexInfo <- this
 * 程式碼引用自 luck & lucene
 * 
 * @web
 * <a href="http://code.google.com/p/nutchez/">http://code.google.com/p/nutchez </a>
 * 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 * 
 */

import java.util.Hashtable;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.TermEnum;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.PriorityQueue;

/**
 * <code>HighFreqTerms</code> class extracts terms and their frequencies out
 * of an existing Lucene index.
 *
 * @version $Id: HighFreqTerms.java,v 1.2 2003/11/08 10:55:40 Administrator Exp $
 */
public class HighFreqTerms {
    public static int defaultNumTerms = 100;
    
    public static void main(String[] args) throws Exception {
        Directory dir = FSDirectory.getDirectory(args[0]);
        TermInfo[] terms = getHighFreqTerms(IndexReader.open(dir), null, new String[]{"body"});
        for (int i = 0; i < terms.length; i++) {
            System.out.println(i + ".\t" + terms[i].term);
        }
    }
    
    public static TermInfo[] getHighFreqTerms(IndexReader ir, Hashtable junkWords, String[] fields) throws Exception {
        return getHighFreqTerms(ir, junkWords, defaultNumTerms, fields);
    }
    
    public static TermInfo[] getHighFreqTerms(IndexReader reader, Hashtable junkWords, int numTerms, String[] fields) throws Exception {
        if (reader == null || fields == null) return null;
        TermInfoQueue tiq = new TermInfoQueue(numTerms);
        TermEnum terms = reader.terms();
        
        int minFreq = 0;
        while (terms.next()) {
            String field = terms.term().field();
            if (fields != null && fields.length > 0) {
                boolean skip = true;
                for (int i = 0; i < fields.length; i++) {
                    if (field.equals(fields[i])) {
                        skip = false;
                        break;
                    }
                }
                if (skip) continue;
            }
            if (junkWords != null && junkWords.get(terms.term().text()) != null) continue;
            if (terms.docFreq() > minFreq) {
                tiq.put(new TermInfo(terms.term(), terms.docFreq()));
                if (tiq.size() >= numTerms) 		     // if tiq overfull
                {
                    tiq.pop();				     // remove lowest in tiq
                    minFreq = ((TermInfo)tiq.top()).docFreq; // reset minFreq
                }
            }
        }
        TermInfo[] res = new TermInfo[tiq.size()];
        for (int i = 0; i < res.length; i++) {
            res[res.length - i - 1] = (TermInfo)tiq.pop();
        }
        return res;
    }
}

final class TermInfoQueue extends PriorityQueue {
    TermInfoQueue(int size) {
        initialize(size);
    }
    protected final boolean lessThan(Object a, Object b) {
        TermInfo termInfoA = (TermInfo)a;
        TermInfo termInfoB = (TermInfo)b;
        return termInfoA.docFreq < termInfoB.docFreq;
    }
}
