import settings;
settings.tex = "pdflatex";
settings.outformat = "png";
import graph;
import grid_and_axes;

pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0, e1.x, e2.x, e1.y, e2.y);  // аффинное -> декартово

// Векторы в аффинных координатах
pair[] dirs_affine = { (1,1), (1,-1), (-1,-1), (-1,1), (7, 5), (-5,-7), (5,7), (-7,-5)};
string[] names = { "E", "N", "W", "S", "NE", "NW", "SE", "SW" };
pen[] pens = {red, blue, darkgreen, orange, magenta, cyan, brown, purple};


defaultpen(fontsize(14));
picture pic; 
size(pic, 800,800);
draw_grid_and_axes(pic, -3,3,-3,3,1, true); 

real L = 1.5; // единая длина векторов в декартовой системе

for (int i = 0; i < dirs_affine.length; ++i) {
    pair v_cart = T * dirs_affine[i];
    real len = length(v_cart);
    if (len == 0) continue;
    pair v_unit = v_cart / len;
    pair v_scaled = v_unit * L;
    draw(pic, (0,0)--v_scaled, pens[i]+linewidth(2), Arrow(angle=15, size=5));
    string labelText = "$" + names[i] + "(" + string(dirs_affine[i].x) + "," + string(dirs_affine[i].y) + ")$";
    label(pic, labelText, v_scaled, v_unit*(0.2));
}

// label_vertices(pic, dirs, true, (0.2,0.2), false);

// // Оси (декартовы) для ориентира
// draw((-2,0)--(2,0), gray+dashed);
// draw((0,-2)--(0,2), gray+dashed);

shipout("directions", pic);