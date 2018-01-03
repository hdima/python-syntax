" Vim syntax file
" Language:             Python
" Current Maintainer:   Dmitry Vasiliev <dima at hlabs dot org>
" Previous Maintainer:  Neil Schemenauer <nas at python dot ca>
" URL:                  https://github.com/hdima/python-syntax
" Last Change:          2015-11-01
" Filenames:            *.py
" Version:              3.6.0
"
" Based on python.vim (from Vim 6.1 distribution)
" by Neil Schemenauer <nas at python dot ca>
"
" Please use the following channels for reporting bugs, offering suggestions or
" feedback:

" - python.vim issue tracker: https://github.com/hdima/python-syntax/issues
" - Email: Dmitry Vasiliev (dima at hlabs.org)
" - Send a message or follow me for updates on Twitter: `@hdima
"   <https://twitter.com/hdima>`__
"
" Contributors
" ============
"
" List of the contributors in alphabetical order:
"
"   Andrea Riciputi
"   Anton Butanaev
"   Antony Lee
"   Caleb Adamantine
"   David Briscoe
"   Elizabeth Myers
"   Ihor Gorobets
"   Jeroen Ruigrok van der Werven
"   John Eikenberry
"   Joongi Kim
"   Marc Weber
"   Pedro Algarvio
"   Victor Salgado
"   Will Gray
"   Yuri Habrusiev
"
" Options
" =======
"
"    :let OPTION_NAME = 1                   Enable option
"    :let OPTION_NAME = 0                   Disable option
"
"
" Option to select Python version
" -------------------------------
"
"    python_version_2                       Enable highlighting for Python 2
"                                           (Python 3 highlighting is enabled
"                                           by default). Can also be set as
"                                           a buffer (b:python_version_2)
"                                           variable.
"
"    You can also use the following local to buffer commands to switch
"    between two highlighting modes:
"
"    :Python2Syntax                         Switch to Python 2 highlighting
"                                           mode
"    :Python3Syntax                         Switch to Python 3 highlighting
"                                           mode
"
" Option names used by the script
" -------------------------------
"
"    python_highlight_builtins              Highlight builtin functions and
"                                           objects
"      python_highlight_builtin_objs        Highlight builtin objects only
"      python_highlight_builtin_funcs       Highlight builtin functions only
"    python_highlight_exceptions            Highlight standard exceptions
"    python_highlight_string_formatting     Highlight % string formatting
"    python_highlight_string_format         Highlight str.format syntax
"    python_highlight_string_templates      Highlight string.Template syntax
"    python_highlight_indent_errors         Highlight indentation errors
"    python_highlight_space_errors          Highlight trailing spaces
"    python_highlight_doctests              Highlight doc-tests
"    python_print_as_function               Highlight 'print' statement as
"                                           function for Python 2
"    python_highlight_file_headers_as_comments
"                                           Highlight shebang and coding
"                                           headers as comments
"
"    python_highlight_all                   Enable all the options above
"                                           NOTE: This option don't override
"                                           any previously set options
"
"    python_slow_sync                       Can be set to 0 for slow machines
"

" For version 5.x: Clear all syntax items
" For versions greater than 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"
" Commands
"
command! -buffer Python2Syntax let b:python_version_2 = 1 | let &syntax=&syntax
command! -buffer Python3Syntax let b:python_version_2 = 0 | let &syntax=&syntax

" Enable option if it's not defined
function! s:EnableByDefault(name)
  if !exists(a:name)
    let {a:name} = 1
  endif
endfunction

" Check if option is enabled
function! s:Enabled(name)
  return exists(a:name) && {a:name}
endfunction

" Is it Python 2 syntax?
function! s:Python2Syntax()
  if exists("b:python_version_2")
      return b:python_version_2
  endif
  return s:Enabled("g:python_version_2")
endfunction

"
" Default options
"

call s:EnableByDefault("g:python_slow_sync")

if s:Enabled("g:python_highlight_all")
  call s:EnableByDefault("g:python_highlight_builtins")
  if s:Enabled("g:python_highlight_builtins")
    call s:EnableByDefault("g:python_highlight_builtin_objs")
    call s:EnableByDefault("g:python_highlight_builtin_funcs")
  endif
  call s:EnableByDefault("g:python_highlight_type_annotations")
  call s:EnableByDefault("g:python_highlight_exceptions")
  call s:EnableByDefault("g:python_highlight_string_formatting")
  call s:EnableByDefault("g:python_highlight_string_format")
  call s:EnableByDefault("g:python_highlight_string_templates")
  call s:EnableByDefault("g:python_highlight_indent_errors")
  call s:EnableByDefault("g:python_highlight_space_errors")
  call s:EnableByDefault("g:python_highlight_doctests")
  call s:EnableByDefault("g:python_print_as_function")
