#pragma once

#include <d3d11.h>
#include <wrl/client.h>
#include <memory>

namespace advsettings {

// D3D11 overlay texture helper.
//
// Replaces the WGL_NV_DX_interop path used by the original code, which is
// broken on Intel Arc drivers. The OpenGL framebuffer content is copied to a
// D3D11 shared texture and submitted to SteamVR as TextureType_DirectX.
class D3D11Overlay
{
public:
    bool Initialize( int width, int height );
    void Shutdown();

    // Uploads raw RGBA8 pixel data into the D3D11 texture and returns the
    // ID3D11Texture2D* to submit to SteamVR. Returns nullptr if not ready.
    ID3D11Texture2D* UpdateTexture( const void* pixels, int width, int height );

    bool IsReady() const { return m_device && m_texture; }
    int Width() const { return m_width; }
    int Height() const { return m_height; }

private:
    Microsoft::WRL::ComPtr<ID3D11Device> m_device;
    Microsoft::WRL::ComPtr<ID3D11DeviceContext> m_context;
    Microsoft::WRL::ComPtr<ID3D11Texture2D> m_texture;
    int m_width = 0;
    int m_height = 0;
};

} // namespace advsettings
