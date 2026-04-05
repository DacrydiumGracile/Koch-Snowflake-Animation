import animation;
import graph;
import grid_and_axes;
settings.tex="pdflatex";
settings.outformat = "pdf";

pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
// transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // affine -> Cartesian
pair e1_rot = rotate(-30) * e1;
pair e2_rot = rotate(-30) * e2;
transform T = (0,0, e1_rot.x, e2_rot.x, e1_rot.y, e2_rot.y);

int iterations = 3;
pen color_snowflake = orange+opacity(0.9);
pen color_background = white;
int width = 1200;
int height = 1200;
int steps = 4;
int all_frame = 16*steps; // 16 * steps
int k = 3^(iterations - 2);

pair[][] snowV; 
picture frame1;
size(frame1, width, height);

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

    // First fragment
    for (int n = 2; n < 2*4^(iterations - 2) + 2; ++n) {
        affinePoints.push((x(n), y(n)));
    }
    // Duplicate point
    affinePoints.push(affinePoints[2*4^(iterations - 2)]);
    // We continue to construct the Koch line
    for (int n = 2*4^(iterations - 2) + 2; n < 4^(iterations - 1) + 2; ++n) {
        affinePoints.push((x(n), y(n)));
    }
    // Duplicate the last of the given points
    affinePoints.push((
      3^(iterations - 1) - affinePoints[0].y  + O.x + O.y,
      3^(iterations - 1) + affinePoints[0].x - affinePoints[0].y - O.x + 2*O.y  
    ));
    // We continue to build the second fragment
    for (int n = 4^(iterations - 1) + 2; n < 4^(iterations - 1) + 3 + 4^(iterations - 1); ++n) {
      int prev_n = n - 4^(iterations - 1) - 1;
      affinePoints.push((
        3^(iterations - 1) - affinePoints[prev_n].y  + O.x + O.y,
        3^(iterations - 1) + affinePoints[prev_n].x - affinePoints[prev_n].y - O.x + 2*O.y  
    ));
  }
  // Duplicate the first point from the third fragment to the second fragment
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
  // Duplicate the first point
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

pair[] update_snowflake_by_frame(picture pic, int frame_number, pair[] snowV) {
  int i = iterations;
  if (1 <= frame_number && frame_number <= steps) {
      shift_snowflake(snowV, (-1/steps, 1/steps));
  } else if (steps + 1 <= frame_number && frame_number <= 2*steps) {
      shift_snowflake(snowV, (-1/steps, 1/steps));
  } else if (2*steps + 1 <= frame_number && frame_number <= 3*steps) {
      shift_snowflake(snowV, (-1/steps, 1/steps));
  } else if (3*steps + 1 <= frame_number && frame_number <= 4*steps) {
      stretching_part(3, i, snowV, (1*(i-1)/steps, 1*(i-1)/steps));
  } else if (4*steps + 1 <= frame_number && frame_number <= 5*steps) {
      stretching_part(1, i, snowV, (1*(i-1)/steps, 1*(i-1)/steps));
      stretching_part(3, i, snowV, (3*(i-1)/steps, 3*(i-1)/steps));
  } else if (5*steps + 1 <= frame_number && frame_number <= 6*steps) {
      stretching_part(1, i, snowV, (3*(i-1)/steps, 3*(i-1)/steps));
      stretching_part(3, i, snowV, (2*(i-1)/steps, 2*(i-1)/steps));
      stretching_part(5, i, snowV, (1*(i-1)/steps, 1*(i-1)/steps));
  } else if (6*steps + 1 <= frame_number && frame_number <= 7*steps) {
      stretching_part(1, i, snowV, (2*(i-1)/steps, 2*(i-1)/steps));
      stretching_part(5, i, snowV, (3*(i-1)/steps, 3*(i-1)/steps));
  } else if (7*steps + 1 <= frame_number && frame_number <= 8*steps) {
      stretching_part(5, i, snowV, (2*(i-1)/steps, 2*(i-1)/steps));
  } else if (8*steps + 1 <= frame_number && frame_number <= 9*steps) {
      shift_snowflake(snowV, (1/steps, -1/steps));
  } else if (9*steps + 1 <= frame_number && frame_number <= 10*steps) {
      shift_snowflake(snowV, (1/steps, -1/steps));
  } else if (10*steps + 1 <= frame_number && frame_number <= 11*steps) {
      shift_snowflake(snowV, (1/steps, -1/steps));
  } else if (11*steps + 1 <= frame_number && frame_number <= 12*steps) {
    stretching_part(2, i, snowV, (1*(i-1)/steps, 1*(i-1)/steps));
  } else if (12*steps + 1 <= frame_number && frame_number <= 13*steps) {
    stretching_part(2, i, snowV, (3*(i-1)/steps, 3*(i-1)/steps));
    stretching_part(4, i, snowV, (1*(i-1)/steps, 1*(i-1)/steps));
  } else if (13*steps + 1 <= frame_number && frame_number <= 14*steps) {
    stretching_part(2, i, snowV, (2*(i-1)/steps, 2*(i-1)/steps));
    stretching_part(4, i, snowV, (3*(i-1)/steps, 3*(i-1)/steps));
    stretching_part(6, i, snowV, (1*(i-1)/steps, 1*(i-1)/steps));
  } else if (14*steps + 1 <= frame_number && frame_number <= 15*steps) {
    stretching_part(4, i, snowV, (2*(i-1)/steps, 2*(i-1)/steps));
    stretching_part(6, i, snowV, (3*(i-1)/steps, 3*(i-1)/steps));
  } else if (15*steps + 1 <= frame_number && frame_number <= 16*steps) {
    stretching_part(6, i, snowV, (2*(i-1)/steps, 2*(i-1)/steps));
  } else {
    abort(format("Error: Invalid frame number = %d", frame_number));
  }
  path snow = T*graph(snowV)--cycle;
  // if (frame_number == 6 || frame_number == 16){
    // string labelText = "$(" + string((T*snowV[0]).x)+"; " + string((T*(snowV[0])).y)+ ")$";
  // string labelText = "$(" + string((snowV[0]).x)+"; " + string(((snowV[0])).y)+ ")$";
    // label(pic,labelText, T*(snowV[0]), (0.5,0.5),red);
  // }
  // draw(pic, snow, glowPen1);
  // draw(pic, snow, glowPen2);
  // draw(pic, snow, glowPen3);
  fill(pic, snow, color_snowflake);
  return snowV;
}


