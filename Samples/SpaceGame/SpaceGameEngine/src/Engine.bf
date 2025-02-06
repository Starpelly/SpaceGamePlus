using System;
using System.IO;
using System.Diagnostics;
using SDL2;
using System.Threading;

using SpaceGameEngine.Graphics;
using internal SpaceGameEngine.Scene;

namespace SpaceGameEngine;

public static class Engine
{
	// Engine modules
	public static Renderer Renderer { get; private set; } ~ delete _;
	public static Random Random { get; private set; } = new .() ~ delete _;

	// Singletons
	private static App m_App = null;

	private static Scene m_CurrentScene = null ~ delete _;
	internal static Scene CurrentScene => m_CurrentScene;

	public static Window MainWindow { get; private set; } ~ delete _;

	// FPS
	private static Stopwatch m_FPSStopwatch = new .() ~ delete _;
	private static int32 m_FPSCount;

	// Frame timing
	private static Stopwatch m_Stopwatch = new .() ~ delete _;
	private static int m_CurPhysTickCount = 0;

	// Engine properties
	private static uint32 m_UpdateCount = 0;
	private static bool m_HasAudio = false;

	// --------------
	// Public methods
	// --------------

	public static void ChangeScene<T>() where T : Scene
	{
		if (m_CurrentScene != null)
		{
			m_CurrentScene.Unload();
			DeleteAndNullify!(m_CurrentScene);
		}
		m_CurrentScene = new T();
		m_CurrentScene.Load();
	}

	// ----------------
	// Internal methods
	// ----------------

	internal static void Init(App app, WindowProps props)
	{
		m_App = app;

		String exePath = scope .();
		Environment.GetExecutableFilePath(exePath);
		String exeDir = scope .();
		if (Path.GetDirectoryPath(exePath, exeDir) case .Ok)
			Directory.SetCurrentDirectory(exeDir);

		SDL2.SDL.Init(.Video | .Events | .Audio);
		SDL2.SDL.EventState(.JoyAxisMotion, .Disable);
		SDL2.SDL.EventState(.JoyBallMotion, .Disable);
		SDL2.SDL.EventState(.JoyHatMotion, .Disable);
		SDL2.SDL.EventState(.JoyButtonDown, .Disable);
		SDL2.SDL.EventState(.JoyButtonUp, .Disable);
		SDL2.SDL.EventState(.JoyDeviceAdded, .Disable);
		SDL2.SDL.EventState(.JoyDeviceRemoved, .Disable);

		MainWindow = new .(props);
		Renderer = new .(MainWindow.[Friend]SDLWindow);

		SDL.SetHint(SDL.SDL_HINT_RENDER_SCALE_QUALITY, "1");

		SDLImage.Init(.PNG);
		m_HasAudio = SDLMixer.OpenAudio(44100, SDLMixer.MIX_DEFAULT_FORMAT, 2, 4096) >= 0;

		SDL.SetRenderDrawBlendMode(Renderer.[Friend]SDLRenderer, .Blend);

		SDLTTF.Init();
	}

	internal static void Shutdown()
	{
	}

	internal static void Run()
	{
		m_Stopwatch.Start();
#if BF_PLATOFRM_WASM
#else
		while (RunOneFrame()) {}
#endif
	}

	// ---------------
	// Private methods
	// ---------------

	private static bool RunOneFrame()
	{
		if (!m_FPSStopwatch.IsRunning)
			m_FPSStopwatch.Start();

		m_FPSCount++;

		if (m_FPSStopwatch.ElapsedMilliseconds > 1000)
		{
			//Debug.WriteLine($"FPS: {mFPSCount} @ {mStopwatch.Elapsed} now: {emscripten_get_now()}");
			m_FPSCount = 0;
			m_FPSStopwatch.Restart();
		}

		int32 waitTime = 1;
		SDL.Event event;

		while (SDL.PollEvent(out event) != 0)
		{
			switch (event.type)
			{
			case .Quit:
				return false;
			case .KeyDown:
				OnKeyPressed(event.key);
			case .KeyUp:
				OnKeyReleased(event.key);
			case .MouseButtonDown:
				OnMouseButtonPressed(event.button);
			case .MouseButtonUp:
				OnMouseButtonReleased(event.button);
			default:
			}

			// HandleEvent(event);
			
			waitTime = 0;
		}

		// Fixed 60 Hz update
		double msPerTick = 1000 / 60.0;
		int newPhysTickCount = (int)(m_Stopwatch.ElapsedMilliseconds / msPerTick);

		int addTicks = newPhysTickCount - m_CurPhysTickCount;
		if (m_CurPhysTickCount == 0)
		{
			// Initial render
			Render();                
			// Show initially hidden window, mitigates white flash on slow startups
			// SDL.ShowWindow(mWindow); 
		}
		else
		{
			Input.[Friend]Poll();

			addTicks = Math.Min(addTicks, 20); // Limit catchup
			if (addTicks > 0)
			{
				for (int i < addTicks)
				{
					m_UpdateCount++;
					Update();
				}
				Render();
			}
			else
			{
				Thread.Sleep(1);
			}
		}

		m_CurPhysTickCount = newPhysTickCount;

		return true;
	}

	private static void Update()
	{
		m_CurrentScene.Update();

		m_App.OnUpdate();
	}

	private static void Render()
	{
		Renderer.Open();
		defer Renderer.Close();

		m_CurrentScene.[Friend]Draw();
		m_App.OnDraw();
	}

	private static void OnKeyPressed(SDL2.SDL.KeyboardEvent key)
	{
		m_CurrentScene.[Friend]OnKeyPressed((KeyCode)key.keysym.scancode);
	}

	private static void OnKeyReleased(SDL2.SDL.KeyboardEvent key)
	{
		m_CurrentScene.[Friend]OnKeyReleased((KeyCode)key.keysym.scancode);
	}

	private static void OnMouseButtonPressed(SDL2.SDL.MouseButtonEvent button)
	{

	}

	private static void OnMouseButtonReleased(SDL2.SDL.MouseButtonEvent button)
	{

	}
}