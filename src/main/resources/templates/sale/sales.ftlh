<#import "/layout.ftlh" as l>
<@l.page_layout title="销售出库管理 (发货登记)" current_page="sales">

    <#if businessError??>
        <div class="alert alert-danger shadow-sm border-0 rounded-3 mb-4 d-flex align-items-center" role="alert">
            <div class="bg-danger bg-opacity-10 text-danger rounded-circle p-2 me-3">
                <i class="bi bi-exclamation-octagon-fill fs-4"></i>
            </div>
            <div>
                <h6 class="alert-heading fw-bold mb-1">发货操作被拒绝</h6>
                <div class="small opacity-75">${businessError}</div>
            </div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </#if>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card border-top border-warning border-3">
                <div class="card-header d-flex align-items-center">
                    <div class="bg-warning bg-opacity-10 text-warning rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                        <i class="bi bi-send-check-fill fs-5"></i>
                    </div>
                    <h6 class="m-0 fw-bold"><#if saleForm.id??>编辑销售出库单<#else>录入销售出库单</#if></h6>
                </div>
                <div class="card-body p-4">
                    <form action="<#if saleForm.id??>/sales/edit/${saleForm.id}<#else>/sales</#if>" method="post">
                        <#if saleForm.id??><input type="hidden" name="id" value="${saleForm.id}"></#if>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">出库(发货)日期 <span class="text-danger">*</span></label>
                            <@spring.bind "saleForm.saleDate" />
                            <#assign dateValue = spring.status.value!((.now)?string('yyyy-MM-dd'))>
                            <div class="input-group input-group-sm-focus shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-calendar-event"></i></span>
                                <input type="date" name="${spring.status.expression}" value="${dateValue}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>">
                            </div>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">销售对象 (顾客) <span class="text-danger">*</span></label>
                            <@spring.bind "saleForm.customerId" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 请选择接收超市 --</option>
                                <#if customers??>
                                    <#list customers as c>
                                        <option value="${c.id}" <#if (spring.status.value!'') == c.id?string>selected</#if>>🏪 ${c.name} (${c.city})</option>
                                    </#list>
                                </#if>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">出库品目 <span class="text-danger">*</span></label>
                            <@spring.bind "saleForm.productId" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 请选择要发货的商品 --</option>
                                <#if products??>
                                    <#list products as p>
                                        <option value="${p.id}" <#if (spring.status.value!'') == p.id?string>selected</#if>>🥦 ${p.name}</option>
                                    </#list>
                                </#if>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4 bg-warning bg-opacity-10 p-3 rounded-3 border border-warning border-opacity-25">
                            <label class="form-label small text-dark fw-bold mb-2"><i class="bi bi-link-45deg me-1"></i>绑定扣减入库批次 <span class="text-danger">*</span></label>
                            <@spring.bind "saleForm.arrivalId" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 指定货物来源批次 --</option>
                                <#if arrivals??>
                                    <#list arrivals as arr>
                                        <option value="${arr.id}" <#if (spring.status.value!'') == arr.id?string>selected</#if>>
                                            [批次 ${arr.id}] ${arr.productName} (原库存: ${arr.quantity}${arr.unit})
                                        </option>
                                    </#list>
                                </#if>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            <div class="form-text text-dark opacity-75 mt-2" style="font-size:0.75rem;"><i class="bi bi-info-circle me-1"></i>发货量严格校验，不可超过原批次库存上限。</div>
                        </div>

                        <div class="row mb-4 pb-2">
                            <div class="col-6">
                                <label class="form-label small text-muted fw-bold mb-2">发货数量 <span class="text-danger">*</span></label>
                                <@spring.bind "saleForm.quantity" />
                                <div class="input-group input-group-sm-focus shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-box-arrow-up-right"></i></span>
                                    <input type="number" step="0.01" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="0.00">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                            <div class="col-6">
                                <label class="form-label small text-muted fw-bold mb-2">销售单价(¥) <span class="text-danger">*</span></label>
                                <@spring.bind "saleForm.unitPrice" />
                                <div class="input-group input-group-sm-focus shadow-sm">
                                    <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-tags"></i></span>
                                    <input type="number" step="0.01" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>" placeholder="0.00">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>
                        </div>

                        <button type="submit" class="btn w-100 fw-bold text-white shadow-sm" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); letter-spacing: 0.5px;">
                            <i class="bi bi-box-seam me-2"></i><#if saleForm.id??>强制覆盖修改<#else>核准发货出库</#if>
                        </button>
                        <#if saleForm.id??>
                            <a href="/sales" class="btn btn-light border w-100 mt-2 fw-bold text-muted shadow-sm">取消编辑，返回新增模式</a>
                        </#if>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center py-3">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-receipt-cutoff text-muted me-2 fs-5"></i>
                        <h6 class="m-0 fw-bold">历史销售出库明细</h6>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">出库单号</th>
                                <th>出库日期</th>
                                <th>接收商超</th>
                                <th>商品</th>
                                <th class="text-end">发货量</th>
                                <th class="text-end">单价</th>
                                <th class="text-end">销售额</th>
                                <th class="text-center">溯源批次</th>
                                <th class="text-center pe-4">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list list![] as item>
                                <tr>
                                    <td class="ps-4"><span class="badge-soft text-warning font-monospace">SAL-${item.id}</span></td>
                                    <td class="text-muted fw-medium">${item.saleDate}</td>
                                    <td class="fw-bold" style="color: #0f172a;">${item.customerName}</td>
                                    <td class="text-primary fw-semibold">${item.productName}</td>
                                    <td class="text-end fw-bold">${item.quantity}</td>
                                    <td class="text-end text-muted">¥${item.unitPrice}</td>
                                    <td class="text-end fw-bold text-success">¥${item.totalPrice}</td>
                                    <td class="text-center">
                                        <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">ARR-${item.arrivalId}</span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="/sales/edit/${item.id}" class="btn btn-sm btn-outline-primary border-0" title="编辑"><i class="bi bi-pencil-square fs-6"></i></a>
                                            <form action="/sales/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('确定要作废(删除)这条出库单吗？');">
                                                <button type="submit" class="btn btn-sm btn-outline-danger border-0" title="删除"><i class="bi bi-trash3 fs-6"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                            <#if (!list??) || (list?size == 0)>
                                <tr>
                                    <td colspan="9" class="text-center py-5">
                                        <div class="text-muted mb-2"><i class="bi bi-inbox fs-1 opacity-50"></i></div>
                                        <div class="text-muted fw-medium">暂无任何销售出库记录</div>
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