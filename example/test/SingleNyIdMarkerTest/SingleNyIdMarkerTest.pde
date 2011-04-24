/*
  SingleNyIdMarker class function test program

*/
import processing.video.*;
import processing.core.*;
import jp.nyatla.nyar4psg.*;

PFont font=createFont("FFScala", 32);
Capture cam;
SingleNyIdMarker nya;

void setup() {
  size(640,480,P3D);
  colorMode(RGB, 100);
  cam=new Capture(this,width,height);
  nya=new SingleNyIdMarker(this,width,height,"camera_para.dat"); //SingleMarker検出インスタンス
  nya.setIdMarkerSize(80);
  print(nya.VERSION); //バージョンの表示
}
int c=0;
void draw() {
  c++;
  if (cam.available() !=true) {
    return;
  }
  background(255);
  cam.read();
  hint(DISABLE_DEPTH_TEST);
  image(cam,0,0);
  hint(ENABLE_DEPTH_TEST);
  switch(nya.detect(cam)){
  case SingleNyIdMarker.ST_NOMARKER:
    return;
  case SingleNyIdMarker.ST_NEWMARKER:
    println("Marker found.");
    return;
  case SingleNyIdMarker.ST_UPDATEMARKER:
    break;
  case SingleNyIdMarker.ST_REMOVEMARKER:
    println("Marker removed.");
    return;
  default:
    return;
  }
  nya.beginTransform();//マーカ座標系に設定
  {
    setMatrix(nya.getMarkerMatrix());//マーカ姿勢をセット
    drawBox();
    drawMarkerXYPos();
  }
  nya.endTransform();  //マーカ座標系を終了
  drawMarkerPatt();
  drawVertex();
  
}
void drawBox()
{
  pushMatrix();
  fill(0);
  stroke(255,200,0);
  translate(0,0,20);
  box(40);
  noFill();
  translate(0,0,-20);
  rect(-40,-40,80,80); 
  popMatrix();
}

//この関数は、マーカパターンを描画します。
void drawMarkerPatt()
{
  PImage p=nya.pickupMarkerImage(40,40,-40,40,-40,-40,40,-40,100,100);
  image(p,0,0);
}

//この関数は、マーカ平面上の点を描画します。
void drawMarkerXYPos()
{
  pushMatrix();
    PVector pos=nya.screen2MarkerCoordSystem(mouseX,mouseY);
    translate(pos.x,pos.y,0);
    noFill();
    stroke(0,0,100);
    ellipse(0,0,20-c%20,20-c%20);
  popMatrix();
}

//この関数は、マーカ頂点の情報を描画します。
void drawVertex()
{
  PVector[] i_v=nya.getMarkerVertex2D();
  textFont(font,10.0);
  stroke(100,0,0);
  for(int i=0;i<4;i++){
    fill(100,0,0);
    ellipse(i_v[i].x,i_v[i].y,6,6);
    fill(0,0,0);
    text("("+i_v[i].x+","+i_v[i].y+")",i_v[i].x,i_v[i].y);
  }
}


