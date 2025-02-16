using System;
using System.Collections;
using System.Diagnostics;
using SpaceGameEngine;
using SpaceGameEngine.Graphics;
using SpaceGameEngine.Audio;

namespace SpaceGame;

static
{
	public static GameApp gGameApp;
}

class GameApp : App
{
#if !NOTTF
	public Font MainFont { get; private set; } ~ delete _;
#endif

	public this(WindowProps windowProperties) : base(windowProperties)
	{
		gGameApp = this;
	}

	public ~this()
	{
		Images.Dispose();
		Sounds.Dispose();
	}

	public override void OnInit()
	{
		Images.Init();
		Sounds.Init();

		MainFont = new Font();
		//mFont.Load("zorque.ttf", 24);
		// mFont.Load("images/Main.fnt", 0);
		MainFont.Load("content/fonts/PressStart2P.ttf", 22);

		Engine.ChangeScene<GameScene>();
	}

	public override void OnUpdate()
	{
		/*
		// HandleInputs();
		*/
	}

	public override void OnDraw()
	{
	}

	/*
	public override void KeyDown(SDL.KeyboardEvent evt)
	{
		base.KeyDown(evt);
		if (evt.keysym.sym == .P)
			mPaused = !mPaused;
	}

	void HandleInputs()
	{
		float deltaX = 0;
		float deltaY = 0;
		float moveSpeed = Hero.MOVE_SPEED;
		if (IsKeyDown(.Left))
			deltaX -= moveSpeed;
		if (IsKeyDown(.Right))
			deltaX += moveSpeed;

		if (IsKeyDown(.Up))
			deltaY -= moveSpeed;
		if (IsKeyDown(.Down))
			deltaY += moveSpeed;

		if ((deltaX != 0) || (deltaY != 0))
		{
			mHero.X = Math.Clamp(mHero.X + deltaX, 10, mWidth - 10);
			mHero.Y = Math.Clamp(mHero.Y + deltaY, 10, mHeight - 10);
			mHasMoved = true;
		}
		mHero.mIsMovingX = deltaX != 0;

		if ((IsKeyDown(.Space)) && (mHero.mShootDelay == 0))
		{
			mHasShot = true;
			mHero.mShootDelay = Hero.SHOOT_DELAY;
			let bullet = new HeroBullet();
			bullet.X = mHero.X;
			bullet.Y = mHero.Y - 50;
			AddEntity(bullet);

			PlaySound(Sounds.RandomShot, GameApp.Random.NextFloat(0.085f, 0.1f));
		}

		if (mHasMoved && mHasShot)
		{
			m_shouldSpawnEnemies = true;
		}
	}
	*/

	// Sample tests
	[Test]
	public static void Test1()
	{
		Debug.WriteLine("Test 1");
	}

	[Test]
	public static void Test2()
	{
		Test.FatalError("Test 2 Failed");
	}
}
