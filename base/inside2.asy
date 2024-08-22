// given 3 colinear points, return true if point z lies between points
// z0 and z1.
bool insideSegment(pair z0, pair z1, pair z) {
  if(z == z1 || z == z0) return true;
  if(z0 == z1) return false;
  real norm = sqrt(max(abs2(z0), abs2(z1), abs2(z)));
  pair h = z0+unit(z1-z0)*I*norm;
  int s1 = sgn(orient(z0,z,h));
  int s2 = sgn(orient(z1,z,h));
  return s1 != s2;
}

struct StraightContribution {
  pair outside;
  int count=0;

  void operator init(pair outside)  {
    this.outside=outside;
  }

  bool onBoundary(pair z0, pair z1, pair z) {
    int s1 = sgn(orient(z,z0,z1));
    if (s1 == 0)
      return insideSegment(z0,z1,z);

    int s2 = sgn(orient(outside,z0,z1));
    if (s1 == s2)
      return false;

    int s3 = sgn(orient(z,outside,z0));
    int s4 = sgn(orient(z,outside,z1));
    if (s3 != s4)
      count += s3;

    return false;
  }
}

// Return the winding number of polygon p relative to point z,
// or the largest odd integer if z lies on p.
int windingnumberPolygon(pair[] p, pair z) {
  pair M = maxbound(p);
  pair m = minbound(p);
  pair outside = 2*M-m;
  real epsilon = sqrt(realEpsilon);
  real Epsilon=abs(M-m)*epsilon;

  // Check that outside does not lie on the extension of the non-degenerate
  // line segment v--z
  bool checkColinear(pair v) {
    if (v != z && orient(v,z,outside) == 0) {
      pair normal=unit(z-v)*I;
      outside += normal*Epsilon;
      return true; // need to restart & recheck
    }
    return false;
  }

  bool check=true;
  while(check) {
    check = false;
    for (pair v : p)
      check = check || checkColinear(v);
  }

  var W=StraightContribution(outside);

  pair prevPoint = p[p.length - 1];
  for (int i=0; i < p.length; ++i) {
    pair currentPoint = p[i];
    if(W.onBoundary(prevPoint,currentPoint,z)) return undefined;
    prevPoint = currentPoint;
  }
  return W.count;
}

// Return true if point z lies on or inside polygon p.
bool insidePolygon(pair[] p, pair z) {
  return windingnumberPolygon(p,z) != 0;
}