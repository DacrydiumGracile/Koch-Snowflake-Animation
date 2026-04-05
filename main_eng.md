# Koch Snowflake Animation: Mathematical Foundations and Asymptote Implementation

This document is dedicated to answering the following question: ["I am trying to make a really cool animation using Koch snowflakes, but don't know how"](https://tex.stackexchange.com/questions/761136/i-am-trying-to-make-a-really-cool-animation-using-koch-snowflakes-but-dont-kno). We begin by defining the Koch curve in an affine coordinate system with basis vectors $e_1 = \left(\frac{1}{2}, \frac{\sqrt{3}}{2}\right)$, $e_2 = \left(\frac{1}{2}, -\frac{\sqrt{3}}{2}\right)$. Then we define the Koch snowflake with some duplicated vertices to correctly implement compression and stretching operations. Afterwards we discuss the frames that make up the animation and how to achieve the required viewing angle. Finally, we consider improvements and alternative implementations.

In this work we use [Asymptote](https://asymptote.sourceforge.io/) as the main tool for demonstrating and implementing the animation. However, as will be seen later, we can use any other language to solve the problem, since we provide all the mathematical derivations.

## Koch Curve

The Koch curve can be created in various ways; the original question already mentioned L‑systems. For our task it does not matter how we obtain the list of vertices of the curve and subsequently the Koch snowflake. However, I found it elegant and flexible to use recurrence formulas. Several approaches exist to derive these formulas. One can find them in the Online Encyclopedia of Integer Sequences: [A335358](https://oeis.org/A335358). That entry also links to a [paper](https://docs.google.com/document/d/1FUUuR99WPY3tXgL1XXdOGkiGcfvC2eyh74WIwfZGyvA/view?tab=t.0#heading=h.al1th1rbqpaa) by A.V. Litvinov, where the derivation is described in detail for the affine basis $e_1 = (1,0)$, $e_2 = \left(\frac{1}{2}, \frac{\sqrt{3}}{2}\right)$.

We will work in the affine coordinate system with basis $e_1 = \left(\frac{1}{2}, \frac{\sqrt{3}}{2}\right)$, $e_2 = \left(\frac{1}{2}, -\frac{\sqrt{3}}{2}\right)$, which allows us to compute all vertices of the curve and later the snowflake using **integer coordinates**. If desired, the whole animation could be computed in integers and only converted to Cartesian coordinates at the rendering stage. However, during certain operations we will enter the field of rational numbers $\mathbb{Q}$.

Repeating the reasoning from the above‑mentioned paper, we arrive at the following formulas:

$$
l(n) = \left\lceil \log_4 n \right\rceil + 1
$$

$$
b(n) = \left\lceil \frac{4n}{4^{\lceil \log_4 n \rceil}} \right\rceil
$$

$$
x(n) = \begin{cases}
0, & n = 1;\\
3^{l(n)-2} + y\bigl(n - 4^{l(n)-2}\bigr), & b(n)=2,\\
2\cdot 3^{l(n)-2} + x\bigl(n - 2\cdot 4^{l(n)-2}\bigr) - y\bigl(n - 2\cdot 4^{l(n)-2}\bigr), & b(n)=3,\\
2\cdot 3^{l(n)-2} + x\bigl(n - 3\cdot 4^{l(n)-2}\bigr), & b(n)=4,
\end{cases}
$$

$$
y(n) = \begin{cases}
0, & n = 1;\\
3^{l(n)-2} - x\bigl(n - 4^{l(n)-2}\bigr) + y\bigl(n - 4^{l(n)-2}\bigr), & b(n)=2,\\
2\cdot 3^{l(n)-2} + x\bigl(n - 2\cdot 4^{l(n)-2}\bigr), & b(n)=3,\\
2\cdot 3^{l(n)-2} + y\bigl(n - 3\cdot 4^{l(n)-2}\bigr), & b(n)=4,
\end{cases}
$$

where $n$ is the vertex number of the Koch broken line, $n \ge 1$.

![Koch curve, iteration 2](asy/koch_curve_2.png)
![Koch curve, iteration 3](asy/koch_curve_3.png)

Next we modify the formulas so that the curve can be constructed not only starting at $(0,0)$ but at an arbitrary point $O = (x_0, y_0)$.

$$
x(n) = \begin{cases}
x_0, & n = 1;\\
3^{l(n)-2} + y\bigl(n - 4^{l(n)-2}\bigr) + x_0 - y_0, & b(n)=2,\\
2\cdot 3^{l(n)-2} + x\bigl(n - 2\cdot 4^{l(n)-2}\bigr) - y\bigl(n - 2\cdot 4^{l(n)-2}\bigr) + y_0, & b(n)=3,\\
2\cdot 3^{l(n)-2} + x\bigl(n - 3\cdot 4^{l(n)-2}\bigr), & b(n)=4,
\end{cases}
$$

$$
y(n) = \begin{cases}
y_0, & n = 1;\\
3^{l(n)-2} - x\bigl(n - 4^{l(n)-2}\bigr) + y\bigl(n - 4^{l(n)-2}\bigr) + x_0, & b(n)=2,\\
2\cdot 3^{l(n)-2} + x\bigl(n - 2\cdot 4^{l(n)-2}\bigr) - x_0 + y_0, & b(n)=3,\\
2\cdot 3^{l(n)-2} + y\bigl(n - 3\cdot 4^{l(n)-2}\bigr), & b(n)=4.
\end{cases}
$$

These formulas can be further generalised, for example by including the segment length between consecutive vertices. However, in our task all snowflakes have the same size, and we can scale them by adjusting the image dimensions.

## Koch Snowflake

Now we need to construct the Koch snowflake. Here it is no longer possible to define the coordinates $x$ and $y$ only by the vertex number $n$, because, for example, vertex number $3$ can have coordinates $(0,1)$ (first iteration, $i=1$, when the snowflake is an equilateral triangle) or $(2,1)$ (case $i>1$). However, given the vertex number and the iteration number, we can determine the coordinates using the following formulas:

$$
x(n,i) = \begin{cases}
x(n), & 1 \le n \le 4^{i-1},\\
3^{i-1} - y\bigl(n - 4^{i-1}\bigr), & 4^{i-1}+1 \le n \le 3\cdot 4^{i-1},
\end{cases}
$$

$$
y(n,i) = \begin{cases}
y(n), & 1 \le n \le 4^{i-1},\\
3^{i-1} + x\bigl(n - 4^{i-1}\bigr) - y\bigl(n - 4^{i-1}\bigr), & 4^{i-1}+1 \le n \le 3\cdot 4^{i-1}.
\end{cases}
$$

These formulas are valid for $n \ge 1$ and $n \le 3\cdot 4^{i-1}$. The upper bound comes from the fact that the Koch snowflake of iteration $i$ has exactly $3\cdot 4^{i-1}$ vertices.

If we want to build the snowflake starting at $O = (x_0, y_0)$, we obtain:

$$
x(n,i) = \begin{cases}
x(n), & 1 \le n \le 4^{i-1},\\
3^{i-1} - y\bigl(n - 4^{i-1}\bigr) + x_0 + y_0, & 4^{i-1}+1 \le n \le 3\cdot 4^{i-1},
\end{cases}
$$

$$
y(n,i) = \begin{cases}
y(n), & 1 \le n \le 4^{i-1},\\
3^{i-1} + x\bigl(n - 4^{i-1}\bigr) - y\bigl(n - 4^{i-1}\bigr) - x_0 + 2y_0, & 4^{i-1}+1 \le n \le 3\cdot 4^{i-1}.
\end{cases}
$$

![Koch snowflake, iteration 2](asy/koch_snowflake_2.png)
![Koch snowflake, iteration 3](asy/koch_snowflake_3.png)

## Operations on Snowflakes

### Translation

Let us look at one of the first frames, rotated by $30^\circ$, from the provided video:

![First frame](img/img_1.png)

For convenience, number some snowflakes.

Notice that snowflake $8$ is strictly above snowflake $1$, and we assume that snowflake $8$ touches snowflake $1$, just as snowflake $5$ touches snowflake $4$. The slight difference in the image can be attributed to poor video quality and the discrepancy between frame $k$ and $k+1$. Snowflakes $2$ and $3$ lie on the same horizontal line. Moreover, snowflake $7$ is to the right and above relative to snowflake $8$.

Continuing to examine these $8$ snowflakes, we can identify $8$ directions of interest. Let $S = (x, y)$ be an arbitrary point in the affine coordinate system. Define the following translation vectors:

1. **N** (North) – shift $S + (2k, -2k)$;
2. **S** (South) – shift $S + (-2k, 2k)$;
3. **W** (West) – shift $S + (-3k, -3k)$;
4. **E** (East) – shift $S + (3k, 3k)$;
5. **NE** (North-East) – shift $S + (4k-1, 2k+1)$;
6. **NW** (North-West) – shift $S + (-2k-1, -4k+1)$;
7. **SE** (South-East) – shift $S + (2k+1, 4k-1)$;
8. **SW** (South-West) – shift $S + (-4k+1, -2k-1)$.

Here $k = 3^{i-2}$, where $i$ (iterations) is the snowflake iteration number. For $i = 2$ we get:

![Direction vectors](asy/directions.png)

Having these translation vectors, we can build snowflake number $1$ and then construct all $8$ previously considered snowflakes relative to it.

![Shifted snowflakes, i=3](asy/shift_snowflakes_3.png)
![Shifted snowflakes, i=4](asy/shift_snowflakes_4.png)

### Stretching and Compression

Fix one frame of the video and duplicate it with overlay so that identical parts coincide:

![Overlay of frames](img/img_2.png)

For convenience, rotate them by $30^\circ$ and examine the elements that look like stretched Koch snowflakes:

![Stretched elements](img/img_3.png)

We will continue to call these stretched objects simply snowflakes. Notice that in snowflakes numbered $1$–$4$ (red numbers) and in snowflakes numbered $5$–$8$ (blue numbers), the following triangles appear:

![Triangles](img/img_4.png)

Let us describe this formally. First, we slightly modify the snowflakes: add $6$ additional vertices that duplicate existing vertices with indices  
$n = 1,\; 2\cdot 4^{i-2}+1,\; 4\cdot 4^{i-2}+1,\; 6\cdot 4^{i-2}+1,\; 8\cdot 4^{i-2}+1,\; 10\cdot 4^{i-2}+1$. Consequently, the numbering changes. Illustrate this with an example for $i=2$:

![Duplication of points](asy/duplication_of_points_2.png)

Now we can split the vertex set into $6$ overlapping parts. Consider the set of vertex numbers $\left[1;\;12\cdot 4^{i-2}+6\right]$. The parts are defined as follows:

1. $\left[1;\;4\cdot 4^{i-2}+2\right]$; for $i=2$: $[1;6]$;
2. $\left[2\cdot 4^{i-2}+2;\;6\cdot 4^{i-2}+3\right]$; for $i=2$: $[4;9]$;
3. $\left[4\cdot 4^{i-2}+3;\;8\cdot 4^{i-2}+4\right]$; for $i=2$: $[7;12]$;
4. $\left[6\cdot 4^{i-2}+4;\;10\cdot 4^{i-2}+5\right]$; for $i=2$: $[10;15]$;
5. $\left[8\cdot 4^{i-2}+5;\;12\cdot 4^{i-2}+6\right]$; for $i=2$: $[13;18]$;
6. $\left[10\cdot 4^{i-2}+6;\;12\cdot 4^{i-2}+6\right] \cup \left[0;\;2\cdot 4^{i-2}+1\right]$; for $i=2$: $[16;18] \cup [0;3]$.

If we apply translation operations only to certain parts of the snowflakes rather than to the whole, we can obtain the desired result. For red‑numbered snowflakes we apply translations to parts $2$, $4$ and $6$; for blue‑numbered snowflakes to parts $1$, $3$ and $5$. The corresponding function is:

```c++
void stretching_part(int part, int iterations, pair[] snowV, pair dxy) {
  assert(part > 0 && part < 7, 
        "part must be between 1 and 6 (inclusive)");
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
```

Now let us draw the stretched snowflakes. Create $8$ snowflakes:

```c++
pair[][] snowV; 
int k = 3^(iterations - 2);
snowV.push(snowflake_vertexs(iterations));
snowV.push(snowflake_vertexs(iterations, (2*3^(iterations-2), 4*3^(iterations-2)))); 
snowV.push(snowflake_vertexs(iterations, (6*3^(iterations-2), 6*3^(iterations-2)))); 
snowV.push(snowflake_vertexs(iterations, (8*3^(iterations-2), 10*3^(iterations-2)))); 

snowV.push(snowflake_vertexs(iterations, 
  (-4*3^(iterations-2), 4*3^(iterations-2))
)); 
snowV.push(snowflake_vertexs(iterations, 
  (0, 6*3^(iterations-2))
)); 
snowV.push(snowflake_vertexs(iterations, 
  (2*3^(iterations-2), 10*3^(iterations-2))
)); 
snowV.push(snowflake_vertexs(iterations, 
  (6*3^(iterations-2), 12*3^(iterations-2))
)); 
```

![Initial snowflakes](img/img_5.png)

Apply the stretching operations:

```c++
stretching_part(2, iterations, snowV[0], (1*(iterations-1), 1*(iterations-1)));

stretching_part(1, iterations, snowV[1], (1*(iterations-1), 1*(iterations-1)));
stretching_part(3, iterations, snowV[1], (4*(iterations-1), 4*(iterations-1)));

stretching_part(2, iterations, snowV[2], (6*(iterations-1), 6*(iterations-1)));
stretching_part(4, iterations, snowV[2], (4*(iterations-1), 4*(iterations-1)));
stretching_part(6, iterations, snowV[2], (1*(iterations-1), 1*(iterations-1)));

stretching_part(1, iterations, snowV[3], (6*(iterations-1), 6*(iterations-1)));
stretching_part(3, iterations, snowV[3], (6*(iterations-1), 6*(iterations-1)));
stretching_part(5, iterations, snowV[3], (4*(iterations-1), 4*(iterations-1)));

stretching_part(3, iterations, snowV[4], (1*(iterations-1), 1*(iterations-1)));

stretching_part(2, iterations, snowV[5], (4*(iterations-1), 4*(iterations-1)));
stretching_part(4, iterations, snowV[5], (1*(iterations-1), 1*(iterations-1)));

stretching_part(1, iterations, snowV[6], (4*(iterations-1), 4*(iterations-1)));
stretching_part(3, iterations, snowV[6], (6*(iterations-1), 6*(iterations-1)));
stretching_part(5, iterations, snowV[6], (1*(iterations-1), 1*(iterations-1)));

stretching_part(2, iterations, snowV[7], (6*(iterations-1), 6*(iterations-1)));
stretching_part(4, iterations, snowV[7], (6*(iterations-1), 6*(iterations-1)));
stretching_part(6, iterations, snowV[7], (4*(iterations-1), 4*(iterations-1)));
```

![Result of stretching, i=3](asy/stretching_3.png)
![Result of stretching, i=4](asy/stretching_4.png)

Note that in $(1\cdot(i-1), 1\cdot(i-1))$ the coefficients are chosen so that the stretching result resembles what we saw in the frame. We add $i-1$ to preserve proportions: the distance between the first and second snowflake is smaller than between the second and third, even for higher iteration snowflakes.

The remaining coefficients are chosen analogously. As we will see later, these coefficients play a key role in determining the period of the entire animation.

## Preparing the Animation

Before starting the animation, notice a beautiful relation:

![Distance relation](img/img_6.png)

If we denote the distance marked in blue as $S$, then the distance marked in red is $2S$, and the green one is $3S$.

Also observe that after $15$ snowflakes a repetition occurs:

![Pattern repetition](img/img_7.png)

We are primarily interested in the interval marked with number $1$.

Now open the GIF from the question, for example in GIMP, and analyse each of the $20$ frames. We are interested in the trajectory of the snowflakes. One could analyse the video directly, but accuracy is not crucial, so it is easier to consider a smaller number of frames. Also, we will mentally rotate the image by $30^\circ$ back and forth.

The initial picture is:

![Initial layout](img/img_8.png)

Between snowflakes $1$ and $4$ the distance is $S$, between $2$ and $5$ – $2S$, between $3$ and $6$ – $3S$. Directions of motion are shown with arrows.

At the third frame we get:

![Third frame](img/img_9.png)

Snowflakes $1$ and $4$ touch, the distance between $2$ and $5$ becomes $S$, between $3$ and $6$ – $2S$. Also at this frame, the snowflakes after $1$ and $4$ form the pattern we created when discussing stretching and compression.

At the fifth frame:

![Fifth frame](img/img_10.png)

Snowflakes $2$ and $5$ touch, the distance between $3$ and $6$ becomes $S$.

At the seventh frame:

![Seventh frame](img/img_11.png)

Snowflakes $3$ and $6$ touch.

## Creating the First Frame

Now let us move to the actual implementation.

![First frame](img/img_12.png)

First, create the red block number $1$, then block $2$. Their creation is already familiar. Then create block $3$ as a copy of block $1$ shifted. Similarly create block $4$ as a copy of block $2$.

![First frame (construction)](asy/first_frame_3.png)

## Main Animation Function

Implement the animation as follows:

```c++
int steps = 4;
int all_frame = 16*steps; // 16 * steps

animation a = animation(prefix="snowflake_animation");
a.add(frame1);

for (int i = 0; i <= all_frame - 1; ++ i){
  picture pic;
  size(pic, width, height);
  for(int n = 0; n < snowV.length # 16; ++n){
      snowV[n*16    ] = update_snowflake_by_frame(pic, 
                              (i)          % all_frame+1, snowV[n*16    ]);
      snowV[n*16 + 1] = update_snowflake_by_frame(pic, 
                              (i+9*steps)  % all_frame+1, snowV[n*16 + 1]);
      snowV[n*16 + 2] = update_snowflake_by_frame(pic, 
                              (i+2*steps)  % all_frame+1, snowV[n*16 + 2]);
      snowV[n*16 + 3] = update_snowflake_by_frame(pic, 
                              (i+11*steps) % all_frame+1, snowV[n*16 + 3]);
      snowV[n*16 + 4] = update_snowflake_by_frame(pic, 
                              (i+4*steps)  % all_frame+1, snowV[n*16 + 4]);
      snowV[n*16 + 5] = update_snowflake_by_frame(pic, 
                              (i+13*steps) % all_frame+1, snowV[n*16 + 5]);
      snowV[n*16 + 6] = update_snowflake_by_frame(pic, 
                              (i+6*steps)  % all_frame+1, snowV[n*16 + 6]);
      snowV[n*16 + 7] = update_snowflake_by_frame(pic, 
                              (i+15*steps) % all_frame+1, snowV[n*16 + 7]);

      snowV[n*16 +  8] = update_snowflake_by_frame(pic, 
                              (i+8*steps) % all_frame+1, snowV[n*16 +  8]); 
      snowV[n*16 +  9] = update_snowflake_by_frame(pic, 
                              (i+1*steps) % all_frame+1, snowV[n*16 +  9]);
      snowV[n*16 + 10] = update_snowflake_by_frame(pic, 
                              (i+10*steps)% all_frame+1, snowV[n*16 + 10]); 
      snowV[n*16 + 11] = update_snowflake_by_frame(pic, 
                              (i+3*steps) % all_frame+1, snowV[n*16 + 11]);
      snowV[n*16 + 12] = update_snowflake_by_frame(pic, 
                              (i+12*steps)% all_frame+1, snowV[n*16 + 12]);
      snowV[n*16 + 13] = update_snowflake_by_frame(pic, 
                              (i+5*steps) % all_frame+1, snowV[n*16 + 13]);
      snowV[n*16 + 14] = update_snowflake_by_frame(pic, 
                              (i+14*steps)% all_frame+1, snowV[n*16 + 14]);
      snowV[n*16 + 15] = update_snowflake_by_frame(pic, 
                              (i+7*steps) % all_frame+1, snowV[n*16 + 15]);
  }

  a.add(pic);
}
```

The main work is done by the function `update_snowflake_by_frame`:

```c++
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
  fill(pic, snow, color_snowflake);
  return snowV;
}
```

There are $16$ main stages in the animation. To add extra smoothness, each stage is divided into `steps` sub‑frames. This is the first time we use rational numbers. If we wanted to avoid this, we could rescale the snowflakes so that, for example, the first vertex has coordinates $(0,0)$ and the second not $(1,1)$ but $(\text{steps}, \text{steps})$.

Also note that for a snowflake (e.g., number $1$) to go through all $16$ stages, each consisting of `steps` steps, we need $\text{all\_frames} = 16 \cdot \text{steps}$ frames. During these `all_frames` the snowflake will be shifted by $12\cdot (i-1)$, where $i$ is the chosen snowflake iteration. We will come back to this; but first we discuss the viewport and the required rotation angle.

## Visible Area

Since the final display will be in Cartesian coordinates, we need to perform a transformation. According to the [Asymptote documentation](https://asymptote.sourceforge.io/doc/Transforms.html):

```txt
Asymptote makes extensive use of affine transforms. A pair (x,y) is transformed 
by the transform t=(t.x,t.y,t.xx,t.xy,t.yx,t.yy) to (x',y'), where

x' = t.x + t.xx * x + t.xy * y
y' = t.y + t.yx * x + t.yy * y

This is equivalent to the PostScript transformation [t.xx t.yx t.xy t.yy t.x t.y].
```

Thus, in our case it looks like:

```c++
pair e1 = (1/2, sqrt(3)/2);
pair e2 = (1/2, -sqrt(3)/2);
transform T = (0,0,e1.x, e2.x, e1.y, e2.y); // affine -> Cartesian
```

Because we also need to apply a $30^\circ$ rotation, we finally obtain:

```c++
pair e1_rot = rotate(-30) * e1;
pair e2_rot = rotate(-30) * e2;
transform T = (0,0, e1_rot.x, e2_rot.x, e1_rot.y, e2_rot.y);
```

![Rotation by 30 degrees](asy/rotate_frame1.png)

Notice that originally in the video we see two full ovals; one of them is formed by snowflakes numbered $1$–$4$ and $25$–$28$. We duplicate the pattern several times vertically and once horizontally (horizontal duplication is necessary for seamlessness).

![Pattern duplication](asy/duplication_pattern.png)

Next, we select a rectangle for cropping. It is hard to define it strictly from the video. On one hand, it looks like a square, but measurements show its width is $422$ pixels and height $406$ pixels. This could be an error (like the rotation angle – measured in Inkscape it gave $30.19514^\circ$). Since we do not need pixel‑perfect reproduction, we set the tilt angle to $30^\circ$ and define the visible rectangle as:

```c++
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

real width = abs(D.x - B.x);
real height = abs(A.y - C.y);
write("width = " + string(width, 2)); 
write("height = " + string(height, 2));

path viewRectD = Aprime--Bprime--Cprime--Dprime--cycle;

draw(pic, viewRect, red+linewidth(0.2));
draw(pic, viewRectD, blue+linewidth(0.5));
```

The red rectangle is defined in the affine coordinate system; based on it we build a rectangle whose sides are parallel to the axes in the Cartesian coordinate system.

![Visible area](asy/visiable_area.png)

## Infinite Animation

The last thing we need to determine is the number of frames after which repetition occurs. Consider the following image:

![Pattern repetition](img/img_13.png)

Repetition occurs when snowflake number $1$ takes the place of snowflake number $2$. Find this distance. Between these snowflakes there are $16$ snowflakes, and they undergo $2$ stretching events. Hence the distance between them is

$$
S(i) = 16\cdot 3^{i-1} + 2\cdot 6\cdot (i-1).
$$

For $i = 3$ we get $S = 168$. This can be verified from the image: snowflake $2$ has coordinates $(279,225)$, snowflake $1$ has $(111,57)$, the difference is $(168,168)$.

We already know that over `all_frames` the shift is $u(i) = 12\cdot(i-1)$. Then

$$
K(i) = \frac{S(i)}{u(i)} = \frac{16\cdot 3^{i-1} + 2\cdot 6\cdot (i-1)}{12\cdot(i-1)}.
$$

For different $i$ we obtain:

| $i$ | 3 | 4 | 5 | 6 | 7 |
|------|---|---|---|---|---|
| $K(i)$ | 7 | 13 | 28 | $\frac{329}{5}$ | 163 |

Thus, for $i = 3$ we need $7\cdot \text{all\_frames} = 7\cdot 16\cdot \text{steps}$ frames. Since we set `steps = 4`, we need $7\cdot 16 \cdot 4 = 448$ frames. If the frame delay is the same as in the video (100 ms), the video length will be $448 \cdot 0.1 = 44.8$ seconds.

As an example, consider the concrete case to estimate file size and runtime. Save all $449$ frames as PDF files. Each frame size is $1200\times 1200$. Asymptote took about $3$ minutes; total size of all files is $7.2$ MB. Then we create a GIF using ImageMagick. Since only $2$ colours are used, we first create a palette:

```bash
convert xc:white xc:orange +append palette.png
```

Then run:

```bash
time convert -density 96 -delay 10 -loop 0 -layers Optimize -colors 2 -dither None -remap ./palette.png frames/frame_{0001..0449}.pdf animation_449.gif
```

Result:  
real 7m54.040s, user 8m34.427s, sys 1m51.682s.  
Final GIF size – 22 MB. Duration – 44.90 seconds.

Be careful: during the process `convert` consumed up to 64 GB of RAM (mainly because of `-density 96`, which results in frames of $1600\times 1493$).

We can further optimise with `gifsicle`:

```bash
time gifsicle -O3 --lossy=80 --colors 2 animation_449.gif -o animation_449_opt.gif
```

Result: real 2m21.253s, user 2m20.780s, sys 0m0.039s.  
File size reduced to 16 MB (without changing resolution).

![Infinite Koch snowflake animation](asy/animation_449_opt.gif)

The full animation code can be found in [asy/main_animation.asy](asy/main_animation.asy);

Of course, one can create PNG files of arbitrary size from the PDFs, and instead of GIF one can create MP4 or WebP. One can also change the colour, speed, tilt angle, and iteration number.

## Conclusion

We have thoroughly analysed the mathematical foundations for constructing the Koch curve and snowflake, derived recurrence formulas with the possibility of translation and rotation, described stretching/compression operations for individual parts of the snowflake, built the visible area, and calculated the period of the animation. The implementation in Asymptote demonstrated the practical feasibility of creating a long animation with high quality and acceptable file size. The resulting GIF file (449 frames, 44.9 seconds) has a size of 16 MB after additional optimisation. The proposed approach can be adapted to other programming languages and allows the creation of infinite animations with periodic pattern repetition.