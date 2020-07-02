package it.unibo.argumentation.arg2p;

import alice.tuprolog.*;

import java.io.File;
import java.io.IOException;

public class ModuleCall extends Arg2PLibrary {
    public ModuleCall() {
        super("moduleCall");
    }

    /**
     * spawns a separate prolog agent providing it a theory text and a goal
     *
     * @throws PrologError
     */
    public boolean agent_3(Term th, Term env, Term g) throws PrologError {
        th = th.getTerm();
        env = env.getTerm();
        g = g.getTerm();
        if (th instanceof Var) {
            throw PrologError.instantiation_error(getEngine().getEngineManager(), 1);
        }
        if (g instanceof Var) {
            throw PrologError.instantiation_error(getEngine().getEngineManager(), 2);
        }
        if (!(th.isAtom())) {
            throw PrologError.type_error(getEngine().getEngineManager(), 1, "atom",
                    th);
        }
        if (!(g instanceof Struct)) {
            throw PrologError.type_error(getEngine().getEngineManager(), 2,
                    "struct", g);
        }

        Struct theory = (Struct) th;
        Struct goal = (Struct) g;
        try {
            Prolog engine = prepareCleanEngine(env, theory);
            SolveInfo solve = engine.solve(goal.toString() + ".");
            if (solve.isSuccess()) return unify(g, solve.getSolution());
            return false;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    private Prolog prepareCleanEngine(Term env, Struct theory) {
        Prolog engine = new Prolog();
        Arg2PLibrary.loadDeonLiteOnPrologEngine(engine);

        Theory t = Theory.parseWithOperators(alice.util.Tools.removeApices(theory.toString()),
                engine.getOperatorManager());

        engine.setTheory(getEnvTheory(env, engine));
        engine.addTheory(Theory.of(env));
        engine.addTheory(t);

        return engine;
    }

    private Theory getEnvTheory(Term env, Prolog engine) {
        if (!(env instanceof Struct) || ((Struct) env).getArity() != 1) {
            return Theory.empty();
        }

        return Theory.parseWithOperators(
                alice.util.Tools.removeApices(((Struct) env).getArg(0).getTerm().toString()),
                engine.getOperatorManager());
    }
}