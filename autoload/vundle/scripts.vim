func! vundle#scripts#search(...)
  let matches = map(vundle#scripts#lookup(a:1), ' printf("Bundle \"%-5s\"", v:val) ') 
  let temp = tempname()
  call writefile(matches, temp)
  exec 'sp '.temp
	let @/=a:1
endf

func! vundle#scripts#lookup(term)
  return filter(vundle#scripts#load(), 'v:val =~ "'.escape(a:term,'"').'"')
endf

func! vundle#scripts#fetch()
  let to = g:vundle_scripts_file
  let temp = tempname()
  exec '!curl http://vim-scripts.org/api/scripts.json > '.temp
  exec '!mkdir -p $(dirname  '.to.') && mv -f '.temp.' '.to
  return to
endf

func! vundle#scripts#read()
  if !filereadable(g:vundle_scripts_file)
    call vundle#scripts#fetch()
  endif
  return readfile(g:vundle_scripts_file, 'b')[0]
endf

func! vundle#scripts#load()
  let g:vundle_scripts_file = expand('$HOME/.vim-vundle/vim-scripts.org.json')
  let g:vundle_scripts = eval(vundle#scripts#read())

  return g:vundle_scripts
endf

func! vundle#scripts#find(id)
  let scripts = vundle#scripts#load()
  return scripts[a:id]
endf