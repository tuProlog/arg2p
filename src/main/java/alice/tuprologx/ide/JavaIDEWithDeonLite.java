package alice.tuprologx.ide;

import it.unibo.argumentation.deonlite.AbstractDeonLite2PLibrary;

import javax.swing.*;

public class JavaIDEWithDeonLite extends JavaIDE {
    public JavaIDEWithDeonLite() {
        super(AbstractDeonLite2PLibrary::loadDeonLiteOnPrologEngine);
    }

    public static void main(String[] args) {
        final JavaIDEWithDeonLite ide = new JavaIDEWithDeonLite();
        SwingUtilities.invokeLater(() -> ide.setVisible(true));
    }
}
