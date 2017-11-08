module module1::fac

int fac(int N) = N <= 0 ? 1 : N * fac(N - 1); 

int fac2(0) = 1;  
default int fac2(int N) = N * fac2(N - 1); 

int fac3(int N)  { 
  if (N == 0)
     return 1;
  return N * fac3(N - 1);
}