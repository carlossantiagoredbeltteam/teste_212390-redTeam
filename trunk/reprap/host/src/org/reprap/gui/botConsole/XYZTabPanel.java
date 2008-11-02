/*
 * XYZTabPanel.java
 *
 * Created on June 30, 2008, 9:15 PM
 */

package org.reprap.gui.botConsole;

import java.io.IOException;
import javax.swing.JOptionPane;
import org.reprap.Preferences;
import org.reprap.Printer;
/**
 *
 * @author  ensab
 */
public class XYZTabPanel extends javax.swing.JPanel {
    private double XYfastSpeed;
    private double ZfastSpeed;
    private Printer printer;
    private static double nudgeSize = 0;
    
    private void setPrefs() throws IOException {
        
        //XYfastSpeed = Preferences.loadGlobalInt("FastSpeed(0..255)");
        //ZfastSpeed = Preferences.loadGlobalInt("MovementSpeedZ(0..255)");
    	
    	XYfastSpeed = printer.getFastFeedrateXY();
    	ZfastSpeed = printer.getFastFeedrateZ();
        
        xySpeedField.setText(String.valueOf(XYfastSpeed));
        zSpeedField.setText(String.valueOf(ZfastSpeed));
    }
    
    public void setMotorSpeeds() {
        
        xStepperPositionJPanel.setSpeed();
        yStepperPositionJPanel.setSpeed();
        zStepperPositionJPanel.setSpeed();
        
    }
    
    public void checkNudgeSize() {
        if (nudgeSize == 0) {
            nudgeSizeRB1.setSelected(true);
            nudgeSize = Double.parseDouble(nudgeSizeRB1.getText());
        }
    }
    
    public void setNudgeSize(Double size) {
        
        nudgeSize = size;
        
        xStepperPositionJPanel.setNudgeSize(nudgeSize);
        yStepperPositionJPanel.setNudgeSize(nudgeSize);
        zStepperPositionJPanel.setNudgeSize(nudgeSize);
    }
    
