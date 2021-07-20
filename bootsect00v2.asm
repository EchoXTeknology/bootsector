%if ( __NASM_MAJOR__ < 2 )
	%fatal "NASM Compiler Version 2.0 or later is required!"
%endif



%if ( __BITS__ != 16 )
	;@TODO: Warning Message(s) for Assembler Instruction set Compilation...
	CPU 8086

	%if ( __BITS__ != 16)
		; @TODO: Warning Message(s) for Assembler Instruction set Compilation...
		USE16

		%if ( __BITS__ != 16)
			;@TODO: Error Message(s) for Improper Assembler Instruction set Compilation...
		%endif
	
	%endif

%endif



ORG																				0x7C00



%define __MEMORY_MANAGEMENT__													0



%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE__									0
%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_ORG__								0
%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_END__								0
%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_SIZE__								0

%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE__									0
%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_ORG__								0
%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_END__								0
%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_SIZE__								0

%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE__							0
%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__						0
%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_END__						0
%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_SIZE__					0

%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE__									0
%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_ORG__								0
%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_EMD__								0
%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_SIZE__							0

%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE__									0
%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_ORG__								0
%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_END__								0
%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_SIZE__								0

%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE__								0
%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_ORG__							0
%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_END__							0
%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_SIZE__							0

%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE__									0
%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_ORG__								0
%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_END__								0
%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_SIZE__								0

%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE__									0
%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_ORG__								0
%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_END_								0
%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_SIZE__								0



%ifdef NTFS
	%fatal ""
	;@TODO: Define Default, Programmer Preferred, NTFS Variables...		

%elifdef FAT32
	%fatal ""
	;@TODO: Define Default, Programmer Preferred, FAT32 Variables...

%elifdef FAT16
	%define def_bpbBytesPerSector												512
	%define def_bpbSectorsPerCluster											4
	%define def_bpbReservedSectors												4
	%define def_bpbNumberOfFATs													2
	%define def_bpbRootDirEntries	 											512
	%define def_bpbTotalSectors													63488
	%define def_bpbMediaDescriptor												0xF8
	%define def_bpbSectorsPerFAT												64
	;@TODO: Define Default, Programmer Preferred, FAT16 Variables...

%elifdef FAT12
	%fatal ""
	;@TODO: Fatal Message(s) Declaring FAT12 is Depreciated!

%else
	;@TODO: Fatal Message(s) Declaring FS was not Declared!

%endif



;===============================================================================
;
;
;
;===============================================================================
jmp			_glEntry



;===============================================================================
; Determine is BIOS Parameter Block is Properly Aligned to Correct Memory
; Buffer Point [0x0003:<....>]
;===============================================================================
%if ( ( $ - $$ ) != 3 )
	%warning "BIOS PARAMETER BLOCK IS IMPROPERLY ALIGNED!"
	%warning "ATTEMPTING ALIGNMENT ROUTINE(S) TO BIOS PARAMETER BLOCK..."
	times		( 3 - ( $ - $$ ) )		db										0x90

	;===========================================================================
	; BIOS Parameter Block was unable to be Aligned Properly!
	;===========================================================================
	%if ( ( $ - $$ ) != 3 )
		%fatal "ALIGNMENT ROUTINE(S) FAILED FOR BIOS PARAMETER BLOCK!"

	%endif

%endif



;===============================================================================
; Global BIOS Parameter Block Entry Point
;===============================================================================
_glBPBHandle:
	bpbOEMLabel:								db								"mkfs.fat"

	bpbBytesPerSector:							dw								def_bpbBytesPerSector
	bpbSectorsPerCluster:						db								def_bpbSectorsPerCluster
	bpbReservedSectors:							dw								def_bpbReservedSectors
	bpbNumberOfFATs:							db								def_bpbNumberOfFATs
	bpbRootDirEntries:							dw								def_bpbRootDirEntries
	bpbTotalSectors:							dw								def_bpbTotalSectors
	bpbMediaDescriptor:							db								def_bpbMediaDescriptor
	bpbSectorsPerFAT:							dw								def_bpbSectorsPerFAT

	bpbSectorsPerTrack:							dw								0
	bpbNumberOfCylinders:						dw								0
	bpbHiddenSectors:							dd								0
	bpbLargeSectors:							dd								0

