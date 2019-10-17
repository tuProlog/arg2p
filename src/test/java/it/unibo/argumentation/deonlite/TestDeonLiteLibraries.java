package it.unibo.argumentation.deonlite;

import alice.tuprolog.Theory;
import org.junit.Test;

public class TestDeonLiteLibraries {

    @Test
    public void libUtilsIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new Utils().getTheory());
    }

    @Test
    public void libStatementLabellingIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new StatementLabelling().getTheory());
    }

    @Test
    public void libDebugIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new Debug().getTheory());
    }

    @Test
    public void libArgumentLabellingIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new ArgumentLabelling().getTheory());
    }

    @Test
    public void libArgumentationGraphIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new ArgumentationGraph().getTheory());
    }

    @Test
    public void libArgumentationEngineInterfaceIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new ArgumentationEngineInterface().getTheory());
    }
}
