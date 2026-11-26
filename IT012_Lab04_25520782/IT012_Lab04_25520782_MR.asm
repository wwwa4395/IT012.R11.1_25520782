# Huynh Vi Khang - 25520782 - Tinh dien nang tung thang, tong, thang cao nhat va dem so thang theo tung bac gia dien.
# Ke hoach dung thanh ghi: $s0 = reading, $s1 = usage, $s2 = i (0..11), $s3 = 12, $s4 = tong, $s5 = max kWh, $s6 = thang max, $s7 = dia chi cnt, $t0-$t7 = bien tam.
.data
m1:      .asciiz "Thang "                                               
m2:      .asciiz ": "                                                     
mt:      .asciiz "Tong: "                                              
mm:      .asciiz "Thang cao nhat: "                                       
mb:      .asciiz "Bac "                                                 
lp:      .asciiz " ("                                                    
rp:      .asciiz ")"                                                      
nl:      .asciiz "\n"                                                     
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955                   # 7 chi so cong to dau tien (reading[0]..reading[6])
         .word 2210, 2440, 2625, 2775, 2895, 2995                         # 6 chi so cong to tiep theo (reading[7]..reading[12])
usage:   .space 48                                                        # Cap phat 48 byte (12 tu nho) cho mang dien nang 12 thang
cnt:     .word 0, 0, 0, 0                                                 # Mang dem so thang cua 4 bac gia, khoi tao bang 0

.text
.globl main                                                               # Khai bao nhan main la diem bat dau toan cuc
main:
  la   $s0, reading                                                       # Nap dia chi nen cua mang reading vao $s0
  la   $s1, usage                                                         # Nap dia chi nen cua mang usage vao $s1
  addi $s2, $zero, 0                                                      # Khoi tao bien dem vong lap i = 0
  addi $s3, $zero, 12                                                     # Khoi tao so thang can duyet n = 12
  addi $s4, $zero, 0                                                      # Khoi tao tong dien nang ca nam $s4 = 0
  addi $s5, $zero, -1                                                     # Khoi tao dien nang cao nhat $s5 = -1
  addi $s6, $zero, 0                                                      # Khoi tao thang cao nhat $s6 = 0

Loop:
  beq  $s2, $s3, Done                                                     # Neu i == 12 thi thoat vong lap tinh dien nang

  sll  $t1, $s2, 2                                                        # Tinh do doi theo byte: $t1 = i * 4
  add  $t2, $s0, $t1                                                      # Tinh dia chi cua reading[i]: $t2 = reading + i * 4
  lw   $t3, 0($t2)                                                        # Nap gia tri reading[i] vao thanh ghi $t3
  lw   $t4, 4($t2)                                                        # Nap gia tri reading[i+1] (cach 4 byte) vao $t4
  sub  $t5, $t4, $t3                                                      # Tinh dien nang thang (i+1): $t5 = reading[i+1] - reading[i]

  add  $t6, $s1, $t1                                                      # Tinh dia chi cua usage[i]: $t6 = usage + i * 4
  sw   $t5, 0($t6)                                                        # Luu dien nang vua tinh ($t5) vao usage[i]

  add  $s4, $s4, $t5                                                      # Cong don dien nang thang hien tai vao tong $s4

  slt  $t7, $s5, $t5                                                      # Dat $t7 = 1 neu $s5 < $t5
  beq  $t7, $zero, SkipMax                                                # Neu $t7 == 0 thi bo qua cap nhat max
  add  $s5, $t5, $zero                                                    # Cap nhat dien nang cao nhat moi: $s5 = $t5
  addi $s6, $s2, 1                                                        # Cap nhat thang cao nhat moi: $s6 = i + 1

SkipMax:
  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, m1                                                            # Nap dia chi chuoi "Thang " vao $a0
  syscall                                                                 # In chuoi "Thang "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  addi $a0, $s2, 1                                                        # Dat so thu tu thang (i + 1) vao $a0
  syscall                                                                 # In so thu tu thang

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, m2                                                            # Nap dia chi chuoi ": " vao $a0
  syscall                                                                 # In chuoi ": "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $t5, $zero                                                    # Chuyen gia tri dien nang ($t5) sang $a0
  syscall                                                                 # In dien nang cua thang

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # In xuong dong

  addi $s2, $s2, 1                                                        # Tang bien dem vong lap: i = i + 1
  j    Loop                                                               # Nhay quay lai dau vong lap Loop

