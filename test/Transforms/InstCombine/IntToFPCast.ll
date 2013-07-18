; RUN: opt < %s -instcombine -S | FileCheck %s

define double @test1(i1 %a) {
; CHECK-LABEL: @test1(
; CHECK: select i1 %a, double 1.000000e+00, double 0.000000e+00
  %b = uitofp i1 %a to double
  ret double %b
}

define double @test2(i1 %a) {
; CHECK-LABEL: @test2(
; CHECK: select i1 %a, double -1.000000e+00, double 0.000000e+00
  %b = sitofp i1 %a to double
  ret double %b
}

define double @test3(i1 %a) {
; CHECK-LABEL: @test3(
; CHECK: select i1 %a, double 1.000000e+00, double 0.000000e+00
  %b = zext i1 %a to i8
  %c = uitofp i8 %b to double
  ret double %c
}

define double @test4(i8 %a) {
; CHECK-LABEL: @test4(
; CHECK: uitofp i8 %a to double
  %b = zext i8 %a to i16
  %c = uitofp i16 %b to double
  ret double %c
}

define double @test5(i1 %a) {
; CHECK-LABEL: @test5(
; CHECK: select i1 %a, double 1.000000e+00, double 0.000000e+00
  %b = zext i1 %a to i8
  %c = sitofp i8 %b to double
  ret double %c
}

define double @test6(i8 %a) {
; CHECK-LABEL: @test6(
; CHECK: uitofp i8 %a to double
  %b = zext i8 %a to i16
  %c = sitofp i16 %b to double
  ret double %c
}

define double @test7(i1 %a) {
; CHECK-LABEL: @test7(
; CHECK: select i1 %a, double -1.000000e+00, double 0.000000e+00
  %b = sext i1 %a to i8
  %c = sitofp i8 %b to double
  ret double %c
}

define double @test8(i8 %a) {
; CHECK-LABEL: @test8(
; CHECK: sitofp i8 %a to double
  %b = sext i8 %a to i16
  %c = sitofp i16 %b to double
  ret double %c
}

