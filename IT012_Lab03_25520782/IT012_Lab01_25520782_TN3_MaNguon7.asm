# Huynh Vi Khang - 25520782 - Buoc 3.3: Tong hop ba thang voi du lieu rieng
.data
prompt: .asciiz "Nhap chi so (kWh): "
m1:     .asciiz "Thang 1: "
m2:     .asciiz "Thang 2: "
m3:     .asciiz "Thang 3: "
tot:    .asciiz "Tong:    "
nl:     .asciiz "\n"

.text
.globl main
main:
    # --- Nhap 4 chi so ---
    # reading0 vao $s0
    li   $v0, 4
    la   $a0, prompt
    syscall
    li   $v0, 5
    syscall
    add  $s0, $v0, $zero

    # reading1 vao $s1
    li   $v0, 4
    la   $a0, prompt
    syscall
    li   $v0, 5
    syscall
    add  $s1, $v0, $zero

    # reading2 vao $s2
    li   $v0, 4
    la   $a0, prompt
    syscall
    li   $v0, 5
    syscall
    add  $s2, $v0, $zero

    # reading3 vao $s3
    li   $v0, 4
    la   $a0, prompt
    syscall
    li   $v0, 5
    syscall
    add  $s3, $v0, $zero

    # --- Tinh toan ---
    sub  $t0, $s1, $s0       # usage1 = reading1 - reading0
    sub  $t1, $s2, $s1       # usage2 = reading2 - reading1
    sub  $t2, $s3, $s2       # usage3 = reading3 - reading2
    
    add  $t3, $t0, $t1       # total = usage1 + usage2
    add  $t3, $t3, $t2       # total = total + usage3

    # --- In ket qua ---
    # Thang 1
    li   $v0, 4
    la   $a0, m1
    syscall
    li   $v0, 1
    add  $a0, $t0, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall

    # Thang 2
    li   $v0, 4
    la   $a0, m2
    syscall
    li   $v0, 1
    add  $a0, $t1, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall

    # Thang 3
    li   $v0, 4
    la   $a0, m3
    syscall
    li   $v0, 1
    add  $a0, $t2, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall

    # Tong
    li   $v0, 4
    la   $a0, tot
    syscall
    li   $v0, 1
    add  $a0, $t3, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall

    # Ket thuc chuong trinh
    li   $v0, 10
    syscall