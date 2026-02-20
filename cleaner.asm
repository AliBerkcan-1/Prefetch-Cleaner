extern ExitProcess
extern GetEnvironmentVariableA
extern FindFirstFileA
extern FindNextFileA
extern FindClose
extern DeleteFileA
extern MessageBoxA

section .data
    title_msg     db "System Cleaner v1.0", 0
    done_msg      db "Temizlik islemi basariyla tamamlandi!", 0
    prefetch_dir  db "C:\Windows\Prefetch\", 0
    prefetch_mask db "C:\Windows\Prefetch\*", 0
    temp_var      db "TEMP", 0

section .bss
    find_data      resb 600
    search_handle  resq 1
    temp_path_raw  resb 260
    temp_path_mask resb 260
    full_path_buf  resb 512

section .text
    global main

main:
    sub rsp, 40

   
    mov rcx, prefetch_mask
    mov rdx, prefetch_dir
    call clean_directory

   
    mov rcx, temp_var
    mov rdx, temp_path_raw
    mov r8, 260
    call GetEnvironmentVariableA

    
    mov rsi, temp_path_raw
    mov rdi, temp_path_mask
    call copy_str
    
   
    cmp byte [rdi-1], '\'
    je .add_star
    mov byte [rdi], '\'
    inc rdi
.add_star:
    mov byte [rdi], '*'    
    mov byte [rdi+1], 0    

    mov rcx, temp_path_mask
    mov rdx, temp_path_raw
    call clean_directory

    
    xor rcx, rcx
    mov rdx, done_msg
    mov r8, title_msg
    mov r9, 0
    call MessageBoxA

    xor rcx, rcx
    call ExitProcess

; -------------------------------------------------------------------
clean_directory:
    sub rsp, 56
    mov [rsp+48], rdx          
    
    mov rdx, find_data
    call FindFirstFileA
    mov [search_handle], rax
    
    cmp rax, -1
    je .done

.loop:
    lea r8, [find_data + 44]  
    
    
    cmp byte [r8], '.'
    je .next

   
    mov rdi, full_path_buf
    mov rsi, [rsp+48]         
    call copy_str
    
    ; Araya \ koy (Yoksa)
    cmp byte [rdi-1], '\'
    je .skip_slash
    mov byte [rdi], '\'
    inc rdi
.skip_slash:
    mov rsi, r8                
    call copy_str              ;

   
    mov rcx, full_path_buf
    call DeleteFileA

.next:
    mov rcx, [search_handle]
    mov rdx, find_data
    call FindNextFileA
    test rax, rax
    jnz .loop

.done:
    mov rcx, [search_handle]
    call FindClose
    add rsp, 56
    ret


copy_str:
.l: mov al, [rsi]
    mov [rdi], al
    test al, al                
    jz .end                    
    inc rsi
    inc rdi
    jmp .l
.end:
    ret