using System;
using System.IO;
using System.Diagnostics;
using System.Threading;

using SpaceGameEngine.Graphics;
using SpaceGameEngine.Audio;

using internal SpaceGameEngine.Scene;

namespace SpaceGameEngine;

public static class Engine
{
	// Engine modules
	public static Renderer Renderer { get; private set; } ~ delete _;
	private static AudioManager AudioManager { get; private set; } ~ delete _;

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

	public static void PlaySound(Sound sound, float volume = 1.0f, float pan = 0.5f)
	{
		if (sound == null)
			return;
#if ENGINE_SDL2
		int32 channel = SDL2.SDLMixer.PlayChannel(-1, sound.mChunk, 0);
		if (channel < 0)
			return;
		SDL2.SDLMixer.Volume(channel, (int32)(volume * 128));
#elif ENGINE_RAYLIB
		RaylibBeef.Raylib.PlaySound(sound.Sound);
#endif
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

		MainWindow = new .(props);
		Renderer = new .(MainWindow.[Friend]SDLWindow);
		AudioManager = new .();
	}

	internal static void Shutdown()
	{
	}

	internal static void Run()
	{
		m_Stopwatch.Start();
#if BF_PLATOFRM_WASM
#else

#if ENGINE_SDL2
		while (RunOneFrame()) {}
#elif ENGINE_RAYLIB
		RaylibBeef.Raylib.SetTargetFPS(60);
		while (!RaylibBeef.Raylib.WindowShouldClose())
		{
			Input.[Friend]Poll();
			Update();
			Render();
		}
#endif
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

#if ENGINE_SDL2
		int32 waitTime = 1;
		SDL.Event event;

		while (SDL.PollEvent(out event) != 0)
		{
			switch (event.type)
			{
			case .Quit:
				return false;
			case .KeyDown:
				OnKeyPressed((KeyCode)event.key.keysym.scancode);
			case .KeyUp:
				OnKeyReleased((KeyCode)event.key.keysym.scancode);
			case .MouseButtonDown:
				OnMouseButtonPressed(event.button);
			case .MouseButtonUp:
				OnMouseButtonReleased(event.button);
			default:
			}

			// HandleEvent(event);
			
			waitTime = 0;
		}
#endif

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

#if ENGINE_SDL2
		return true;
#elif ENGINE_RAYLIB
		return !RaylibBeef.Raylib.WindowShouldClose();
#endif
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

	private static void OnKeyPressed(KeyCode key)
	{
		m_CurrentScene.[Friend]OnKeyPressed(key);
	}

	private static void OnKeyReleased(KeyCode key)
	{
		m_CurrentScene.[Friend]OnKeyReleased(key);
	}

	private static void OnMouseButtonPressed(SDL2.SDL.MouseButtonEvent button)
	{

	}

	private static void OnMouseButtonReleased(SDL2.SDL.MouseButtonEvent button)
	{

	}
}