package it.unibo.argumentation.deonlite;

import alice.tuprolog.Library;
import alice.util.Tools;

import java.io.File;
import java.io.IOException;

public class AbstractDeonLite2PLibrary extends Library {

    private final String theoryFileName;

    public AbstractDeonLite2PLibrary(String theoryFileName) {
        this.theoryFileName = theoryFileName;
        final File f = new File(getClass().getResource(theoryFileName + ".pl").getFile());
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
                    AbstractDeonLite2PLibrary.class.getResourceAsStream(theoryFileName + ".pl")
            );
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }
}
