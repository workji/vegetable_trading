<#import "/layout.ftlh" as l>
<@l.page_layout title="供货农家管理 (系统录入)" current_page="farmers">

    <!-- 居中显示的独立大表单区 -->
    <div class="row justify-content-center mt-3">
        <div class="col-lg-10 col-xl-8">
            <div class="card border-0 shadow-lg">
                <div class="card-header bg-white d-flex align-items-center py-4 border-bottom-0">
                    <div class="bg-success bg-opacity-10 text-success rounded-circle p-3 me-4 d-flex align-items-center justify-content-center" style="width: 64px; height: 64px;">
                        <i class="bi bi-person-plus-fill fs-2"></i>
                    </div>
                    <div>
                        <h4 class="m-0 fw-bold text-dark"><#if farmerForm.id??>编辑/更新农家档案<#else>建立新农家档案</#if></h4>
                        <p class="text-muted small m-0 mt-1">请核对实名认证与地理位置信息后进行保存</p>
                    </div>
                </div>

                <div class="card-body p-5 pt-2">
                    <form action="<#if farmerForm.id??>/farmers/edit/${farmerForm.id}<#else>/farmers/add</#if>" method="post">

                        <#if farmerForm.id??>
                            <input type="hidden" name="id" value="${farmerForm.id}">
                            <!-- 核心防丢失机制：隐藏域穿透，携带一览画面的所有检索与分页条件 -->
                            <input type="hidden" name="page" value="${page!'1'}">
                            <input type="hidden" name="sort" value="${sort!'id'}">
                            <input type="hidden" name="dir" value="${dir!'desc'}">
                            <input type="hidden" name="searchName" value="${searchName!''}">
                            <input type="hidden" name="searchRank" value="${searchRank!''}">
                        </#if>

                        <div class="row g-4">
                            <!-- 第一列：名称 -->
                            <div class="col-md-6">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">农家名 / 注册屋号 <span class="text-danger">*</span></label>
                                <@spring.bind "farmerForm.name" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-shop fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0 <#if spring.status.error>is-invalid border-danger</#if>" placeholder="营业执照上的名称">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2 fw-semibold"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>

                            <!-- 第二列：评级 -->
                            <div class="col-md-6">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">内部信任评级 <span class="text-danger">*</span></label>
                                <@spring.bind "farmerForm.rank" />
                                <select name="${spring.status.expression}" class="form-select form-select-lg shadow-sm <#if spring.status.error>is-invalid border-danger</#if>">
                                    <option value="A" <#if (spring.status.value!'') == 'A'>selected</#if>>🌟 A级 (核心货源，长期稳定)</option>
                                    <option value="B" <#if (spring.status.value!'') == 'B'>selected</#if>>⭐ B级 (标准供货商)</option>
                                    <option value="C" <#if (spring.status.value!'') == 'C'>selected</#if>>⚠️ C级 (高风险，临时调货)</option>
                                </select>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2 fw-semibold"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>

                            <!-- 第三列：都道府县 -->
                            <div class="col-md-6">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">都道府县 <span class="text-danger">*</span></label>
                                <@spring.bind "farmerForm.prefecture" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-map fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0 <#if spring.status.error>is-invalid border-danger</#if>" placeholder="如：東京都">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2 fw-semibold"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>

                            <!-- 第四列：市区町村 -->
                            <div class="col-md-6">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">市区町村 <span class="text-danger">*</span></label>
                                <@spring.bind "farmerForm.city" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-pin-map fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0 <#if spring.status.error>is-invalid border-danger</#if>" placeholder="如：葛飾区">
                                </div>
                                <#list spring.status.errorMessages as error><div class="text-danger fs-6 mt-2 fw-semibold"><i class="bi bi-exclamation-circle me-1"></i>${error}</div></#list>
                            </div>

                            <!-- 第五列：全宽详细地址 -->
                            <div class="col-12">
                                <label class="form-label text-dark fw-bold mb-2 fs-5">详细地址 (番地・圃场)</label>
                                <@spring.bind "farmerForm.addressLine" />
                                <div class="input-group input-group-lg shadow-sm">
                                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-signpost-split fs-4"></i></span>
                                    <input type="text" name="${spring.status.expression}" value="${spring.status.value!''}" class="form-control form-control-lg border-start-0 ps-0" placeholder="具体的街道与门牌号 (选填)">
                                </div>
                            </div>
                        </div>

                        <!-- 底部超大操作按钮 -->
                        <div class="mt-5 pt-3 border-top d-flex gap-3">
                            <button type="submit" class="btn-gradient btn-lg py-3 fs-4 fw-bold shadow flex-grow-1">
                                <i class="bi bi-cloud-arrow-up me-2"></i><#if farmerForm.id??>核准并更新系统数据<#else>确认录入系统数据库</#if>
                            </button>

                            <#assign backUrl = "/farmers">
                            <#if farmerForm.id??>
                                <#assign backUrl = "/farmers?page=${page!'1'}&sort=${sort!'id'}&dir=${dir!'desc'}&searchName=${searchName!''}&searchRank=${searchRank!''}">
                            </#if>
                            <a href="${backUrl}" class="btn btn-light border btn-lg py-3 fs-4 fw-bold text-secondary shadow-sm px-5">
                                <i class="bi bi-x-lg me-2"></i>放弃
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</@l.page_layout>