package org.reprap.artofillusion;

import artofillusion.Plugin;

public class MetaCADEvaluatorPlugin implements Plugin
{
  public void processMessage(int message, Object args[]) {
    if (message == Plugin.APPLICATION_STARTING) {
    }
    else if (message == Plugin.SCENE_WINDOW_CREATED) {
    }
  }
}
