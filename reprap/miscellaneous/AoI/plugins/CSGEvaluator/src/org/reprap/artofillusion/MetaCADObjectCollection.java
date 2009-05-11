package org.reprap.artofillusion;

import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import artofillusion.Scene;
import artofillusion.animation.Keyframe;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectCollection;
import artofillusion.object.ObjectInfo;
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;

/** Used to display Groups of Objects that arise for example in a cs node
 * shamelessly ripped  from:  ExternalObject:ExternalObjectCollection 
 * which I would have used if it was public */

public class MetaCADObjectCollection extends ObjectCollection
{
  private List<ObjectInfo> objects;

  public MetaCADObjectCollection(List<ObjectInfo> objects)
  {
    this.objects = objects;
  }

  protected Enumeration enumerateObjects(ObjectInfo info, boolean interactive, Scene scene)
  {
    return Collections.enumeration(this.objects);
  }

  public Object3D duplicate()
  {
    return new MetaCADObjectCollection(this.objects);
  }

  public void copyObject(Object3D obj)
  {
    this.objects = ((MetaCADObjectCollection) obj).objects;
  }

  public void setSize(double xsize, double ysize, double zsize)
  {
  }

  public Keyframe getPoseKeyframe()
  {
    return null;
  }

  public void applyPoseKeyframe(Keyframe k)
  {
  }
  
  public void setTexture(Texture tex, TextureMapping map)
  {
    for (ObjectInfo info : this.objects) {
      info.object.setTexture(tex, map);
    }
    super.setTexture(tex, map);
  }
}