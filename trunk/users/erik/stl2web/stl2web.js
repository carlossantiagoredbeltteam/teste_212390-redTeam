/* stl2web.js - image sequence viewer. 
 *   Part of STL2Web. A 3D object viewer and composing system.
 *   by Erik de Bruijn
 *   Licence: GPLv3. See: http://www.gnu.org/copyleft/gpl.html
 *   
 *   Changes:
 *   v0.1	2009-03-29	First version (Can walk through a one-dimensional numbered sequence (pre-built animation).
 *   TODOs:
 *   - distributed rendering system (sort this out server side, use lowest latency server, write to cookie)
 *   - controls
 *   - playback & record movement paths (fly over object, highlight a detail, etc.)
 *   - set object color (and perhaps even the material PLA,ABS, etc.)
 *   - scene customization: 
 *       bg color, shadow on/off, grid on/off, put the rendering on top of a tabletop, put pencil besides it, etc.
 *   - STL upload and fetching feature (e.g. fetch from thingiverse)
 *   - Download/export as movie/.mjpeg/ani-gif?, etc.
 *   - Allow various image sizes
 */

var r;

$(document).ready(function(){


ri = 'Wineglass';
r= new Renderer(ri,'/stl2web/img/');
//r.debug = true;
r.setFrameRate(2);
r.animate(0,30);

i = $(".s2wi");
});

function Renderer(ri,ipfx)
{

// renderer values
var frame = 0;
var frameInterval = 10; //binding
var frameRate = 5; //non binding
var startFrame = 0;
var stopFrame = 4;
var interval; // used to keep track of the setInterval() thread
var debug = false;
var imgPrefix = '/stl2web/img/';

// define function
this.toggleDebug = toggleDebug;
this.setFrameRate = rSetFrameRate;
this.animate = rAnimate;
this.pause = rPause;
this.resume = rResume;
this.showFrame = rShowFrame;   
this.nextFrame = rNextFrame;
this.log = log;
this.reset = rReset;


if(ipfx) this.imgPrefix = ipfx;
this.log(ipfx);
this.reset();

}

function log(str)
{
if(this.debug) console.log(str);
}
function rSetFrameRate(frameRate)
{
  this.frameRate = frameRate;
  this.frameInterval = 1000/frameRate;
}
/* Reset or initialize the rendering */
function rReset()
{
  $("div.stl2web").text(' '); // empty it all

  // populate it
  //$("div.stl2web").append("<img class='s2wi' src='"+this.imgPrefix+ri+"0.png'/>");
  $("div.stl2web").append("<img class='s2wi'/>");
  $("div.stl2web").append("<div class='s2wLabel'>"+ri+" (Loading...)</div>")
    .append("<a href='javascript:r.pause()'>pause</a> ")
    .append("<a href='javascript:r.resume()'>resume</a> ")
    .append("<a href='javascript:r.reset()'>reset</a> ")
    .append("<a href='javascript:r.toggleDebug();'>debug</a> ")
    .append("FPS: <input type='textfield' value='"+this.frameRate+"' onblur='r.setFrameRate(this.value);r.pause();r.resume()'>")
  ;
   
  this.frame=this.startFrame;
  this.showFrame(this.frame);
  //this.pause();
  //this.resume();
}

function rPause(doPause)
{
  if(doPause==false) 
    this.rResume();
  clearInterval(this.interval);
}
function rResume()
{
  this.interval = window.setInterval('r.nextFrame()',this.frameInterval);
}
function rAnimate(startFrame,stopFrame)
{
  //if(startFrame>0)
  this.startFrame=startFrame;
  //if(stopFrame>0)
  this.stopFrame=stopFrame;
  this.resume(); 

  //while(this.frame<=stopFrame)
  //{
  //  this.showFrame(this.frame);
  //  this.frame++;
  //}
}
function rShowFrame(frameNr)
{
if(frameNr<10) frameNr="0"+frameNr;
  this.log("frame "+this.imgPrefix+ri+frameNr);
  $(".s2wi").attr('src',this.imgPrefix+ri+frameNr+".png");
  $("div.s2wLabel").text(ri+" ("+frameNr+"/"+this.stopFrame+")"); //div.s2wLabel").val('Frame '+frameNr);
}

function rNextFrame()
{
  if(!this.frame) this.frame = 0;
  if(this.frame >= this.stopFrame)
  {
    if(this.repeat--)
      clearInterval(this.interval);
    else this.frame = this.startFrame; // repeat
  }
  this.frame++;
  this.showFrame(this.frame);

}
function toggleDebug(val)
{
if(val==true) this.debug = true;
if(val==false) this.debug = false;
if(!val) this.debug = (!this.debug);
}
