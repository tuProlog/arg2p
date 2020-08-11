package alice.tuprologx.ide;

/**
 * @author ale
 */

public interface Console {
    boolean hasOpenAlternatives();

    void enableTheoryCommands(boolean flag);

    void getNextSolution();

    void acceptSolution();

    void stopEngine();

    String getGoal();
}