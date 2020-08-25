package alice.tuprologx.ide;

import alice.tuprolog.Prolog;
import alice.tuprolog.Theory;
import alice.tuprolog.exceptions.InvalidTheoryException;

import javax.swing.*;
import java.awt.*;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.net.URL;

public class TheoryEditor
        extends JPanel {

    private static final long serialVersionUID = 1L;

    /**
     * The Prolog engine referenced by the editor.
     */
    private Prolog engine;
    /**
     * The edit area used by the editor.
     */
    private TheoryEditArea editArea;
    /**
     * Used for components interested in changes of console's properties.
     */
    private PropertyChangeSupport propertyChangeSupport;

    private IDE ide;

    private JLabel caretLineLabel;
    private JButton bSetTheory;

    public TheoryEditor(IDE ide) {
        initComponents();
        this.ide = ide;
        propertyChangeSupport = new PropertyChangeSupport(this);
    }

    private void initComponents() {
        setLayout(new BorderLayout());
        JPanel caretPanel = new JPanel();
        add(caretPanel, BorderLayout.WEST);
        JPanel buttonsPanel = new JPanel();
        add(buttonsPanel, BorderLayout.EAST);
        add(new JSeparator(), BorderLayout.SOUTH);

        caretLineLabel = new JLabel("Line: ");
        caretPanel.add(caretLineLabel);

        JButton bGetTheory = new JButton();
        URL urlImage = getClass().getResource("img/GetTheory20.png");
        bGetTheory.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bGetTheory.setToolTipText("Get Theory");
        bGetTheory.setPreferredSize(new Dimension(32, 32));
        bGetTheory.addActionListener(event -> getEngineTheory());
        bSetTheory = new JButton();
        urlImage = getClass().getResource("img/SetTheory20.png");
        bSetTheory.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bSetTheory.setToolTipText("Set Theory");
        bSetTheory.setPreferredSize(new Dimension(32, 32));
        bSetTheory.addActionListener(event -> setEngineTheory());
        JButton bUndo = new JButton();
        urlImage = getClass().getResource("img/Undo20.png");
        bUndo.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bUndo.setToolTipText("Undo Edit Action");
        bUndo.setPreferredSize(new Dimension(32, 32));
        bUndo.addActionListener(event -> undo());
        JButton bRedo = new JButton();
        urlImage = getClass().getResource("img/Redo20.png");
        bRedo.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bRedo.setToolTipText("Redo Edit Action");
        bRedo.setPreferredSize(new Dimension(32, 32));
        bRedo.addActionListener(event -> redo());
        buttonsPanel.add(bGetTheory);
        buttonsPanel.add(bSetTheory);
        buttonsPanel.add(bUndo);
        buttonsPanel.add(bRedo);
    }

    /**
     * Get the Prolog engine referenced by the editor.
     *
     * @return The Prolog engine referenced by the editor.
     */
    public Prolog getEngine() {
        return engine;
    }

    /**
     * Set the Prolog engine referenced by the editor.
     *
     * @param engine an <code>alice.tuprolog.Prolog</code> engine.
     */
    public void setEngine(Prolog engine) {
        this.engine = engine;
    }

    /**
     * Set the editor status.
     *
     * @param message The message describing the new status of the editor.
     */
    public void setStatusMessage(String message) {
        propertyChangeSupport.firePropertyChange("StatusMessage", "", message);
    }

    public void addPropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.removePropertyChangeListener(listener);
    }

    /**
     * Set the edit area used by the editor to manipulate the text of Prolog theories.
     *
     * @param editArea The edit area we want the editor to use.
     */
    public void setEditArea(TheoryEditArea editArea) {
        this.editArea = editArea;
    }

    /**
     * Set the theory of the tuProlog engine referenced by the editor to the
     * theory currently contained in the edit area.
     */
    public void setEngineTheory() {
        // insert a check on feededTheory? -> if true does not feed anything.
        String theory = editArea.getTheory();
        try {
            getEngine().setTheory(Theory.parseWithOperators(theory, getEngine().getOperatorManager()));
            editArea.setDirty(false);
            setStatusMessage("New theory accepted.");
        } catch (InvalidTheoryException ite) {
            setStatusMessage("Error setting theory: Syntax Error at/before line " + ite.getLine());
        }
    }

    /**
     * Get the theory currently contained in the tuProlog engine referenced by
     * the editor and display it in the edit area.
     */
    public void getEngineTheory() {
        ide.getTheory();
        setStatusMessage("Engine theory displayed.");
    }

    /**
     * Undo last action in the Edit Area.
     */
    public void undo() {
        editArea.undoAction();
    }

    /**
     * Redo last action in the Edit Area.
     */
    public void redo() {
        editArea.redoAction();
    }

    /**
     * Display the line number where the caret in the edit area is.
     *
     * @param caretLine The line number to be displayed.
     */
    public void setCaretLine(int caretLine) {
        caretLineLabel.setText("Line: " + caretLine);
    }

    /**
     * Enable or disable theory-related buttons.
     *
     * @param flag true if the buttons have to be enabled, false otherwise.
     */
    protected void enableTheoryCommands(boolean flag) {
        bSetTheory.setEnabled(flag);
    }

} // end ThinletTheoryEditor class    

