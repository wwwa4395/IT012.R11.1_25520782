# Huynh Vi Khang - 25520782 - Ma nguon 4: Chuyen cau lenh thanh lenh hop ngu
.text
.globl main
main:
    addi $s0, $zero, 8       # y = 8
    addi $s1, $zero, 5       # z = 5
    addi $s2, $zero, 3       # w = 3
 
    # >>> cac lenh cho x1, x2, x3 va x4
    
    # x1 = y + z + w (vao $t0)
    add  $t0, $s0, $s1       # $t0 = y + z
    add  $t0, $t0, $s2       # $t0 = $t0 + w
    
    # x2 = (y + z) - (w + 5) (vao $t1, dung $t5 lam trung gian)
    add  $t1, $s0, $s1       # $t1 = y + z
    addi $t5, $s2, 5         # $t5 = w + 5
    sub  $t1, $t1, $t5       # $t1 = $t1 - $t5
    
    # x3 = y (sao chep vao $t2)
    add  $t2, $s0, $zero     # $t2 = y + 0
    
    # x4 = z - y (vao $t3)
    sub  $t3, $s1, $s0       # $t3 = z - y
 
    li   $v0, 10
    syscall