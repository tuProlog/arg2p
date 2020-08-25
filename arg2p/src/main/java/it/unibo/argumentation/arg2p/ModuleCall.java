package it.unibo.argumentation.arg2p;

import alice.tuprolog.*;
import alice.tuprolog.event.QueryEvent;
import alice.tuprolog.exceptions.NoSolutionException;

import java.io.File;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

public class ModuleCall extends Arg2PLibrary {
    public ModuleCall() {
        super("moduleCall");
    }

    /**
     * spawns a separate prolog agent providing it a theory text and a goal
     *
     * @throws PrologError
     */
    public boolean arg_agent_3(Term th, Term g, Term res) throws PrologError {
        
        th = th.getTerm();
        g = g.getTerm();
        res = res.getTerm();

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
        if (!(res instanceof Var)) {
            throw PrologError.instantiation_error(getEngine().getEngineManager(), 3);
        }

        Struct theory = (Struct) th;
        Struct goal = (Struct) g;
        List<Term> results = new LinkedList<>();

        try {
            Prolog engine = prepareCleanEngine(theory);
            SolveInfo info = engine.solve(goal.toString() + ".");
            while (info.isSuccess()) {
                results.add(info.getSolution());
                if (engine.hasOpenAlternatives())
                    info = engine.solveNext();
                else break;
            }

            unify(res, Struct.list(results));
            return true;

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