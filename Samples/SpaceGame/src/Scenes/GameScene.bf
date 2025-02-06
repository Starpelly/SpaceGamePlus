using SpaceGameEngine;

namespace SpaceGame;

public class GameScene : Scene
{
	public static Self Instance { get; private set; }

	public Hero mHero;
	public int mScore;
	public float mDifficulty;

	private int mEmptyUpdates;
	private bool mHasMoved;
	private bool mHasShot;
	private bool mPaused;
	private bool m_shouldSpawnEnemies = false;

	private Background m_background = new .() ~ delete _;

	public this()
	{
		Instance = this;
	}

	public override void OnLoad()
	{
		mHero = new Hero();
		AddEntity(mHero);

		mHero.Y = 650;
		mHero.X = 512;

		m_background.Init();
	}

	public override void OnUnload()
	{
	}

	public override void OnUpdate()
	{
		if (mPaused)
			return;

		if (m_shouldSpawnEnemies)
		{
			SpawnEnemies();

			// Make the game harder over time
			mDifficulty += 0.0001f;
		}

		// Scroll the background
		m_background.Update();
	}

	public override void OnDraw()
	{
		m_background.Draw();

		/*
		Drawing.DrawString(m_Font, 8, 4, scope String()..AppendF("SCORE: {}", mScore), .(240, 240, 240, 255));

		if (!m_shouldSpawnEnemies)
			Drawing.DrawString(m_Font, Engine.MainWindow.Width / 2, 200, "Use cursor keys to move and Space to fire", .(240, 240, 240, 255), true);
		*/
	}

	public void ExplodeAt(float x, float y, float sizeScale, float speedScale)
	{
		let explosion = new Explosion();
		explosion.mSizeScale = sizeScale;
		explosion.mSpeedScale = speedScale;
		explosion.X = x;
		explosion.Y = y;
		AddEntity(explosion);
	}

	void SpawnSkirmisher()
	{
		let spawner = new EnemySkirmisher.Spawner();
		spawner.mLeftSide = Engine.Random.NextDouble() < 0.5;
		spawner.Y = ((float)Engine.Random.NextDouble() * 0.5f + 0.25f) * Engine.MainWindow.Height;
		AddEntity(spawner);
	}

	void SpawnGoliath()
	{
		let enemy = new EnemyGolaith();
		enemy.X = ((float)Engine.Random.NextDouble() * 0.5f + 0.25f) * Engine.MainWindow.Width;
		enemy.Y = -300;
		AddEntity(enemy);
	}

	void SpawnEnemies()
	{
		bool hasEnemies = false;
		for (var entity in Entities)
		{
			if (entity is Enemy)
			{
				hasEnemies = true;
			}
		}
		if (hasEnemies)
			mEmptyUpdates = 0;
		else
			mEmptyUpdates++;

		float spawnScale = 0.4f + (mEmptyUpdates * 0.025f);
		spawnScale += mDifficulty;

		if (Engine.Random.NextDouble() < 0.002f * spawnScale)
			SpawnSkirmisher();

		if (Engine.Random.NextDouble() < 0.0005f * spawnScale)
			SpawnGoliath();
	}
}