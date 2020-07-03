package it.unibo.argumentation.arg2p;

import alice.tuprolog.*;
import alice.tuprolog.exceptions.NoSolutionException;

import java.io.File;
import java.io.IOException;
import java.util.Optional;

public class ModuleCall extends Arg2PLibrary {
    public ModuleCall() {
        super("moduleCall");
    }

    /**
     * spawns a separate prolog agent providing it a theory text and a goal
     *
     * @throws PrologError
     */
    public boolean arg_agent_2(Term th, Term g) throws PrologError {
        
        th = th.getTerm();
        g = g.getTerm();

        if (th instanceof Var) {
            throw PrologError.instantiation_error(getEngine().getEngineManager(), 1);
        }
        if (g instanceof Var) {
            throw PrologError.instantiation_error(getEngine().getEngineManager(), 2);
        }
        if (!(th.isAtom())) {
            throw PrologError.type_error(getEngine().getEngineManager(), 1, "atom", th);
        }
        if (!(g instanceof Struct)) {
            throw PrologError.type_error(getEngine().getEngineManager(), 2, "struct", g);
        }

        Struct theory = (Struct) th;
        Struct goal = (Struct) g;

        try {
            Prolog engine = prepareCleanEngine(theory);
            SolveInfo solve = engine.solve(goal.toString() + ".");
            if (solve.isSuccess()) return unify(g, solve.getSolution());
            return false;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }

    }

    private Prolog prepareCleanEngine(Struct theory) {
        Prolog engine = new Prolog();
        Arg2PLibrary.loadDeonLiteOnPrologEngine(engine);

        Theory t = Theory.parseWithOperators(alice.util.Tools.removeApices(theory.toString()),
                engine.getOperatorManager());

        engine.setTheory(getEnvTheory());
        engine.addTheory(t);

        return engine;
    }

    private Theory getEnvTheory() {
        
        final Optional<Term> modulesPath = getEngine().getTheory()
                .getClauses().stream()
                .filter(x -> x.match(getEngine().termSolve("modulesPath(X)")))
                .findAny();

        return modulesPath
                .map(term -> Theory.of(term.copy()))
                .orElseGet(Theory::empty);
    }
}