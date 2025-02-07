using System;
namespace SpaceGameEngine.Graphics;

#if ENGINE_SDL2
using SDL2;
#elif ENGINE_RAYLIB
using RaylibBeef;
#endif

using internal SpaceGameEngine.Graphics.Renderer;

public class Image
{
	public int32 mWidth;
	public int32 mHeight;

#if ENGINE_SDL2
	public SDL.Surface* mSurface;
	public SDL.Texture* mTexture;
#elif ENGINE_RAYLIB
	private RaylibBeef.Image m_Image;

	private RaylibBeef.Texture2D m_Texture;
	public RaylibBeef.Texture2D Texture => m_Texture;
#endif

	public ~this()
	{
#if ENGINE_SDL2
		if (mTexture != null)
			SDL.DestroyTexture(mTexture);
		if (mSurface != null)
			SDL.FreeSurface(mSurface);
#elif ENGINE_RAYLIB
		Raylib.UnloadTexture(m_Texture);
#endif
	}

	public Result<void> Load(StringView fileName)
	{
#if ENGINE_SDL2
		let origSurface = SDLImage.Load(fileName.ToScopeCStr!());
		if (origSurface == null)
			return .Err;

		mSurface = origSurface;

		SDL.Rect rect = .(0, 0, mSurface.w, mSurface.h);
		mTexture = SDL.CreateTexture(Engine.Renderer.SDLRenderer, SDL.PIXELFORMAT_ABGR8888, (.)SDL.TextureAccess.Static, mSurface.w, mSurface.h);

		uint32* data = new uint32[mSurface.w*mSurface.h]*;
		defer delete data;

		int res = SDL.ConvertPixels(mSurface.w, mSurface.h, mSurface.format.format, mSurface.pixels, mSurface.pitch, SDL.PIXELFORMAT_ABGR8888, data, mSurface.w * 4);
		if (res == -1)
		{
			for (int y = 0; y < mSurface.h; y++)
				Internal.MemCpy(data + y*mSurface.w, (uint8*)mSurface.pixels + y*mSurface.pitch, mSurface.w*4);
		}

		SDL.UpdateTexture(mTexture, &rect, data, mSurface.w * 4);
		SDL.SetTextureBlendMode(mTexture, .Blend);

		mWidth = mSurface.w;
		mHeight = mSurface.h;
#elif ENGINE_RAYLIB
		m_Texture = Raylib.LoadTexture(fileName.Ptr);

		mWidth = m_Texture.width;
		mHeight = m_Texture.height;
#endif

		return .Ok;
	}
}