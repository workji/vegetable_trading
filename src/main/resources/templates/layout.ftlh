<#macro page_layout title current_page>
    <!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${title} | 智能青果交易中枢</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- 引入具有几何科技感的无衬线字体 Inter -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Noto+Sans+JP:wght@400;500;700&display=swap" rel="stylesheet">

        <style>
            /* =========================================================
               现代科技 SaaS 仪表盘全局主题变量 (Modern Tech Theme)
               ========================================================= */
            :root {
                /* 极客深邃蓝灰 */
                --bg-sidebar: #0f172a;
                --bg-sidebar-hover: rgba(255, 255, 255, 0.05);
                /* 浅色呼吸背景 */
                --bg-body: #f8fafc;
                /* 科技蓝到未来青的流光渐变 */
                --gradient-primary: linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%);
                --gradient-hover: linear-gradient(135deg, #2563eb 0%, #0891b2 100%);
                /* 柔和阴影 */
                --shadow-card: 0 10px 25px -5px rgba(15, 23, 42, 0.05);
                --shadow-float: 0 20px 25px -5px rgba(59, 130, 246, 0.15);
                /* 边框与文字 */
                --border-soft: #e2e8f0;
                --text-main: #334155;
                --text-muted: #64748b;
            }

            body {
                font-family: 'Inter', 'Noto Sans JP', sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                -webkit-font-smoothing: antialiased;
            }

            /* --- 侧边栏 (Sidebar) 极简科技风 --- */
            .sidebar {
                width: 260px;
                height: 100vh;
                position: fixed;
                top: 0;
                left: 0;
                background-color: var(--bg-sidebar);
                color: #f1f5f9;
                z-index: 1000;
                border-right: 1px solid rgba(255,255,255,0.05);
                box-shadow: 4px 0 20px rgba(0,0,0,0.05);
            }

            .sidebar-header {
                padding: 24px 20px;
                text-align: center;
                background: linear-gradient(180deg, rgba(255,255,255,0.02) 0%, transparent 100%);
            }

            .sidebar-logo {
                font-size: 2.2rem;
                background: var(--gradient-primary);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                filter: drop-shadow(0 0 8px rgba(6, 182, 212, 0.3));
            }

            .sidebar .nav-link {
                color: #94a3b8;
                padding: 12px 20px;
                margin: 4px 12px;
                border-radius: 8px;
                font-weight: 500;
                font-size: 0.95rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border-left: 3px solid transparent;
            }

            .sidebar .nav-link:hover {
                color: #ffffff;
                background-color: var(--bg-sidebar-hover);
                transform: translateX(4px);
            }

            .sidebar .nav-link.active {
                color: #06b6d4;
                /* 激活态：左侧边框发光 + 半透明渐变背景 */
                background: linear-gradient(90deg, rgba(6, 182, 212, 0.1) 0%, transparent 100%);
                border-left: 3px solid #06b6d4;
                box-shadow: inset 2px 0 10px rgba(6, 182, 212, 0.05);
            }
            .sidebar .nav-link i { margin-right: 12px; font-size: 1.1rem; }

            /* --- 主内容区 (Main Content) --- */
            .main-content {
                margin-left: 260px;
                padding: 32px 40px;
                min-height: 100vh;
            }

            /* --- 卡片 (Cards) 悬浮微毛玻璃 --- */
            .card {
                border: 1px solid var(--border-soft);
                border-radius: 16px;
                box-shadow: var(--shadow-card);
                background: rgba(255, 255, 255, 0.85);
                backdrop-filter: blur(12px);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .card:hover { box-shadow: var(--shadow-float); }
            .card-header {
                background-color: transparent;
                border-bottom: 1px solid var(--border-soft);
                padding: 1.25rem 1.5rem;
            }

            /* --- 控件与表单 (Forms) --- */
            .form-control, .form-select {
                border-radius: 10px;
                border: 1px solid #cbd5e1;
                background-color: #f8fafc;
                padding: 0.65rem 1rem;
                font-size: 0.95rem;
                transition: all 0.2s;
            }
            .form-control:focus, .form-select:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
                background-color: #ffffff;
            }

            /* --- 流光按钮 (Gradient Buttons) --- */
            .btn-gradient {
                background: var(--gradient-primary);
                color: white;
                border: none;
                border-radius: 10px;
                font-weight: 600;
                padding: 0.65rem 1.5rem;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
            }
            .btn-gradient:hover {
                background: var(--gradient-hover);
                transform: translateY(-2px);
                box-shadow: 0 8px 15px rgba(6, 182, 212, 0.3);
                color: white;
            }

            /* --- 表格 (Tables) 高级感排版 --- */
            .table { --bs-table-bg: transparent; margin-bottom: 0; }
            .table th {
                border-bottom-width: 1px;
                color: var(--text-muted);
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                padding: 1rem;
            }
            .table td { vertical-align: middle; padding: 1rem; color: var(--text-main); font-weight: 500; }
            .table-hover tbody tr:hover { background-color: rgba(241, 245, 249, 0.6); }

            /* --- 标签 (Badges) --- */
            .badge-soft {
                background-color: #f1f5f9;
                color: #475569;
                font-weight: 600;
                padding: 0.5em 0.8em;
                border-radius: 6px;
                border: 1px solid var(--border-soft);
            }
        </style>
    </head>
    <body>

    <!-- 左侧导航栏 -->
    <div class="sidebar">
        <div class="sidebar-header">
            <i class="bi bi-hexagon-half sidebar-logo d-block mb-2"></i>
            <h5 class="fw-bold m-0 text-white" style="letter-spacing: 1px;">青果智能中枢</h5>
            <small style="color: #64748b; font-size: 0.7rem; font-weight: 600;">V2.0 AI-DRIVEN</small>
        </div>

        <div class="px-4 pt-4 pb-2 text-uppercase" style="font-size:0.7rem; color: #475569; font-weight: 700; letter-spacing:1px;">交易管理 (Trade)</div>
        <ul class="nav flex-column mb-2">
            <li class="nav-item">
                <a href="/arrivals" class="nav-link <#if current_page == 'arrivals'>active</#if>">
                    <i class="bi bi-box-arrow-in-right"></i><span>入库管理 (仕入)</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="/sales" class="nav-link <#if current_page == 'sales'>active</#if>">
                    <i class="bi bi-send-check"></i><span>出库管理 (販売)</span>
                </a>
            </li>
        </ul>

        <div class="px-4 pt-4 pb-2 text-uppercase" style="font-size:0.7rem; color: #475569; font-weight: 700; letter-spacing:1px;">基础名册 (Master)</div>
        <ul class="nav flex-column mb-2">
            <li class="nav-item">
                <a href="/farmers" class="nav-link <#if current_page == 'farmers'>active</#if>">
                    <i class="bi bi-person-bounding-box"></i><span>供货农家 (農家)</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="/customers" class="nav-link <#if current_page == 'customers'>active</#if>">
                    <i class="bi bi-buildings"></i><span>零售超市 (顧客)</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="/products" class="nav-link <#if current_page == 'products'>active</#if>">
                    <i class="bi bi-upc-scan"></i><span>蔬菜品目 (品目)</span>
                </a>
            </li>
        </ul>

        <div class="px-4 pt-4 pb-2 text-uppercase" style="font-size:0.7rem; color: #475569; font-weight: 700; letter-spacing:1px;">商业智能 (BI)</div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a href="/forecasts" class="nav-link <#if current_page == 'forecasts'>active</#if>">
                    <i class="bi bi-activity"></i><span>供需预测 (予測)</span>
                </a>
            </li>
        </ul>
    </div>

    <!-- 右侧主内容区 -->
    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h3 fw-bold text-dark m-0" style="letter-spacing: -0.5px;">${title}</h2>
                <p class="text-muted small mt-1 mb-0">高效管理您的基础数据资产</p>
            </div>
            <div class="d-flex align-items-center bg-white px-3 py-2 rounded-pill shadow-sm border" style="border-color: var(--border-soft) !important;">
                <div class="spinner-grow spinner-grow-sm text-info me-2" role="status" style="width: 0.5rem; height: 0.5rem;"></div>
                <span class="text-muted fw-semibold" style="font-size: 0.85rem;">实时在线</span>
                <div class="vr mx-3 text-muted"></div>
                <span class="text-muted fw-semibold" style="font-size: 0.85rem;"><i class="bi bi-clock me-1"></i>${.now?string('yyyy-MM-dd')}</span>
            </div>
        </div>

        <!-- 嵌套注入各个页面的具体内容 -->
        <#nested>

        <footer class="text-center text-muted mt-5 pt-4" style="font-size:0.8rem;">
            <div class="d-inline-flex align-items-center gap-2">
                <i class="bi bi-code-slash"></i>
                <span>&copy; 2026 Intelligent Trading Platform. All rights reserved.</span>
            </div>
        </footer>
    </main>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
</#macro>