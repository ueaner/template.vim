" Author  : ueaner <ueaner#gmail.com>
" License : MIT

" ==================== plugin header ==================== {{{

if exists('g:loaded_template_vim') || &cp
    finish
endif
let g:loaded_template_vim = 1
let s:save_cpo = &cpo
set cpo&vim

" }}}
" ==================== plugin content ==================== {{{

let s:current_file = expand("<sfile>")

augroup template-create
    autocmd!
    autocmd BufNewFile * call s:TemplateCreate()
augroup end

func s:GetTemplateFile() abort
    let l:root_dir = fnamemodify(s:current_file, ':h:h')
    let l:template_path  = l:root_dir . '/templates/'
    let l:template_dummy = l:root_dir . '/templates/dummy'

    " 默认模板为 hello_world.<扩展名>，特殊规则可手工指定
    let l:template_name  = 'hello_world.' . expand('%:e')
    let l:templates = {
                \ "_test.go$": "hello_world_test.go",
                \ ".java$":    "HelloWorld.java",
                \ ".bash$":    "hello_world.sh",
                \}

    let l:filename = expand('%:t')

    " g:templates

    " l:templates
    for [ft, tplname] in items(l:templates)
        if l:filename =~ ft
            let l:template_name = tplname
            break
        endif
    endfor

    let l:template_file = l:template_path . l:template_name
    if filereadable(l:template_file)
        return l:template_file
    endif

    " let l:template_file = get(l:templates, l:filetype, l:template_dummy)
    return l:template_dummy
endfunc

func s:TemplateCreate() abort
    let l:template_file = s:GetTemplateFile()
    silent exec 'keepalt 0r ' . fnameescape(l:template_file)
endfunc

" }}}
" ==================== plugin footer ==================== {{{

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
