package SpyFrame;

import alice.tuprolog.*;
import alice.tuprologx.spyframe.TermFrame;

import java.util.List;
import java.util.Scanner;

/**
 * This is to be thrown away in the end.
 *
 * @author franz.beslmeisl at googlemail.com
 */
public class Test {
    public static void main(String[] args) throws Exception {
        Scanner tast = new Scanner(System.in);
        Theory theo = Theory.parseLazilyWithStandardOperators(
                "mutter(anne,alice).\n"
                        + "mutter(anne,louise).\n"
                        + "mutter(coco,anne).\n"
                        + "mutter(rose,coco).\n"
                        + "vorfahr(V,N):-\n"
                        + "  mutter(V,N).\n"
                        + "vorfahr(V,N):-\n"
                        + "  mutter(V,Z),\n"
                        + "  vorfahr(Z,N).\n"
        );
        System.out.println(theo);
        Prolog prolog = new Prolog();
        prolog.setTheory(theo);
        Term sol;
        final TermFrame tf = new TermFrame(null);
        tf.setBounds(300, 300, 300, 200);
        prolog.addSpyListener(se -> {
            if (se == null) return;
            Engine engine = se.getSnapshot();
            if (engine == null) System.out.println("noengine:" + se);
            else {
                //if(!"Eval".equals(engine.getNextStateName())) return;
                List<ExecutionContext> eclist = engine.getExecutionStack();
                for (int i = eclist.size() - 1; i >= 0; i--) {
                    ExecutionContext ec = eclist.get(i);
                    System.out.println(ec);
                }
                System.out.println("nextState " + engine.getNextStateName());
                System.out.println("\n");
                //JOptionPane.showMessageDialog(null, "weiter", "Detail", JOptionPane.INFORMATION_MESSAGE);
            }
        });
        prolog.setSpy(true);
        SolveInfo sinfo = prolog.solve(args[0]);
        while (sinfo.isSuccess()) {
            sol = sinfo.getSolution();
            //tf.setTerm(sol);
            //System.out.println("solution: "+sol);
            //System.out.println("info:     "+sinfo);
            //tast.next();
            //JOptionPane.showMessageDialog(null, sinfo, "Detail", JOptionPane.INFORMATION_MESSAGE);
            if (sinfo.hasOpenAlternatives()) sinfo = prolog.solveNext();
            else break;
        }
        System.out.println("Ende");
    }
}