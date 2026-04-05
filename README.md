# Koch Snowflake Animation

This repository contains materials for answering the StackExchange question:  
["I am trying to make a really cool animation using Koch snowflakes, but don't know how"](https://tex.stackexchange.com/questions/761136/i-am-trying-to-make-a-really-cool-animation-using-koch-snowflakes-but-dont-kno)

The project implements a **periodic infinite animation** of Koch snowflakes using affine coordinates, recursive formulas, and frame‑by‑frame deformation (stretching/shrinking) in **Asymptote**.

- Full research text and conclusions in Russian: [`main_ru.md`](main_ru.md)  
- Full research text and conclusions in English: [`main_eng.md`](main_eng.md)

## Brief Description

The animation is built on:

- An **affine basis** $e_1 = (1/2,\sqrt3/2)$ $e_2 = (1/2,-\sqrt3/2) $ allowing integer coordinates.
- **Recursive formulas** for the Koch curve vertices.
- **Duplication of vertices** to split the snowflake into $6$ overlapping parts, enabling independent stretching of selected segments.
- **16 animation stages** (each subdivided into `steps` sub‑frames) that apply translations or partial stretches to specific snowflake parts.
- A **periodicity calculation** giving the exact number of frames after which the pattern repeats ($K(i) = \frac{16\cdot3^{i-1}+12(i-1)}{12(i-1)}$; for $i=3$, $K=7$ full cycles).
- Conversion to Cartesian coordinates with a **30° rotation** and final rendering as PDF frames.
- **GIF creation** using a two‑colour palette and post‑optimisation with `gifsicle`.

The resulting animation for $i=3$ contains $449$ frames (44.9 seconds) and weighs only **16 MB** after optimisation.

![alt text](asy/animation_449_opt.gif)
## Requirements

- [Asymptote](https://asymptote.sourceforge.io/)
- ImageMagick (`convert`)  
- `gifsicle`  
- (optional) `ffmpeg` for WebP output

