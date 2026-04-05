import animation;
import graph;
import grid_and_axes;
settings.tex="pdflatex";
settings.outformat = "png";
pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // аффинное -> декартово
int iterations;

pair[] koch_curve(int iterations) {
    int l(int n) {
        return ceil(log(n) / log(4)) + 1;
    }

    int block_number(int n) {
        return ceil(4.0*n / 4^ceil(log(n)/log(4)));
    }

    pair[] affinePoints = new pair[] {(0,0)};
    for (int n = 2; n < 4^(iterations - 1) + 2; ++n) {
        int block = block_number(n);
        int ln = l(n);
        int prev_n = n - (block - 1) * 4^(ln - 2) - 1;
        if (block == 2){
        affinePoints.push((
            3^(ln - 2) + affinePoints[prev_n].y ,
            3^(ln - 2) - affinePoints[prev_n].x + affinePoints[prev_n].y
        ));
        } else if (block == 3) {
            affinePoints.push((
            2 * 3^(ln - 2) + affinePoints[prev_n].x - affinePoints[prev_n].y,
            3^(ln - 2) + affinePoints[prev_n].x
            ));
        } else if (block == 4) {
            affinePoints.push((
            2 * 3^(ln - 2) + affinePoints[prev_n].x,
            2 * 3^(ln - 2) + affinePoints[prev_n].y
            ));
        } 
    }
    return affinePoints;
}


defaultpen(fontsize(18));
picture pic_iter_2; 
size(pic_iter_2, 800,800);
iterations = 2 ;
pair[] curveV2 = koch_curve(iterations);
path curve2 = T*graph(curveV2);
draw_grid_and_axes(pic_iter_2, -1,3,-1,3,1, true); 

draw(pic_iter_2, curve2, blue+linewidth(2));
label_vertices(pic_iter_2, curveV2, true, (0.2,0.2));
shipout("koch_curve_2", pic_iter_2);

defaultpen(fontsize(14));
picture pic_iter_3; 
size(pic_iter_3, 800,800);
iterations = 3;  
pair[] curveV3 = koch_curve(iterations);
path curve3 = T*graph(curveV3);
draw_grid_and_axes(pic_iter_3, -1,9,-1,9,1, true); 

draw(pic_iter_3, curve3, blue+linewidth(2));
label_vertices(pic_iter_3, curveV3, true, (0.2,0.2));
shipout("koch_curve_3", pic_iter_3);


// pair[] snowV2 = snowflake_vertexs(iterations);
// snowV2 = rotate60_snowflake_vertexs(iterations, snowV2);

// for (int i = 0; i < snowV1.length; ++i){
//   write(format("%d  ",i), snowV1[i], snowV2[i]); 
// }
// path snow2 = T*graph(snowV2)--cycle;



// draw(snow1, red+opacity(0.5)+linewidth(1));