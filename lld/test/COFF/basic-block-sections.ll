; REQUIRES: x86
; RUN: llvm-as -o %t.obj %s 
; RUN: lld-link /out:%t.exe /entry:main /subsystem:console /opt:lldlto=0 /lldsavetemps /lto-basic-block-sections:all /lldmap:%t.map %t.obj 
; RUN: llvm-readobj -s %t.exe.lto.obj | FileCheck --check-prefix=SECNAMES %s  
; RUN: FileCheck --check-prefix=SYMS %s < %t.map

; RUN: echo 'foo.__part.2' > %torder
; RUN: echo 'foo' >> %torder
; RUN: echo 'foo.__part.1' >> %torder

; RUN: lld-link /out:%t2.exe /entry:main /subsystem:console /opt:lldlto=0 /lldsavetemps /lto-basic-block-sections:all /order:@%torder /lldmap:%t2.map %t.obj 
; RUN: llvm-readobj -s %t2.exe.lto.obj | FileCheck --check-prefix=SECNAMES %s  
; RUN: FileCheck --check-prefix=SYMS-ORDER %s < %t2.map

; SECNAMES: Name: foo
; SECNAMES: Section: .text
; SECNAMES: Name: .text$foo.__part.1
; SECNAMES: Section: .text$foo.__part.1
; SECNAMES: Name: .text$foo.__part.2
; SECNAMES: Section: .text$foo.__part.2

; SYMS: foo
; SYMS: foo.__part.1
; SYMS: foo.__part.2

; SYMS-ORDER: foo.__part.2
; SYMS-ORDER: foo
; SYMS-ORDER: foo.__part.1

target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @foo(i32 %b) local_unnamed_addr nounwind {
entry:
  %tobool.not = icmp eq i32 %b, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  tail call void @foo(i32 0)
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret void
}

define void @main() nounwind {
  call void @foo(i32 1)
  ret void
}

