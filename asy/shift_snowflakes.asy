import animation;
import graph;
import grid_and_axes;
import Koch_snowflake;
settings.tex="pdflatex";
settings.outformat = "png";
pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // аффинное -> декартово


defaultpen(fontsize(4));
 
for (int iterations = 3; iterations <= 4; ++iterations){
  pair[][] snowV; 
  picture pic_iter;
  size(pic_iter, 1200,1200);
  int k = 3^(iterations - 3);
  int k3 = 3^(iterations - 2);
  snowV.push(koch_snowflake(iterations));
  snowV.push(koch_snowflake(iterations, 
    (2*k3 + k ,
    4*k3 - k)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (5*k3 + k,
    7*k3 - k)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (9*k3,
    9*k3)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (11*k3,
    7*k3)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (9*k3 - k,
    3*k3 + k)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (6*k3 - k,
    1)  
  ));
  snowV.push(koch_snowflake(iterations, 
    (2*k3,
    -2*k3)  
  ));
// void label_vertices(picture pic, pair[] pts, bool showCoords=true, pair offset=(0.15,0.15), bool showNumbers=true) {
//     pen tiny = fontsize(14);
//     for (int i = 0; i < pts.length-1; ++i) {
//       pair pt = pts[i];
//       string labelText;
//       if (pts[i] == pts[i+1]){
//         continue;
//       }
//       if (showCoords && showNumbers) {
//           string xStr = format("$%f$", pt.x);
//           string yStr = format("$%f$", pt.y);
//           labelText = "$" + string(i+1) + "(" + xStr + "," + yStr + ")$";
//       } else if (showNumbers) {
//           labelText = "$" + string(i+1) + "$";
//       } else if (showCoords) {
//           string xStr = format("$%f$", pt.x);
//           string yStr = format("$%f$", pt.y);
//           labelText = "$(" + xStr + "," + yStr + ")$";
//       }
//       label(pic=pic, scale(0.3)*labelText, T*pt, offset, Fill(white+opacity(0.7)));
//     }
// }

draw_grid_and_axes(pic_iter, -3,14*k3,-6,13*k3, 1, false); 
for (int i = 0; i < snowV.length; ++i) {
  path snow = T*graph(snowV[i])--cycle;
  // draw(pic_iter, snow, brown+linewidth(2));
  fill(pic_iter, snow, orange+opacity(0.2));
  // label_vertices(pic_iter, snowV[i], true, (0.2,0.2));
}
shipout(format("shift_snowflakes_%d",iterations), pic_iter);

}