    /** Creates new form XYZTabPanel */
    public XYZTabPanel() {
        printer = org.reprap.Main.gui.getPrinter();
        initComponents();
        try
        {
            setPrefs();
            xStepperPositionJPanel.postSetUp(1);
            yStepperPositionJPanel.postSetUp(2);
            zStepperPositionJPanel.postSetUp(3);
        } catch (Exception ex) {System.err.println(ex.toString());}
        setMotorSpeeds();
        setNudgeSize(Double.parseDouble(nudgeSizeRB1.getText()));
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        nudgePanel = new javax.swing.JPanel();
        nudgeSizeRB1 = new javax.swing.JRadioButton();
        nudgeSizeRB2 = new javax.swing.JRadioButton();
        nudgeSizeRB3 = new javax.swing.JRadioButton();
        motorsPanel = new javax.swing.JPanel();
        homeAllButton = new javax.swing.JButton();
        storeAllButton = new javax.swing.JButton();
        recallAllButton = new javax.swing.JButton();
        goButton = new javax.swing.JButton();
        xStepperPositionJPanel = new org.reprap.gui.botConsole.StepperPositionJPanel();
        yStepperPositionJPanel = new org.reprap.gui.botConsole.StepperPositionJPanel();
        zStepperPositionJPanel = new org.reprap.gui.botConsole.StepperPositionJPanel();
        speedsPanel = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        xySpeedField = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        zSpeedField = new javax.swing.JTextField();
        plotExtruderCheck = new javax.swing.JCheckBox();
        extruderToPlotWith = new javax.swing.JTextField();

        nudgePanel.setBorder(javax.swing.BorderFactory.createTitledBorder("Nudge size (mm)"));

        buttonGroup1.add(nudgeSizeRB1);
        nudgeSizeRB1.setSelected(true);
        nudgeSizeRB1.setText("0.1");
        nudgeSizeRB1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nudgeSizeRB1ActionPerformed(evt);
            }
        });

        buttonGroup1.add(nudgeSizeRB2);
        nudgeSizeRB2.setText("1.0");
        nudgeSizeRB2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nudgeSizeRB2ActionPerformed(evt);
            }
        });

        buttonGroup1.add(nudgeSizeRB3);
        nudgeSizeRB3.setText("10.0");
        nudgeSizeRB3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nudgeSizeRB3ActionPerformed(evt);
            }
        });

        org.jdesktop.layout.GroupLayout nudgePanelLayout = new org.jdesktop.layout.GroupLayout(nudgePanel);
        nudgePanel.setLayout(nudgePanelLayout);
        nudgePanelLayout.setHorizontalGroup(
            nudgePanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(nudgePanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(nudgeSizeRB1)
                .add(18, 18, 18)
                .add(nudgeSizeRB2)
                .add(18, 18, 18)
                .add(nudgeSizeRB3)
                .addContainerGap(org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        nudgePanelLayout.setVerticalGroup(
            nudgePanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(org.jdesktop.layout.GroupLayout.TRAILING, nudgePanelLayout.createSequentialGroup()
                .addContainerGap(14, Short.MAX_VALUE)
                .add(nudgePanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(nudgeSizeRB1)
                    .add(nudgeSizeRB2)
                    .add(nudgeSizeRB3)))
        );

        motorsPanel.setBorder(javax.swing.BorderFactory.createTitledBorder("Axis positions"));

        homeAllButton.setText("Home all");
        homeAllButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                homeAllButtonActionPerformed(evt);
            }
        });

        storeAllButton.setText("Sto all");
        storeAllButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                storeAllButtonActionPerformed(evt);
            }
        });

        recallAllButton.setText("Rcl all");
        recallAllButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                recallAllButtonActionPerformed(evt);
            }
        });

        goButton.setText("Go");
        goButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                goButtonActionPerformed(evt);
            }
        });

        org.jdesktop.layout.GroupLayout motorsPanelLayout = new org.jdesktop.layout.GroupLayout(motorsPanel);
        motorsPanel.setLayout(motorsPanelLayout);
        motorsPanelLayout.setHorizontalGroup(
            motorsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(motorsPanelLayout.createSequentialGroup()
                .add(motorsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(motorsPanelLayout.createSequentialGroup()
                        .add(23, 23, 23)
                        .add(goButton)
                        .add(121, 121, 121)
                        .add(homeAllButton)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(storeAllButton)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(recallAllButton))
                    .add(xStepperPositionJPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                    .add(yStepperPositionJPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                    .add(zStepperPositionJPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(24, Short.MAX_VALUE))
        );
        motorsPanelLayout.setVerticalGroup(
            motorsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(org.jdesktop.layout.GroupLayout.TRAILING, motorsPanelLayout.createSequentialGroup()
                .add(xStepperPositionJPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(yStepperPositionJPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(zStepperPositionJPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(motorsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(goButton)
                    .add(recallAllButton)
                    .add(storeAllButton)
                    .add(homeAllButton))
                .addContainerGap())
        );

        speedsPanel.setBorder(javax.swing.BorderFactory.createTitledBorder("Axis speeds (mm/min)"));

        jLabel2.setFont(new java.awt.Font("Tahoma", 0, 12));
        jLabel2.setText("X & Y");

        xySpeedField.setColumns(4);
        xySpeedField.setFont(new java.awt.Font("Tahoma", 0, 12));
        xySpeedField.setText("0000");

        jLabel3.setFont(new java.awt.Font("Tahoma", 0, 12));
        jLabel3.setText("Z");

        zSpeedField.setColumns(4);
        zSpeedField.setFont(new java.awt.Font("Tahoma", 0, 12));
        zSpeedField.setText("0000");

        org.jdesktop.layout.GroupLayout speedsPanelLayout = new org.jdesktop.layout.GroupLayout(speedsPanel);
        speedsPanel.setLayout(speedsPanelLayout);
        speedsPanelLayout.setHorizontalGroup(
            speedsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(speedsPanelLayout.createSequentialGroup()
                .add(jLabel2)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(xySpeedField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .add(18, 18, 18)
                .add(jLabel3)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(zSpeedField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
        );
        speedsPanelLayout.setVerticalGroup(
            speedsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(speedsPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                .add(jLabel2)
                .add(jLabel3)
                .add(zSpeedField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .add(xySpeedField, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
        );

        plotExtruderCheck.setText("Plot using Extruder #");

        extruderToPlotWith.setColumns(1);
        extruderToPlotWith.setText("0");

        org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
                        .addContainerGap()
                        .add(nudgePanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                        .add(2, 2, 2)
                        .add(speedsPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.UNRELATED)
                        .add(plotExtruderCheck)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(extruderToPlotWith, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                        .add(235, 235, 235))
                    .add(motorsPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(motorsPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 226, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(layout.createSequentialGroup()
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(nudgePanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                    .add(layout.createSequentialGroup()
                        .add(14, 14, 14)
                        .add(speedsPanel, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 43, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                    .add(layout.createSequentialGroup()
                        .add(18, 18, 18)
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                            .add(extruderToPlotWith, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                            .add(plotExtruderCheck))))
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents

private void nudgeSizeRB1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nudgeSizeRB1ActionPerformed
    setNudgeSize(Double.parseDouble(nudgeSizeRB1.getText()));
}//GEN-LAST:event_nudgeSizeRB1ActionPerformed

private void nudgeSizeRB2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nudgeSizeRB2ActionPerformed
    setNudgeSize(Double.parseDouble(nudgeSizeRB2.getText()));
}//GEN-LAST:event_nudgeSizeRB2ActionPerformed

private void nudgeSizeRB3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nudgeSizeRB3ActionPerformed
    setNudgeSize(Double.parseDouble(nudgeSizeRB3.getText()));
}//GEN-LAST:event_nudgeSizeRB3ActionPerformed

private void homeAllButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_homeAllButtonActionPerformed
    xStepperPositionJPanel.homeAxis();
    yStepperPositionJPanel.homeAxis();
    zStepperPositionJPanel.homeAxis();
}//GEN-LAST:event_homeAllButtonActionPerformed

public void storeAll()
{
    xStepperPositionJPanel.store();
    yStepperPositionJPanel.store();
    zStepperPositionJPanel.store();	
}

private void storeAllButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_storeAllButtonActionPerformed
	storeAll();
}//GEN-LAST:event_storeAllButtonActionPerformed

public void recallAll()
{
    xStepperPositionJPanel.recall();
    yStepperPositionJPanel.recall();
    zStepperPositionJPanel.recall(); 	
}

private void recallAllButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_recallAllButtonActionPerformed
	recallAll();
}//GEN-LAST:event_recallAllButtonActionPerformed

private void goButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_goButtonActionPerformed
	double x = printer.getX();
	double y = printer.getY();
	double z = printer.getZ();
	double xTo = xStepperPositionJPanel.getTargetPositionInMM();
	double yTo = yStepperPositionJPanel.getTargetPositionInMM();
	double zTo = zStepperPositionJPanel.getTargetPositionInMM();

	try
	{
		if(z >= zTo)
		{
			printer.setFeedrate(Double.parseDouble(xySpeedField.getText()));
			printer.moveTo(xTo, yTo, z, false, false);
			printer.setFeedrate(Double.parseDouble(zSpeedField.getText()));
			printer.moveTo(xTo, yTo, zTo, false, false);
		} else
		{
			printer.setFeedrate(Double.parseDouble(zSpeedField.getText()));
			printer.moveTo(x, y, zTo, false, false);
			printer.setFeedrate(Double.parseDouble(xySpeedField.getText()));
			printer.moveTo(xTo, yTo, zTo, false, false);	
		}
	} catch (Exception e)
	{}
}//GEN-LAST:event_goButtonActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JTextField extruderToPlotWith;
    private javax.swing.JButton goButton;
    private javax.swing.JButton homeAllButton;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JPanel motorsPanel;
    private javax.swing.JPanel nudgePanel;
    private javax.swing.JRadioButton nudgeSizeRB1;
    private javax.swing.JRadioButton nudgeSizeRB2;
    private javax.swing.JRadioButton nudgeSizeRB3;
    private javax.swing.JCheckBox plotExtruderCheck;
    private javax.swing.JButton recallAllButton;
    private javax.swing.JPanel speedsPanel;
    private javax.swing.JButton storeAllButton;
    private org.reprap.gui.botConsole.StepperPositionJPanel xStepperPositionJPanel;
    public static javax.swing.JTextField xySpeedField;
    private org.reprap.gui.botConsole.StepperPositionJPanel yStepperPositionJPanel;
    public static javax.swing.JTextField zSpeedField;
    private org.reprap.gui.botConsole.StepperPositionJPanel zStepperPositionJPanel;
    // End of variables declaration//GEN-END:variables

}