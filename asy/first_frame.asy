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

void shift_snowflake(pair[] snowV, pair dxy){
  for (int n = 0; n < snowV.length; ++n) {
    snowV[n] = snowV[n] + dxy;
  }
}

pair[] copy_snow(pair[] snowV){
  pair[] result;
  for (pair p : snowV) {
    result.push(p);
  }
  return result;
}

void stretching_part(int part, int iterations, pair[] snowV, pair dxy) {
  assert(part > 0 && part < 7, 
        "part должна быть между 1 и 6 (включая границы)");
  int m = 4^(iterations - 2);
  if (part > 0 && part < 6) {
    for (int n = 2*(part - 1)*m + (part - 1); 
             n <= 2*(part + 1)*m + part; ++n) {
      snowV[n] = snowV[n] + dxy;
    } 
  } else if (part == 6) {
    for (int n = 10*m + 5; n <= 12*m + 5; ++n) {
      snowV[n] = snowV[n] + dxy;
    }
    for (int n = 0; n <= 2*m; ++n) {
      snowV[n] = snowV[n] + dxy;
    }
  }  
}

pair[][] snowV; 
picture frame1;
size(frame1, 800,800);
iterations = 3;
int k = 3^(iterations - 3);
int k3 = 3*k;
snowV.push(snowflake_vertexs(iterations)); // snowflake 1
snowV.push(snowflake_vertexs(iterations, (2*k3 + k, 4*k3 - k))); // snowflake 2
snowV.push(snowflake_vertexs(iterations, (5*k3 + k, 7*k3 - k))); // snowflake 3
snowV.push(snowflake_vertexs(iterations, (9*k3, 9*k3))); // snowflake 4
snowV.push(snowflake_vertexs(iterations, (11*k3, 13*k3))); // snowflake 5
snowV.push(snowflake_vertexs(iterations, (15*k3, 15*k3))); // snowflake 6
snowV.push(snowflake_vertexs(iterations, (17*k3, 19*k3))); // snowflake 7
snowV.push(snowflake_vertexs(iterations, (21*k3, 21*k3))); // snowflake 8
// for 5 snowflake
stretching_part(3, iterations, snowV[4], (1*(iterations-1), 1*(iterations-1)));
// for 6 snowflake
stretching_part(2, iterations, snowV[5], (4*(iterations-1), 4*(iterations-1)));
stretching_part(4, iterations, snowV[5], (1*(iterations-1), 1*(iterations-1)));
// for 7 snowflake
stretching_part(1, iterations, snowV[6], (4*(iterations-1), 4*(iterations-1)));
stretching_part(3, iterations, snowV[6], (6*(iterations-1), 6*(iterations-1)));
stretching_part(5, iterations, snowV[6], (1*(iterations-1), 1*(iterations-1)));
// for 8 snowflake
stretching_part(2, iterations, snowV[7], (6*(iterations-1), 6*(iterations-1)));
stretching_part(4, iterations, snowV[7], (6*(iterations-1), 6*(iterations-1)));
stretching_part(6, iterations, snowV[7], (4*(iterations-1), 4*(iterations-1)));

snowV.push(snowflake_vertexs(iterations, 
  (23*k3 + 6*(iterations-1), 25*k3 + 6*(iterations-1)))); // snowflake 9
snowV.push(snowflake_vertexs(iterations, 
  (27*k3 - k + 6*(iterations-1), 27*k3 + k + 6*(iterations-1)))); // snowflake 10
snowV.push(snowflake_vertexs(iterations, 
  (30*k3 - k + 6*(iterations-1), 30*k3 + k + 6*(iterations-1)))); // snowflake 11
snowV.push(snowflake_vertexs(iterations, 
  (32*k3 + 6*(iterations-1), 34*k3 + 6*(iterations-1)))); // snowflake 12
snowV.push(snowflake_vertexs(iterations, 
  (36*k3 + 6*(iterations-1), 36*k3 + 6*(iterations-1)))); // snowflake 13
snowV.push(snowflake_vertexs(iterations, 
  (38*k3 + 6*(iterations-1), 40*k3 + 6*(iterations-1)))); // snowflake 14
snowV.push(snowflake_vertexs(iterations, 
  (42*k3 + 6*(iterations-1), 42*k3 + 6*(iterations-1)))); // snowflake 15
snowV.push(snowflake_vertexs(iterations, 
  (44*k3 + 6*(iterations-1), 46*k3 + 6*(iterations-1)))); // snowflake 16
// for 13 snowflake
stretching_part(2, iterations, snowV[12], (1*(iterations-1), 1*(iterations-1)));
// for 14 snowflake
stretching_part(1, iterations, snowV[13], (1*(iterations-1), 1*(iterations-1)));
stretching_part(3, iterations, snowV[13], (4*(iterations-1), 4*(iterations-1)));
// for 15 snowflake
stretching_part(2, iterations, snowV[14], (6*(iterations-1), 6*(iterations-1)));
stretching_part(4, iterations, snowV[14], (4*(iterations-1), 4*(iterations-1)));
stretching_part(6, iterations, snowV[14], (1*(iterations-1), 1*(iterations-1)));
// for 16 snowflake
stretching_part(1, iterations, snowV[15], (6*(iterations-1), 6*(iterations-1)));
stretching_part(3, iterations, snowV[15], (6*(iterations-1), 6*(iterations-1)));
stretching_part(5, iterations, snowV[15], (4*(iterations-1), 4*(iterations-1)));



// Now let's duplicate to the left with an offset
int snowV_length = snowV.length;
for(int n = snowV_length-16; n < snowV_length - 8; ++n){
  pair[] new_snowV = copy_snow(snowV[n]);
  shift_snowflake(new_snowV, 
    ((27*k3 + 6*(iterations-1)), (21*k3 + 6*(iterations-1)))
  );
  snowV.push(new_snowV);
} 
for(int n = snowV_length - 8; n < snowV_length; ++n){
  pair[] new_snowV = copy_snow(snowV[n]);
  shift_snowflake(new_snowV, 
    ((-21*k3 - 6*(iterations-1))  , (-27*k3 - 6*(iterations-1))) 
  );
  snowV.push(new_snowV);
} 


// for (int i = 1; i < 2; ++i){
//   snowV_length = snowV.length;
//   for(int n = snowV_length-32; n < snowV_length; ++n){
//     snowV.push(shift_snowflake(copy_snow(snowV[n]), 
//       ((48*k + 2*6*(iterations-1)), (48*k + 2*6*(iterations-1)))
//     ));
//   }
// }

// draw_grid_and_axes(pic_iter, -3,14*k,-6,13*k, iterations, false); 
for (int i = 0; i < snowV.length; ++i) {
  path snow = T*graph(snowV[i])--cycle;
  // draw(pic_iter, snow, brown+linewidth(2));
  fill(frame1, snow, orange+opacity(0.8));
  string labelText = "$" + string(i+1) + "$";
  label(frame1,labelText, T*(snowV[i][0]), (0.5,0.5),purple);
}


// label_vertices(pic_iter_3, snowV2, true, (0.2,0.2));
shipout(format("first_frame_%d",iterations), frame1);