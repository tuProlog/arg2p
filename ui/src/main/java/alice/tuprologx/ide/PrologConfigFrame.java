package alice.tuprologx.ide;

import javax.swing.*;
import java.awt.*;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

public class PrologConfigFrame
        extends GenericFrame {
    private static final long serialVersionUID = 1L;
    private int millsStopEngine;
    private int selectDisplayModality;
    /*Castagna 06/2011*/
    private boolean enableNotifyException;
    /**/
    private PropertyChangeSupport propertyChangeSupport;
    private JRadioButton inColumnsRadioButton;
    private JRadioButton inRowsRadioButton;
    private JRadioButton inRowsVariableSeparatedRadioButton;
    private JTextField millsStopEngineTextField;
    private JTextField fontDimensionTextField;
    /*Castagna 06/2011*/
    private JCheckBox notifyExceptionCheckBox;
    /**/

    private FontDimensionHandler fontDimensionHandler;

    public PrologConfigFrame(JFrame mainWindow, FontDimensionHandler fontDimensionHandler) {
        super("Configure Console", mainWindow, 275, 135, true, true);
        this.propertyChangeSupport = new PropertyChangeSupport(this);
        this.fontDimensionHandler = fontDimensionHandler;
        initComponents();
    }


    private void initComponents() {
        /*Castagna 06/2011*/
    	/*
        Container c=this.getContentPane();
        setLayout(new BorderLayout());
        JPanel fontDimensionPanel = new JPanel();
        JPanel optionPanel = new JPanel();
        JPanel okCancelPanel = new JPanel();
        c.add(fontDimensionPanel ,BorderLayout.NORTH);
        c.add(optionPanel,BorderLayout.CENTER);
        c.add(okCancelPanel,BorderLayout.SOUTH);

        JLabel fontDimensionLabel = new JLabel(" Font dimension");
        */
        JButton bDec = new JButton("<");
        bDec.setToolTipText("Reduce Font Dimension");
        bDec.addActionListener(event -> decFontDimension());

        JButton bInc = new JButton(">");
        bInc.setToolTipText("Enlarge Font Dimension");
        bInc.addActionListener(event -> incFontDimension());

        fontDimensionTextField = new JTextField();
        fontDimensionTextField.setText("" + fontDimensionHandler.getFontDimension());
        fontDimensionTextField.addActionListener(event -> setFontDimension());

        inColumnsRadioButton = new JRadioButton("Variables in columns");
        inRowsRadioButton = new JRadioButton("Variables in rows");
        inRowsVariableSeparatedRadioButton = new JRadioButton("Variables in rows with separated variable");
        ButtonGroup group = new ButtonGroup();
        group.add(inColumnsRadioButton);
        group.add(inRowsRadioButton);
        group.add(inRowsVariableSeparatedRadioButton);

        millsStopEngineTextField = new JTextField("" + millsStopEngine);

        notifyExceptionCheckBox = new JCheckBox();
        enableNotifyException = true;
        notifyExceptionCheckBox.setSelected(enableNotifyException);

        JButton ok = new JButton("OK");

        ok.addActionListener(event -> ok());

        JButton cancel = new JButton("Cancel");
        cancel.addActionListener(event -> cancel());

        {
            Container c = this.getContentPane();
            setLayout(new BorderLayout());

            //Display Option Panel (font dimensions and modality view)
            {
                JPanel displayOptionPanel = new JPanel();
                displayOptionPanel.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "View Options"));
                displayOptionPanel.setLayout(new BoxLayout(displayOptionPanel, BoxLayout.Y_AXIS));

                //Font Panel
                {
                    JPanel fontPanel = new JPanel();
                    FlowLayout fontPanelLayout = new FlowLayout();
                    fontPanelLayout.setAlignment(FlowLayout.LEFT);
                    fontPanel.setLayout(fontPanelLayout);

                    JLabel fontLabel = new JLabel("Font Dimension: ");
                    fontPanel.add(fontLabel);
                    fontPanel.add(bDec);
                    fontPanel.add(fontDimensionTextField);
                    fontPanel.add(bInc);

                    displayOptionPanel.add(fontPanel);
                }

                //Display Modality Panel
                {
                    JPanel displayModalityPanel = new JPanel();

                    FlowLayout displayModalityPanelLayout = new FlowLayout();
                    displayModalityPanelLayout.setAlignment(FlowLayout.LEFT);
                    displayModalityPanel.setLayout(displayModalityPanelLayout);

                    JPanel boxDisplayModalityPanel = new JPanel();
                    boxDisplayModalityPanel.setLayout(new BoxLayout(boxDisplayModalityPanel, BoxLayout.Y_AXIS));
                    JLabel displayModalityLabel = new JLabel("Select the display modality for query Solve solutions:");
                    boxDisplayModalityPanel.add(displayModalityLabel);

                    boxDisplayModalityPanel.add(inColumnsRadioButton);
                    boxDisplayModalityPanel.add(inRowsRadioButton);
                    boxDisplayModalityPanel.add(inRowsVariableSeparatedRadioButton);

                    displayModalityPanel.add(boxDisplayModalityPanel);
                    displayOptionPanel.add(displayModalityPanel);
                }

                c.add(displayOptionPanel, BorderLayout.NORTH);
            }

            //Dsplay Modality Panel
            {

                JPanel engineOptionPanel = new JPanel();
                engineOptionPanel.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Engine Options"));
                engineOptionPanel.setLayout(new BoxLayout(engineOptionPanel, BoxLayout.Y_AXIS));

                {
                    JPanel millsStopEnginePanel = new JPanel();
                    FlowLayout millsStopEnginePanelLayout = new FlowLayout();
                    millsStopEnginePanelLayout.setAlignment(FlowLayout.LEFT);
                    millsStopEnginePanel.setLayout(millsStopEnginePanelLayout);
                    JLabel stopLabel = new JLabel("tuProlog will stop solving after");
                    millsStopEnginePanel.add(stopLabel);
                    millsStopEngineTextField.setPreferredSize(new Dimension(50, 20));
                    millsStopEngineTextField.setHorizontalAlignment(JTextField.RIGHT);
                    millsStopEnginePanel.add(millsStopEngineTextField);
                    JLabel msLabel = new JLabel("ms");
                    millsStopEnginePanel.add(msLabel);

                    engineOptionPanel.add(millsStopEnginePanel);
                }
                {
                    JPanel notifyExceptionPanel = new JPanel();
                    FlowLayout notifyExceptionPanelLayout = new FlowLayout();
                    notifyExceptionPanelLayout.setAlignment(FlowLayout.LEFT);
                    notifyExceptionPanel.setLayout(notifyExceptionPanelLayout);
                    JLabel notifyExceptionLabel = new JLabel("Notify exceptions");
                    notifyExceptionPanel.add(notifyExceptionLabel);
                    notifyExceptionPanel.add(notifyExceptionCheckBox);

                    engineOptionPanel.add(notifyExceptionPanel);
                }

                c.add(engineOptionPanel, BorderLayout.CENTER);
            }

            //Ok Cancel Panel
            {
                JPanel okCancelPanel = new JPanel();
                ok.setPreferredSize(new Dimension(80, 32));
                cancel.setPreferredSize(new Dimension(80, 32));
                okCancelPanel.add(ok);
                okCancelPanel.add(cancel);

                c.add(okCancelPanel, BorderLayout.SOUTH);
            }
        }
        /**/

        reload();
        pack();
    }

    public void reload() {
        if (selectDisplayModality == 0) {
            inColumnsRadioButton.setSelected(true);
        }
        if (selectDisplayModality == 1) {
            inRowsRadioButton.setSelected(true);
        }
        if (selectDisplayModality == 2) {
            inRowsVariableSeparatedRadioButton.setSelected(true);
        }
        millsStopEngineTextField.setText("" + millsStopEngine);
        /*Castagna 06/2011*/
        notifyExceptionCheckBox.setSelected(enableNotifyException);
        /**/
    }

    public void ok() {
        setFontDimension();

        if (inColumnsRadioButton.isSelected()) {
            setSelectDisplayModality(0);
        }
        if (inRowsRadioButton.isSelected()) {
            setSelectDisplayModality(1);
        }
        if (inRowsVariableSeparatedRadioButton.isSelected()) {
            setSelectDisplayModality(2);
        }

        /*Castagna 06/2011*/
        setNotifyExceptionEvent(notifyExceptionCheckBox.isSelected());
        /**/

        boolean close = true;
        try {
            setMillsStopEngine(Integer.parseInt(millsStopEngineTextField.getText()));
        } catch (NumberFormatException e) {
            close = false;
        }
        if (close) {
            onClose();
        }
    }

    public void cancel() {
        onClose();
    }

    public void addPropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.removePropertyChangeListener(listener);
    }

    public int getMillsStopEngine() {
        return millsStopEngine;
    }

    public void setMillsStopEngine(int newValue) {
        int oldValue = millsStopEngine;
        millsStopEngine = newValue;
        propertyChangeSupport.firePropertyChange("millsStopEngine", oldValue, newValue);
    }

    public int getSelectDisplayModality() {
        return selectDisplayModality;
    }

    public void setSelectDisplayModality(int newValue) {
        int oldValue = selectDisplayModality;
        selectDisplayModality = newValue;
        propertyChangeSupport.firePropertyChange("selectDisplayModality", oldValue, newValue);
    }

    /*Castagna 06/2011*/
    public void setNotifyExceptionEvent(boolean newValue) {
        boolean oldValue = enableNotifyException;
        enableNotifyException = newValue;
        propertyChangeSupport.firePropertyChange("notifyExceptionEvent", oldValue, newValue);
    }
    /**/

    private void decFontDimension() {
        if ((Integer.parseInt(fontDimensionTextField.getText())) != 1) {
            fontDimensionHandler.decFontDimension();
            fontDimensionTextField.setText("" + fontDimensionHandler.getFontDimension());
        }
    }

    private void setFontDimension() {
        int dim;
        try {
            dim = Integer.parseInt(fontDimensionTextField.getText());
        } catch (NumberFormatException e) {
            dim = fontDimensionHandler.getFontDimension();
        }
        if (dim < 1) {
            fontDimensionHandler.setFontDimension(1);
            fontDimensionTextField.setText("" + fontDimensionHandler.getFontDimension());
        } else if (dim > 99) {
            fontDimensionHandler.setFontDimension(99);
            fontDimensionTextField.setText("" + fontDimensionHandler.getFontDimension());
        } else {
            fontDimensionHandler.setFontDimension(dim);
        }
    }

    private void incFontDimension() {
        if ((Integer.parseInt(fontDimensionTextField.getText())) != 99) {
            fontDimensionHandler.incFontDimension();
            fontDimensionTextField.setText("" + fontDimensionHandler.getFontDimension());
        }
    }

}
