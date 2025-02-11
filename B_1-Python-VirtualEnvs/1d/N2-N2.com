# MP4/cc-pVQZ Counterpoise=2

N2 N2 interaction potential

0 1   0 1    0 1
X(Fragment=1)
N(Fragment=1)   1 0.55
N(Fragment=1)   1 0.55             2 180.0
X(Fragment=2)   1 [{% print r %}]  2  90.0   3 0.0
N(Fragment=2)   4 0.55             1   0.0   2 0.0
N(Fragment=2)   4 0.55             1 180.0   2 0.0

