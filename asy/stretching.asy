import animation;
import graph;
import grid_and_axes;
settings.tex="pdflatex";
settings.outformat = "png";
pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // аффинное -> декартово
int iterations;

pair[] snowflake_vertexs(int iterations, pair O = (0,0)) {
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

    // Первый фрагмент
    for (int n = 2; n < 2*4^(iterations - 2) + 2; ++n) {
        affinePoints.push((x(n), y(n)));
    }
    // Дублирование точки 
    affinePoints.push(affinePoints[2*4^(iterations - 2)]);
    // Продолжаем строить ломанную Коха
    for (int n = 2*4^(iterations - 2) + 2; n < 4^(iterations - 1) + 2; ++n) {
        affinePoints.push((x(n), y(n)));
    }
    // Дублируем последнюю из созданных точек
    affinePoints.push((
      3^(iterations - 1) - affinePoints[0].y  + O.x + O.y,
      3^(iterations - 1) + affinePoints[0].x - affinePoints[0].y - O.x + 2*O.y  
    ));
    // Продолжаем строить второй фрагмент
    for (int n = 4^(iterations - 1) + 2; n < 4^(iterations - 1) + 3 + 4^(iterations - 1); ++n) {
      int prev_n = n - 4^(iterations - 1) - 1;
      affinePoints.push((
        3^(iterations - 1) - affinePoints[prev_n].y  + O.x + O.y,
        3^(iterations - 1) + affinePoints[prev_n].x - affinePoints[prev_n].y - O.x + 2*O.y  
    ));
  }
  // Дублируем первую точку из третей части во вторую часть.
  affinePoints.push((
    3^(iterations - 1) - affinePoints[4^(iterations - 1) + 1].y  + O.x + O.y,
    3^(iterations - 1) + affinePoints[4^(iterations - 1) + 1].x - affinePoints[4^(iterations - 1) + 1].y - O.x + 2*O.y
  ));
  // Третья часть снежинки
  for (int n = 2*4^(iterations - 1) + 4; n < 3*4^(iterations - 1) + 4 ; ++n) {
    int prev_n = n - 4^(iterations - 1) - 1;
    affinePoints.push((
      3^(iterations - 1) - affinePoints[prev_n].y + O.x + O.y,
      3^(iterations - 1) + affinePoints[prev_n].x - affinePoints[prev_n].y  - O.x + 2*O.y
    ));     
  }
  // Дублируем самую первую точку
  affinePoints.push(affinePoints[0]);
  return affinePoints;
}

defaultpen(fontsize(20));
picture pic_iter_2; 
size(pic_iter_2, 800,800);
iterations = 2 ;
pair[] snowV2 = snowflake_vertexs(iterations);
path snow2 = T*graph(snowV2)--cycle;
// draw_grid_and_axes(pic_iter_2, -1,3,-1,4,1, true); 

draw(pic_iter_2, snow2, blue+linewidth(2));

// Рисуем точки и подписи с разными смещениями
for (int i = 0; i < snowV2.length; ++i) {
    dot(pic_iter_2,T*(snowV2[i]), red+linewidth(2));
    // Смещение подписи: в зависимости от номера
    pair offset = (0,0);
    if (i % 3 == 0) offset = (0.2, 0.2);
    else if (i % 3 == 1) offset = (-0.2, -0.2);
    else offset = (0.2, -0.2);
    label(pic_iter_2,"$" + string(i+1) + "(" + string(snowV2[i].x) + ", " + string(snowV2[i].y) + ")$", T *(snowV2[i]), offset, Fill(white+opacity(0.7)));
}

shipout("duplication_of_points_2", pic_iter_2);


void stretching_part(int part, int iterations, pair[] snowV, pair dxy) {
  assert(part > 0 && part < 7, 
        "part должна быть между 1 и 6 (включая границы)");
  int k = 4^(iterations - 2);
  if (part > 0 && part < 6) {
    for (int n = 2*(part - 1)*k + (part - 1); 
             n <= 2*(part + 1)*k + part; ++n) {
      snowV[n] = snowV[n] + dxy;
    } 
  } else if (part == 6) {
    for (int n = 10*k + 5; n <= 12*k + 5; ++n) {
      snowV[n] = snowV[n] + dxy;
    }
    for (int n = 0; n <= 2*k; ++n) {
      snowV[n] = snowV[n] + dxy;
    }
  }  
}

