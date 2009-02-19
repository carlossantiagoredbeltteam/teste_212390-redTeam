For online docs and install instructions, see here:

http://objects.reprap.org/wiki/Builders/Metalab/AoI_CSG_Evaluator

HOWTO build from source:

0) Check out reprap/miscellaneous/AoI/plugins

1) Edit build.properties: Set this dir to point to your AOI install dir (this dir should
  contain artofillusion.jar)
  aoidir=/Applications/Art of Illusion

2) ant -f CSGEvaluator.xml

3) Copy or symlink Plugins/CSGEvaluator.jar from your AoI plugin dir.
