using System;
using System.Collections;

using SpaceGameEngine;
using SpaceGameEngine.Graphics;

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
			let particleScale = Engine.Random.NextFloat(0.35f, 1.0f);
			let particleSpeed = Math.Abs(-particleScale);
			let newParticle = StarParticle()
			{
				X = Engine.Random.NextFloat(0, SpaceGameEngine.Engine.MainWindow.Width),
				Y = Engine.Random.NextFloat(0, SpaceGameEngine.Engine.MainWindow.Height),

				Scale = particleScale,
				Speed = particleSpeed,

				SpriteAlpha = Engine.Random.NextFloat(0.0f, 1.0f)
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

			if (particle.Y > SpaceGameEngine.Engine.MainWindow.Height)
			{
				particle.Y = -(Images.sStar.mHeight * particle.Scale);
			}
		}
	}

	public void Draw()
	{
		Drawing.DrawImage(Images.sSpaceImage, 0, mBkgPos - 1024);
		Drawing.DrawImage(Images.sSpaceImage, 0, mBkgPos);

		for (let particle in m_particles)
		{
			// Drawing.DrawImageEx(Images.sStar, particle.X, particle.Y, particle.Scale, particle.Scale, (uint8)(particle.SpriteAlpha * 255));
		}
	}
}