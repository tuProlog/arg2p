package alice.tuprologx.ide;

import alice.tuprolog.*;
import alice.tuprolog.event.ExceptionEvent;
import alice.tuprolog.event.OutputEvent;
import alice.tuprolog.event.QueryEvent;
import alice.tuprolog.event.ReadEvent;
import alice.tuprolog.exceptions.NoSolutionException;
import alice.tuprolog.interfaces.event.ExceptionListener;
import alice.tuprolog.interfaces.event.OutputListener;
import alice.tuprolog.interfaces.event.ReadListener;
import com.google.common.collect.ImmutableMap;
import edu.uci.ics.jung.algorithms.layout.KKLayout;
import edu.uci.ics.jung.algorithms.layout.Layout;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.SparseMultigraph;
import edu.uci.ics.jung.graph.util.EdgeType;
import edu.uci.ics.jung.visualization.VisualizationViewer;
import edu.uci.ics.jung.visualization.control.DefaultModalGraphMouse;
import edu.uci.ics.jung.visualization.control.ModalGraphMouse;
import edu.uci.ics.jung.visualization.decorators.ToStringLabeller;
import edu.uci.ics.jung.visualization.renderers.Renderer;
import edu.uci.ics.jung.visualization.renderers.VertexLabelAsShapeRenderer;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.table.TableModel;
import javax.swing.text.BadLocationException;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

//import alice.tuprologx.spyframe.TermPanel;
//import alice.tuprolog.Term;
/*Castagna 06/2011*/
/**/

