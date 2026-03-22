<#import "/layout.ftlh" as l>
<@l.page_layout title="供需趋势预测面板" current_page="forecasts">

    <div class="row g-4">
        <!-- 左侧表单区 -->
        <div class="col-lg-4">
            <div class="card border-top border-info border-3">
                <div class="card-header d-flex align-items-center">
                    <div class="bg-info bg-opacity-10 text-info rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                        <i class="bi bi-magic fs-5"></i>
                    </div>
                    <h6 class="m-0 fw-bold"><#if forecastForm.id??>编辑预测数据<#else>录入市场预测(勘)</#if></h6>
                </div>
                <div class="card-body p-4">
                    <form action="<#if forecastForm.id??>/forecasts/edit/${forecastForm.id}<#else>/forecasts</#if>" method="post">
                        <#if forecastForm.id??><input type="hidden" name="id" value="${forecastForm.id}"></#if>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">预测目标日期 <span class="text-danger">*</span></label>
                            <@spring.bind "forecastForm.targetDate" />
                            <div class="input-group input-group-sm-focus shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-calendar-range"></i></span>
                                <input type="date" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0 <#if spring.status.error>is-invalid</#if>">
                            </div>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">预测维度 <span class="text-danger">*</span></label>
                            <@spring.bind "forecastForm.type" />
                            <div class="d-flex gap-4 mt-1 bg-light p-2 rounded-3 border border-secondary border-opacity-10">
                                <div class="form-check form-check-inline m-0">
                                    <input class="form-check-input shadow-sm" type="radio" name="${spring.status.expression}" id="typeSupply" value="SUPPLY" <#if (spring.status.value!'') == 'SUPPLY'>checked</#if>>
                                    <label class="form-check-label fw-semibold text-success" for="typeSupply"><i class="bi bi-graph-down-arrow me-1"></i>农家供货</label>
                                </div>
                                <div class="form-check form-check-inline m-0">
                                    <input class="form-check-input shadow-sm" type="radio" name="${spring.status.expression}" id="typeDemand" value="DEMAND" <#if (spring.status.value!'') == 'DEMAND'>checked</#if>>
                                    <label class="form-check-label fw-semibold text-warning" for="typeDemand"><i class="bi bi-graph-up-arrow me-1"></i>市场需求</label>
                                </div>
                            </div>
                            <#if spring.status.error>
                                <div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>必须选择一个维度</div>
                            </#if>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">被预测品目 <span class="text-danger">*</span></label>
                            <@spring.bind "forecastForm.productId" />
                            <select name="${spring.status.expression}" class="form-select shadow-sm <#if spring.status.error>is-invalid</#if>">
                                <option value="">-- 请选择要预测的蔬菜 --</option>
                                <#if products??>
                                    <#list products as p>
                                        <option value="${p.id}" <#if (spring.status.value!'') == p.id?string>selected</#if>>${p.name}</option>
                                    </#list>
                                </#if>
                            </select>
                            <#list spring.status.errorMessages as error><div class="text-danger small mt-1"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small text-muted fw-bold mb-2">人工评估数量(微调)</label>
                            <@spring.bind "forecastForm.manualQty" />
                            <div class="input-group input-group-sm-focus shadow-sm">
                                <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-sliders"></i></span>
                                <input type="number" step="0.01" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control border-start-0 ps-0" placeholder="凭借经验估算的最终值">
                            </div>
                        </div>

                        <div class="mb-4 pb-2">
                            <label class="form-label small text-muted fw-bold mb-2">研判依据 / 备注说明</label>
                            <@spring.bind "forecastForm.note" />
                            <textarea name="${spring.status.expression}" class="form-control shadow-sm" rows="3" placeholder="例：台风预警，预计白菜减产50%">${spring.status.value!''}</textarea>
                        </div>

                        <button type="submit" class="btn-gradient w-100"><i class="bi bi-cloud-arrow-up me-2"></i><#if forecastForm.id??>保存修改并更新<#else>保存预测模型</#if></button>
                        <#if forecastForm.id??>
                            <a href="/forecasts" class="btn btn-light border w-100 mt-2 fw-bold text-muted shadow-sm">取消编辑，返回新增模式</a>
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
                        <i class="bi bi-bar-chart-steps text-muted me-2 fs-5"></i>
                        <h6 class="m-0 fw-bold">全盘预测数据记录</h6>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-4">目标日期</th>
                                <th>维度</th>
                                <th>品目</th>
                                <th class="text-end">系统预测值</th>
                                <th class="text-end">人工核定值</th>
                                <th>研判依据</th>
                                <th class="text-center pe-4">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list list![] as item>
                                <tr>
                                    <td class="ps-4 fw-bold" style="color: #0f172a;">${item.targetDate}</td>
                                    <td>
                                        <#if item.type == 'SUPPLY'>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1"><i class="bi bi-arrow-down-short me-1"></i>预计供货</span>
                                        <#else>
                                            <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-2 py-1"><i class="bi bi-arrow-up-short me-1"></i>预计需求</span>
                                        </#if>
                                    </td>
                                    <td class="fw-bold text-primary">${item.productName}</td>
                                    <td class="text-end text-muted">${(item.estimatedQty!'<span class="small opacity-50">-</span>')?no_esc}</td>
                                    <td class="text-end fw-bold fs-6">${(item.manualQty!'<span class="small text-muted opacity-50">-</span>')?no_esc}</td>
                                    <td class="text-muted small">
                                        <div class="text-truncate" style="max-width: 150px;" title="${item.note!''}">${item.note!'-'}</div>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="/forecasts/edit/${item.id}" class="btn btn-sm btn-outline-primary border-0" title="编辑该项"><i class="bi bi-pencil-square fs-6"></i></a>
                                            <form action="/forecasts/delete/${item.id}" method="post" class="m-0" onsubmit="return confirm('确定要永久删除这条预测记录吗？此操作无法撤销。');">
                                                <button type="submit" class="btn btn-sm btn-outline-danger border-0" title="删除该项"><i class="bi bi-trash3 fs-6"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                            <#if (!list??) || (list?size == 0)>
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <div class="text-muted mb-2"><i class="bi bi-inbox fs-1 opacity-50"></i></div>
                                        <div class="text-muted fw-medium">目前尚未建立任何预测数据</div>
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