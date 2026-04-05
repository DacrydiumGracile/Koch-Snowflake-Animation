pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // аффинное -> декартово

void draw_grid_and_axes(picture pic, int x_min, int x_max, int y_min, int y_max, int step, bool fine=false) {
    // Основная сетка (шаг = step)
    // Линии x = const
    for (int x = x_min; x <= x_max; x += step) {
        path line;
        for (int y = y_min; y <= y_max; ++y) {
            line = line -- T*(x,y);
        }
        draw(pic, line, gray(0.7)+linewidth(0.3));   // светлый серый, тонкая линия
    }
    // Линии y = const
    for (int y = y_min; y <= y_max; y += step) {
        path line;
        for (int x = x_min; x <= x_max; ++x) {
            line = line -- T*(x,y);
        }
        draw(pic, line, gray(0.65)+linewidth(0.3));
    }
    // Дополнительная сетка (шаг 0.5)
    if (fine) {
        real step2 = 0.5;
        // Линии x = const
        for (real x = x_min; x <= x_max; x += step2) {
            path line;
            for (int y = y_min; y <= y_max; ++y) {
                line = line -- T*(x,y);
            }
            draw(pic, line, gray(0.9)+linewidth(0.2)+dashed);   // ещё светлее и тоньше
        }
        // Линии y = const
        for (real y = y_min; y <= y_max; y += step2) {
            path line;
            for (int x = x_min; x <= x_max; ++x) {
                line = line -- T*(x,y);
            }
            draw(pic, line, gray(0.9)+linewidth(0.2)+dashed);
        }
    }
    // Оси координат (чёрные, но тонкие)
    draw(pic, T*(x_min,0)--T*(x_max+1,0), black+linewidth(0.5), arrow=EndArrow);
    draw(pic, T*(0,y_min)--T*(0,y_max+1), black+linewidth(0.5), arrow=EndArrow);
    
    // Тики и подписи на осях
    // На оси x (y=0)
    for (int x = x_min; x <= x_max; x += step) {
        pair pt = T*(x,0);
        dot(pic, pt, black);
        label(pic=pic,"$"+string(x)+"$", pt, (-0.5,1.15));
    }
    // На оси y (x=0)
    for (int y = y_min; y <= y_max; y += step) {
        pair pt = T*(0,y);
        dot(pic, pt, black);
        label(pic=pic, "$"+string(y)+"$", pt, (-1.2,0));
    }
    // Подписи осей (чуть крупнее, можно оставить стандартный шрифт или тоже уменьшить)
    label(pic=pic, "$x$", T*(x_max+0.7,0), SE);
    label(pic=pic, "$y$", T*(0,y_max+0.7), NE);
}


void label_vertices(picture pic, pair[] pts, bool showCoords=true, pair offset=(0.15,0.15), bool showNumbers=true) {
    pen tiny = fontsize(14);
    for (int i = 0; i < pts.length; ++i) {
      pair pt = pts[i];
      string labelText;
      if (showCoords && showNumbers) {
          string xStr = format("$%f$", pt.x);
          string yStr = format("$%f$", pt.y);
          labelText = "$" + string(i+1) + "(" + xStr + "," + yStr + ")$";
      } else if (showNumbers) {
          labelText = "$" + string(i+1) + "$";
      } else if (showCoords) {
          string xStr = format("$%f$", pt.x);
          string yStr = format("$%f$", pt.y);
          labelText = "$(" + xStr + "," + yStr + ")$";
      }
      label(pic=pic, labelText, T*pt, offset, Fill(white+opacity(0.7)));
    }
}