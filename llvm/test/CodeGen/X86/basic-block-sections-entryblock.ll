; COM: Tests to verify that the entry basic block is always placed at the beginning of its section.
; RUN: echo 'v1' > %t1
; RUN: echo 'f foo' >> %t1
; RUN: echo 'c2 0' >> %t1
; RUN: llc < %s -mtriple=x86_64-pc-linux -function-sections -basic-block-sections=%t1 -O0 | FileCheck %s -check-prefix=LINUX-SECTIONS1
; RUN: llc < %s -mtriple=x86_64-windows-msvc -function-sections -basic-block-sections=%t1 -O0 | FileCheck %s -check-prefix=MSVC-SECTIONS1

; RUN: echo 'v1' > %t2
; RUN: echo 'f foo' >> %t2
; RUN: echo 'c2' >> %t2
; RUN: llc < %s -mtriple=x86_64-pc-linux -function-sections -basic-block-sections=%t2 -O0 | FileCheck %s -check-prefix=LINUX-SECTIONS2
; RUN: llc < %s -mtriple=x86_64-windows-msvc -function-sections -basic-block-sections=%t2 -O0 | FileCheck %s -check-prefix=MSVC-SECTIONS2


define void @foo(i1 %a, i1 %b) {
b0:
  br i1 %a, label %b1, label %b2

b1:                                           ; preds = %b0
  ret void

b2:                                           ; preds = %b0
  ret void
}

;; Check that %b0 is emitted at the beginning of the function.
; LINUX-SECTIONS1:    .section .text.foo,"ax",@progbits
; LINUX-SECTIONS1:  foo:
; LINUX-SECTIONS1:  # %bb.0:             # %b0
; LINUX-SECTIONS1:    jne foo.cold
; LINUX-SECTIONS1:  # %bb.2:             # %b2
; LINUX-SECTIONS1:    retq
; LINUX-SECTIONS1:    .section .text.split.foo,"ax",@progbits
; LINUX-SECTIONS1:  foo.cold:            # %b1
; LINUX-SECTIONS1:    retq

; MSVC-SECTIONS1:    .section .text,"xr",one_only,foo
; MSCV-SECTIONS1:  foo:
; MSCV-SECTIONS1:  # %bb.0:             # %b0
; MSCV-SECTIONS1:    jne foo.cold
; MSCV-SECTIONS1:  # %bb.2:             # %b2
; MSCV-SECTIONS1:    retq
; MSCV-SECTIONS1:    .section .text$split,"xr",associative,foo
; MSCV-SECTIONS1:  foo.cold:            # %b1
; MSCV-SECTIONS1:    retq

; LINUX-SECTIONS2:    .section .text.foo,"ax",@progbits
; LINUX-SECTIONS2:  foo:
; LINUX-SECTIONS2:  # %bb.0:             # %b0
; LINUX-SECTIONS2:    je foo.__part.0
; LINUX-SECTIONS2:  # %bb.1:             # %b1
; LINUX-SECTIONS2:    retq
; LINUX-SECTIONS2:    .section .text.foo,"ax",@progbits
; LINUX-SECTIONS2:  foo.__part.0:        # %b2
; LINUX-SECTIONS2:    retq

; MSVC-SECTIONS2:    .section .text,"xr",one_only,foo
; MSVC-SECTIONS2:  foo:
; MSVC-SECTIONS2:  # %bb.0:             # %b0
; MSVC-SECTIONS2:    je foo.__part.0
; MSVC-SECTIONS2:  LBB0_1:              # %b1
; MSVC-SECTIONS2:    retq
; MSVC-SECTIONS2:    .section .text$foo.__part.0,"xr",associative,foo
; MSVC-SECTIONS2:  foo.__part.0:        # %b2
; MSVC-SECTIONS2:    retq