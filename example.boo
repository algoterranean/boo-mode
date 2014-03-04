namespace ExampleSyntax

import System as S
import System.Drawing from System.Drawing as SD
from System.XML import * 


import System.Collections.Generic
import System.Linq
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Steps
import Boo.Lang.Compiler.MetaProgramming



abstract class Ether:
	pass


interface Dunno:
	def Foo()
	

enum Yum:
	Chocolate
	Cookies
	HotPockets

struct Point:
	x as single
	y as single
	food as Yum

	# TODO should constructor be highlighted in function face?
	def constructor(_x as int, _y as int):
		x = _x
		y = _y



macro PewPewPew:
# TODO indentation for doc string is not correct
"""print each statement in the body three times"""
	for statement in PewPewPew.Body.Statements:
		# TODO: Ast.ExpressionStatement should be highlighted in type face
		s = cast(Ast.ExpressionStatement, statement).Expression as Ast.StringLiteralExpression
		# TODO all string interpolation should be in the same face (as s.Value)
		yield [| print "$(s.Value * 3)" |]


# [Collection(NodeCollection)]
class Node:
	[Property(Name)]
	_n as string = ""

	override def ToString() as string:
		return _n



class AThing (Ether):
"""Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed 
do eiusmod tempor incididunt ut labore et dolore magna aliqua."""
	some_food as Dictionary[of Yum, int]
	eating = false
	bff = "socks"
	public at_your_peril as single = 1.0

	[getter(Value)] _value as double
	
	Eating as bool:
		get:
			return eating
		set:
			eating = value

	FavoriteCat as string:
		set:
			bff = value
		get:
			return bff



	event FinishedEating as callable (bool)

	def constructor():
		some_food = Dictionary[of Yum, int]()
		some_food[Yum.Cookies] = 20
		print "Sorry, I am busy eating" if eating
		
		FinishedEating(true)
			
		
	def OnYum (y as Yum) as int:
		if y in some_food:
			some_food[y] += 1
			return some_food[y]
		return 0

	def Meow ([default("mmmmmeeeeeeeooooowwwwwww")] s as string):
		print s




a = AThing()
print a.FavoriteCat
a.Meow(null)
print Node(Name: "something")


# duck typing
# TODO highlight duck in type face?
m as duck = AThing()
print m.FavoriteCat

# generator expressions
q = [x for x in range(10) if x % 2] # print odd numbers
print q
q = [x for x in range(10) unless x % 2] # events
print q



# linq
ints as int* = (of int: 1,2,3,1,2,3)  # TODO: int* should all be the same color for the type
print join(ints.Select({i as int | i.ToString("00")}))
print ints.Aggregate({i, j | i + j})

# regexp
secret_word = "up up down down left right left right a b a b select start"
if secret_word =~ @/select start/:
	print "99 lives!"

# macros
PewPewPew:
	"timetoeat!"

# slicing
l =[1, 2, 3, 4, 5]
print l[2:]
print l[0]
print l[1:3]

# arrays
foos = array(int, 3)
for i in range(foos.Length):
	foos[i] = i


# multi-dim arrays
ab = matrix(int, 3, 3)
for i in range(0,3):
	for j in range(0,3):
		ab[i,j] = i + 3*j

b = ab[0, 1:]
print b.Length
print b[0]
print b[1]



# hex
print 0xABC
# decimal(9)
print char(52)


i = 0
# TODO highlist checked/unchecked in macro face
unchecked:
	k = i + 1
checked:
	k = i + 1



try:
	raise System.ArithmeticException()
except x as System.OverflowException:
	pass
except x:
	print 'caught it'
ensure:
	print "now let's move on"



print typeof((object))

# continue
# break
# pass

# goto and labels
goto exit
print 'this should never appear'
:exit
print "That wasn't so harmful, was it?"




# for or syntax
for item in []:
	pass
or:
	print 'empty list!'
then:
	print "finished"

# # unpacking
# a, b, c = { i *= 2; print(i); return i }() for i in range(1, 10)

# while
while true:
	break

while false:
	pass
or:
	print "immediately got here"


myarray = (1,2,3)
# TODO highlight normal and raw arrayindexing in macro face
normalArrayIndexing:
	myarray[-1] = 4
	assert myarray[2] == 4

try:
	rawArrayIndexing:
		myarray[-1] = 5
except:
	print 'raw array indexing is working'

# AstAnnotations.MarkRawArrayIndexing(module)	


# by reference
def teststruct(ref s as Point):
	s.x = 6
	s.y = 7

s = Point(1, 2)
teststruct(s)
print s.x, s.y


# TODO highlight { } in bracket face
new_hash = {'hi':'world'}
new_hash['foo'] = 'bar'