snowV.push(snowflake_vertexs(iterations)); // snowflake 1
snowV.push(snowflake_vertexs(iterations, (2*k + 1, 4*k - 1))); // snowflake 2
snowV.push(snowflake_vertexs(iterations, (5*k + 1, 7*k - 1))); // snowflake 3
snowV.push(snowflake_vertexs(iterations, (9*k, 9*k))); // snowflake 4
snowV.push(snowflake_vertexs(iterations, (11*k, 13*k))); // snowflake 5
snowV.push(snowflake_vertexs(iterations, (15*k, 15*k))); // snowflake 6
snowV.push(snowflake_vertexs(iterations, (17*k, 19*k))); // snowflake 7
snowV.push(snowflake_vertexs(iterations, (21*k, 21*k))); // snowflake 8
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
  (23*k + 6*(iterations-1), 25*k + 6*(iterations-1)))); // snowflake 9
snowV.push(snowflake_vertexs(iterations, 
  (27*k - 1 + 6*(iterations-1), 27*k + 1 + 6*(iterations-1)))); // snowflake 10
snowV.push(snowflake_vertexs(iterations, 
  (30*k - 1 + 6*(iterations-1), 30*k + 1 + 6*(iterations-1)))); // snowflake 11
snowV.push(snowflake_vertexs(iterations, 
  (32*k + 6*(iterations-1), 34*k + 6*(iterations-1)))); // snowflake 12
snowV.push(snowflake_vertexs(iterations, 
  (36*k + 6*(iterations-1), 36*k + 6*(iterations-1)))); // snowflake 13
snowV.push(snowflake_vertexs(iterations, 
  (38*k + 6*(iterations-1), 40*k + 6*(iterations-1)))); // snowflake 14
snowV.push(snowflake_vertexs(iterations, 
  (42*k + 6*(iterations-1), 42*k + 6*(iterations-1)))); // snowflake 15
snowV.push(snowflake_vertexs(iterations, 
  (44*k + 6*(iterations-1), 46*k + 6*(iterations-1)))); // snowflake 16
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
    ((27*k + 6*(iterations-1)), (21*k + 6*(iterations-1)))
  );
  snowV.push(new_snowV);
} 
for(int n = snowV_length - 8; n < snowV_length; ++n){
  pair[] new_snowV = copy_snow(snowV[n]);
  shift_snowflake(new_snowV, 
    ((-21*k - 6*(iterations-1))  , (-27*k - 6*(iterations-1))) 
  );
  snowV.push(new_snowV);
} 


for (int i = 0; i < snowV.length; ++i) {
  path snow = T*graph(snowV[i])--cycle;
  // draw(pic_iter, snow, brown+linewidth(2));
  fill(frame1, snow, orange+opacity(0.8));
  string labelText = "$" + string(i + 1) + "$";
  label(frame1,labelText, T*(snowV[i][0]), (0.5,0.5), purple);
}

