# Minesweeper+

![[LICENSE](https://github.com/Intancote/Minesweeper-Plus/blob/main/LICENSE)](https://img.shields.io/github/license/Intancote/Minesweeper-Plus?style=flat-square)
![[GitHub Contributors](https://github.com/Intancote/Minesweeper-Plus/graphs/contributors)](https://img.shields.io/github/contributors/Intancote/Minesweeper-Plus?style=flat-square)
![[Github Issues](https://github.com/Intancote/Minesweeper-Plus/issues)](https://img.shields.io/github/issues/Intancote/Minesweeper-Plus?style=flat-square&color=0088ff)
![[GitHub Pull requests](https://github.com/Intancote/Minesweeper-Plus/pulls)](https://img.shields.io/github/issues-pr/Intancote/Minesweeper-Plus?style=flat-square&color=0088ff)
![[OpenSSF Scorecard](https://securityscorecards.dev/viewer/?uri=github.com/Intancote/Minesweeper-Plus)](https://api.securityscorecards.dev/projects/github.com/Intancote/Minesweeper-Plus/badge?style=flat-square)

> [!IMPORTANT]
> This project is still in development and is currently in a somewhat "playable" state.
> The game is still missing some features and is not yet fully polished.
> Use this opportunity to contribute to the project and be a early contributor.

This is a open source version of Minesweeper, but made in Haxe with some added features (eventually added features...).

This is made for a school project, but I decided to make it open source
so that others can contribute to the project if they so choose.

I will not be working on this project as much (or at all) after the project is presented in school,
but I will still be accepting pull requests and issues if I have the time.

I might even come back to the project and add more features if I want to.
Or give ownership to someone I believe can take care of the project.

## Building

To build the project, you will need to have the following installed:

* Haxe 4.3.4
* HaxeFlixel 5.8.0
* Lime 8.1.2

1. Download Haxe 4.3.4 from [Here](https://haxe.org/download/version/4.3.4) or get the latest version from [Here](https://haxe.org/download/)

2. Install and setup HaxeFlixel and Lime by running these commands:

```bash
# To get the packages
haxelib install lime
haxelib install openfl
haxelib install flixel

# To install additional libraries
haxelib run lime setup flixel

# To use lime as a command (alias for haxelib run lime)
haxelib run lime setup

# To properly setup flixel-tools for projects
haxelib install flixel-tools
haxelib run flixel-tools setup
```

3. Clone the repository and navigate to the project directory and open a terminal. Then run the following command:

```bash
# Currently you can only run the HTML5 build (from my knowledge)

# Run this command to build the project and run it in your browser
lime test html5

# Run this command to only build the project but not run it
lime build html5
```

(You should go to "./export/target/bin" after building, so you can check out the README.txt for more info)
