namespace Gorilla

import System.Collections.Generic
import Boo.Lang.Compiler
# import Dog # TODO: add thumbs

abstract class Smarty:
	pass

enum Yum:
	Bananna
	Greens
	Poop

struct Paint:
	actual_color as int
	gorilla_color as int

macro PewPewPew:
"""print each statement in the body three times"""
	for statement in PewPewPew.Body.Statements:
		s = cast(Ast.ExpressionStatement, statement).Expression as Ast.StringLiteralExpression
		yield [| print $(s.Value*3) |]

# [Collection(NodeCollection)]
class Node:
	[Property(Name)]
	_n as string = ""

	override def ToString() as string:
		return _n


class Koko (Smarty):
"""an
example 
class"""
	food_tastes as Dictionary[of Yum, bool]
	good_girl = true
	bff as string
	
	FavoriteCat as string:
		get:
			return "KOKO LOVE $(bff)"
		set:
			bff = value

	[Getter(HotPockets)]
	secret_word as string

	event FinishedPainting as callable(int)

	def constructor(ego as bool):
		self.bff = 'Jane'
		food_tastes = Dictionary[of Yum, bool]()
		food_tastes[Yum.Poop] = ego
		not_too_subtle = ("GOOD GIRL YUM YUM" if good_girl else "WOULD LIKE TO KNOW WHY SUCH CAGE")
		print "ME KOKO KOKO $not_too_subtle"
		secret_word = "up up down down left right left right a b a b select start"

		if secret_word =~ @/select start/:
			print "99 lives!"

			
			

		PewPewPew:
			"playtime"

		FinishedPainting(42)
			
		
	def OnYum (y as Yum) as int:
		return 0

	def Meow (s as string) as void:
		bff = s




k = Koko(true)
k.FavoriteCat = "socks"
print k.FavoriteCat + "\n", k.HotPockets
print Node(Name: "something")

		
	
