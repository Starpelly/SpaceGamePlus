using System;
using SDL2;
using System.Collections;
using System.Diagnostics;

namespace SpaceGame;

static
{
	public static GameApp gGameApp;
}

class GameApp : SDLApp
{
	public List<Entity> mEntities = new List<Entity>() ~ DeleteContainerAndItems!(_);
	public Hero mHero;
	public int mScore;
	public float mDifficulty;
	public Random mRand = new Random() ~ delete _;
#if !NOTTF
	Font mFont ~ delete _;
#endif
	int mEmptyUpdates;
	bool mHasMoved;
	bool mHasShot;
	bool mPaused;
	bool m_shouldSpawnEnemies = false;

	private Camera m_camera = new .() ~ delete _;
	private Background m_background = new .() ~ delete _;

	public static Random Random = new .() ~ delete _;

	public this()
	{
		gGameApp = this;

		mHero = new Hero();
		AddEntity(mHero);

		mHero.Y = 650;
		mHero.X = 512;
	}

	public ~this()
	{
		Images.Dispose();
		Sounds.Dispose();
	}

	public override void Init()
	{
		base.Init();
		Images.Init();
		if (mHasAudio)
		{
			Sounds.Init();
		}

		mFont = new Font();
		//mFont.Load("zorque.ttf", 24);
		// mFont.Load("images/Main.fnt", 0);
		mFont.Load("content/fonts/PressStart2P.ttf", 22);

		m_background.Init();
	}

	public void DrawString(float x, float y, String str, SDL.Color color, bool centerX = false)
	{
		DrawString(mFont, x, y, str, color, centerX);
	}

	public override void Update()
	{
		if (mPaused)
			return;

		base.Update();

		HandleInputs();

		if (m_shouldSpawnEnemies)
		{
			SpawnEnemies();

			// Make the game harder over time
			mDifficulty += 0.0001f;
		}

		// Scroll the background
		m_background.Update();

		for (let entity in mEntities)
		{
			entity.UpdateCount++;
			entity.Update();
			if (entity.IsDeleting)
			{
				// '@entity' refers to the enumerator itself
	            @entity.Remove();
				delete entity;
			}
		}
	}

	public override void Draw()
	{
		m_background.Draw();

		for (var entity in mEntities)
			entity.Draw();

		DrawString(8, 4, scope String()..AppendF("SCORE: {}", mScore), .(240, 240, 240, 255));

		if (!m_shouldSpawnEnemies)
			DrawString(mWidth / 2, 200, "Use cursor keys to move and Space to fire", .(240, 240, 240, 255), true);

	}

	public void ExplodeAt(float x, float y, float sizeScale, float speedScale)
	{
		let explosion = new Explosion();
		explosion.mSizeScale = sizeScale;
		explosion.mSpeedScale = speedScale;
		explosion.X = x;
		explosion.Y = y;
		mEntities.Add(explosion);
	}

	public void AddEntity(Entity entity)
	{
		mEntities.Add(entity);
	}

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

	void SpawnSkirmisher()
	{
		let spawner = new EnemySkirmisher.Spawner();
		spawner.mLeftSide = mRand.NextDouble() < 0.5;
		spawner.Y = ((float)mRand.NextDouble() * 0.5f + 0.25f) * mHeight;
		AddEntity(spawner);
	}

	void SpawnGoliath()
	{
		let enemy = new EnemyGolaith();
		enemy.X = ((float)mRand.NextDouble() * 0.5f + 0.25f) * mWidth;
		enemy.Y = -300;
		AddEntity(enemy);
	}

	void SpawnEnemies()
	{
		bool hasEnemies = false;
		for (var entity in mEntities)
			if (entity is Enemy)
				hasEnemies = true;
		if (hasEnemies)
			mEmptyUpdates = 0;
		else
			mEmptyUpdates++;

		float spawnScale = 0.4f + (mEmptyUpdates * 0.025f);
		spawnScale += mDifficulty;

		if (mRand.NextDouble() < 0.002f * spawnScale)
			SpawnSkirmisher();

		if (mRand.NextDouble() < 0.0005f * spawnScale)
			SpawnGoliath();
	}

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
