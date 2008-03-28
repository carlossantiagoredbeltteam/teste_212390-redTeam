/*
 * BotConsoleFrame.java
 *
 * Created on 28 March 2008, 08:35
 */

package org.reprap.gui.botConsole;

/**
 *
 * @author  en0es
 */
public class BotConsoleFrame extends javax.swing.JFrame {
    
    /** Creates new form BotConsoleFrame */
    public BotConsoleFrame() {
        initComponents();
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTabbedPane1 = new javax.swing.JTabbedPane();
        printTabPanel1 = new org.reprap.gui.botConsole.PrintTabPanel();
        xYZTabPanel1 = new org.reprap.gui.botConsole.XYZTabPanel();
        genericExtruderTabPanel1 = new org.reprap.gui.botConsole.GenericExtruderTabPanel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTabbedPane1.addTab("Print", printTabPanel1);
        jTabbedPane1.addTab("XYZ", xYZTabPanel1);
        jTabbedPane1.addTab("Extruder #X", genericExtruderTabPanel1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 680, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new BotConsoleFrame().setVisible(true);
            }
        });
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private org.reprap.gui.botConsole.GenericExtruderTabPanel genericExtruderTabPanel1;
    private javax.swing.JTabbedPane jTabbedPane1;
    private org.reprap.gui.botConsole.PrintTabPanel printTabPanel1;
    private org.reprap.gui.botConsole.XYZTabPanel xYZTabPanel1;
    // End of variables declaration//GEN-END:variables
    
}