%ifdef NTFS
	ebpbVolumeDescriptor:						db								0
	ebpbVolumeFlags:							db								0x01
	ebpbExtendedSignature:						db								0x80
	ebpbReservedByte:							db								0
	ebpbTotalVolumeSectors:						dq								0
	ebpbMTFLocalCluster:						dq								0
	ebpbMTFMirrorCluster:						dq								0
	ebpbMTFRecordSize:							dd								0
	ebpbIndexBlockSize:							dd								0
	ebpbSerialNumber:							dq								0
	ebpbVolumeChecksum:							dd								0
	ebpbFileSystem:								db								"NTFS    "

%elifdef FAT32
	ebpbLogicalSectorsPerFAT:					dd								0
	ebpbMirroringFlags:							dw								0
	ebpbVersion:								dw								0
	ebpbRootDirCluster:							dd								0
	ebpbLocalFSInfoCluster:						dw								0
	ebpbLocalBackupSectors:						dw								0
	ebpbBootFileName:			times	12		db								0x20
	ebpbVolumeDescriptor:						db								0
	ebpbVolumeFlags:							db								0x01
	ebpbExtendedSignature:						db								0x28
	ebpbSerialNumber:							dd								0
	ebpbFileSystem:								db								"FAT32   "

%elifdef FAT16
	ebpbVolumeDescriptor:						db								0
	ebpbVolumeFlags:							db								0x01
	ebpbExtendedSignature:						db								0x29
	ebpbSerialNumber:							dd								0x00000000
	ebpbVolumeLabel:			times	11		db								0x20
	ebpbFileSystem:								db								"FAT16   "

%elifdef FAT12
	ebpbVolumeDescriptor:						db								0
	ebpbVolumeFlags:							db								0x01
	ebpbExtendedSignature:						db								0x29
	ebpbSerialNumber:							dd								0
	ebpbVolumeLabel:			times	11		db								0x20
	ebpbFileSystem:								db								"FAT12   "

%endif



;@TODO: Create System to Properly Align [MBRSECTOR]?



;===============================================================================
; Determine is Assembly (NASM) Compiler Instruction Flag(s)/Definition(s)
; were Declared during Preprocessor Compilation
;===============================================================================
%ifdef MEMMORY_MANAGMENT
	;===========================================================================
	; Determine if Assembly (NASM) Compiler Intstruction [RESERVE_ALL_SEGMENTS]
	; Flag was Declared during Preprocessor Compilation
	;===========================================================================
	%ifdef RESERVE_ALL_SEGMENTS
		;=======================================================================
		; Legacy BIOS Reserves [0x0000] through [0x03FF] for IVT (Interrupt
		; Vector Table)
		;=======================================================================
		%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE__							1
		%define	__MEMORY_MANAGEMENT_LMA_IVT_RESERVE_ORG__						0
		%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_END__						1023
		%define __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_SIZE__						( ( ( __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_ORG__ ) ) + 1 )
		;=======================================================================
		; Legacy BIOS Reserves [0x0400] through [0x04FF] for BDA (BIOS DATA
		; AREA)
		;=======================================================================
		%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE__							1
		%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_ORG__						( ( __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_END__ ) + 1 )
		%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_END__						1279
		%define __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_SIZE__						( ( ( __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_ORG__ ) ) + 1 )

		%ifdef RESERVE_EXTENSION_SEGMENT
			;===================================================================
			; Define/Declare Preprocessor Definition(s) for
			; [EXTENDED_BOOT_RESERVE]
			; NOTE: [STACK_RESERVE] & [EXTENDED_BOOT_RESERVE] OVERLAP!
			; NOTE: [STACK_RESERVE] & [BOOT_RESERVE] OVERLAP!
			;===================================================================
			%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE__				1
			%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__			( ( __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_END__ ) + 1 )
			%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_END__			( ( ( ( def_bpbBytesPerSector ) * ( def_bpbReservedSectors ) ) + ( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__ ) ) - 1 )
			%define __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_SIZE__		( ( ( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__ ) ) + 1 )
			;-------------------------------------------------------------------
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE__						1
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_ORG__					( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__ )
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_EMD__					31744
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_SIZE__				( ( ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_EMD__ ) - ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_ORG__ ) ) - ( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_SIZE__ ) )

		%else
			;===================================================================
			; Define/Declare Preprocessor Definition(s) for [STACK_RESERVE]
			; NOTE; [STACK_RESERVE] & [BOOT_RESERVE] OVERLAP!
			;===================================================================
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE__						1
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_ORG__					( ( __MEMORY_MANAGEMENT_LMA_BDA_RESERVE_END__ ) + 1 )
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_EMD__					31744
			%define __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_SIZE__				( ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_EMD__ ) - ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_ORG__ ) )

		%endif

		;=======================================================================
		; Define/Declare Preprocessor Defintion(s) for [BOOT_RESERVE]
		;=======================================================================
		%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE__							1
		%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_ORG__						31744
		%define __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_END__						32255
		%define	__MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_SIZE__						( ( ( __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_ORG__ ) ) + 1 )

		;=======================================================================
		; Define/Declare Preprocessor Defintion(s) for [KERNEL_RESERVE]
		;=======================================================================
		%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE__						1
		%define	__MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_ORG__					( ( __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_END__ ) + 1 )
		%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_END__					65023
		%define __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_SIZE__					( ( ( __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_ORG__ ) ) + 1 )

		;=======================================================================
		; Define/Declare Preprocessor Defintion(s) for [FAT_RESERVE]
		;=======================================================================
		%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE__							1
		%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_ORG__						( ( __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_END__ ) + 1 )
		%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_END__						130559
		%define __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_SIZE__						( ( ( __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_ORG__ ) ) + 1 )

		;=======================================================================
		; Define/Declare Preprocessor Definition(s) for [MAP_RESERVE]
		;=======================================================================
		%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE__							1
		%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_ORG__						( __MEMORY_MANAGEMENT_LMA_IVT_RESERVE_ORG__ )
		%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_END__						( __MEMORY_MANAGEMENT_LMA_FAT_RESERVE_END__ )
		%define __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_SIZE__						( ( ( __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_END__ ) - ( __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_ORG__ ) ) + 1 )
	
	%else
		%warning ""
		;@TODO: Create a System to Handle each segments individually?..

	%endif

