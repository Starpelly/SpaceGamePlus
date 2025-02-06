using System;
using System.Collections;

namespace SpaceGame;

public class Background
{
	public const float SCROLL_SPEED = 0.6f;

	private float mBkgPos;

	private List<StarParticle> m_particles = new .() ~ delete _;

	public struct StarParticle
	{
		public float X;
		public float Y;

		public float Scale = 1.0f;
		public float Speed = 0.0f;

		public float SpriteAlpha = 0.5f;
	}

	public void Init()
	{
		for (let i < 150)
		{
			let particleScale = GameApp.Random.NextFloat(0.35f, 1.0f);
			let particleSpeed = Math.Abs(-particleScale);
			let newParticle = StarParticle()
			{
				X = GameApp.Random.NextFloat(0, gGameApp.mWidth),
				Y = GameApp.Random.NextFloat(0, gGameApp.mHeight),

				Scale = particleScale,
				Speed = particleSpeed,

				SpriteAlpha = GameApp.Random.NextFloat(0.0f, 1.0f)
			};
			m_particles.Add(newParticle);
		}
	}

	public void Update()
	{
		mBkgPos += SCROLL_SPEED;
		if (mBkgPos > 1024)
			mBkgPos -= 1024;

		for (var particle in ref m_particles)
		{
			particle.Y += particle.Speed;

			if (particle.Y > gGameApp.mHeight)
			{
				particle.Y = -(Images.sStar.mHeight * particle.Scale);
			}
		}
	}

	public void Draw()
	{
		// gGameApp.Draw(Images.sSpaceImage, 0, mBkgPos - 1024);
		// gGameApp.Draw(Images.sSpaceImage, 0, mBkgPos);

		for (let particle in m_particles)
		{
			gGameApp.DrawEx(Images.sStar, particle.X, particle.Y, particle.Scale, particle.Scale, (uint8)(particle.SpriteAlpha * 255));
		}
	}
}