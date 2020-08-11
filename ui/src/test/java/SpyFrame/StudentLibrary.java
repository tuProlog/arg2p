package SpyFrame;
// franz.beslmeisl at googlemail.com

import alice.tuprolog.Library;
import alice.tuprolog.Term;
import alice.tuprologx.spyframe.TermFrame;

// import in a prolog session by
// :-load_library('StudentLibrary').
public class StudentLibrary extends Library {
    public boolean termframe_1(Term term) {
        new TermFrame(term);
        return true;
    }
}
