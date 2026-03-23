<#import "/layout.ftlh" as l>
<@l.page_layout title="供货农家名册 (一览与检索)" current_page="farmers">

    <!-- 顶部检索区 -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <i class="bi bi-search text-primary me-2 fs-4"></i>
                <h5 class="m-0 fw-bold text-dark">多条件检索</h5>
            </div>
            <!-- 跳转到独立的农家新增表单页面 -->
            <a href="/farmers/add" class="btn btn-primary btn-lg shadow-sm rounded-pill px-4 fw-bold">
                <i class="bi bi-plus-lg me-2"></i>新增供货农家
            </a>
        </div>
        <div class="card-body p-4 bg-light bg-opacity-50">
            <!-- 检索表单：使用 GET 请求，将条件挂载到 URL 上 -->
            <form action="/farmers" method="get" class="row g-3 align-items-end">
                <!-- 隐藏域保留当前的排序状态，使得检索时不打乱用户之前的排序偏好 -->
                <input type="hidden" name="sort" value="${sortColumn!'id'}">
                <input type="hidden" name="dir" value="${sortDir!'desc'}">

                <div class="col-md-5">
                    <label class="form-label fw-bold text-muted mb-2 fs-6">农家名 / 屋号模糊匹配</label>
                    <div class="input-group input-group-lg shadow-sm">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-shop text-muted"></i></span>
                        <input type="text" name="searchName" value="${searchName!''}" class="form-control border-start-0" placeholder="输入名称关键字...">
                    </div>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold text-muted mb-2 fs-6">信任评级精准筛选</label>
                    <select name="searchRank" class="form-select form-select-lg shadow-sm">
                        <option value="">全部评级</option>
                        <option value="A" <#if (searchRank!'') == 'A'>selected</#if>>🌟 A级 (核心合作)</option>
                        <option value="B" <#if (searchRank!'') == 'B'>selected</#if>>⭐ B级 (普通合作)</option>
                        <option value="C" <#if (searchRank!'') == 'C'>selected</#if>>⚠️ C级 (临时散单)</option>
                    </select>
                </div>

                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-dark btn-lg w-100 shadow-sm fw-bold"><i class="bi bi-funnel me-2"></i>执行检索</button>
                    <a href="/farmers" class="btn btn-outline-secondary btn-lg shadow-sm px-4" title="清空检索条件"><i class="bi bi-arrow-counterclockwise"></i></a>
                </div>
            </form>
        </div>
    </div>

    <!-- 下方：全宽数据列表区 (带分页与动态排序) -->
    <div class="card border-0 shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center py-4 bg-white">
            <div class="d-flex align-items-center">
                <i class="bi bi-list-columns-reverse text-muted me-3 fs-3"></i>
                <h5 class="m-0 fw-bold">农家数据一览</h5>
            </div>
            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-4 py-2 fs-6">检索命中 ${total!'0'} 条数据</span>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr class="bg-light">
                        <!-- 动态排序辅助宏：提取公共的检索参数，防止在点击表头排序时丢失检索条件 -->
                        <#assign baseParams = "&searchName=${searchName!''}&searchRank=${searchRank!''}">

                        <th class="ps-4 py-3" style="width: 15%;">
                            <!-- 三元运算：如果当前就是ID升序，下一次点击就变为降序，否则默认升序 -->
                            <#assign nextDirId = (sortColumn == 'id' && sortDir == 'asc')?then('desc', 'asc')>
                            <a href="/farmers?page=1&sort=id&dir=${nextDirId}${baseParams}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center user-select-none" style="font-size: 1.1rem;">
                                数据ID
                                <#if sortColumn == 'id'>
                                    <i class="bi bi-sort-numeric-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                <#else>
                                    <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                </#if>
                            </a>
                        </th>

                        <th class="py-3" style="width: 30%;">
                            <#assign nextDirName = (sortColumn == 'name' && sortDir == 'asc')?then('desc', 'asc')>
                            <a href="/farmers?page=1&sort=name&dir=${nextDirName}${baseParams}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center user-select-none" style="font-size: 1.1rem;">
                                农家/屋号名称
                                <#if sortColumn == 'name'>
                                    <i class="bi bi-sort-alpha-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                <#else>
                                    <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                </#if>
                            </a>
                        </th>

                        <th class="py-3" style="width: 25%;">
                            <#assign nextDirPref = (sortColumn == 'prefecture' && sortDir == 'asc')?then('desc', 'asc')>
                            <a href="/farmers?page=1&sort=prefecture&dir=${nextDirPref}${baseParams}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center user-select-none" style="font-size: 1.1rem;">
                                地理位置
                                <#if sortColumn == 'prefecture'>
                                    <i class="bi bi-sort-alpha-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                <#else>
                                    <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                </#if>
                            </a>
                        </th>

                        <th class="text-center py-3" style="width: 15%;">
                            <#assign nextDirRank = (sortColumn == 'rank' && sortDir == 'asc')?then('desc', 'asc')>
                            <a href="/farmers?page=1&sort=rank&dir=${nextDirRank}${baseParams}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center justify-content-center user-select-none" style="font-size: 1.1rem;">
                                评级
                                <#if sortColumn == 'rank'>
                                    <i class="bi bi-sort-alpha-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                <#else>
                                    <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                </#if>
                            </a>
                        </th>

                        <th class="text-center pe-4 text-dark fw-bold py-3" style="font-size: 1.1rem; width: 15%;">操作管理</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list list![] as item>
                        <tr>
                            <td class="ps-4 py-3"><span class="badge-soft fs-6 px-3 py-2 text-monospace">#${item.id}</span></td>
                            <td class="py-3">
                                <div class="d-flex align-items-center">
                                    <div class="bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 42px; height: 42px;">
                                        <i class="bi bi-person text-success fs-5"></i>
                                    </div>
                                    <span class="fw-bold fs-5" style="color: #0f172a;">${item.name}</span>
                                </div>
                            </td>
                            <td class="py-3">
                                <span class="text-muted fw-medium fs-5"><i class="bi bi-geo-alt me-1 text-primary opacity-75"></i>${item.prefecture}${item.city}</span>
                            </td>
                            <td class="text-center py-3">
                                <#if item.rank == 'A'>
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-4 py-2 fs-6">A 级</span>
                                <#elseif item.rank == 'B'>
                                    <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-4 py-2 fs-6">B 级</span>
                                <#else>
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-4 py-2 fs-6">C 级</span>
                                </#if>
                            </td>
                            <td class="text-center pe-4 py-3">
                                <div class="d-flex justify-content-center gap-3">
                                    <!-- 修改按钮：跳转到独立的表单页，且将当前所有的检索、分页和排序状态塞入 URL -->
                                    <a href="/farmers/edit/${item.id}?page=${currentPage!'1'}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}${baseParams}" class="btn btn-outline-primary border-0 px-3 py-2" title="修改"><i class="bi bi-pencil-square fs-4"></i></a>
                                    <form action="/farmers/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('确定要物理删除该农家吗？此操作不可逆！');">
                                        <button type="submit" class="btn btn-outline-danger border-0 px-3 py-2" title="删除"><i class="bi bi-trash3 fs-4"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </#list>
                    <#if (!list??) || (list?size == 0)>
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <div class="text-muted mb-3"><i class="bi bi-search opacity-25" style="font-size: 5rem;"></i></div>
                                <div class="text-muted fw-medium fs-4">没有检索到任何符合条件的农家数据</div>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <!-- 底部大尺寸分页控件 (Pagination) -->
            <#if totalPages?? && totalPages &gt; 1>
                <div class="d-flex justify-content-center py-4 bg-light bg-opacity-50 border-top">
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-lg m-0 shadow-sm">
                            <!-- 上一页 -->
                            <li class="page-item <#if currentPage == 1>disabled</#if>">
                                <a class="page-link px-4 fw-bold" href="/farmers?page=${currentPage - 1}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}${baseParams}">
                                    <i class="bi bi-chevron-left me-1"></i> 上一页
                                </a>
                            </li>

                            <!-- 动态页码 -->
                            <#list 1..totalPages as p>
                                <li class="page-item <#if p == currentPage>active</#if>">
                                    <a class="page-link px-4 fw-bold" href="/farmers?page=${p}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}${baseParams}">${p}</a>
                                </li>
                            </#list>

                            <!-- 下一页 -->
                            <li class="page-item <#if currentPage == totalPages>disabled</#if>">
                                <a class="page-link px-4 fw-bold" href="/farmers?page=${currentPage + 1}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}${baseParams}">
                                    下一页 <i class="bi bi-chevron-right ms-1"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </#if>

        </div>
    </div>
</@l.page_layout>