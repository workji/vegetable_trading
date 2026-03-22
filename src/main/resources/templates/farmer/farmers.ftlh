<#import "/layout.ftlh" as l>
<@l.page_layout title="农家管理 (供货商名册)" current_page="farmers">

    <div class="row g-4">
        <!-- 左侧表单区 -->
        <div class="col-lg-4">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <div class="bg-success bg-opacity-10 text-success rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                        <i class="bi bi-person-bounding-box fs-5"></i>
                    </div>
                    <h6 class="m-0 fw-bold"><#if farmerForm.id??>编辑供货农家<#else>新增供货农家</#if></h6>
                </div>
                <div class="card-body p-4">
                    <form action="<#if farmerForm.id??>/farmers/edit/${farmerForm.id}<#else>/farmers</#if>" method="post">
                        <#if farmerForm.id??><input type="hidden" name="id" value="${farmerForm.id}"></#if>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">农家名・屋号 <span class="text-danger">*</span></label>
                            <@spring.bind "farmerForm.name" />
                            <div class="input-group input-group-sm-focus shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-shop"></i></span>
                                <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="例：田中农园">
                            </div>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="row mb-4">
                            <div class="col-6">
                                <label class="form-label small text-muted fw-bold mb-2">都道府县 <span class="text-danger">*</span></label>
                                <@spring.bind "farmerForm.prefecture" />
                                <div class="input-group input-group-sm-focus shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-map"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="東京都">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                            <div class="col-6">
                                <label class="form-label small text-muted fw-bold mb-2">市区町村 <span class="text-danger">*</span></label>
                                <@spring.bind "farmerForm.city" />
                                <div class="input-group input-group-sm-focus shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-pin-map"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="葛飾区">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">详细地址 (番地・圃场)</label>
                            <@spring.bind "farmerForm.addressLine" />
                            <div class="input-group shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-signpost-split"></i></span>
                                <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0" placeholder="详细地址可留空">
                            </div>
                        </div>

                        <div class="mb-4 pb-2">
                            <label class="form-label small text-muted fw-bold mb-2">信任评级 <span class="text-danger">*</span></label>
                            <@spring.bind "farmerForm.rank" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="A" <#if (spring.status.value!'') == 'A'>selected</#if>>🌟 A级 (长期稳定合作)</option>
                                <option value="B" <#if (spring.status.value!'') == 'B'>selected</#if>>⭐ B级 (普通标准合作)</option>
                                <option value="C" <#if (spring.status.value!'') == 'C'>selected</#if>>⚠️ C级 (临时散单合作)</option>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <button type="submit" class="btn-gradient w-100"><i class="bi bi-cloud-arrow-up me-2"></i><#if farmerForm.id??>保存修改并更新<#else>保存至数据库</#if></button>
                        <#if farmerForm.id??>
                            <a href="/farmers" class="btn btn-light border w-100 mt-2 fw-bold text-muted shadow-sm">取消编辑，返回新增模式</a>
                        </#if>
                    </form>
                </div>
            </div>
        </div>

        <!-- 右侧数据列表区 -->
        <div class="col-lg-8">
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-database text-muted me-2 fs-5"></i>
                        <h6 class="m-0 fw-bold">已注册农家名册</h6>
                    </div>
                    <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2">共 ${list?size} 条数据</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">数据ID</th>
                                <th>农家名称</th>
                                <th>地理位置</th>
                                <th class="text-center">系统评级</th>
                                <th class="text-center pe-4">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list list![] as item>
                                <tr>
                                    <td class="ps-4"><span class="badge-soft">#${item.id}</span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 32px; height: 32px;">
                                                <i class="bi bi-person text-success"></i>
                                            </div>
                                            <span class="fw-bold" style="color: #0f172a;">${item.name}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-muted fw-medium"><i class="bi bi-geo-alt me-1 text-primary opacity-75"></i>${item.prefecture}${item.city}</span>
                                    </td>
                                    <td class="text-center">
                                        <#if item.rank == 'A'>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-1">A 级</span>
                                        <#elseif item.rank == 'B'>
                                            <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-3 py-1">B 级</span>
                                        <#else>
                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-3 py-1">C 级</span>
                                        </#if>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="/farmers/edit/${item.id}" class="btn btn-sm btn-outline-primary border-0" title="编辑"><i class="bi bi-pencil-square fs-6"></i></a>
                                            <form action="/farmers/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('确定要删除此农家吗？\n如果已存在相关的入库记录，物理删除可能导致关联错误。');">
                                                <button type="submit" class="btn btn-sm btn-outline-danger border-0" title="删除"><i class="bi bi-trash3 fs-6"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                            <#if (!list??) || (list?size == 0)>
                                <tr>
                                    <td colspan="5" class="text-center py-5">
                                        <div class="text-muted mb-2"><i class="bi bi-inbox fs-1 opacity-50"></i></div>
                                        <div class="text-muted fw-medium">系统中尚未录入任何农家信息</div>
                                    </td>
                                </tr>
                            </#if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@l.page_layout>