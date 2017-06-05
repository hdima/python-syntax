#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Above the run-comment and file encoding comment.

# Comments.

# TODO FIXME XXX

# Keywords.

with break continue del exec return pass print raise global assert yield
for while if elif else import from as try except finally and in is not or

lambda: a + 1
lambda x, y: x + y

yield from

def functionname
class Classname
def функция
class Класс

await
async def Test
async with
async for

# Type annotations

def myfunc(a: str, something_other,
           b: Callable[[str, str], int]) -> 'runtime_resolved_type':
    myval: float
    mygood: Optional[int, Any] = b('wow', 'oops')
    myarr: Sequence[int] = origarr[aa:bb] + (lambda: x)()
    mykey = a
    wow = {
        mykey: this_should_not_be_type_anno[Any],
        'b': some_data,
    }
    call_with_dict(a={
        'a': asdf,
        'b': 'zxcb',
        mykey: this_should_not_be_type_anno[Any],
    }, b=mydata['a'])
    vanilla_lambda = lambda x, y: myval + 1.0
    call_with_lambda(lambda x, y: myval + 1.0)
    call_with_slice(mydata[range_start:range_end])


# Builtin objects.

True False Ellipsis None NotImplemented

# Builtin function and types.

__import__() abs() all() any() apply() basestring() bool() buffer() callable() chr() classmethod()
cmp() coerce() compile() complex() delattr() dict() dir() divmod() enumerate() eval() execfile() file()
filter() float() frozenset() getattr() globals() hasattr() hash() help() hex() id() input() int()
intern() isinstance() issubclass() iter() len() list() locals() long() map() max() min() object() oct()
open() ord() pow() property() range() raw_input() reduce() reload() repr() reversed() round() set()
setattr() slice() sorted() staticmethod() str() sum() super() tuple() type() unichr() unicode() vars()
xrange() zip()

when_we_dont_call = a.float
float = when_we_dont_call

when_we_call = float(x)
when_we_call = min(a, b)

# Builtin exceptions and warnings.

BaseException Exception StandardError ArithmeticError LookupError
EnvironmentError

AssertionError AttributeError EOFError FloatingPointError GeneratorExit IOError
ImportError IndexError KeyError KeyboardInterrupt MemoryError NameError
NotImplementedError OSError OverflowError ReferenceError RuntimeError
StopIteration SyntaxError IndentationError TabError SystemError SystemExit
TypeError UnboundLocalError UnicodeError UnicodeEncodeError UnicodeDecodeError
UnicodeTranslateError ValueError WindowsError ZeroDivisionError

Warning UserWarning DeprecationWarning PendingDepricationWarning SyntaxWarning
RuntimeWarning FutureWarning ImportWarning UnicodeWarning

# Decorators.

@ decoratorname
@ object.__init__(arg1, arg2)
@ декоратор
@ декоратор.décorateur

# Numbers

0 1 2 9 10 0x1f .3 12.34 0j 124j 34.2E-3 0b10 0o77 1023434 0x0
1_1 1_1.2_2 1_2j 0x_1f 0x1_f 34_56e-3 34_56e+3_1 0o7_7

# Erroneous numbers

077 100L 0xfffffffL 0L 08 0xk 0x 0b102 0o78 0o123LaB
0_ 0_1 0_x1f 0x1f_ 0_b77 0b77_ .2_ 1_j

# Strings

" test " ' test '
"""
  test
"""
'''
  test
'''

" \a\b\c\"\'\n\r \x34\077 \08 \xag"
r" \" \' "

"testтест"

b"test"

b"test\r\n\xffff"

b"тестtest"

br"test"

br"\a\b\n\r"

# Formattings

" %f "
b" %f "

"{0.name!r:b} {0[n]} {name!s:  } {{test}} {{}} {} {.__len__:s}"
b"{0.name!r:b} {0[n]} {name!s:  } {{test}} {{}} {} {.__len__:s}"

"${test} ${test ${test}aname $$$ $test+nope"
b"${test} ${test ${test}aname $$$ $test+nope"

f"{var}...{arr[123]} normal {var['{'] // 0xff} \"xzcb\" 'xzcb' {var['}'] + 1} text"
f"{expr1 if True or False else expr2} wow {','.join(c.lower() for c in 'asdf')}"
f"hello {expr:.2f} yes {(lambda: 0b1)():#03x} lol {var!r}"

# Doctests.

"""
    Test:
    >>> a = 5
    >>> a
    5

    Test
"""

'''
    Test:
    >>> a = 5
    >>> a
    5

    Test
'''

# Erroneous symbols or bad variable names.

$ ? 6xav

&& || ===

# Indentation errors.

    	    break

# Trailing space errors.

    	
    break	    
"""  	
   	 
    test    	
"""  	