%else
	%warning ""
	;@TODO: Create a System to Handle no Memory Management?..

%endif



;===============================================================================
;
;
;
;===============================================================================
_glEntry:
	CLI
	%if ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE__ >= 1 )
		MOV									AX,									( ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_EMD__ ) / 16 )
		MOV									SS,									AX
		MOV									SP,									( ( __MEMORY_MANAGEMENT_LMA_STACK_RESERVE_SIZE__ ) / 16 )
	%else
		MOV									AX,									0x07C0
		MOV									SS,									AX
		MOV									SP,									0x7700
	%endif
	STI

	XOR										AX,									AX
	MOV										AX,									( ( __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_ORG__ ) / 16 )
	MOV										DS,									AX
	XOR										AX,									AX

	%ifdef RESERVE_EXTENSION_SEGMENT
		MOV									AX,									( ( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__ ) / 16 )
		MOV									ES,									AX
		XOR									BX,									BX
		MOV									AX,									BX
	%else
		MOV									AX,									( ( __MEMORY_MANAGEMENT_LMA_KERNEL_RESERVE_ORG__ ) / 16 )
		MOV									ES,									AX
		XOR									BX,									BX
		MOV									AX,									BX
	%endif

	MOV					BYTE				[ebpbVolumeDescriptor],				DL



%ifdef MEMORY_MANAGEMENT
	%define __MEMORY_MANAGEMENT__												0
	;===========================================================================
	;
	;
	;
	;===========================================================================
	_glLowerMemoryManagement:
		STC
		XOR									EAX,								EAX
		INT									0x12
		JC									.LowerMemoryDetectionError

		MOV									DI,									MEMORY_MANAGEMENT_BUFFER_REGION
		MOV									CX,									0x0400
		MUL									CX
		MOV				WORD				[DS:DI+0x0000],						AX
		MOV				WORD				[DS:DI+0x0002],						DX
		MOV									EAX,			DWORD				[DS:DI+0x0000]

		%ifdef RESERVE_ALL_SEGMENTS
			SUB								EAX,								( __MEMORY_MANAGEMENT_LMA_MAP_RESERVE_SIZE__ )
		%else
			SUB								EAX,								0x0700
		%endif

		MOV				DWORD				[DS:DI+0x0000],						EAX

		;=======================================================================
		;
		;=======================================================================
		.LowerMemoryDetectionError:
			XOR								EAX,								EAX


%else
	%warning ""
	%define __MEMORY_MANAGEMENT__												0xBAD0AE12

%endif



;===============================================================================
;
;
;
;===============================================================================
_glVolumeManagement:
	XOR										EAX,								EAX
	XOR										EBX,								EBX
	XOR										ECX,								ECX
	XOR										EDX,								EDX



