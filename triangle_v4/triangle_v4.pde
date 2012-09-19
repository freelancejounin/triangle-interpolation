import java.util.Arrays;
import java.awt.Color;
import javax.swing.JColorChooser;

private int[] minv = new int[5];
private int[] midv = new int[5];
private int[] maxv = new int[5];

private int[][] vs = {{-1,0,0,0,0},
                {-1,0,0,0,0},
                {-1,0,0,0,0}};

int rAtMin, rAtMid, rAtMax;
int gAtMin, gAtMid, gAtMax;
int bAtMin, bAtMid, bAtMax;

private Color c;
private boolean drawn;

void setup() {
  size(400,400);
  background(100);
  //drawTriangle();
  drawn = false;
}

void mouseClicked() {
  if (vs[0][0] == -1) {
    c = JColorChooser.showDialog(this,"Choose Color",Color.white);
    if (c != null) {
      vs[0][0] = mouseX;
      vs[0][1] = mouseY;
      vs[0][2] = c.getRed();
      vs[0][3] = c.getGreen();
      vs[0][4] = c.getBlue();
      set(mouseX,mouseY,color(vs[0][2],vs[0][3],vs[0][4]));
    }    
  }
  else {
    if (vs[1][0] == -1) {
      c = JColorChooser.showDialog(this,"Choose Color",Color.white);
      if (c != null) {
        vs[1][0] = mouseX;
        vs[1][1] = mouseY;
        vs[1][2] = c.getRed();
        vs[1][3] = c.getGreen();
        vs[1][4] = c.getBlue();
        set(mouseX,mouseY,color(vs[1][2],vs[1][3],vs[1][4]));
      } 
      
    }
    else {
      if (vs[2][0] == -1) {
        c = JColorChooser.showDialog(this,"Choose Color",Color.white);
        if (c != null) {
          vs[2][0] = mouseX;
          vs[2][1] = mouseY;
          vs[2][2] = c.getRed();
          vs[2][3] = c.getGreen();
          vs[2][4] = c.getBlue();
          set(mouseX,mouseY,color(vs[2][2],vs[2][3],vs[2][4]));
        } 
      }
      else {
        if (!drawn) {
          drawTriangle();
          drawn = true;
        }
        else {
          vs[0][0] = -1;
          vs[1][0] = -1;
          vs[2][0] = -1;
          background(100);
          drawn = false;
        }
      }
    }
  }
}

void draw() {
  
}

void drawTriangle() {
  loadPixels();
  // two dimensional array
  // array of vertices which are arrays of x,y,r,g,b values
  /*int[][] vs = {{70,70,255,0,255},
                {170,60,255,255,0},
                {150,190,0,255,255}};
  */
  // sort the array based on y value
  Arrays.sort(vs, new Comparator<int[]>() {
    public int compare(final int[] a, final int[] b) {
      int aY = a[1];
      int bY = b[1];
      return aY-bY;
    }
  });
  
  // retrieve min, mid, and max along with their colors
  minv[0] = vs[0][0];
  minv[1] = vs[0][1];
  rAtMin = vs[0][2];
  gAtMin = vs[0][3];
  bAtMin = vs[0][4];
  
  midv[0] = vs[1][0];
  midv[1] = vs[1][1];
  rAtMid = vs[1][2];
  gAtMid = vs[1][3];
  bAtMid = vs[1][4];
  
  maxv[0] = vs[2][0];
  maxv[1] = vs[2][1];
  rAtMax = vs[2][2];
  gAtMax = vs[2][3];
  bAtMax = vs[2][4];
  
  // for each scanline of the triangle
  for (int i = minv[1]; i <= maxv[1]; i++) {
    
    // variables for x,r,g,b opposite the min-max edge
    float oppX;
    float oppRed;
    float oppGreen;
    float oppBlue;
    
    // interpolate along min-mid edge or mid-max edge
    if ( i <= midv[1]) {  // min-mid
      oppX = minv[0] + (i - minv[1]) * (midv[0] - minv[0]) / (midv[1] - minv[1]);
      oppRed = rAtMin + (i - minv[1]) * (rAtMid - rAtMin) / (midv[1] - minv[1]);
      oppGreen = gAtMin + (i - minv[1]) * (gAtMid - gAtMin) / (midv[1] - minv[1]);
      oppBlue = bAtMin + (i - minv[1]) * (bAtMid - bAtMin) / (midv[1] - minv[1]);
    }
    else {  // mid-max
      oppX = midv[0] + (i - midv[1]) * (maxv[0] - midv[0]) / (maxv[1] - midv[1]);
      oppRed = rAtMid + (i - midv[1]) * (rAtMax - rAtMid) / (maxv[1] - midv[1]);;
      oppGreen = gAtMid + (i - midv[1]) * (gAtMax - gAtMid) / (maxv[1] - midv[1]);
      oppBlue = bAtMid + (i - midv[1]) * (bAtMax - bAtMid) / (maxv[1] - midv[1]);
    }
        
    // interpolate along min-max edge
    float minmaxx = minv[0] + (i - minv[1]) * (maxv[0] - minv[0]) / (maxv[1] - minv[1]);
    float minmaxred = rAtMin + (i - minv[1]) * (rAtMax - rAtMin) / (maxv[1] - minv[1]);
    float minmaxgreen = gAtMin + (i - minv[1]) * (gAtMax - gAtMin) / (maxv[1] - minv[1]);
    float minmaxblue = bAtMin + (i - minv[1]) * (bAtMax - bAtMin) / (maxv[1] - minv[1]);
        
    for (int j = 0; j < width; j++) {  // do for the whole width of the scanline
      if (((j >= minmaxx) && (j < oppX)) || ((j >= oppX) && (j < minmaxx))){
        
        // interpolate between left and right values
        int pixelred = (int)(oppRed + (j - oppX) * (minmaxred - oppRed) / (minmaxx - oppX)   );
        int pixelgreen = (int)(oppGreen + (j - oppX) * (minmaxgreen - oppGreen) / (minmaxx - oppX)   );
        int pixelblue = (int)(oppBlue + (j - oppX) * (minmaxblue - oppBlue) / (minmaxx - oppX)   );
        
        pixels[i*width + j] = color(pixelred,pixelgreen,pixelblue);
        
      }
    }
  }
  
  // finished!
  updatePixels();
}
