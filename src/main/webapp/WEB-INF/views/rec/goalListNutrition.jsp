<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalMealList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🍱 식단 목표 목록</h2>
			<p class="text-muted">당신이 설정한 마법의 식단 목표를 확인해보세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty nutritionGoalList}">
		<div class="alert alert-info text-center">아직 등록된 식단 목표가 없습니다.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/goalInputNutrition" class="btn btn-outline-primary">+목표 설정</a>
		<button class="btn btn-outline-warning" id="toggleEditModeBtn">✏️수정모드</button>
		<button class="btn btn-outline-secondary d-none" id="cancelEditModeBtn">❌수정취소</button>
	</div>

	<c:if test="${not empty nutritionGoalList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x:auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 700px;">
				<thead>
					<tr class="bg-light">
						<th>no.</th>
						<th style="min-width:120px;">목표 유형</th>
						<th style="min-width:140px;">목표 항목</th>
						<th style="min-width:160px;">목표 수치</th>
						<th style="min-width:140px;">기간</th>
						<th style="min-width:100px;">설정자</th>
						<th style="min-width:120px;">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${nutritionGoalList}" varStatus="st">
						<tr>
							<td>${st.count}</td>
							<td>
								<c:choose>
									<c:when test="${vo.goal_type == 1}">영양소</c:when>
									<c:when test="${vo.goal_type == 2}">식품</c:when>
									<c:otherwise>알 수 없음</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.goal_type == 1}">
										${vo.nutrient_name}
									</c:when>
									<c:otherwise>
										${vo.food_name}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<fmt:formatNumber value="${vo.target_value}" maxFractionDigits="2" />
								${vo.goal_unit_label}
							</td>
							<td>
								<fmt:formatDate value="${vo.start_date}" pattern="yyyy-MM-dd" /> ~
								<fmt:formatDate value="${vo.end_date}" pattern="yyyy-MM-dd" />
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.set_by == 1}">🙋‍♂️ 본인</c:when>
									<c:otherwise>🧙 전문가</c:otherwise>
								</c:choose>
							</td>
							<td>
								<a href="${ctp}/rec/goalEditNutrition?goal_id=${vo.goal_id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
								<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="confirmSingleGoalDelete(${vo.goal_id});">삭제</a>
								<input type="hidden" name="goal_id" value="${vo.goal_id}" />
								<input type="hidden" class="goalType" value="${vo.goal_type}" />
								<input type="hidden" class="itemName" value="${vo.goal_type == 1 ? vo.nutrient_name : vo.food_name}" />
								<input type="hidden" class="goalUnitCode" value="${vo.goal_unit}" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</c:if>

	<div class="mt-4 text-center">
		<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
	</div>
</main>

