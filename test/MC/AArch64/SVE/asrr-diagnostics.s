// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve  2>&1 < %s| FileCheck %s

asrr    z0.b, p8/m, z0.b, z0.b
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: restricted predicate has range [0, 7].
// CHECK-NEXT: asrr    z0.b, p8/m, z0.b, z0.b
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

asrr    z0.b, p0/m, z0.b, z0.d
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: asrr    z0.b, p0/m, z0.b, z0.d
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

asrr    z0.h, p0/m, z0.h, z0.d
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: asrr    z0.h, p0/m, z0.h, z0.d
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

asrr    z0.s, p0/m, z0.s, z0.d
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: asrr    z0.s, p0/m, z0.s, z0.d
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
