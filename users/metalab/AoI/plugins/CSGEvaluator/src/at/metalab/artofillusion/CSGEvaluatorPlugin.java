package at.metalab.artofillusion;

import java.awt.event.KeyEvent;

import artofillusion.Plugin;
import artofillusion.keystroke.KeystrokeManager;
import artofillusion.keystroke.KeystrokeRecord;

public class CSGEvaluatorPlugin implements Plugin
{
  public void processMessage(int message, Object args[]) {
    if (message == Plugin.APPLICATION_STARTING) {
      KeystrokeManager.addRecord(new KeystrokeRecord(KeyEvent.VK_C, 0, "CSG Evaluator",
          "ModellingTool plugin = (ModellingTool)" +
          "PluginRegistry.getPluginObject(\"at.metalab.artofillusion.CSGEvaluatorTool\");" +
          "plugin.commandSelected(window);"));
    }
    else if (message == Plugin.SCENE_WINDOW_CREATED) {
    }
  }
}
