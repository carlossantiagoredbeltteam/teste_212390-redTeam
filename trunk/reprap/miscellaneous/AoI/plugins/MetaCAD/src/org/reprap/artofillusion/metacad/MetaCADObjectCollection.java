package org.reprap.artofillusion.metacad;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InvalidObjectException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import artofillusion.ArtOfIllusion;
import artofillusion.Scene;
import artofillusion.animation.Keyframe;
import artofillusion.math.CoordinateSystem;
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
  
  public void writeToFile(DataOutputStream out, Scene theScene) throws IOException
  {
    // inspired by CSGObject.writeToFile
    super.writeToFile(out, theScene);
    
    out.writeShort(0);
    
    // how many objects do we have?
    out.writeInt(this.objects.size());
    // serializing all the ObjectInfos in the collection
    for (ObjectInfo objInfo : this.objects)
    {
      objInfo.getCoords().writeToFile(out);
      out.writeUTF(objInfo.getName());
      out.writeUTF(objInfo.getObject().getClass().getName());
      objInfo.getObject().writeToFile(out, theScene);
    }
  }
  
  public MetaCADObjectCollection(DataInputStream in, Scene theScene) throws IOException, 
  InvalidObjectException
  {
    // inspired by CSGObject.CSGObject(DataInputStream in, Scene theScene)
    super(in, theScene);

    short version = in.readShort();
    if (version != 0)
      throw new InvalidObjectException("");

    int objectSize = in.readInt();
    try {
      this.objects = new ArrayList<ObjectInfo>(objectSize);
      // deserializing all the ObjectInfos in the collection
      for (int i = 0; i < objectSize; i++)
      {
        ObjectInfo objInfo;
        objInfo = new ObjectInfo(null, new CoordinateSystem(in), in.readUTF());
        Class cls = ArtOfIllusion.getClass(in.readUTF());
        Constructor con = cls.getConstructor(DataInputStream.class, Scene.class);
        objInfo.setObject((Object3D) con.newInstance(in, theScene));
        
        if  (getTexture() !=  null && objInfo.getObject().getTexture() == null)
        {
          objInfo.getObject().setTexture(getTexture(), getTextureMapping());
        }
        if (getMaterial() != null && objInfo.getObject().getMaterial() == null)
        {
          objInfo.getObject().setMaterial(getMaterial(), getMaterialMapping());
        }
        this.objects.add(objInfo);
      }
    }
    catch (InvocationTargetException ex)
    {
      ex.getTargetException().printStackTrace();
      throw new IOException();
    }
    catch (Exception ex) 
    {
      ex.printStackTrace();
      throw new IOException();
    }
  }
  
  protected Enumeration enumerateObjects(ObjectInfo info, boolean interactive, Scene scene)
  {
    return Collections.enumeration(this.objects);
  }

  public Object3D duplicate()
  {
    Object3D obj = new MetaCADObjectCollection(this.objects);
    obj.copyTextureAndMaterial(this);
    return obj;
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
    // need this check to prevent null pointer exception while loading
    if (this.objects != null)
    {
      for (ObjectInfo info : this.objects) {
        Texture existingTex = info.object.getTexture();
        TextureMapping existingMap = info.object.getTextureMapping();
        
        if (existingTex == null) {
          info.object.setTexture(tex, map);
        }
        
  
      }
    }
    super.setTexture(tex, map);
  }
}