package alice.tuprologx.ide;

import it.unibo.argumentation.arg2p.Arg2PLibrary;

import javax.swing.*;

public class JavaIDEWithArg2P extends JavaIDE {
    public JavaIDEWithArg2P() {
        super(Arg2PLibrary::loadDeonLiteOnPrologEngine);
    }

    public static void main(String[] args) {
        final JavaIDEWithArg2P ide = new JavaIDEWithArg2P();
        SwingUtilities.invokeLater(() -> ide.setVisible(true));
    }
}
