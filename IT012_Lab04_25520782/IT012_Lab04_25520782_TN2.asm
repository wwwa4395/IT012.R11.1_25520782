# Huynh Vi Khang - 25520782 - Nhap dien nang (kWh), xac dinh bac gia dien (1-4) va in ket qua.
# Ke hoach dung thanh ghi: $s0 = dien nang (kWh), $s1 = bac dien nang (1..4), $t0 = bien tam ket qua so sanh.

.data
prompt: .asciiz "Nhap dien nang (kWh): "  # Chuoi thong bao yeu cau nhap dien nang
msg:    .asciiz "Bac: "                   # Chuoi nhan in truoc gia tri bac dien
nl:     .asciiz "\n"                      # Ky tu xuong dong

.text
.globl main                               # Khai bao nhan main la diem bat dau toan cuc
main:
  li   $v0, 4                             # Nap ma syscall 4 (in chuoi ky tu) vao $v0
  la   $a0, prompt                        # Nap dia chi chuoi prompt vao thanh ghi doi so $a0
  syscall                                 # Goi he thong de in chuoi "Nhap dien nang (kWh): "

  li   $v0, 5                             # Nap ma syscall 5 (doc so nguyen tu ban phim) vao $v0
  syscall                                 # Goi he thong de doc so kWh nguoi dung nhap (luu vao $v0)
  add  $s0, $v0, $zero                    # Sao chep gia tri dien nang tu $v0 sang thanh ghi $s0

  slti $t0, $s0, 101                      # Dat $t0 = 1 neu $s0 < 101 (tuc dien nang <= 100), nguoc lai $t0 = 0
  bne  $t0, $zero, Bac1                   # Nhay den nhan Bac1 neu $t0 != 0 (thoa dieu kien Bac 1)

  slti $t0, $s0, 151                      # Dat $t0 = 1 neu $s0 < 151 (tuc dien nang <= 150), nguoc lai $t0 = 0
  bne  $t0, $zero, Bac2                   # Nhay den nhan Bac2 neu $t0 != 0 (thoa dieu kien Bac 2)

  slti $t0, $s0, 201                      # Dat $t0 = 1 neu $s0 < 201 (tuc dien nang <= 200), nguoc lai $t0 = 0
  bne  $t0, $zero, Bac3                   # Nhay den nhan Bac3 neu $t0 != 0 (thoa dieu kien Bac 3)

  j    Bac4                               # Nhay khong dieu kien den nhan Bac4 (truong hop dien nang >= 201)

Bac1:
  addi $s1, $zero, 1                      # Gan gia tri bac dien $s1 = 1
  j    Print                              # Nhay den nhan Print de bo qua cac nhanh bac con lai

Bac2:
  addi $s1, $zero, 2                      # Gan gia tri bac dien $s1 = 2
  j    Print                              # Nhay den nhan Print de bo qua cac nhanh bac con lai

Bac3:
  addi $s1, $zero, 3                      # Gan gia tri bac dien $s1 = 3
  j    Print                              # Nhay den nhan Print de bo qua nhanh Bac4

Bac4:
  addi $s1, $zero, 4                      # Gan gia tri bac dien $s1 = 4

Print:
  li   $v0, 4                             # Nap ma syscall 4 (in chuoi ky tu) vao $v0
  la   $a0, msg                           # Nap dia chi chuoi "Bac: " vao thanh ghi $a0
  syscall                                 # Goi he thong de in chuoi "Bac: "

  li   $v0, 1                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s1, $zero                    # Chuyen gia tri bac dien tu $s1 sang thanh ghi doi so $a0
  syscall                                 # Goi he thong de in gia tri so nguyen cua bac dien

  li   $v0, 4                             # Nap ma syscall 4 (in chuoi ky tu) vao $v0
  la   $a0, nl                            # Nap dia chi ky tu xuong dong "\n" vao thanh ghi $a0
  syscall                                 # Goi he thong de in ky tu xuong dong

  li   $v0, 10                            # Nap ma syscall 10 (ket thuc chuong trinh) vao $v0
  syscall                                 # Goi he thong de thoat chuong trinh an toan