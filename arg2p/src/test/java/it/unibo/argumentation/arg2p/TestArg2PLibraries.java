package it.unibo.argumentation.arg2p;

import alice.tuprolog.Theory;
import org.junit.Test;

public class TestArg2PLibraries {

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

    @Test
    public void libRuleTranslatorIsParsedCorrectly() {
        Theory.parseWithStandardOperators(new RuleTranslator().getTheory());
    }
}
