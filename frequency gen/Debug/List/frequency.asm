
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x4E,0x20
	.DB  0x6F,0x66,0x20,0x66,0x73,0x20,0x61,0x73
	.DB  0x0,0x66,0x6F,0x6C,0x6C,0x6F,0x77,0x73
	.DB  0x0,0x4E,0x2F,0x66,0x31,0x2D,0x66,0x32
	.DB  0x2B,0x66,0x33,0x0,0x20,0x69,0x73,0x20
	.DB  0x49,0x4E,0x56,0x41,0x4C,0x49,0x44,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;  //EFORE USING!!!!!
;  //in order to enter three frequencies, you sould do that in the follwing form
;  // N (number of frequencies) / division sign to seperate N and the first number - the subtraction sign to sperate the  ...
;  // finally + to seperate the third number and the firdt two ( N/feq_1-feq_2+feq_3
;  // to generate feq_1 please press =, to generate feq_2 please enter X and to generate feq_3 please enter ON/Off button
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <alcd.h>
;#include <delay.h>
;
;void main(void)
; 0000 000D {

	.CSEG
_main:
; .FSTART _main
; 0000 000E //intialization of some needed varabiles
; 0000 000F int key =0;
; 0000 0010 int Nfreq=0;              // number of fequencies needed
; 0000 0011 long int feq_1=0;        // frequency one
; 0000 0012 long int feq_2=0;       // frequency two
; 0000 0013 long int feq_3=0;      // frequency three
; 0000 0014   // please note that the accepted number of requencies should not exceed three
; 0000 0015 int num_indicator =0; // to differentiate between numbers and operators
; 0000 0016 int space =0;        // division sign to seperate the entered frequencies
; 0000 0017 int space_indicator =0;
; 0000 0018 int generate=0;     // to generate feq_1
; 0000 0019 char num[16];
; 0000 001A int com=0;          // to generate feq_2
; 0000 001B int col=0;
; 0000 001C DDRC=0b00001111;   // to generate feq_3
	SBIW R28,38
	LDI  R24,38
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	CALL __INITLOCB
;	key -> R16,R17
;	Nfreq -> R18,R19
;	feq_1 -> Y+34
;	feq_2 -> Y+30
;	feq_3 -> Y+26
;	num_indicator -> R20,R21
;	space -> Y+24
;	space_indicator -> Y+22
;	generate -> Y+20
;	num -> Y+4
;	com -> Y+2
;	col -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 001D PORTC=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 001E DDRD.0=0;
	CBI  0x11,0
; 0000 001F PORTD.0=1;
	SBI  0x12,0
; 0000 0020 DDRB.3=1;    // OCR0
	SBI  0x17,3
; 0000 0021 DDRD.5=1;    // OCR1A
	SBI  0x11,5
; 0000 0022 DDRD.7=1;    // OCR2
	SBI  0x11,7
; 0000 0023 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0024 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0025 lcd_putsf("Enter N of fs as");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0026 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x0
; 0000 0027 lcd_putsf("follows");
	__POINTW2FN _0x0,17
	CALL _lcd_putsf
; 0000 0028 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL SUBOPT_0x1
; 0000 0029 lcd_clear();
; 0000 002A lcd_putsf("N/f1-f2+f3");  // to guide the user so that the inputs are correctly entered
	__POINTW2FN _0x0,25
	CALL _lcd_putsf
; 0000 002B delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL SUBOPT_0x1
; 0000 002C lcd_clear();
; 0000 002D while (1)
_0xE:
; 0000 002E     {
; 0000 002F 
; 0000 0030 
; 0000 0031      PORTC.0=1;
	SBI  0x15,0
; 0000 0032      if (PINC.4==1) {while(PINC.4==1){}  key=7; num_indicator =1;}
	SBIS 0x13,4
	RJMP _0x13
_0x14:
	SBIC 0x13,4
	RJMP _0x14
	__GETWRN 16,17,7
	__GETWRN 20,21,1
; 0000 0033     else if (PINC.5==1) {while(PINC.5==1){}  key=8; num_indicator =1;}
	RJMP _0x17
_0x13:
	SBIS 0x13,5
	RJMP _0x18
_0x19:
	SBIC 0x13,5
	RJMP _0x19
	__GETWRN 16,17,8
	__GETWRN 20,21,1
; 0000 0034     else if (PINC.6==1){ while(PINC.6==1){}  key=9; num_indicator =1; }
	RJMP _0x1C
_0x18:
	SBIS 0x13,6
	RJMP _0x1D
_0x1E:
	SBIC 0x13,6
	RJMP _0x1E
	__GETWRN 16,17,9
	__GETWRN 20,21,1
; 0000 0035     else if (PINC.7==1){ while(PINC.7==1){}space=1; space_indicator =1;}      // /
	RJMP _0x21
_0x1D:
	SBIS 0x13,7
	RJMP _0x22
_0x23:
	SBIC 0x13,7
	RJMP _0x23
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2
; 0000 0036      delay_ms (10);
_0x22:
_0x21:
_0x1C:
_0x17:
	CALL SUBOPT_0x3
; 0000 0037      PORTC.0=0;
	CBI  0x15,0
; 0000 0038      PORTC.1=1;
	SBI  0x15,1
; 0000 0039     if (PINC.4==1) {while(PINC.4==1){}  key=4; num_indicator =1;}
	SBIS 0x13,4
	RJMP _0x2A
_0x2B:
	SBIC 0x13,4
	RJMP _0x2B
	__GETWRN 16,17,4
	__GETWRN 20,21,1
; 0000 003A     else if (PINC.5==1) {while(PINC.5==1){}  key=5; num_indicator =1;}
	RJMP _0x2E
_0x2A:
	SBIS 0x13,5
	RJMP _0x2F
_0x30:
	SBIC 0x13,5
	RJMP _0x30
	__GETWRN 16,17,5
	__GETWRN 20,21,1
; 0000 003B     else if (PINC.6==1){ while(PINC.6==1){}  key=6; num_indicator =1;}
	RJMP _0x33
_0x2F:
	SBIS 0x13,6
	RJMP _0x34
_0x35:
	SBIC 0x13,6
	RJMP _0x35
	__GETWRN 16,17,6
	__GETWRN 20,21,1
; 0000 003C   else if (PINC.7==1){ while(PINC.7==1){}  com=1;}
	RJMP _0x38
_0x34:
	SBIS 0x13,7
	RJMP _0x39
_0x3A:
	SBIC 0x13,7
	RJMP _0x3A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 003D      delay_ms (10);
_0x39:
_0x38:
_0x33:
_0x2E:
	CALL SUBOPT_0x3
; 0000 003E      PORTC.1=0;
	CBI  0x15,1
; 0000 003F      PORTC.2=1;
	SBI  0x15,2
; 0000 0040      if (PINC.4==1) {while(PINC.4==1){}  key=1; num_indicator =1;}
	SBIS 0x13,4
	RJMP _0x41
_0x42:
	SBIC 0x13,4
	RJMP _0x42
	__GETWRN 16,17,1
	__GETWRN 20,21,1
; 0000 0041     else if (PINC.5==1) {while(PINC.5==1){}  key=2; num_indicator =1; }
	RJMP _0x45
_0x41:
	SBIS 0x13,5
	RJMP _0x46
_0x47:
	SBIC 0x13,5
	RJMP _0x47
	__GETWRN 16,17,2
	__GETWRN 20,21,1
; 0000 0042     else if (PINC.6==1){ while(PINC.6==1){} key=3; num_indicator =1;}
	RJMP _0x4A
_0x46:
	SBIS 0x13,6
	RJMP _0x4B
_0x4C:
	SBIC 0x13,6
	RJMP _0x4C
	__GETWRN 16,17,3
	__GETWRN 20,21,1
; 0000 0043        else if (PINC.7==1){ while(PINC.7==1){} space=2;space_indicator =1;}   // -
	RJMP _0x4F
_0x4B:
	SBIS 0x13,7
	RJMP _0x50
_0x51:
	SBIC 0x13,7
	RJMP _0x51
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2
; 0000 0044      delay_ms (10);
_0x50:
_0x4F:
_0x4A:
_0x45:
	CALL SUBOPT_0x3
; 0000 0045      PORTC.2=0;
	CBI  0x15,2
; 0000 0046      PORTC.3=1;
	SBI  0x15,3
; 0000 0047      if (PINC.4==1) {while(PINC.4==1){}  col=1;}
	SBIS 0x13,4
	RJMP _0x58
_0x59:
	SBIC 0x13,4
	RJMP _0x59
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0048     else if (PINC.5==1) {while(PINC.5==1){}  key=0; num_indicator =1;}
	RJMP _0x5C
_0x58:
	SBIS 0x13,5
	RJMP _0x5D
_0x5E:
	SBIC 0x13,5
	RJMP _0x5E
	__GETWRN 16,17,0
	__GETWRN 20,21,1
; 0000 0049     else if (PINC.6==1) {while(PINC.6==1){}  generate=1;}    // when = is pressed the generation process begins
	RJMP _0x61
_0x5D:
	SBIS 0x13,6
	RJMP _0x62
_0x63:
	SBIC 0x13,6
	RJMP _0x63
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 004A    else if (PINC.7==1){ while(PINC.7==1){} space=3;space_indicator=1;}        // +
	RJMP _0x66
_0x62:
	SBIS 0x13,7
	RJMP _0x67
_0x68:
	SBIC 0x13,7
	RJMP _0x68
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x2
; 0000 004B     PORTC.3=0;
_0x67:
_0x66:
_0x61:
_0x5C:
	CBI  0x15,3
; 0000 004C     delay_ms (10);
	CALL SUBOPT_0x3
; 0000 004D      if (PIND.0==0) {while(PIND.0==0){} lcd_clear();  key=0; Nfreq=0; feq_1=0; feq_2=0; feq_3=0;space=0; space_indicator ...
	SBIC 0x10,0
	RJMP _0x6D
_0x6E:
	SBIS 0x10,0
	RJMP _0x6E
	CALL _lcd_clear
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	__CLRD1S 26
	STD  Y+24,R30
	STD  Y+24+1,R30
	STD  Y+22,R30
	STD  Y+22+1,R30
	__GETWRN 20,21,0
; 0000 004E      com=0; col=0; generate=0;OCR0=0;TCCR0=0;TCCR2=0; OCR2=0; TCCR1A=0;TCCR1B=0;OCR1A=0; }
	STD  Y+2,R30
	STD  Y+2+1,R30
	STD  Y+0,R30
	STD  Y+0+1,R30
	STD  Y+20,R30
	STD  Y+20+1,R30
	OUT  0x3C,R30
	OUT  0x33,R30
	OUT  0x25,R30
	OUT  0x23,R30
	OUT  0x2F,R30
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 004F       delay_ms (10);
_0x6D:
	CALL SUBOPT_0x3
; 0000 0050 
; 0000 0051    if ( space==0 && num_indicator ==1){ Nfreq = Nfreq*10+key;  itoa(key,num);lcd_puts(num);num_indicator=0; }
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,0
	BRNE _0x72
	CALL SUBOPT_0x6
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
	MOVW R30,R18
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R16
	ADC  R31,R17
	MOVW R18,R30
	CALL SUBOPT_0x7
; 0000 0052    if  (Nfreq >3){
_0x71:
	__CPWRN 18,19,4
	BRLT _0x74
; 0000 0053     lcd_putsf(" is INVALID");
	__POINTW2FN _0x0,36
	CALL _lcd_putsf
; 0000 0054      delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL SUBOPT_0x1
; 0000 0055    lcd_clear();
; 0000 0056     Nfreq=0;
	__GETWRN 18,19,0
; 0000 0057     }
; 0000 0058 
; 0000 0059 
; 0000 005A    if (space==1 && space_indicator==1){lcd_putchar('/'); space_indicator=0; }
_0x74:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,1
	BRNE _0x76
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	SBIW R26,1
	BREQ _0x77
_0x76:
	RJMP _0x75
_0x77:
	CALL SUBOPT_0x8
; 0000 005B       if (space==2 && space_indicator==1){lcd_putchar('/'); space_indicator=0; }
_0x75:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,2
	BRNE _0x79
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	SBIW R26,1
	BREQ _0x7A
_0x79:
	RJMP _0x78
_0x7A:
	CALL SUBOPT_0x8
; 0000 005C        if (space==3 && space_indicator==1){lcd_putchar('/'); space_indicator=0; }
_0x78:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,3
	BRNE _0x7C
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	SBIW R26,1
	BREQ _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
	CALL SUBOPT_0x8
; 0000 005D if ( (Nfreq==1||Nfreq==2||Nfreq==3)&& space==1 &&num_indicator==1){
_0x7B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x7F
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x7F
	CALL SUBOPT_0x9
	BRNE _0x81
_0x7F:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,1
	BRNE _0x81
	CALL SUBOPT_0x6
	BREQ _0x82
_0x81:
	RJMP _0x7E
_0x82:
; 0000 005E    feq_1=feq_1*10+key ;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	__PUTD1S 34
; 0000 005F    itoa (key,num);
	CALL SUBOPT_0x7
; 0000 0060    lcd_puts(num);
; 0000 0061    num_indicator=0;  }
; 0000 0062    if ( generate==1) {
_0x7E:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0x83
; 0000 0063    if(feq_1<=4000000&&feq_1>15625){
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	BRGE _0x85
	CALL SUBOPT_0xE
	BRGE _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 0064    TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(25)
	CALL SUBOPT_0xF
; 0000 0065 TCNT0=0x00;
; 0000 0066 OCR0 =(8000000/(2*1*feq_1))-1;
	CALL SUBOPT_0x10
	OUT  0x3C,R30
; 0000 0067   itoa (OCR0,num);
	IN   R30,0x3C
	LDI  R31,0
	RJMP _0xCC
; 0000 0068     feq_1=0;
; 0000 0069     lcd_gotoxy(0,1);
; 0000 006A    lcd_puts(num);}
; 0000 006B    else if(feq_1<=500000&&feq_1>=1953){
_0x84:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x11
	BRGE _0x89
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	BRGE _0x8A
_0x89:
	RJMP _0x88
_0x8A:
; 0000 006C    TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(26)
	CALL SUBOPT_0xF
; 0000 006D TCNT0=0x00;
; 0000 006E OCR0 =(8000000/(2*8*feq_1))-1;
	CALL SUBOPT_0x13
	OUT  0x3C,R30
; 0000 006F   itoa (OCR0,num);
	IN   R30,0x3C
	LDI  R31,0
	RJMP _0xCC
; 0000 0070     feq_1=0;
; 0000 0071     lcd_gotoxy(0,1);
; 0000 0072    lcd_puts(num);}
; 0000 0073     else if(feq_1<=62500&&feq_1>=244){
_0x88:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x14
	BRGE _0x8D
	CALL SUBOPT_0xC
	CALL SUBOPT_0x15
	BRGE _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
; 0000 0074    TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(27)
	CALL SUBOPT_0xF
; 0000 0075 TCNT0=0x00;
; 0000 0076 OCR0 =(8000000/(2*64*feq_1))-1;
	CALL SUBOPT_0x16
	OUT  0x3C,R30
; 0000 0077   itoa (OCR0,num);
	IN   R30,0x3C
	LDI  R31,0
	RJMP _0xCC
; 0000 0078     feq_1=0;
; 0000 0079     lcd_gotoxy(0,1);
; 0000 007A    lcd_puts(num);}
; 0000 007B 
; 0000 007C    else if(feq_1<=15625&&feq_1>=61){
_0x8C:
	CALL SUBOPT_0xE
	BRGE _0x91
	CALL SUBOPT_0xC
	CALL SUBOPT_0x17
	BRGE _0x92
_0x91:
	RJMP _0x90
_0x92:
; 0000 007D TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(28)
	CALL SUBOPT_0xF
; 0000 007E TCNT0=0x00;
; 0000 007F OCR0 =(8000000/(2*256*feq_1))-1;
	CALL SUBOPT_0x18
	OUT  0x3C,R30
; 0000 0080   itoa (OCR0,num);
	IN   R30,0x3C
	LDI  R31,0
	RJMP _0xCC
; 0000 0081     feq_1=0;
; 0000 0082     lcd_gotoxy(0,1);
; 0000 0083    lcd_puts(num);}
; 0000 0084     else if(feq_1<=3906&&feq_1>=15){
_0x90:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x19
	BRGE _0x95
	CALL SUBOPT_0x1A
	BRGE _0x96
_0x95:
	RJMP _0x94
_0x96:
; 0000 0085 TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(29)
	CALL SUBOPT_0xF
; 0000 0086 TCNT0=0x00;
; 0000 0087 OCR0 =(8000000/(2*1024*feq_1))-1;
	CALL SUBOPT_0x1B
	SUBI R30,LOW(1)
	OUT  0x3C,R30
; 0000 0088   itoa (OCR0,num);
	IN   R30,0x3C
	LDI  R31,0
	RJMP _0xCC
; 0000 0089     feq_1=0;
; 0000 008A     lcd_gotoxy(0,1);
; 0000 008B    lcd_puts(num);}
; 0000 008C         else if(feq_1<15&&feq_1>=1){
_0x94:
	CALL SUBOPT_0x1A
	BRGE _0x99
	CALL SUBOPT_0xC
	CALL SUBOPT_0x1C
	BRGE _0x9A
_0x99:
	RJMP _0x98
_0x9A:
; 0000 008D TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(64)
	OUT  0x2F,R30
; 0000 008E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 008F     OCR1A=(8000000/(2*1024*feq_1)-1);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
; 0000 0090   itoa (OCR1A,num);
; 0000 0091   itoa (OCR1A,num);
_0xCC:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
; 0000 0092     feq_1=0;
	CALL SUBOPT_0x4
; 0000 0093     lcd_gotoxy(0,1);
	CALL SUBOPT_0x0
; 0000 0094    lcd_puts(num);}
	CALL SUBOPT_0x1F
; 0000 0095 
; 0000 0096     }
_0x98:
; 0000 0097 
; 0000 0098   generate=0;
_0x83:
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+20+1,R30
; 0000 0099 
; 0000 009A   if ((Nfreq==2||Nfreq==3 )&& space==2 &&num_indicator==1){
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x9C
	CALL SUBOPT_0x9
	BRNE _0x9E
_0x9C:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,2
	BRNE _0x9E
	CALL SUBOPT_0x6
	BREQ _0x9F
_0x9E:
	RJMP _0x9B
_0x9F:
; 0000 009B    feq_2=feq_2*10+key ;
	CALL SUBOPT_0x20
	CALL SUBOPT_0xB
	__PUTD1S 30
; 0000 009C    itoa (key,num);
	CALL SUBOPT_0x7
; 0000 009D    lcd_puts(num);
; 0000 009E    num_indicator=0;  }
; 0000 009F   if (com==1){
_0x9B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xA0
; 0000 00A0    if(feq_2<=4000000&&feq_2>=15625){
	CALL SUBOPT_0x21
	CALL SUBOPT_0xD
	BRGE _0xA2
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	BRGE _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
; 0000 00A1 TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(25)
	CALL SUBOPT_0x23
; 0000 00A2 TCNT2=0x00;
; 0000 00A3 OCR2 =(8000000/(2*1*feq_2))-1;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x24
; 0000 00A4   itoa (OCR2,num);
; 0000 00A5  lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 00A6 
; 0000 00A7    lcd_puts(num);
	CALL SUBOPT_0x1F
; 0000 00A8 
; 0000 00A9   feq_2=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00AA 
; 0000 00AB    }
; 0000 00AC    if(feq_2<=500000&&feq_2>=1953){
_0xA1:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x11
	BRGE _0xA5
	CALL SUBOPT_0x21
	CALL SUBOPT_0x12
	BRGE _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
; 0000 00AD 
; 0000 00AE TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (0<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(26)
	CALL SUBOPT_0x23
; 0000 00AF TCNT2=0x00;
; 0000 00B0 OCR2 =(8000000/(2*8*feq_2))-1;
	CALL SUBOPT_0x13
	CALL SUBOPT_0x24
; 0000 00B1   itoa (OCR2,num);
; 0000 00B2  lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 00B3 
; 0000 00B4    lcd_puts(num);
	CALL SUBOPT_0x1F
; 0000 00B5 
; 0000 00B6   feq_2=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00B7 
; 0000 00B8    }
; 0000 00B9       if(feq_2<=62500&&feq_2>=244){
_0xA4:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x14
	BRGE _0xA8
	CALL SUBOPT_0x21
	CALL SUBOPT_0x15
	BRGE _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
; 0000 00BA TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(28)
	CALL SUBOPT_0x23
; 0000 00BB TCNT2=0x00;
; 0000 00BC OCR2 =(8000000/(2*64*feq_2))-1;
	CALL SUBOPT_0x16
	CALL SUBOPT_0x24
; 0000 00BD   itoa (OCR2,num);
; 0000 00BE   lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 00BF 
; 0000 00C0    lcd_puts(num);
	CALL SUBOPT_0x1F
; 0000 00C1 
; 0000 00C2   feq_2=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00C3 
; 0000 00C4    }
; 0000 00C5        if(feq_2<=15625&&feq_2>=61){
_0xA7:
	CALL SUBOPT_0x21
	__CPD2N 0x3D0A
	BRGE _0xAB
	CALL SUBOPT_0x21
	CALL SUBOPT_0x17
	BRGE _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
; 0000 00C6 
; 0000 00C7 
; 0000 00C8 TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(30)
	CALL SUBOPT_0x23
; 0000 00C9 TCNT2=0x00;
; 0000 00CA OCR2 =(8000000/(2*256*feq_2))-1;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x24
; 0000 00CB   itoa (OCR2,num);
; 0000 00CC  lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 00CD 
; 0000 00CE    lcd_puts(num);
	CALL SUBOPT_0x1F
; 0000 00CF 
; 0000 00D0   feq_2=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00D1 
; 0000 00D2    }
; 0000 00D3        if(feq_2<=3906&&feq_2>=15){
_0xAA:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x19
	BRGE _0xAE
	CALL SUBOPT_0x25
	BRGE _0xAF
_0xAE:
	RJMP _0xAD
_0xAF:
; 0000 00D4 
; 0000 00D5 TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(31)
	CALL SUBOPT_0x23
; 0000 00D6 TCNT2=0x00;
; 0000 00D7 OCR2 =(8000000/(2*1024*feq_2))-1;
	CALL SUBOPT_0x1B
	SUBI R30,LOW(1)
	CALL SUBOPT_0x24
; 0000 00D8   itoa (OCR2,num);
; 0000 00D9  lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 00DA 
; 0000 00DB    lcd_puts(num);
	CALL SUBOPT_0x1F
; 0000 00DC 
; 0000 00DD   feq_2=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00DE 
; 0000 00DF    }
; 0000 00E0            else if(feq_2<15&&feq_2>=1){
	RJMP _0xB0
_0xAD:
	CALL SUBOPT_0x25
	BRGE _0xB2
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1C
	BRGE _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
; 0000 00E1 TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 00E2 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 00E3     OCR1A=(8000000/(2*1024*feq_2)-1);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
; 0000 00E4 
; 0000 00E5   itoa (OCR1A,num);
; 0000 00E6   itoa (OCR1A,num);
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
; 0000 00E7     feq_2=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 00E8     lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 00E9    lcd_puts(num);}
	CALL SUBOPT_0x1F
; 0000 00EA 
; 0000 00EB 
; 0000 00EC 
; 0000 00ED       com =0;
_0xB1:
_0xB0:
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00EE }
; 0000 00EF 
; 0000 00F0   if ((Nfreq==3 )&& space==3 &&num_indicator==1){
_0xA0:
	CALL SUBOPT_0x9
	BRNE _0xB5
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,3
	BRNE _0xB5
	CALL SUBOPT_0x6
	BREQ _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
; 0000 00F1    feq_3=feq_3*10+key ;
	CALL SUBOPT_0x26
	CALL SUBOPT_0xB
	__PUTD1S 26
; 0000 00F2    itoa (key,num);
	CALL SUBOPT_0x7
; 0000 00F3    lcd_puts(num);
; 0000 00F4    num_indicator=0;  }
; 0000 00F5      if (col==1){
_0xB4:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xB7
; 0000 00F6    if(feq_3<4000000 && feq_3>=61){
	CALL SUBOPT_0x27
	__CPD2N 0x3D0900
	BRGE _0xB9
	CALL SUBOPT_0x27
	CALL SUBOPT_0x17
	BRGE _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
; 0000 00F7 TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 00F8 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 00F9     OCR1A=(8000000/(2*1*feq_3)-1);
	CALL SUBOPT_0x26
	CALL __LSLD1
	RJMP _0xCD
; 0000 00FA   itoa (OCR1A,num);
; 0000 00FB  lcd_gotoxy(10,1);
; 0000 00FC 
; 0000 00FD    lcd_puts(num);
; 0000 00FE 
; 0000 00FF   feq_3=0;
; 0000 0100 
; 0000 0101    }
; 0000 0102    else if(feq_3<500000&&feq_3>=7){
_0xB8:
	CALL SUBOPT_0x27
	__CPD2N 0x7A120
	BRGE _0xBD
	CALL SUBOPT_0x27
	__CPD2N 0x7
	BRGE _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
; 0000 0103 TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(64)
	OUT  0x2F,R30
; 0000 0104 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 0105     OCR1A=(8000000/(2*8*feq_3)-1);
	CALL SUBOPT_0x26
	__GETD2N 0x10
	RJMP _0xCE
; 0000 0106   itoa (OCR1A,num);
; 0000 0107  lcd_gotoxy(10,1);
; 0000 0108 
; 0000 0109    lcd_puts(num);
; 0000 010A 
; 0000 010B   feq_3=0;
; 0000 010C 
; 0000 010D    }
; 0000 010E       else if(feq_3<62500&&feq_3>=1){
_0xBC:
	CALL SUBOPT_0x27
	__CPD2N 0xF424
	BRGE _0xC1
	CALL SUBOPT_0x28
	BRGE _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
; 0000 010F TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(64)
	OUT  0x2F,R30
; 0000 0110 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0111     OCR1A=(8000000/(2*64*feq_3)-1);
	CALL SUBOPT_0x26
	__GETD2N 0x80
	RJMP _0xCE
; 0000 0112   itoa (OCR1A,num);
; 0000 0113  lcd_gotoxy(10,1);
; 0000 0114 
; 0000 0115    lcd_puts(num);
; 0000 0116 
; 0000 0117   feq_3=0;
; 0000 0118 
; 0000 0119    }
; 0000 011A         else if(feq_3<15625&&feq_3>=1){
_0xC0:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x22
	BRGE _0xC5
	CALL SUBOPT_0x28
	BRGE _0xC6
_0xC5:
	RJMP _0xC4
_0xC6:
; 0000 011B TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(64)
	OUT  0x2F,R30
; 0000 011C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 011D     OCR1A=(8000000/(2*256*feq_3)-1);
	CALL SUBOPT_0x26
	__GETD2N 0x200
	RJMP _0xCE
; 0000 011E   itoa (OCR1A,num);
; 0000 011F  lcd_gotoxy(10,1);
; 0000 0120 
; 0000 0121    lcd_puts(num);
; 0000 0122 
; 0000 0123   feq_3=0;
; 0000 0124 
; 0000 0125    }
; 0000 0126          else if(feq_3<=3906&&feq_3>=1){
_0xC4:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x19
	BRGE _0xC9
	CALL SUBOPT_0x28
	BRGE _0xCA
_0xC9:
	RJMP _0xC8
_0xCA:
; 0000 0127 TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(64)
	OUT  0x2F,R30
; 0000 0128 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 0129     OCR1A=(8000000/(2*1024*feq_3)-1);
	CALL SUBOPT_0x26
	__GETD2N 0x800
_0xCE:
	CALL __MULD12
_0xCD:
	__GETD2N 0x7A1200
	CALL __DIVD21
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 012A   itoa (OCR1A,num);
	IN   R30,0x2A
	IN   R31,0x2A+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
; 0000 012B  lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x0
; 0000 012C 
; 0000 012D    lcd_puts(num);
	CALL SUBOPT_0x1F
; 0000 012E 
; 0000 012F   feq_3=0;
	LDI  R30,LOW(0)
	__CLRD1S 26
; 0000 0130 
; 0000 0131    }
; 0000 0132   col=0;
_0xC8:
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
; 0000 0133         }
; 0000 0134 
; 0000 0135  }
_0xB7:
	RJMP _0xE
; 0000 0136 }
_0xCB:
	RJMP _0xCB
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x29
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x29
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	CP   R5,R7
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x20A0001
_0x2020007:
_0x2020004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	RJMP _0x20A0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
_0x20A0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	STD  Y+24,R30
	STD  Y+24+1,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	__CLRD1S 34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	__CLRD1S 30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x7:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,6
	CALL _itoa
	MOVW R26,R28
	ADIW R26,4
	CALL _lcd_puts
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(47)
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	STD  Y+22,R30
	STD  Y+22+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	__GETD1S 34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xB:
	__GETD2N 0xA
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	CALL __CWD1
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xC:
	__GETD2S 34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	__CPD2N 0x3D0901
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xC
	__CPD2N 0x3D0A
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	CALL __LSLD1
	__GETD2N 0x7A1200
	CALL __DIVD21
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	__CPD2N 0x7A121
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	__CPD2N 0x7A1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	__GETD2N 0x10
	CALL __MULD12
	__GETD2N 0x7A1200
	CALL __DIVD21
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	__CPD2N 0xF425
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__CPD2N 0xF4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x16:
	__GETD2N 0x80
	CALL __MULD12
	__GETD2N 0x7A1200
	CALL __DIVD21
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	__GETD2N 0x200
	CALL __MULD12
	__GETD2N 0x7A1200
	CALL __DIVD21
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	__CPD2N 0xF43
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0xC
	__CPD2N 0xF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1B:
	__GETD2N 0x800
	CALL __MULD12
	__GETD2N 0x7A1200
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1C:
	__CPD2N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1D:
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	CALL _itoa
	IN   R30,0x2A
	IN   R31,0x2A+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,6
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1F:
	MOVW R26,R28
	ADIW R26,4
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	__GETD1S 30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x21:
	__GETD2S 30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	__CPD2N 0x3D09
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	OUT  0x25,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x24:
	OUT  0x23,R30
	IN   R30,0x23
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x21
	__CPD2N 0xF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x26:
	__GETD1S 26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x27:
	__GETD2S 26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x27
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
