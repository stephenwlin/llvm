; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=core-avx2 -mattr=avx2,+fma -fp-contract=fast | FileCheck %s -check-prefix=CHECK-FAST
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=core-avx2 -mattr=avx2,+fma | FileCheck %s -check-prefix=CHECK-SAFE

; CHECK-FAST-LABEL: test_add_1
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_1
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vaddsd
; CHECK-SAFE: ret
define double @test_add_1(double %a0, double %a1, double %a2) {
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ret double %res
}

; CHECK-FAST-LABEL: test_add_2
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_2
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vaddsd
; CHECK-SAFE: ret
define double @test_add_2(double %a0, double %a1, double %a2) {
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ret double %res
}

; CHECK-FAST-LABEL: test_add_3
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_3
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {double, double} @test_add_3(i1 zeroext %i0, double %a1, double %a2) {
  %a0 = uitofp i1 %i0 to double
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_4
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_4
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {double, double} @test_add_4(double %a0, i1 zeroext %i1, double %a2) {
  %a1 = uitofp i1 %i1 to double
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ; use of %a1 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a1, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_5
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_5
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {double, double} @test_add_5(i1 zeroext %c0, double %a1, double %a2) {
  %b0 = uitofp i1 %c0 to double
  %a0 = fsub double 1.000000e+00, %b0
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_6
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_6
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {double, double} @test_add_6(double %a0, i1 zeroext %c1, double %a2) {
  %b1 = uitofp i1 %c1 to double
  %a1 = fsub double 1.000000e+00, %b1
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ; use of %a1 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a1, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_7
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_7
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vaddsd
; CHECK-SAFE: ret
define {double, double} @test_add_7(i1 zeroext %c0, double %a1, double %a2) {
  %b0 = uitofp i1 %c0 to double
  %a0 = fsub double 0.000000e+00, %b0
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_8
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_8
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vaddsd
; CHECK-SAFE: ret
define {double, double} @test_add_8(double %a0, i1 zeroext %c1, double %a2) {
  %b1 = uitofp i1 %c1 to double
  %a1 = fsub double 0.000000e+00, %b1
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ; use of %a1 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a1, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_9
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_9
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vaddsd
; CHECK-SAFE: ret
define {double, double} @test_add_9(i8 zeroext %b0, double %a1, double %a2) {
  %a0 = uitofp i8 %b0 to double
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ;  use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_10
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_10
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vaddsd
; CHECK-SAFE: ret
define {double, double} @test_add_10(double %a0, i8 zeroext %b1, double %a2) {
  %a1 = uitofp i8 %b1 to double
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ; use of %a1 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a1, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_11
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_11
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {double, double} @test_add_11(double %y, double %z, double %a1, double %a2) {
  %c0 = fcmp ogt double %y, %z
  %b0 = uitofp i1 %c0 to double
  %a0 = fsub double 1.000000e+00, %b0
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_12
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_12
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {double, double} @test_add_12(double %a0, double %y, double %z, double %a2) {
  %c1 = fcmp ogt double %y, %z
  %b1 = uitofp i1 %c1 to double
  %a1 = fsub double 1.000000e+00, %b1
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ; use of %a1 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a1, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_add_13
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_13
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {float, double, double} @test_add_13(i1 zeroext %i0, double %a1, double %a2) {
  %b0 = uitofp i1 %i0 to float
  %a0 = fpext float %b0 to double
  %x = fmul double %a0, %a1
  %res = fadd double %x, %a2
  ; uses of %b1 and %a1 so they do not get optimized away
  %r0 = insertvalue {float, double, double} undef, float %b0, 0
  %r1 = insertvalue {float, double, double} %r0, double %a0, 1
  %r2 = insertvalue {float, double, double} %r1, double %res, 2
  ret {float, double, double} %r2
}

; CHECK-FAST-LABEL: test_add_14
; CHECK-FAST: vfmadd213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_add_14
; CHECK-SAFE: vfmadd213sd
; CHECK-SAFE: ret
define {float, double, double} @test_add_14(double %a0, i1 zeroext %i1, double %a2) {
  %b1 = uitofp i1 %i1 to float
  %a1 = fpext float %b1 to double
  %x = fmul double %a2, %a1
  %res = fadd double %a0, %x
  ; uses of %b1 and %a1 so they do not get optimized away
  %r0 = insertvalue {float, double, double} undef, float %b1, 0
  %r1 = insertvalue {float, double, double} %r0, double %a1, 1
  %r2 = insertvalue {float, double, double} %r1, double %res, 2
  ret {float, double, double} %r2
}

; CHECK-FAST-LABEL: test_sub_1
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_1
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vsubsd
; CHECK-SAFE: ret
define double @test_sub_1(double %a0, double %a1, double %a2) {
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ret double %res
}

; CHECK-FAST-LABEL: test_sub_2
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_2
; CHECK-SAFE: vfmsub213sd
; CHECK-SAFE: ret
define {double, double} @test_sub_2(i1 zeroext %i0, double %a1, double %a2) {
  %a0 = uitofp i1 %i0 to double
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_sub_3
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_3
; CHECK-SAFE: vfmsub213sd
; CHECK-SAFE: ret
define {double, double} @test_sub_3(i1 zeroext %c0, double %a1, double %a2) {
  %b0 = uitofp i1 %c0 to double
  %a0 = fsub double 1.000000e+00, %b0
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_sub_4
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_4
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vsubsd
; CHECK-SAFE: ret
define {double, double} @test_sub_4(i1 zeroext %c0, double %a1, double %a2) {
  %b0 = uitofp i1 %c0 to double
  %a0 = fsub double 0.000000e+00, %b0
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_sub_5
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_5
; CHECK-SAFE: vmulsd
; CHECK-SAFE: vsubsd
; CHECK-SAFE: ret
define {double, double} @test_sub_5(i8 zeroext %b0, double %a1, double %a2) {
  %a0 = uitofp i8 %b0 to double
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_sub_6
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_6
; CHECK-SAFE: vfmsub213sd
; CHECK-SAFE: ret
define {double, double} @test_sub_6(double %y, double %z, double %a1, double %a2) {
  %c0 = fcmp ogt double %y, %z
  %b0 = uitofp i1 %c0 to double
  %a0 = fsub double 1.000000e+00, %b0
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ; use of %a0 so it does not get optimized away
  %r0 = insertvalue {double, double} undef, double %a0, 0
  %r1 = insertvalue {double, double} %r0, double %res, 1
  ret {double, double} %r1
}

; CHECK-FAST-LABEL: test_sub_7
; CHECK-FAST: vfmsub213sd
; CHECK-FAST: ret
; CHECK-SAFE-LABEL: test_sub_7
; CHECK-SAFE: vfmsub213sd
; CHECK-SAFE: ret
define {float, double, double} @test_sub_7(i1 zeroext %i0, double %a1, double %a2) {
  %b0 = uitofp i1 %i0 to float
  %a0 = fpext float %b0 to double
  %x = fmul double %a0, %a1
  %res = fsub double %x, %a2
  ; uses of %b0 and %a0 so they do not get optimized away
  %r0 = insertvalue {float, double, double} undef, float %b0, 0
  %r1 = insertvalue {float, double, double} %r0, double %a0, 1
  %r2 = insertvalue {float, double, double} %r1, double %res, 2
  ret {float, double, double} %r2
}
