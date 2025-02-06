using System;
using SpaceGameEngine.Math;

namespace SpaceGameEngine.Graphics;

public class Renderer
{
	private SDL2.SDL.Renderer* m_Renderer;
	internal SDL2.SDL.Renderer* SDLRenderer => m_Renderer;

	public this(SDL2.SDL.Window* window)
	{
		m_Renderer = SDL2.SDL.CreateRenderer(window, -1, .Accelerated);
	}

	public ~this()
	{
		if (m_Renderer != null)
			SDL2.SDL.DestroyRenderer(m_Renderer);
	}

	public void Open()
	{
		SDL2.SDL.SetRenderDrawColor(m_Renderer, 0, 0, 0, 255);
		SDL2.SDL.RenderClear(m_Renderer);
	}

	public void Close()
	{
		SDL2.SDL.RenderPresent(m_Renderer);
	}
}