<script type="text/javascript">
    const ctp = "${ctp}";
    let isEditMode = false, editBtn, cancelBtn, selectAllBtn;

    /* JSTL->JS 데이터 주입 */
    const nutrientArr = [
        <c:forEach var="n" items="${nutrientList}">
            {id:${n.id},name:"${n.name}",unit:"${n.unit}",goalUnit:${n.goalUnitCode}},
        </c:forEach>];
    const foodArr = [
        <c:forEach var="f" items="${foodList}">
            {id:${f.food_id},name:"${f.name}"},
        </c:forEach>];
    const unitArr = [
        <c:forEach var="u" items="${unitList}">
            {code:${u.code},label:"${u.label}",isInt:${u.integerOnly},goalType:${u.goalType}},
        </c:forEach>];


    //단일 삭제
    function confirmSingleGoalDelete(goalId) {
        const confirmBox = document.querySelector("#wizard-delete-confirm");
        const yesBtn = document.getElementById("wizard-confirm-yes");
        const noBtn = document.getElementById("wizard-confirm-no");

        confirmBox.classList.remove("d-none");

        yesBtn.onclick = () => {
            confirmBox.classList.add("d-none");
            location.href = ctp + "/rec/goalDeleteNutrition?goal_id=" + goalId;
        };

        noBtn.onclick = () => {
            confirmBox.classList.add("d-none");
        };
    }

    // 수정모드
    document.addEventListener('DOMContentLoaded', function () {
        editBtn = document.getElementById('toggleEditModeBtn');
        cancelBtn = document.getElementById('cancelEditModeBtn');
        const table = document.querySelector('table');
        // 전체 선택 버튼 생성 및 삽입

        const toggleSelectAllBtn = document.createElement("button");
        toggleSelectAllBtn.className = "btn btn-outline-dark me-1 d-none";
        toggleSelectAllBtn.id = "toggleSelectAllBtn";
        toggleSelectAllBtn.textContent = "✔️전체선택";
        editBtn.parentNode.insertBefore(toggleSelectAllBtn, editBtn);
        selectAllBtn = toggleSelectAllBtn; // 전역변수로 연결

        if (!editBtn || !cancelBtn || !table) return;

        editBtn.addEventListener('click', function () {
            if (isEditMode) {
                toggleSelectAllBtn.classList.remove('d-none');
                return;
            }

            isEditMode = true;
            editBtn.textContent = '✅저장하기';
            cancelBtn.classList.remove('d-none');

            const rows = table.querySelectorAll('tbody tr');

            rows.forEach((row, index) => {
                const goalId = row.querySelector("input[name='goal_id']").value;
                const goalType = row.querySelector("input[class='goalType']").value;
                const itemName = row.querySelector("input[class='itemName']").value;
                const goalUnitCode = row.querySelector("input[class='goalUnitCode']").value;
                const cells = row.querySelectorAll('td');
                const [noCell, typeCell, itemCell, valueCell, dateCell, setByCell, controlCell] = cells;

                typeCell.innerHTML = "<select name='goal_type' class='form-select form-select-sm'>" +
                    "<option value='1'" + (goalType === "1" ? " selected" : "") + ">영양소</option>" +
                    "<option value='2'" + (goalType === "2" ? " selected" : "") + ">식품</option>" +
                    "</select>";

                const unitSelectWrapper = document.createElement("div");
                unitSelectWrapper.className = "input-group";

                const valueInput = document.createElement("input");
                valueInput.type = "number";
                valueInput.name = "target_value";
                valueInput.className = "form-control form-control-sm";
                valueInput.step = "0.1";
                valueInput.required = true;
                valueInput.value = parseFloat(valueCell.textContent.trim().replace(/[^\d.]/g, ''));

                const goalUnitSelect = document.createElement("select");
                goalUnitSelect.name = "goal_unit";
                goalUnitSelect.className = "form-select form-select-sm";

                unitSelectWrapper.appendChild(valueInput);
                unitSelectWrapper.appendChild(goalUnitSelect);
                valueCell.innerHTML = "";
                valueCell.appendChild(unitSelectWrapper);


                // 초기 렌더링
                renderItemCell(itemCell, goalType, itemName, goalUnitSelect);
                renderGoalUnit(goalUnitSelect, goalUnitCode, goalType);

                // goal_type 변경 시 동적 렌더링
                const goalTypeSelect = typeCell.querySelector("select[name='goal_type']");
                goalTypeSelect.addEventListener("change", function () {
                    const newType = this.value;
                    renderItemCell(itemCell, newType, "", goalUnitSelect);
                    const itemSelect = itemCell.querySelector("select");

                    if (newType === "1") {
                        // 영양소 선택 → nutrient.goalUnit 자동 적용
                        const nutrientId = parseInt(itemSelect.value);
                        const nutrient = nutrientArr.find(n => n.id === nutrientId);
                        const unitCode = nutrient ? nutrient.goalUnit : null;
                        renderGoalUnit(goalUnitSelect, unitCode, "single");

                        itemSelect.addEventListener("change", function () {
                            const nutrient = nutrientArr.find(n => n.id == parseInt(this.value));
                            renderGoalUnit(goalUnitSelect, nutrient?.goalUnit, "single");
                        });
                    } else {
                        // 식품 선택 → 식단 단위 전체 출력
                        renderGoalUnit(goalUnitSelect, null, "multi");
                    }
                });

                // 날짜 셀
                const [start, end] = dateCell.textContent.trim().split("~").map(s => s.trim());
                dateCell.innerHTML =
                    "<input type='date' name='start_date' class='form-control form-control-sm mb-1' value='" + start + "' readonly />" +
                    "<input type='date' name='end_date' class='form-control form-control-sm' value='" + end + "' required />";

                // 제어 셀
                controlCell.innerHTML =
                    "<input type='hidden' name='goal_id' value='" + goalId + "' />" +
                    "<button class='btn btn-sm btn-outline-success' onclick='submitSingleGoalEdit(this)'>개별저장</button>";

                // 변경 감지
                row.querySelectorAll("input, select").forEach(input => {
                    input.addEventListener("change", () => {
                        let changed = row.querySelector("input[name='goalList[" + index + "].changed']");
                        if (!changed) {
                            changed = document.createElement("input");
                            changed.type = "hidden";
                            changed.name = "goalList[" + index + "].changed";
                            changed.value = "true";
                            row.appendChild(changed);
                        }
                    });
                });

                row.addEventListener("click", (e) => {
                    if (e.target.closest("button") || e.target.tagName === "A") return;

                    row.classList.toggle("table-success");
                    row.dataset.selected = row.classList.contains("table-success");

                    const selectedCount = table.querySelectorAll("tbody tr.table-success").length;
                    selectAllBtn.textContent = selectedCount > 0 ? "❌선택해제" : "✔️전체선택";
                    updateGoalEditButtonLabel();
                });

            });

        });

        toggleSelectAllBtn.addEventListener("click", () => {
            const rows = document.querySelectorAll("tbody tr");
            const shouldDeselect = [...rows].some(row => row.classList.contains("table-success"));

            rows.forEach(row => {
                if (shouldDeselect) {
                    row.classList.remove("table-success");
                    row.removeAttribute("data-selected");
                } else {
                    row.classList.add("table-success");
                    row.setAttribute("data-selected", "true");
                }
            });

            toggleSelectAllBtn.textContent = shouldDeselect ? "✔️전체선택" : "❌선택해제";
            updateGoalEditButtonLabel();
        });

        cancelBtn.addEventListener('click', () => location.reload());
        toggleSelectAllBtn.classList.remove('d-none');

    });

    //목표 항목 변경 시 단위 자동 업데이트
    function bindAutoUnitOnNutrientChange(nutrientSelect, unitSelect) {
        nutrientSelect.addEventListener("change", function () {
            const selectedId = parseInt(this.value);
            const nutrient = nutrientArr.find(n => n.id === selectedId);
            const unitCode = nutrient ? nutrient.goalUnit : null;
            const unitMeta = unitArr.find(u => u.code === unitCode);

            unitSelect.innerHTML = ""; // 초기화
            if (unitMeta) {
                const opt = document.createElement("option");
                opt.value = unitMeta.code;
                opt.textContent = unitMeta.label;
                opt.selected = true;
                unitSelect.appendChild(opt);
            }
        });
    }

    // 버튼 상태 업데이트 함수
    function updateGoalEditButtonLabel() {
        const rows = document.querySelectorAll("tbody tr");
        let selected = 0, changed = 0;

        rows.forEach(row => {
            if (row.classList.contains("table-success")) selected++;
            if (row.querySelector("input[name*='.changed']")) changed++;
        });

        if (editBtn) {
            if (changed > 0) {
                editBtn.textContent = "✅적용하기";
            } else if (selected > 0) {
                editBtn.textContent = "🗑️선택삭제";
            } else {
                editBtn.textContent = "✅적용하기";
            }
        }
        if (selectAllBtn) {
            selectAllBtn.textContent = selected > 0 ? "❌선택해제" : "✔️전체선택";
        }
    }

    // 목표 단위 렌더링
    function renderGoalUnit(selectEl, codeOrNull, mode) {
        selectEl.innerHTML = "";
        if (mode === "single") {
            const unitMeta = unitArr.find(u => u.code == codeOrNull);
            if (unitMeta) {
                const opt = document.createElement("option");
                opt.value = u.code;
                opt.textContent = u.label;
                opt.selected = true;
                selectEl.appendChild(opt);
            }
        } else {
            unitArr.filter(u => u.goalType == 2).forEach(u => {
                const opt = document.createElement("option");
                opt.value = u.code;
                opt.textContent = u.label;
                if (u.code == codeOrNull) opt.selected = true;
                selectEl.appendChild(opt);
            });
        }
    }

    // 목표 항목 렌더링
    function renderItemCell(cell, goalTypeVal, selectedName, unitSelect) {
        const select = document.createElement("select");
        select.name = goalTypeVal === "1" ? "nutrient_id" : "food_id";
        select.className = "form-select form-select-sm";

        const arr = goalTypeVal === "1" ? nutrientArr : foodArr;
        arr.forEach(obj => {
            const opt = document.createElement("option");
            opt.value = obj.id;
            opt.textContent = obj.name;
            if (obj.name === selectedName) opt.selected = true;
            select.appendChild(opt);
        });
        cell.innerHTML = "";
        cell.appendChild(select);

        // goalType이 영양소인 경우: 단위 자동 지정
        if (goalTypeVal === "1" && unitSelect) {
            function setUnitByNutrientId(nutrientId) {
                const nutrient = nutrientArr.find(n => n.id === parseInt(nutrientId));
                const unitCode = nutrient ? nutrient.goalUnit : null;
                const unitMeta = unitArr.find(u => u.code === unitCode);
                unitSelect.innerHTML = "";
                if (unitMeta) {
                    const opt = document.createElement("option");
                    opt.value = unitMeta.code;
                    opt.textContent = unitMeta.label;
                    opt.selected = true;
                    unitSelect.appendChild(opt);
                }
            }
            setUnitByNutrientId(select.value); // 초기 렌더링

            select.addEventListener("change", function () {
                setUnitByNutrientId(this.value);
            });
        }
    }

    // 개별 저장(수정 모드 - 단일 수정)
    function submitSingleGoalEdit(button) {
        const row = button.closest("tr");
        if (!validateFormOnSubmit(row)) return;

        const form = document.createElement("form");
        form.method = "POST";
        form.action = ctp + "/rec/goalUpdateNutrition";

        const names = [
            "goal_id", "goal_type", "target_value", "goal_unit",
            "start_date", "end_date", "nutrient_id", "food_id"
        ];

        names.forEach(name => {
            const el = row.querySelector("[name='" + name + "']");
            if (el) {
                const hidden = document.createElement("input");
                hidden.type = "hidden";
                hidden.name = name;
                hidden.value = el.value;
                form.appendChild(hidden);
            }
        });

        document.body.appendChild(form);
        form.submit();
    }

</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
