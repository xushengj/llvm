; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: %cheri128_purecap_llc -O2 -o - %s | FileCheck %s
; ModuleID = 'libxo.i'

%struct.xo_handle_s = type { i8 addrspace(200)* }

@b = common addrspace(200) global %struct.xo_handle_s zeroinitializer, align 32

; Function Attrs: nounwind
; Check that locally creating a va_list and then storing it to a global works
; (Yes, this is an odd thing to do.  See libxo for a real-world example)
; This is similar to cheri-sandbox-vaargs.ll, but ensures CheriPureCapABI can
; handle the optimiser turning AddrSpaceCast instructions into ConstantExpr's
define void @xo_emit(i8 addrspace(200)* %fmt, ...) {
; CHECK-LABEL: xo_emit:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cincoffset $c11, $c11, -64
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    csc $c24, $zero, 48($c11) # 16-byte Folded Spill
; CHECK-NEXT:    .cfi_offset 96, -16
; CHECK-NEXT:    cincoffset $c24, $c11, $zero
; CHECK-NEXT:    .cfi_def_cfa_register 96
; CHECK-NEXT:    cgetoffset $1, $c11
; CHECK-NEXT:    daddiu $2, $zero, -32
; CHECK-NEXT:    and $1, $1, $2
; CHECK-NEXT:    csetoffset $c11, $c11, $1
; CHECK-NEXT:    cgetoffset $25, $c12
; CHECK-NEXT:    lui $1, %hi(%neg(%gp_rel(xo_emit)))
; CHECK-NEXT:    daddu $1, $1, $25
; CHECK-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(xo_emit)))
; CHECK-NEXT:    cincoffset $c1, $c11, 32
; CHECK-NEXT:    csetbounds $c1, $c1, 16
; CHECK-NEXT:    csc $c3, $zero, 0($c1)
; CHECK-NEXT:    ld $2, %got_disp(.size.b)($1)
; CHECK-NEXT:    cmove $c1, $c13
; CHECK-NEXT:    ld $1, %got_disp(b)($1)
; CHECK-NEXT:    ld $2, 0($2)
; CHECK-NEXT:    cincoffset $c2, $c11, 0
; CHECK-NEXT:    csetbounds $c2, $c2, 16
; CHECK-NEXT:    cfromddc $c3, $1
; CHECK-NEXT:    csetbounds $c3, $c3, $2
; CHECK-NEXT:    csc $c3, $zero, 0($c2)
; CHECK-NEXT:    ctoptr $1, $c3, $c0
; CHECK-NEXT:    cgetnull $c13
; CHECK-NEXT:    csc $c1, $1, 0($ddc)
; CHECK-NEXT:    cincoffset $c11, $c24, $zero
; CHECK-NEXT:    clc $c24, $zero, 48($c11) # 16-byte Folded Reload
; CHECK-NEXT:    cjr $c17
; CHECK-NEXT:    cincoffset $c11, $c11, 64
; FIXME: we should just use the capability $c3 here instead of doing a ctoptr relative to $ddc
entry:
  %fmt.addr = alloca i8 addrspace(200)*, align 32, addrspace(200)
  %c = alloca %struct.xo_handle_s addrspace(200)*, align 32, addrspace(200)
  store i8 addrspace(200)* %fmt, i8 addrspace(200)* addrspace(200)* %fmt.addr, align 32
  store %struct.xo_handle_s addrspace(200)* @b, %struct.xo_handle_s addrspace(200)* addrspace(200)* %c, align 32
  %0 = load %struct.xo_handle_s addrspace(200)*, %struct.xo_handle_s addrspace(200)* addrspace(200)* %c, align 32
  %xo_vap = getelementptr inbounds %struct.xo_handle_s, %struct.xo_handle_s addrspace(200)* %0, i32 0, i32 0
  %xo_vap1 = addrspacecast i8 addrspace(200)* addrspace(200)* %xo_vap to i8*
  ; Load the address of b
  ; Store the va_list (passed in $c13) in the global
  call void @llvm.va_start.p200i8(i8* %xo_vap1)
  ret void
}

; Function Attrs: nounwind
declare void @llvm.va_start.p200i8(i8*) #0

attributes #0 = { nounwind }

