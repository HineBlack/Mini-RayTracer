# Mini-RayTracer
参照 [Peter Shirley](https://github.com/petershirley) 的光线追踪课程 [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) 做的练习项目

## Usage (on windows):
下载项目，解压，执行 `run.bat`，同时注意
1. 需要在 `run.bat` 中指定 `Photoshop.exe` 路径
2. 需要安装 `MinGW` 并确保 `make.exe` `g++.exe` 位于系统环境变量中
3. 最终图像渲染耗时较长，在 `main.cc` 中降低图像宽高节省渲染时间

## Ch-02 Output an Image
> HW of ratracer: write a color interpolated .ppm image file


### Notes
[.ppm](https://en.wikipedia.org/wiki/Netpbm#PPM_example) 是一种非常简单的图像格式，非常适合我们做练习输出图像使用

### Task

- define an image with height & width both are 256 pixels
- write out an image which 4 corner's RGB value is:
<0, 255, 63>  | <255, 255, 63>
<0, 0, 63>    | <255, 0, 63>


## Ch-03 vec3 class

### Notes
- variables & methods for vec3 class
```cpp
// variable
public:
  double e[3];
  
// methods (all public)
vec3 operator-() const {}
double operator[](int i) const {}
double& operator[](int i) {}

vec3& operator+=(const vec3 &v) {}
vec3& operator*=(const double t) {}
vec3& operator/=(const double t) {}

double length() const {}
double length_squared() const {}
```

- vec3 unility functions
```cpp
inline std::ostream& operator<<(std::ostream &out, const vec3 &v) {}
inline vec3 operator+(const vec3 &u, const vec3 &v) {}
inline vec3 operator-(const vec3 &u, const vec3 &v) {}
inline vec3 operator*(const vec3 &u, const vec3 &v) {}
inline vec3 operator*(double t, const vec3 &v) {}
inline vec3 operator*(const vec3 &u, double t) {}
inline vec3 operator/(vec3 v, double t) {}
inline double dot(const vec3 &u, const vec3 &v) {}
inline vec3 cross(const vec3 &u, const vec3 &v) {}
inline vec3 unit_vector(vec3 v) {}
```

- Returning values by reference in C++
so that a function can be used as a left value in assignment
```cpp
double& operator[](int i) { return e[i]; }
// overloaded [] returns reference so the member can be modified like
vec[0] = 5; 
```

### Task
- define a vec3 class in vec.h
- a wrtie_color() utility func in color.h

## Ch-04 Rays, a Simple Camera, and Background

### Notes
- variables & methods for ray class
```cpp
public:
  point3 _origin;
  vec3 _direction;
  point3 at(double t) const {
    return _origin + t*_direction;
  }
```
- execute sequence
  1. cast rays to 2-dimensional image from `origin` to each pixel (image plane at z=-1)
  2. use normalized ray direction to interpolate between 2 colors

- `main()`
  1. Image section (define aspect ratio, width, height)
  2. Camera section (define viewport, focal length, origin, image lower left corner, etc.)
  3. Render section (use 2 for-loop to cast rays to 2-dimensional image, write out color image)

### Task
- define a ray class in ray.h

## Ch-05 Adding a Sphere

### Notes
- sphere intersection test:
solve the quadratic equation with respect to parameter `t`
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=t^2 \bf{b} \cdot \bf{b} + 2t\bf{b} \cdot (\bf{A} - \bf{C}) + (A-C) \cdot (A-C) - r^2 = 0"></p>
(use discriminant to perform the intersection test)

### Task
- render a sphere at `point3(0,0,-1)` witch `radius = 1`

## Ch-06 Surface Normals and Multiple Objects

### Notes
It's easy to compute a sphere normal:
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=N = (Normalize(r.at(t) - sphere.center()) + 1)*0.5"></p>

### Task
- use the sphere normal [x, y, z] as rendered color [r, g, b]

## Ch-07 Antialiasing
### Notes
sample a single pixel multiple times, each time with a random [x,y] within pixel, add all sampled color & divide by times

### Task
- Add a new sub-loop in Render section to sample a pixel multiple times

## Ch-08 Diffuse Materials
### Notes
- Randomlize the reflected ray direction:
  use a tangent unit sphere (the one on the same side of the surface) to randomlize the reflected ray.
- Make `ray_color()` function recursive to keep tracking the bounce after the originally casted ray hitted something, decay 0.5 on each bounce (absorbed).
- perform gamma correction (gamma 2 = ^1/2) 

### Task
- Define 3 (slightly) different diffuse materials

## Ch-09 Metal
### Notes
- 2 design approachs of a material class
  1. a universal material with lots of parameters and different material types just zero out some of those parameters.
  2. have an abstract material class that encapsulates behavior

- 2 things material needs to do
  1. Produce a scattered ray (or say it absorbed in incident ray)
  2. If scattered, say how much the ray should be attenuated

### Task
- Define a metal materials

## Ch-10 Dielectrics
### Notes
- Compute refraction
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=R^\prime = R^\prime_\perp + R^\prime_\| "></p>
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=R^\prime_\perp = \frac{\eta}{\eta^\prime} (R + \cos\theta n) "></p>
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=R^\prime_\| = - \sqrt{1-|R^\prime_\perp|^2 n} "></p>

### Task
- Define a dielectric materials

## Ch-11 Positionable Camera
### Notes
- use 2 points & 1 vector to set up the camera direction:
```cpp
point3 lookfrom;
point3 lookat;
vec3 vup;
```
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=backward = Normalize(lookfrom - lookat)"></p>
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=right = Normalize(cross(vup, backward)) "></p>
<p align="center"><img src="https://render.githubusercontent.com/render/math?math=up = cross(backward, right) "></p>

### Task
- Define a camera class

## Ch-12 Defocus Blur
### Notes
- Cast ray randomly from a unit disk * aperture to get a defocus blur
- Place the image plane exactly on the focus distance (so objects around there will keep focus & others bulrred by the randomized ray directions)

### Task
- Randomize the ray casted from camera, to get defocus effects
