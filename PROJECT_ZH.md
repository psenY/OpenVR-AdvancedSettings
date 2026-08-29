# 项目说明：为 Intel Arc GPU 修复 OVR Advanced Settings 叠加层渲染

> 文档状态：框架（待补充细节）

---

## 一、为什么做这个项目（背景与动机）

### 1. 问题现象
- 在 **Intel Arc B580** 显卡 + PICO 4S 头显 + SteamVR 环境中，第三方 Overlay 工具 **OVR Advanced Settings（OVRAS）** 的设置面板在 SteamVR 中**渲染为空白 / 黑屏**。
- 该工具对 VR 用户很重要（手势重定位、边界调整、音量控制等），黑屏导致其核心功能完全不可用。

### 2. 根因定位
- OVRAS 原版使用 **Qt 5 + QQuickRenderControl** 将 QML 界面渲染到 OpenGL FBO，再以 `TextureType_OpenGL`（裸 GL 纹理）提交给 SteamVR compositor，底层依赖 `WGL_NV_DX_interop` 做跨 API 纹理共享。
- **Intel Arc 显卡驱动（含 32.0.101.8864 最新版）的 `WGL_NV_DX_interop` 实现存在 bug**，导致提交失败、面板黑屏。
- 证据：上游 GitHub issue #647（A770 同问题）、#620；维护者确认官方正计划迁移离开 OpenGL 渲染。

### 3. 为什么不用现有社区方案
- 社区临时方案 `IntelOpenGLVRFix` 通过**替换 `opengl32.dll` + `openvr_api.dll`** 代理实现。
- 但对同时使用 VRChat 等**带反作弊系统**的用户来说，替换系统 DLL 会**触发反作弊风险**，无法接受。
- 因此目标明确：**在不动系统 / 游戏进程模块的前提下修复渲染**。

---

## 二、解决方案（思路与演进）

### 1. 方案的取舍过程
| 方案 | 说明 | 结果 |
|---|---|---|
| 官方 qt6 分支 | 官方正在做的 Qt6 + QRhi + D3D11 迁移 | 半成品、界面质量差、CI 失败，放弃 |
| 社区 DLL 代理 | `IntelOpenGLVRFix` | 有效但有反作弊风险 |
| **自编译 + D3D11 提交（最终采用）** | 保留 Qt5 渲染，改纹理提交路径 | ✅ 零 DLL 替换，已验证 |

### 2. 最终技术方案（D3D11 拷贝提交）
- 保留原有 Qt5 + QQuickRenderControl 渲染管线；
- 渲染完成后通过 `QOpenGLFramebufferObject::toImage()` 将画面**读回 CPU**；
- 将像素上传到一块 **`D3D11_RESOURCE_MISC_SHARED` 共享纹理**；
- 以 `TextureType_DirectX`（`ID3D11Texture2D*`）提交给 SteamVR compositor；
- 彻底绕开有 bug 的 `WGL_NV_DX_interop` 路径。

### 3. 关键技术要点
- `DXGI_FORMAT_R8G8B8A8_UNORM`（RGBA 字节序，否则颜色红蓝反转）；
- 纹理必须带 `D3D11_RESOURCE_MISC_SHARED` 标志（跨进程共享给 compositor 必需）；
- 鼠标事件坐标做 Y 轴翻转（D3D11 纹理为 top-down），保证手柄点击方向正确；
- OpenGL 提交路径保留作为失败兜底。

---

## 三、改动范围

- **新增**：`src/utils/d3d11_overlay.h` / `.cpp`（D3D11Overlay 类）
- **修改**：
  - `src/overlaycontroller.cpp` / `.h`（渲染提交 + 鼠标坐标翻转 + Shutdown 清理）
  - `build_scripts/qt/sources.pri`（构建配置，链接 `d3d11` / `opengl32`）

---

## 四、构建与发布

### 1. 构建环境
- Qt 5.15.2（MSVC2019）+ VS2022（MSVC 14.5x）
- NSIS 3.12（安装器）、gh CLI（发布）

### 2. 发布产物（中英双版本）
| 文件 | 说明 |
|---|---|
| `AdvancedSettings-5.8.12-dev-Installer.exe` | 英文 NSIS 安装器 |
| `AdvancedSettings-5.8.12-dev-ZH-Installer.exe` | 中文 NSIS 安装器 |
| `OVR-AdvancedSettings-recenterfix-d3d11-win64.zip` | 英文便携包 |
| `OVR-AdvancedSettings-recenterfix-d3d11-zh-CN-win64.zip` | 中文便携包 |

---

## 五、验证结果

- SteamVR 中叠加层正常渲染，颜色 / 输入正确（Intel Arc B580 + PICO 4S 实机验证）；
- 桌面模式（`-desktopmode`）运行正常；
- 中文界面汉化集成完成；
- **无任何 DLL 替换 / 钩子，进程模块干净，反作弊风险最低**。

---

## 六、后续可做（TODO / 展望）

- [ ] 向上游提交修复建议 / 同步官方 Qt6 迁移进度
- [ ] 尝试去掉 `toImage()` CPU 读回，探索 GPU→GPU 直接拷贝（性能优化）
- [ ] 跟进 Intel 驱动更新，评估回归风险
- [ ] 适配更多显卡 / 驱动组合的回归测试