public class ConsoleDialog
        extends JPanel
        implements OutputListener, ReadListener, InformationToDisplayListener, PropertyChangeListener, MouseListener, ChangeListener/*Castagna 06/2011*/, ExceptionListener/**/ {
    static final long serialVersionUID = 0;

    private static final int SOLUTION_INDEX = 0;
    private static final int BINDINGS_INDEX = 1;
    private static final int ALL_BINDINGS_INDEX = 2;
    private static final int OUTPUT_INDEX = 3;
    private static final int INPUT_INDEX = 4; /* Index of Input Tab*/
    /*Castagna 06/2011*/
    private static final int EXCEPTION_INDEX = 5;
    /**/
    static String sol = ""; //used in showing all results (before only one result was shown at a time)
    private String statusMessage;
    private PropertyChangeSupport propertyChangeSupport;
    private Console consoleManager;
    private String[] variables = null;
    private java.util.List<Var> bindings = null;
    private int selectDisplayModality = 0;
    /**/
    /*Castagna 06/2011*/
    private boolean exceptionEnabled;
    private IOFileOperations fileManager;

    private JTabbedPane tp;
    private JTextPane solution;
    //private TermPanel callTree;
    private PrologTable tableSolve;
    private PrologTable tableSolveAll;
    private JTextPane output;
    /*Castagna 06/2011*/
    private JTextPane exception;

    private ArgumentationGraphFrame argumentationGraphFrame;

    private JButton bNext;
    private JButton bAccept;
    private JButton bStop;
    private JButton bClear;
    private JButton bExport;

    public ConsoleDialog(Console consoleManager) {
        this.consoleManager = consoleManager;
        propertyChangeSupport = new PropertyChangeSupport(this);
        initComponents();
    }

    private void initComponents() {
        setLayout(new GridBagLayout());
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.weightx = 1;
        constraints.weighty = 1;
        constraints.fill = GridBagConstraints.BOTH;
        constraints.gridwidth = GridBagConstraints.REMAINDER;
        tp = new JTabbedPane();
        tp.setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);
        add(tp, constraints);

        solution = new JTextPane();
        solution.setEditable(false);
        tp.addTab("solution", new JScrollPane(solution));

        tableSolve = new PrologTable();
        tp.addTab("bindings", new JScrollPane(tableSolve));

        tableSolveAll = new PrologTable();
        tp.addTab("all bindings", new JScrollPane(tableSolveAll));

        output = new JTextPane();
        output.setEditable(false);
        tp.addTab("output", new JScrollPane(output));

        /**
         * Added an input tab ("input") to tp (JTabbedPane)
         */
        tp.addTab("input", new JScrollPane());

        /*Castagna 06/2011*/
        exceptionEnabled = true;
        exception = new JTextPane();
        exception.setEditable(false);

        //Get the exception text pane's document
        StyledDocument doc = exception.getStyledDocument();

        Style style = doc.addStyle("Italic", null);
        StyleConstants.setItalic(style, true);

        style = doc.addStyle("NoItalic", null);
        StyleConstants.setItalic(style, false);

        tp.addTab("exceptions", new JScrollPane(exception));

        final JSplitPane argumentationGraphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        tp.addTab("graph", argumentationGraphPane);
        argumentationGraphFrame = new ArgumentationGraphFrame(argumentationGraphPane);

        /**/

        bNext = new JButton("Next");
        URL urlImage = getClass().getResource("img/Next16.png");
        bNext.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bNext.setEnabled(false);
        bNext.addActionListener(event -> getNextSolution());
        bAccept = new JButton("Accept");
        urlImage = getClass().getResource("img/Accept16.png");
        bAccept.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bAccept.setEnabled(false);
        bAccept.addActionListener(event -> acceptSolution());
        bStop = new JButton("Stop");
        urlImage = getClass().getResource("img/Stop16.png");
        bStop.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bStop.setEnabled(false);
        bStop.addActionListener(event -> stopEngine());
        bClear = new JButton("Clear");
        urlImage = getClass().getResource("img/Clear16.png");
        bClear.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bClear.setEnabled(false);
        bClear.addActionListener(event -> clear());
        bExport = new JButton("Export CSV");
        urlImage = getClass().getResource("img/ExportCSV24.png");
        bExport.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));
        bExport.setEnabled(false);
        bExport.addActionListener(event -> exportCSV());
        JPanel buttonsPanel = new JPanel();
        buttonsPanel.add(bNext);
        buttonsPanel.add(bAccept);
        buttonsPanel.add(bStop);
        buttonsPanel.add(bClear);
        buttonsPanel.add(bExport);

        constraints = new GridBagConstraints();
        constraints.gridx = 0;
        constraints.gridy = 1;
        constraints.weightx = 1;

        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.gridwidth = GridBagConstraints.REMAINDER;
        add(buttonsPanel, constraints);

        tp.addChangeListener(this);

    }

    /**
     * Method to insert an InputDialog inside the ConsoleDialog
     */
    public void setInputDialog(InputDialog input) {
        /**/
        tp.setComponentAt(INPUT_INDEX, new JScrollPane(input));
    }

    /**
     * Set the file manager referenced by the toolbar for use in Input/Output tasks.
     *
     * @param fileManager The file manager we want the toolbar to use.
     */
    public void setFileManager(IOFileOperations fileManager) {
        this.fileManager = fileManager;
    }

    public void setFileManagerType(String type) {
        this.fileManager.setTypeFileFilter(type);
    }

    protected void enableStopButton(boolean flag) {
        bStop.setEnabled(flag);
    }

    protected void enableSolutionCommands(boolean flag) {
        bNext.setEnabled(flag);
        bAccept.setEnabled(flag);
    }

    protected void enableTheoryCommands(boolean flag) {
        consoleManager.enableTheoryCommands(flag);
    }

    protected void getNextSolution() {
        enableStopButton(true);
        enableSolutionCommands(false);
        setStatusMessage("Solving...");
        try {
            consoleManager.getNextSolution();
        } catch (Exception e) {
            this.setStatusMessage("Error: " + e);
        }
    }

    protected void acceptSolution() {
        enableStopButton(false);
        enableSolutionCommands(false);
        consoleManager.enableTheoryCommands(true);
        consoleManager.acceptSolution();
        setStatusMessage("Ready.");
    }

    protected void stopEngine() {
        // stop the tuProlog engine
        consoleManager.stopEngine();
        // disable button
        enableSolutionCommands(false);
        enableStopButton(false);
        setStatusMessage("Ready.");
    }

    protected void clear() {
        if (tp.getSelectedIndex() == SOLUTION_INDEX) {
            solution.setText("");
        }
        if (tp.getSelectedIndex() == BINDINGS_INDEX) {
            tableSolve = new PrologTable();
            tp.setComponentAt(BINDINGS_INDEX, new JScrollPane(tableSolve));
            clearResults();
            enableTheoryCommands(true);
            enableSolutionCommands(false);
        }
        if (tp.getSelectedIndex() == ALL_BINDINGS_INDEX) {
            tableSolveAll = new PrologTable();
            tp.setComponentAt(ALL_BINDINGS_INDEX, new JScrollPane(tableSolveAll));
            clearResults();
            enableSolutionCommands(false);
        }
        if (tp.getSelectedIndex() == OUTPUT_INDEX) {
            output.setText("");
        }
        /*Castagna 06/2011*/
        if (tp.getSelectedIndex() == EXCEPTION_INDEX) {
            exception.setText("");
        }
        /**/
    }

    protected void exportCSV() {
        if (tp.getSelectedIndex() != OUTPUT_INDEX) {
            String fileContent = "";
            TableModel model = null;
            if (tp.getSelectedIndex() == BINDINGS_INDEX) {
                model = tableSolve.getModel();
                for (int i = 0; i < tableSolve.getColumnCount(); i++) {
                    fileContent += tableSolve.getColumnName(i) + "\t";
                }
            }

            if (tp.getSelectedIndex() == ALL_BINDINGS_INDEX) {
                model = tableSolveAll.getModel();
                for (int i = 0; i < tableSolveAll.getColumnCount(); i++) {
                    fileContent += tableSolveAll.getColumnName(i) + "\t";
                }
            }
            fileContent += "\n";

            for (int j = 0; j < model.getRowCount(); j++) {
                for (int i = 0; i < model.getColumnCount(); i++) {
                    fileContent += model.getValueAt(j, i) + "\t";
                }
                fileContent += "\n";
            }
            try {
                FileIDE fileIDE = new FileIDE("", null);
                fileIDE.setContent(fileContent);
                fileIDE = fileManager.saveFile(fileIDE);
                if (fileIDE.getFilePath() != null) {
                    setStatusMessage("Query solution saved to " + fileIDE.getFileName() + ".");
                } else {
                    setStatusMessage("Ready.");
                }
            } catch (Exception e) {
                setStatusMessage("Error saving query solution." + e.getMessage());
            }
        }
    }

    public String getStatusMessage() {
        return statusMessage;
    }

    public void setStatusMessage(String message) {
        String oldStatusMessage = getStatusMessage();
        statusMessage = message;
        propertyChangeSupport.firePropertyChange("StatusMessage", oldStatusMessage, statusMessage);
    }

    public void addPropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.removePropertyChangeListener(listener);
    }

    //OutputListener interface method
    public void onOutput(OutputEvent event) {
        output.setText(output.getText() + event.getMsg());
        tp.setBackgroundAt(OUTPUT_INDEX, new Color(184, 229, 207));

    }

    /**
     * Implemented the method readCalled because the consoleDialog is
     * a ReadListener.
     * When it is called a read operation the input tab is selected
     */
    public void readCalled(ReadEvent event) {
        tp.setSelectedIndex(INPUT_INDEX);
    }

    /***/

    /*Castagna 06/2011*/
    public void onException(ExceptionEvent event) {
        try {
            StyledDocument doc = exception.getStyledDocument();
            doc.insertString(doc.getLength(), ((exception.getText().length() > 0) ? "\n" : "") +
                                              event.getMsg(), doc.getStyle("NoItalic"));
        } catch (BadLocationException e) {
            exception.setText(exception.getText() + ((exception.getText().length() > 0) ? "\n" : "") + event.getMsg());
        }
        tp.setBackgroundAt(EXCEPTION_INDEX, new Color(229, 184, 207));
    }
    /**/

    //InformationToDisplayListener interface method
    public void onInformation(InformationToDisplayEvent event) {
        if (event.getSolveType() == 1)//if there is information about a solveAll operation
        {
            showAllSolutions(event.getQueryResults(), event.getQueryResultsString());
        }
        if (event.getSolveType() == 0)//if there is information about a solve operation
        {
            //argumentationGraphFrame.printArgumentationInfo(event.getQueryResult(), (Prolog) event.getSource());
            showSolution(event.getQueryResult());
        }
    }

    private void showSolution(SolveInfo info) {
        enableStopButton(false);
        enableSolutionCommands(true);
        if (variables == null || variables.length < getVariablesName(info).length) {
            variables = getVariablesName(info);
        }
        if (bindings == null) {
            bindings = new ArrayList<Var>();
        }
        try {
            if (info.isSuccess()) {
                String binds = info.toString();

                if (!consoleManager.hasOpenAlternatives()) {
                    enableTheoryCommands(true);
                    enableSolutionCommands(false);
                    setStatusMessage("Yes. Ready.");
                } else {
                    enableSolutionCommands(true);
                    setStatusMessage("Yes. Other alternatives can be explored.");
                }
                // visualize solution on the solution pane

                //Alberto
                if (sol.equalsIgnoreCase("")) {
                    sol = binds + "\nSolution: " + info.getSolution() + "\n";
                } else {
                    sol = sol + "\n" + binds + "\nSolution: " + info.getSolution() + "\n";
                }

                solution.setText(sol);

                // store bindings for visualization on the binding pane
                for (Var v : info.getBindingVars()) {
                    if (!v.isAnonymous()) {
                        bindings.add(v);
                    }
                }

                solution.setCaretPosition(sol.length());
            } else {
                enableSolutionCommands(false);
                enableTheoryCommands(true);
                /*Castagna 06/2011*/
                if (info.isHalted()) {
                    solution.setText("halt.");
                } else {
                    //Alberto
                    if (sol.equals("")) {
                        solution.setText("no.");
                    } else {
                        solution.setText(sol + "\nno.");
                    }
                }
                setStatusMessage("No. Ready.");
            }
            draw();
        } catch (Exception ex) {
            ex.printStackTrace();
            setStatusMessage("Internal error. " + ex.getMessage() + " " + ex.getLocalizedMessage());
        }
    }

    private void showAllSolutions(QueryEvent[] querySolutions, ArrayList<String> querySolutionsString) {
        enableStopButton(false);
        enableSolutionCommands(false);
        enableTheoryCommands(true);

        // shows solutions on the solution pane
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < querySolutions.length; i++) {
            SolveInfo s = querySolutions[i].getSolveInfo();
            if (s.isSuccess()) {

                if (s.toString().length() < querySolutionsString.get(i).length()) {
                    buffer.append(querySolutionsString.get(i)).append("\nSolution: ");
                } else {
                    buffer.append(s.toString()).append("\nSolution: ");
                }

                try {
                    buffer.append(s.getSolution().toString());
                } catch (NoSolutionException e) {
                }
                buffer.append("\n\n");
            }
        }
        solution.setText(buffer.toString().trim());

        variables = getVariablesName(querySolutions);
        tableSolveAll = new PrologTable();
        if (getVariablesName(querySolutions) != null)
        // shows solutions on the all bindings table
        {
            tableSolveAll = newPrologTable(getSolutionsMatrix(querySolutions), getVariablesName(querySolutions));
        } else {
            String info = querySolutions[0].getSolveInfo().isSuccess() ? "Yes." : "No.";
            setStatusMessage(info + " Ready.");
        }
        tp.setComponentAt(ALL_BINDINGS_INDEX, new JScrollPane(tableSolveAll));
        tp.setSelectedIndex(SOLUTION_INDEX);
        refreshFont();
    }

    private String[][] getSolutionsMatrix(Object[] querySolutions) {
        int columns = getVariablesNumber(querySolutions);
        int rows = getSolutionsNumber(querySolutions);
        if (columns > 0) {
            ArrayList<String> tableModelList = new ArrayList<String>();
            for (int i = 0; i < getSolutionsNumber(querySolutions); i++) {
                SolveInfo solution = ((QueryEvent) querySolutions[i]).getSolveInfo();
                if (solution.isSuccess()) {
                    try {
                        for (Var v : solution.getBindingVars()) {
                            if (!v.isAnonymous()) {
                                String value = v.getTerm().toString();

                                if (v == v.getTerm()) {
                                    value = Var.underscore().getName();
                                }
                                tableModelList.add(value);
                            }
                        }
                    } catch (NoSolutionException e) {
                    }
                } else {
                    rows--;
                }
            }
            String[][] data = new String[rows][columns];
            for (int i = 0; i < tableModelList.size(); i++) {
                data[i / columns][i % columns] = (String) tableModelList.get(i);
            }
            return data;
        } else {
            return null;
        }
    }

    private String[] getVariablesName(Object[] querySolutions) {
        int columns = getVariablesNumber(querySolutions);
        if (columns > 0) {
            for (Object querySolution : querySolutions) {
                if (getVariablesNumber(((QueryEvent) querySolution).getSolveInfo()) ==
                        getVariablesNumber(querySolutions)) {
                    return getVariablesName(((QueryEvent) querySolution).getSolveInfo());
                }
            }
            return null;//never executed
        } else {
            return null;
        }
    }

    private String[] getVariablesName(SolveInfo info) {
        int columns = getVariablesNumber(info);
        if (columns > 0) {
            String[] variables = new String[columns];
            try {
                int position = 0;
                for (Var v : info.getBindingVars()) {
                    if (!v.isAnonymous()) {
                        variables[position] = v.getName();
                        position++;
                    }
                }
            } catch (NoSolutionException e) {

                throw new AssertionError(e);
            }
            return variables;
        } else {
            return new String[]{};
        }
    }

    private int getVariablesNumber(Object[] querySolutions) {
        int count = 0;
        for (Object querySolution : querySolutions) {
            int n = getVariablesNumber(((QueryEvent) querySolution).getSolveInfo());
            if (count < n) {
                count = n;
            }
        }
        return count;
    }

    private int getVariablesNumber(SolveInfo info) {
        int count = 0;
        try {
            for (Var v : info.getBindingVars()) {
                if (!v.isAnonymous()) {
                    count++;
                }
            }
        } catch (NoSolutionException e) {
        }
        return count;
    }

    private int getSolutionsNumber(Object[] querySolutions) {
        return querySolutions.length;
    }

    private void draw() {
        String[][] tableModel = null;
        tableSolve = new PrologTable();
        if (bindings != null && variables.length > 0) {
            if (selectDisplayModality == 0) {
                ArrayList<String> tableModelList = new ArrayList<String>();
                for (Var v : bindings) {
                    String value = v.getTerm().toString();

                    if (v == v.getTerm()) {
                        value = Var.underscore().getName();
                    }
                    tableModelList.add(value);
                }
                tableModel = new String[tableModelList.size() / variables.length][variables.length];
                for (int i = 0; i < tableModelList.size(); i++) {
                    tableModel[i / variables.length][i % variables.length] = (String) tableModelList.get(i);
                }
                tableSolve = newPrologTable(tableModel, variables);
            }
            if (selectDisplayModality == 1 || selectDisplayModality == 2) {
                ArrayList<String> tableModelList = new ArrayList<String>();
                for (Var v : bindings) {
                    String value = v.getTerm().toString();
                    if (v == v.getTerm()) {
                        value = Var.underscore().getName();
                    }
                    tableModelList.add(v.getName());
                    tableModelList.add(value);
                }
                tableModel = new String[tableModelList.size() / 2][2];
                if (selectDisplayModality == 1) {
                    for (int i = 0; i < tableModelList.size(); i++) {
                        tableModel[i / 2][i % 2] = (String) tableModelList.get(i);
                    }
                }
                if (selectDisplayModality == 2) {
                    int j = 0;
                    for (int var = 0; var < variables.length; var++) {
                        for (int i = 0 + 2 * var; i < tableModelList.size(); ) {
                            tableModel[j / 2][j % 2] = (String) tableModelList.get(i);
                            j++;
                            tableModel[j / 2][j % 2] = (String) tableModelList.get(i + 1);
                            i = i + 2 * variables.length;
                            j++;
                        }
                    }
                }
                String[] vars = {"Variable", "Binding"};
                tableSolve = newPrologTable(tableModel, vars, selectDisplayModality);
            }
            tp.setComponentAt(BINDINGS_INDEX, new JScrollPane(tableSolve));
            tp.setSelectedIndex(SOLUTION_INDEX);
            refreshFont();
        }
    }

    public void setFontDimension(int dimension) {
        Font font = new Font(output.getFont().getName(), output.getFont().getStyle(), dimension);
        output.setFont(font);
        solution.setFont(font);
        tableSolve.setFont(font);
        tableSolve.setRowHeight(dimension + 4);
        tableSolveAll.setFont(font);
        tableSolveAll.setRowHeight(dimension + 4);
    }

    private void refreshFont() {
        Font font = output.getFont();
        solution.setFont(font);
        tableSolve.setFont(font);
        tableSolve.setRowHeight(font.getSize() + 4);
        tableSolveAll.setFont(font);
        tableSolveAll.setRowHeight(font.getSize() + 4);
    }

    //PropertyChangeListener interface method
    public void propertyChange(PropertyChangeEvent event) {
        String propertyName = event.getPropertyName();
        if (propertyName.equals("selectDisplayModality")) {
            selectDisplayModality = ((Integer) event.getNewValue()).intValue();
            if (bindings != null) {
                draw();
            }
        }
        /*Castagna 06/2011*/
        if (propertyName.equals("notifyExceptionEvent")) {
            setExceptionEnabled(((Boolean) event.getNewValue()).booleanValue());
        }
        /**/
    }

    public void clearResults() {
        variables = null;
        bindings = null;
    }

    private PrologTable newPrologTable(String[][] rowData, String[] columnNames) {
        PrologTable table = new PrologTable(rowData, columnNames);
        table.addMouseListener(this);
        return table;
    }

    private PrologTable newPrologTable(String[][] rowData, String[] columnNames, int selectDisplayModality) {
        PrologTable table = new PrologTable(rowData, columnNames, initTableIsBorderedCellArray(rowData.length));
        table.addMouseListener(this);
        return table;
    }

    private boolean[] initTableIsBorderedCellArray(int length) {
        boolean[] array = new boolean[length];
        if (selectDisplayModality == 0) {
            for (int j = 0; j < length; j++) {
                array[j] = false;
            }
        }
        if (selectDisplayModality == 1) {
            for (int j = 0; j < length; j++) {
                array[j] = j % variables.length == 0;
            }
        }
        if (selectDisplayModality == 2) {
            for (int j = 0; j < length; j++) {
                array[j] = j % (bindings.size() / variables.length) == 0;
            }
        }
        return array;
    }

    private PrologTable newPrologTable(TableModel model) {
        PrologTable table = new PrologTable(model);
        table.addMouseListener(this);
        return table;
    }

    //MouseListener interface methods
    public void mouseClicked(MouseEvent event) {
        if (tp.getSelectedIndex() != 2) {
            PrologTable table = (PrologTable) event.getSource();
            Point p = event.getPoint();
            int row = table.rowAtPoint(p);
            table.changeRowStatus(row);
            TableModel model = table.getModel();
            if (tp.getSelectedIndex() == BINDINGS_INDEX) {
                boolean[] isExpandedCellArray = tableSolve.getIsExpandedCellArray();
                boolean[] isBorderedCellArray = tableSolve.getIsBorderedCellArray();
                Point view = ((JScrollPane) tp.getComponentAt(BINDINGS_INDEX)).getViewport().getViewPosition();
                tableSolve = newPrologTable(model);
                tableSolve.setIsExpandedCellArray(isExpandedCellArray);
                tableSolve.setIsBorderedCellArray(isBorderedCellArray);
                tp.setComponentAt(BINDINGS_INDEX, new JScrollPane(tableSolve));
                ((JScrollPane) tp.getComponentAt(BINDINGS_INDEX)).getViewport().setViewPosition(view);
            }
            if (tp.getSelectedIndex() == ALL_BINDINGS_INDEX) {
                boolean[] isExpandedCellArray = tableSolveAll.getIsExpandedCellArray();
                Point view = ((JScrollPane) tp.getComponentAt(ALL_BINDINGS_INDEX)).getViewport().getViewPosition();
                tableSolveAll = newPrologTable(model);
                tableSolveAll.setIsExpandedCellArray(isExpandedCellArray);
                tp.setComponentAt(ALL_BINDINGS_INDEX, new JScrollPane(tableSolveAll));
                ((JScrollPane) tp.getComponentAt(ALL_BINDINGS_INDEX)).getViewport().setViewPosition(view);
            }
            refreshFont();
        }
    }

    public void mouseEntered(MouseEvent event) {
    }

    public void mouseExited(MouseEvent event) {
    }

    public void mousePressed(MouseEvent event) {
    }

    public void mouseReleased(MouseEvent event) {
    }

    //ChangeListener interface methods

    /**
     * this method enable bExport JButton if the user sees a not emptyWithStandardOperators table
     * else disable it
     */
    public void stateChanged(ChangeEvent arg0) {
        if (tp.getSelectedIndex() == SOLUTION_INDEX) {
            bExport.setEnabled(false);
            bClear.setEnabled(false);
        }
        if (tp.getSelectedIndex() == BINDINGS_INDEX) {
            if (tableSolve.getModel().getColumnCount() > 0) {
                bExport.setEnabled(true);
            } else {
                bExport.setEnabled(false);
            }
            bClear.setEnabled(true);
        }
        if (tp.getSelectedIndex() == ALL_BINDINGS_INDEX) {
            if (tableSolveAll.getModel().getColumnCount() > 0) {
                bExport.setEnabled(true);
            } else {
                bExport.setEnabled(false);
            }
            bClear.setEnabled(true);
        }
        if (tp.getSelectedIndex() == OUTPUT_INDEX) {
            bExport.setEnabled(false);
            tp.setBackgroundAt(OUTPUT_INDEX, new Color(238, 238, 238));
            bClear.setEnabled(true);
        }
        /*Castagna 06/2011*/
        if (tp.getSelectedIndex() == EXCEPTION_INDEX) {
            bExport.setEnabled(false);
            setExceptionJTextPaneRendering();
        }
        /**/
        /**
         * Matteo Librenti 03/2014
         */
        if (tp.getSelectedIndex() == INPUT_INDEX) {
            tp.setBackgroundAt(INPUT_INDEX, new Color(238, 238, 238));
            bClear.setEnabled(false);
        }
        /***/
    }

    /*Castagna 06/2011*/
    public void setExceptionEnabled(boolean enable) {
        exception.setText("");
        exceptionEnabled = enable;
        setExceptionJTextPaneRendering();
    }

    /*Castagna 06/2011*/
    private void setExceptionJTextPaneRendering() {
        if (exceptionEnabled) {
            tp.setBackgroundAt(EXCEPTION_INDEX, new Color(238, 238, 238));
            exception.setBackground(new Color(255, 255, 255));
            if (tp.getSelectedIndex() == EXCEPTION_INDEX) {
                bClear.setEnabled(true);
            }
        } else {
            tp.setBackgroundAt(EXCEPTION_INDEX, new Color(207, 207, 207));
            exception.setBackground(new Color(207, 207, 207));
            exception.setText("");
            try {
                StyledDocument doc = exception.getStyledDocument();
                doc.insertString(doc.getLength(), "Exception notifications disabled", doc.getStyle("Italic"));
            } catch (BadLocationException e) {
                exception.setText("Exception notification disabled");
            }
            bClear.setEnabled(false);
        }
    }
}
