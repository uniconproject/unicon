double vec1_sum(const double x[], int n) {
  int i;
  double s = 0.0;
  for(i=0;i<n;i++) s += x[i];
  return s;
}

double vec2_sum(const double x[], int m, const double y[], int n) {
  int i;
  double s = 0.0;
  for(i=0;i<n;i++) s += x[i]+y[i];
  return s;
}
