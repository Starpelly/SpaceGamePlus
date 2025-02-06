using System;
namespace SpaceGameEngine;

public struct WindowProps
{
	public StringView Title;
	public uint Width;
	public uint Height;
}

/// The main window of the game.
/// There can only be one of these.
public class Window
{
	private static Window g_MainWindow;

	private SDL2.SDL.Window* m_Window;
	internal SDL2.SDL.Window* SDLWindow => m_Window;;

	public uint Width
	{
		get
		{
			SDL2.SDL.GetWindowSize(m_Window, let w, let h);
			return (uint)w;
		}
	}
	public uint Height
	{
		get
		{
			SDL2.SDL.GetWindowSize(m_Window, let w, let h);
			return (uint)h;
		}
	}

	public this(WindowProps props)
	{
		m_Window = SDL2.SDL.CreateWindow(props.Title.Ptr, .Undefined, .Undefined, (int32)props.Width, (int32)props.Height, .Shown);
	}

	public ~this()
	{
		if (m_Window != null)
			SDL2.SDL.DestroyWindow(m_Window);
	}
}