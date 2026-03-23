<#import "/layout.ftlh" as l>
<@l.page_layout title="顾客管理 (零售商/超市名册)" current_page="customers">

    <div class="row g-4">
        <!-- 上方：表单区 (全宽 12 列) -->
        <div class="col-12">
            <div class="card border-0 shadow-sm">
                <div class="card-header d-flex align-items-center py-3">
                    <div class="bg-info bg-opacity-10 text-info rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                        <i class="bi bi-building-add fs-3"></i>
                    </div>
                    <h5 class="m-0 fw-bold"><#if customerForm.id??>编辑顾客 / 超市<#else>新增顾客 / 超市</#if></h5>
                </div>
                <div class="card-body p-4">
                    <form action="<#if customerForm.id??>/customers/edit/${customerForm.id}<#else>/customers</#if>" method="post">
                        <#if customerForm.id??>
                            <input type="hidden" name="id" value="${customerForm.id}">
                            <!-- 隐藏域：将当前的分页和排序状态随着POST一起发给后端，保证更新后能精准重定向回来 -->
                            <input type="hidden" name="page" value="${currentPage!'1'}">
                            <input type="hidden" name="sort" value="${sortColumn!'id'}">
                            <input type="hidden" name="dir" value="${sortDir!'desc'}">
                        </#if>

                        <div class="row">
                            <!-- 第一列：商超名称 -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">商超名称 (企业名) <span class="text-danger">*</span></label>
                                <@spring.bind "customerForm.name" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-shop-window fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="如：XX生鲜连锁">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>

                            <!-- 第二列：详细地址 -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">详细地址 (店铺号)</label>
                                <@spring.bind "customerForm.addressLine" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-signpost-2 fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0" placeholder="详细地址可留空">
                                </div>
                            </div>

                            <!-- 第三列：都道府县 -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">都道府县 <span class="text-danger">*</span></label>
                                <@spring.bind "customerForm.prefecture" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-map fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="如：埼玉県">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>

                            <!-- 第四列：市区町村 -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">市区町村 <span class="text-danger">*</span></label>
                                <@spring.bind "customerForm.city" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-pin-map fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="如：川口市">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                        </div>

                        <div class="row mt-2">
                            <div class="col-md-8 col-lg-6 mx-auto">
                                <button type="submit" class="btn-gradient btn-lg w-100 py-3 fs-5 shadow"><i class="bi bi-cloud-arrow-up me-2"></i><#if customerForm.id??>保存修改并更新<#else>确认保存至数据库</#if></button>
                                <#if customerForm.id??>
                                    <!-- 取消编辑时，带上原有的分页参数，回到原来的列表页 -->
                                    <a href="/customers?page=${currentPage!'1'}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}" class="btn btn-light btn-lg border w-100 mt-3 fw-bold text-muted shadow-sm fs-5 py-3">取消编辑，返回</a>
                                </#if>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- 下方：数据列表区 (带有分页和排序功能) -->
        <div class="col-12 mt-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center py-4">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-database text-muted me-3 fs-3"></i>
                        <h5 class="m-0 fw-bold">合作商超名册</h5>
                    </div>
                    <span class="badge bg-info bg-opacity-10 text-info rounded-pill px-4 py-2 fs-6">全库共 ${total!'0'} 条数据</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <!-- 动态排序表头 1：ID -->
                                <th class="ps-4 py-3" style="width: 15%;">
                                    <#assign nextDirId = (sortColumn == 'id' && sortDir == 'asc')?then('desc', 'asc')>
                                    <a href="/customers?page=1&sort=id&dir=${nextDirId}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center user-select-none" style="font-size: 1.1rem;">
                                        数据ID
                                        <#if sortColumn == 'id'>
                                            <i class="bi bi-sort-numeric-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                        <#else>
                                            <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                        </#if>
                                    </a>
                                </th>

                                <!-- 动态排序表头 2：名称 -->
                                <th class="py-3" style="width: 35%;">
                                    <#assign nextDirName = (sortColumn == 'name' && sortDir == 'asc')?then('desc', 'asc')>
                                    <a href="/customers?page=1&sort=name&dir=${nextDirName}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center user-select-none" style="font-size: 1.1rem;">
                                        顾客/商超名称
                                        <#if sortColumn == 'name'>
                                            <i class="bi bi-sort-alpha-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                        <#else>
                                            <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                        </#if>
                                    </a>
                                </th>

                                <!-- 动态排序表头 3：地区 -->
                                <th class="py-3" style="width: 30%;">
                                    <#assign nextDirPref = (sortColumn == 'prefecture' && sortDir == 'asc')?then('desc', 'asc')>
                                    <a href="/customers?page=1&sort=prefecture&dir=${nextDirPref}" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center user-select-none" style="font-size: 1.1rem;">
                                        所在地区
                                        <#if sortColumn == 'prefecture'>
                                            <i class="bi bi-sort-alpha-${(sortDir == 'asc')?then('down', 'down-alt')} ms-2 text-info fs-4"></i>
                                        <#else>
                                            <i class="bi bi-arrow-down-up ms-2 text-muted opacity-25 fs-5"></i>
                                        </#if>
                                    </a>
                                </th>

                                <th class="text-center pe-4 text-dark fw-bold py-3" style="font-size: 1.1rem; width: 20%;">操作管理</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list list![] as item>
                                <tr>
                                    <td class="ps-4 py-3"><span class="badge-soft fs-6 px-3 py-2">#${item.id}</span></td>
                                    <td class="py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-info bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 42px; height: 42px;">
                                                <i class="bi bi-cart3 text-info fs-5"></i>
                                            </div>
                                            <span class="fw-bold fs-5" style="color: #0f172a;">${item.name}</span>
                                        </div>
                                    </td>
                                    <td class="py-3">
                                        <span class="text-muted fw-medium fs-5"><i class="bi bi-geo-alt me-1 text-primary opacity-75"></i>${item.prefecture}${item.city}</span>
                                    </td>
                                    <td class="text-center pe-4 py-3">
                                        <div class="d-flex justify-content-center gap-3">
                                            <!-- 编辑按钮也携带当前的分页状态，防止跳转丢失位置 -->
                                            <a href="/customers/edit/${item.id}?page=${currentPage!'1'}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}" class="btn btn-outline-primary border-0 px-3 py-2" title="编辑"><i class="bi bi-pencil-square fs-4"></i></a>
                                            <form action="/customers/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('确定要永久删除此顾客吗？此操作不可恢复！');">
                                                <button type="submit" class="btn btn-outline-danger border-0 px-3 py-2" title="删除"><i class="bi bi-trash3 fs-4"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                            <#if (!list??) || (list?size == 0)>
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <div class="text-muted mb-3"><i class="bi bi-inbox opacity-50" style="font-size: 4rem;"></i></div>
                                        <div class="text-muted fw-medium fs-4">系统中尚未录入任何零售顾客信息</div>
                                    </td>
                                </tr>
                            </#if>
                            </tbody>
                        </table>
                    </div>

                    <!-- 巨型分页控件 (Pagination) -->
                    <#if totalPages?? && totalPages &gt; 1>
                        <div class="d-flex justify-content-center py-4 bg-light bg-opacity-50 border-top">
                            <nav aria-label="Page navigation">
                                <ul class="pagination pagination-lg m-0 shadow-sm">
                                    <li class="page-item <#if currentPage == 1>disabled</#if>">
                                        <a class="page-link px-4 fw-bold" href="/customers?page=${currentPage - 1}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}">
                                            <i class="bi bi-chevron-left me-1"></i> 上一页
                                        </a>
                                    </li>

                                    <#list 1..totalPages as p>
                                        <li class="page-item <#if p == currentPage>active</#if>">
                                            <a class="page-link px-4 fw-bold" href="/customers?page=${p}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}">${p}</a>
                                        </li>
                                    </#list>

                                    <li class="page-item <#if currentPage == totalPages>disabled</#if>">
                                        <a class="page-link px-4 fw-bold" href="/customers?page=${currentPage + 1}&sort=${sortColumn!'id'}&dir=${sortDir!'desc'}">
                                            下一页 <i class="bi bi-chevron-right ms-1"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </#if>

                </div>
            </div>
        </div>
    </div>
</@l.page_layout>