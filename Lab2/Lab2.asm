.model small
.stack 100h
.data
len equ 200
string db 202 dup('$')
number db 'number:$'
ent db 10, 13, '$'
enterString db "Enter string:", 13,10,'$'
resaultString db "Resault String:", 13,10,'$' 

.code

start:      
   mov ax, @data
   mov ds, ax
   mov es, ax
   xor ax, ax

   lea dx, enterString
   call output
   
   mov al, len
   mov [string], al
   mov [string + 1], 0
   lea dx, string  
   call input 
      
   call do 
   
   lea dx, ent
   call output

   lea dx, resaultString
   call output

   lea dx, string
   add dx, 2
   call output
   
   mov ah,4Ch
   int 21h

   output Proc  
    
   mov ah,9h
   int 21h
   ret         
   
   output Endp
    
   input Proc
     
   mov ah, 0Ah
   int 21h
   ret  
   
   input Endp
   
   do Proc
     
   lea si, string
   add si, 2
   add si, bx
   
   findNext:
   push si
   
   call find
   
   pop si
   
   cmp ax, 0
   je exit
   
   mov si, di
   push di
   
   call shift
   
   pop di
   
   call addNumberWord
   
   lea si, string
   jmp findNext
   
   exit:
   ret
   
   do Endp
   
   find Proc 
    
   mov di, si
   mov bl, 1                     
   mov ah, byte ptr[si]
   cmp ah, ' '
   je loopSpace
   
   cmp ah, 13
   je fullret
   
   xstart:
   
   mov ah, byte ptr[si]
   cmp ah, 13
   je endprog
   
   cmp ah, ' '
   je space
   
   jmp numbercheck
   
   space:
   
   cmp bl, 1
   je outproc
   
   mov bl, 1
   jmp loopSpace
   
   outproc:

   mov ax, di 
   ret

   endprog:
   
   cmp bl, 1
   je outproc
   
   mov ax, 0
   ret
   
   numberCheck:
   
   mov ah, byte ptr[si]
    
   cmp ah, '0'   
   jl notNumber
   
   cmp ah, '9'
   jg notNumber
     
   inc si
   jmp xstart
   
   notNumber:
             
   mov bl, 0 
   inc si
   jmp xstart
   
   loopSpace:
   
   mov ah, byte ptr[si] 
   cmp ah, ' '
   jne numberCheck
   
   inc si
   mov ah, byte ptr[si]
   cmp ah, 13
   je fullret
   
   mov di, si
   jmp loopSpace
    
   fullret:
   
   mov ax, 0
   ret

   find Endp

   shift Proc
        
   cld
   mov di, si
   xor cx, cx
   
   shiftStart:
   
   mov bl, byte ptr [si]
   cmp bl, '$'
   je add7
   
   inc cx
   inc si
   jmp shiftStart
   
   add7:
   
   inc cx
   mov di, si
   add di, 7
   
   shiftProcess: 
   
   mov bl, byte ptr [si]
   mov byte ptr [di], bl
   dec si
   dec di
   loop shiftProcess
   ret
   
   shift Endp
   
   addNumberWord Proc
     
   cld
   lea si, number
   mov cx, 7
   rep movsb
   ret        
   
   addnumberWord Endp

end     start