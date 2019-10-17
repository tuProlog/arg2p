package it.unibo.argumentation.deonlite;

import alice.tuprolog.Library;
import alice.tuprolog.Prolog;
import alice.util.Tools;

import java.io.File;
import java.io.IOException;

public class DeonLite2PLibrary extends Library {

    private final String theoryFileName;

    public DeonLite2PLibrary(String theoryFileName) {
        this.theoryFileName = theoryFileName;
        final File f = new File(DeonLite2PLibrary.class.getResource(theoryFileName + ".pl").getFile());
        if (!f.exists()) {
            throw new IllegalArgumentException(String.format("File %s does not exist.", f.getAbsoluteFile()));
        }
    }

    @Override
    public String getName() {
        return getClass().getName();
    }

    @Override
    public String getTheory() {
        try {
            return Tools.loadText(
                    DeonLite2PLibrary.class.getResourceAsStream(theoryFileName + ".pl")
            );
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public static void loadDeonLiteOnPrologEngine(Prolog engine) {
        engine.loadLibrary(Utils.class.getName());
        engine.loadLibrary(Debug.class.getName());
        engine.loadLibrary(ArgumentationGraph.class.getName());
        engine.loadLibrary(ArgumentLabelling.class.getName());
        engine.loadLibrary(StatementLabelling.class.getName());
        engine.loadLibrary(ArgumentationEngineInterface.class.getName());
    }
}
