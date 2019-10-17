package alice.tuprologx.ide;

import it.unibo.argumentation.deonlite.DeonLite2PLibrary;

import javax.swing.*;

public class JavaIDEWithDeonLite extends JavaIDE {
    public JavaIDEWithDeonLite() {
        super(DeonLite2PLibrary::loadDeonLiteOnPrologEngine);
    }

    public static void main(String[] args) {
        final JavaIDEWithDeonLite ide = new JavaIDEWithDeonLite();
        SwingUtilities.invokeLater(() -> ide.setVisible(true));
    }
}
