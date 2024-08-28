;; This test verifies that basic-block-sections works with address-taken basic blocks.
; RUN: llc < %s -mtriple=x86_64 -basic-block-sections=all | FileCheck %s --check-prefixes=CHECK,ELF
; RUN: llc < %s -mtriple=x86_64-windows-msvc -basic-block-sections=all | FileCheck %s --check-prefixes=CHECK,COFF

define void @foo(i1 zeroext %0) nounwind {
entry:
  %1 = select i1 %0, ptr blockaddress(@foo, %bb1), ptr blockaddress(@foo, %bb2) ; <ptr> [#uses=1]
  indirectbr ptr %1, [label %bb1, label %bb2]

; CHECK:         .text
; ELF:         .section .text.foo,"ax",@progbits
; COFF:        .section .text,"xr"
; CHECK-LABEL: foo:
; ELF:           movl    $.Ltmp0, %eax
; ELF-NEXT:      movl    $.Ltmp1, %ecx
; COFF:          leaq    .Ltmp0(%rip), %rax
; COFF-NEXT:     leaq    .Ltmp1(%rip), %rcx
; CHECK-NEXT:    cmovneq %rax, %rcx
; CHECK-NEXT:    jmpq    *%rcx

bb1:                                                ; preds = %entry
  %2 = call i32 @bar()
  ret void
; ELF:         .section .text.foo,"ax",@progbits,unique,1
; COFF:        .section .text$foo.__part.1,"xr"
; CHECK-LABEL:  .Ltmp0:
; CHECK-NEXT:  foo.__part.1
; CHECK-NEXT:    callq   bar
;

bb2:                                                ; preds = %entry
  %3 = call i32 @baz()
  ret void
; ELF:         .section .text.foo,"ax",@progbits,unique,2
; COFF:        .section .text$foo.__part.2,"xr"
; CHECK-LABEL:  .Ltmp1:
; CHECK-NEXT:  foo.__part.2
; CHECK-NEXT:    callq   baz
}

declare i32 @bar()
declare i32 @baz()
