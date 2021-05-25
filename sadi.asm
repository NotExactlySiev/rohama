mkfile: subroutine
	ldy #0		; first find empty row
	lda #$00
        sta $1
        lda #$60
        sta $2
.mf_l   lda ($1),x
	beq .mf_o
        lda $1
        clc
        adc #12
        sta $1
        bne .mf_j
        inc $2
.mf_j   jmp .mf_l
.mf_o	
	lda #1
.mf_l2	sta ($1),y       ; write table information 
	iny
        cpy #$C
        beq .mf_o2
        lda $2,y
	jmp .mf_l2
.mf_o2  ldy #1		; load file address
	lda ($1),y
        sta $10
        iny
        lda ($1),y
        sta $11
        ldy #0
        lda #EOF
        sta ($10),y
        rts

mkdir: subroutine
	ldy #0		; find empty row
	lda #$00
        sta $1
        lda #$60
        sta $2
.md_l   lda ($1),x
	beq .md_o
        lda $1
        clc
        adc #12
        sta $1
        bne .md_j
        inc $2
.md_j   jmp .md_l
.md_o	lda #3		; fill table
	sta ($1),y
        lda #0
        iny
        sta ($1),y
	iny
        sta ($1),y
        
        ldy #3		; fill parent and name
.md_l2  lda $2,y
        sta ($1),y
        iny
        cpy #$C
        bne .md_l2      
	rts

listfiles: subroutine	; puts a list of all files into buffer
	ldx #0
	
	lda #$00
        sta FLPT
        lda #$60
        sta FLPTH
        
        lda #00
        sta BUFFPT
        lda #$03
        sta BUFFPTH
	
.lf_l	ldy #0		; file loop
	lda (FLPT),y
        beq .lf_d
        
        ldy #4
.lf_l2  lda (FLPT),y	; put to buffer
        beq .lf_o
        sta (BUFFPT,x)
        inc BUFFPT
        iny
        cpy #12
        beq .lf_o
        jmp .lf_l2
.lf_o   lda #LF
	sta (BUFFPT,x)
        inc BUFFPT
        
        lda FLPT
        clc
        adc #12
        sta FLPT        
        jmp .lf_l
               
.lf_d   lda #EOS
	sta (BUFFPT,x)
        inc BUFFPT
        lda #0
        sta BUFFPT
        lda #$03
        sta BUFFPTH
	rts