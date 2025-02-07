using System;
using SpaceGameEngine.Math;

#if ENGINE_SDL2
using SDL2;
#elif ENGINE_RAYLIB
using RaylibBeef;
#endif

namespace SpaceGameEngine.Graphics;

public class Renderer
{
#if ENGINE_SDL2
	private SDL.Renderer* m_Renderer;
	internal SDL.Renderer* SDLRenderer => m_Renderer;
#endif

	public this(SDL2.SDL.Window* window)
	{
#if ENGINE_SDL2
		m_Renderer = SDL.CreateRenderer(window, -1, .Accelerated);
		SDL.SetHint(SDL.SDL_HINT_RENDER_SCALE_QUALITY, "1");

		SDLImage.Init(.PNG);
		SDLTTF.Init();

		SDL.SetRenderDrawBlendMode(m_Renderer, .Blend);
#elif ENGINE_RAYLIB

#endif
	}

	public ~this()
	{
#if ENGINE_SDL2
		if (m_Renderer != null)
			SDL2.SDL.DestroyRenderer(m_Renderer);
#endif
	}

	public void Open()
	{
#if ENGINE_SDL2
		SDL.SetRenderDrawColor(m_Renderer, 0, 0, 0, 255);
		SDL.RenderClear(m_Renderer);
#elif ENGINE_RAYLIB
		Raylib.BeginDrawing();
		Raylib.ClearBackground(Raylib.BLACK);
#endif
	}

	public void Close()
	{
#if ENGINE_SDL2
		SDL.RenderPresent(m_Renderer);
#elif ENGINE_RAYLIB
		Raylib.EndDrawing();
#endif
	}
}