%ifdef RESERVE_EXTENSION_SEGMENT
	;===========================================================================
	;
	;===========================================================================
	vmGatherBIOSVolumeParameters:
		MOV									AH,									0x08
		MOV									DL,				BYTE				[ebpbVolumeDescriptor]
		MOV									BX,									ES
		MOV									ES,									CX
		MOV									DI,									CX
		STC
		INT									0x13
		JC									vmFatalBIOSVolumeError

		MOV									ES,									BX
		XOR									BX,									BX
	
	;===========================================================================
	;
	;===========================================================================
	vmDeciferBIOSVolumeParameters:
		AND									CX,									0x003F
		MOV				WORD				[bpbSectorsPerTrack],				CX
		MOVZX								DX,									DH
		INC									DX
		MOV				WORD				[bpbNumberOfCylinders],				DX
	
	;===========================================================================
	;
	;===========================================================================
	vmCalculateReservedExtendedBootRegion:
		MOV									AX,									0x0001

		MOV									BX,									AX

		XOR									DX,									DX
		DIV				WORD				[bpbSectorsPerTrack]
		INC									DL
		MOV									CL,									DL
		MOV									AX,									BX

		XOR									DX,									DX
		DIV				WORD				[bpbSectorsPerTrack]
		XOR									DX,									DX
		DIV				WORD				[bpbNumberOfCylinders]
		MOV									DH,									DL
		MOV									CH,									AL

		MOV									DL,				BYTE				[ebpbVolumeDescriptor]

		XOR									BX,									BX
		MOV									AX,				WORD				[bpbReservedSectors]
		AND									AX,									0x0204
		DEC									AL
		STC
		INT									0x13
		JC									vmFatalBIOSVolumeError

		JMP									0x0050:0x0000

		CLI
		HLT
		


	;===========================================================================
	;
	;===========================================================================
	vmFatalBIOSVolumeError:
		;@TODO: Create a Fatal Volume Error Handle?..
		MOV									AH,									0x0E
		MOV									AL,									'!'
		INT									0x10
		
		CLI
		HLT

%else
	;===========================================================================
	;
	;===========================================================================
	vmValidateVolumeBIOSExtensions:
		MOV									AH,									0x41
		MOV									DL,				BYTE				[ebpbVolumeDescriptor]
		MOV									BX,									0x55AA
		STC
		INT									0x13
		JNC									.vmValidateVolumeBIOSExtensionSwap

		;@TODO: Create System to handle BIOS Extension Support not Supported!
		CLI
		HLT

		;======================================================================
		;
		;======================================================================
		.vmValidateVolumeBIOSExtensionSwap:
			STC
			CMP								BX,									0xAA55
			JE								vmCalculateRootDirectoryRegionLBA

			;@TODO: Create a Swap Warning/Error Handle?...
			CLI
			HLT
	
	;===========================================================================
	;
	;===========================================================================
	vmCalculateRootDirectoryRegionLBA:


%endif



;===============================================================================
;
;
;
;===============================================================================
_glDepreciatedHandle:
	;@TODO: Create a System to tell user the hardware medium is no longer supported?..
	MOV										AH,									0x0E
	MOV										AL,									'?'
	INT										0x10
	CLI
	HLT



times		506 - ( $ - $$ )				db									0x00
MEMORY_MANAGEMENT_BUFFER_REGION:			dd									( __MEMORY_MANAGEMENT__ )
											dw									0xAA55



%ifdef RESERVE_EXTENSION_SEGMENT

;===============================================================================
;
;
;
;===============================================================================
JMP				_glExtendedEntry



;===============================================================================
;
;
;
;===============================================================================
_glExtendedBPBHandle:
	times			128					db										0x00



;===============================================================================
;
;
;
;===============================================================================
_glExtendedEntry:
	XOR										AX,									AX
	MOV										AX,									( ( __MEMORY_MANAGEMENT_LMA_EXTENDED_BOOT_RESERVE_ORG__ ) / 16 )
	MOV										DS,									AX
	XOR										AX,									AX
	MOV										DI,									_glExtendedBPBHandle

	MOV										AX,									( ( __MEMORY_MANAGEMENT_LMA_BOOT_RESERVE_ORG__ ) / 16 )
	MOV										ES,									AX
	MOV										SI,									_glExtendedBPBHandle
	XOR										AX,									AX

	XOR										CX,									CX
	MOV										AH,									0x0E
	MOV										AL,									'7'
	INT										0x10

	CLI
	HLT



times		1532 - ( $ - $$ )				db									0x00
EXTENDED_MEMORY_MANAGEMENT_BUFFER_REGION:	dd									( __MEMORY_MANAGEMENT__ )

%endif