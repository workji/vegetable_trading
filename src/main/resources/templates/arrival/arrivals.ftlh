<#import "/layout.ftlh" as l>
<@l.page_layout title="入库明细管理 (采购登记)" current_page="arrivals">

    <#if businessError??>
        <div class="alert alert-danger shadow-sm border-0 rounded-3 mb-4 d-flex align-items-center" role="alert">
            <div class="bg-danger bg-opacity-10 text-danger rounded-circle p-2 me-3">
                <i class="bi bi-shield-lock fs-4"></i>
            </div>
            <div>
                <h6 class="alert-heading fw-bold mb-1">安全风控拦截</h6>
                <div class="small opacity-75">${businessError}</div>
            </div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </#if>

    <div class="row g-4">
        <!-- 左侧表单区 -->
        <div class="col-lg-4">
            <div class="card border-top border-primary border-3">
                <div class="card-header d-flex align-items-center">
                    <div class="bg-primary bg-opacity-10 text-primary rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                        <i class="bi bi-box-arrow-in-right fs-5"></i>
                    </div>
                    <h6 class="m-0 fw-bold"><#if arrivalForm.id??>编辑采购入库单<#else>录入采购入库单</#if></h6>
                </div>
                <div class="card-body p-4">
                    <form action="<#if arrivalForm.id??>/arrivals/edit/${arrivalForm.id}<#else>/arrivals</#if>" method="post">
                        <#if arrivalForm.id??><input type="hidden" name="id" value="${arrivalForm.id}"></#if>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">入库日期 <span class="text-danger">*</span></label>
                            <@spring.bind "arrivalForm.arrivalDate" />
                            <#assign dateValue = spring.status.value!((.now)?string('yyyy-MM-dd'))>
                            <div class="input-group input-group-sm-focus shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-calendar-check"></i></span>
                                <input type="date" name="${spring.status.expression}" value="${dateValue}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>">
                            </div>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">供货农家 <span class="text-danger">*</span></label>
                            <@spring.bind "arrivalForm.farmerId" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 请选择供货来源 --</option>
                                <#if farmers??>
                                    <#list farmers as f>
                                        <option value="${f.id}" <#if (spring.status.value!'') == f.id?string>selected</#if>>🚜 ${f.name} (${f.prefecture})</option>
                                    </#list>
                                </#if>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">蔬菜品目 <span class="text-danger">*</span></label>
                            <@spring.bind "arrivalForm.productId" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 请选择入库商品 --</option>
                                <#if products??>
                                    <#list products as p>
                                        <option value="${p.id}" <#if (spring.status.value!'') == p.id?string>selected</#if>>🥦 ${p.name} <#if p.variety??>(${p.variety})</#if> [${p.standardUnit}]</option>
                                    </#list>
                                </#if>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="row mb-4 pb-2">
                            <div class="col-6">
                                <label class="form-label small text-muted fw-bold mb-2">入库数量 <span class="text-danger">*</span></label>
                                <@spring.bind "arrivalForm.quantity" />
                                <div class="input-group input-group-sm-focus shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-layers"></i></span>
                                    <input type="number" step="0.01" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="0.00">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                            <div class="col-6">
                                <label class="form-label small text-muted fw-bold mb-2">进货单价(¥) <span class="text-danger">*</span></label>
                                <@spring.bind "arrivalForm.unitPrice" />
                                <div class="input-group input-group-sm-focus shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-currency-yen"></i></span>
                                    <input type="number" step="0.01" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="0.00">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                        </div>

                        <button type="submit" class="btn-gradient w-100"><i class="bi bi-check2-circle me-2"></i><#if arrivalForm.id??>确认保存修改<#else>确认写入入库流水</#if></button>
                        <#if arrivalForm.id??>
                            <a href="/arrivals" class="btn btn-light border w-100 mt-2 fw-bold text-muted shadow-sm">取消编辑，返回新增模式</a>
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
                        <i class="bi bi-clock-history text-muted me-2 fs-5"></i>
                        <h6 class="m-0 fw-bold">历史入库明细流水</h6>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">流水号</th>
                                <th>入库日期</th>
                                <th>农家(来源)</th>
                                <th>商品品目</th>
                                <th class="text-end">数量</th>
                                <th class="text-end">单价</th>
                                <th class="text-end">总金额</th>
                                <th class="text-center pe-4">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list list![] as item>
                                <tr>
                                    <td class="ps-4"><span class="badge-soft text-primary font-monospace">ARR-${item.id}</span></td>
                                    <td class="text-muted fw-medium">${item.arrivalDate}</td>
                                    <td><span class="badge bg-dark bg-opacity-10 text-dark border border-secondary border-opacity-25 px-2 py-1">${item.farmerName}</span></td>
                                    <td class="fw-bold" style="color: #0f172a;">${item.productName}</td>
                                    <td class="text-end fw-bold">${item.quantity} <span class="text-muted small fw-normal">${item.unit}</span></td>
                                    <td class="text-end text-muted">¥${item.unitPrice}</td>
                                    <td class="text-end fw-bold text-danger">¥${item.totalPrice}</td>
                                    <td class="text-center pe-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="/arrivals/edit/${item.id}" class="btn btn-sm btn-outline-primary border-0" title="编辑"><i class="bi bi-pencil-square fs-6"></i></a>
                                            <form action="/arrivals/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('⚠️ 警告：删除入库流水可能会导致出库溯源失败！确定要强行删除吗？');">
                                                <button type="submit" class="btn btn-sm btn-outline-danger border-0" title="删除"><i class="bi bi-trash3 fs-6"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                            <#if (!list??) || (list?size == 0)>
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <div class="text-muted mb-2"><i class="bi bi-inbox fs-1 opacity-50"></i></div>
                                        <div class="text-muted fw-medium">目前没有任何采购入库记录</div>
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