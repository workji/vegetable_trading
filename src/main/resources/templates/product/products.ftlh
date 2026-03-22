<#import "/layout.ftlh" as l>
<@l.page_layout title="蔬菜品目管理 (商品库)" current_page="products">

    <div class="row g-4">
        <!-- 左侧表单区 -->
        <div class="col-lg-4">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <div class="bg-primary bg-opacity-10 text-primary rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                        <i class="bi bi-tag-fill fs-5"></i>
                    </div>
                    <h6 class="m-0 fw-bold"><#if productForm.id??>编辑蔬菜品目<#else>新增蔬菜品目</#if></h6>
                </div>
                <div class="card-body p-4">
                    <form action="<#if productForm.id??>/products/edit/${productForm.id}<#else>/products/add</#if>" method="post">
                        <#if productForm.id??><input type="hidden" name="id" value="${productForm.id}"></#if>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">蔬菜种类 (大类) <span class="text-danger">*</span></label>
                            <@spring.bind "productForm.name" />
                            <div class="input-group input-group-sm-focus shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-box-seam"></i></span>
                                <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="如：番茄、白菜">
                            </div>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">细分品种 (品牌)</label>
                            <@spring.bind "productForm.variety" />
                            <div class="input-group shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-stars"></i></span>
                                <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0" placeholder="如：桃太郎 (可留空)">
                            </div>
                        </div>

                        <div class="mb-4 pb-2">
                            <label class="form-label small text-muted fw-bold mb-2">基本计量单位 <span class="text-danger">*</span></label>
                            <@spring.bind "productForm.standardUnit" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 请选择基准单位 --</option>
                                <option value="箱" <#if (spring.status.value!'') == '箱'>selected</#if>>📦 箱 (ケース)</option>
                                <option value="kg" <#if (spring.status.value!'') == 'kg'>selected</#if>>⚖️ 公斤 (kg)</option>
                                <option value="把" <#if (spring.status.value!'') == '把'>selected</#if>>🥬 把 (束)</option>
                                <option value="个" <#if (spring.status.value!'') == '个'>selected</#if>>🍅 个 (個)</option>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <button type="submit" class="btn-gradient w-100"><i class="bi bi-cloud-arrow-up me-2"></i><#if productForm.id??>保存修改并更新<#else>保存至数据库</#if></button>
                        <#if productForm.id??>
                            <a href="/products" class="btn btn-light border w-100 mt-2 fw-bold text-muted shadow-sm">取消编辑，返回新增模式</a>
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
                        <h6 class="m-0 fw-bold">已注册品目数据字典</h6>
                    </div>
                    <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-2">共 ${list?size} 条数据</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">数据ID</th>
                                <th>品目核心名称</th>
                                <th>细分品种特征</th>
                                <th class="text-center">系统基准单位</th>
                                <th class="text-center pe-4">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list list![] as item>
                                <tr>
                                    <td class="ps-4"><span class="badge-soft">#${item.id}</span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-secondary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 32px; height: 32px;">
                                                <i class="bi bi-box text-secondary"></i>
                                            </div>
                                            <span class="fw-bold" style="color: #0f172a;">${item.name}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <#if item.variety?has_content>
                                            <span class="text-primary fw-semibold"><i class="bi bi-hash me-1"></i>${item.variety}</span>
                                        <#else>
                                            <span class="text-muted opacity-50"><i class="bi bi-dash"></i> 无变种</span>
                                        </#if>
                                    </td>
                                    <td class="text-center">
                                    <span class="badge bg-dark bg-opacity-10 text-dark rounded px-2 py-1 border border-secondary border-opacity-25">
                                        ${item.standardUnit}
                                    </span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="/products/edit/${item.id}" class="btn btn-sm btn-outline-primary border-0" title="编辑"><i class="bi bi-pencil-square fs-6"></i></a>
                                            <form action="/products/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('确定要删除此品目吗？\n警告：若已有入库记录引用此品目，强制删除可能会导致历史流水报错！');">
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
                                        <div class="text-muted fw-medium">系统中尚未录入任何品目数据</div>
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