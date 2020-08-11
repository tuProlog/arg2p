package alice.tuprologx.ide;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Theory;
import alice.tuprolog.Var;
import alice.tuprolog.event.ExceptionEvent;
import alice.tuprolog.event.OutputEvent;
import alice.tuprolog.event.SpyEvent;
import alice.tuprolog.event.WarningEvent;
import alice.tuprolog.exceptions.InvalidTheoryException;
import alice.tuprolog.exceptions.MalformedGoalException;
import alice.tuprolog.exceptions.NoSolutionException;
import alice.tuprolog.interfaces.event.ExceptionListener;
import alice.tuprolog.interfaces.event.OutputListener;
import alice.tuprolog.interfaces.event.SpyListener;
import alice.tuprolog.interfaces.event.WarningListener;
import alice.tuprolog.lib.IOLibrary;
import alice.util.Automaton;

import java.io.*;
import java.util.function.Consumer;

@SuppressWarnings("serial")
public class CUIConsole extends Automaton implements Serializable, OutputListener, SpyListener, WarningListener/*Castagna 06/2011*/, ExceptionListener/**/ {

    static final String incipit =
            "tuProlog system - release " + Prolog.getVersion() + "\n";
    static String sol = ""; //to do -> correct output of CUI console in order to show multiple results
    BufferedReader stdin;
    Prolog engine;

    public CUIConsole(Consumer<Prolog> engineInitialiser) {
        engine = new Prolog();
        engineInitialiser.accept(engine);

        /**
         * Added the method setExecution to conform
         * the operation of CUIConsole as that of JavaIDE
         */
        IOLibrary IO = (IOLibrary) engine.getLibrary("alice.tuprolog.lib.IOLibrary");
        IO.setExecutionType(IOLibrary.consoleExecution);
        /***/
        stdin = new BufferedReader(new InputStreamReader(System.in));
        engine.addWarningListener(this);
        engine.addOutputListener(this);
        engine.addSpyListener(this);
        /*Castagna 06/2011*/
        engine.addExceptionListener(this);
    }

    public CUIConsole(String[] args) {

        if (args.length > 1) {
            System.err.println("args: { theory file }");
            System.exit(-1);
        }


        engine = new Prolog();
        /**
         * Added the method setExecution to conform
         * the operation of CUIConsole as that of JavaIDE
         */
        IOLibrary IO = (IOLibrary) engine.getLibrary("alice.tuprolog.lib.IOLibrary");
        IO.setExecutionType(IOLibrary.consoleExecution);
        /***/
        stdin = new BufferedReader(new InputStreamReader(System.in));
        engine.addWarningListener(this);
        engine.addOutputListener(this);
        engine.addSpyListener(this);
        /*Castagna 06/2011*/
        engine.addExceptionListener(this);
        /**/
        if (args.length > 0) {
            try {
                engine.setTheory(Theory.parseLazilyWithOperators(new FileInputStream(args[0]), engine.getOperatorManager()));
            } catch (InvalidTheoryException ex) {
                System.err.println("invalid theory - line: " + ex.getLine());
                System.exit(-1);
            } catch (Exception ex) {
                System.err.println("invalid theory.");
                System.exit(-1);
            }
        }
    }

    public static void main(String[] args) {
        new Thread(new CUIConsole(args)).start();
    }

    public void boot() {
        System.out.println(incipit);
        become("goalRequest");
    }

    public void goalRequest() {
        String goal = "";
        while (goal.equals("")) {
            System.out.print("\n?- ");
            try {
                goal = stdin.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        solveGoal(goal);
    }

    void solveGoal(String goal) {

        try {
            SolveInfo info = engine.solve(goal);

            /*Castagna 06/2011*/
            //if (engine.isHalted())
            //	System.exit(0);
            /**/
            if (!info.isSuccess()) {
                /*Castagna 06/2011*/
                if (info.isHalted()) {
                    System.out.println("halt.");
                } else
                    /**/ {
                    System.out.println("no.");
                }
                become("goalRequest");
            } else if (!engine.hasOpenAlternatives()) {
                String binds = info.toString();
                if (binds.equals("")) {
                    System.out.println("yes.");
                } else {
                    System.out.println(solveInfoToString(info) + "\nyes.");
                }
                become("goalRequest");
            } else {
                System.out.print(solveInfoToString(info) + " ? ");
                become("getChoice");
            }
        } catch (MalformedGoalException ex) {
            System.out.println("syntax error in goal:\n" + goal);
            become("goalRequest");
        }
    }

    private String solveInfoToString(SolveInfo result) {
        String s = "";
        try {
            for (Var v : result.getBindingVars()) {
                if (!v.isAnonymous() && v.isBound() &&
                    (!(v.getTerm() instanceof Var) || (!((Var) (v.getTerm())).getName().startsWith("_")))) {
                    s += v.getName() + " / " + v.getTerm() + "\n";
                }
            }
            /*Castagna 06/2011*/
            if (s.length() > 0) {
                /**/
                s.substring(0, s.length() - 1);
            }
        } catch (NoSolutionException e) {
        }
        return s;
    }

    public void getChoice() {
        String choice = "";
        try {
            while (true) {
                choice = stdin.readLine();
                if (!choice.equals(";") && !choice.equals("")) {
                    System.out.println("\nAction ( ';' for more choices, otherwise <return> ) ");
                } else {
                    break;
                }
            }
        } catch (IOException ex) {
        }
        if (!choice.equals(";")) {
            System.out.println("yes.");
            engine.solveEnd();
            become("goalRequest");
        } else {
            try {
                System.out.println();
                SolveInfo info = engine.solveNext();
                if (!info.isSuccess()) {
                    System.out.println("no.");
                    become("goalRequest");
                } else {
                    System.out.print(solveInfoToString(info) + " ? ");
                    become("getChoice");
                }
            } catch (Exception ex) {
                System.out.println("no.");
                become("goalRequest");
            }
        }
    }

    public void onOutput(OutputEvent e) {
        System.out.print(e.getMsg());
    }

    public void onSpy(SpyEvent e) {
        System.out.println(e.getMsg());
    }

    public void onWarning(WarningEvent e) {
        System.out.println(e.getMsg());
    }
    /**/

    /*Castagna 06/2011*/
    public void onException(ExceptionEvent e) {
        System.out.println(e.getMsg());
    }
}
