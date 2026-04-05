import animation;
import graph;
import grid_and_axes;
settings.tex="pdflatex";
settings.outformat = "png";
pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // аффинное -> декартово
int iterations;

pair[] koch_snowflake(int iterations, pair O = (0,0)) {
    pair[] affinePoints = new pair[] {O};

    int l(int n) {
      return ceil(log(n) / log(4)) + 1;
    }

    int block_number(int n) {
      return ceil(4.0*n / 4^ceil(log(n)/log(4)));
    }

    real x(int n){
      int bn = block_number(n);
      int ln = l(n);
      int prev_n = n - (bn - 1) * 4^(ln - 2) - 1;
      real xn;
      if (bn == 2){
          xn = 3^(ln - 2) + affinePoints[prev_n].y + O.x - O.y;
      } else if (bn == 3) {
          xn = 2 * 3^(ln - 2) + affinePoints[prev_n].x - affinePoints[prev_n].y + O.y;
      } else if (bn == 4) {
          xn = 2 * 3^(ln - 2) + affinePoints[prev_n].x;
      } 
      return xn;
    };

    real y(int n){
      int bn = block_number(n);
      int ln = l(n);
      int prev_n = n - (bn - 1) * 4^(ln - 2) - 1;
      real yn;
      if (bn == 2){
          yn = 3^(ln - 2) - affinePoints[prev_n].x + affinePoints[prev_n].y + O.x;
      } else if (bn == 3) {
          yn = 3^(ln - 2) + affinePoints[prev_n].x - O.x + O.y;
      } else if (bn == 4) {
          yn = 2 * 3^(ln - 2) + affinePoints[prev_n].y;
      } 
      return yn;
    };

    // Ломанная Коха
    for (int n = 2; n < 4^(iterations - 1) + 2; ++n) {
        affinePoints.push((x(n), y(n)));
    }
    // Оставшаяся часть снежинки
    for (int n = 4^(iterations - 1) + 2; n < 3*4^(iterations - 1) + 1; ++n) {
      int prev_n = n - 4^(iterations - 1) - 1;
      affinePoints.push((
        3^(iterations - 1) - affinePoints[prev_n].y  + O.x + O.y,
        3^(iterations - 1) + affinePoints[prev_n].x - affinePoints[prev_n].y - O.x + 2*O.y  
      ));
    }
    return affinePoints;
}

defaultpen(fontsize(18));
picture pic_iter_2; 
size(pic_iter_2, 800,800);
iterations = 2 ;
pair[] snowV2 = koch_snowflake(iterations);
path snow2 = T*graph(snowV2)--cycle;
draw_grid_and_axes(pic_iter_2, -1,3,-1,3,1, true); 

draw(pic_iter_2, snow2, blue+linewidth(2));
label_vertices(pic_iter_2, snowV2, true, (0.2,0.2));
shipout("koch_snowflake_2", pic_iter_2);

defaultpen(fontsize(10));
picture pic_iter_3; 
size(pic_iter_3, 800,800);
iterations = 3;
pair[] snowV3 = koch_snowflake(iterations);
path snow3 = T*graph(snowV3)--cycle;
draw_grid_and_axes(pic_iter_3, -3,9,-1,12,1, true); 

draw(pic_iter_3, snow3, blue+linewidth(2));
label_vertices(pic_iter_3, snowV3, true, (0.2,0.2));
shipout("koch_snowflake_3", pic_iter_3);