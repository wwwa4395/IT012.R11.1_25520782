# Huynh Vi Khang - 25520782 - Tinh dien nang tung thang, tong dien nang ca nam va tim thang tieu thu cao nhat.
# Ke hoach dung thanh ghi: $s0 = dia chi reading, $s1 = dia chi usage, $s2 = i (0..11), $s3 = 12, $s4 = tong dien nang, $s5 = dien nang cao nhat, $s6 = thang cao nhat, $t1-$t7 = bien tam.

.data
m1:      .asciiz "Thang "                                                 # Chuoi tien to in truoc so thu tu thang
m2:      .asciiz ": "                                                     # Chuoi ngan cach giua so thang va dien nang
mt:      .asciiz "Tong: "                                                 # Chuoi nhan in tong dien nang ca nam
mm:      .asciiz "Thang cao nhat: "                                       # Chuoi nhan in thang tieu thu cao nhat
lp:      .asciiz " ("                                                     # Dau mo ngoac tron truoc dien nang cao nhat
rp:      .asciiz ")"                                                      # Dau dong ngoac tron sau dien nang cao nhat
nl:      .asciiz "\n"                                                     # Ky tu xuong dong
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955                   # 7 chi so cong to dau tien (reading[0]..reading[6])
         .word 2210, 2440, 2625, 2775, 2895, 2995                         # 6 chi so cong to tiep theo (reading[7]..reading[12])
usage:   .space 48                                                        # Cap phat 48 byte (12 tu nho) cho mang dien nang 12 thang

.text
.globl main                                                               # Khai bao nhan main la diem bat dau toan cuc
main:
  la   $s0, reading                                                       # Nap dia chi nen cua mang reading vao $s0
  la   $s1, usage                                                         # Nap dia chi nen cua mang usage vao $s1
  addi $s2, $zero, 0                                                      # Khoi tao bien dem vong lap i = 0
  addi $s3, $zero, 12                                                     # Khoi tao so thang can duyet n = 12
  addi $s4, $zero, 0                                                      # Khoi tao tong dien nang ca nam $s4 = 0
  addi $s5, $zero, -1                                                     # Khoi tao dien nang cao nhat $s5 = -1 (de thang 1 luon cap nhat)
  addi $s6, $zero, 0                                                      # Khoi tao thang cao nhat $s6 = 0

Loop:
  beq  $s2, $s3, Done                                                     # Neu i == 12 thi thoat vong lap nhay den Done

  sll  $t1, $s2, 2                                                        # Tinh do doi theo byte: $t1 = i * 4
  add  $t2, $s0, $t1                                                      # Tinh dia chi cua reading[i]: $t2 = reading + i * 4
  lw   $t3, 0($t2)                                                        # Nap gia tri reading[i] vao thanh ghi $t3
  lw   $t4, 4($t2)                                                        # Nap gia tri reading[i+1] (cach 4 byte) vao $t4
  sub  $t5, $t4, $t3                                                      # Tinh dien nang thang (i+1): $t5 = reading[i+1] - reading[i]

  add  $t6, $s1, $t1                                                      # Tinh dia chi cua usage[i]: $t6 = usage + i * 4
  sw   $t5, 0($t6)                                                        # Luu dien nang vua tinh ($t5) vao usage[i]

  add  $s4, $s4, $t5                                                      # Cong don dien nang thang hien tai vao tong $s4

  slt  $t7, $s5, $t5                                                      # Dat $t7 = 1 neu $s5 < $t5 (thang hien tai cao hon ky luc cu)
  beq  $t7, $zero, SkipMax                                                # Neu $t7 == 0 (khong lon hon) thi bo qua cap nhat max
  add  $s5, $t5, $zero                                                    # Cap nhat dien nang cao nhat moi: $s5 = $t5
  addi $s6, $s2, 1                                                        # Cap nhat thang cao nhat moi: $s6 = i + 1

SkipMax:
  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, m1                                                            # Nap dia chi chuoi "Thang " vao $a0
  syscall                                                                 # Goi he thong de in chuoi "Thang "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  addi $a0, $s2, 1                                                        # Tinh so thu tu thang (i + 1) va dat vao $a0
  syscall                                                                 # Goi he thong de in so thu tu thang

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, m2                                                            # Nap dia chi chuoi ": " vao $a0
  syscall                                                                 # Goi he thong de in chuoi ": "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $t5, $zero                                                    # Chuyen gia tri dien nang ($t5) sang $a0
  syscall                                                                 # Goi he thong de in dien nang cua thang

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # Goi he thong de xuong dong

  addi $s2, $s2, 1                                                        # Tang bien dem vong lap: i = i + 1
  j    Loop                                                               # Nhay quay lai dau vong lap Loop

Done:
  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, mt                                                            # Nap dia chi chuoi "Tong: " vao $a0
  syscall                                                                 # Goi he thong de in chuoi "Tong: "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s4, $zero                                                    # Chuyen tong dien nang ca nam ($s4) sang $a0
  syscall                                                                 # Goi he thong de in tong dien nang

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # Goi he thong de xuong dong

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, mm                                                            # Nap dia chi chuoi "Thang cao nhat: " vao $a0
  syscall                                                                 # Goi he thong de in chuoi "Thang cao nhat: "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s6, $zero                                                    # Chuyen so thu tu thang cao nhat ($s6) sang $a0
  syscall                                                                 # Goi he thong de in thang cao nhat

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, lp                                                            # Nap dia chi chuoi " (" vao $a0
  syscall                                                                 # Goi he thong de in dau mo ngoac " ("

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s5, $zero                                                    # Chuyen dien nang cao nhat ($s5) sang $a0
  syscall                                                                 # Goi he thong de in gia tri dien nang cao nhat

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, rp                                                            # Nap dia chi chuoi ")" vao $a0
  syscall                                                                 # Goi he thong de in dau dong ngoac ")"

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # Goi he thong de xuong dong

  li   $v0, 10                                                            # Nap ma syscall 10 (ket thuc chuong trinh) vao $v0
  syscall                                                                 # Goi he thong de thoat chuong trinh