endif

"
" Keywords
"

syn keyword pythonStatement     break continue del
if s:Python2Syntax()
  syn keyword pythonStatement     exec
endif
syn keyword pythonStatement     return
syn keyword pythonStatement     pass raise
syn keyword pythonStatement     global assert
syn keyword pythonStatement     with
syn keyword pythonStatement     def class nextgroup=pythonFunction skipwhite
syn keyword pythonRepeat        for while
syn keyword pythonConditional   if elif else
" The standard pyrex.vim unconditionally removes the pythonInclude group, so
" we provide a dummy group here to avoid crashing pyrex.vim.
syn keyword pythonInclude       import
syn keyword pythonImport        import
syn match   pythonIdentifier    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" nextgroup=pythonFuncArgs,pythonTypeAnno display
syn keyword pythonException     try except finally
syn keyword pythonOperator      and in is not or
syn match pythonLambdaExpr   "\<lambda[^:]*:"he=s+6 contains=@pythonExpression nextgroup=@pythonExpression

syn region pythonDictSetExpr matchgroup=pythonDictSetExpr start='{' end='}' contains=@pythonExpression
syn region pythonListSliceExpr matchgroup=pythonListSliceExpr start='\[' end='\]' contains=@pythonExpression
syn region pythonFuncArgs    matchgroup=pythonFuncArgs    start='(' end=')' contained contains=@pythonTypeExpression,@pythonExpression

