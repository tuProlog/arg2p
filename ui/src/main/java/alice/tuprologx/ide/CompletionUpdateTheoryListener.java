package alice.tuprologx.ide;

import alice.tuprolog.event.TheoryEvent;
import alice.tuprolog.interfaces.event.TheoryListener;
import org.fife.ui.autocomplete.Completion;
import org.fife.ui.autocomplete.DefaultCompletionProvider;

import java.util.LinkedList;

class CompletionUpdateTheoryListener implements TheoryListener {
    private final DefaultCompletionProvider commonCompletionProvider;
    private LinkedList<Completion> addedTheoryCompletions = new LinkedList<Completion>();

    CompletionUpdateTheoryListener(DefaultCompletionProvider commonCompletionProvider) {
        this.commonCompletionProvider = commonCompletionProvider;
    }

    @Override
    public void theoryChanged(TheoryEvent e) {
        // Simply remove old theory completions and add new ones - can be optimized by replacing deltas
        for (Completion oldCompletion : addedTheoryCompletions) {
            commonCompletionProvider.removeCompletion(oldCompletion);
        }

        addedTheoryCompletions.clear();

        // Create new completions: a naive implementation based on string processing for now...
        String newTheory = e.getNewTheory().toString();
        String[] lines = newTheory.split("\n");
        for (String line : lines) {
            if (line.length() > 0 && Character.isLetter(line.charAt(0)) && line.replace(" ", "").contains("):-")) {
                String newTerm = line.replace(" ", "").split("\\)")[0];
                String name = newTerm.split("\\(")[0];
                // Skip commented lines
                if (name.contains("%")) {
                    continue;
                }

                // Skip already added
                boolean alreadyAdded = false;
                for (Completion c : addedTheoryCompletions) {
                    if (c.getInputText().equals(name)) {
                        alreadyAdded = true;
                        break;
                    }
                }
                if (alreadyAdded) {
                    continue;
                }

                String[] params = newTerm.replace(name + "(", "").replace(")", "").split(",");

                Completion newCompletion = CompletionUtils.AddPredicateCompletion(commonCompletionProvider,
                                                                                  name, null,
                                                                                  "User defined: " + newTerm +
                                                                                  ")", CompletionUtils.THEORY_COMPLETIONS_RELEVANCE, params);

                addedTheoryCompletions.add(newCompletion);
            }
        }
    }
}
