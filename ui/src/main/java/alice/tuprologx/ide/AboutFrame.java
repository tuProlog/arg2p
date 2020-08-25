package alice.tuprologx.ide;

import alice.tuprolog.Prolog;

import javax.swing.*;
import java.awt.*;
import java.net.URL;

public class AboutFrame extends GenericFrame {
    private static final long serialVersionUID = 1L;

    public AboutFrame(JFrame mainWindow) {
        super("About tuProlog", mainWindow, 275, 135, true, true);
        initComponents();
    }

    private void initComponents() {
        Container c = this.getContentPane();
        JLabel icon = new JLabel();
        URL urlImage = getClass().getResource("img/tuProlog.gif");
        icon.setIcon(new ImageIcon(Toolkit.getDefaultToolkit().getImage(urlImage)));

        JLabel versionSystem = new JLabel(" tuProlog engine version " + Prolog.getVersion());

        //String platformMessage = " " + alice.util.VersionInfo.getPlatform();
        //platformMessage += " platform version ";
        //platformMessage += alice.util.VersionInfo.getCompleteVersion();
        JLabel versionIDE = new JLabel(" tuProlog for " + alice.util.VersionInfo.getPlatform() + " version " +
                                       alice.util.VersionInfo.getCompleteVersion() + "   ");
        JLabel copyright = new JLabel(" \u00a9 2001-2020 @ Apice Research Group");
        JLabel unibo = new JLabel(" Alma Mater Studiorum-Universita' di Bologna");
        JLabel country = new JLabel(" Italy");
        JLabel url = new JLabel("http://tuprolog.unibo.it");
        url.setFont(new Font("Courier New", Font.PLAIN, 12));

        c.setLayout(new GridBagLayout());
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.weightx = 1;
        constraints.weighty = 1;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.gridwidth = GridBagConstraints.REMAINDER;
        c.add(icon, constraints);
        constraints.gridy = 1;
        c.add(versionSystem, constraints);
        constraints.gridy = 2;
        c.add(versionIDE, constraints);
        constraints.gridy = 3;
        c.add(copyright, constraints);
        constraints.gridy = 4;
        c.add(unibo, constraints);
        constraints.gridy = 5;
        c.add(country, constraints);
        constraints.gridy = 6;
        c.add(url, constraints);
        pack();
        setVisible(true);
    }
}