if !s:Python2Syntax()
  if s:Enabled("g:python_highlight_type_annotations")
    syn match pythonTypeAnno @:\s*['"]\?\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\)*['"]\?@hs=s+1 display contained contains=pythonType,pythonString nextgroup=pythonTypeUnion,pythonTypeArgs
    syn match pythonTypeUnion @\s*|\s*['"]\?\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\)*['"]\?@ display contained contains=pythonType,pythonString nextgroup=pythonTypeUnion
    syn match pythonTypeAnnoReturn @->\s*['"]\?\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\)*['"]\?@ display contains=pythonType,pythonString nextgroup=pythonTypeArgs
    syn region pythonTypeArgs matchgroup=pythonTypeArgs start='\[' end='\]' display contained contains=pythonType,pythonString,pythonTypeArgs
    syn keyword pythonType Any AnyStr Callable ClassVar Tuple Union Optional Type TypeVar None contained
    syn keyword pythonType AbstractSet MutableSet Mapping MutableMapping Sequence MutableSequence ByteString Deque List contained
    syn keyword pythonType Set FrozenSet MappingView KeysView ItemsView ValuesView Awaitable Coroutine AsyncIterable contained
    syn keyword pythonType AsyncIterator ContextManager Dict DefaultDict Generator AsyncGenerator Text NamedTuple contained
    syn keyword pythonType Iterable Iterator Reversible SupportsInt SupportsFloat SupportsAbs SupportsRound Container contained
    syn keyword pythonType Hashable Sized Collection contained
  endif
endif

syn match pythonStatement   "\<yield\>" display
syn match pythonImport      "\<from\>" display

if s:Python2Syntax()
  if !s:Enabled("g:python_print_as_function")
    syn keyword pythonStatement  print
  endif
  syn keyword pythonImport      as
  syn match   pythonFunction    "[a-zA-Z_][a-zA-Z0-9_]*" display contained
else
  syn keyword pythonStatement   as nonlocal
  syn match   pythonStatement   "\<yield\s\+from\>" display
  syn keyword pythonBuiltinObj  None True False
  syn match   pythonFunction    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" nextgroup=pythonFuncArgs display contained
  syn keyword pythonStatement   await async
  syn match   pythonStatement   "\<async\s\+def\>" display nextgroup=pythonFunction skipwhite
  syn match   pythonStatement   "\<async\s\+with\>" display
  syn match   pythonStatement   "\<async\s\+for\>" display
endif

syn cluster pythonTypeExpression contains=pythonTypeAnno,pythonTypeUnion,pythonTypeArgs

syn cluster pythonExpression contains=
            \ pythonFuncArgs,
            \ pythonDictSetExpr,
            \ pythonListSliceExpr,
            \ pythonLambdaExpr,
            \ pythonStatement,
            \ pythonRepeat,
            \ pythonConditional,
            \ pythonComment,
            \ pythonOperator,
            \ pythonNumber,
            \ pythonNumberError,
            \ pythonFloat,
            \ pythonHexNumber,
            \ pythonOctNumber,
            \ pythonBytes,
            \ pythonString,
            \ pythonRawString,
            \ pythonUniString,
            \ pythonUniRawString,
            \ pythonFString,
            \ pythonExClass,
            \ pythonBuiltinObj,
            \ pythonBuiltinFunc

syn cluster pythonFExpression contains=
            \ pythonStatement,
            \ pythonDictSetExpr,
            \ pythonListSliceExpr,
            \ pythonLambdaExpr,
            \ pythonRepeat,
            \ pythonConditional,
            \ pythonOperator,
            \ pythonNumber,
            \ pythonHexNumber,
            \ pythonOctNumber,
            \ pythonBinNumber,
            \ pythonFloat,
            \ pythonString,
            \ pythonBytes,
            \ pythonBuiltinObj,
            \ pythonBuiltinFunc

"
" Decorators (new in Python 2.4)
"

syn match   pythonDecorator     "^\s*\zs@" display nextgroup=pythonDottedName skipwhite
if s:Python2Syntax()
  syn match   pythonDottedName "[a-zA-Z_][a-zA-Z0-9_]*\%(\.[a-zA-Z_][a-zA-Z0-9_]*\)*" display contained
else
  syn match   pythonDottedName "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\)*" display contained
endif
syn match   pythonDot        "\." display containedin=pythonDottedName

"
" Comments
"

syn match   pythonComment       "#.*$" display contains=pythonTodo,@Spell
if !s:Enabled("g:python_highlight_file_headers_as_comments")
  syn match   pythonRun         "\%^#!.*$"
  syn match   pythonCoding      "\%^.*\%(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
endif
syn keyword pythonTodo          TODO FIXME XXX contained

"
" Errors
"

syn match pythonError           "\<\d\+\D\+\>" display
syn match pythonError           "[$?]" display
syn match pythonError           "[&|]\{2,}" display
syn match pythonError           "[=]\{3,}" display

" Mixing spaces and tabs also may be used for pretty formatting multiline
" statements
if s:Enabled("g:python_highlight_indent_errors")
  syn match pythonIndentError   "^\s*\%( \t\|\t \)\s*\S"me=e-1 display
endif

" Trailing space errors
if s:Enabled("g:python_highlight_space_errors")
  syn match pythonSpaceError    "\s\+$" display
endif

"
" Strings
"

if s:Python2Syntax()
  " Python 2 strings
  syn region pythonString   start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+[bB]\="""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonString   start=+[bB]\='''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
else
  " Python 3 byte strings
  syn region pythonBytes                start=+[bB]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
  syn region pythonBytes                start=+[bB]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
  syn region pythonBytes                start=+[bB]"""+ end=+"""+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonBytes                start=+[bB]'''+ end=+'''+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest,pythonSpaceError,@Spell

  syn match pythonBytesError    ".\+" display contained
  syn match pythonBytesContent  "[\u0000-\u00ff]\+" display contained contains=pythonBytesEscape,pythonBytesEscapeError
endif

syn match pythonBytesEscape       +\\[abfnrtv'"\\]+ display contained
syn match pythonBytesEscape       "\\\o\o\=\o\=" display contained
syn match pythonBytesEscapeError  "\\\o\{,2}[89]" display contained
syn match pythonBytesEscape       "\\x\x\{2}" display contained
syn match pythonBytesEscapeError  "\\x\x\=\X" display contained
syn match pythonBytesEscape       "\\$"

syn match pythonUniEscape         "\\u\x\{4}" display contained
syn match pythonUniEscapeError    "\\u\x\{,3}\X" display contained
syn match pythonUniEscape         "\\U\x\{8}" display contained
syn match pythonUniEscapeError    "\\U\x\{,7}\X" display contained
syn match pythonUniEscape         "\\N{[A-Z ]\+}" display contained
syn match pythonUniEscapeError    "\\N{[^A-Z ]\+}" display contained

if s:Python2Syntax()
  " Python 2 Unicode strings
  syn region pythonUniString  start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonUniString  start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonUniString  start=+[uU]"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonUniString  start=+[uU]'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
else
  " Python 3 strings
  syn region pythonString   start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonString   start=+'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell

  syn region pythonFString  start=+[fF]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonFString  start=+[fF]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonFString  start=+[fF]"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonFString  start=+[fF]'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
endif

if s:Python2Syntax()
  " Python 2 Unicode raw strings
  syn region pythonUniRawString start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
  syn region pythonUniRawString start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
  syn region pythonUniRawString start=+[uU][rR]"""+ end=+"""+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonUniRawString start=+[uU][rR]'''+ end=+'''+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest,pythonSpaceError,@Spell

  syn match  pythonUniRawEscape       "\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
  syn match  pythonUniRawEscapeError  "\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained
endif

" Python 2/3 raw strings
if s:Python2Syntax()
  syn region pythonRawString  start=+[bB]\=[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell
else
  syn region pythonRawString  start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawString  start=+[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

  syn region pythonRawBytes  start=+[bB][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawBytes  start=+[bB][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawBytes  start=+[bB][rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawBytes  start=+[bB][rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell
endif

syn match pythonRawEscape +\\['"]+ display transparent contained

if s:Enabled("g:python_highlight_string_formatting")
  " % operator string formatting
  if s:Python2Syntax()
    syn match pythonStrFormatting       "%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrFormatting       "%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
  else
    syn match pythonStrFormatting       "%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
    syn match pythonStrFormatting       "%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
  endif
endif

if s:Enabled("g:python_highlight_string_format")
  " str.format syntax
  if s:Python2Syntax()
    syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrFormat   "{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
  else
    syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonRawString
    syn match pythonStrFormat "{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonRawString
    syn region pythonStrInterpRegion matchgroup=pythonStrInterpRegion start="{" end="}" extend contained containedin=pythonFString contains=@pythonFExpression
  endif
endif

if s:Enabled("g:python_highlight_string_templates")
  " string.Template format
  if s:Python2Syntax()
    syn match pythonStrTemplate "\$\$" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrTemplate "\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrTemplate "\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
  else
    syn match pythonStrTemplate "\$\$" contained containedin=pythonString,pythonRawString
    syn match pythonStrTemplate "\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonRawString
    syn match pythonStrTemplate "\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonRawString
  endif
endif

if s:Enabled("g:python_highlight_doctests")
  " DocTests
  syn region pythonDocTest      start="^\s*>>>" end=+'''+he=s-1 end="^\s*$" contained
  syn region pythonDocTest2     start="^\s*>>>" end=+"""+he=s-1 end="^\s*$" contained
endif

"
" Numbers (ints, longs, floats, complex)
"

if s:Python2Syntax()
  syn match   pythonHexError    "\<0[xX]\x*[g-zG-Z]\+\x*[lL]\=\>" display
  syn match   pythonOctError    "\<0[oO]\=\o*\D\+\d*[lL]\=\>" display
  syn match   pythonBinError    "\<0[bB][01]*\D\+\d*[lL]\=\>" display

  syn match   pythonHexNumber   "\<0[xX]\x\+[lL]\=\>" display
  syn match   pythonOctNumber "\<0[oO]\o\+[lL]\=\>" display
  syn match   pythonBinNumber "\<0[bB][01]\+[lL]\=\>" display

  syn match   pythonNumberError "\<\d\+\D[lL]\=\>" display
  syn match   pythonNumber      "\<\d[lL]\=\>" display
  syn match   pythonNumber      "\<[0-9]\d\+[lL]\=\>" display
  syn match   pythonNumber      "\<\d\+[lLjJ]\>" display

  syn match   pythonOctError    "\<0[oO]\=\o*[8-9]\d*[lL]\=\>" display
  syn match   pythonBinError    "\<0[bB][01]*[2-9]\d*[lL]\=\>" display

  syn match   pythonFloat       "\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>" display
  syn match   pythonFloat       "\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
  syn match   pythonFloat       "\<\d\+\.\d*\%([eE][+-]\=\d\+\)\=[jJ]\=" display
else
  syn match   pythonHexError    "\<0[xX]\x*[g-zG-Z]\x*\>" display
  syn match   pythonOctError    "\<0[oO]\=\o*\D\+\d*\>" display
  syn match   pythonBinError    "\<0[bB][01]*\D\+\d*\>" display

  syn match   pythonHexNumber   "\<0[xX][_0-9a-fA-F]*\x\>" display
  syn match   pythonOctNumber "\<0[oO][_0-7]*\o\>" display
  syn match   pythonBinNumber "\<0[bB][_01]*[01]\>" display

  syn match   pythonNumberError "\<\d[_0-9]*\D\>" display
  syn match   pythonNumberError "\<0[_0-9]\+\>" display
  syn match   pythonNumberError "\<\d[_0-9]*_\>" display
  syn match   pythonNumber      "\<\d\>" display
  syn match   pythonNumber      "\<[1-9][_0-9]*\d\>" display
  syn match   pythonNumber      "\<\d[jJ]\>" display
  syn match   pythonNumber      "\<[1-9][_0-9]*\d[jJ]\>" display

  syn match   pythonOctError    "\<0[oO]\=\o*[8-9]\d*\>" display
  syn match   pythonBinError    "\<0[bB][01]*[2-9]\d*\>" display

  syn match   pythonFloat       "\.\d\%([_0-9]*\d\)\=\%([eE][+-]\=\d\%([_0-9]*\d\)\=\)\=[jJ]\=\>" display
  syn match   pythonFloat       "\<\d\%([_0-9]*\d\)\=[eE][+-]\=\d\%([_0-9]*\d\)\=[jJ]\=\>" display
  syn match   pythonFloat       "\<\d\%([_0-9]*\d\)\=\.\d\%([_0-9]*\d\)\=\%([eE][+-]\=\d\%([_0-9]*\d\)\=\)\=[jJ]\=" display
endif

"
" Builtin objects and types
"

if s:Enabled("g:python_highlight_builtin_objs")
  if s:Python2Syntax()
    syn keyword pythonBuiltinObj        None False True
  endif
  syn keyword pythonBuiltinObj  Ellipsis NotImplemented self cls
  syn keyword pythonBuiltinObj  __debug__ __doc__ __file__ __name__ __package__
endif

"
" Builtin functions
"

if s:Enabled("g:python_highlight_builtin_funcs")
  if s:Python2Syntax()
    syn match pythonBuiltinFunc '\v(\.)@<!\zs<(apply|basestring|buffer|callable|coerce)>\ze\(' nextgroup=pythonFuncArgs
    syn match pythonBuiltinFunc '\v(\.)@<!\zs<(execfile|file|help|intern|long|raw_input)>\ze\(' nextgroup=pythonFuncArgs
    syn match pythonBuiltinFunc '\v(\.)@<!\zs<(reduce|reload|unichr|unicode|xrange)>\ze\(' nextgroup=pythonFuncArgs
    if s:Enabled("g:python_print_as_function")
      syn match pythonBuiltinFunc       '\v(\.)@<!\zs<(print)>\ze\(' nextgroup=pythonFuncArgs
    endif
  else
    syn match pythonBuiltinFunc '\v(\.)@<!\zs<(ascii|exec|memoryview|print)\ze\(' nextgroup=pythonFuncArgs
  endif
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(__import__|abs|all|any)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(bin|bool|bytearray|bytes)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(chr|classmethod|cmp|compile|complex)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(delattr|dict|dir|divmod|enumerate|eval)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(filter|float|format|frozenset|getattr)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(globals|hasattr|hash|hex|id)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(input|int|isinstance)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(issubclass|iter|len|list|locals|map|max)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(min|next|object|oct|open|ord)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(pow|property|range)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(repr|reversed|round|set|setattr)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(slice|sorted|staticmethod|str|sum|super|tuple)>\ze\(' nextgroup=pythonFuncArgs
  syn match pythonBuiltinFunc   '\v(\.)@<!\zs<(type|vars|zip)>\ze\(' nextgroup=pythonFuncArgs
endif

"
" Builtin exceptions and warnings
"

if s:Enabled("g:python_highlight_exceptions")
  if s:Python2Syntax()
    syn keyword pythonExClass   StandardError nextgroup=pythonFuncArgs
  else
    syn keyword pythonExClass   BlockingIOError ChildProcessError nextgroup=pythonFuncArgs
    syn keyword pythonExClass   ConnectionError BrokenPipeError nextgroup=pythonFuncArgs
    syn keyword pythonExClass   ConnectionAbortedError ConnectionRefusedError nextgroup=pythonFuncArgs
    syn keyword pythonExClass   ConnectionResetError FileExistsError nextgroup=pythonFuncArgs
    syn keyword pythonExClass   FileNotFoundError InterruptedError nextgroup=pythonFuncArgs
    syn keyword pythonExClass   IsADirectoryError NotADirectoryError nextgroup=pythonFuncArgs
    syn keyword pythonExClass   PermissionError ProcessLookupError TimeoutError nextgroup=pythonFuncArgs

    syn keyword pythonExClass   ResourceWarning nextgroup=pythonFuncArgs
  endif
  syn keyword pythonExClass     BaseException nextgroup=pythonFuncArgs
  syn keyword pythonExClass     Exception ArithmeticError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     LookupError EnvironmentError nextgroup=pythonFuncArgs

  syn keyword pythonExClass     AssertionError AttributeError BufferError EOFError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     FloatingPointError GeneratorExit IOError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     ImportError IndexError KeyError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     KeyboardInterrupt MemoryError NameError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     NotImplementedError OSError OverflowError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     ReferenceError RuntimeError StopIteration nextgroup=pythonFuncArgs
  syn keyword pythonExClass     SyntaxError IndentationError TabError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     SystemError SystemExit TypeError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     UnboundLocalError UnicodeError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     UnicodeEncodeError UnicodeDecodeError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     UnicodeTranslateError ValueError VMSError nextgroup=pythonFuncArgs
  syn keyword pythonExClass     WindowsError ZeroDivisionError nextgroup=pythonFuncArgs

  syn keyword pythonExClass     Warning UserWarning BytesWarning DeprecationWarning nextgroup=pythonFuncArgs
  syn keyword pythonExClass     PendingDepricationWarning SyntaxWarning nextgroup=pythonFuncArgs
  syn keyword pythonExClass     RuntimeWarning FutureWarning nextgroup=pythonFuncArgs
  syn keyword pythonExClass     ImportWarning UnicodeWarning nextgroup=pythonFuncArgs
endif

if s:Enabled("g:python_slow_sync")
  syn sync minlines=2000
else
  " This is fast but code inside triple quoted strings screws it up. It
  " is impossible to fix because the only way to know if you are inside a
  " triple quoted string is to start from the beginning of the file.
  syn sync match pythonSync grouphere NONE "):$"
  syn sync maxlines=200
endif

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pythonStatement        Statement
  HiLink pythonLambdaExpr       Statement
  HiLink pythonImport           Include
  HiLink pythonFunction         Function
  HiLink pythonConditional      Conditional
  HiLink pythonRepeat           Repeat
  HiLink pythonException        Exception
  HiLink pythonOperator         Operator

  HiLink pythonDecorator        Define
  HiLink pythonDottedName       Function
  HiLink pythonDot              Normal

  HiLink pythonComment          Comment
  if !s:Enabled("g:python_highlight_file_headers_as_comments")
    HiLink pythonCoding           Special
    HiLink pythonRun              Special
  endif
  HiLink pythonTodo             Todo

  HiLink pythonError            Error
  HiLink pythonIndentError      Error
  HiLink pythonSpaceError       Error

  HiLink pythonString           String
  HiLink pythonRawString        String

  HiLink pythonUniEscape        Special
  HiLink pythonUniEscapeError   Error

  if s:Python2Syntax()
    HiLink pythonUniString          String
    HiLink pythonUniRawString       String
    HiLink pythonUniRawEscape       Special
    HiLink pythonUniRawEscapeError  Error
  else
    HiLink pythonBytes              String
    HiLink pythonRawBytes           String
    HiLink pythonBytesContent       String
    HiLink pythonBytesError         Error
    HiLink pythonBytesEscape        Special
    HiLink pythonBytesEscapeError   Error
    HiLink pythonFString            String
    HiLink pythonStrInterpRegion    Special
  endif

  HiLink pythonStrFormatting    Special
  HiLink pythonStrFormat        Special
  HiLink pythonStrTemplate      Special

  HiLink pythonDocTest          Special
  HiLink pythonDocTest2         Special

  HiLink pythonNumber           Number
  HiLink pythonHexNumber        Number
  HiLink pythonOctNumber        Number
  HiLink pythonBinNumber        Number
  HiLink pythonFloat            Float
  HiLink pythonNumberError      Error
  HiLink pythonOctError         Error
  HiLink pythonHexError         Error
  HiLink pythonBinError         Error

  HiLink pythonBuiltinObj       Structure
  HiLink pythonBuiltinFunc      Function

  HiLink pythonExClass          Structure

  HiLink pythonTypeAnno         Optional
  HiLink pythonTypeUnion        Optional
  HiLink pythonTypeAnnoReturn   Optional
  HiLink pythonTypeArgs         Optional
  HiLink pythonType             Special

  delcommand HiLink

  " default style for custom highlight group (may be overriden in colors)
  hi Optional gui=italic cterm=italic
endif

let b:current_syntax = "python"
