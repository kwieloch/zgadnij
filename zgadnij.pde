
boolean pointInRect(float a, float b, float x, float y, float w, float h) {
   return (a >= x && a <= x + w) && (b >= y && b <= y + h);
}

import java.util.Map;
import java.util.Collections;


class Point {
  public float x;
  public float y;
  Point(float x, float y) {
    this.x = x; 
    this.y = y;
  }
};

class Grid {
  int rows;
  int cols;
  ArrayList<PImage> images;
  ArrayList<String> imagenames;
  ArrayList<Point> imagepoints;
  int iwidth;
  int iheight;
  int hspacing;
  int vspacing;
  Point origin;

  Grid() {
    images = new ArrayList<PImage>();
    imagenames = new ArrayList<String>();
    imagepoints = new ArrayList<Point>();
  }

  Grid(int rows, int cols, int iwidth, int iheight, Point origin, int hspacing, int vspacing) {
    this.rows = rows;
    this.cols = cols; 
    this.iwidth = iwidth;
    this.iheight = iheight;
    this.origin = origin;
    this.hspacing = hspacing;
    this.vspacing = vspacing;
    images = new ArrayList<PImage>();
    imagepoints = new ArrayList<Point>();
  }

  void addimage (PImage i) {
    images.add(i);
  }
  
  void removeimages () {
    images = new ArrayList<PImage>(); 
  }

  void setimagedimmensions(int w, int h) {
    iwidth = w;
    iheight = h;
  }

  void setlayout(int r, int c) {
    rows = r;
    cols = c;
  }

  int getsizex() {
    return cols*iwidth + (cols-1)*hspacing;
  }

  int getsizey() {
    return rows*iheight + (rows-1)*vspacing;
  }

  void arrange() {
    float noslots = rows * cols;
    for (int i=0; i < noslots; ++i) {
      float rn = i/cols;
      float cn = i%cols;
      float y = rn*(iheight+vspacing)+origin.y;
      float x = cn*(iwidth+hspacing)+origin.x;
      Point p = new Point(x,y);
      imagepoints.add(p);
    }
  }

  int getimagebypoint(float x, float y) {
    for (int i = 0; i < imagepoints.size(); ++i) {
      if (pointInRect(x, y, imagepoints.get(i).x, imagepoints.get(i).y, iwidth, iheight)) {
        return i;
      }
    }
    return -1;
  }

  void render() {
    PImage im;
    for (int i = 0; i<images.size(); ++i) {
      im = images.get(i);
      Point p = imagepoints.get(i);
      image(im, p.x, p.y, iwidth, iheight);
      //rect(p.x, p.y, iwidth, iheight);
    }
  }
  
  void wrong(int i) {
      fill(255,255,255);
      noStroke();
      Point p = imagepoints.get(i);
      rect(p.x, p.y, iwidth, iheight);     
  }
  
  void rende2r() {
    image(images.get(0),20,20);
  }
}


ArrayList<PImage> allimages;
ArrayList<String> alltexts;
Grid G;
String label;
int rightimage;
int nrandom = 3;
boolean bDisplayMessage = false;
int startTime;
final int DISPLAY_DURATION = 2000;
int selection;
int ok = 1;


void setrandom(Grid g) {
  int chosen[] = new int[nrandom];
  ArrayList<Integer> all = new ArrayList<Integer>(); //int[allimages.size()];
  for (int i = 0; i < allimages.size(); ++i) all.add(i,i);
  Collections.shuffle(all);
  g.removeimages();
  for (int i = 0; i<nrandom; ++i) {
    //int r = int(random(0, allimages.size()));
    int r = all.get(i);
    chosen[i] = r;
    g.addimage(allimages.get(r));
  }
  rightimage = int(random(0,nrandom));
  label = alltexts.get(chosen[rightimage]);
}

import sprites.utils.*;
import sprites.*;

void setup() {
  println(dataPath(""));
    allimages = new ArrayList<PImage>();
    alltexts = new ArrayList<String>();
    String lines[] = loadStrings("list.txt");
    for (int i = 0 ; i < lines.length; i++) {
        String parts[] = lines[i].split("#");
        allimages.add(loadImage(parts[0]));
        alltexts.add(parts[1]);
    }

    size(displayWidth,displayHeight);
    //size(800,600);

    float imageratio = 3.0/4.0; 
    int rows = 1;
    int cols = nrandom;
    int hspacing = 10;
    int vspacing = 10;
    int iwidth = (width-2*hspacing-(cols-1)*hspacing)/cols;
    int iheight =  int( imageratio*iwidth );
    int gbox_width = cols*iwidth + (cols-1)*hspacing + 2*hspacing;
    int gbox_height = rows*iheight + (rows-1)*vspacing +2*vspacing;
    int gbox_x = (width - gbox_width)/2 + hspacing;
    int gbox_y = height/2 + (height/2-gbox_height)/2 + vspacing;

    // println(rows,cols);
    // println(iwidth,iheight);
    // println(gbox_width,gbox_height);
    // println(gbox_x,gbox_y);

    G = new Grid(rows,cols,iwidth,iheight,new Point( gbox_x ,gbox_y),hspacing,vspacing);
    G.arrange();
    setrandom(G);
    drawtask();
};

void drawtask() {
    background(255,255,255);
    
    int tsize = height/3;
    if (textWidth(label) < width -20 ) {
      ;
    } else {
      while (textWidth(label) >= width - 20) {
        textSize(--tsize); 
      }
    }
    
    textSize(tsize);
    fill(255,0,0);
    textAlign(CENTER,CENTER);
    text(label,width/2,height/4);
    G.render();
}

void draw() {
    if (bDisplayMessage) {
        background(255,255,255);
        textSize(height/2);
        textAlign(CENTER,CENTER);
        fill(255,0,0);
        text("\u263A", width/2 ,height/2);
        if (millis() - startTime > DISPLAY_DURATION) {
            bDisplayMessage = false;
            setrandom(G);
            drawtask();
        }
    }
}

void mousePressed() {
    if (!bDisplayMessage) {
        selection = G.getimagebypoint(mouseX,mouseY);
        if (selection == rightimage) {
            bDisplayMessage = true;
            startTime = millis();
        } else if (selection > -1) {
            G.wrong(selection); 
        }
    }
}






