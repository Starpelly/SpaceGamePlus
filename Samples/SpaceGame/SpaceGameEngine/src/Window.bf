using System;

#if ENGINE_SDL2
using SDL2;
#elif ENGINE_RAYLIB
using RaylibBeef;
#endif

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
#if ENGINE_SDL2
			SDL.GetWindowSize(m_Window, let w, let h);
			return (uint)w;
#elif ENGINE_RAYLIB
			return (uint)Raylib.GetScreenWidth();
#endif
		}
	}
	public uint Height
	{
		get
		{
#if ENGINE_SDL2
			SDL.GetWindowSize(m_Window, let w, let h);
			return (uint)h;
#elif ENGINE_RAYLIB
			return (uint)Raylib.GetScreenHeight();
#endif
		}
	}

	public this(WindowProps props)
	{
#if ENGINE_SDL2
		SDL2.SDL.Init(.Video | .Events | .Audio);
		SDL2.SDL.EventState(.JoyAxisMotion, .Disable);
		SDL2.SDL.EventState(.JoyBallMotion, .Disable);
		SDL2.SDL.EventState(.JoyHatMotion, .Disable);
		SDL2.SDL.EventState(.JoyButtonDown, .Disable);
		SDL2.SDL.EventState(.JoyButtonUp, .Disable);
		SDL2.SDL.EventState(.JoyDeviceAdded, .Disable);
		SDL2.SDL.EventState(.JoyDeviceRemoved, .Disable);

		m_Window = SDL2.SDL.CreateWindow(props.Title.Ptr, .Undefined, .Undefined, (int32)props.Width, (int32)props.Height, .Shown);
#elif ENGINE_RAYLIB
		Raylib.InitWindow((int32)props.Width, (int32)props.Height, props.Title.Ptr);
		Raylib.InitAudioDevice();
#endif
	}

	public ~this()
	{
#if ENGINE_SDL2
		if (m_Window != null)
			SDL2.SDL.DestroyWindow(m_Window);
#elif ENGINE_RAYLIB
		Raylib.CloseAudioDevice();
		Raylib.CloseWindow();
#endif
	}
}