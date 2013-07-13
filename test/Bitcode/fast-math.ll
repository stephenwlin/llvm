; RUN: llvm-as < %s | llvm-dis > %t0
; RUN: opt -S < %s > %t1
; RUN: diff %t0 %t1

define double @foo(i1 %f, double %a, double %b) {
entry:
  %0 = fadd nsz double %a, %b
  %1 = fsub ninf double %0, %b
  %2 = fmul arcp double %1, %b
  %3 = fdiv nnan double %2, %b
  %4 = select fast i1 %f, double %a, double %b
  ret double %4
}