Done:
  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, mt                                                            # Nap dia chi chuoi "Tong: " vao $a0
  syscall                                                                 # In chuoi "Tong: "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s4, $zero                                                    # Chuyen tong dien nang ca nam ($s4) sang $a0
  syscall                                                                 # In tong dien nang

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # In xuong dong

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, mm                                                            # Nap dia chi chuoi "Thang cao nhat: " vao $a0
  syscall                                                                 # In chuoi "Thang cao nhat: "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s6, $zero                                                    # Chuyen so thu tu thang cao nhat ($s6) sang $a0
  syscall                                                                 # In thang cao nhat

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, lp                                                            # Nap dia chi chuoi " (" vao $a0
  syscall                                                                 # In dau mo ngoac " ("

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  add  $a0, $s5, $zero                                                    # Chuyen dien nang cao nhat ($s5) sang $a0
  syscall                                                                 # In gia tri dien nang cao nhat

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, rp                                                            # Nap dia chi chuoi ")" vao $a0
  syscall                                                                 # In dau dong ngoac ")"

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # In xuong dong

  # --- PHAN MO RONG: Duyet mang usage va dem so thang theo 4 bac gia ---
  la   $s7, cnt                                                           # Nap dia chi nen cua mang cnt vao $s7
  addi $s2, $zero, 0                                                      # Khoi tao lai bien dem i = 0 de duyet mang usage

CountLoop:
  beq  $s2, $s3, PrintCnt                                                 # Neu i == 12 thi ket thuc dem, chuyen sang in ket qua

  sll  $t1, $s2, 2                                                        # Tinh do doi theo byte: $t1 = i * 4
  add  $t2, $s1, $t1                                                      # Tinh dia chi cua usage[i]: $t2 = usage + i * 4
  lw   $t3, 0($t2)                                                        # Nap dien nang thang thu (i+1) tu usage[i] vao $t3

  slti $t0, $t3, 101                                                      # Kiem tra usage[i] <= 100 (tuc < 101)
  bne  $t0, $zero, Tier1                                                  # Neu dung, nhay den Tier1 (chi so 0 trong cnt)

  slti $t0, $t3, 151                                                      # Kiem tra usage[i] <= 150 (tuc < 151)
  bne  $t0, $zero, Tier2                                                  # Neu dung, nhay den Tier2 (chi so 1 trong cnt)

  slti $t0, $t3, 201                                                      # Kiem tra usage[i] <= 200 (tuc < 201)
  bne  $t0, $zero, Tier3                                                  # Neu dung, nhay den Tier3 (chi so 2 trong cnt)

  j    Tier4                                                              # Truong hop con lai (>= 201), nhay den Tier4 (chi so 3)

Tier1:
  addi $t4, $zero, 0                                                      # Chi so mang cnt cho Bac 1 la 0
  j    IncCnt                                                             # Nhay den doan tang bien dem
Tier2:
  addi $t4, $zero, 1                                                      # Chi so mang cnt cho Bac 2 la 1
  j    IncCnt                                                             # Nhay den doan tang bien dem
Tier3:
  addi $t4, $zero, 2                                                      # Chi so mang cnt cho Bac 3 la 2
  j    IncCnt                                                             # Nhay den doan tang bien dem
Tier4:
  addi $t4, $zero, 3                                                      # Chi so mang cnt cho Bac 4 la 3

IncCnt:
  sll  $t4, $t4, 2                                                        # Tinh do doi theo byte trong mang cnt: $t4 = chi_so * 4
  add  $t4, $s7, $t4                                                      # Tinh dia chi phan tu cnt[bac - 1]
  lw   $t5, 0($t4)                                                        # Doc gia tri dem hien tai cua bac vao $t5
  addi $t5, $t5, 1                                                        # Tang so thang cua bac them 1
  sw   $t5, 0($t4)                                                        # Ghi gia tri dem moi tro lai mang cnt

  addi $s2, $s2, 1                                                        # Tang bien dem vong lap: i = i + 1
  j    CountLoop                                                          # Quay lai dau vong lap CountLoop

PrintCnt:
  addi $s2, $zero, 0                                                      # Khoi tao bien dem k = 0 (duyet 4 bac)
  addi $t6, $zero, 4                                                      # Gioi han 4 bac gia

PrintLoop:
  beq  $s2, $t6, Exit                                                     # Neu k == 4 thi thoat vong lap in

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, mb                                                            # Nap dia chi chuoi "Bac " vao $a0
  syscall                                                                 # In chuoi "Bac "

  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  addi $a0, $s2, 1                                                        # Dat so thu tu bac (k + 1) vao $a0
  syscall                                                                 # In so thu tu bac (1..4)

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, m2                                                            # Nap dia chi chuoi ": " vao $a0
  syscall                                                                 # In chuoi ": "

  sll  $t1, $s2, 2                                                        # Tinh do doi theo byte: $t1 = k * 4
  add  $t2, $s7, $t1                                                      # Tinh dia chi phan tu cnt[k]
  li   $v0, 1                                                             # Nap ma syscall 1 (in so nguyen) vao $v0
  lw   $a0, 0($t2)                                                        # Nap so thang cua bac (k + 1) vao $a0
  syscall                                                                 # In so thang thuoc bac do

  li   $v0, 4                                                             # Nap ma syscall 4 (in chuoi) vao $v0
  la   $a0, nl                                                            # Nap dia chi ky tu xuong dong "\n" vao $a0
  syscall                                                                 # In xuong dong

  addi $s2, $s2, 1                                                        # Tang bien dem: k = k + 1
  j    PrintLoop                                                          # Quay lai dau vong lap PrintLoop

Exit:
  li   $v0, 10                                                       
  syscall                                                          