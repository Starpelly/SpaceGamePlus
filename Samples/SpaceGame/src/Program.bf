// SpaceGame is a Beef sample utilizing SDL2.
//
// Press F5 to compile and run.
//
// Beef supports "hot compilation", allowing code changes while a program is
// running. Try opening "Hero.bf" under "SpaceGame" in the Workspace panel on
// the left and modify one of the constants at the top of the file. Press
// F7 to compile and apply your changes while the game is running.
//
// Beef can detect memory leaks in real-time. Try commenting out the
// "delete entity" line at the bottom of "GameApp.bf".

using SpaceGameEngine;

namespace SpaceGame;

class Program
{
	public static void Main()
	{
		let windowProps = WindowProps()
		{
			Title = "SpaceGame++",
			Width = 1024,
			Height = 768
		};

		let gameApp = scope GameApp(windowProps);
		gameApp.Init();
		gameApp.Run();
	}
}
