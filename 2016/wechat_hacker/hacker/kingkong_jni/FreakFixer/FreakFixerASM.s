.text
.align 2
.global FIXER_ENTRY_CODE32
.type FIXER_ENTRY_CODE32, %common
.global FIXER_PARAMETERS_START
.type FIXER_PARAMETERS_START, %common
.global FIXER_PARAMETERS_END
.type FIXER_PARAMETERS_END, %common

.global PATCH_DRIVER_FUNCTION_START
.type PATCH_DRIVER_FUNCTION_START, %common
.global PATCH_DRIVER_FUNCTION_reportEvilCatched
.type PATCH_DRIVER_FUNCTION_reportEvilCatched, %common
.global PATCH_DRIVER_FUNCTION_reportCxaFinalizeCalled
.type PATCH_DRIVER_FUNCTION_reportCxaFinalizeCalled, %common
.global PATCH_DRIVER_FUNCTION_reportFixerErrorOccurred
.type PATCH_DRIVER_FUNCTION_reportFixerErrorOccurred, %common
.global PATCH_DRIVER_FUNCTION_cxa_finalize
.type PATCH_DRIVER_FUNCTION_cxa_finalize, %common
.global PATCH_DRIVER_FUNCTION_original_LR
.type PATCH_DRIVER_FUNCTION_original_LR, %common
.global PATCH_DRIVER_FUNCTION_END
.type PATCH_DRIVER_FUNCTION_END, %common

.code 32
FIXER_ENTRY_CODE32:
		LDR		R0, SSL_REGISTER
		CMP 	R0, #4
		BEQ		FROM_REG4
		CMP		R0, #5
		BEQ		FROM_REG5
		CMP		R0, #6
		BEQ		FROM_REG6
		CMP		R0, #7
		BEQ		FROM_REG7
		CMP		R0, #8
		BEQ		FROM_REG8
		CMP		R0, #9
		BEQ		FROM_REG9
		CMP		R0, #10
		BEQ		FROM_REG10
		CMP		R0, #11
		BEQ		FROM_REG11
		B		FALSE_EXIT

FROM_REG4:
		MOV 	R0, R4
		B		fixerStart
FROM_REG5:
		MOV 	R0, R5
		B		fixerStart
FROM_REG6:
		MOV 	R0, R6
		B		fixerStart
FROM_REG7:
		MOV 	R0, R7
		B		fixerStart
FROM_REG8:
		MOV 	R0, R8
		B		fixerStart
FROM_REG9:
		MOV 	R0, R9
		B		fixerStart
FROM_REG10:
		MOV 	R0, R10
		B		fixerStart
FROM_REG11:
		MOV 	R0, R11
		B		fixerStart


fixerStart:
		PUSH	{R1}

		LDR		R1, SSL_OFFSET1		@ LDR		R0, [R0,#0x58]
		LDR		R0, [R0, R1]

		LDR		R1, SSL_OFFSET2		@ LDR		R0, [R0,#0x344]
		LDR		R0, [R0, R1]

		LDR		R1, SSL_OFFSET3		@ LDR		R0, [R0,#0x20]
		LDR		R0, [R0, R1]

		POP 	{R1}

		AND		R0, R0, #2
		CMP		R0, #0
		BEQ		FALSE_EXIT

TRUE_EXIT:
		LDR		R0, FUNC_ADDR_RSA_new
		BLX		R0
		LDR		LR, TRUE_EXIT_ADDR_16
		BX 		LR

FALSE_EXIT:
		#BL		reportEvilCatched
		MOV		R0, #0
		LDR		LR, FALSE_EXIT_ADDR_16
		BX		LR


/*	See definition in common.h
enum {
	PARAM_HOOK_POINT = 0,	// used by patcher
	PARAM_RSA_NEW_ADDRESS,
	PARAM_EXIT_TRUE,
	PARAM_EXIT_FALSE,
	PARAM_SSL_REGISTER,
	PARAM_SSL_OFFSET1,
	PARAM_SSL_OFFSET2,
	PARAM_SSL_OFFSET3,
	PARAM_MAX
};*/

FIXER_PARAMETERS_START:
PARAM_HOOK_POINT:
.word	0	@ unused here
FUNC_ADDR_RSA_new:
.word	FUNC_ADDR_RSA_new
TRUE_EXIT_ADDR_16:
.word	TRUE_EXIT_ADDR_16
FALSE_EXIT_ADDR_16:
.word	FALSE_EXIT_ADDR_16
SSL_REGISTER:
.word	0
SSL_OFFSET1:
.word	0
SSL_OFFSET2:
.word	0
SSL_OFFSET3:
.word	0
FIXER_PARAMETERS_END:
.word	FIXER_PARAMETERS_END

PATCH_DRIVER_FUNCTION_START:
PATCH_DRIVER_FUNCTION_reportEvilCatched:
.word	PATCH_DRIVER_FUNCTION_reportEvilCatched
PATCH_DRIVER_FUNCTION_reportCxaFinalizeCalled:
.word	PATCH_DRIVER_FUNCTION_reportCxaFinalizeCalled
PATCH_DRIVER_FUNCTION_reportFixerErrorOccurred:
.word	PATCH_DRIVER_FUNCTION_reportFixerErrorOccurred
PATCH_DRIVER_FUNCTION_cxa_finalize:
.word	PATCH_DRIVER_FUNCTION_cxa_finalize
PATCH_DRIVER_FUNCTION_original_LR:
.word	PATCH_DRIVER_FUNCTION_original_LR
PATCH_DRIVER_FUNCTION_END:
.word	PATCH_DRIVER_FUNCTION_END