defaultpen(fontsize(24));
 
for (int iterations = 3; iterations <= 4; ++iterations){
  pair[][] snowV; 
  picture pic_iter;
  size(pic_iter, 800,800);
  int k = 3^(iterations - 2);
  snowV.push(snowflake_vertexs(iterations));
  stretching_part(2, iterations, snowV[0], (1*(iterations-1), 1*(iterations-1)));

  snowV.push(snowflake_vertexs(iterations, (2*3^(iterations-2), 4*3^(iterations-2)))); 
  stretching_part(1, iterations, snowV[1], (1*(iterations-1), 1*(iterations-1)));
  stretching_part(3, iterations, snowV[1], (4*(iterations-1), 4*(iterations-1)));

  snowV.push(snowflake_vertexs(iterations, (6*3^(iterations-2), 6*3^(iterations-2)))); 
  stretching_part(2, iterations, snowV[2], (6*(iterations-1), 6*(iterations-1)));
  stretching_part(4, iterations, snowV[2], (4*(iterations-1), 4*(iterations-1)));
  stretching_part(6, iterations, snowV[2], (1*(iterations-1), 1*(iterations-1)));

  snowV.push(snowflake_vertexs(iterations, (8*3^(iterations-2), 10*3^(iterations-2)))); 
  stretching_part(1, iterations, snowV[3], (6*(iterations-1), 6*(iterations-1)));
  stretching_part(3, iterations, snowV[3], (6*(iterations-1), 6*(iterations-1)));
  stretching_part(5, iterations, snowV[3], (4*(iterations-1), 4*(iterations-1)));

 
  snowV.push(snowflake_vertexs(iterations, 
    (-4*3^(iterations-2), 4*3^(iterations-2))
  )); 
  stretching_part(3, iterations, snowV[4], (1*(iterations-1), 1*(iterations-1)));

  snowV.push(snowflake_vertexs(iterations, 
    (0, 6*3^(iterations-2))
  )); 
  stretching_part(2, iterations, snowV[5], (4*(iterations-1), 4*(iterations-1)));
  stretching_part(4, iterations, snowV[5], (1*(iterations-1), 1*(iterations-1)));
  snowV.push(snowflake_vertexs(iterations, 
    (2*3^(iterations-2), 10*3^(iterations-2))
  )); 
  stretching_part(1, iterations, snowV[6], (4*(iterations-1), 4*(iterations-1)));
  stretching_part(3, iterations, snowV[6], (6*(iterations-1), 6*(iterations-1)));
  stretching_part(5, iterations, snowV[6], (1*(iterations-1), 1*(iterations-1)));
  snowV.push(snowflake_vertexs(iterations, 
    (6*3^(iterations-2), 12*3^(iterations-2))
  )); 
  stretching_part(2, iterations, snowV[7], (6*(iterations-1), 6*(iterations-1)));
  stretching_part(4, iterations, snowV[7], (6*(iterations-1), 6*(iterations-1)));
  stretching_part(6, iterations, snowV[7], (4*(iterations-1), 4*(iterations-1)));

  // draw_grid_and_axes(pic_iter, -3,14*k,-6,13*k, iterations, false); 
  for (int i = 0; i < snowV.length; ++i) {
    path snow = T*graph(snowV[i])--cycle;
    // draw(pic_iter, snow, brown+linewidth(2));
    fill(pic_iter, snow, orange+opacity(0.8));
    string labelText = "$" + string(i+1) + "$";
    label(pic_iter,labelText, T*(snowV[i][0]), (0.5,0.5),purple);
  }
  // label_vertices(pic_iter_3, snowV2, true, (0.2,0.2));
  shipout(format("stretching_%d",iterations), pic_iter);

}

// defaultpen(fontsize(10));
// picture pic_iter_3; 
// size(pic_iter_3, 800,800);
// iterations = 3;
// pair[] snowV3 = snowflake_vertexs(iterations);
// path snow3 = T*graph(snowV3)--cycle;
// draw_grid_and_axes(pic_iter_3, -3,9,-1,12,1, true); 

// draw(pic_iter_3, snow3, blue+linewidth(2));
// label_vertices(pic_iter_3, snowV3, true, (0.2,0.2));
// shipout("stretching_3", pic_iter_3);