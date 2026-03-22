<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>系统发生错误</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">
<div class="text-center">
    <i class="bi bi-exclamation-triangle text-danger" style="font-size: 5rem;"></i>
    <h1 class="mt-3 fw-bold">System Error</h1>
    <p class="text-muted lead mt-2">抱歉，系统遇到了无法处理的异常状况。</p>
    <div class="alert alert-danger d-inline-block text-start mt-3" style="max-width: 600px; word-wrap: break-word;">
        ${errorMessage!'未知系统错误'}
    </div>
    <div class="mt-4">
        <a href="/" class="btn btn-primary"><i class="bi bi-house-door me-2"></i>返回首页</a>
        <button onclick="history.back()" class="btn btn-outline-secondary ms-2"><i class="bi bi-arrow-left me-2"></i>返回上一页</button>
    </div>
</div>
</body>
</html>