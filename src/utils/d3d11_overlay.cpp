#include "d3d11_overlay.h"


namespace advsettings {

bool D3D11Overlay::Initialize( int width, int height )
{
    Shutdown();

    if ( width <= 0 || height <= 0 )
        return false;

    UINT flags = 0;
#ifdef _DEBUG
    flags |= D3D11_CREATE_DEVICE_DEBUG;
#endif
    // BGRA support allows the device to create surfaces SteamVR can consume,
    // and is harmless to set even though we use R8G8B8A8 here.
    flags |= D3D11_CREATE_DEVICE_BGRA_SUPPORT;

    // Try to create a hardware device first; fall back to WARP (software)
    // if no hardware device is available.
    D3D_FEATURE_LEVEL levels[] = {
        D3D_FEATURE_LEVEL_11_1,
        D3D_FEATURE_LEVEL_11_0,
        D3D_FEATURE_LEVEL_10_1,
        D3D_FEATURE_LEVEL_10_0,
    };
    D3D_FEATURE_LEVEL gotLevel = D3D_FEATURE_LEVEL_11_0;

    HRESULT hr = D3D11CreateDevice(
        nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, flags, levels,
        _countof( levels ), D3D11_SDK_VERSION, &m_device, &gotLevel,
        &m_context );
    if ( FAILED( hr ) )
    {
        // Fall back to WARP (software) if no hardware device is available.
        hr = D3D11CreateDevice(
            nullptr, D3D_DRIVER_TYPE_WARP, nullptr, flags, levels,
            _countof( levels ), D3D11_SDK_VERSION, &m_device, &gotLevel,
            &m_context );
        if ( FAILED( hr ) )
            return false;
    }

    m_width = width;
    m_height = height;

    D3D11_TEXTURE2D_DESC desc = {};
    desc.Width = static_cast<UINT>( width );
    desc.Height = static_cast<UINT>( height );
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    // R8G8B8A8 matches the RGBA byte order of the QImage input; SteamVR reads
    // overlay textures in this order (verified empirically: BGRA+swap produced
    // inverted colors).
    desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
    // Shared is required so the texture can be opened by SteamVR's compositor
    // which runs in a separate process.
    desc.MiscFlags = D3D11_RESOURCE_MISC_SHARED;

    hr = m_device->CreateTexture2D( &desc, nullptr, &m_texture );
    return SUCCEEDED( hr ) && m_texture;
}

void D3D11Overlay::Shutdown()
{
    m_texture.Reset();
    if ( m_context )
    {
        m_context->ClearState();
        m_context->Flush();
    }
    m_context.Reset();
    m_device.Reset();
    m_width = 0;
    m_height = 0;
}

ID3D11Texture2D* D3D11Overlay::UpdateTexture( const void* pixels, int width,
                                              int height )
{
    if ( !m_device || !m_context || !m_texture || !pixels )
        return nullptr;

    // If the incoming size does not match the allocated texture, (re)create it.
    if ( width != m_width || height != m_height )
    {
        m_texture.Reset();
        D3D11_TEXTURE2D_DESC desc = {};
        desc.Width = static_cast<UINT>( width );
        desc.Height = static_cast<UINT>( height );
        desc.MipLevels = 1;
        desc.ArraySize = 1;
        desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
        desc.SampleDesc.Count = 1;
        desc.Usage = D3D11_USAGE_DEFAULT;
        desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
        desc.MiscFlags = D3D11_RESOURCE_MISC_SHARED;
        if ( FAILED( m_device->CreateTexture2D( &desc, nullptr, &m_texture ) ) )
            return nullptr;
        m_width = width;
        m_height = height;
    }

    UINT rowPitch = static_cast<UINT>( width ) * 4;
    // The input is already in R,G,B,A byte order which matches the
    // R8G8B8A8 texture format, so upload directly.
    m_context->UpdateSubresource( m_texture.Get(), 0, nullptr, pixels,
                                  rowPitch, 0 );
    // Ensure the GPU has processed the upload before SteamVR reads the
    // texture from another process.
    m_context->Flush();

    return m_texture.Get();
}

} // namespace advsettings
