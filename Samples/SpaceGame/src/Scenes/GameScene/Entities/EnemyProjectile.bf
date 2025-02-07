using SpaceGameEngine;
using SpaceGameEngine.Math;

namespace SpaceGame;

class EnemyProjectile : Entity
{
	public override void Update()
	{
		if (GameScene.Instance.mHero.mInvincibleDelay > 0)
			return;

		let heroBoundingBox = Rect(-30, -30, 60, 60);
		if (heroBoundingBox.Contains((.)(X - GameScene.Instance.mHero.X), (.)(Y - GameScene.Instance.mHero.Y)))
		{
			GameScene.Instance.ExplodeAt(X, Y, 0.25f, 1.25f);
			Engine.PlaySound(Sounds.Explode, 0.5f, 1.5f);
			GameScene.Instance.mHero.mHealth--;
		}
	}
}
