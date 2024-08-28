; RUN: llc -O0 %s -function-sections -basic-block-sections=all -unique-basic-block-section-names -mtriple=x86_64-windows-msvc -filetype=asm -frame-pointer=all -o - | FileCheck --check-prefix=X64 %s
; RUN: llc -O0 %s -basic-block-sections=all -unique-basic-block-section-names -mtriple=x86_64-windows-msvc -filetype=obj -frame-pointer=all -o - | llvm-readobj --codeview - | FileCheck --check-prefix=OBJ64 %s

;; COM: clang -emit-llvm -S basic-block-sections.cpp -g -fno-exceptions -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections -o basic-block-sections.ll
;; Generated with below C++ source:
;; int volatile x;
;; void bar() {
;;   ++x;
;; }
;; void foo() {
;;   --x;
;; }
;; void baz(bool b) {
;;   if (b)
;;     bar();
;; 
;;   foo();
;; }
;; 
;; int main() {
;;   baz(true);
;;   return x;
;; }

; X64:        .cv_file [[#CV_FILE_ID:]]
; X64:        .section  .text,"xr",one_only,[[BAZ_SYMBOL:".?baz@@YAX_N@Z"]]
; X64:        .globl [[BAZ_SYMBOL]]
; X64:        [[BAZ_SYMBOL]]:
; X64:        .cv_func_id [[#BEGIN_BAZ_FUNC_ID:]]
; X64:        .cv_loc [[#BEGIN_BAZ_FUNC_ID]] [[#CV_FILE_ID]] 8 0 # basic-block-sections.cpp:8:0 
; X64:        [[BEGIN_CV_DEF_RANGE_ENTRY_BB:.?Ltmp[0-9]+]]:
; X64:        .cv_loc [[#BEGIN_BAZ_FUNC_ID]] [[#CV_FILE_ID]] 9 0 # basic-block-sections.cpp:9:0 
; X64:        [[END_OF_BAZ_ENTRY_BB:.?LBB_END[0-9]+_[0-9]+]]

; X64:        .section  .text$[[BAZ_BB_PART_1_SYMBOL:.?baz@@YAX_N@Z\.__part\.1]],"xr",associative,[[BAZ_SYMBOL]]
; X64:        .globl "[[BAZ_BB_PART_1_SYMBOL]]"
; X64:        "[[BAZ_BB_PART_1_SYMBOL]]":
; X64:        .cv_func_id [[#BEGIN_BAZ_FUNC_ID+1]]
; X64:        [[BEGIN_CV_DEF_RANGE_BB_PART_1:.?Ltmp[0-9]+]]:
; X64:        .cv_loc [[#BEGIN_BAZ_FUNC_ID+1]] [[#CV_FILE_ID]] 10 0 # basic-block-sections.cpp:10:0
; X64:        [[END_OF_BAZ_BB_PART_1:.LBB_END[0-9]+_[0-9]+]]

; X64:        .section  .text$[[BAZ_BB_PART_2_SYMBOL:.?baz@@YAX_N@Z\.__part\.2]],"xr",associative,[[BAZ_SYMBOL]]
; X64:        .globl "[[BAZ_BB_PART_2_SYMBOL]]"
; X64:        "[[BAZ_BB_PART_2_SYMBOL]]":
; X64:        .cv_func_id [[#BEGIN_BAZ_FUNC_ID+2]]
; X64:        [[BEGIN_CV_DEF_RANGE_BB_PART_2:.?Ltmp[0-9]+]]:
; X64:        .cv_loc [[#BEGIN_BAZ_FUNC_ID+2]] [[#CV_FILE_ID]] 12 0 # basic-block-sections.cpp:12:0
; X64:        .cv_loc [[#BEGIN_BAZ_FUNC_ID+2]] [[#CV_FILE_ID]] 13 0 # basic-block-sections.cpp:13:0
; X64:        [[END_OF_BAZ_BB_PART_2:.LBB_END[0-9]+_[0-9]+]]

; X64:        .section  .text,"xr",one_only,[[BAZ_SYMBOL]]
; X64:        [[END_OF_BAZ:.Lfunc_end[0-9]+]]:

; X64:        .section .debug$S,"dr",associative,[[BAZ_SYMBOL]]
; X64:        .long [[END_OF_BAZ]]-[[BAZ_SYMBOL]] # Code size
; X64:        .cv_def_range [[BEGIN_CV_DEF_RANGE_ENTRY_BB]] [[END_OF_BAZ_ENTRY_BB]], frame_ptr_rel
; X64:        .cv_linetable [[#BEGIN_BAZ_FUNC_ID]], [[BAZ_SYMBOL]], [[END_OF_BAZ]]

; X64:        .section .debug$S,"dr",associative,"[[BAZ_BB_PART_1_SYMBOL]]"
; X64:        .long [[END_OF_BAZ_BB_PART_1]]-"[[BAZ_BB_PART_1_SYMBOL]]" # Code size
; X64:        .cv_def_range [[BEGIN_CV_DEF_RANGE_BB_PART_1]] [[END_OF_BAZ_BB_PART_1]], frame_ptr_rel
; X64:        .cv_linetable [[#BEGIN_BAZ_FUNC_ID+1]], "[[BAZ_BB_PART_1_SYMBOL]]", [[END_OF_BAZ_BB_PART_1]]

; X64:        .section .debug$S,"dr",associative,"[[BAZ_BB_PART_2_SYMBOL]]"
; X64:        .long [[END_OF_BAZ_BB_PART_2]]-"[[BAZ_BB_PART_2_SYMBOL]]" # Code size
; X64:        .cv_def_range [[BEGIN_CV_DEF_RANGE_BB_PART_2]] [[END_OF_BAZ_BB_PART_2]], frame_ptr_rel
; X64:        .cv_linetable [[#BEGIN_BAZ_FUNC_ID+2]], "[[BAZ_BB_PART_2_SYMBOL]]", [[END_OF_BAZ_BB_PART_2]]


; OBJ64:      CodeViewDebugInfo [
; OBJ64-NEXT:   Section: .debug$S
; OBJ64:        Subsection [
; OBJ64-NEXT:     SubSectionType: Symbols (0xF1)
; OBJ64:          GlobalProcIdSym {
; OBJ64:            DisplayName: baz
; OBJ64:          }
; OBJ64:        FunctionLineTable [
; OBJ64:          FilenameSegment [
; OBJ64:            LineNumberStart: 8
; OBJ64:            LineNumberStart: 9
; OBJ64:         ]
; OBJ64:       ]

; OBJ64:      CodeViewDebugInfo [
; OBJ64-NEXT:   Section: .debug$S
; OBJ64:        Subsection [
; OBJ64-NEXT:     SubSectionType: Symbols (0xF1)
; OBJ64:          GlobalProcIdSym {
; OBJ64:            DisplayName: baz
; OBJ64:          }
; OBJ64:        FunctionLineTable [
; OBJ64:          FilenameSegment [
; OBJ64:            LineNumberStart: 10
; OBJ64:         ]
; OBJ64:       ]

; OBJ64:      CodeViewDebugInfo [
; OBJ64-NEXT:   Section: .debug$S
; OBJ64:        Subsection [
; OBJ64-NEXT:     SubSectionType: Symbols (0xF1)
; OBJ64:          GlobalProcIdSym {
; OBJ64:            DisplayName: baz
; OBJ64:          }
; OBJ64:        FunctionLineTable [
; OBJ64:          FilenameSegment [
; OBJ64:            LineNumberStart: 12
; OBJ64:            LineNumberStart: 13
; OBJ64:         ]
; OBJ64:       ]

source_filename = "basic-block-sections.cpp"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@"?x@@3HC" = dso_local global i32 0, align 4, !dbg !0

; Function Attrs: mustprogress noinline nounwind optnone
define dso_local void @"?bar@@YAXXZ"() #0 !dbg !12 {
  %1 = load volatile i32, ptr @"?x@@3HC", align 4, !dbg !16
  %2 = add nsw i32 %1, 1, !dbg !16
  store volatile i32 %2, ptr @"?x@@3HC", align 4, !dbg !16
  ret void, !dbg !17
}

; Function Attrs: mustprogress noinline nounwind optnone
define dso_local void @"?foo@@YAXXZ"() #0 !dbg !18 {
  %1 = load volatile i32, ptr @"?x@@3HC", align 4, !dbg !19
  %2 = add nsw i32 %1, -1, !dbg !19
  store volatile i32 %2, ptr @"?x@@3HC", align 4, !dbg !19
  ret void, !dbg !20
}

; Function Attrs: mustprogress noinline nounwind optnone
define dso_local void @"?baz@@YAX_N@Z"(i1 noundef zeroext %0) #0 !dbg !21 {
  %2 = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, ptr %2, align 1
  call void @llvm.dbg.declare(metadata ptr %2, metadata !25, metadata !DIExpression()), !dbg !26
  %4 = load i8, ptr %2, align 1, !dbg !27
  %5 = trunc i8 %4 to i1, !dbg !27
  br i1 %5, label %6, label %7, !dbg !27

6:                                                ; preds = %1
  call void @"?bar@@YAXXZ"(), !dbg !28
  br label %7, !dbg !28

7:                                                ; preds = %6, %1
  call void @"?foo@@YAXXZ"(), !dbg !30
  ret void, !dbg !31
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: mustprogress noinline norecurse nounwind optnone
define dso_local noundef i32 @main() #2 !dbg !32 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @"?baz@@YAX_N@Z"(i1 noundef zeroext true), !dbg !35
  %2 = load volatile i32, ptr @"?x@@3HC", align 4, !dbg !36
  ret i32 %2, !dbg !36
}

attributes #0 = { mustprogress noinline nounwind optnone "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { mustprogress noinline norecurse nounwind optnone "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", linkageName: "?x@@3HC", scope: !2, file: !3, line: 1, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "clang", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "basic-block-sections.cpp", directory: "/llvm/test/DebugInfo/COFF", checksumkind: CSK_MD5, checksum: "e267a2b3930bf9db1fc0d8cf92317ea9")
!4 = !{!0}
!5 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !6)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 2, !"CodeView", i32 1}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 2}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{!"clang"}
!12 = distinct !DISubprogram(name: "bar", linkageName: "?bar@@YAXXZ", scope: !3, file: !3, line: 2, type: !13, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !15)
!13 = !DISubroutineType(types: !14)
!14 = !{null}
!15 = !{}
!16 = !DILocation(line: 3, scope: !12)
!17 = !DILocation(line: 4, scope: !12)
!18 = distinct !DISubprogram(name: "foo", linkageName: "?foo@@YAXXZ", scope: !3, file: !3, line: 5, type: !13, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !15)
!19 = !DILocation(line: 6, scope: !18)
!20 = !DILocation(line: 7, scope: !18)
!21 = distinct !DISubprogram(name: "baz", linkageName: "?baz@@YAX_N@Z", scope: !3, file: !3, line: 8, type: !22, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !15)
!22 = !DISubroutineType(types: !23)
!23 = !{null, !24}
!24 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!25 = !DILocalVariable(name: "b", arg: 1, scope: !21, file: !3, line: 8, type: !24)
!26 = !DILocation(line: 8, scope: !21)
!27 = !DILocation(line: 9, scope: !21)
!28 = !DILocation(line: 10, scope: !29)
!29 = distinct !DILexicalBlock(scope: !21, file: !3, line: 9)
!30 = !DILocation(line: 12, scope: !21)
!31 = !DILocation(line: 13, scope: !21)
!32 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 15, type: !33, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !15)
!33 = !DISubroutineType(types: !34)
!34 = !{!6}
!35 = !DILocation(line: 16, scope: !32)
!36 = !DILocation(line: 17, scope: !32)
