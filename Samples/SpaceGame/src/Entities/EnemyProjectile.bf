using SDL2;

namespace SpaceGame;

class EnemyProjectile : Entity
{
	public override void Update()
	{
		if (gGameApp.mHero.mInvincibleDelay > 0)
			return;

		SDL.Rect heroBoundingBox = .(-30, -30, 60, 60);
		if (heroBoundingBox.Contains((.)(X - gGameApp.mHero.X), (.)(Y - gGameApp.mHero.Y)))
		{
			gGameApp.ExplodeAt(X, Y, 0.25f, 1.25f);
			gApp.PlaySound(Sounds.Explode, 0.5f, 1.5f);
			gGameApp.mHero.mHealth--;
		}
	}
}