// Horizontal duplication
for (int i = 1; i < 2; ++i){
  snowV_length = snowV.length;
  for(int n = snowV_length-32; n < snowV_length; ++n){
    pair[] new_snowV = copy_snow(snowV[n]);
    shift_snowflake(new_snowV, 
      ((48*k + 2*6*(iterations-1)), (48*k + 2*6*(iterations-1)))
    );
    snowV.push(new_snowV);
  }
}
// Duplicating up
snowV_length = snowV.length;
for (int i = 1; i < 5; ++i){
  for(int n = 0; n < snowV_length; ++n){
    pair[] new_snowV = copy_snow(snowV[n]);
    shift_snowflake(new_snowV, 
      (6*i*k , -6*i*k)
    );
    snowV.push(new_snowV);
  }
}



for (int i = 0; i < snowV.length; ++i) {
  path snow = T*graph(snowV[i])--cycle;
  // draw(pic_iter, snow, brown+linewidth(2));
  fill(frame1, snow, color_snowflake);
}

real xmin = 2.82*(24*3^(iterations-2) +6*(iterations - 1)); 
real xmax = 3.71*(24*3^(iterations-2) +6*(iterations - 1));
real ymin = ((1.6*6 - 2.5)*3^(iterations - 2));
real ymax = ((3.45*6 - 2.5)*3^(iterations - 2));

pair A = T * ((xmin+ymax), (xmin-ymax));// Left Top
pair B = T * ((xmin+ymin), (xmin-ymin));// Left Bot
pair C = T * ((xmax+ymin), (xmax-ymin));
pair D = T * ((xmax+ymax), (xmax-ymax));
path viewRect = A--B--C--D--cycle;

// Constructing an axial rectangle
pair Aprime = (B.x, A.y);
pair Bprime = (B.x, C.y);
pair Cprime = (D.x, C.y);
pair Dprime = (D.x, A.y);

path viewRectD = Aprime--Bprime--Cprime--Dprime--cycle;

// draw(frame1, viewRect, red+linewidth(0.2));
// draw(frame1, viewRectD, blue+linewidth(0.5));
clip(frame1,viewRectD);

// animation a = animation(prefix="snowflake_animation");
// a.add(frame1);
shipout(format("frames_png/frame_%04d", 1), frame1, BBox(0mm,Fill(color_background)));
 

// We created the first frame above. Now we still need to create 448 for i = 3
for (int i = 0; i <= 447; ++ i){ 
  picture pic;
  size(pic, width, height);
  for(int n = 0; n < snowV.length # 16; ++n){
      snowV[n*16    ] = update_snowflake_by_frame(pic, (i)          % all_frame+1, snowV[n*16    ]);
      snowV[n*16 + 1] = update_snowflake_by_frame(pic, (i+9*steps)  % all_frame+1, snowV[n*16 + 1]);
      snowV[n*16 + 2] = update_snowflake_by_frame(pic, (i+2*steps)  % all_frame+1, snowV[n*16 + 2]);
      snowV[n*16 + 3] = update_snowflake_by_frame(pic, (i+11*steps) % all_frame+1, snowV[n*16 + 3]);
      snowV[n*16 + 4] = update_snowflake_by_frame(pic, (i+4*steps)  % all_frame+1, snowV[n*16 + 4]);
      snowV[n*16 + 5] = update_snowflake_by_frame(pic, (i+13*steps) % all_frame+1, snowV[n*16 + 5]);
      snowV[n*16 + 6] = update_snowflake_by_frame(pic, (i+6*steps)  % all_frame+1, snowV[n*16 + 6]);
      snowV[n*16 + 7] = update_snowflake_by_frame(pic, (i+15*steps) % all_frame+1, snowV[n*16 + 7]);

      snowV[n*16 +  8] = update_snowflake_by_frame(pic, (i+8*steps) % all_frame+1, snowV[n*16 +  8]); 
      snowV[n*16 +  9] = update_snowflake_by_frame(pic, (i+1*steps) % all_frame+1, snowV[n*16 +  9]);
      snowV[n*16 + 10] = update_snowflake_by_frame(pic, (i+10*steps)% all_frame+1, snowV[n*16 + 10]); 
      snowV[n*16 + 11] = update_snowflake_by_frame(pic, (i+3*steps) % all_frame+1, snowV[n*16 + 11]);
      snowV[n*16 + 12] = update_snowflake_by_frame(pic, (i+12*steps)% all_frame+1, snowV[n*16 + 12]);
      snowV[n*16 + 13] = update_snowflake_by_frame(pic, (i+5*steps) % all_frame+1, snowV[n*16 + 13]);
      snowV[n*16 + 14] = update_snowflake_by_frame(pic, (i+14*steps)% all_frame+1, snowV[n*16 + 14]);
      snowV[n*16 + 15] = update_snowflake_by_frame(pic, (i+7*steps) % all_frame+1, snowV[n*16 + 15]);
  }

  clip(pic, viewRectD);
  // a.add(pic);
  shipout(format("frames_png/frame_%04d", i+2), pic, BBox(0mm,Fill(color_background)));
}

// a.export(multipage=true);
// a.movie(format="gif", BBox(0mm,Fill(white)), delay=100, loops=0);