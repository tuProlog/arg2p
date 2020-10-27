package it.unibo.argumentation.arg2p;

import alice.tuprolog.Library;
import alice.tuprolog.Prolog;
import alice.util.Tools;

import java.io.IOException;

public class Arg2PLibrary extends Library {

    private final String theoryFileName;

    public Arg2PLibrary(String theoryFileName) {
        this.theoryFileName = theoryFileName;
    }

    @Override
    public String getName() {
        return getClass().getName();
    }

    @Override
    public String getTheory() {
        try {
            return Tools.loadText(
                    Arg2PLibrary.class.getResourceAsStream(theoryFileName + ".pl")
            );
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public static void loadDeonLiteOnPrologEngine(Prolog engine) {
        engine.loadLibrary(Utils.class.getName());
        engine.loadLibrary(Debug.class.getName());
        engine.loadLibrary(ArgumentationGraph.class.getName());
        engine.loadLibrary(GroundedStrictPreferencesLabelling.class.getName());
        engine.loadLibrary(GroundedDefeasiblePreferencesLabelling.class.getName());
        engine.loadLibrary(CompleteStrictPreferencesLabelling.class.getName());
        engine.loadLibrary(ArgumentBPLabelling.class.getName());
        engine.loadLibrary(StatementLabelling.class.getName());
        engine.loadLibrary(ArgumentationEngineInterface.class.getName());
        engine.loadLibrary(RuleTranslator.class.getName());
        engine.loadLibrary(ModuleCall.class.getName());
        engine.loadLibrary(AbstractMode.class.getName());
        engine.loadLibrary(QueryMode.class.getName());
    }
}
