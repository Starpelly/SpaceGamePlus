using System;
using SDL2;
namespace SpaceGameEngine.Graphics;

using internal SpaceGameEngine.Graphics.Renderer;

class Image
{
	public SDL.Surface* mSurface;
	public SDL.Texture* mTexture;
	public int32 mWidth;
	public int32 mHeight;

	public ~this()
	{
		if (mTexture != null)
			SDL.DestroyTexture(mTexture);
		if (mSurface != null)
			SDL.FreeSurface(mSurface);
	}

	public Result<void> Load(StringView fileName)
	{
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

		return .Ok;
	}
}