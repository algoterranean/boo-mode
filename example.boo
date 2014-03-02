namespace Gorilla

import System.Collections.Generic
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

# macro PewPewPew:
# 	return [|
			
# 	|]

class Koko (Smarty):
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

	def constructor(ego as bool):
		food_tastes = Dictionary[of Yum, bool]()
		food_tastes[Yum.Poop] = ego
		not_too_subtle = ("GOOD GIRL YUM YUM" if good_girl else "WOULD LIKE TO KNOW WHY SUCH CAGE")
		print "ME KOKO KOKO $not_too_subtle"
		secret_word = "up up down down left right left right a b a b select start"
		
		
	def OnYum (y as Yum):
		pass

	def Meow (s as string) as void:
		bff = s


k = Koko(true)
k.FavoriteCat = "socks"
print k.FavoriteCat + "\n", k.HotPockets


		
	
