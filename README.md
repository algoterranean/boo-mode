# boo-mode

  This is an emacs major mode for the Boo programming language. 
 For more info on boo, see <http://boo.codehaus.org>.
 
 "Boo is an object oriented statically typed language for .NET and Mono
  with a python-inspired syntax and a special focus on metaprogramming
  through language and compiler extensibility."
 
 For this reason, this mode derives from python.el (python.el "Gallina").
 It is doubtful any other python mode will work with boo-mode due to the 
 use of and dependence on the indentation features of python.el.

 + Author: Patrick Sullivan
 + URL: <http://github.com/algoterranean/boo-mode>


This file is distributed under the terms of the GNU General Public License.
See <https://www.gnu.org/copyleft/gpl.html> for more information.


## Installation

 First, you will need python.el:
 <https://github.com/fgallina/python.el>. This mode derives from it
 and depends on its particular manner of handling syntax indentation.
 
 Put this file in your load path and put (require 'boo-mode) in your .emacs.
 You may, of course, hook into the boo-mode hook if you wish, and you will
 want to define the autoload stuff. For example:


```emacs-lisp
(setq boo-custom-macros '("client" "server"))
(require 'boo-mode)
(setq auto-mode-alist (append '(("\\.boo$" . boo-mode))
auto-mode-alist))
```


 
## Customization:


+ The faces are exposed if you wish to customize them.
 
+ You can define your own keywords that need syntax highlighting and 
   indentation (read: your custom macros!). HOWEVER you will need to 
   define the boo-custom-macro variable BEFORE you load this mode. 
   This is due to some rather hackish macro expansion stuff that 
   has been derived from python.el. See the example under
   Installation, above.
       

## TODO:
 
 - Improve and finalize syntax highlighting. 
   - In particular, Attributes.
 - Add doc string support.
 - Add keymap support. 
 - Interpreter support.
 - Break out font lock keywords into separate categories. 
 - Debugging support?
 - Unity-specific support? 


## History and Version Notes:

 - 0.1, Feb 2014: Initial release, so, yeah. Don't expect shit to work much.



