import animation;
import graph;
import grid_and_axes;
import Koch_snowflake;
settings.tex="pdflatex";
settings.outformat = "png";
pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // аффинное -> декартово


defaultpen(fontsize(20));
 
for (int iterations = 3; iterations <= 4; ++iterations){
  pair[][] snowV; 
  picture pic_iter;
  size(pic_iter, 800,800);
  int k = 3^(iterations - 2);
  snowV.push(koch_snowflake(iterations));
  snowV.push(koch_snowflake(iterations, 
    (2*k + 1,
    4*k - 1)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (5*k + 1,
    7*k - 1)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (9*k,
    9*k)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (11*k,
    7*k)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (9*k - 1,
    3*k + 1)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (6*k - 1,
    1)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (2*k,
    -2*k)  
  ));

  draw_grid_and_axes(pic_iter, -3,14*k,-6,13*k, iterations, false); 
  for (int i = 0; i < snowV.length; ++i) {
    path snow = T*graph(snowV[i])--cycle;
    draw(pic_iter, snow, brown+linewidth(2));
    fill(pic_iter, snow, orange+opacity(0.2));
  }
  // label_vertices(pic_iter_3, snowV2, true, (0.2,0.2));
  shipout(format("shift_snowflakes_%d",iterations), pic_iter);

}
